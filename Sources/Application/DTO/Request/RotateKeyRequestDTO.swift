//
//  RotateKeyRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct RotateKeyRequestDTO {
    public let participantID: String
    public let currentPrivateKey: Data

    public init(participantID: String, currentPrivateKey: Data) {
        self.participantID = participantID
        self.currentPrivateKey = currentPrivateKey
    }

    internal static func from(participant: Participant) -> RotateKeyRequestDTO {
        return RotateKeyRequestDTO(
            participantID: participant.participantID.uuidString,
            currentPrivateKey: participant.privateKey.rawValue
        )
    }
}
