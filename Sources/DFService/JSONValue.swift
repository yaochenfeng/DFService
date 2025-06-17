import Foundation

public enum JSONValue: Codable, Hashable {
    public static var jsonEncode = JSONEncoder()
    public static var jsonDecoder = JSONDecoder()
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case list([JSONValue])
    case map([String: JSONValue])
    case data(Data)
    case null

    // MARK: - Init from Any
    public init?(obj: Any) {
        switch obj {
        case let value as String:
            self = .string(value)
        case let value as Bool:
            self = .bool(value)
        case let value as Int:
            self = .int(value)
        case let value as Double:
            self = .double(value)

        case let value as Data:
            self = .data(value)
        case let value as [Any]:
            self = .list(value.compactMap { JSONValue(obj: $0) })
        case let value as [String: Any]:
            var object = [String: JSONValue]()
            // map 根据key 排序
            for (key, val) in value {
                guard let jv = JSONValue(obj: val) else { return nil }
                object[key] = jv
            }
            self = .map(object)
        case let value as Encodable:
            do {
                let data = try JSONValue.jsonEncode.encode(value)
                if let jsonObject = try? JSONDecoder().decode(JSONValue.self, from: data) {
                    self = jsonObject
                } else {
                    self = .data(data)
                }

            } catch {
                return nil
            }
        case _ as NSNull:
            self = .null
        default:
            return nil
        }
    }

    // MARK: - To Any
    public func toAny() -> Any {
        switch self {
        case .string(let value): return value
        case .int(let value): return value
        case .double(let value): return value
        case .bool(let value): return value
        case .list(let array): return array.map { $0.toAny() }
        case .map(let dict): return dict.mapValues { $0.toAny() }
        case .data(let data): return data.base64EncodedString()
        case .null: return NSNull()
        }
    }

    // MARK: - Encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .list(let value): try container.encode(value)
        case .map(let value): try container.encode(value)
        case .data(let value): try container.encode(value.base64EncodedString())
        case .null: try container.encodeNil()
        }
    }

    // MARK: - Decode
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(String.self) {
            if let data = Data(base64Encoded: value), !data.isEmpty {
                self = .data(data)
            } else {
                self = .string(value)
            }
        } else if let value = try? container.decode([JSONValue].self) {
            self = .list(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .map(value)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Unknown JSONValue")
        }
    }

    // MARK: - Path Access
    public func value(at path: [String]) -> JSONValue? {
        guard !path.isEmpty else { return self }
        if case .map(let dict) = self {
            guard let first = path.first, let next = dict[first] else { return nil }
            return next.value(at: Array(path.dropFirst()))
        } else if case .list(let array) = self {
            guard let first = path.first, let index = Int(first), array.indices.contains(index)
            else { return nil }
            return array[index].value(at: Array(path.dropFirst()))
        }
        return nil
    }

    public func value(at path: String) -> JSONValue? {
        return value(at: path.components(separatedBy: "."))
    }

    // MARK: - Get<T>
    public func optional<T>(_ type: T.Type = T.self) -> T? {
        return try? to()
    }

    public func to<T>(type: T.Type = T.self) throws -> T {
        if let value = self as? T {
            return value
        }
        let value = toAny()
        if let obj: T = value as? T {
            return obj
        }
        throw ServiceError.castError(from: value, to: T.Type.self)
    }

    // MARK: - Decode to Model
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        if let value: T = optional() {
            return value
        } else if case .data(let data) = self {
            return try Self.jsonDecoder.decode(T.self, from: data)
        } else if case .string(let value) = self {
            guard let data = value.data(using: .utf8) else {
                throw NSError(
                    domain: "JSONValue", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid string encoding"])
            }
            return try Self.jsonDecoder.decode(T.self, from: data)
        }
        let obj = self.toAny()
        let data = try JSONSerialization.data(withJSONObject: obj, options: [])
        return try Self.jsonDecoder.decode(T.self, from: data)
    }

    // MARK: - Init from Model
    public init<T: Encodable>(from model: T) throws {
        let data = try Self.jsonEncode.encode(model)
        let any = try JSONSerialization.jsonObject(with: data)
        guard let json = JSONValue(obj: any) else {
            throw NSError(
                domain: "JSONValue", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Cannot convert model to JSONValue"])
        }
        self = json
    }
}

extension JSONValue: Equatable {}

extension JSONValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Any)...) {
        var dict = [String: JSONValue]()
        for (key, value) in elements {
            dict[key] = JSONValue(obj: value)
        }
        self = .map(dict)
    }
}
extension JSONValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Any...) {
        self = .list(elements.compactMap { JSONValue(obj: $0) })
    }
}

extension JSONValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let value): return "\"\(value)\""
        case .int(let value): return "\(value)"
        case .double(let value): return "\(value)"
        case .bool(let value): return "\(value)"
        case .list(let array):
            return "[" + array.map { $0.description }.joined(separator: ", ") + "]"
        case .map(let dict):
            let items = dict.map { "\"\($0)\": \($1.description)" }.sorted().joined(separator: ", ")
            return "{\(items)}"
        case .data(let data): return "\"\(data.base64EncodedString())\""
        case .null: return "null"
        }
    }
}
