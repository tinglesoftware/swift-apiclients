//
//  ResourceResponseBase.swift
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class ResourceResponseBase<TResource, TProblem> where TProblem : HttpApiResponseProblem {
    
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
    public let problem: TProblem?
    
    /**
     * - Parameter statusCode: The status code of the response.
     * - Parameter headers: The headers of the response
     * - Parameter resource: The de-serialized resource
     * - Parameter problem: The error de-serialized from the response
     */
    public init(statusCode: Int, headers: Any, resource: TResource?, problem: TProblem?) {
        self.statusCode = statusCode
        self.headers = headers
        self.resource = resource
        self.problem = problem
    }
    
    public var isUnauthorized: Bool { return statusCode == 401 }

    public var successful: Bool { return 200...299 ~= statusCode }
}
