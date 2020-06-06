//
//  JsonPatchDocumentTests.swift
//  TingleApiClientTests
//
//  Created by Seth Onyango on 26/05/2020.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import XCTest
@testable import TingleApiClient


class JsonPatchDocumentTest: XCTestCase {
    
    func testSerializationProducedExpectedJson() {
        let document = JsonPatchDocument()
            .replace(path: "Name", value: "Mr.Zero")
                
        let expectedJson = "[{\"op\":\"replace\",\"path\":\"Name\",\"value\":\"Mr.Zero\"}]"
        let encoder = JSONEncoder()
        let data = try! encoder.encode(document.getOperations())
        let actualJson = String(data: data, encoding: .utf8)!
        XCTAssertEqual(expectedJson, actualJson)
    }
}
