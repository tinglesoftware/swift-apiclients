//
//  Int+ExtensionTests.swift
//  TingleApiClientTests
//
//  Created by Maxwell Weru on 5/28/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import XCTest
@testable import TingleApiClient


class IntExtensionTest: XCTestCase{
    
    func testFormatAbbreviated() {
        XCTAssertEqual(1_001.formatAbbreviated(), "1K")
        XCTAssertEqual(1_010.formatAbbreviated(), "1K")
        XCTAssertEqual(10_300.formatAbbreviated(), "10.3K")
        XCTAssertEqual(3_900_120.formatAbbreviated(), "3.9M")
        XCTAssertEqual(3_910_120.formatAbbreviated(), "3.9M"/*"3.91M"*/)
        XCTAssertEqual(3_000_120.formatAbbreviated(), "3M")
        XCTAssertEqual(1_400_000_120.formatAbbreviated(), "1.4B")
        XCTAssertEqual(1_000_000_120.formatAbbreviated(), "1B")
        XCTAssertEqual(1_004_000_120.formatAbbreviated(), "1B"/*"1.004B"*/)
        XCTAssertEqual(1_044_000_120.formatAbbreviated(), "1B"/*"1.004B"*/)
        XCTAssertEqual(10_044_000_120.formatAbbreviated(), "10B"/*"10.004B"*/)
        XCTAssertEqual(10_044_000_120_000.formatAbbreviated(), "10T"/*"10.004T"*/)
    }
}
