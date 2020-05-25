
import Foundation

class JsonPatchOperation: Encodable{
    var op: String
    
    init(op: String) {
        self.op = op
    }
}
