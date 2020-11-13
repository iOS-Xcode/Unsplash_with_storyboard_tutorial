//
//  StatusLogger.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire

final class StatusLogger : EventMonitor {
    let queue = DispatchQueue(label: "StatusLogger")
//    func requestDidResume(_ request: Request) {
//        print("StatusLogger - requestDidResume() called")
//        debugPrint(request)
//    }
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("StatusLogger - didParseResponse() called")
        guard let statusCode = request.response?.statusCode else { return }
        print("StatusLogger - didParseResponse \(statusCode)")
    }
}
