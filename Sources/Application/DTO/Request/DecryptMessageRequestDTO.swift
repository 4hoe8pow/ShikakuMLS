//
//  DecryptMessageRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct DecryptMessageRequestDTO {
    let ciphertext: Data
    let senderPublicKey: Data
    let recipientPrivateKey: Data
    let contextInfo: [String: Any]

    public init(
        ciphertext: Data, senderPublicKey: Data, recipientPrivateKey: Data,
        contextInfo: [String: Any]
    ) {
        self.ciphertext = ciphertext
        self.senderPublicKey = senderPublicKey
        self.recipientPrivateKey = recipientPrivateKey
        self.contextInfo = contextInfo
    }

    static func from(message: Message, recipient: Participant) -> DecryptMessageRequestDTO {
        return DecryptMessageRequestDTO(
            ciphertext: message.cipherText.rawValue,
            senderPublicKey: message.sender.publicKey.rawValue,
            recipientPrivateKey: recipient.privateKey.rawValue,
            contextInfo: message.contextInfo.toDictionary()
        )
    }
}
