//
//  Participant.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

final class Participant: Equatable {
    let participantID: UUID
    let publicKey: PublicKey
    let privateKey: PrivateKey

    init(
        participantID: UUID = UUID(),
        publicKey: PublicKey,
        privateKey: PrivateKey
    ) {
        self.participantID = participantID
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    static func == (lhs: Participant, rhs: Participant) -> Bool {
        lhs.participantID == rhs.participantID
    }
}
