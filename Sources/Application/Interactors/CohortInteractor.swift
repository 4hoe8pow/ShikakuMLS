//
//  CohortInteractor.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(macOS 10.15, *)
@available(iOS 17.0, *)
@Observable
final class CohortInteractor: CohortInputPort {
    private let outputPort: CohortOutputPort

    init(outputPort: CohortOutputPort) {
        self.outputPort = outputPort
    }

    private let cohortService = CohortService()
    private var cohort: Cohort?

    func createCohort(request: CreateCohortRequestDTO) async throws {
        let cohort = cohortService.createCohort(
            memberPublicKeys: request.memberPublicKeys,
            initialState: request.initialState
        )
        self.cohort = cohort
        let response = CreateCohortResponseDTO(cohort: cohort)
        outputPort.didCreateCohort(response: response)
    }

    func addMember(request: AddMemberRequestDTO) async throws {
        guard let cohort = self.cohort else { return }
        let updatedCohort = cohortService.addMember(
            cohort: cohort,
            newMemberPublicKey: request.newMemberPublicKey,
            senderPrivateKey: request.senderPrivateKey
        )
        self.cohort = updatedCohort
        let response = AddMemberResponseDTO(cohort: updatedCohort)
        outputPort.didAddMember(response: response)
    }

    func removeMember(request: RemoveMemberRequestDTO) async throws {
        // 実装省略
    }

    func getCohortState(request: GetCohortStateRequestDTO) async throws {
        guard let cohort = self.cohort else { return }
        let response = GetCohortStateResponseDTO(cohort: cohort)
        outputPort.didUpdateCohortState(response: response)
    }
}
