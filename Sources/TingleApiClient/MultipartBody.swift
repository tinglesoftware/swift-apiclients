
import Foundation

public class MultipartBody{
    private let boundery: Data
    private var type: MediaType
    private var parts: Array<Part>
    
    
    init(boundery: Data, type: MediaType, parts: Array<Part>) {
        self.boundery = boundery
        self.type = type
        self.parts = parts
    }
    
    
    func toRequestBody()-> Data {
        let body = NSMutableData()
        
        return body as Data
    }
    
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
            
            //            if (request?.contentLength == nil) {
            //                fatalError("Unexpected header: Content-Length")
            //            }
            
            return Part(request: request, body: data)
        }
        
        static func createFormData(request: inout URLRequest, name: String, value: String) -> Part{
            return createFormData(request: &request, name: name, fileName: nil, body: value.data(using: .utf8)!)
        }
        
        static func createFormData(request: inout URLRequest,name: String, fileName: String?, body: Data) -> Part{
            var disposition = "form-data; name="
            disposition.appendQuotedString(key: name)
            
            if fileName != nil{
                disposition.append("; filename=")
                disposition.appendQuotedString(key: fileName!)
            }
            
            request.setValue(disposition, forHTTPHeaderField: "Content-Disposition")
            
            return try! create(request: request, data: body)
        }
    }
    
    public class Builder {
        private let boundery = "\(UUID().uuidString)".data(using: .utf8)!
        private var type: MediaType = .MIXED
        private var parts: Array<Part> = []
        private var request: URLRequest
        
        public  init(_ request: URLRequest) {
            self.request = request
        }
        
        /**
         * Set the MIME type.
         */
        public func setType(type: MediaType)-> Self{
            self.type = type
            return self
        }
        
        /**
         * Add a part to the body.
         */
        public func addPart(body: Data) -> Self{
            parts.append(Part.create(body: body))
            return self
        }
        
        /**
         * Add a part to the body.
         */
        public func addPart(request: URLRequest,body: Data) -> Self{
            parts.append(try! Part.create(request: request,data: body))
            return self
        }
        
        /**
         * Add a parts to the body.
         */
        func addPart(part: Part) -> Self{
            parts.append(part)
            return self
        }
        
        
        /**
         * Add a part to the body.
         */
        public func addFormDataPart(name: String, value: String) -> Self {
            let part = Part.createFormData(request: &request, name: name, value: value)
            let _ = addPart(part: part)
            return self
        }
        
        /**
         * Add a part to the body.
         */
        public func addFormDataPart(name: String, fileName: String, withData body:Data ) -> Self {
            let part = Part.createFormData(request: &request, name: name, fileName: fileName, body: body)
            let _ = addPart(part: part)
            return self
        }
        
        
        public func build() throws -> MultipartBody {
            if parts.isEmpty{ fatalError("Mutlipart body must have at least one part")}
            return MultipartBody(boundery: boundery, type: type, parts: parts)
        }
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
