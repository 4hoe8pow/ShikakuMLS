//
//  OutputPorts.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//

import Foundation

public protocol MessageOutputPort {
    func didSendMessage(response: SendMessageResponseDTO)
    func didDecryptMessage(response: DecryptMessageResponseDTO)
    func didFailMessageOperation(error: Error)
}

public protocol CohortOutputPort {
    func didCreateCohort(response: CreateCohortResponseDTO)
    func didAddMember(response: AddMemberResponseDTO)
    func didRemoveMember(response: RemoveMemberResponseDTO)
    func didUpdateCohortState(response: GetCohortStateResponseDTO)
    func didFailCohortOperation(error: Error)
}

public protocol KeyManagementOutputPort {
    func didGenerateKeyPair(response: GenerateKeyPairResponseDTO)
    func didRetrievePublicKey(response: GetPublicKeyResponseDTO)
    func didRotateKey(response: RotateKeyResponseDTO)
    func didFailKeyManagementOperation(error: Error)
}
