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

    init(cohort: Cohort) {
        self.cohortID = cohort.cohortID.uuidString
        self.state = cohort.state.treeKEMData
    }
}
