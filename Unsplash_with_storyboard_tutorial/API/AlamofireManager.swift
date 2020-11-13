//
//  AlamofireManager.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire

final class AlamofireManager {
    //Singleton conform
    static let shared = AlamofireManager()
    //Interceptors multi possiable
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    //multi possiable log
    let monitors = [Logger(), StatusLogger()] as [EventMonitor]
    //Session
    var session : Session
    
    private init() {
        session = Session(interceptor : interceptors, eventMonitors: monitors)
    }
}
