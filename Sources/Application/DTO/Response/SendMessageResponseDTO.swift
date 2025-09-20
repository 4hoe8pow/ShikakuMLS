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

    init(message: Message, sender: Participant, recipient: Participant) {
        self.ciphertext = message.cipherText.rawValue
        self.senderPublicKey = sender.publicKey.rawValue
        self.recipientPublicKey = recipient.publicKey.rawValue
        self.contextInfo = message.contextInfo.toDictionary()
    }
}
