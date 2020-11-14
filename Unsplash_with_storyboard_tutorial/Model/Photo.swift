//
//  Photo.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-13.
//

import Foundation

struct Photo : Codable {
    var thumnail : String
    var userName : String
    var likesCount : Int
    var createdAt : String
}
