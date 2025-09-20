//
//  CreateCohortRequestDTO.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/20.
//
import Foundation

public struct CreateCohortRequestDTO {
    let memberPublicKeys: [Data]
    let initialState: Data

    public init(memberPublicKeys: [Data], initialState: Data) {
        self.memberPublicKeys = memberPublicKeys
        self.initialState = initialState
    }
}
