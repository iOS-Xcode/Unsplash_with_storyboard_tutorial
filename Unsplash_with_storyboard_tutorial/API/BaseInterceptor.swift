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
    //Request 호출할 때 같이 호출, 헤더 부분 설정
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() called")
        var request = urlRequest
        //받을 때 Json 형태로 받음.
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        //Add public parameters, 공통파라미터 추가
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
    //재확인
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        let data = ["statusCode" : statusCode]
        //userInfo에 데이타를 보냄
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
        completion(.doNotRetry)
    }
}
