//
//  ReviewListContainerView.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 12..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//마이페이지에서 리뷰목럭누르면 나오는 테이블 뷰

import UIKit
import Alamofire
import AlamofireImage

class ReviewListContainerView: UIViewController {

    var url:String!
    var reviews:[Any] = []
    
    @IBOutlet var tableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.url = ":8003/profile/"+String(4)+"/"
        
        listJson()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.separatorStyle = .none
        
        print(self.url)
        
    }
    
    func listJson() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        //데이터 가져오는 부분
        Alamofire.request(appDelegate.basicURL + url, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                debugPrint(response)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    if let JSON = response.result.value as? [String : Any] {
                        
                        for datas in JSON{
                            if datas.key == "data"{
                                for data in datas.value as! [String:Any] {
                                    if data.key == "reviews"{
                                        
                                        if let profileDatas:[Any] = data.value as? [Any] {
                                            self.reviews = profileDatas
                                            
                                            self.tableview.reloadData()
                                            
                                            for profileData in profileDatas{
                                                let profile:[String:Any] = profileData as! [String : Any]
                                                print(profile["url"])
                                            }
                                            
                                        }
                                        
                                        //print(testdata[0])
                                        //self.reviews = datas.value as! [Any]
                                    }
                                }
                            }
                        }
                    }
                case .failure(_):
                    print("fail")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReviewListContainerView:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.isEmpty{
            return 0
        }
        return reviews.count
    }
    
    //any를 기반으로
    //셀에 표시 될 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "RLC Cell",for:indexPath) as! ReviewListContainerCell
        
        
        if !reviews.isEmpty{
            cell.view.layer.borderColor = UIColor.gray.cgColor
            cell.view.layer.borderWidth = 1
            cell.view.layer.cornerRadius = 7
            cell.view.layer.masksToBounds = true
            
            let review:[String:Any] = reviews[indexPath.row] as! [String:Any]
            print("tableView - cellForRowAt test!!!")
            print(review)
            print(reviews)
            //print(review["url"])
            let url:String = "http://192.168.0.10:8003/media/" + (review["image"] as! String)
            
            Alamofire.request(url, method: .get).responseImage { response in
                switch response.result {
                case .success(let image):
                    cell.img.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            /*
            cell.img.image = UIImage.init(named: "gg.png")
            cell.like.text = "yerin님 외 18명이 좋아합니다."
            cell.info.text = "yerin. 진짜정말 너무 맛있다 맛있어서 눈물난다 진짜 눈물을 흘리면서 먹었다 먹으면서 눈물이 나왔다."
            cell.menu.text = "회사밥"
            cell.store.text = "스마게!"
             */
          
            let likeUser = review["like_user_list"] as! [String]
            if likeUser.isEmpty{
                cell.like.text = "♥아직 좋아요가 없습니다."
            }
            else{
                cell.like.text = "♥"+likeUser[0] + "님 외 " + String(review["like_user_count"] as! Int)+"명이 좋아합니다."
            }
            cell.info.text = (review["profile"] as! String) + ". " + (review["text"] as! String)
            cell.menu.text = review["menu"] as? String
            cell.store.text = review["store"] as? String

        }
        return cell
    }
    
    //테이블뷰 안에있는 내용을 선택했을 시 테이블뷰를 숨김
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
}

