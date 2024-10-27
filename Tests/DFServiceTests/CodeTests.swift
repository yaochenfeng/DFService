import XCTest
@testable import DFService

import Foundation

class Book: Codable {
    var title: String
    var author: String
    var publicationDate: Date?
    var genre: String?
    var pages: Int

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case publicationDate = "publication_date"
        case genre
        case pages
    }

    required init(title: String, author: String, publicationDate: Date?, genre: String?, pages: Int) {
        self.title = title
        self.author = author
        self.publicationDate = publicationDate
        self.genre = genre
        self.pages = pages
    }
    
    // 自定义解码器
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 必须字段
        let title = try container.decode(String.self, forKey: .title)
        let author = try container.decode(String.self, forKey: .author)
        let pages = try container.decode(Int.self, forKey: .pages)
        
        // 验证页数
        guard pages >= 0 else {
            throw DecodingError.dataCorruptedError(forKey: .pages,
                                                   in: container,
                                                   debugDescription: "Pages cannot be negative")
        }

        // 可选字段
        let dateString = try container.decodeIfPresent(String.self, forKey: .publicationDate)
        let publicationDate = dateString.flatMap { Book.dateFormatter.date(from: $0) }
        
        // 设定默认值
        let genre = try container.decodeIfPresent(String.self, forKey: .genre) ?? "Unknown"
        
        // 初始化对象
        self.init(title: title, author: author, publicationDate: publicationDate, genre: genre, pages: pages)
    }
}


extension Book {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // 自定义日期格式
        return formatter
    }()

    

    // 自定义编码器
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(author, forKey: .author)
        try container.encode(pages, forKey: .pages)
        
        // 日期格式化
        if let publicationDate = publicationDate {
            let dateString = Book.dateFormatter.string(from: publicationDate)
            try container.encode(dateString, forKey: .publicationDate)
        }
        
        // 编码默认值
        try container.encode(genre, forKey: .genre)
    }
}


final class DFSerTests: XCTestCase {
    func testDecoder() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        
        do {
            let jsonData = """
            {
                "double": 3.1415899999999999,
                "string": "Hello, World!",
                "int": 42,
                "book": {
                    "author": "John Doe",
                    "title": "Swift Programming",
                    "pages": 250,
                    "publication_date": "2024-10-28",
                    "genre": null
                },
                "dictionary": {
                    "nestedKey": "nestedValue"
                },
                "bool": true,
                "array": [
                    1,
                    2,
                    3
                ]
            }
            """.data(using: .utf8)!
            let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: jsonData)
            print(decoded)
            
            let encodedData = try JSONEncoder().encode(decoded)
            print(String(data: encodedData, encoding: .utf8)!)
        } catch {
            print("Error decoding or encoding JSON: \(error)")
        }
        
    }
    
    func testEncode() async throws {
        let book = Book(title: "Swift Programming", author: "John Doe", publicationDate: Date(), genre: nil, pages: 250)

        let json: [String: AnyCodable] = [
            "string": AnyCodable("Hello, World!"),
            "int": AnyCodable(42),
            "double": AnyCodable(3.14159),
            "bool": AnyCodable(true),
            "array": AnyCodable([1, 2, 3]),
            "dictionary": AnyCodable([ "nestedKey": "nestedValue" ]),
            "book": AnyCodable(book)
        ]
        do {
            
            let encodedData = try JSONEncoder().encode(json)
            let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: encodedData)
            let jsonString = String(data: encodedData, encoding: .utf8)
            print(jsonString)
            print(String(data: encodedData, encoding: .utf8)!)
        } catch {
            print("Error decoding or encoding JSON: \(error)")
        }
        Application.shared[.logger] = LogService.self
    }
}
