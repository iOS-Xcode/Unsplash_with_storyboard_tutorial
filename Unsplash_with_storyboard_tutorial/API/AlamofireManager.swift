//
//  AlamofireManager.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager {
    //Singleton conform
    static let shared = AlamofireManager()
    //Interceptors multi possiable, 공통파라미터, 헤더에 뭘 추가한다는 지.
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    //multi possiable log, 이벤트 모니터
    let monitors = [Logger(), StatusLogger()] as [EventMonitor]
    //Session
    var session : Session
    
    private init() {
        session = Session(interceptor : interceptors, eventMonitors: monitors)
    }
    
    //completion block, return Result type.
    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], ErrorHandle>) -> Void) {
        print("AlamofireManager - getPhotos() called", userInput)
        
        self.session
            .request(SearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            //.responseDecodable(completionHandler: { response in
            //.responseJSON(completionHandler: { response in
            .responseDecodable(of: Photo.self) { response in
                
                guard let responseValue = response.data else { return }
                
                let responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                
                var photos = [Photo]()
                
                print("jsonArray.count",jsonArray.count)
                
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index: \(index) , subJson : \(subJson)")
                    
                    //Data parsing
//                    let thumnail = subJson["urls"]["thumb"].string ?? ""
//                    let username = subJson["user"]["username"].string ?? ""
//                    let likesCount = subJson["likes"].intValue
//                    let createdAt = subJson["created_at"].string ?? ""
                    guard let thumnail = subJson["urls"]["thumb"].string,
                          let username = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else { return }
                    
                    let likesCount = subJson["likes"].intValue
                    
                    let photoItem = Photo(thumb: thumnail, username: username, likes: likesCount, created_at: createdAt)
                    photos.append(photoItem)
                    print("photos.count",photos.count)
                }
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
            }
    }
}
