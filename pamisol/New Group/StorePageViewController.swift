//
//  StorePageViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 12..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class StorePageViewController: UIViewController {
    
    
    @IBOutlet var tableview: UITableView!
    
    var url:String = ""
    var storePK:Int!
    
    @IBOutlet var storeImg: UIImageView!
    @IBOutlet var storeName: UILabel!
    @IBOutlet var storeInfo: UILabel!
    
    @IBOutlet var storeLocation: UIButton!
    
    @IBOutlet var notice1: UILabel!
    @IBOutlet var notice2: UILabel!
    @IBOutlet var notice3: UILabel!
    
    var menuList:[[String:Any]]=[]
    
    @IBOutlet var followRBtn: UIBarButtonItem!
    var followToggleURL:String = ""
    /*
     1 = 팔로우 안함
     2 = 팔로우 함
     */
    var followStatus:Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStoreData()
        noticePreviewData()
        getMenuListData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        storeViewUI()
    }

    func storeViewUI(){
        
        self.tableview.separatorStyle = .none
        
        storeImg.layer.cornerRadius = 27
        storeImg.clipsToBounds = true
    }
    
    @IBAction func followClick(_ sender: UIBarButtonItem) {
        
       
        //팔로우하고 있는 상태였다면
        if self.followStatus == 2{
            followStatus = 1
            followRBtn.title = "follow"
        }
            //팔로우 하고 있는 상태가 아니라면
        else if self.followStatus == 1{
            followStatus = 2
            followRBtn.title = "unfollow"
        }
        
         likeAndKeepToggle()
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //메누 디테일로 넘어갈 때
        
        if let indexPath = self.tableview.indexPathForSelectedRow{
            //let selectedRow = indexPath.row
            let detailVC = segue.destination as! MenuDetailViewController
            let menuPK:Int = menuList[indexPath.row]["pk"] as! Int
            detailVC.url = ":8003/store/"+String(self.storePK)+"/menu/"+String(menuPK)+"/"
        }
        
    }
    

}

//json통신 관련
extension StorePageViewController{
    
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
    
    
    //notice preview를 위한....
    func noticePreviewData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //test
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + ":8003/store/" + String(self.storePK) + "/notice_thumbnail/"
        
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
                        if let results = JSON["results"] as? [[String:Any]]{
                            if results.count >= 1{
                                self.notice1.text = results[0]["title_thumbnail"] as? String
                            }
                            
                            if results.count >= 2{
                                self.notice2.text = results[1]["title_thumbnail"] as? String
                            }
                            
                            if results.count >= 3{
                                self.notice3.text = results[2]["title_thumbnail"] as? String
                            }
                        }
                        
                    }
                case .failure(_):
                    print("dd")
                }
                
        }
    }
    
    func getStoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + ":8003/store/" + String(self.storePK) + "/"
        //데이터 가져오는 부분
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
                        //var is_success:Bool = false
                        
                        //가게 대표 이미지 받아오기
                        if let imgUrl:String = JSON["image"] as? String{
                            Alamofire.request(imgUrl, method: .get).responseImage { response in
                                switch response.result {
                                case .success(let image):
                                    self.storeImg.image = image
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                        //가게명 가져오기
                        if let name:String = JSON["name"] as? String{
                            self.storeName.text = name
                        }
                        
                        //가게 설명 가져오기
                        if let info = JSON["description"] as? String{
                            self.storeInfo.text = info
                        }
                        
                        //가게 위치 가져오기
                        if let location = JSON["locations"] as? String{
                            self.storeLocation.titleLabel?.text = location
                        }
                        
                        self.storePK = JSON["pk"] as! Int
                        
                        //내가 이 사람을 팔로우 하고 있는지 안하고 있는지 확인
                        if JSON["follow_status"] as! Bool{
                            self.followRBtn.title = "follow"
                            self.followStatus = 2
                            
                        }
                        
                        self.followToggleURL = JSON["follow_btn"] as! String
                        
                        
                    }
                case .failure(_):
                    print("dd")
                }
 
        }
    
    }
    
    func getMenuListData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + ":8003/store/" + String(storePK) + "/menu/"
        
        //데이터 가져오는 부분
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
                        //var is_success:Bool = false
                        self.menuList = (JSON["results"] as? [[String:Any]])!
                        self.tableview.reloadData()
                    }
                case .failure(_):
                    print("dd")
                }
                
        }
        
    }
}

extension StorePageViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !menuList.isEmpty{
            return menuList.count
        }
        return 0
    }
    
    //셀에 표시 될 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Store Page Cell",for:indexPath) as! StorePageCell
        
        if !menuList.isEmpty{
            let menuData = self.menuList[indexPath.row]
            
            cell.header.layer.borderColor = UIColor.gray.cgColor
            cell.header.layer.borderWidth = 1
            cell.header.layer.cornerRadius = 7
            cell.header.layer.masksToBounds = true
            
            cell.menuName.text = menuData["name"] as? String
            cell.menuInfo.text = menuData["description"] as? String
            cell.price.text = String(menuData["price"] as! Int) + "원"
            
            let likeUser:[String] = menuData["like_user"] as! [String]
            if likeUser.isEmpty {
                cell.likeReviewCount.text = "♥아직 좋아요가 없습니다."
            }
            else{
                cell.likeReviewCount.text = "♥" + likeUser[0] + "님 외 " + String(menuData["like_user_count"] as! Int) + "명이 있습니다."
            }
            
            if menuData["like_status"] as! Bool {
                cell.likeBtn.setImage(UIImage(named: "like_in") , for: .normal)
                cell.likeStatus = true
            }
            
            if menuData["keep_status"] as! Bool{
                cell.bucketBtn.setImage(UIImage(named: "bucket_in") , for: .normal)
                cell.keepStatus = true
            }
            
            cell.likeToggleURL = menuData["like_btn"] as! String
            cell.keepToggleURL = menuData["keep_btn"] as! String
            
            cell.grade.text = String(format: "%.1f", menuData["grade"] as! Float) + "★"
            
            if let imgUrl:String = menuData["image"] as? String{
                Alamofire.request(imgUrl, method: .get).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        cell.img.image = image
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        

        return cell
    }
    
    //테이블뷰 안에있는 내용을 선택했을 시 테이블뷰를 숨김
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}


