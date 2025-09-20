//
//  KeyManagementInteractor.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable
final class KeyManagementInteractor: KeyManagementInputPort {
    private let outputPort: KeyManagementOutputPort

    init(outputPort: KeyManagementOutputPort) {
        self.outputPort = outputPort
    }

    private let keyService = KeyManagementService()

    func generateKeyPair(request: GenerateKeyPairRequestDTO) async throws {
        let (pub, priv) = keyService.generateKeyPair(
            participantID: request.participantID
        )
        let response = GenerateKeyPairResponseDTO(
            participantID: request.participantID,
            publicKey: pub.rawValue,
            privateKey: priv.rawValue
        )
        outputPort.didGenerateKeyPair(response: response)
    }

    func getPublicKey(request: GetPublicKeyRequestDTO) async throws {
        // 実装省略
    }

    func rotateKey(request: RotateKeyRequestDTO) async throws {
        let (pub, priv) = keyService.rotateKey(
            participantID: request.participantID
        )
        let response = RotateKeyResponseDTO(
            participantID: request.participantID,
            publicKey: pub.rawValue,
            privateKey: priv.rawValue
        )
        outputPort.didRotateKey(response: response)
    }
}
