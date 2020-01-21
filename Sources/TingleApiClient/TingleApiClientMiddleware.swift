//
//  TingleApiClientMiddleware.swift
//  
//
//  Created by Maxwell Weru on 1/16/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public protocol TingleApiClientMiddleware {
    /**
     * Process a request before sending
     * - Parameter request the request that needs to be processed before sending
     */
    func process(request: inout URLRequest) -> URLRequest

    /**
     * Process a response received
     * - Parameter response the response that needs to be processed
     * - Parameter data the data in the response
     * - Parameter error an error processing the request
     */
    func process(response: URLResponse?, data: Data?, error: Error?)
}
