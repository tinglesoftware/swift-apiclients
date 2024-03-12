import XCTest
@testable import TingleApiClient

class MultipartBodyTests: XCTestCase{
    func testSerializationOfFormData(){
        let url = URL(string: "www.example.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = try! MultipartBody.Builder(&request, type: .FORM)
            .addFormDataPart(name: "Currency", value:"USD")
            .addFormDataPart(name: "Amount", value: "1234")
            .build()
                
        request.httpBody = body.toRequestBody()
    }
}
