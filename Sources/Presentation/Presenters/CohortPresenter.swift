//
//  CohortPresenter.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable
public final class CohortPresenter: Observable, CohortOutputPort {
    var createdCohort: CreateCohortResponseDTO?
    var addedMember: AddMemberResponseDTO?
    var removedMember: RemoveMemberResponseDTO?
    var updatedCohortState: GetCohortStateResponseDTO?
    var cohortError: Error?

    public func didCreateCohort(response: CreateCohortResponseDTO) {
        createdCohort = response
    }

    public func didAddMember(response: AddMemberResponseDTO) {
        addedMember = response
    }

    public func didRemoveMember(response: RemoveMemberResponseDTO) {
        removedMember = response
    }

    public func didUpdateCohortState(response: GetCohortStateResponseDTO) {
        updatedCohortState = response
    }

    public func didFailCohortOperation(error: Error) {
        cohortError = error
    }
}
