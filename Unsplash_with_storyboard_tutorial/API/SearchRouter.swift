//
//  SearchRouter.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire

//Serach API
enum SearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    //Closer baseURL value
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
//        switch self {
//        case .searchPhotos: return .get
//        case .searchUsers: return .post
//        }
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters : [String : String] {
        switch self {
        //let == enum type
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query" : term]
        }
    }
    
    //throws ~ try - does not need to do ~ catch
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        print("SearchRouter - asURLRequest() url : \(url)")
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
