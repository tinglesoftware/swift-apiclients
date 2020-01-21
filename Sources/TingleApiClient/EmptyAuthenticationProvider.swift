//
//  EmptyAuthenticationProvider.swift
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
public class EmptyAuthenticationProvider: IAuthenticationProvider {
    public func authenticate(request: inout URLRequest) {
        // nothing to do here
    }
}
