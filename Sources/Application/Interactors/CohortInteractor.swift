//
//  CohortInteractor.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

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
        let response = CreateCohortResponseDTO(
            cohortID: cohort.cohortID.uuidString,
            memberPublicKeys: cohort.members.map { $0.publicKey.rawValue },
            state: cohort.state.treeKEMData
        )
        outputPort.didCreateCohort(response: response)
    }

    func addMember(request: AddMemberRequestDTO) async throws {
        guard let cohort = self.cohort else { return }
        let updated = cohortService.addMember(
            cohort: cohort,
            newMemberPublicKey: request.newMemberPublicKey,
            senderPrivateKey: request.senderPrivateKey
        )
        self.cohort = updated
        let response = AddMemberResponseDTO(
            cohortID: updated.cohortID.uuidString,
            memberPublicKeys: updated.members.map { $0.publicKey.rawValue },
            state: updated.state.treeKEMData
        )
        outputPort.didAddMember(response: response)
    }

    func removeMember(request: RemoveMemberRequestDTO) async throws {
        // 実装省略
    }

    func getCohortState(request: GetCohortStateRequestDTO) async throws {
        guard let cohort = self.cohort else { return }
        let state = cohortService.getCohortState(cohort: cohort)
        let response = GetCohortStateResponseDTO(
            cohortID: cohort.cohortID.uuidString,
            state: state.treeKEMData
        )
        outputPort.didUpdateCohortState(response: response)
    }
}
