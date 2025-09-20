//
//  InputPorts.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//

import Foundation

@available(iOS 13.0.0, *)
public protocol MessageInputPort {
    func sendMessage(request: SendMessageRequestDTO) async throws
    func decryptMessage(request: DecryptMessageRequestDTO) async throws
}

@available(iOS 13.0.0, *)
public protocol CohortInputPort {
    func createCohort(request: CreateCohortRequestDTO) async throws
    func addMember(request: AddMemberRequestDTO) async throws
    func removeMember(request: RemoveMemberRequestDTO) async throws
    func getCohortState(request: GetCohortStateRequestDTO) async throws
}

@available(iOS 13.0.0, *)
public protocol KeyManagementInputPort {
    func generateKeyPair(request: GenerateKeyPairRequestDTO) async throws
    func getPublicKey(request: GetPublicKeyRequestDTO) async throws
    func rotateKey(request: RotateKeyRequestDTO) async throws
}
