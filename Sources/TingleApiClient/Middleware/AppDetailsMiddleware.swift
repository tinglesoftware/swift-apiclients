//
//  AppDetailsMiddleware.swift
//  
//
//  Created by Maxwell Weru on 1/21/20.
//

import Foundation

/**
 *An `TingleApiClientMiddleware` that adds headers for package id, version name and version code to a request before sending
*/
public class AppDetailsMiddleware: TingleApiClientMiddleware {
    private let packageId: String
    private let versionName: String
    private let versionCode: String
    
    public init (_ packageId: String, _ versionName: String, _ versionCode: String) {
        self.packageId = packageId
        self.versionName = versionName
        self.versionCode = versionCode
    }
    
    public func process(request: inout URLRequest) -> URLRequest {
        request.setValue(packageId, forHTTPHeaderField: "AppPackageId")
        request.setValue(versionName, forHTTPHeaderField: "AppVersionName")
        request.setValue(versionCode, forHTTPHeaderField: "AppVersionCode")

        return request
    }
    
    public func process(response: URLResponse?, data: Data?, error: Error?) {
        
    }
}

