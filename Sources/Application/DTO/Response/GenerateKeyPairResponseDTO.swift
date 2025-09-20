//
//  GenerateKeyPairResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct GenerateKeyPairResponseDTO {
    let participantID: String
    let publicKey: Data
    let privateKey: Data

    public init(participantID: String, publicKey: Data, privateKey: Data) {
        self.participantID = participantID
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    static func from(participant: Participant) -> GenerateKeyPairResponseDTO {
        return GenerateKeyPairResponseDTO(
            participantID: participant.participantID.uuidString,
            publicKey: participant.publicKey.rawValue,
            privateKey: participant.privateKey.rawValue
        )
    }
}
