//
//  AuthenticationHeaderProvider.swift
//  TingleApiClient
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class AuthenticationHeaderProvider: IAuthenticationProvider {
    private static let DEFAULT_SCHEME = "Bearer"
    
    public let scheme: String
    
    init(_ scheme: String = DEFAULT_SCHEME) {
        self.scheme = scheme
    }
    
    public func authenticate(request: inout URLRequest) {
        let parameter = getParameter(request: &request)
        let headerValue = "\(scheme) \(parameter)"
        request.setValue(headerValue, forHTTPHeaderField: "Authorization")
    }
    
    open func getParameter(request: inout URLRequest) -> String {
        fatalError("getParameter must be implemented")
    }
}
