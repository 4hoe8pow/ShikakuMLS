//
//  ContextInfo.swift
//  ShikakuMLS
//
//  Created by 4hoe8pow on 2025/09/19.
//

import Foundation

struct ContextInfo: Equatable {
    let ticketID: String
    let timestamp: Date

    init(ticketID: String, timestamp: Date) {
        self.ticketID = ticketID
        self.timestamp = timestamp
    }

    func toDictionary() -> [String: Any] {
        return [
            "ticketID": ticketID,
            "timestamp": timestamp,
        ]
    }

    static func == (lhs: ContextInfo, rhs: ContextInfo) -> Bool {
        lhs.ticketID == rhs.ticketID && lhs.timestamp == rhs.timestamp
    }
}
