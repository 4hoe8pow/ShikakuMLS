import Foundation

final class MessageService {
    public init() {}

    public func sendMessage(
        plaintext: String,
        senderPrivateKey: Data,
        recipientPublicKey: Data,
        contextInfo: [String: Any]
    ) -> CipherText {
        // 疑似暗号化
        let data = Data((plaintext + "_encrypted").utf8)
        return CipherText(rawValue: data)
    }

    public func decryptMessage(
        ciphertext: Data,
        senderPublicKey: Data,
        recipientPrivateKey: Data,
        contextInfo: [String: Any]
    ) -> String {
        // 疑似復号
        return String(data: ciphertext, encoding: .utf8)?.replacingOccurrences(
            of: "_encrypted",
            with: ""
        ) ?? ""
    }
}
