//
//  DomainServiceTests.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Testing

@testable import ShikakuMLSDomain

struct DomainServiceTests {

    // MARK: - KeyManagementService テスト

    @Test("鍵生成とラチェット更新")
    func testKeyGenerationAndRotation() async throws {
        let participantID = UUID()
        let participant = Participant(
            participantID: participantID,
            publicKey: PublicKey(rawValue: Data()),
            privateKey: PrivateKey(rawValue: Data())
        )

        let keyService = KeyManagementService()

        let keyPair = try keyService.generateKeyPair(for: participantID)
        #expect(keyPair.publicKey.rawValue.count > 0, "公開鍵が生成されること")
        #expect(keyPair.privateKey.rawValue.count > 0, "秘密鍵が生成されること")

        let rotatedKeyPair = try keyService.rotateKeyPair(for: participantID)
        #expect(
            rotatedKeyPair.publicKey != keyPair.publicKey,
            "ラチェット更新で公開鍵が変わること"
        )
        #expect(
            rotatedKeyPair.privateKey != keyPair.privateKey,
            "ラチェット更新で秘密鍵が変わること"
        )
    }

    // MARK: - MessageService テスト

    @Test("1:1 メッセージ暗号化／復号")
    func testOneToOneMessageEncryptionDecryption() async throws {
        let keyService = KeyManagementService()
        let senderID = UUID()
        let recipientID = UUID()
        let senderKey = try keyService.generateKeyPair(for: senderID)
        let recipientKey = try keyService.generateKeyPair(for: recipientID)

        let sender = Participant(
            participantID: senderID,
            publicKey: senderKey.publicKey,
            privateKey: senderKey.privateKey
        )
        let recipient = Participant(
            participantID: recipientID,
            publicKey: recipientKey.publicKey,
            privateKey: recipientKey.privateKey
        )

        let messageService = MessageService(keyService: keyService)
        let plaintext = "Hello Participant!"

        let ciphertext = try messageService.encrypt(
            plaintext: plaintext,
            sender: sender,
            recipient: recipient,
            context: ContextInfo(ticketID: "TICKET1", timestamp: Date())
        )

        let decrypted = try messageService.decrypt(
            ciphertext: ciphertext,
            sender: sender,
            recipient: recipient,
            context: ContextInfo(ticketID: "TICKET1", timestamp: Date())
        )

        #expect(decrypted == plaintext, "復号結果が平文と一致すること")
    }

    // MARK: - CohortService テスト

    @Test("Cohort作成とメンバー管理")
    func testCohortCreateAndMemberManagement() async throws {
        let participant1 = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: Data([0x01])),
            privateKey: PrivateKey(rawValue: Data([0x01]))
        )
        let participant2 = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: Data([0x02])),
            privateKey: PrivateKey(rawValue: Data([0x02]))
        )

        let initialState = CohortState(treeKEMData: Data())
        let cohortService = CohortService()

        let cohort = try cohortService.createCohort(
            members: [participant1],
            initialState: initialState
        )
        #expect(cohort.members.contains(participant1), "初期メンバーが追加されること")

        try cohortService.addMember(cohort: cohort, participant: participant2)
        #expect(cohort.members.contains(participant2), "新規メンバーが追加されること")

        try cohortService.removeMember(
            cohort: cohort,
            participant: participant1
        )
        #expect(!cohort.members.contains(participant1), "メンバー削除が反映されること")
    }

    @Test("Cohort内メッセージ暗号化／復号")
    func testCohortMessageEncryptionDecryption() async throws {
        let participant1 = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: Data([0x01])),
            privateKey: PrivateKey(rawValue: Data([0x01]))
        )
        let participant2 = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: Data([0x02])),
            privateKey: PrivateKey(rawValue: Data([0x02]))
        )
        let initialState = CohortState(treeKEMData: Data())
        let cohortService = CohortService()
        let cohort = try cohortService.createCohort(
            members: [participant1, participant2],
            initialState: initialState
        )

        let messageService = MessageService(keyService: KeyManagementService())
        let plaintext = "Hello Cohort!"

        let ciphertext = try messageService.encryptInCohort(
            plaintext: plaintext,
            sender: participant1,
            cohort: cohort,
            context: ContextInfo(ticketID: "COHORT1", timestamp: Date())
        )

        let decrypted = try messageService.decryptInCohort(
            ciphertext: ciphertext,
            recipient: participant2,
            cohort: cohort,
            context: ContextInfo(ticketID: "COHORT1", timestamp: Date())
        )

        #expect(decrypted == plaintext, "Cohort内メッセージが正しく復号できること")
    }
}
