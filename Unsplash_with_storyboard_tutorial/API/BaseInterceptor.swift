//
//  BaseInterceptor.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    //Add header and public parameters with interceptor for request
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        var request = urlRequest
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "accept")
        
        //Add public parameters
        //If you want to make "401", commant below.
        var dic = [String : String]()
        dic.updateValue(API.CLIENTID, forKey: "client_id")
        
        do {
            request = try URLEncodedFormParameterEncoder().encode(dic, into: request)
        } catch {
            print(error)
        }
        //must to call comlection block by completion: @escaping
        completion(.success(request))
    }
    
    //In case of setting validate in AlamofireManager
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        let data = ["statusCode" : statusCode]
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
        completion(.doNotRetry)
    }
}
