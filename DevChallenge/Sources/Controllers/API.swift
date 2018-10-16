//
//  API.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

let serverURL = "https://jsonplaceholder.typicode.com/"
typealias APIResponse = ((JSON, Error?) -> Void)

protocol RequestProtocol {
    var baseURL: String { get }
    var path: Path { get }
    var fullURL: String { get }
    var encoding: ParameterEncoding { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
    var queryID: String? { get }
}

@objc class API: NSObject {
    @objc static let shared = API()
    var manager: SessionManager!
    
    override private init() {
        super.init()
        let config = URLSessionConfiguration.default
        manager = SessionManager(configuration: config)
    }
}

extension API {
    func request(_ request: APIRequest, completion: @escaping APIResponse) {
        let apiRequest = manager.request(request.fullURL,
                                         method: request.method,
                                         parameters: request.parameters,
                                         encoding: request.encoding,
                                         headers: request.headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let value):
                    completion(JSON(value), nil)
                case .failure(let error):
                    completion(JSON.null, error)
                }
        }
        print(apiRequest.description)
    }
}

enum Path: String {
    case comments = "comments"
}

enum APIRequest {
    case getAllComments()
    case getComment(_ identifier: Int)
}

extension RequestProtocol {
    
    var baseURL: String {
        return serverURL
    }
    
    var fullURL: String {
        var url = baseURL + path.rawValue
        if let id = queryID {
            url = url+"/"+id
        }
        return url
    }
    
}

extension APIRequest: RequestProtocol {
    
    var path: Path {
        switch self {
        case .getAllComments,
             .getComment:
            return .comments
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllComments,
             .getComment:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters {
        switch self {
        default:
            return Parameters()
        }
    }
    
    var queryID: String? {
        switch self {
        case .getComment(let identifier):
            return "\(identifier)"
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders()
        }
    }
    
}

