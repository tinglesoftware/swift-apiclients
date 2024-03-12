//
//  AppDetailsMiddleware.swift
//  
//
//  Created by Maxwell Weru on 1/21/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

/**
 * An `TingleApiClientMiddleware` that adds headers for package id, version name and version code to a request before sending
*/
public final class AppDetailsMiddleware: TingleApiClientMiddleware {
    private let bundleId: String
    private let shortBundleVersion: String
    private let bundleVersion: String
    private let appKind: String

    /**
     * Initialize and instance of `AppDetailsMiddleware`
     *
     * - Parameter bundleId: The identifier of the application bundle
     * - Parameter shortBundleVersion: The short version of the application bundle
     * - Parameter bundleVersion: The version of the application bundle
     */
    public init (_ bundleId: String, _ shortBundleVersion: String, _ bundleVersion: String, _appKind: String) {
        self.bundleId = bundleId
        self.shortBundleVersion = shortBundleVersion
        self.bundleVersion = bundleVersion
        self.appKind = _appKind
    }
    
    /**
     * Process a request before sending
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    public func process(request: inout URLRequest) -> URLRequest {
        request.setValue(bundleId, forHTTPHeaderField: "X-App-Package-Id")
        request.setValue(shortBundleVersion, forHTTPHeaderField: "X-App-Version-Name")
        request.setValue(bundleVersion, forHTTPHeaderField: "X-App-Version-Code")
        request.setValue(appKind, forHTTPHeaderField: "X-App-Kind")

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
        
    }
}

