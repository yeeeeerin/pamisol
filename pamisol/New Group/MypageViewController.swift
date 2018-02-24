//
//  MypageViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 11..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MypageViewController: UIViewController {
    
    var url:String = ""
    var fromListUrl:String = ""
    
    var url_list_reviewer:String = ""
    var url_list_store:String = ""
    var url_list_followed:String = ""
    
    @IBOutlet var header: UIView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var storeFollowing: UILabel!
    @IBOutlet var reviewerFollowing: UILabel!
    @IBOutlet var folloer: UILabel!
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userMessage: UILabel!         //유저 상테메세지
    
    @IBOutlet var reviewListBtn: UIButton!      //리뷰목록 버튼
    @IBOutlet var keepStoreBtn: UIButton!       //간직한 맛집 버튼
    
    @IBOutlet var reviewListContainer: UIView!
    @IBOutlet var keepStoreContainer: UIView!
    
    @IBOutlet var followRBtn: UIBarButtonItem!  //follow relations button
    
    var listView: ReviewListContainerView? = nil
    
    var profilePK:Int = 1
    
    /*
     내 페이지인지 다른 사람 페이지인지 확인
     false = 내 페이지
     true = 다른사람 페이지
     */
    var is_other:Bool = false
    
    /*
     내가 팔로우를 하고있는 상태인지 안하고있는 상태인지 확인
     1 = 팔로우 안함
     2 = 팔로우 함
     0 = 나
     */
    var followStatus:Int = 2
    var followToggleURL:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //만약 전 화면이 tab_bar로 들어온 화면이 아니라면???
        if self.url.isEmpty {
            
            print("in! self.url.isEmpty  -  MypageViewController")
            self.url = ":8003/profile/"+String(appDelegate.profilePK)+"/"
            

        }else{
            print("MypageViewController - viewWillAppear")
            print(self.url)
        }
        listView?.url = appDelegate.basicURL+url
        keepStoreContainer.isHidden = true
        userDataJson()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPageUI()
        
    }
    
    //UI관련 처리
    func myPageUI(){
        //profile image radius add
        profileImg.layer.cornerRadius = 42
        profileImg.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
        profileImg.clipsToBounds = true
        
    
        reviewListBtn.addBottomBorderWithColor(color: UIColor.black, width: 2)
        keepStoreBtn.addBottomBorderWithColor(color: UIColor.black, width: 0.6)
        

        

    }
    
    
    //review목록 또는 간직한 맛집을 눌렀을 때
    @IBAction func clickListBtn(_ sender: UIButton) {
        if sender == reviewListBtn{
            keepStoreContainer.isHidden = true
            reviewListContainer.isHidden = false
            
            

        }
        else if sender == keepStoreBtn {
            keepStoreContainer.isHidden = false
            reviewListContainer.isHidden = true
        

        }
    }
    
    //follow 또는 unfollow버튼을 눌렀을 때
    @IBAction func clickFollow(_ sender: UIBarButtonItem) {
        likeAndKeepToggle()
        //팔로우하고 있는 상태였다면
        if self.followStatus == 2{
            followStatus = 1
            followRBtn.title = "unfollow"
        }
        //팔로우 하고 있는 상태가 아니라면
        else if self.followStatus == 1{
            followStatus = 2
            followRBtn.title = "follow"
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list_store"{
            
            let vc = segue.destination as! FollowingStoreTableViewController
            vc.url = url_list_store
            
        }
        else if segue.identifier == "list_reviewer"{
            
            let vc = segue.destination as! FollowingUserTableViewController
            vc.url = url_list_reviewer
        }
        else if segue.identifier == "To Keep Contain"{
            let destination = segue.destination as! KeepStoreContainerView
            destination.profilePK = profilePK
        }
    }
    

}
//json 관련 처리
extension MypageViewController{
    
    
    //follow toggle
    func likeAndKeepToggle() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //test
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + ":8003" + followToggleURL
        
        //데이터 가져오는 부분
        Alamofire.request(fullURL, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                //debugPrint(response)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    print("FollowToggle 성공")
                case .failure(_):
                    print("FollowToggle 실패")
                }
                
        }
    }
    
    //기본 데이터 가져오는 부분
    func userDataJson(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]

        print(appDelegate.token)
        //데이터 가져오는 부분
        
        let fullURL = appDelegate.basicURL+url
        //let fullURL = appDelegate.basicURL+":8003/profile/1/"
        
        Alamofire.request(fullURL, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                //debugPrint(response)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    if let JSON = response.result.value as? [String : Any] {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        var is_success:Bool = false
                        
                        if JSON["code"] as! Int == 2000{
                            is_success = true
                        }
                        
                        if is_success{
                            if let data = JSON["data"] as? [String:Any]{
                                //내 페이지인지 내 페이지가 아닌지 확인
                                //내 페이지면 hidden!!!
                                print("MypageViewController pk 값 확인")
                                
                                print(String(data["pk"] as! Int))
                                
                                //내가 이 사람을 팔로우 하고 있는지 안하고 있는지 확인
                                if data["follow_status"] as! Bool{
                                    self.followRBtn.title = "unfollow"
                                    self.followStatus = 1
                                    
                                }
                                
                                if (data["pk"] as! Int) == appDelegate.profilePK {
                                    self.is_other = false
                                    self.followRBtn.isEnabled = false
                                    self.followRBtn.title = " "
                                    self.followStatus = 0
                                }
                                
                                
                                self.followToggleURL = data["url_follow_toggle"] as! String
                                
                                self.url_list_reviewer = data["url_list_reviewer"] as! String
                                self.url_list_store = data["url_list_store"] as! String
                                self.url_list_followed = data["url_list_followed"] as! String
                                
                                let imgUrl:String = data["image"] as! String
                                //appDelegate.basicURL + ":8003" + imgUrl
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                let fullImgUrl:String = appDelegate.basicURL + ":8003" + imgUrl
                                print("fullImgUrl")
                                print(fullImgUrl)
                                Alamofire.request(fullImgUrl, method: .get).responseImage { response in
                                    switch response.result {
                                    case .success(let image):
                                        self.profileImg.image = image
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                                self.userName.text = (data["user"] as! String)
                                self.userMessage.text = (data["description"] as! String)
                                
                                self.storeFollowing.text = String(data["store_following_count"] as! Int)
                                self.reviewerFollowing.text = String(data["following_count"] as! Int)
                                
                                self.folloer.text = String(data["followed_by_count"] as! Int)
                                
                                self.listView?.reviews = data["reviews"] as! [Any]
                            }
                        }
                        
                    }
                case .failure(_):
                    print("MypageViewController 실패")
                }
                
                
        }
    }
}

