//
//  MoveOperation.swift
//  
//
//  Created by Seth Onyango on 25/05/2020.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation


public class MoveOperation: JsonPatchOperation {
    var path: String
    var value: String
    
    init(path: String, value: String){
        self.path = path
        self.value = value
        super.init(op: "move")
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
