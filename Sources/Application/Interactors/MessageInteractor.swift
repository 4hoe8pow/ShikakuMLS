//
//  MessageInteractor.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(macOS 10.15, *)
@available(iOS 17.0, *)
@Observable
final class MessageInteractor: MessageInputPort {
    private let outputPort: MessageOutputPort

    init(outputPort: MessageOutputPort) {
        self.outputPort = outputPort
    }

    private let messageService = MessageService()

    func sendMessage(request: SendMessageRequestDTO) async throws {
        let sender = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: request.senderPublicKey),
            privateKey: PrivateKey(rawValue: request.senderPrivateKey)
        )
        let recipient = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: request.recipientPublicKey),
            privateKey: PrivateKey(rawValue: Data())  // dummy
        )
        let contextInfo: ContextInfo
        let dict = request.contextInfo
        if let ticketID = dict["ticketID"] as? String,
            let timestamp = dict["timestamp"] as? Date
        {
            contextInfo = ContextInfo(ticketID: ticketID, timestamp: timestamp)
        } else {
            contextInfo = ContextInfo(ticketID: "", timestamp: Date())
        }
        let cipherText = messageService.encrypt(
            plaintext: request.plaintext,
            sender: sender,
            recipient: recipient,
            context: contextInfo
        )
        let message = Message(
            sender: sender,
            cipherText: cipherText,
            contextInfo: contextInfo
        )
        let response = SendMessageResponseDTO(
            message: message,
            sender: sender,
            recipient: recipient
        )
        outputPort.didSendMessage(response: response)
    }

    func decryptMessage(request: DecryptMessageRequestDTO) async throws {
        let sender = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: request.senderPublicKey),
            privateKey: PrivateKey(rawValue: Data())  // dummy
        )
        let recipient = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: Data()),  // dummy
            privateKey: PrivateKey(rawValue: request.recipientPrivateKey)
        )
        let contextInfo: ContextInfo
        let dict = request.contextInfo
        if let ticketID = dict["ticketID"] as? String,
            let timestamp = dict["timestamp"] as? Date
        {
            contextInfo = ContextInfo(ticketID: ticketID, timestamp: timestamp)
        } else {
            contextInfo = ContextInfo(ticketID: "", timestamp: Date())
        }

        let message = Message(
            sender: sender,
            cipherText: CipherText(rawValue: request.ciphertext),
            contextInfo: contextInfo
        )
        let response = DecryptMessageResponseDTO(
            message: message,
            recipient: recipient
        )
        outputPort.didDecryptMessage(response: response)
    }
}
