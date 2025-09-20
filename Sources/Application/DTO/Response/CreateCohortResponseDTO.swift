//
//  CreateCohortResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct CreateCohortResponseDTO {
    let cohortID: String
    let memberPublicKeys: [Data]
    let state: Data

    public init(cohortID: String, memberPublicKeys: [Data], state: Data) {
        self.cohortID = cohortID
        self.memberPublicKeys = memberPublicKeys
        self.state = state
    }

    static func from(cohort: Cohort) -> CreateCohortResponseDTO {
        return CreateCohortResponseDTO(
            cohortID: cohort.cohortID.uuidString,
            memberPublicKeys: cohort.members.map { $0.publicKey.rawValue },
            state: cohort.state.treeKEMData
        )
    }
}
