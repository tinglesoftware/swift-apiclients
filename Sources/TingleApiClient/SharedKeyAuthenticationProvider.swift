//
//  SharedKeyAuthenticationProvider.swift
//  TingleApiClient
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation
import CryptoKit

public class SharedKeyAuthenticationProvider: AuthenticationHeaderProvider {
    private static let DEFAULT_DATE_HEADER_NAME = "x-ms-date"
    private static let DEFAULT_SCHEME = "SharedKey"

    private let dateHeaderName: String
    private let keyData: Data

    init (_ scheme: String, _ dateHeaderName: String, keyData: Data) {
        self.dateHeaderName = dateHeaderName
        self.keyData = keyData
        super.init(scheme)
    }

    convenience init (_ scheme: String, _ dateHeaderName: String, base64Key: String) {
        self.init(scheme, dateHeaderName, keyData: Data(base64Encoded: base64Key)!)
    }
    
    convenience init (_ dateHeaderName: String, keyData: Data) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_SCHEME, dateHeaderName, keyData: keyData)
    }

    convenience init (_ dateHeaderName: String, base64Key: String) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_SCHEME, dateHeaderName, base64Key: base64Key)
    }

    convenience init (_ keyData: Data) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_DATE_HEADER_NAME, keyData: keyData)
    }

    convenience init (base64Key: String) {
        self.init(SharedKeyAuthenticationProvider.DEFAULT_DATE_HEADER_NAME, base64Key: base64Key)
    }

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


    private func sign(method: String, contentLength: Int64, contentType: String, date: String, resource: String) -> String? {
        if #available(iOS 13.0, OSX 10.15, *) {
            // generate secret key
            let key = SymmetricKey(data: keyData)
            var hmac = HMAC<SHA256>(key: key)

            // generate data to hash
            let parts = [method, "\(contentLength)", contentType, "\(dateHeaderName):\(date)", resource]
            let stringToHash = parts.joined(separator: "\n")
            let dataToHash = stringToHash.data(using: .ascii, allowLossyConversion: false)!

            // hash the data
            hmac.update(data: dataToHash)
            let hashed = hmac.finalize()
            let bytes = hashed.compactMap { $0 }
            let hashedData = Data(bytes)

            // encode to base 64
            return hashedData.base64EncodedString()

        } else {
            // Fallback on earlier versions

            return nil
        }
    }
}
