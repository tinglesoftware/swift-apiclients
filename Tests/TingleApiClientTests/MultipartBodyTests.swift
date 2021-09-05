import XCTest
@testable import TingleApiClient

class MutlipartBodyTests: XCTestCase{
    func testSerializationOfFormData(){
        let url = URL(string: "www.example.com")!
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data;", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let body = try! MultipartBody.Builder(request)
            .setType(type: .FORM)
            .addFormDataPart(name: "Currecny", value:"USD")
            .addFormDataPart(name: "Amount", value: "1234")
            .build()
                
        request.httpBody = body.toRequestBody()
    }
}
