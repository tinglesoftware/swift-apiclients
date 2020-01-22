//
//  TingleApiClient.swift
//
//  Created by Maxwell Weru on 1/9/20.
//  Copyright © 2020 TINGLE SOFTWARE COMPANY LTD. All rights reserved.
//

import Foundation

/**
 * Middleware for performing authentication
 */
typealias IAuthenticationProvider = TingleApiClientMiddleware

/**
 * A convenience class for making HTTP requests. The implementation of this uses `URLRequest` and `URLSession` internally.
 *
 */
public class TingleApiClient {
    
    /**
     * The instance of `URLSession` to use in making requests of type `URLRequest`
     */
    private let session: URLSession
    
    /**
     * The instance of `JSONDecoder` to use in creating objects from JSON payloads
     */
    private let decoder: JSONDecoder = JSONDecoder()
    
    /**
     * The instance of `JsonEncoder` to use in creating JSON payloads from objects
     */
    public let encoder: JSONEncoder = JSONEncoder()
    
    /**
     * The instances of `TingleApiClientMiddleware` to be executed in present order for outgoing requests and reverse for incoming requests
     */
    private var middlewareItems = [TingleApiClientMiddleware]()
    
    /**
     * Initializes an instance of `TingleApiClient`
     *
     * - Parameter session: The instance of `URLSession` to use when queuing requests. When not provided or set to `nil`, the client uses `URLSession.shared`
     * - Parameter authenticationProvider: The instance of `IAuthenticationProvider` to use to authenticate outgoing requests.
     * When not provided or set to `nil`, the client uses and instance of `EmptyAuthenticationProvider`
     * */
    init(session: URLSession? = nil, authenticationProvider: IAuthenticationProvider? = nil)
    {
        // set the URLSession and default to the shared one when set to nil
        self.session = session ?? URLSession.shared
        
        // apped the authentication middleware and default to empty when set to nil
        middlewareItems.append(authenticationProvider ?? EmptyAuthenticationProvider())
        
        // build the middleware items
        let otherItems = buildMiddleware()
        if (!otherItems.isEmpty) {
            middlewareItems.append(contentsOf: otherItems)
        }
        
        // setup the encoder and decoder
        setupJsonSerialization(encoder: encoder, decoder: decoder)
    }
    
    /**
     * Initializes an instance of `TingleApiClient`
     * - Parameter authenticationProvider: The instance of `IAuthenticationProvider` to use to authenticate outgoing requests.
     */
    convenience init(_ authenticationProvider: IAuthenticationProvider) {
        self.init(session: nil, authenticationProvider: authenticationProvider)
    }
    
    /**
     * Builds the middleware that is used to process requests and responses. There are different reasons why you might want to use middleware, such as logging, setting extra headers etc.
     * The `IAuthenticationProvider` is itself middleware dedicated towards authenticating the request before going out.
     */
    open func buildMiddleware() -> [TingleApiClientMiddleware] { [TingleApiClientMiddleware]() }
    
    /**
     * Setups the instances of  `JSONEncoder` and `JSONDecoder` already created. These instances are used to encode/decode requests/responses respectively in the `send` functions
     */
    open func setupJsonSerialization(encoder: JSONEncoder, decoder: JSONDecoder) {
        // nothing to do here, the implementing class shall override to specify the settings for the encoder and decoder
        // example for these settings are the date format, the key strategy etc.
    }
    
    /**
     * This method sends a HTTP request as per the details in the `request` parameter. The response is parsed to produce a `TResource` and  `TProblem`.
     * These two are supplied to the `resultBuilder`  closure to produce a `ResourceResponse<TResource, TProblem>`.
     *
     * When the network call fails such as there being no internet access or being unable to reach the server, a `ResourceResponse<TResource, TProblem>` is not created.
     * The `completionHandler` closure is called with the `ResourceResponse<TResource, TProblem>?` argument set to `nil` and the `Error?` argument not `nil`.
     * When the network call succeeds, a `ResourceResponse<TResource, TProblem>` is created and passed to the
     * `completionHandler` closure but the `Error?` parameter is set to `nil`.
     *
     * - Parameter request: The request to be sent
     * - Parameter completionHandler: The closure to call when the call completes wether is was successful or not
     */
    @discardableResult
    func send<TResource>(_ request: inout URLRequest, _ completionHandler: @escaping (ResourceResponse<TResource>?, Error?) -> Void) -> URLSessionTask
        where TResource: Decodable {
            
            // make the result builder
            let builder: (Int, Any, TResource?, HttpApiResponseProblem?) -> ResourceResponse<TResource> = {
                (sc: Int, headers: Any, resource:TResource?, problem: HttpApiResponseProblem?) -> ResourceResponse<TResource> in
                return ResourceResponse(statusCode: sc, headers: headers, resource: resource, problem: problem)
            }
            
            // send the request
            return send(&request, builder, completionHandler)
    }
    
    /**
     * This method sends a HTTP request as per the details in the `request` parameter. The response is parsed to produce a `TResource` and  `TProblem`.
     * These two are supplied to the `resultBuilder`  closure to produce a `ResourceResponseBase<TResource, TProblem>`.
     *
     * When the network call fails such as there being no internet access or being unable to reach the server, a `ResourceResponseBase<TResource, TProblem>` is not created.
     * The `completionHandler` closure is called with the `ResourceResponseBase<TResource, TProblem>?` argument set to `nil` and the `Error?` argument not `nil`.
     * When the network call succeeds, a `ResourceResponseBase<TResource, TProblem>` is created and passed to the
     * `completionHandler` closure but the `Error?` parameter is set to `nil`.
     *
     * - Parameter request: The request to be sent
     * - Parameter completionHandler: The closure to call when the call completes wether is was successful or not
     */
    @discardableResult
    func send<TResource, TProblem>(_ request: inout URLRequest,
                                   _ completionHandler: @escaping (ResourceResponseBase<TResource, TProblem>?, Error?) -> Void) -> URLSessionTask
        where TResource: Decodable {
            
            // make the result builder
            let builder: (Int, Any, TResource?, TProblem?) -> ResourceResponseBase<TResource, TProblem> = {
                (sc: Int, headers: Any, resource:TResource?, problem: TProblem?) -> ResourceResponseBase<TResource, TProblem> in
                return ResourceResponseBase(statusCode: sc, headers: headers, resource: resource, problem: problem)
            }
            
            // send the request
            return send(&request, builder, completionHandler)
    }
    
    /**
     * This method sends a HTTP request as per the details in the `request` parameter. The response is parsed to produce a `TResource` and  `TProblem`.
     * These two are supplied to the `resultBuilder`  closure to produce a `TResourceResponse`.
     *
     * When the network call fails such as there being no internet access or being unable to reach the server, the `resultBuilder` closure is not called.
     * Instead, the `completionHandler` closure is called with the `TResourceResponse?` argument set to `nil` and the `Error?` argument not `nil`.
     * When the network call succeeds, the `resultBuilder` closure is called to produce an instance of `TResourceResponse` and the result is passed to the
     * `completionHandler` closure but the `Error?` parameter is set to `nil`.
     *
     * - Parameter request: The request to be sent
     * - Parameter resultBuilder: The closure to call when the network call succeeds whether or not the HTTP response indicares success
     * - Parameter completionHandler: The closure to call when the call completes wether is was successful or not
     */
    @discardableResult
    func send<TResource, TProblem, TResourceResponse>(_ request: inout URLRequest,
                                                      _ resultBuilder: @escaping (Int, Any, TResource?, TProblem?) -> TResourceResponse,
                                                      _ completionHandler: @escaping (TResourceResponse?, Error?) -> Void) -> URLSessionTask
        where TResource: Decodable, TProblem: Decodable, TResourceResponse: ResourceResponseBase<TResource, TProblem> {
            
            // first execute all middleware in sequence
            var outgoingRequest = request
            for m in middlewareItems {
                outgoingRequest = m.process(request: &outgoingRequest)
            }
            
            // now send the request over the wire
            let task = session.dataTask(with: outgoingRequest) { (data, response, error) in
                
                // pass the response thourhg the middleware in reverse order
                self.middlewareItems.reversed().forEach { (m: TingleApiClientMiddleware) in
                    m.process(response: response, data: data, error: error)
                }
                
                // prepare the variables for resource and problem
                var resource: TResource? = nil
                var problem: TProblem? = nil
                var result: TResourceResponse? = nil
                
                // cast response to the HTTP version
                if let response = response as? HTTPURLResponse {
                    
                    // get the status code
                    let statusCode = response.statusCode
                    
                    // if the response was successful, decode the resource, else the problem
                    if (data != nil && data!.count > 0) {
                        if (200..<300 ~= statusCode) {
                            resource = try! self.decoder.decode(TResource.self, from: data!)
                        } else {
                            problem = try! self.decoder.decode(TProblem.self, from: data!)
                        }
                    }
                    
                    // get the headers
                    let headers = response.allHeaderFields
                    
                    // generate the result
                    result = resultBuilder(statusCode, headers, resource, problem)
                }
                
                // invoke the completion handler
                completionHandler(result, error)
            }
            
            task.resume()
            
            return task
    }
    
//    typealias RequestHandler = (inout URLRequest) -> URLRequest
////    let rootRequestHandler: RequestHandler = { $0 }
////
////    func makeChain(next: RequestHandler) -> RequestHandler {
////
////        return rootRequestHandler
////    }
//
//    func makeChain2(next: RequestHandler, request: inout URLRequest) -> URLRequest {
//        return next(&request)
//    }
//
//    func makeChain3(next: @escaping RequestHandler, request: inout URLRequest) -> RequestHandler {
//        return { next(&$0) }
//    }
//
//    func makeOutgoingChain(handlers: [RequestHandler], request: inout URLRequest) -> RequestHandler {
////        var prev = handlers.isEmpty ? rootRequestHandler : handlers.first
////        var result: RequestHandler = { $0 }
//        var result = handlers.first
//        for i in 0..<(handlers.count - 1) {
//            let current = handlers[i]
//            let nextIndex = i + 1
//            if (nextIndex < (handlers.count - 1)) {
//                let next = handlers[nextIndex]
//                result = {
//                    next($0)
//                }
//            }
//        }
////        for h in handlers {
////            makeChain3(next: h, request: &URLRequestrequest)
////        }
//    }
}
