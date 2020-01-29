//
//  JsonDecoder+DateFormatter.swift
//  
//
//  Created by Seth Onyango on 29/01/2020.
//

import Foundation
extension JSONDecoder {
    
    /// Assign multiple DateFormatter to dateDecodingStrategy
    ///
    /// Usage :
    ///
    ///      decoder.dateDecodingStrategyFormatters = [ DateFormatter.iso8601Formatter, DateFormatter.iso8601MSFormatter ]
    ///
    /// The decoder will now be able to decode two DateFormat, the 'iso8601Formatter' one and the 'iso8601MSFormatter'
    ///
    /// Throws a 'DecodingError.dataCorruptedError' if an unsupported date format is found while parsing the document
    
    var dateDecodingStrategyFormatters: [DateFormatter]?  {
        @available(*, unavailable, message: "This variable is meant to be set only")
        get { return nil }
        set{
            guard let formatters = newValue else { return }
            self.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })
        }
    }
    
    
}


extension DateFormatter {
    static var iSO8601DateWithMillisec: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }
    
    static var iSO8601Date: DateFormatter {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           return dateFormatter
       }
}
