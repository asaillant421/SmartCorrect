//
//  APIManager.swift
//  SmartCorrect
//
//  Created by מאיר רדנוביץ׳ on 27 Tamuz 5782.
//

import Foundation
import os.log

class APIManager {
    static let shared = APIManager()
    
    private let log = OSLog(subsystem: Constants.apiBundleIdentifier, category: "api")
    
    private let debuggingDelegate = DebuggingDelegate()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }()
    
    private var host: APIHost {
        HostManager.shared.selectedHost
    }
    
    private init() {
        
    }
    
    private func createQueryParamRequest<P: Encodable>(url: URL, params: P) throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.badURL(url.absoluteString)
        }
        
        let d = try params.encodeJSON()
        guard let paramDict = try JSONSerialization.jsonObject(with: d) as? [String:Any] else {
            throw APIError.encodingError(params)
        }
        
        // TODO: Improve upon this for more complicated Encodable objects if query params are necessary
        let queryItems = paramDict.map { (key: String, value: Any) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        components.queryItems = queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?.percentEscaped()
        
        var req = URLRequest(url: components.url ?? url)
        
        req.addValue(NetworkingConstants.MimeType.JSON.rawValue, forHTTPHeaderField: NetworkingConstants.Accept)
        
        return req
    }
    
    private func createJSONBodyRequest<P: Encodable>(url: URL, params: P) throws -> URLRequest {
        var request = URLRequest(url: url)
        
        let d = try params.encodeJSON()
        
        request.httpBody = d
        request.addValue(NetworkingConstants.MimeType.JSON.rawValue, forHTTPHeaderField: NetworkingConstants.ContentType)
        request.addValue(NetworkingConstants.MimeType.JSON.rawValue, forHTTPHeaderField: NetworkingConstants.Accept)
        
        return request
    }
    
    private func createRequest(endpoint: Endpoint, authToken: String? = nil) throws -> URLRequest {
        let fakeParam: Int? = nil
        return try createRequest(endpoint: endpoint, params: fakeParam, authToken: authToken)
    }
    
    private func createRequest<P: Encodable>(endpoint: Endpoint, params: P?, authToken: String? = nil) throws -> URLRequest {
        guard let u = endpoint.url else {
            throw APIError.badURL("\(HostManager.shared.selectedHost.url)/\(endpoint.path)")
        }
        
        var request: URLRequest
        
        if let params = params {
            if endpoint.method.acceptsBody {
                request = try createJSONBodyRequest(url: u, params: params)
            } else {
                request = try createQueryParamRequest(url: u, params: params)
            }
        } else {
            request = URLRequest(url: u)
        }
        
        if let authToken = authToken {
            request.addValue(authToken, forHTTPHeaderField: NetworkingConstants.Authorisation)
        }
        
        request.httpMethod = endpoint.method.rawValue
        
        return request
    }

    func sendRequest<R: Decodable>(endpoint: Endpoint, authToken: String? = nil) async throws -> R {
        let dummyParam: Int? = nil
        
        return try await sendRequest(endpoint: endpoint, params: dummyParam, authToken: authToken)
    }
    
    func download(fromURL url: URL, authToken: String? = nil) async throws -> URL {
        return try await download(fromEndpoint: .download(url), authToken: authToken)
    }
    
    func download(fromEndpoint endpoint: Endpoint, authToken: String? = nil) async throws -> URL {
        let req = try createRequest(endpoint: endpoint, authToken: authToken)
        
        os_log(.debug, log: log, "FLUFFERNUTTER DL Req. = %{public}@", endpoint.path)
        
        let (downloadedURL, _) = try await session.download(for: req)
        
        return downloadedURL
    }
    
    func sendRequest<P: Encodable, R: Decodable>(endpoint: Endpoint, params: P?, authToken: String? = nil) async throws -> R {
        let req = try createRequest(endpoint: endpoint, params: params, authToken: authToken)
        
        os_log(.debug, log: log, "FLUFFERNUTTER Request = %{public}@", endpoint.path)
        
        let (data, response) = try await session.data(for: req, delegate: debuggingDelegate)
        
        os_log(.debug, log: log, "FLUFFERNUTTER Response = %{public}@, Body: %{public}@", response.betterDescription, data.s)
        
        let parsedData = try Constants.decoder.decode(ResponseResult<R>.self, from: data)
        
        switch parsedData {
        case let .success(goodness):
            return goodness
        case let .failure(err):
            throw err
        }
    }
}

