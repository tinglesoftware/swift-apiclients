//
//  OAuthAuthenticationHeaderProvider.swift
//  
//
//  Created by Seth Onyango on 13/12/2020.
//

import Foundation
/**
 * Authentication provider for OAuth Client Credentials flow (see the OAuth 2.0 spec for more details).
 * This provider supports caching
 */
public final class OAuthAuthenticationHeaderProvider: AuthenticationHeaderProvider{
    private static let DEFAULT_SCHEME = "Bearer"
    private static let MAX_ATTEMPTS = 3
    private static let BACKOFF_MILLI_SECONDS = 2000
    
    private var oAuthRequest: OAuthRequest
    
    /**
     * Initializes an instance of `OAuthAuthenticationHeaderProvider`
     * - Parameter scheme: The scheme to set in the `Authorization` header
     * - Parameter oAuthRequest: The request model to be used to request a token. Contains parameters like clientId, clientSecret e.t.c
     */
    public init(_ scheme: String, oAuthRequest: OAuthRequest){
        self.oAuthRequest = oAuthRequest
        super.init(scheme)
    }
    
    /**
     * Initializes an instance of `OAuthAuthenticationHeaderProvider`
     * - Parameter oAuthRequest: The request model to be used to request a token. Contains parameters like clientId, clientSecret e.t.c
     */
    public convenience init(oAuthRequest: OAuthRequest){
        self.init(OAuthAuthenticationHeaderProvider.DEFAULT_SCHEME, oAuthRequest: oAuthRequest)
    }
    
    
    /**
     * Initializes an instance of `OAuthAuthenticationHeaderProvider`
     * - Parameter authenticationEndpoint The authentication endpoint to be used to request a token
     * - Parameter clientId The client identifier (client_id) to be used in the token request
     * - Parameter clientSecret The client secret (client_secret) to be used in the token request
     * - Parameter resource The resource to be requested for in the token request
     */
    public convenience init(authenticationEndpoint: String?, clientId: String?,clientSecret: String?, resource: String?) {
        let oAuthRequest = OAuthRequest(authenticationEndpoint: authenticationEndpoint, clientId: clientId, clientSecret: clientSecret, resource: resource)
        self.init(oAuthRequest: oAuthRequest)
    }
    
    /**
     * Initializes an instance of `OAuthAuthenticationHeaderProvider`
     * - Parameter scheme The scheme to set in the `Authorization` header
     * - Parameter authenticationEndpoint The authentication endpoint to be used to request a token
     * - Parameter clientId The client identifier (client_id) to be used in the token request
     * - Parameter clientSecret The client secret (client_secret) to be used in the token request
     * - Parameter resource The resource to be requested for in the token request
     */
    public convenience init(_ scheme: String, authenticationEndpoint: String?, clientId: String?,clientSecret: String?, resource: String?) {
        let oAuthRequest = OAuthRequest(authenticationEndpoint: authenticationEndpoint, clientId: clientId, clientSecret: clientSecret, resource: resource)
        self.init(scheme,oAuthRequest: oAuthRequest)
    }
    
    /**
     * Authorize a request before executing
     * - Parameter request the request message to be authorized
     * - Returns  the authentication parameter
     */
    public override func getParameter(request: inout URLRequest) -> String {
        return accessToken
    }
    
    
    /**
     * Requests an accessToken
     * - Returns the  `OAuthResponse`'
     */
    private var requestAuthorization: OAuthResponse?{
        
        let apiClient = TingleApiClient()
        let semaphore = DispatchSemaphore(value: 0)
        
        let requestBody = "grant_type=client_credentials&client_id=\(oAuthRequest.clientId!)&client_secret=\(oAuthRequest.clientSecret!)&resource=\(oAuthRequest.resource!)".data(using: .utf8)
        
        var request = URLRequest(url: URL(string: self.oAuthRequest.authenticationEndpoint!)!)
        request.httpBody = requestBody
        request.httpMethod = "POST"
        request.contentType = "application/x-www-form-urlencoded"
        
        var oAuthResponse: OAuthResponse? = nil
        
        apiClient.sendRequest(request: &request) { (response:AnyResourceResponse<OAuthResponse>?, error) in
            
            if response != nil && response!.successful && response!.resource != nil{
                oAuthResponse = response!.resource!
            }
            
            semaphore.signal()
        }
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return oAuthResponse
    }
    
    private var accessToken: String {
        var backoff = OAuthAuthenticationHeaderProvider.BACKOFF_MILLI_SECONDS + Int.random(in: 1...1000)
        
        
        for index in (1...OAuthAuthenticationHeaderProvider.MAX_ATTEMPTS){
            print("Attempt \(index) to acquire Auth Token")
          
            // Check if we have an existing token and the token's validity.
            let accessToken = CachingUtils.accessToken
            let hasTokenExpired = CachingUtils.hasTokenExpired
            
            if accessToken != nil && !accessToken!.isEmpty && !hasTokenExpired{
                print("Valid token in cache, expiry time: \(CachingUtils.accessTokenExpiry)")
                return accessToken!
            }
            
            // let's request for a new token
            print("Making token acquisition request, number of attempts = \(index)")
            let response = requestAuthorization
            
            if(response != nil){
                print("Valid token was acquired, expiry time: \(response!.expiresOn)")
                
                // Cache token
                CachingUtils.accessToken = response!.accessToken
                
                // Calculate and store the time the token expires
                let expiresIn_ms = Int(response!.expiresIn)! * 1000
                let expiresAt = (Int(Date().timeIntervalSinceNow) + expiresIn_ms) - 100
                CachingUtils.accessTokenExpiry = expiresAt
                
                return response!.accessToken!
            }
            
            print("Failed to acquire auth code on attempt \(index)")

            if index == OAuthAuthenticationHeaderProvider.MAX_ATTEMPTS {
                break
            }
            
            do{
                print("Sleeping for \(backoff) ms before retry")
                sleep(UInt32(backoff))
            }
            
            // increase backoff exponentially
            backoff *= 2
        }
        
        return ""
    }
    
}


public class OAuthRequest{
    //  the authentication endpoint to be used to request a token
    var authenticationEndpoint: String? = nil
    // the client identifier (client_id) to be used in the token request
    var clientId: String? = nil
    // the client secret (client_secret) to be used in the token request
    var clientSecret: String? = nil
    // the resource to be requested for in the token request
    var resource: String? = nil
    
    
    public init(authenticationEndpoint: String?, clientId: String?,clientSecret: String?, resource: String?) {
        self.authenticationEndpoint = authenticationEndpoint
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.resource = resource
    }
}


class OAuthResponse: Decodable {
    var accessToken: String? = nil
    var expiresOn: String = "3600"
    var expiresIn: String = "0"
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.expiresOn = try container.decode(String.self, forKey: .expiresOn)
        self.expiresIn = try container.decode(String.self, forKey: .expiresIn)
    }
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "access_token"
        case expiresOn =  "expires_on"
        case expiresIn = "expires_in"
    }
}

