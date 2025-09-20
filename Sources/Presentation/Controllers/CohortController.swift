//
//  CohortController.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

@available(iOS 13.0.0, *)
public final class CohortController {
    private let inputPort: CohortInputPort

    public init(inputPort: CohortInputPort) {
        self.inputPort = inputPort
    }

    public func createCohort(memberPublicKeys: [Data], initialState: Data) async throws {
        let request = CreateCohortRequestDTO(
            memberPublicKeys: memberPublicKeys, initialState: initialState)
        try await inputPort.createCohort(request: request)
    }

    public func addMember(cohortID: String, newMemberPublicKey: Data, senderPrivateKey: Data)
        async throws
    {
        let request = AddMemberRequestDTO(
            cohortID: cohortID, newMemberPublicKey: newMemberPublicKey,
            senderPrivateKey: senderPrivateKey)
        try await inputPort.addMember(request: request)
    }

    public func getCohortState(cohortID: String) async throws {
        let request = GetCohortStateRequestDTO(cohortID: cohortID)
        try await inputPort.getCohortState(request: request)
    }
}
