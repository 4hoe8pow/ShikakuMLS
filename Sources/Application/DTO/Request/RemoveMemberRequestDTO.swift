//
//  RemoveMemberRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct RemoveMemberRequestDTO {
    public let cohortID: String
    public let removedMemberPublicKey: Data
    public let senderPrivateKey: Data

    public init(cohortID: String, removedMemberPublicKey: Data, senderPrivateKey: Data) {
        self.cohortID = cohortID
        self.removedMemberPublicKey = removedMemberPublicKey
        self.senderPrivateKey = senderPrivateKey
    }

    static func from(cohort: Cohort, removedMember: Participant, sender: Participant)
        -> RemoveMemberRequestDTO
    {
        return RemoveMemberRequestDTO(
            cohortID: cohort.cohortID.uuidString,
            removedMemberPublicKey: removedMember.publicKey.rawValue,
            senderPrivateKey: sender.privateKey.rawValue
        )
    }
}
