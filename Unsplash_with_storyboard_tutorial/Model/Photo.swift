//
//  Photo.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-13.
//

import Foundation

struct Photo : Decodable {
    var thumb : String
    var username : String
    var likes : Int
    var created_at : String
}
