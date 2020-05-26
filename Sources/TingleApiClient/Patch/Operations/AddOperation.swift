import Foundation


public class AddOperation : JsonPatchOperation{
    var path: String
    var value: Any?
    
    init(path: String, value: Any?){
        self.path = path
        self.value = value
        super.init(op: "add")
    }
}
