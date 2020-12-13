//
//  CachingUtils.swift
//  
//
//  Created by Seth Onyango on 13/12/2020.
//

import Foundation

struct CachingUtils {
    private static let PREF_ACCESS_TOKEN = "access_token_"
    
    private static let defaults: UserDefaults = UserDefaults.standard

    static var accessToken: String? {
        get {
            defaults.string(forKey: PREF_ACCESS_TOKEN)
        } set {
            defaults.set(newValue, forKey: PREF_ACCESS_TOKEN)
        }
    }
}
