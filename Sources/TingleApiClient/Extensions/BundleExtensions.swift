//
//  Bundle.swift
//
//
//  Created by Maxwell Weru on 1/21/20.
//

import Foundation

extension Bundle {
    var shortBundleVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var bundleVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
