//
//  Commit.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

final class Commit: Equatable {
    let commitID: UUID
    let committer: Participant
    let newState: CohortState
    let signature: Signature
    let timestamp: Date

    init(
        commitID: UUID = UUID(),
        committer: Participant,
        newState: CohortState,
        signature: Signature,
        timestamp: Date = Date()
    ) {
        self.commitID = commitID
        self.committer = committer
        self.newState = newState
        self.signature = signature
        self.timestamp = timestamp
    }

    static func == (lhs: Commit, rhs: Commit) -> Bool {
        lhs.commitID == rhs.commitID
    }
}
