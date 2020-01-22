# TingleApiClient


[![Build Status](https://dev.azure.com/tingle/COMMON/_apis/build/status/Swift%20-%20ApiClients?branchName=master)](https://dev.azure.com/tingle/COMMON/_build/latest?definitionId=239&branchName=master)
![Language](https://img.shields.io/badge/language-Swift%205.0-orange.svg)

TingleApiClient is a simple class for making api calls in iOS, macOS and tvOS apps. It has specific support for parsing errors and content.
This library eases working with HTTP APIs built by Tingle Software but can also work with other APIs.

## Usage (Simple Client)

```swift
// Initialize
let apiClient = TingleApiClient()

// prepare request
let url = URL(string: "https://citam.azurewebsites.net/api/v2/assemblies")!
var request = URLRequest(url: url)
request.httpMethod = "GET"

// make request
apiClient.send(&request) { (response: ResourceResponse<[Assembly]>?, error: Error?) in

    // first check for a network error (such as no internet)
    if (error != nil) {
        // handle error here
        return
    }
    
    // if the error is nil the response should not be nil
    // but lets just check for the sake of checking
    if (response == nil) {
        // should not happen
        return
    }
    
    // check if the response was successful
    if (response!.successful && response!.resource != nil) {
        let assemblies = response!.resource!
        if (!assemblies.isEmpty) {
            // save the entries in the database or elsewhere
            // this is called in the background you should not access the UI thread directly without a dispatcher
        }
    }
}
```

## Usage (Derived Client)

```swift
import Foundation
import TingleApiClient

public class CitamApiClient: TingleApiClient {
    private let baseUrl = "https://citam.azurewebsites.net"
    
    override public func setupJsonSerialization(encoder: JSONEncoder, decoder: JSONDecoder) {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    override public func buildMiddleware() -> [TingleApiClientMiddleware] {
        [
            AppDetailsMiddleware(Bundle.main.bundleIdentifier ?? "", Bundle.main.shortBundleVersion, Bundle.main.shortBundleVersion),
            LoggingMiddleware(.BODY, .info)
        ]
    }
    
    @discardableResult
    public func getAssemblies(_ completionHandler: @escaping (ResourceResponse<[Assembly]>?, error: Error?) -> Void) -> URLSessionTask {
        let url = URL(string: "\(baseUrl)/api/v2/assemblies")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return send(&request, completionHandler)
    }
    
    @discardableResult
    public func getSermons(_ assemblyCode: String, _ completionHandler: @escaping (ResourceResponse<[Sermon]>?, error: Error?) -> Void) -> URLSessionTask {
        let url = URL(string: "\(baseUrl)/api/v2/assemblies/\(assemblyCode)/sermons")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return send(&request, completionHandler)
    }
    
    @discardableResult
    public func getNotices(_ assemblyCode: String, _ completionHandler: @escaping (ResourceResponse<[Notice]>?, error: Error?) -> Void) -> URLSessionTask {
        let url = URL(string: "\(baseUrl)/api/v2/assemblies/\(assemblyCode)/notices")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return send(&request, completionHandler)
    }
}
```

```swift
import Foundation
import RealmSwift
import TingleApiClient

public class DownloadManager {
    private static let client = CitamApiClient()
    
    @discardableResult
    public static func downloadAllAssemblies() -> URLSessionTask {
        return client.getAssemblies { (response: ResourceResponse<[Assembly]>) in
            if (response.successful && response.resource != nil) {
                let assemblies = response.resource!
                if (!assemblies.isEmpty) {
                    if let realm = try? Realm() {
                        try? realm.write {
                            realm.add(assemblies, update: .all)
                        }
                    }
                }
            }
        }
    }
}
```

See the samples project to see advanced usage

## Installation

### Swift Package Manager

TingleApiClient is available on SPM. Just add the following to your Package file:

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://dev.azure.com/tingle/COMMON/_git/swift-apiclients", from: 0.2.0)
    ]
)
```

### Manual Installation

Just drag the `Sources/*.swift` files into your project.

## TingleApiClient properties

```swift
encoder
```

The instance of `JsonEncoder` to use in creating JSON payloads from objects

```swift
decoder
```

The instance of `JSONDecoder` to use in creating objects from JSON payloads

## TingleApiClient methods

```swift
init(session: URLSession? = nil, authenticationProvider: IAuthenticationProvider? = nil)
init(_ authenticationProvider: IAuthenticationProvider)
```

These methods create a new TingleApiClient instance that uses the session and authentication provider passed.

```swift
func buildMiddleware() -> [TingleApiClientMiddleware]
```

Builds the middleware that is used to process requests and responses. There are different reasons why you might want to use middleware, such as logging, setting extra headers etc.
The `IAuthenticationProvider` is itself middleware dedicated towards authenticating the request before going out.

```swift
func func setupJsonSerialization(encoder: JSONEncoder, decoder: JSONDecoder)
```

Setups the instances of  `JSONEncoder` and `JSONDecoder` already created. These instances are used to encode/decode requests/responses respectively in the `send` functions

```swift
func sendRequest<TResource, TProblem, TResourceResponse>(_ request: inout URLRequest,
                                                         _ resultBuilder: @escaping (Int, Any, TResource?, TProblem?) -> TResourceResponse,
                                                         _ completionHandler: @escaping (TResourceResponse?, Error?) -> Void) -> URLSessionTask
```

This method sends a HTTP request as per the details in the `request` parameter. The response is parsed to produce a `TResource` and  `TProblem`.
These two are supplied to the `resultBuilder`  closure to produce a `TResourceResponse`.
When the network call fails such as there being no internet access or being unable to reach the server, the `resultBuilder` closure is not called. Instead,
the `completionHandler` closure is called with the `TResourceResponse?` argument set to `nil` and the `Error?` argument not `nil`.
When the network call succeeds, the `resultBuilder` closure is called to produce an instance of `TResourceResponse` and the result is passed to the
`completionHandler` closure but the `Error?` parameter is set to `nil`.

```swift
func sendRequest<TResource, TProblem>(_ request: inout URLRequest,
                                      _ completionHandler: @escaping (ResourceResponseBase<TResource, TProblem>?, Error?) -> Void) -> URLSessionTask
```

This is similar to calling the `sendRequest` method above but instead produces a `ResourceResponseBase<TResource, TProblem>`  for the `TResourceResponse`


```swift
func sendRequest<TResource, TProblem>(_ request: inout URLRequest,
                                      _ completionHandler: @escaping (ResourceResponse<TResource, TProblem>?, Error?) -> Void) -> URLSessionTask
```

This is similar to calling the `sendRequest` method above but instead produces a `ResourceResponse<TResource, TProblem>`  for the `TResourceResponse`
