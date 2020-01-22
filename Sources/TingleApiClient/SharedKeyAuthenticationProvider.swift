//
//  SharedKeyAuthenticationProvider.swift
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation
import CryptoSwift

/**
 * Implementation of `IAuthenticationProvider` for SharedKey authentication scheme.
 * This is mainly used for Tingle APIs/Services but can be modified to be used with Microsoft APIs.
 *
 * The implementation generates a token based on the HTTP method, path, time, content length and
 * content type, then hashing using the pre-shared key (PSK). The hashing algorithm is HMACSHA256.
 */
public final class SharedKeyAuthenticationProvider: AuthenticationHeaderProvider {
    private static let DEFAULT_DATE_HEADER_NAME = "x-ms-date"
    private static let DEFAULT_SCHEME = "SharedKey"

    private let dateHeaderName: String
    private let keyData: Data

    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter scheme: The scheme to set in the `Authorization` header
     * - Parameter dateHeaderName: The name to use when setting the date header
     * - Parameter keyData: The bytes for the key used for signing
     */
    public init (_ scheme: String, _ dateHeaderName: String, keyData: Data) {
        self.dateHeaderName = dateHeaderName
        self.keyData = keyData
        super.init(scheme)
    }

    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter scheme: The scheme to set in the `Authorization` header
     * - Parameter dateHeaderName: The name to use when setting the date header
     * - Parameter base64Key: The string key for signing encoded in base64
     */
    public convenience init (_ scheme: String, _ dateHeaderName: String, base64Key: String) {
        self.init(scheme, dateHeaderName, keyData: Data(base64Encoded: base64Key)!)
    }
    
    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter scheme: The scheme to set in the `Authorization` header
     * - Parameter keyData: The bytes for the key used for signing
     */
    public convenience init (_ dateHeaderName: String, keyData: Data) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_SCHEME, dateHeaderName, keyData: keyData)
    }

    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter dateHeaderName: The name to use when setting the date header
     * - Parameter base64Key: The string key for signing encoded in base64
*/
    public convenience init (_ dateHeaderName: String, base64Key: String) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_SCHEME, dateHeaderName, base64Key: base64Key)
    }

    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter keyData: The bytes for the key used for signing
     */
    public convenience init (_ keyData: Data) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_DATE_HEADER_NAME, keyData: keyData)
    }

    /**
     * Initializes an instance of `SharedKeyAuthenticationProvider`
     * - Parameter base64Key: The string key for signing encoded in base64
     */
    public convenience init (base64Key: String) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_DATE_HEADER_NAME, base64Key: base64Key)
    }

    /**
     * Gets the paramter that should be included in the `Authorization` header
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    override public func getParameter(request: inout URLRequest) -> String {
        // get the known parts required for signing
        let method = request.httpMethod!
        let path = (request.url?.path)!
        let contentType = request.value(forHTTPHeaderField: "Content-Type") ?? ""
        let contentLength = request.httpBody?.count ?? 0

        // get the specified rf date or otherwise set it
        var rfcDate = request.value(forHTTPHeaderField: dateHeaderName)
        if (rfcDate?.isEmpty ?? true) {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'" // RFC
            rfcDate = formatter.string(from: Date())
            request.setValue(rfcDate, forHTTPHeaderField: dateHeaderName)
        }
        
        // return the signed version
        return sign(method: method, contentLength: Int64(contentLength), contentType: contentType, date: rfcDate!, resource: path)!
    }

    /**
     * Sign request parts to produce the authorization parameter
     *
     * - Parameter method: The HTTP request method
     * - Parameter contentLength: The value for the `Content-Length`header
     * - Parameter contentType: The value for the `Content-Type`header
     * - Parameter date: The date alue used to make the request, set in the header with key specified by `dateHeaderName`
     * - Parameter resource: The resource that is being accessed
     */
    private func sign(method: String, contentLength: Int64, contentType: String, date: String, resource: String) -> String? {

        // generate data to hash
        let parts = [method, "\(contentLength)", contentType, "\(dateHeaderName):\(date)", resource]
        let stringToHash = parts.joined(separator: "\n")
        let dataToHash = stringToHash.data(using: .ascii, allowLossyConversion: false)!
        
        let key = keyData.compactMap { $0 }
        let bytes = dataToHash.compactMap { $0 }
        
        // hash the data
        let hmac = HMAC(key: key, variant: .sha256)
        if let hashed = try? hmac.authenticate(bytes) {
            let hashedData = Data(hashed.compactMap { $0 })
            
            // encode to base 64
            return hashedData.base64EncodedString()
        }
        
        return nil
    }
}
