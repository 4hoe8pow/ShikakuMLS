//
//  GetPublicKeyRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct GetPublicKeyRequestDTO {
    let participantID: String

    public init(participantID: String) {
        self.participantID = participantID
    }

    static func from(participant: Participant) -> GetPublicKeyRequestDTO {
        return GetPublicKeyRequestDTO(participantID: participant.participantID.uuidString)
    }
}
