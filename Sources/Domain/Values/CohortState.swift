//
//  CohortState.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

struct CohortState: Equatable {
    let treeKEMData: Data
    init(treeKEMData: Data) {
        self.treeKEMData = treeKEMData
    }
    static func == (lhs: CohortState, rhs: CohortState) -> Bool {
        lhs.treeKEMData == rhs.treeKEMData
    }
}
