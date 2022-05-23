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
    
    var keyboardDismissTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: HomeVC.self, action: nil)
    
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
            //urlToCall = SearchRouter.searchPhotos(term: userInput)
        AlamofireManager
            .shared
            //If you want to use "self" in closer, you should weak self the reason are
            //                                   // 클로저 arc
            // automatic reference count
            // 자동 메모리사용수 계산
            // stack, heap 메모리 영역
            // class, closure 등이 사용
            // weak self
            // self 는 메모리 카운트를 증가
            // weak self 를 통해 메모리를 가지고 있는 것을 방지
            // 다음과 같이  self.메소드등 self 를 사용해야 하는 경우 weak self 로 메모리에 계속 잡고 두고 있는 것을 방지
            .getPhotos(searchTerm: userInput, completion: {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let fetchedPhotos):
                    print("HomeVC - getPhotos.success", fetchedPhotos.count)
                case .failure(let error):
                    print("HomeVC - getPhotos.failure - error : \(error.rawValue)")
                    //밑의 self는 약한 참조로..[weak self]에 의해
                    self.view.makeToast(error.rawValue, duration: 2.0, position: .center)
                }
            })
        case 1:
            urlToCall = SearchRouter.searchUsers(term: userInput)
        default:
            print("default")
        }
        
//        if let urlConvertible = urlToCall {
//            //For use router, header and public params
//        AlamofireManager
//            .shared
//            .session
//            .request(urlConvertible)
//            //
//            .validate(statusCode: 200..<401)
//            .responseJSON(completionHandler: { response in
//                debugPrint(response)
//            })
//        //pushVC()
//    }
    }
    
    @IBAction func filterValueChanged(_ sender: UISegmentedControl) {
        var searchBarTitle = ""
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "Photo keyword"
        case 1:
            searchBarTitle = "User name"
        default:
            searchBarTitle = "Keyword of photo"
        }
        searchBar.placeholder = "Input " + searchBarTitle
        //Focus search bar
        searchBar.becomeFirstResponder()
        //release focus
        //searchBar.resignFirstResponder()
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
        //즉 iOS에서 키보드가 올라가는 것을 알려줌.
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
                //키보드가 덮은 만큼 올려줌.
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
        //if touch on searchSegment or searchBar, Descendant : 자손
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
        print("shouldChangeTextIn : \(inputTextCount) / text : \(text)")

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

