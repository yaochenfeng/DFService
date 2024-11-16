import Foundation

public protocol LoggerHandler {
    func log(
        level: LogService.Level,
        message: String,
        file: String,
        function: String,
        line: UInt
    )
}
public extension LoggerHandler {
    func debug(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        self.log(level: .debug, message: message(), file: file, function: function, line: line)
    }
    func info(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        self.log(level: .info, message: message(), file: file, function: function, line: line)
    }
    
    func error(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        self.log(level: .error, message: message(), file: file, function: function, line: line)
    }
}

public struct LogService: ServiceKey {
    public static let shared = Self.init()
    public static let name: String = "console.log"
    var tag: String
    public init() {
        self.init("main")
    }
    public init(_ tag: String) {
        self.tag = tag
    }
    
    public enum Level: String, Codable, CaseIterable {
        case trace
        case debug
        case info
        case warn
        case error
    }
}

extension Service: LoggerHandler where Base == LogService {
    
    
    public func log(
        level: LogService.Level,
        message: String,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        self(method: "log", args: level, message, file, function, line)
    }
}
