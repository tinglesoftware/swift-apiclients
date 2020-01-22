//
//  Bundle.swift
//
//
//  Created by Maxwell Weru on 1/21/20.
//

import Foundation

extension Bundle {
    
    /**
     * The receiver's short version. Usually done in semantic versioning format
     *
     * The bundle identifier is defined by the `CFBundleShortVersionString` key in the bundle’s information property list.
     */
    var shortBundleVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /**
     * The receiver's bundle version. Usually an incrementing integer.
     *
     * The bundle identifier is defined by the `CFBundleVersion` key in the bundle’s information property list.
    */
    var bundleVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
