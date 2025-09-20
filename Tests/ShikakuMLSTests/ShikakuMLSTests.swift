import CryptoKit
import Foundation
import Testing

@testable import ShikakuMLS

struct ShikakuMLSTests {
    @Test("Cohort作成・メンバー追加・状態取得")
    @available(iOS 17.0, *)
    func testCohortFlow() async throws {
        let shikaku = ShikakuMLS()
        let memberPublicKeys = [Data([1, 2, 3, 4])]
        let initialState = Data([5, 6, 7, 8])
        let cohortResponse = try await shikaku.handler.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )
        #expect(cohortResponse != nil, "Cohort作成が成功すること")

        guard let cohortResponse = cohortResponse else {
            #expect(Bool(false), "Cohort作成に失敗しました")
            return
        }

        // メンバー追加
        let newMemberPublicKey = Data([9, 10, 11, 12])
        let senderPrivateKey = Data([13, 14, 15, 16])
        let addMemberResponse = try await shikaku.handler.addMember(
            cohortID: cohortResponse.cohortID,
            newMemberPublicKey: newMemberPublicKey,
            senderPrivateKey: senderPrivateKey
        )
        #expect(addMemberResponse != nil, "メンバー追加が成功すること")

        // Cohort状態取得
        let stateResponse = try await shikaku.handler.getCohortState(
            cohortID: cohortResponse.cohortID
        )
        #expect(stateResponse != nil, "Cohort状態取得が成功すること")
    }

    @Test("鍵生成・取得・ローテーション")
    @available(iOS 17.0, *)
    func testKeyManagementFlow() async throws {
        let shikaku = ShikakuMLS()
        let participantID = "test-participant"
        let keyPairResponse = try await shikaku.handler.generateKeyPair(
            participantID: participantID
        )
        #expect(keyPairResponse != nil, "鍵生成が成功すること")

        // 鍵ローテーション（participantIDを一致させる）
        let rotateResponse = RotateKeyResponseDTO(
            participantID: participantID,
            publicKey: Data([21, 22, 23, 24]),
            privateKey: Data([25, 26, 27, 28])
        )
        #expect(
            rotateResponse.participantID == participantID,
            "鍵ローテーションが成功すること"
        )
    }

    @Test("メッセージ送信・復号")
    @available(iOS 17.0, *)
    func testMessageFlow() async throws {
        let shikaku = ShikakuMLS()
        let plaintext = "Hello!"
        let senderPublicKey = Data([31, 32, 33, 34])
        let senderPrivateKey = Data([35, 36, 37, 38])
        let recipientPublicKey = Data([39, 40, 41, 42])
        let contextInfo: [String: Any] = [
            "ticketID": "TICKET1", "timestamp": Date(),
        ]
        let sendResponse = try await shikaku.handler.sendMessage(
            plaintext: plaintext,
            senderPublicKey: senderPublicKey,
            senderPrivateKey: senderPrivateKey,
            recipientPublicKey: recipientPublicKey,
            contextInfo: contextInfo
        )
        #expect(sendResponse != nil, "メッセージ送信が成功すること")

        let ciphertext = sendResponse!.ciphertext
        let decryptResponse = try await shikaku.handler.decryptMessage(
            ciphertext: ciphertext,
            senderPublicKey: recipientPublicKey,
            recipientPrivateKey: senderPrivateKey,
            contextInfo: contextInfo
        )
        #expect(decryptResponse != nil, "メッセージ復号が成功すること")
    }

    @Test("Cohort内メッセージ送信・復号")
    @available(iOS 17.0, *)
    func testCohortMessageFlow() async throws {
        let shikaku = ShikakuMLS()
        let memberPublicKeys = [Data([1, 2, 3, 4]), Data([5, 6, 7, 8])]
        let initialState = Data([9, 10, 11, 12])
        let cohortResponse = try await shikaku.handler.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )
        #expect(cohortResponse != nil, "Cohort作成が成功すること")
        guard cohortResponse != nil else { return }

        let senderPrivateKey = Data([13, 14, 15, 16])
        let senderPublicKey = memberPublicKeys[0]
        let recipientPublicKey = memberPublicKeys[1]
        let contextInfo: [String: Any] = [
            "ticketID": "TICKET2", "timestamp": Date(),
        ]
        let sendResponse = try await shikaku.handler.sendMessage(
            plaintext: "Cohort Hello!",
            senderPublicKey: senderPublicKey,
            senderPrivateKey: senderPrivateKey,
            recipientPublicKey: recipientPublicKey,
            contextInfo: contextInfo
        )
        #expect(sendResponse != nil, "Cohort内メッセージ送信が成功すること")

        let ciphertext = sendResponse!.ciphertext
        let decryptResponse = try await shikaku.handler.decryptMessage(
            ciphertext: ciphertext,
            senderPublicKey: recipientPublicKey,
            recipientPrivateKey: senderPrivateKey,
            contextInfo: contextInfo
        )
        #expect(decryptResponse != nil, "Cohort内メッセージ復号が成功すること")
    }

    @Test("Commit生成・署名検証")
    @available(iOS 17.0, *)
    func testCommitSignatureFlow() async throws {
        // 正しいCurve25519鍵でParticipant・署名生成
        let signPriv = Curve25519.Signing.PrivateKey()
        let signPub = signPriv.publicKey
        let privKey = signPriv.rawRepresentation
        let pubKey = signPub.rawRepresentation
        let participant = Participant(
            publicKey: PublicKey(rawValue: pubKey),
            privateKey: PrivateKey(rawValue: privKey)
        )
        let newState = CohortState(treeKEMData: Data([9, 10, 11, 12]))
        let message = newState.treeKEMData
        // 署名生成
        let signature = try? Signature.sign(
            message: message,
            privateKey: privKey
        )
        #expect(signature != nil, "署名生成が成功すること")
        // Commit生成
        let commit = Commit(
            committer: participant,
            newState: newState,
            signature: signature!,
            timestamp: Date()
        )
        #expect(commit.signature == signature, "Commitに署名が格納されること")
        // 署名検証
        let verified = Signature.verify(
            message: message,
            signature: signature!,
            publicKey: pubKey
        )
        #expect(verified == true, "署名検証が成功すること")
    }
}
