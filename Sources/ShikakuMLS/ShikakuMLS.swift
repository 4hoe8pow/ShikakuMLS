// ライブラリエントリーポイント

import Foundation

@available(macOS 10.15, *)
@available(iOS 17.0, *)

public struct ShikakuMLS {
    public let handler: ShikakuMLSHandler

    public init() {
        // Cohort
        let cohortPresenter = CohortPresenter()
        let cohortInteractor = CohortInteractor(outputPort: cohortPresenter)
        let cohortController = CohortController(inputPort: cohortInteractor)

        // KeyManagement
        let keyManagementPresenter = KeyManagementPresenter()
        let keyManagementInteractor = KeyManagementInteractor(
            outputPort: keyManagementPresenter
        )
        let keyManagementController = KeyManagementController(
            inputPort: keyManagementInteractor
        )

        // Message
        let messagePresenter = MessagePresenter()
        let messageInteractor = MessageInteractor(outputPort: messagePresenter)
        let messageController = MessageController(inputPort: messageInteractor)

        self.handler = ShikakuMLSHandler(
            cohortController: cohortController,
            keyManagementController: keyManagementController,
            messageController: messageController,
            cohortPresenter: cohortPresenter,
            keyManagementPresenter: keyManagementPresenter,
            messagePresenter: messagePresenter
        )
    }

    // --- ファサードAPI ---
    // ユーザーIDと公開鍵のマッピング（簡易管理）
    private var userPublicKeys: [String: Data] = [:]
    private var userPrivateKeys: [String: Data] = [:]

    // CohortIDと初期状態のマッピング
    private var cohortStates: [String: Data] = [:]

    // ユーザー登録（鍵生成）
    public mutating func registerUser(_ userID: String) async throws -> Data {
        let keyPair = try await handler.generateKeyPair(participantID: userID)
        guard let pub = keyPair?.publicKey, let priv = keyPair?.privateKey else {
            throw HandlerError.invalidArgument
        }
        userPublicKeys[userID] = pub
        userPrivateKeys[userID] = priv
        return pub
    }

    // Cohort作成
    public mutating func createCohort(members: [Data]) async throws -> String {
        // CohortStateは空データで初期化（本来はMLS初期化）
        let initialState = Data()
        let resp = try await handler.createCohort(
            memberPublicKeys: members, initialState: initialState)
        guard let cohortID = resp?.cohortID else {
            throw HandlerError.invalidArgument
        }
        // CohortStateは getCohortState で取得
        let stateResp = try await handler.getCohortState(cohortID: cohortID)
        if let state = stateResp?.state {
            cohortStates[cohortID] = state
        }
        return cohortID
    }

    // メッセージ送信
    public func sendMessage(text: String, from: String, to: Data) async throws -> Data {
        guard let senderPub = userPublicKeys[from], let senderPriv = userPrivateKeys[from] else {
            throw HandlerError.invalidArgument
        }
        let contextInfo: [String: Any] = ["timestamp": Date().timeIntervalSince1970]
        let resp = try await handler.sendMessage(
            plaintext: text,
            senderPublicKey: senderPub,
            senderPrivateKey: senderPriv,
            recipientPublicKey: to,
            contextInfo: contextInfo
        )
        guard let ciphertext = resp?.ciphertext else {
            throw HandlerError.invalidArgument
        }
        return ciphertext
    }

    // メッセージ受信（復号）
    public func receiveMessage(ciphertext: Data, from: Data, for userID: String) async throws
        -> String
    {
        guard let recipientPriv = userPrivateKeys[userID] else {
            throw HandlerError.invalidArgument
        }
        let contextInfo: [String: Any] = ["timestamp": Date().timeIntervalSince1970]
        let resp = try await handler.decryptMessage(
            ciphertext: ciphertext,
            senderPublicKey: from,
            recipientPrivateKey: recipientPriv,
            contextInfo: contextInfo
        )
        guard let plaintext = resp?.plaintext else {
            throw HandlerError.invalidArgument
        }
        return plaintext
    }
}
