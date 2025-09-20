//
//  MessageController.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

@available(iOS 13.0.0, *)
public final class MessageController {
    private let inputPort: MessageInputPort

    public init(inputPort: MessageInputPort) {
        self.inputPort = inputPort
    }

    public func sendMessage(
        plaintext: String, senderPrivateKey: Data, recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) async throws {
        let request = SendMessageRequestDTO(
            plaintext: plaintext, senderPrivateKey: senderPrivateKey,
            recipientPublicKey: recipientPublicKey, contextInfo: contextInfo)
        try await inputPort.sendMessage(request: request)
    }

    public func decryptMessage(
        ciphertext: Data, senderPublicKey: Data, recipientPrivateKey: Data,
        contextInfo: [String: Any]
    ) async throws {
        let request = DecryptMessageRequestDTO(
            ciphertext: ciphertext, senderPublicKey: senderPublicKey,
            recipientPrivateKey: recipientPrivateKey, contextInfo: contextInfo)
        try await inputPort.decryptMessage(request: request)
    }
}
