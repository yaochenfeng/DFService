public protocol DFLogHandle {
    func log(level: LogService.Level,
             message:  @autoclosure () -> String,
             file: String,
             function: String,
             line: UInt)
    
    var logLevel: LogService.Level { get }
}

public extension DFLogHandle {
    func log(level: LogService.Level,
             message: @autoclosure () -> String,
             file: String = #fileID,
             function: String = #function,
             line: UInt = #line) {
        guard logLevel >= level else { return }
        debugPrint("\(level) - \(file):\(line) - \(function) - \(message())")
    }
    
    func debug(_ message: @autoclosure () -> String,
             file: String = #fileID,
             function: String = #function,
             line: UInt = #line) {
        self.log(level: .debug, message: message(), file: file, function: function, line: line)
    }
    
    func info(_ message: @autoclosure () -> String,
              file: String = #fileID,
              function: String = #function,
              line: UInt = #line) {
         self.log(level: .info, message: message(), file: file, function: function, line: line)
     }
    
    func warning(_ message: @autoclosure () -> String,
              file: String = #fileID,
              function: String = #function,
              line: UInt = #line) {
         self.log(level: .warning, message: message(), file: file, function: function, line: line)
     }
    
    func error(_ message: @autoclosure () -> String,
              file: String = #fileID,
              function: String = #function,
              line: UInt = #line) {
         self.log(level: .error, message: message(), file: file, function: function, line: line)
     }
}


public struct LogService: DFApiService {
    public static var defaultValue: DFLogHandle {
        return MockApiServiceImpl()
    }
}

public extension LogService {
    enum Level: Comparable {
        case debug
        case info
        case warning
        case error
    }
}

extension MockApiServiceImpl: DFLogHandle {
    var logLevel: LogService.Level {
        .debug
    }
}
