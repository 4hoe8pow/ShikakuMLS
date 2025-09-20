//
//  AddMemberRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct AddMemberRequestDTO {
    let cohortID: String
    let newMemberPublicKey: Data
    let senderPrivateKey: Data

    public init(cohortID: String, newMemberPublicKey: Data, senderPrivateKey: Data) {
        self.cohortID = cohortID
        self.newMemberPublicKey = newMemberPublicKey
        self.senderPrivateKey = senderPrivateKey
    }

    static func from(cohort: Cohort, newMember: Participant, sender: Participant)
        -> AddMemberRequestDTO
    {
        return AddMemberRequestDTO(
            cohortID: cohort.cohortID.uuidString,
            newMemberPublicKey: newMember.publicKey.rawValue,
            senderPrivateKey: sender.privateKey.rawValue
        )
    }
}
