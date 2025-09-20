import CryptoKit
//
//  PrivateKey.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

@available(macOS 10.15, *)
struct PrivateKey: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // Curve25519秘密鍵生成
    @available(iOS 13.0, *)
    static func generate() -> PrivateKey {
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        return PrivateKey(rawValue: privateKey.rawRepresentation)
    }

    // Curve25519秘密鍵復元
    @available(iOS 13.0, *)
    static func fromRaw(_ data: Data) throws -> PrivateKey {
        let key = try Curve25519.KeyAgreement.PrivateKey(
            rawRepresentation: data
        )
        return PrivateKey(rawValue: key.rawRepresentation)
    }
}
