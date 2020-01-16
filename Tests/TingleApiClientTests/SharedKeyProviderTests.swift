//
//  SharedKeyProviderTests.swift
//  TingleApiClientTests
//
//  Created by Maxwell Weru on 1/14/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation
import XCTest
@testable import TingleApiClient

class SharedKeyProviderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProviderWorksForGet() {
        // prepare the http request message
        let url = URL(string: "https://scoppe.people.tinglesoftware.com/api/v1.1/iprs?idNumber=12345678")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Tue, 26 Dec 2017 23:09:28 GMT", forHTTPHeaderField: "x-ms-date")

        // prepare the authentication provider
        let provider = SharedKeyAuthenticationProvider(base64Key: "TiR0p2ZwnUuBGBEDU5LADWBXpxXy3Y9Aq4Fb1nD+6CM=")

        // invoke the authentication provider
        provider.authenticate(request: &request)

        // assert values
        let headerValue = request.value(forHTTPHeaderField: "Authorization")
        XCTAssertNotNil(headerValue)
        XCTAssertEqual("SharedKey v9LNWEDKJ65oSHnPqDW8akUCYz97Kcu+UGie0qZbO4k=", headerValue)
    }
    
    func testProviderWorksForPost() {
        // prepare the http request message
        let url = URL(string: "https://scoppe.people.tinglesoftware.com/api/v1.1/iprs?idNumber=12345678")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "{}".data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Tue, 26 Dec 2017 23:09:28 GMT", forHTTPHeaderField: "x-ms-date")

        // prepare the authentication provider
        let provider = SharedKeyAuthenticationProvider(base64Key: "TiR0p2ZwnUuBGBEDU5LADWBXpxXy3Y9Aq4Fb1nD+6CM=")

        // invoke the authentication provider
        provider.authenticate(request: &request)

        // assert values
        let headerValue = request.value(forHTTPHeaderField: "Authorization")
        XCTAssertNotNil(headerValue)
        XCTAssertEqual("SharedKey wvvxU8t2ocF0lY2GOmkQSepiUGhjuQnGqMCzfTxhfX0=", headerValue)
    }
    
    func testProviderAddsDateHeader() {
        // prepare the http request message
        let url = URL(string: "https://scoppe.people.tinglesoftware.com/api/v1.1/iprs?idNumber=12345678")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // prepare the authentication provider
        let provider = SharedKeyAuthenticationProvider(base64Key: "TiR0p2ZwnUuBGBEDU5LADWBXpxXy3Y9Aq4Fb1nD+6CM=")

        // invoke the authentication provider
        provider.authenticate(request: &request)

        // assert values
        let headerValue = request.value(forHTTPHeaderField: "x-ms-date")
        XCTAssertNotNil(headerValue)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT'" // RFC
        let date = formatter.date(from: headerValue!)!
        XCTAssertTrue(date < Date())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
