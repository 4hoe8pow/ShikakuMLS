//
//  KeyManagementController.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

@available(iOS 13.0.0, *)
public final class KeyManagementController {
    private let inputPort: KeyManagementInputPort

    public init(inputPort: KeyManagementInputPort) {
        self.inputPort = inputPort
    }

    public func generateKeyPair(participantID: String) async throws {
        let request = GenerateKeyPairRequestDTO(participantID: participantID)
        try await inputPort.generateKeyPair(request: request)
    }
}
