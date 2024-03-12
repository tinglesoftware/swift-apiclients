//
//  HttpApiResponseProblemTests.swift
//  TingleApiClientTests
//
//  Created by Maxwell Weru on 1/8/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import XCTest
@testable import TingleApiClient

class HttpApiResponseProblemTest: XCTestCase {

    func testSerializationProducedExpectedJson() {
        let problem = HttpApiResponseProblem()
        problem.title = "insufficient_balance"
        problem.detail = "Add more money!"
        problem.errors = Dictionary<String, [String]>()
        problem.errors!["SessionId"] = ["The SessionId is required"]

        // serialize the problem and ensure that the produced value is the same
        let expectedJson = "{\"title\":\"insufficient_balance\",\"detail\":\"Add more money!\",\"errors\":{\"SessionId\":[\"The SessionId is required\"]}}"
        let encoder = JSONEncoder()
        let data = try! encoder.encode(problem)
        let actualJson = String(data: data, encoding: .utf8)!
        XCTAssertEqual(expectedJson, actualJson)
    }

    func testDeserializationWorksWithErrors() {
        // serialize the problem and ensure that the produced value is the same
        let json = "{\"title\":\"insufficient_balance\",\"detail\":\"Add more money!\",\"errors\":{\"SessionId\":[\"The SessionId is required\"]}}"
        let decoder = JSONDecoder()
        let data = Data(json.utf8)
        let problem = try! decoder.decode(HttpApiResponseProblem.self, from: data)
        XCTAssertEqual("insufficient_balance", problem.title)
        XCTAssertEqual("insufficient_balance", problem.code)
        XCTAssertEqual("Add more money!", problem.detail)
        XCTAssertEqual("Add more money!", problem.description)
        XCTAssertNotNil(problem.errors)
        XCTAssertFalse(problem.errors!.isEmpty)
        XCTAssertEqual("SessionId", problem.errors!.first?.key)
        XCTAssertEqual("The SessionId is required", problem.errors!.first?.value.first)
    }

    func testDeserializationWorksWithNoErrors() {
        // serialize the problem and ensure that the produced value is the same
        let json = "{\"title\":\"insufficient_balance\",\"detail\":\"Add more money!\"}"
        let decoder = JSONDecoder()
        let data = Data(json.utf8)
        let problem = try! decoder.decode(HttpApiResponseProblem.self, from: data)
        XCTAssertEqual("insufficient_balance", problem.title)
        XCTAssertEqual("insufficient_balance", problem.code)
        XCTAssertEqual("Add more money!", problem.detail)
        XCTAssertEqual("Add more money!", problem.description)
        XCTAssertNil(problem.errors)
    }

    func testProblemDetailsPrioritizesRFC3986() {
        // serialize the problem and ensure that the produced value is the same
        let json = "{\"title\":\"insufficient_balance\",\"detail\":\"who cares\",\"error_code\":\"zero_balance\",\"error_description\":\"go away\"}"
        let decoder = JSONDecoder()
        let data = Data(json.utf8)
        let problem = try! decoder.decode(HttpApiResponseProblem.self, from: data)

        XCTAssertEqual("insufficient_balance", problem.title)
        XCTAssertEqual("insufficient_balance", problem.code)
        XCTAssertEqual("zero_balance", problem.error_code)

        XCTAssertEqual("who cares", problem.detail)
        XCTAssertEqual("who cares", problem.description)
        XCTAssertEqual("go away", problem.error_description)
    }

    func testProblemDetailsPrioritizesFallsBackToLegacy() {
        // serialize the problem and ensure that the produced value is the same
        let json = "{\"title\":null,\"detail\":null,\"error_code\":\"zero_balance\",\"error_description\":\"go away\"}"
        let decoder = JSONDecoder()
        let data = Data(json.utf8)
        let problem = try! decoder.decode(HttpApiResponseProblem.self, from: data)

        XCTAssertNil(problem.title)
        XCTAssertEqual("zero_balance", problem.code)
        XCTAssertEqual("zero_balance", problem.error_code)


        XCTAssertNil(problem.detail)
        XCTAssertEqual("go away", problem.description)
        XCTAssertEqual("go away", problem.error_description)
    }

}

