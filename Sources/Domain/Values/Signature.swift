//
//  Signature.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//
import Foundation

struct Signature: Equatable {
    let rawValue: Data
    init(rawValue: Data) {
        self.rawValue = rawValue
    }
    static func == (lhs: Signature, rhs: Signature) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
