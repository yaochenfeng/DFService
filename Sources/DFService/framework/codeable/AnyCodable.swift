import Foundation


public struct AnyCodable: Codable {
    public let value: Any
    public init(_ value: Any) {
            self.value = value
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
                
                if container.decodeNil() {
                    self.value = NSNull()
                } else if let boolValue = try? container.decode(Bool.self) {
                    self.value = boolValue
                } else if let intValue = try? container.decode(Int.self) {
                    self.value = intValue
                } else if let doubleValue = try? container.decode(Double.self) {
                    self.value = doubleValue
                } else if let stringValue = try? container.decode(String.self) {
                    self.value = stringValue
                } else if let arrayValue = try? container.decode([AnyCodable].self) {
                    self.value = arrayValue.map { $0.value }
                } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
                    self.value = dictionaryValue.mapValues { $0.value }
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
                }
    }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self.value {
            case is NSNull:
                try container.encodeNil()
            case let boolValue as Bool:
                try container.encode(boolValue)
            case let intValue as Int:
                try container.encode(intValue)
            case let doubleValue as Double:
                try container.encode(doubleValue)
            case let stringValue as String:
                try container.encode(stringValue)
            case let arrayValue as [Any]:
                let encodableArray = arrayValue.map { AnyCodable($0) }
                try container.encode(encodableArray)
            case let dictionaryValue as [String: Any]:
                let encodableDictionary = dictionaryValue.mapValues { AnyCodable($0) }
                try container.encode(encodableDictionary)
            case let custom as Codable:
                try container.encode(custom)
            default:
                throw EncodingError.invalidValue(self.value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
            }
        }
}


extension AnyCodable: Equatable {
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        return lhs.value as AnyObject === rhs.value as AnyObject
    }
}

extension AnyCodable: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(value as AnyObject))
    }
}
