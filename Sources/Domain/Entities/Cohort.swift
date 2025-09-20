//
//  Cohort.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

@available(macOS 10.15, *)
final class Cohort: Equatable {
    let cohortID: UUID
    private(set) var members: [Participant]
    var state: CohortState

    init(
        cohortID: UUID = UUID(),
        members: [Participant],
        state: CohortState
    ) {
        self.cohortID = cohortID
        self.members = members
        self.state = state
    }

    func addMember(_ participant: Participant) {
        members.append(participant)
    }

    func removeMember(_ participant: Participant) {
        members.removeAll { $0 == participant }
    }

    static func == (lhs: Cohort, rhs: Cohort) -> Bool {
        lhs.cohortID == rhs.cohortID
    }
}
