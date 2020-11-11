//
//  BaseVC.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-11.
//

import UIKit

//It's a superviewcontroller for UserListVC and PhotoCollectionVC
class BaseVC: UIViewController {
    var vcTitle : String = "" {
        didSet {
            self.title = vcTitle
        }
    }
}
