//
//  Constants.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollectionVC"
}

enum API {
    static let BASE_URL : String = "https://api.unsplash.com/"
    static let CLIENTID : String = "_Zu43dcoiRYH1j14XHFZCGWNnrYVC1HSmUGrR4SZwTk"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
