//
//  GetCohortStateResponseDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct GetCohortStateResponseDTO {
    let cohortID: String
    let state: Data

    public init(cohortID: String, state: Data) {
        self.cohortID = cohortID
        self.state = state
    }

    static func from(cohort: Cohort) -> GetCohortStateResponseDTO {
        return GetCohortStateResponseDTO(
            cohortID: cohort.cohortID.uuidString,
            state: cohort.state.treeKEMData
        )
    }
}
