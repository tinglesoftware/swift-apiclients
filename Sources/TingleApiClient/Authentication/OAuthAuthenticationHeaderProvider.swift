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
        <#code#>
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

