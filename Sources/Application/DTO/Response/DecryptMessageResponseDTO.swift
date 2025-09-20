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

    init(message: Message, recipient: Participant) {
        self.plaintext = ""  // 復号結果はドメインから取得
        self.senderPublicKey = message.sender.publicKey.rawValue
        self.recipientPublicKey = recipient.publicKey.rawValue
        self.contextInfo = message.contextInfo.toDictionary()
    }
}
