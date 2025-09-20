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

    init(participant: Participant) {
        self.participantID = participant.participantID.uuidString
        self.publicKey = participant.publicKey.rawValue
    }
}
