//
//  ShikakuMLSHandler.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

// 外部API用ハンドラ

import Foundation

public enum HandlerError: Error {
    case invalidArgument
}

@available(iOS 17.0.0, *)
public final class ShikakuMLSHandler {
    private let cohortController: CohortController
    private let keyManagementController: KeyManagementController
    private let messageController: MessageController
    private let cohortPresenter: CohortPresenter
    private let keyManagementPresenter: KeyManagementPresenter
    private let messagePresenter: MessagePresenter

    public init(
        cohortController: CohortController,
        keyManagementController: KeyManagementController,
        messageController: MessageController,
        cohortPresenter: CohortPresenter,
        keyManagementPresenter: KeyManagementPresenter,
        messagePresenter: MessagePresenter
    ) {
        self.cohortController = cohortController
        self.keyManagementController = keyManagementController
        self.messageController = messageController
        self.cohortPresenter = cohortPresenter
        self.keyManagementPresenter = keyManagementPresenter
        self.messagePresenter = messagePresenter
    }

    // Cohort作成
    public func createCohort(memberPublicKeys: [Data], initialState: Data)
        async throws
        -> CreateCohortResponseDTO?
    {
        guard !memberPublicKeys.isEmpty else {
            throw HandlerError.invalidArgument
        }
        try await cohortController.createCohort(
            memberPublicKeys: memberPublicKeys,
            initialState: initialState
        )
        return cohortPresenter.createdCohort
    }

    // メンバー追加
    public func addMember(
        cohortID: String,
        newMemberPublicKey: Data,
        senderPrivateKey: Data
    )
        async throws -> AddMemberResponseDTO?
    {
        guard !cohortID.isEmpty, !newMemberPublicKey.isEmpty,
            !senderPrivateKey.isEmpty
        else {
            throw HandlerError.invalidArgument
        }
        try await cohortController.addMember(
            cohortID: cohortID,
            newMemberPublicKey: newMemberPublicKey,
            senderPrivateKey: senderPrivateKey
        )
        return cohortPresenter.addedMember
    }

    // Cohort状態取得
    public func getCohortState(cohortID: String) async throws
        -> GetCohortStateResponseDTO?
    {
        guard !cohortID.isEmpty else { throw HandlerError.invalidArgument }
        try await cohortController.getCohortState(cohortID: cohortID)
        return cohortPresenter.updatedCohortState
    }

    // 鍵生成
    public func generateKeyPair(participantID: String) async throws
        -> GenerateKeyPairResponseDTO?
    {
        guard !participantID.isEmpty else { throw HandlerError.invalidArgument }
        try await keyManagementController.generateKeyPair(
            participantID: participantID
        )
        return keyManagementPresenter.generatedKeyPair
    }

    // メッセージ送信
    public func sendMessage(
        plaintext: String,
        senderPublicKey: Data,
        senderPrivateKey: Data,
        recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) async throws -> SendMessageResponseDTO? {
        guard !plaintext.isEmpty, !senderPublicKey.isEmpty,
            !senderPrivateKey.isEmpty,
            !recipientPublicKey.isEmpty
        else {
            throw HandlerError.invalidArgument
        }
        try await messageController.sendMessage(
            plaintext: plaintext,
            senderPublicKey: senderPublicKey,
            senderPrivateKey: senderPrivateKey,
            recipientPublicKey: recipientPublicKey,
            contextInfo: contextInfo
        )
        return messagePresenter.sentMessage
    }

    // メッセージ復号
    public func decryptMessage(
        ciphertext: Data,
        senderPublicKey: Data,
        recipientPrivateKey: Data,
        contextInfo: [String: Any]
    ) async throws -> DecryptMessageResponseDTO? {
        guard !ciphertext.isEmpty, !senderPublicKey.isEmpty,
            !recipientPrivateKey.isEmpty
        else {
            throw HandlerError.invalidArgument
        }
        try await messageController.decryptMessage(
            ciphertext: ciphertext,
            senderPublicKey: senderPublicKey,
            recipientPrivateKey: recipientPrivateKey,
            contextInfo: contextInfo
        )
        return messagePresenter.decryptedMessage
    }
}
