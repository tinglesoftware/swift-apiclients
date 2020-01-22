//
//  ResourceResponse.swift
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class ResourceResponse<TResource>: ResourceResponseBase<TResource, HttpApiResponseProblem> {
    
    /**
     * - Parameter statusCode: The status code of the response.
     * - Parameter headers: The headers of the response
     * - Parameter resource: The de-serialized resource
     * - Parameter problem: The error de-serialized from the response
     */
    public override init(statusCode: Int, headers: Any, resource: TResource?, problem: HttpApiResponseProblem?) {
        super.init(statusCode: statusCode, headers: headers, resource: resource, problem: problem)
    }
}
