//
//  Int+Extension.swift
//
//
//  Created by Maxwell Weru on 5/28/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

extension Int {

    func formatAbbreviated () -> String {
        let numFormatter = NumberFormatter()

        typealias Abbreviation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbreviation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B"),
                                           (100_000_000_000.0, 1_000_000_000_000.0, "T")]
                                           // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbreviation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value: value))!
    }

}
