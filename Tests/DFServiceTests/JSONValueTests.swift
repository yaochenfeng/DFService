//
//  JSONValueTests.swift
//  DFService
//
//  Created by yaochenfeng on 2025/6/17.
//

import XCTest

@testable import DFService

final class JSONValueTests: XCTestCase {
    func testInitFromPrimitiveTypes() {
        XCTAssertEqual(JSONValue(obj: "hello"), .string("hello"))
        XCTAssertEqual(JSONValue(obj: 42), .int(42))
        XCTAssertEqual(JSONValue(obj: 3.14), .double(3.14))
        XCTAssertEqual(JSONValue(obj: true), .bool(true))
        XCTAssertEqual(JSONValue(obj: NSNull()), .null)
    }

    func testInitFromArray() {
        let arr: [Any] = ["a", 1, false]
        let json = JSONValue(obj: arr)
        XCTAssertEqual(json, .list([.string("a"), .int(1), .bool(false)]))
    }

    func testInitFromDictionary() {
        let dict: [String: Any] = ["a": 1, "b": "str", "c": false]
        let json = JSONValue(obj: dict)
        XCTAssertEqual(
            json,
            .map([
                "a": .int(1),
                "b": .string("str"),
                "c": .bool(false),
            ]))
    }

    func testToAny() {
        let json: JSONValue = .map([
            "a": .int(1),
            "b": .string("str"),
            "c": .list([.bool(true), .null]),
        ])
        let any = json.toAny() as? [String: Any]
        XCTAssertEqual(any?["a"] as? Int, 1)
        XCTAssertEqual(any?["b"] as? String, "str")
        let arr = any?["c"] as? [Any]
        XCTAssertEqual(arr?.first as? Bool, true)
    }

    func testEncodeDecode() throws {
        let original: JSONValue = .map([
            "int": .int(1),
            "double": .double(2.5),
            "string": .string("abc"),
            "bool": .bool(false),
            "array": .list([.int(1), .null]),
            "null": .null,
        ])
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testDataEncodingDecoding() throws {
        let raw = "hello".data(using: .utf8)!
        let json = JSONValue.data(raw)
        let data = try JSONEncoder().encode(json)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        if case .data(let d) = decoded {
            XCTAssertEqual(d, raw)
        } else {
            XCTFail("Expected .data case")
        }
    }

    func testValueAtPath() {
        let json: JSONValue = .map([
            "a": .map([
                "b": .list([
                    .map(["c": .string("value")])
                ])
            ])
        ])
        XCTAssertEqual(json.value(at: ["a", "b", "0", "c"]), .string("value"))
        XCTAssertNil(json.value(at: ["a", "x"]))
    }

    func testGetGeneric() {
        XCTAssertEqual(JSONValue.int(5).optional(Int.self), 5)
        XCTAssertEqual(JSONValue.string("abc").optional(String.self), "abc")
        XCTAssertNil(JSONValue.null.optional(Int.self))
    }

    struct Dummy: Codable, Equatable {
        let a: Int
        let b: String
    }

    func testDecodeToModel() throws {
        let json: JSONValue = .map([
            "a": .int(10),
            "b": .string("test"),
        ])
        let model = try json.decode(Dummy.self)
        XCTAssertEqual(model, Dummy(a: 10, b: "test"))
    }

    func testInitFromModel() throws {
        let model = Dummy(a: 7, b: "foo")
        let json = try JSONValue(from: model)
        XCTAssertEqual(
            json,
            .map([
                "a": .int(7),
                "b": .string("foo"),
            ]))
    }

    func testEquatable() {
        let json1: JSONValue = .map(["key": .int(1)])
        let json2: JSONValue = .map(["key": .int(1)])
        let json3: JSONValue = .map(["key": .int(2)])

        XCTAssertEqual(json1, json2)
        XCTAssertNotEqual(json1, json3)
        XCTAssertNotEqual(json2, json3)
    }
    func testHashable() {
        let json1: JSONValue = .map(["key": .int(1)])
        let json2: JSONValue = .map(["key": .int(1)])
        let json3: JSONValue = .map(["key": .int(2)])

        let set: Set<JSONValue> = [json1, json2, json3]
        XCTAssertEqual(set.count, 2)  // json1 and json2 are equal
    }

    //测试模型转换
    func testModelConversion() throws {
        _ = UserProfile(id: 123, name: "Alice", email: "sds")
    }
    func testNullEqualityAndHashing() {
        XCTAssertEqual(JSONValue.null, JSONValue.null)
        XCTAssertEqual(JSONValue.null.hashValue, JSONValue.null.hashValue)
    }

    func testArrayWithNulls() {
        let arr: [Any] = [NSNull(), 1, "a"]
        let json = JSONValue(obj: arr)
        XCTAssertEqual(json, .list([.null, .int(1), .string("a")]))
    }

    func testObjectWithNestedArrayAndObject() {
        let dict: [String: Any] = [
            "arr": [1, 2, 3],
            "obj": ["x": "y"],
        ]
        let json = JSONValue(obj: dict)
        XCTAssertEqual(
            json,
            .map([
                "arr": .list([.int(1), .int(2), .int(3)]),
                "obj": .map(["x": .string("y")]),
            ])
        )
    }

    func testGetWithWrongType() {
        XCTAssertNil(JSONValue.int(1).optional(String.self))
        XCTAssertNil(JSONValue.string("abc").optional(Int.self))
    }

    func testDecodeInvalidModelThrows() {
        let json: JSONValue = .string("{\"id\":1,name:\"test\",email:\"sd@qq.com\"}")
        // Decoding a JSONValue that does not match the expected model should throw an error
        XCTAssertThrowsError(try json.decode(UserProfile.self))
    }

    func testInitFromInvalidObjReturnsNil() {
        class DummyClass {}
        let dummy = DummyClass()
        XCTAssertNil(JSONValue(obj: dummy))
    }

    func testDataCaseToAny() {
        let data = "abc".data(using: .utf8)!
        let json = JSONValue.data(data)
        let any = json.toAny()
        XCTAssertEqual(any as? String, data.base64EncodedString())
    }

    func testValueAtPathString() {
        let json: JSONValue = .map([
            "a": .map([
                "b": .string("found")
            ])
        ])
        XCTAssertEqual(json.value(at: "a.b"), .string("found"))
        XCTAssertNil(json.value(at: "a.c"))
    }

    func testDecodeDataFromBase64String() throws {
        let data = "hello".data(using: .utf8)!
        let base64 = data.base64EncodedString()
        let jsonString = "\"\(base64)\""
        let decoded = try JSONDecoder().decode(JSONValue.self, from: jsonString.data(using: .utf8)!)
        if case .data(let d) = decoded {
            XCTAssertEqual(d, data)
        } else {
            XCTFail("Expected .data case")
        }
    }

    func testInitFromModelWithNestedStruct() throws {
        struct Nested: Codable, Equatable {
            let user: UserProfile
            let active: Bool
        }
        let json1: JSONValue = ["a": 1, "b": 2]
        let json2: JSONValue = ["b": 2, "a": 1]
        XCTAssertEqual(json1, json2)
        let nested = Nested(user: UserProfile(id: 1, name: "n", email: "e"), active: true)
        let obj1 = JSONValue(obj: nested)
        let obj2: JSONValue = .map([
            "user": .map([
                "id": .int(1),
                "name": .string("n"),
                "email": .string("e"),
            ]),
            "active": .bool(true),
        ])
        let obj3: JSONValue = .map([
            "active": .bool(true),
            "user": .map([
                "id": .int(1),
                "name": .string("n"),
                "email": .string("e"),
            ]),

        ])
        XCTAssertEqual(
            obj3,
            obj2
        )
        XCTAssertEqual(
            obj1,
            obj2
        )
    }

    func testExpressibleByDictionaryLiteral() {
        let json: JSONValue = ["foo": 1, "bar": "baz", "flag": true]
        XCTAssertEqual(
            json,
            .map([
                "foo": .int(1),
                "bar": .string("baz"),
                "flag": .bool(true),
            ])
        )
    }

    func testExpressibleByArrayLiteral() {
        let json: JSONValue = [1, "a", false]
        XCTAssertEqual(json, .list([.int(1), .string("a"), .bool(false)]))
    }

    func testCustomStringConvertible() {
        let json: JSONValue = .map([
            "num": .int(1),
            "str": .string("abc"),
            "arr": .list([.bool(true), .null]),
        ])
        let desc = json.description
        XCTAssertTrue(desc.contains("\"num\": 1"))
        XCTAssertTrue(desc.contains("\"str\": \"abc\""))
        XCTAssertTrue(desc.contains("\"arr\": [true, null]"))
    }

    func testNullDescription() {
        XCTAssertEqual(JSONValue.null.description, "null")
    }

    func testDecodeInvalidJSONThrows() {
        let invalidData = "not a json".data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(JSONValue.self, from: invalidData))
    }

    func testInitFromEncodableFallbackToData() {
        struct NotCodable {}
        // NotCodable is not Encodable, so JSONValue(obj:) should return nil
        XCTAssertNil(JSONValue(obj: NotCodable()))
    }

    func testMapWithUnconvertibleValueReturnsNil() {
        class DummyClass {}
        let dict: [String: Any] = ["a": DummyClass()]
        XCTAssertNil(JSONValue(obj: dict))
    }

    func testListWithUnconvertibleValueSkipsNil() {
        class DummyClass {}
        let arr: [Any] = [1, DummyClass(), 2]
        let json = JSONValue(obj: arr)
        // Only convertible values should be present
        XCTAssertEqual(json, .list([.int(1), .int(2)]))
    }

    func testValueAtPathWithArrayIndexOutOfBounds() {
        let json: JSONValue = .list([.int(1)])
        XCTAssertNil(json.value(at: ["2"]))
    }

    func testValueAtPathWithNonIntArrayIndex() {
        let json: JSONValue = .list([.int(1)])
        XCTAssertNil(json.value(at: ["foo"]))
    }

    func testGetWithArrayAndMap() {
        let arr: JSONValue = .list([.int(1), .int(2)])
        let dict: JSONValue = .map(["a": .int(1)])
        XCTAssertEqual(arr.optional(JSONValue.self), [JSONValue.int(1), JSONValue.int(2)])
        XCTAssertEqual(dict.optional(JSONValue.self), ["a": JSONValue.int(1)])
    }

    func testDecodeStringAsModel() throws {
        struct S: Codable, Equatable { let value: String }
        let json: JSONValue = .string("{\"value\":\"abc\"}")
        XCTAssertNoThrow(try json.decode(S.self))
    }

    func testEncodeDecodeNull() throws {
        let json: JSONValue = .null
        let data = try JSONEncoder().encode(json)
        let decoded = try JSONDecoder().decode(JSONValue.self, from: data)
        XCTAssertEqual(decoded, .null)
    }

    func testEncodeDecodeEmptyArrayAndObject() throws {
        let arr: JSONValue = .list([])
        let obj: JSONValue = .map([:])
        let arrData = try JSONEncoder().encode(arr)
        let objData = try JSONEncoder().encode(obj)
        let arrDecoded = try JSONDecoder().decode(JSONValue.self, from: arrData)
        let objDecoded = try JSONDecoder().decode(JSONValue.self, from: objData)
        XCTAssertEqual(arr, arrDecoded)
        XCTAssertEqual(obj, objDecoded)
    }

    func testDescriptionForData() {
        let data = "abc".data(using: .utf8)!
        let json = JSONValue.data(data)
        XCTAssertTrue(json.description.contains(data.base64EncodedString()))
    }
}

struct UserProfile: Codable, Equatable {
    let id: Int
    let name: String
    let email: String
}
