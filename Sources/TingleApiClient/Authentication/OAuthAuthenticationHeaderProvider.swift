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
