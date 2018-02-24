//
//  SearchFeedViewController_test.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 16..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchFeedViewController_test: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    var searchText:String!
    
    var results:[[String:Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isHidden = true
        self.tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //done키를 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        getSearchData(search: searchText)
        return true
    }
    
    @IBAction func editingText() {
        if (searchTextField.text?.isEmpty)!{
            self.tableView.isHidden = true
        }
        else{
            self.tableView.isHidden = false
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
 
        
    }
    

}

//json 통신 관련
extension SearchFeedViewController_test{
    
    func getSearchData(search:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        let fullUrl:String = appDelegate.basicURL + ":8003/search/?q=" + search
        
        let encodeUrl:URL = URL(string: fullUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        
        print("fullUrl")
        print(fullUrl)
        
        //데이터 가져오는 부분
        Alamofire.request(encodeUrl, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                //print("!!validate!!")
                //debugPrint(response)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                //성공일 때
                case .success( _):
                    if let JSON = response.result.value as? [String : Any] {
                        if let result = JSON["results"] as? [String:Any]{
                            if (result["code"] as! Int) == 4000{
                                if let data = result["data"] as? [[String:Any]]{
                                    //self.following_list = data["store_following_list"] as! [String]
                                    self.results = data
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    
                    }
                    self.tableView.reloadData()
                case .failure(_):
                    print("fail")
                }
        }
    }
    
}

extension SearchFeedViewController_test:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.results.isEmpty{
            return self.results.count
        }
        return 0
    }
    
    //any를 기반으로
    //셀에 표시 될 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search Cell",for:indexPath) as! StoreListTableViewCell
        
        if !self.results.isEmpty{
            //비어있지 않다면
            
            let filter_type = results[indexPath.row]["content_type"] as! String
            let object = results[indexPath.row]["searchfilter_object"] as! [String:Any]
            
            //user profile일경우
            if filter_type == "user profile"{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let imgUrl:String =  object["image"] as? String{
                    let url = appDelegate.basicURL + ":8003" + imgUrl
                    Alamofire.request(url, method: .get).responseImage { response in
                        switch response.result {
                        case .success(let image):
                            cell.userimg.layer.borderWidth = 0.7
                            cell.userimg.layer.cornerRadius = 25
                            cell.userimg.layer.borderColor = UIColor(rgb: 0xffffff).cgColor
                            cell.userimg.clipsToBounds = true
                            cell.userimg.image = image
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
                cell.userID.text = object["name"] as? String
            }
            else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let imgUrl:String =  object["image"] as? String{
                    let url = appDelegate.basicURL + ":8003" + imgUrl
                    Alamofire.request(url, method: .get).responseImage { response in
                        switch response.result {
                        case .success(let image):
                            cell.userimg.layer.borderWidth = 0.7
                            cell.userimg.layer.cornerRadius = 25
                            cell.userimg.layer.borderColor = UIColor(rgb: 0xffffff).cgColor
                            cell.userimg.clipsToBounds = true
                            cell.userimg.image = image
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
                cell.userID.text = object["name"] as? String
                
            }
            
            
            
        }
        
        return cell
    }
    
    //tableview 선택했을 때 맞는 화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = results[indexPath.row]["searchfilter_object"] as! [String:Any]
        let filter_type = results[indexPath.row]["content_type"] as! String
        
        if filter_type == "user profile"{
            
            let pkUrl:String = object["url"] as! String
            
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Profile Page") as! MypageViewController
            
            
            nextView.url = ":8003" + pkUrl
            
            self.navigationController?.pushViewController(nextView, animated:
                true)
            
            //self.present(navController, animated: true, completion: nil)
            
        }
        else{
            
            let pk:Int = object["pk"] as! Int
            
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Store Page") as! StorePageViewController
            
            //let navController = UINavigationController(rootViewController: nextView)
            
            nextView.storePK = pk
            self.navigationController?.pushViewController(nextView, animated:
                true)
            
            //self.present(navController, animated: true, completion: nil)
            
        }
        
        
    }
    
}

