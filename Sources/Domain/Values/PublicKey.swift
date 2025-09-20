//
//  PublicKey.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

struct PublicKey: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
