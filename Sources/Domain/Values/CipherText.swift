//
//  CipherText.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//

import CryptoKit
import Foundation

@available(macOS 10.15, *)
struct CipherText: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: CipherText, rhs: CipherText) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // AES-GCM暗号化
    @available(iOS 13.0, *)
    static func encrypt(plaintext: Data, key: SymmetricKey) throws -> CipherText
    {
        let sealedBox = try AES.GCM.seal(plaintext, using: key)
        return CipherText(rawValue: sealedBox.combined!)
    }

    // AES-GCM復号
    @available(iOS 13.0, *)
    static func decrypt(ciphertext: CipherText, key: SymmetricKey) throws
        -> Data
    {
        let sealedBox = try AES.GCM.SealedBox(combined: ciphertext.rawValue)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
