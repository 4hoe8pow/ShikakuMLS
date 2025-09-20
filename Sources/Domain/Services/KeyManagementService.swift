import Foundation

@available(macOS 10.15, *)
final class KeyManagementService {
    public init() {}

    public func generateKeyPair(participantID: String) -> (
        PublicKey, PrivateKey
    ) {
        // 疑似鍵生成
        let pub = PublicKey(rawValue: Data(participantID.utf8))
        let priv = PrivateKey(rawValue: Data((participantID + "_priv").utf8))
        return (pub, priv)
    }

    public func rotateKeyPair(participantID: String) -> (PublicKey, PrivateKey)
    {
        // 疑似鍵ローテーション
        let pub = PublicKey(rawValue: Data((participantID + "_rot").utf8))
        let priv = PrivateKey(
            rawValue: Data((participantID + "_rot_priv").utf8)
        )
        return (pub, priv)
    }
}
