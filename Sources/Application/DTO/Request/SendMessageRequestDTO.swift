//
//  SendMessageRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct SendMessageRequestDTO {
    let plaintext: String
    let senderPublicKey: Data
    let senderPrivateKey: Data
    let recipientPublicKey: Data
    let contextInfo: [String: Any]

    public init(
        plaintext: String,
        senderPublicKey: Data,
        senderPrivateKey: Data,
        recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) {
        self.plaintext = plaintext
        self.senderPublicKey = senderPublicKey
        self.senderPrivateKey = senderPrivateKey
        self.recipientPublicKey = recipientPublicKey
        self.contextInfo = contextInfo
    }
}
