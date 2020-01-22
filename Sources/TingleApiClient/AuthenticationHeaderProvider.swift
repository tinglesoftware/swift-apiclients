//
//  AuthenticationHeaderProvider.swift
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

/**
 * Implementation of `IAuthenticationProvider` which sets the Authorization header using the scheme and parameter separated by a space.
 * The parameter set is gotten from the abstract method `getParameter(request: inout URLRequest)`.
 */
open class AuthenticationHeaderProvider: IAuthenticationProvider {
    private static let DEFAULT_SCHEME = "Bearer"
    
    /**
     * The scheme to be set in the `Authorization` header
     */
    public let scheme: String
    
    /**
     * Initializes an instance of `AuthenticationHeaderProvider`
     * - Parameter scheme: The scheme to set in the `Authorization` header
     */
    public init(_ scheme: String = DEFAULT_SCHEME) {
        self.scheme = scheme
    }
    
    /**
     * Process a request before sending
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    public func process(request: inout URLRequest) -> URLRequest {
        let parameter = getParameter(request: &request)
        let headerValue = "\(scheme) \(parameter)"
        request.setValue(headerValue, forHTTPHeaderField: "Authorization")
        return request
    }
    
    /**
     * Gets the paramter that should be included in the `Authorization` header
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    open func getParameter(request: inout URLRequest) -> String {
        fatalError("getParameter must be implemented")
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
