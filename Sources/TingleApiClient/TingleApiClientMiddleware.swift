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
     * Authenticate a request before sending
     * - Parameter request the request that needs to be authenticated before sending
     */
    func process(request: inout URLRequest) -> URLRequest
}
