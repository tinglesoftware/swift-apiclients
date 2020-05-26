//
//  JsonPatchDocument.swift
//  
//
//  Created by Seth Onyango on 24/05/2020.
//

import Foundation

public class JsonPatchDocument {
    private var operations = [JsonPatchOperation]()
    
    
    /**
     * Add Operation. Will result in, for example
     * { "op": "add", "path": "/a/b/c", "value": [ "foo", "bar" ] }
     *
     * - Parameter path  target location
     * - Parameter value value to be added
     */
    func add(path: String, value: Any?) -> JsonPatchDocument{
        operations.append(AddOperation(path: path, value: value))
        return self
    }
    
    
    /**
     * Remove value at target location, Will result in, for example,
     * { "op": "remove", "path": "/a/b/c" }
     *
     * - Parameter path target location
     */
    func remove(path: String) -> JsonPatchDocument{
        operations.append(RemoveOperation(path: path))
        return self
    }
    
    
    /**
     * Replace value, Will result in, for example,
     * { "op": "replace", "path": "/a/b/c", "value": foo }
     *
     * - Parameter path  target location
     * - Parameter value value to be replaced
     */
    func replace(path: String, value: Any?) -> JsonPatchDocument {
        operations.append(ReplaceOperation(path: path, value: value))
        return self
    }
    
    /**
     * Test value, will result in, for example,
     * { "op": "test", "path": "/a/b/c", "value": foo }
     *
     * - Parameter path  target location
     * - Parameter value test value
     */
    func test(path: String, value: Any) -> JsonPatchDocument {
        operations.append(TestOperation(path: path, value: value))
        return self
    }
    
    /**
     * Removes a value from a specified location and adds it to the target location, will result in,
     * for example,
     * { "op": "move", "from": "/a/b/c", "path": "/a/b/d" }
     *
     * - Parameter from source location
     * - Parameter path target location
     */
    func move(from: String, path: String) -> JsonPatchDocument {
        operations.append(MoveOperation(path: from, value: path))
        return self
    }
    
    /**
     * Copy the value at a specified location to the target location, will result in, for example,
     * { "op": "copy", "from": "/a/b/c", "path": "/a/b/e" }
     *
     * - Parameter from source location
     * - Parameter path target location
     */
    func copy(from: String, path: String) -> JsonPatchDocument {
        operations.append(CopyOperation(path: from, value: path))
        return self
    }
    
    func getOperations() -> [JsonPatchOperation] {
        return operations
    }
}
