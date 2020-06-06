//
//  JsonPatchOperation.swift
//
//
//  Created by Seth Onyango on 24/05/2020.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class JsonPatchOperation: Encodable {
    public var op: String
    
    init(op: String) {
        self.op = op
    }
}
