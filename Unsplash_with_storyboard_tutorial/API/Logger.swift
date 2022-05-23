//
//  Logger.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation
import Alamofire

final class Logger : EventMonitor {
    //큐설정
    let queue = DispatchQueue(label: "Logger")
    func requestDidResume(_ request: Request) {
        print("Logger - requestDidResume() called")
        debugPrint(request)
    }
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("Logger - didParseResponse() called")
        debugPrint(response)
    }
}
