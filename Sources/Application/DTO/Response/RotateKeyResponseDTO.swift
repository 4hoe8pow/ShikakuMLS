//
//  RotateKeyResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct RotateKeyResponseDTO {
    public let participantID: String
    public let publicKey: Data
    public let privateKey: Data

    init(participant: Participant) {
        self.participantID = participant.participantID.uuidString
        self.publicKey = participant.publicKey.rawValue
        self.privateKey = participant.privateKey.rawValue
    }

    public init(participantID: String, publicKey: Data, privateKey: Data) {
        self.participantID = participantID
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
