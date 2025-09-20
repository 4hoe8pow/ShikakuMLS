//
//  GetPublicKeyResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct GetPublicKeyResponseDTO {
    let participantID: String
    let publicKey: Data

    public init(participantID: String, publicKey: Data) {
        self.participantID = participantID
        self.publicKey = publicKey
    }

    static func from(participant: Participant) -> GetPublicKeyResponseDTO {
        return GetPublicKeyResponseDTO(
            participantID: participant.participantID.uuidString,
            publicKey: participant.publicKey.rawValue
        )
    }
}
