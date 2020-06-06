//
//  EmptyAuthenticationProvider.swift
//
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

/**
 * The default implementation for `IAuthenticationProvider` which does not modify the request message at all.
 * Use this to make requests to services that do not need authentication or to test authentication.
 * This can also be used to find out the supported authentication methods as is presented in the 'WWW-Authentication' header
 * of a response message `ResourceResponse`
*/
public final class EmptyAuthenticationProvider: IAuthenticationProvider {

    /**
     * Process a request before sending
     *
     * - Parameter request: The request that needs to be processed before sending
     */
    public func process(request: inout URLRequest) -> URLRequest {
        // nothing to do here
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
