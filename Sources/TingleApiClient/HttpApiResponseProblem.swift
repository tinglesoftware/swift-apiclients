//
//  HttpApiResponseProblem.swift
//
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class HttpApiResponseProblem: Codable {
    /**
     * A URI reference [RFC3986] that identifies the problem type. This specification encourages
     * that, when dereferenced, it provide human-readable documentation for the problem type
     * (e.g., using HTML [W3C.REC-html5-20141028]).  When this member is not present, its value
     * is assumed to be "about:blank".
     */
    public var type: String? = nil
    
    /**
     * A short, human-readable summary of the problem type.It SHOULD NOT change from occurrence
     * to occurrence of the problem, except for purposes of localization(e.g., using proactive
     * content negotiation; see[RFC7231], Section 3.4).
     */
    public var title: String? = nil
    
    /**
     * A human-readable explanation specific to this occurrence of the problem.
     */
    public var detail: String? = nil
    
    /**
     * A URI reference that identifies the specific occurrence of the problem.It may or may
     * not yield further information if dereferenced.
     */
    public var instance: String? = nil

    /**
     * Gets the validation errors associated with this instance of `HttpApiResponseProblem`.
     */
    public var errors: Dictionary<String, [String]>? = nil
 
    
    /**
     * The standard code for the error
     */
    public var error_code: String? = nil

    /**
     * The detailed description for the error.
     * Where provided, it can be used as a display message to the user in an interactive environment.
     */
    public var error_description: String? = nil

    /**
     * Gets the value for error_code if `title` is not set
     */
    public var code : String? {
        return title ?? error_code
    }

    /**
     * Gets the value for error_code if `detail` is not set
     */
    public var description : String? {
        return detail ?? error_description
    }
}
