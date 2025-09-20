import Foundation

@available(macOS 10.15, *)
final class CohortService {
    public init() {}

    public func createCohort(memberPublicKeys: [Data], initialState: Data)
        -> Cohort
    {
        let members = memberPublicKeys.map { pk in
            Participant(
                participantID: UUID(),
                publicKey: PublicKey(rawValue: pk),
                privateKey: PrivateKey(rawValue: Data())
            )
        }
        let state = CohortState(treeKEMData: initialState)
        return Cohort(members: members, state: state)
    }

    public func addMember(
        cohort: Cohort,
        newMemberPublicKey: Data,
        senderPrivateKey: Data
    ) -> Cohort {
        let newMember = Participant(
            participantID: UUID(),
            publicKey: PublicKey(rawValue: newMemberPublicKey),
            privateKey: PrivateKey(rawValue: senderPrivateKey)
        )
        var newMembers = cohort.members
        newMembers.append(newMember)
        // CohortState更新は省略
        return Cohort(members: newMembers, state: cohort.state)
    }

}
