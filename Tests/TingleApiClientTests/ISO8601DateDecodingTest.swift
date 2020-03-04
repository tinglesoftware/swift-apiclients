//
//  File.swift
//  
//
//  Created by Seth Onyango on 29/01/2020.
//

import XCTest
@testable import TingleApiClient

class ISO8601DateDecodingTest: XCTestCase{
    
    func testDateDeserialization(){
        let json = "{\"appliedOn\":\"2019-08-23T16:00:51+03:00\"}"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let data = Data(json.utf8)
        _ = try! decoder.decode(SampleData.self, from: data)
    }
    
    
    func testDateWithMSDeserialization(){
        let json = "{\"appliedOn\":\"2018-05-08T11:44:58.167907+00:00\",\"paidOn\":\"2019-08-23T16:00:51+03:00\"}"
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategyFormatters = [
            DateFormatter.iSO8601Date,
            DateFormatter.iSO8601DateWithMillisec
        ]
        let data = Data(json.utf8)
        _ = try! decoder.decode(SampleData.self, from: data)
        
    }
}


class SampleData : Decodable {
    var appliedOn: Date? = nil
    var paidOn: Date? = nil
}
