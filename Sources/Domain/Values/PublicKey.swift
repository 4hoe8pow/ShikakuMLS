import CryptoKit
//
//  PublicKey.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

@available(macOS 10.15, *)
struct PublicKey: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // Curve25519公開鍵生成
    @available(iOS 13.0, *)
    static func generate() -> PublicKey {
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        return PublicKey(rawValue: publicKey.rawRepresentation)
    }

    // Curve25519公開鍵復元
    @available(iOS 13.0, *)
    static func fromRaw(_ data: Data) throws -> PublicKey {
        let key = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: data)
        return PublicKey(rawValue: key.rawRepresentation)
    }
}
