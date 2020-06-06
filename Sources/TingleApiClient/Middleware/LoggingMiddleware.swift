//
//  LoggingMiddleware.swift
//  
//
//  Created by Maxwell Weru on 1/21/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation
import Logging

/**
 * An `TingleApiClientMiddleware` that logs the outgoing request (`URLRequest`) and the incoming response (`URLResponse`)
*/
public final class LoggingMiddleware: TingleApiClientMiddleware {
    
    private let logger: Logger
    
    public var logLevel: Logger.Level
    public var level: Level
    
    /**
     * Initialize an instance of `LoggingMiddleware` for using with an instance of `TingleApiClient`
     *
     * - Parameter level: The level of data from a request/response to log. This defaults to `.NONE`.
     * - Parameter logLevel: The logging level to use when writing the logs to the output. This depends on the logging implementation in use. The default level is `.trace`
     * - Parameter loggerLabel: The lable to use for use when logging. This is useful for filtering logs. When not provided, it defaults to the name of this class i.e.`String(describing: LoggingMiddleware.self)`
     */
    public init(_ level: Level = .NONE, _ logLevel: Logger.Level = Logger.Level.trace, loggerLabel: String = String(describing: LoggingMiddleware.self)) {
        self.logger = Logger(label: loggerLabel)
        self.level = level
        self.logLevel = logLevel
    }
    
    /**
     * Process a request before sending
     * 
     * - Parameter request: The request that needs to be processed before sending
     */
    public func process(request: inout URLRequest) -> URLRequest {
        log(request: request)
        return request
    }
    
    /**
     * Process a response received
     *
     * - Parameter response: The response that needs to be processed
     * - Parameter data: The data in the response
     * - Parameter error: An error processing the request
     */
    public func process(response: URLResponse?, data: Data?, error: Error?) {
        log(response: response, data: data, error: error)
    }
    
    private func log(request: URLRequest) {
        if (level == .NONE) {
            return
        }
        
        let logBody = level == .BODY;
        let logHeaders = logBody || level == .HEADERS;
        
        let requestBody = request.httpBody
        let hasRequestBody = requestBody != nil;
        var requestStartMessage = "--> \(request.httpMethod!) \(request.url!)"
        if (!logHeaders && hasRequestBody) {
            requestStartMessage += " (\(requestBody!.count)-byte body)";
        }
        
        logger.log(level: logLevel, Logger.Message(stringLiteral: requestStartMessage))
        
        if (logHeaders) {
            if (hasRequestBody) {
                // Request body headers are only present when installed as a network interceptor. Force
                // them to be included (when available) so there values are known.
                if (request.contentType != nil) {
                    logger.log(level: logLevel, "Content-Type: \(request.contentType!)");
                }
                logger.log(level: logLevel, "Content-Length: \(requestBody!.count)");
            }
            
            request.allHTTPHeaderFields?.forEach({ (arg0) in
                
                let (key, value) = arg0
                if ("Content-Type".caseInsensitiveCompare(key) != .orderedSame
                    && "Content-Length".caseInsensitiveCompare(key) != .orderedSame) {
                    
                    let v = value // TODO: check if this headers should be redacted
                    logger.log(level: logLevel, "\(key): \(v)")
                }
            })
            
            if (!logBody || !hasRequestBody) {
                logger.log(level: logLevel, "--> END \(request.httpMethod!)");
            } else if (request.bodyHasUnknownEncoding) {
                logger.log(level: logLevel, "--> END \(request.httpMethod!) (encoded body omitted)");
            } else {
                logger.log(level: logLevel, "");
                if let bs = String(data: requestBody!, encoding: .utf8) {
                    logger.log(level: logLevel, Logger.Message(stringLiteral: bs));
                    logger.log(level: logLevel, "--> END \(request.httpMethod!) (\(requestBody!.count)-byte body)");
                } else {
                    logger.log(level: logLevel, "--> END \(request.httpMethod!) (binary \(requestBody!.count)-byte body omitted)");
                }
            }
        }
    }
    
    private func log(response: URLResponse?, data: Data?, error: Error?) {
        if (error != nil) {
            logger.log(level: logLevel, "<-- HTTP FAILED: \(error.debugDescription)");
            return
        }
        
        let response = response as? HTTPURLResponse
        if (response == nil) {
            // TODO: log this unormally
            return
        }
        
        let logBody = level == .BODY;
        let logHeaders = logBody || level == .HEADERS;
        
        let tookMs: Int64 = -1 // TODO: find a way of getting how long it took to get the response
        let responseBody = data
        let contentLength = responseBody?.count ?? -1
        let bodySize = contentLength != -1 ? "\(contentLength)-byte" : "unknown-length"
        
        let startMessageTail = !logHeaders ? ", \(bodySize) body" : ""
        logger.log(level: logLevel, "<-- \(response!.statusCode) \(response!.url!) (\(tookMs)ms \(startMessageTail))");
        
        if (logHeaders) {
            
            response!.allHeaderFields.forEach({ (arg0) in
                
                let (key, value) = arg0
                if let key = key as? String {
                    var raw_v = ""
                    if let value = value as? String {
                        raw_v = value
                    } else if let value = value as? [String] {
                        raw_v = value.joined(separator: ", ")
                    }
                    let v = raw_v // TODO: check if this headers should be redacted
                    logger.log(level: logLevel, "\(key): \(v)")
                }
            })
            
            if (!logBody || !response!.hasBody) {
                logger.log(level: logLevel, "<-- END HTTP");
            } else if (response!.bodyHasUnknownEncoding) {
                logger.log(level: logLevel, "<-- END HTTP (encoded body omitted)");
            } else {
                let bs = String(data: responseBody!, encoding: .utf8)
                if bs == nil {
                    logger.log(level: logLevel, "");
                    logger.log(level: logLevel, "<-- END HTTP (binary \(contentLength)-byte body omitted)");
                    return
                }
                
                if (contentLength != 0) {
                    logger.log(level: logLevel, "");
                    logger.log(level: logLevel, Logger.Message(stringLiteral: bs!));
                }
                
                logger.log(level: logLevel, "<-- END HTTP (\(contentLength)-byte body)");
            }
        }
    }
    
    public enum Level {
        /** No logs. */
        case NONE
        
        /**
         * Logs request and response lines.
         *
         * Example:
         * ```
         * --> POST /greeting http/1.1 (3-byte body)
         *
         * <-- 200 OK (22ms, 6-byte body)
         * ```
         */
        case BASIC
        
        /**
         * Logs request and response lines and their respective headers.
         *
         * Example:
         * ```
         * --> POST /greeting http/1.1
         * Host: example.com
         * Content-Type: plain/text
         * Content-Length: 3
         * --> END POST
         *
         * <-- 200 OK (22ms)
         * Content-Type: plain/text
         * Content-Length: 6
         * <-- END HTTP
         * ```
         */
        case HEADERS
        
        /**
         * Logs request and response lines and their respective headers and bodies (if present).
         *
         * Example:
         * ```
         * --> POST /greeting http/1.1
         * Host: example.com
         * Content-Type: plain/text
         * Content-Length: 3
         *
         * Hi?
         * --> END POST
         *
         * <-- 200 OK (22ms)
         * Content-Type: plain/text
         * Content-Length: 6
         *
         * Hello!
         * <-- END HTTP
         * ```
         */
        case BODY
    }
}
