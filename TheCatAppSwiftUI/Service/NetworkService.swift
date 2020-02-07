//
//  NetworkService.swift
//  SwiftUIRxSwiftTheCatApp
//
//  Created by Admin on 1/30/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService  {
    
    private init() {}
    static let instance = NetworkService()
    
    typealias GenericCompletion<T> = (T?, Error?) -> ()
    fileprivate let baseURL = "https://api.thecatapi.com/v1/"
    fileprivate var requireHeaders: HTTPHeaders {
        return ["x-api-key":"c7ce8814-39f3-470f-85b5-5f27a64d01fa"]
    }
    
    func getCatList(limitCatElemnt : Int,_ completion: GenericCompletion<[Cat]>?) {
        let link = "images/search"
        let parameters = ["limit": limitCatElemnt]
        
        request(url: link, parameters: parameters, encoding: URLEncoding(destination: .queryString)) { (cats : [Cat]?, error) in
            guard let unrupCats = cats else { return }
            completion?(unrupCats, error)
        }

    }
    
    // Use this generic method for make request where you wait a data
    // This method has 3 require parameters: T, url and completion
    // @param: T - type model, which JSON represent will be returned when this request is executed
    // For correct parsing JSON to models, use https://app.quicktype.io service
    // @param: url - path of endpoint
    // @param: completion - callback, which will return parsing model or error
    fileprivate func request<T: Decodable>(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, extraHeaders: HTTPHeaders? = nil, _ completion: GenericCompletion<T>?) {
        
        request(url: url, method: method, parameters: parameters, encoding:encoding, extraHeaders: extraHeaders).validate(contentType: ["application/json"]).responseDecodable { (response: DataResponse<T>) in
            switch response.result {
            case .success(let value):
                completion?(value, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    // Use this method, where you don't wait a data
    // This method has 2 require parameters: url and completion
    // @param: url - path of endpoint
    // @param: completion - callback, which will return parsing model or error
    fileprivate func request(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, extraHeaders: HTTPHeaders? = nil, _ completion: GenericCompletion<String>?) {
        request(url: url, method: method, parameters: parameters, encoding:encoding, extraHeaders: extraHeaders).responseString { (response) in
            print(response.result)
            switch response.result {
            case .success(let value):
                completion?(value, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    private func request(url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default, extraHeaders: HTTPHeaders? = nil) -> DataRequest {
           var headers = requireHeaders
           if let extraHeaders = extraHeaders {
               headers = headers.merging(extraHeaders, uniquingKeysWith: { (current, _) in current })
           }
           return Alamofire.request(baseURL + url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate(statusCode: 200..<201)
       }
    
}

// MARK: - Alamofire response handlers
fileprivate extension DataRequest {
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
    func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try self.jsonDecoder.decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
}

