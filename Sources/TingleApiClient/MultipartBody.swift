
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
}


