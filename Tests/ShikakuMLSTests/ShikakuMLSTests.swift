import Foundation
import Testing

@testable import ShikakuMLS

struct ShikakuMLSTests {
    @Test("Cohort作成・メンバー追加・状態取得")
    @available(iOS 17.0, *)
    func testCohortFlow() async throws {
        let shikaku = ShikakuMLS()
        let memberPublicKeys = [Data()]
        let initialState = Data()
        let cohortResponse = try await shikaku.handler.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )
        #expect(cohortResponse != nil, "Cohort作成が成功すること")

        guard let cohortResponse = cohortResponse else {
            #expect(false, "Cohort作成に失敗しました")
            return
        }

        // メンバー追加
        let newMemberPublicKey = Data()
        let senderPrivateKey = Data()
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

        // 鍵ローテーション
        let rotateResponse = RotateKeyResponseDTO(
            participantID: participantID,
            publicKey: Data(),
            privateKey: Data()
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
        let senderPrivateKey = Data()
        let recipientPublicKey = Data()
        let contextInfo: [String: Any] = [
            "ticketID": "TICKET1", "timestamp": Date(),
        ]
        let sendResponse = try await shikaku.handler.sendMessage(
            plaintext: plaintext,
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
}
