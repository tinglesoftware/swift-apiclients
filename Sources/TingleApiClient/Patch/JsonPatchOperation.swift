
import Foundation

public class JsonPatchOperation: Encodable{
    public var op: String
    
    init(op: String) {
        self.op = op
    }
}
