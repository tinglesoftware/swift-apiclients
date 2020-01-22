//
//  AppDetailsMiddleware.swift
//  
//
//  Created by Maxwell Weru on 1/21/20.
//

import Foundation

/**
 * An `TingleApiClientMiddleware` that adds headers for package id, version name and version code to a request before sending
*/
public final class AppDetailsMiddleware: TingleApiClientMiddleware {
    private let bundleId: String
    private let shortBundleVersion: String
    private let bundleVersion: String

    /**
     * Intitialize and instance of `AppDetailsMiddleware`
     *
     * - Parameter bundleId: The identifier of the application bundle
     * - Parameter shortBundleVersion: The short version of the application bundle
     * - Parameter bundleVersion: The version of the application bundle
     */
    public init (_ bundleId: String, _ shortBundleVersion: String, _ bundleVersion: String) {
        self.bundleId = bundleId
        self.shortBundleVersion = shortBundleVersion
        self.bundleVersion = bundleVersion
    }
    
    /**
     * Process a request before sending
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    public func process(request: inout URLRequest) -> URLRequest {
        request.setValue(bundleId, forHTTPHeaderField: "AppPackageId")
        request.setValue(shortBundleVersion, forHTTPHeaderField: "AppVersionName")
        request.setValue(bundleVersion, forHTTPHeaderField: "AppVersionCode")

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

