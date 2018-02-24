//
//  KeepStoreContainerView.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 12..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class KeepStoreContainerView: UIViewController {
    
    var profilePK:Int = 1
    
    @IBOutlet var collectionview: UICollectionView!
    var datas:[[String:Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSearchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
extension KeepStoreContainerView{
    func getSearchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        
        
        let fullUrl:String = appDelegate.basicURL + ":8003/profile/" + String(self.profilePK) + "/keep/"

        
        Alamofire.request(fullUrl, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
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
                        if let result = JSON["results"] as? [[String:Any]]{
                            self.datas = result
                        }
                    }
                    
                    self.collectionview.reloadData()
                    
                case .failure(_):
                    print("fail")
                    
                }
        }
        
    }
}

extension KeepStoreContainerView:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !datas.isEmpty{
            return datas.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KSC Cell",for:indexPath) as! KeepStoreContainerCell
        
        if !datas.isEmpty{
            
            let data = datas[indexPath.row]
            
            cell.layer.cornerRadius = 7
            cell.layer.masksToBounds = true
            
            //image
            let imgUrl:String = data["image"] as! String
            print(imgUrl)
            var img:UIImage!
            
            Alamofire.request(imgUrl, method: .get).responseImage { response in
                switch response.result {
                case .success(let image):
                    img = image
                    cell.img.image = img
                //self.collectionview.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

            cell.andSM.text = data["name"] as? String

            if let like_user:[String] = data["like_user"] as? [String]{
                
                if like_user.isEmpty{
                    cell.like.text = "좋아요가 없습니다."
                }
                else{
                    cell.like.text = "♥"+like_user[0] + "님 외" + String(data["like_user_count"] as! Int) + "명"
                }
                

            }
            cell.price.text=String(data["price"] as! Int)+"원"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 20, right: 3)
    }
    
    
    
    
    
}
