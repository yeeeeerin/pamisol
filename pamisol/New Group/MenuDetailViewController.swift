//
//  MenuDetailViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 15..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MenuDetailViewController: UIViewController {
    
    
    @IBOutlet var header: UIView!
    @IBOutlet var tableview: UITableView!
    
    
    @IBOutlet var menuImg: UIImageView!
    @IBOutlet var menuName: UILabel!
    @IBOutlet var menuGrade: UILabel!
    @IBOutlet var menuInfo: UILabel!
    @IBOutlet var menuPrice: UILabel!
    
    @IBOutlet var reviewCount: UILabel!
    
    @IBOutlet var menuKeepBtn: UIBarButtonItem!
    
    var url:String!
    
    var reviewList:[[String:Any]] = []
    
    /*
     1 = 간직 안함
     2 = 간직 함
     */
    var followStatus:Int = 1
    var followToggleURL:String = ""
    @IBOutlet var followRBtn: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMenuData()
        getReviewData()
        
        ui()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func ui(){
        
        header.layer.cornerRadius = 5
        header.clipsToBounds = true
        
        self.tableview.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //간직하기 눌렀을 때
    @IBAction func clickFollow(_ sender: UIBarButtonItem) {
        likeAndKeepToggle()
        //팔로우하고 있는 상태였다면
        if self.followStatus == 2{
            followStatus = 1
            followRBtn.title = "간직하기"
        }
            //팔로우 하고 있는 상태가 아니라면
        else if self.followStatus == 1{
            followStatus = 2
            followRBtn.title = "간직안함"
        }
        
    }


}

extension MenuDetailViewController{
    
    //간직 토글
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
                    print("간직Toggle 성공")
                case .failure(_):
                    print("간직Toggle 실패")
                }
                
        }
    }
    
    
    func getReviewData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + self.url+"review/"
        
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
                    if let JSON = response.result.value as? [String : Any] {
                        //var is_success:Bool = false
                        self.reviewList = (JSON["results"] as? [[String:Any]])!
                        self.tableview.reloadData()
                        
                        
                        
                    }
                case .failure(_):
                    print("dd")
                }
                
        }
        
    }
    
    
    func getMenuData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + self.url
        
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
                    if let JSON = response.result.value as? [String : Any] {

                        self.followToggleURL = JSON["keep_btn"] as! String
                        
                        //내가 이 메뉴를 간직하고 있는지
                        if JSON["keep_status"] as! Bool{
                            self.followRBtn.title = "간직중"
                            self.followStatus = 1
                            
                        }
                        
                        if let imgUrl:String = JSON["image"] as? String{
                            
                            Alamofire.request(imgUrl, method: .get).responseImage { response in
                                switch response.result {
                                case .success(let image):
                                    self.menuImg.image = image
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                        self.menuName.text = JSON["name"] as? String
                        self.menuInfo.text = JSON["description"] as? String
                        self.menuPrice.text = String(JSON["price"] as! Int) + "원"
                        
                        let likeUser:[String] = JSON["like_user"] as! [String]
                        if likeUser.isEmpty {
                            self.reviewCount.text = "아직 좋아요가 없습니다."
                        }
                        else{
                            self.reviewCount.text = likeUser[0] + "님 외 " + String(JSON["like_user_count"] as! Int) + "명이 있습니다."
                        }
                        
                    }
                case .failure(_):
                    print("dd")
                }
                
        }
        
    }
    
}

extension MenuDetailViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !reviewList.isEmpty{
            return reviewList.count
        }
        return 0

    }
    
    //셀에 표시 될 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Review Cell",for:indexPath) as! StoreMenuReviewCell
        
        if !reviewList.isEmpty{
            let reviewData = self.reviewList[indexPath.row]
            
            /*
             @IBOutlet var userid: UILabel!
             @IBOutlet var grade: UILabel!
             @IBOutlet var mainimg: UIImageView!
             @IBOutlet var reviewText: UILabel!
             @IBOutlet var like: UILabel!
             @IBOutlet var commentCount: UILabel!
             @IBOutlet var comment: UILabel!
             */
            cell.userid.text = reviewData["profile"] as? String
            
            cell.mainimg.layer.cornerRadius = 33
            cell.mainimg.layer.masksToBounds = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //프로필 이미지
            if let imgUrl:String = reviewData["profile_image_url"] as? String{

                let url = appDelegate.basicURL + ":8003/media/" + imgUrl
                Alamofire.request(url, method: .get).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        cell.mainimg.image = image
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            cell.reviewText.text = reviewData["text"] as? String
            
            //누구누구님 외 몇명이 좋아합니다.
            let likeUser:[String] = reviewData["like_user_list"] as! [String]
            if likeUser.isEmpty {
                cell.like.text = "아직 좋아요가 없습니다."
            }
            else{
                cell.like.text = "♥"+likeUser[0] + "님 외 " + String(reviewData["like_user_count"] as! Int) + "명이 좋아합니다."
            }
            
            //댓글이 없을때 , 있을때
            if let commentList:[Any] = reviewData["review_comment"] as? [Any]{
                if commentList.count == 0{
                    cell.commentCount.text = "아직 댓글이 없습니다."
                }else{
                    
                    cell.commentCount.text = String(commentList.count)+"개의 댓글이 있습니다."
                    
                    let closet_user = reviewData["closest_comment_user"] as! String
                    let closet_comment = reviewData["closest_comment"] as! String
                    
                    cell.comment.text = closet_user+". "+closet_comment
                    
                }
            }

            let reviewImgList:[String] = [(reviewData["image"] as! String),
                                          (reviewData["image_2"] as! String),
                                          (reviewData["image_3"] as! String)]
            

            cell.reviewImg = reviewImgList
            
            cell.grade.text = "★" + String(reviewData["grade"] as! Int)

            cell.collectionView.reloadData()

            
        }
        
        return cell
    }
    
}
