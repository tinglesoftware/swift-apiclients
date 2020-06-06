//
//  AddOperation.swift
//
//
//  Created by Seth Onyango on 25/05/2020.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

public class AddOperation<TValue: Encodable> : JsonPatchOperation {
    var path: String
    var value: TValue
    
    init(path: String, value: TValue){
        self.path = path
        self.value = value
        super.init(op: "add")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.path, forKey: .path)
        try container.encode(self.value, forKey: .value)
    }
    
    private enum CodingKeys: String, CodingKey {
        case path, value
    }
}
