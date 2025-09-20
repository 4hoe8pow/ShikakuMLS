//
//  Message.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

@available(macOS 10.15, *)
final class Message: Equatable {
    let messageID: UUID
    let sender: Participant
    let cipherText: CipherText
    let contextInfo: ContextInfo

    init(
        messageID: UUID = UUID(),
        sender: Participant,
        cipherText: CipherText,
        contextInfo: ContextInfo
    ) {
        self.messageID = messageID
        self.sender = sender
        self.cipherText = cipherText
        self.contextInfo = contextInfo
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.messageID == rhs.messageID
    }
}
