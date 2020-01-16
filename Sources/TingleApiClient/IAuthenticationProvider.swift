//
//  IAuthenticationProvider.swift
//  TingleApiClient
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public protocol IAuthenticationProvider {
    /**
     * Authenticate a request before sending
     * - Parameter request the request that needs to be authenticated before sending
     */
    func authenticate(request: inout URLRequest) -> Void
}
