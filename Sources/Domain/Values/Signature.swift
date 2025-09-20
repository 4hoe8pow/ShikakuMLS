import CryptoKit
//
//  Signature.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct Signature: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: Signature, rhs: Signature) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // Ed25519署名生成
    static func sign(message: Data, privateKey: Data) throws -> Signature {
        let key = try Curve25519.Signing.PrivateKey(
            rawRepresentation: privateKey
        )
        let signature = try key.signature(for: message)
        return Signature(rawValue: signature)
    }

    // Ed25519署名検証
    static func verify(message: Data, signature: Signature, publicKey: Data)
        -> Bool
    {
        guard
            let key = try? Curve25519.Signing.PublicKey(
                rawRepresentation: publicKey
            )
        else {
            return false
        }
        return key.isValidSignature(signature.rawValue, for: message)
    }
}
