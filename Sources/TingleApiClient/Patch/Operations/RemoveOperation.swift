//
//  RemoveOperation.swift
//  
//
//  Created by Seth Onyango on 25/05/2020.
//

import Foundation

public class RemoveOperation: JsonPatchOperation{
    var path: String
    
    init(path: String){
        self.path = path
        super.init(op: "remove")
    }
}
