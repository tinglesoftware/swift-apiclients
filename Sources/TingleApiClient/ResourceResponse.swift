//
//  ResourceResponse.swift
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public protocol ResourceResponse {
    associatedtype TResource
    
    /**
     * The status code of the response
     */
    var statusCode: Int { get }
    
    /**
     * The headers of the response
     */
    var headers: Any { get }
    
    /**
     * The de-serialized resource
     */
    var resource: TResource? { get }
    
    /**
     * The error de-serialized from the response
     */
    var problem: HttpApiResponseProblem? { get }
    
    /**
     * - Parameter statusCode: The status code of the response.
     * - Parameter headers: The headers of the response
     * - Parameter resource: The de-serialized resource
     * - Parameter problem: The error de-serialized from the response
     */
    init(statusCode: Int, headers: Any, resource: TResource?, problem: HttpApiResponseProblem?)
}

extension ResourceResponse {
    
    public var isUnauthorized: Bool { statusCode == 401 }

    public var successful: Bool { 200...299 ~= statusCode }
}
