//
//  KeyManagementPresenter.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable
public final class KeyManagementPresenter: Observable, KeyManagementOutputPort {
    var generatedKeyPair: GenerateKeyPairResponseDTO?
    var retrievedPublicKey: GetPublicKeyResponseDTO?
    var rotatedKey: RotateKeyResponseDTO?
    var keyManagementError: Error?

    public func didGenerateKeyPair(response: GenerateKeyPairResponseDTO) {
        generatedKeyPair = response
    }

    public func didRetrievePublicKey(response: GetPublicKeyResponseDTO) {
        retrievedPublicKey = response
    }

    public func didRotateKey(response: RotateKeyResponseDTO) {
        rotatedKey = response
    }

    public func didFailKeyManagementOperation(error: Error) {
        keyManagementError = error
    }
}
