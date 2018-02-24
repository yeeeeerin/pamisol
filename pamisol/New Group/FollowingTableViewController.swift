//
//  FollowingTableViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 1..
//  Copyright © 2018년 Yerin. All rights reserved.

//UserPage에서 store user following 버튼 누르면

import UIKit
import Alamofire

class FollowingStoreTableViewController: UITableViewController {

    var url:String = ""
    var following_list:[[String:Any]]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getJsonData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "toStore Cell", for: indexPath) as! StoreListTableViewCell
        if !following_list.isEmpty{
            
            if let imgUrl:String = following_list[indexPath.row]["image"] as? String{
                Alamofire.request(imgUrl, method: .get).responseImage { response in
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
            
            cell.userID.text = following_list[indexPath.row]["name"] as? String
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //스토어로 넘어갈 때
        
        if let indexPath = tableView.indexPathForSelectedRow{
            //let selectedRow = indexPath.row
            let detailVC = segue.destination as! StorePageViewController
            let pk:Int = following_list[indexPath.row]["pk"] as! Int
            //detailVC.url = ":8003/store/"+String(pk)
            detailVC.storePK = pk
        }
        
    }
    

}

//json 통신 관련 extention
extension FollowingStoreTableViewController{
    /*
     API서버를 통해 json데이터를 얻어오는 함수
     */
    func getJsonData(){
        //토큰 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        let fullUrl = appDelegate.basicURL + ":8003" + self.url
        
        //test url
        /*
         let Auth_header = ["Authorization":"Token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNTE4NTc0NjcyfQ.I5_D-ShmDH-fRnlK685Gutaq1DAJbjeLfyng1D7j2Kg"]
         
         let fullUrl = appDelegate.basicURL + ":8003/profile/1/follow_store_list/"
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
                        if let result = JSON["results"] as? [String:Any]{
                            if (result["code"] as! Int) == 3010{
                                if let data = result["data"] as? [[String:Any]]{
                                    //self.following_list = data["store_following_list"] as! [String]
                                    self.following_list = data
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                        }
                        
                    }
                case .failure(_):
                    print("fail")
                }
        }
    }
}
