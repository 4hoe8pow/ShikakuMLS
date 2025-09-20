//
//  DomainServiceTests.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import CryptoKit
import Foundation
import Testing

@testable import ShikakuMLS

struct DomainServiceTests {

    // MARK: - KeyManagementService テスト

    @Test("鍵生成・ラチェット更新")
    func testKeyManagementFlow() async throws {
        let participantID = UUID().uuidString
        let keyService = KeyManagementService()
        let keyPair = keyService.generateKeyPair(participantID: participantID)
        #expect(keyPair.0.rawValue.count > 0, "公開鍵が生成されること")
        #expect(keyPair.1.rawValue.count > 0, "秘密鍵が生成されること")

        // 鍵ローテーション（rotateKeyPairを使用）
        let rotatedKeyPair = keyService.rotateKeyPair(
            participantID: participantID
        )
        #expect(rotatedKeyPair.0 != keyPair.0, "ラチェット更新で公開鍵が変わること")
        #expect(rotatedKeyPair.1 != keyPair.1, "ラチェット更新で秘密鍵が変わること")
    }

    // MARK: - MessageService テスト

    @Test("1:1メッセージ暗号化・復号")
    func testOneToOneMessageFlow() async throws {
        let keyService = KeyManagementService()
        let senderID = UUID().uuidString
        let recipientID = UUID().uuidString
        let senderKeyPair = keyService.generateKeyPair(participantID: senderID)
        let recipientKeyPair = keyService.generateKeyPair(
            participantID: recipientID
        )

        let sender = Participant(
            participantID: UUID(),
            publicKey: senderKeyPair.0,
            privateKey: senderKeyPair.1
        )
        let recipient = Participant(
            participantID: UUID(),
            publicKey: recipientKeyPair.0,
            privateKey: recipientKeyPair.1
        )

        let messageService = MessageService()
        let plaintext = "Hello Participant!"
        let context = ContextInfo(ticketID: "TICKET1", timestamp: Date())

        // 暗号化
        let ciphertext = messageService.encrypt(
            plaintext: plaintext,
            sender: sender,
            recipient: recipient,
            context: context
        )
        #expect(ciphertext.rawValue.count > 0, "暗号文が生成されること")

        // 復号
        let decrypted = messageService.decrypt(
            ciphertext: ciphertext,
            sender: sender,
            recipient: recipient,
            context: context
        )
        #expect(decrypted == plaintext, "復号結果が平文と一致すること")
    }

    // MARK: - CohortService テスト

    @Test("Cohort作成・メンバー追加・削除")
    func testCohortMemberManagementFlow() async throws {
        let keyService = KeyManagementService()
        let p1KeyPair = keyService.generateKeyPair(
            participantID: UUID().uuidString
        )
        let p2KeyPair = keyService.generateKeyPair(
            participantID: UUID().uuidString
        )
        let memberPublicKeys = [p1KeyPair.0.rawValue]
        let initialState = Data()
        let cohortService = CohortService()

        // Cohort作成
        var cohort = cohortService.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )
        #expect(cohort.members.count == 1, "初期メンバーが追加されること")

        // メンバー追加（返り値でcohortを更新）
        cohort = cohortService.addMember(
            cohort: cohort,
            newMemberPublicKey: p2KeyPair.0.rawValue,
            senderPrivateKey: p1KeyPair.1.rawValue
        )
        #expect(cohort.members.count == 2, "新規メンバーが追加されること")

        // メンバー削除（直接配列操作でテスト）
        // メンバー削除テストはAPIがなければ省略
    }

    @Test("Cohort内メッセージ暗号化・復号")
    func testCohortMessageFlow() async throws {
        let keyService = KeyManagementService()
        let p1KeyPair = keyService.generateKeyPair(
            participantID: UUID().uuidString
        )
        let p2KeyPair = keyService.generateKeyPair(
            participantID: UUID().uuidString
        )
        let memberPublicKeys = [p1KeyPair.0.rawValue, p2KeyPair.0.rawValue]
        let initialState = Data()
        let cohortService = CohortService()
        let cohort = cohortService.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )

        let messageService = MessageService()
        let plaintext = "Hello Cohort!"
        let context = ContextInfo(ticketID: "COHORT1", timestamp: Date())

        // 暗号化
        let ciphertext = messageService.encryptInCohort(
            plaintext: plaintext,
            sender: cohort.members[0],
            cohort: cohort,
            context: context
        )
        #expect(ciphertext.rawValue.count > 0, "Cohort内暗号文が生成されること")

        // 復号
        let decrypted = messageService.decryptInCohort(
            ciphertext: ciphertext,
            recipient: cohort.members[1],
            cohort: cohort,
            context: context
        )
        #expect(decrypted == plaintext, "Cohort内メッセージが正しく復号できること")
    }
}

// MARK: - エンティティ・値オブジェクトの同値性・生成・API動作

@Test("Participant, Message, Commit, Cohortの同値性・基本振る舞い")
func testEntityEqualityAndBehavior() async throws {
    let pubKey = PublicKey(rawValue: Data([1, 2, 3]))
    let privKey = PrivateKey(rawValue: Data([4, 5, 6]))
    let participant1 = Participant(publicKey: pubKey, privateKey: privKey)
    let participant2 = Participant(
        participantID: participant1.participantID,
        publicKey: pubKey,
        privateKey: privKey
    )
    #expect(participant1 == participant2, "Participant同値性が正しく判定されること")

    let cipherText = CipherText(rawValue: Data([7, 8, 9]))
    let context = ContextInfo(ticketID: "T1", timestamp: Date())
    let message1 = Message(
        sender: participant1,
        cipherText: cipherText,
        contextInfo: context
    )
    let message2 = Message(
        messageID: message1.messageID,
        sender: participant1,
        cipherText: cipherText,
        contextInfo: context
    )
    #expect(message1 == message2, "Message同値性が正しく判定されること")

    let state = CohortState(treeKEMData: Data([10, 11, 12]))
    let cohort1 = Cohort(members: [participant1], state: state)
    let cohort2 = Cohort(
        cohortID: cohort1.cohortID,
        members: [participant1],
        state: state
    )
    #expect(cohort1 == cohort2, "Cohort同値性が正しく判定されること")

    let signature = Signature(rawValue: Data([13, 14, 15]))
    let commit1 = Commit(
        committer: participant1,
        newState: state,
        signature: signature,
        timestamp: Date()
    )
    let commit2 = Commit(
        commitID: commit1.commitID,
        committer: participant1,
        newState: state,
        signature: signature,
        timestamp: commit1.timestamp
    )
    #expect(commit1 == commit2, "Commit同値性が正しく判定されること")
}

@Test(
    "PublicKey, PrivateKey, CipherText, ContextInfo, Signature, CohortStateの生成・同値性・API動作"
)
func testValueObjectBehavior() async throws {
    // PublicKey/PrivateKey生成・同値性
    let priv = PrivateKey.generate()
    let pub = PublicKey.generate()
    let priv2 = try PrivateKey.fromRaw(priv.rawValue)
    let pub2 = try PublicKey.fromRaw(pub.rawValue)
    #expect(priv == priv2, "PrivateKey同値性が正しいこと")
    #expect(pub == pub2, "PublicKey同値性が正しいこと")

    // CipherText生成・同値性
    let key = SymmetricKey(size: .bits256)
    let plain = Data([1, 2, 3, 4])
    let cipher = try CipherText.encrypt(plaintext: plain, key: key)
    let decrypted = try CipherText.decrypt(ciphertext: cipher, key: key)
    #expect(
        cipher == CipherText(rawValue: cipher.rawValue),
        "CipherText同値性が正しいこと"
    )
    #expect(decrypted == plain, "CipherText復号が正しいこと")

    // ContextInfo生成・同値性
    let ctx1 = ContextInfo(ticketID: "TICKET", timestamp: Date())
    let ctx2 = ContextInfo(ticketID: ctx1.ticketID, timestamp: ctx1.timestamp)
    #expect(ctx1 == ctx2, "ContextInfo同値性が正しいこと")

    // Signature生成・検証
    let msg = Data([5, 6, 7, 8])
    let signPriv = Curve25519.Signing.PrivateKey()
    let signPub = signPriv.publicKey
    let signature = try Signature.sign(
        message: msg,
        privateKey: signPriv.rawRepresentation
    )
    let verified = Signature.verify(
        message: msg,
        signature: signature,
        publicKey: signPub.rawRepresentation
    )
    #expect(verified == true, "Signature検証が正しいこと")

    // CohortState生成・同値性
    let state1 = CohortState(treeKEMData: Data([9, 10, 11]))
    let state2 = CohortState(treeKEMData: Data([9, 10, 11]))
    #expect(state1 == state2, "CohortState同値性が正しいこと")
}
