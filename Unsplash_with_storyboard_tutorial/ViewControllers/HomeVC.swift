//
//  HomeVC.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by Seokhyun Kim on 2020-11-10.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var keyboardDismissTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    @IBOutlet weak var searchSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func tappesSearchButton(_ sender: UIButton) {
//        AF.request("https://api.unsplash.com/search/photos").response {
//            response in
//            debugPrint(response)
//        }
        //let url = API.BASE_URL + "search/photos"
        guard let userInput = searchBar.text else {
            return
        }
        //key-value param
        //let queryParam = ["query" : userInput, "client_id" : API.CLIENTID]
        //This is a simple way to use Alamofire.
//        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: {
//            response in
//            debugPrint(response)
//        })
        var urlToCall : URLRequestConvertible?
        
        switch searchSegment.selectedSegmentIndex {
        case 0:
            urlToCall = SearchRouter.searchPhotos(term: userInput)
        default:
            urlToCall = SearchRouter.searchUsers(term: userInput)
        }
        
        if let urlConvertible = urlToCall {
            //For use router, header and public params
        AlamofireManager
            .shared
            .session
            .request(urlConvertible)
            //
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                debugPrint(response)
            })
        //pushVC()
    }
    }
    
    @IBAction func filterValueChanged(_ sender: UISegmentedControl) {
        var searchBarTitle = ""
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "Photo keyword"
        default:
            searchBarTitle = "User name"
        }
        searchBar.placeholder = "Input " + searchBarTitle
        //Focus search bar
        searchBar.becomeFirstResponder()
        //release focus
        searchBar.resignFirstResponder()
    }
    
    fileprivate func pushVC() {
        var sequeId = ""
        switch searchSegment.selectedSegmentIndex {
        case 0:
            sequeId = "goToPhotoCollectionVC"
        default:
            //goToUserListVC
            sequeId = "goToUserListVC"
        }
        //transit viewController
        performSegue(withIdentifier: sequeId, sender: self)
    }
    
    //Prepare transit(segue way) before.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare = \(String(describing: segue.identifier))")
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            //get next viewController
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = searchBar.text else {
                return
            }
            nextVC.vcTitle = userInputValue + "😎"
        default:
            //get next viewController
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = searchBar.text else {
                return
            }
            nextVC.vcTitle = userInputValue + "💽"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Basically, It provides notification when keyboard show up as UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        //get keyboard size
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            print("searchButton position = \(searchButton.frame.origin.y)")
            
            if keyboardSize.height < searchButton.frame.origin.y {
                let distance = keyboardSize.height - searchButton.frame.origin.y
                view.frame.origin.y = distance + searchButton.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    fileprivate func setup() {
        //setupUI
        searchButton.layer.cornerRadius = 10
        
        searchBar.delegate = self
        
        keyboardDismissTapGesture.delegate = self
        
        view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    //MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //if touch on searchSegment
        if (touch.view?.isDescendant(of: searchSegment) == true) || (touch.view?.isDescendant(of: searchBar) == true) {
            return false
        } else {
            //end of editing so dismiss keyboard
            view.endEditing(true)
            return true
        }
    }
    
    //MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchButton.isHidden = true
            //Make delay when user tap clear button on search bar
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                //release focus
                searchBar.resignFirstResponder()
            })
        } else {
            searchButton.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //When keyword length is 0
        guard let userInput = searchBar.text else { return }
        if userInput.isEmpty {
            self.view.makeToast("🤓 Please input keyword", duration: 2.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //add a text on current string
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        //In case of length >= 12
        if inputTextCount >= 12 {
            //emoji ctrl + command + space
            self.view.makeToast("🤓 Only allow 12 length", duration: 2.0, position: .center)
        }
        
//        if inputTextCount <= 12 {
//            return true
//        } else {
//            //can't input anymore
//            return false
//        }
        return inputTextCount <= 12
    }

}

