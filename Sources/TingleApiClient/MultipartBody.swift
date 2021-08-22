
import Foundation

public class MultipartBody: Codable{
    
    struct Part{
        let request: URLRequest?
        let body: Data
        
        init(request:URLRequest? = nil, body:Data ) {
            self.request = request
            self.body = body
        }
        
        static func create(body: Data) -> Part{
            return Part(body: body)
        }
        
        static func create(request: URLRequest?, data:Data) throws -> Part{
            if (request?.contentType == nil) {
                fatalError("Unexpected header: Content-Type")
            }
            
            if (request?.contentLength == nil) {
                fatalError("Unexpected header: Content-Length")
            }
            
            return Part(request: request, body: data)
        }
        
        static func createFormData(request: inout URLRequest,name: String, fileName: String?, body: Data) -> Part{
            var disposition = "form-data; name=\"\(name)\""
            
            if fileName != nil{
                disposition.append("; filename=")
                disposition.append("\"\(fileName!)\"")
            }
            
            request.setValue(disposition, forHTTPHeaderField: "Content-Disposition")
            
            return try! create(request: request, data: body)
        }
    }
    
    public struct Builder {
        private let boundery = "\(UUID().uuidString)".data(using: .utf8)
        private let type: MediaType = .MIXED
        private let parts: Array<Part>
    }
}


public enum MediaType: String {
    /**
     * The "mixed" subtype of "multipart" is intended for use when the body parts are independent and need to be bundled in a particular order.
     * Any "multipart" subtypes that an implementation does not recognize must be treated as being of subtype "mixed".
     */
    case MIXED = "multipart/mixed"
    
    /**
     * The "multipart/alternative" type is syntactically identical to "multipart/mixed", but the semantics are different. In particular, each of the body
     * parts is an "alternative" version of the same information.
     */
    case ALTERNATIVE = "multipart/alternative"
    
    /**
     * This type is syntactically identical to "multipart/mixed", but the semantics are different.
     * In particular, in a digest, the default `Content-Type` value for a body part is changed from
     * "text/plain" to "message/rfc822".
     */
    case DIGEST = "multipart/digest"
    
    
    /**
     * This type is syntactically identical to "multipart/mixed", but the semantics are different.
     * In particular, in a parallel entity, the order of body parts is not significant.
     */
    case PARALLEL = "multipart/parallel"
    
    /**
     * The media-type multipart/form-data follows the rules of all multipart MIME data streams as
     * outlined in RFC 2046. In forms, there are a series of fields to be supplied by the user who
     * fills out the form. Each field has a name. Within a given form, the names are unique.
     */
    case FORM = "multipart/form-data"
}
