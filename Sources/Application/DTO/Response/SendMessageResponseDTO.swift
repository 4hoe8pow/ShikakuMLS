//
//  SendMessageResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct SendMessageResponseDTO {
    let ciphertext: Data
    let senderPublicKey: Data
    let recipientPublicKey: Data
    let contextInfo: [String: Any]

    public init(
        ciphertext: Data, senderPublicKey: Data, recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) {
        self.ciphertext = ciphertext
        self.senderPublicKey = senderPublicKey
        self.recipientPublicKey = recipientPublicKey
        self.contextInfo = contextInfo
    }

    static func from(message: Message, sender: Participant, recipient: Participant)
        -> SendMessageResponseDTO
    {
        return SendMessageResponseDTO(
            ciphertext: message.cipherText.rawValue,
            senderPublicKey: sender.publicKey.rawValue,
            recipientPublicKey: recipient.publicKey.rawValue,
            contextInfo: message.contextInfo.toDictionary()
        )
    }
}
