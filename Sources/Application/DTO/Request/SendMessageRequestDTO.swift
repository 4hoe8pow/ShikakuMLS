//
//  SendMessageRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct SendMessageRequestDTO {
    let plaintext: String
    let senderPrivateKey: Data
    let recipientPublicKey: Data
    let contextInfo: [String: Any]

    public init(
        plaintext: String, senderPrivateKey: Data, recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) {
        self.plaintext = plaintext
        self.senderPrivateKey = senderPrivateKey
        self.recipientPublicKey = recipientPublicKey
        self.contextInfo = contextInfo
    }

    static func from(message: Message, sender: Participant, recipient: Participant)
        -> SendMessageRequestDTO
    {
        return SendMessageRequestDTO(
            plaintext: "",  // Messageから平文は取得不可のため空文字
            senderPrivateKey: sender.privateKey.rawValue,
            recipientPublicKey: recipient.publicKey.rawValue,
            contextInfo: message.contextInfo.toDictionary()
        )
    }
}
