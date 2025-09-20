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

    init(participant: Participant) {
        self.participantID = participant.participantID.uuidString
        self.publicKey = participant.publicKey.rawValue
        self.privateKey = participant.privateKey.rawValue
    }
}
