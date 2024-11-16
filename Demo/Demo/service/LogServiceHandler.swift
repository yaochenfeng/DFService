//
//  LogServiceHandler.swift
//  Demo
//
//  Created by yaochenfeng on 2024/11/17.
//

import Foundation
import DFService

struct LogServiceHandler: LoggerHandler, ServiceHandler {
    func callAsFunction(method: String, args: Any...) -> DFService.ServiceResult<Any, Error> {
        do {
            try self.log(level: AnyCodable(args[0]).as(),
                         message: AnyCodable(args[1]).as(),
                         file: AnyCodable(args[2]).as(),
                         function: AnyCodable(args[3]).as(),
                         line: AnyCodable(args[4]).as())
        } catch {
            return .sync(.failure(error))
        }
        return .none
    }
    
    func log(level: DFService.LogService.Level, message: String, file: String, function: String, line: UInt) {
        
    }
}
