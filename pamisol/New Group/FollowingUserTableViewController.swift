//
//  FollowingUserTableViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 1..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire

class FollowingUserTableViewController: UITableViewController {
    
    var url:String = ""
    var following_list:[[String:Any]]=[]

    override func viewDidLoad() {
        super.viewDidLoad()

        getJsonData()
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !following_list.isEmpty{
            return following_list.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toReviewer Cell", for: indexPath) as! StoreListTableViewCell
        
        if !following_list.isEmpty{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let imgUrl:String = following_list[indexPath.row]["image"] as? String{
                let url:String = appDelegate.basicURL + ":8003" + imgUrl
                Alamofire.request(url, method: .get).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        cell.userimg.layer.borderWidth = 0.7
                        cell.userimg.layer.cornerRadius = 25
                        cell.userimg.layer.borderColor = UIColor(rgb: 0xDEDEDE).cgColor
                        cell.userimg.clipsToBounds = true
                        cell.userimg.image = image
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            cell.userID.text = following_list[indexPath.row]["username"] as? String
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //유저로 넘어갈 때
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let detailVC = segue.destination as! MypageViewController
            let pk:Int = following_list[indexPath.row]["pk"] as! Int
            //detailVC.url = ":8003/store/"+String(pk)
            detailVC.url = ":8003/profile/" + String(pk) + "/"
            detailVC.profilePK = pk
        }
    }

}


//API 통신 관련
extension FollowingUserTableViewController {
    
    /*
     API서버를 통해 json데이터를 얻어오는 함수
     */
    func getJsonData(){
        //토큰 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        let fullUrl = appDelegate.basicURL + ":8003" + self.url
        
        /*
        //test url
        let Auth_header = ["Authorization":"Token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNTE4NTc0NjcyfQ.I5_D-ShmDH-fRnlK685Gutaq1DAJbjeLfyng1D7j2Kg"]
        
        let fullUrl = appDelegate.basicURL + ":8003/profile/1/follow_reviewer_list/"
        */
        
        //데이터 가져오는 부분
        Alamofire.request(fullUrl, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    if let JSON = response.result.value as? [String : Any] {

                        if let data = JSON["results"] as? [String:Any]{
                            if data["code"] as! Int == 3020{
                                self.following_list = data["data"] as! [[String:Any]]
                                self.tableView.reloadData()
                            }
                            
                        }

                    }
                case .failure(_):
                    print("fail")
                }
        }
    }

}

