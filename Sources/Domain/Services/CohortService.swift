import Foundation

final class CohortService {
    public init() {}

    public func createCohort(memberPublicKeys: [Data], initialState: Data)
        -> Cohort
    {
        let members = memberPublicKeys.map { pk in
            Participant(
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
    )
        -> Cohort
    {
        let newMember = Participant(
            publicKey: PublicKey(rawValue: newMemberPublicKey),
            privateKey: PrivateKey(rawValue: senderPrivateKey)
        )
        cohort.addMember(newMember)
        // CohortState更新は省略
        return cohort
    }

    public func getCohortState(cohort: Cohort) -> CohortState {
        return cohort.state
    }
}
