//
//  MessageInteractor.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable
final class MessageInteractor: MessageInputPort {
    private let outputPort: MessageOutputPort

    init(outputPort: MessageOutputPort) {
        self.outputPort = outputPort
    }

    private let messageService = MessageService()

    func sendMessage(request: SendMessageRequestDTO) async throws {
        let cipherText = messageService.sendMessage(
            plaintext: request.plaintext,
            senderPrivateKey: request.senderPrivateKey,
            recipientPublicKey: request.recipientPublicKey,
            contextInfo: request.contextInfo
        )
        let response = SendMessageResponseDTO(
            ciphertext: cipherText.rawValue,
            senderPublicKey: request.senderPrivateKey,  // 仕様上本来はPublicKey
            recipientPublicKey: request.recipientPublicKey,
            contextInfo: request.contextInfo
        )
        outputPort.didSendMessage(response: response)
    }

    func decryptMessage(request: DecryptMessageRequestDTO) async throws {
        let plain = messageService.decryptMessage(
            ciphertext: request.ciphertext,
            senderPublicKey: request.senderPublicKey,
            recipientPrivateKey: request.recipientPrivateKey,
            contextInfo: request.contextInfo
        )
        let response = DecryptMessageResponseDTO(
            plaintext: plain,
            senderPublicKey: request.senderPublicKey,
            recipientPublicKey: request.recipientPrivateKey,  // 仕様上本来はPublicKey
            contextInfo: request.contextInfo
        )
        outputPort.didDecryptMessage(response: response)
    }
}
