//
//  GetCohortStateRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct GetCohortStateRequestDTO {
    let cohortID: String

    public init(cohortID: String) {
        self.cohortID = cohortID
    }

    static func from(cohort: Cohort) -> GetCohortStateRequestDTO {
        return GetCohortStateRequestDTO(cohortID: cohort.cohortID.uuidString)
    }
}
