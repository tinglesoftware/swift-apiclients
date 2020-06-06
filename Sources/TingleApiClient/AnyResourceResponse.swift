//
//  ResourceResponseBase.swift
//
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public final class AnyResourceResponse<TResource>: ResourceResponse {
    
    /**
     * The status code of the response
     */
    public let statusCode: Int
    
    /**
     * The headers of the response
     */
    public let headers: Any
    
    /**
     * The de-serialized resource
     */
    public let resource: TResource?
    
    /**
     * The error de-serialized from the response
     */
    public let problem: HttpApiResponseProblem?
    
    /**
     * - Parameter statusCode: The status code of the response.
     * - Parameter headers: The headers of the response
     * - Parameter resource: The de-serialized resource
     * - Parameter problem: The error de-serialized from the response
     */
    public init(statusCode: Int, headers: Any, resource: TResource?, problem: HttpApiResponseProblem?) {
        self.statusCode = statusCode
        self.headers = headers
        self.resource = resource
        self.problem = problem
    }
}
