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

    init(cohort: Cohort) {
        self.cohortID = cohort.cohortID.uuidString
        self.memberPublicKeys = cohort.members.map { $0.publicKey.rawValue }
        self.state = cohort.state.treeKEMData
    }
}
