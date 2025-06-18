//
//  File.swift
//  DFService
//
//  Created by yaochenfeng on 2025/6/18.
//

import Foundation
public struct Destination: Hashable {
    public let route: String
    public let parameters: [String: Any]
    public let id: UUID

    public init(route: String, parameters: [String: Any] = [:], id: UUID = UUID()) {
        self.route = route
        self.parameters = parameters
        self.id = id
    }

    public static func ==(lhs: Destination, rhs: Destination) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
