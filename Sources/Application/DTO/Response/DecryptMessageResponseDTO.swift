//
//  DecryptMessageResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct DecryptMessageResponseDTO {
    let plaintext: String
    let senderPublicKey: Data
    let recipientPublicKey: Data
    let contextInfo: [String: Any]

    public init(
        plaintext: String, senderPublicKey: Data, recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) {
        self.plaintext = plaintext
        self.senderPublicKey = senderPublicKey
        self.recipientPublicKey = recipientPublicKey
        self.contextInfo = contextInfo
    }

    static func from(message: Message, recipient: Participant) -> DecryptMessageResponseDTO {
        return DecryptMessageResponseDTO(
            plaintext: "",  // 復号結果はドメインから取得
            senderPublicKey: message.sender.publicKey.rawValue,
            recipientPublicKey: recipient.publicKey.rawValue,
            contextInfo: message.contextInfo.toDictionary()
        )
    }
}
