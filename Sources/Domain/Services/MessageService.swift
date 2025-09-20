import Foundation

@available(macOS 10.15, *)
final class MessageService {
    public init() {}

    // 1:1暗号化
    public func encrypt(
        plaintext: String,
        sender: Participant,
        recipient: Participant,
        context: ContextInfo
    ) -> CipherText {
        let data = Data((plaintext + "_encrypted").utf8)
        return CipherText(rawValue: data)
    }

    public func decrypt(
        ciphertext: CipherText,
        sender: Participant,
        recipient: Participant,
        context: ContextInfo
    ) -> String {
        return String(data: ciphertext.rawValue, encoding: .utf8)?
            .replacingOccurrences(
                of: "_encrypted",
                with: ""
            ) ?? ""
    }

    // Cohort暗号化
    public func encryptInCohort(
        plaintext: String,
        sender: Participant,
        cohort: Cohort,
        context: ContextInfo
    ) -> CipherText {
        let data = Data((plaintext + "_encrypted").utf8)
        return CipherText(rawValue: data)
    }

    public func decryptInCohort(
        ciphertext: CipherText,
        recipient: Participant,
        cohort: Cohort,
        context: ContextInfo
    ) -> String {
        return String(data: ciphertext.rawValue, encoding: .utf8)?
            .replacingOccurrences(
                of: "_encrypted",
                with: ""
            ) ?? ""
    }
}
