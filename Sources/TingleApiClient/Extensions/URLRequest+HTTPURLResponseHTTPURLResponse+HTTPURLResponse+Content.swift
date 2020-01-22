//
//  URLRequest+HTTPURLResponse+Content.swift
//  
//
//  Created by Maxwell Weru, Seth Onyango on 1/21/20.
//

import Foundation

extension URLRequest {
    public var contentType: String? {
        get {
            self.value(forHTTPHeaderField: "Content-Type")
        }
        set {
            self.setValue(newValue, forHTTPHeaderField: "Content-Type")
        }
    }
    
    public var bodyHasUnknownEncoding: Bool {
        get {
            let contentEncoding = self.value(forHTTPHeaderField: "Content-Encoding")
            return (contentEncoding != nil/*
                && contentEncoding!.caseInsensitiveCompare("identity") != .orderedSame
                && contentEncoding!.caseInsensitiveCompare("gzip") != .orderedSame*/)
        }
    }
}

extension HTTPURLResponse {
    public var contentType: String? {
        get {
            self.allHeaderFields["Content-Type"] as? String
        }
    }
    
    public var transferEncoding: String? {
        get {
            self.allHeaderFields["Transfer-Encoding"] as? String
        }
    }
    
    private var contentLength: Int64 {
        get {
            let raw = self.allHeaderFields["Content-Length", default: ""] as? String
            if (raw != nil && raw!.isEmpty) {
                return Int64(raw!) ?? -1
            }
            return -1
        }
    }
    
    var bodyHasUnknownEncoding: Bool {
        get {
            let contentEncoding = self.allHeaderFields["Content-Encoding"] as? String
            return (contentEncoding != nil
                && contentEncoding!.caseInsensitiveCompare("identity") != .orderedSame
                && contentEncoding!.caseInsensitiveCompare("gzip") != .orderedSame)
        }
    }
    
    var hasBody: Bool {
        get {
//            // HEAD requests never yield a body regardless of the response headers.
//            if (response.request().method().equals("HEAD")) {
//              return false;
//            }

            let responseCode = self.statusCode
            if ((responseCode < 100 || responseCode >= 200)
                && responseCode != 204
                && responseCode != 304) {
              return true;
            }

            // If the Content-Length or Transfer-Encoding headers disagree with the response code, the
            // response is malformed. For best compatibility, we honor the headers.
            if (contentLength != -1 || "chunked".caseInsensitiveCompare(transferEncoding ?? "") == .orderedSame) {
              return true;
            }

            return false;
        }
    }
}
