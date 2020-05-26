//
//  ReplaceOperation.swift
//  
//
//  Created by Seth Onyango on 25/05/2020.
//

import Foundation

public class ReplaceOperation: JsonPatchOperation{
    var path: String
    var value: Any?
    
    init(path: String, value: Any?){
        self.path = path
        self.value = value
        super.init(op: "replace")
    }
}
