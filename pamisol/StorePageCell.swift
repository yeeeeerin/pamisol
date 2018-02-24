//
//  StorePageCell.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 12..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import Alamofire

class StorePageCell: UITableViewCell {
    
    @IBOutlet var header: UIView!
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var menuName: UILabel! //메뉴이름
    @IBOutlet var menuInfo: UILabel! //메뉴설명
    @IBOutlet var price: UILabel!
    
    @IBOutlet var grade: UILabel!
    
    @IBOutlet var likeBtn: UIButton!
    var likeStatus:Bool = false
    var likeToggleURL:String = ""
    
    @IBOutlet var bucketBtn: UIButton!
    var keepStatus:Bool = false
    var keepToggleURL:String = ""
    
    @IBOutlet var shareBtn: UIButton!
    
    @IBOutlet var likeReviewCount: UILabel!
    
    
    @IBAction func likeClick(_ sender: UIButton) {
        
        if likeStatus{
            likeStatus = false
            likeBtn.setImage(UIImage(named: "like") , for: .normal)
        }
        else{
            likeStatus = true
            likeBtn.setImage(UIImage(named: "like_in") , for: .normal)
        }
        likeAndKeepToggle(url:likeToggleURL)
    }
    
    @IBAction func bucketClick(_ sender: UIButton) {
        
        if keepStatus{
            keepStatus = false
            bucketBtn.setImage(UIImage(named: "bucket_out") , for: .normal)
        }
        else{
            keepStatus = true
            bucketBtn.setImage(UIImage(named: "bucket_in") , for: .normal)
        }
        likeAndKeepToggle(url:keepToggleURL)
        
    }
    
    //like and keep toggle
    func likeAndKeepToggle(url:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        //test
        //let store_pk:Int = 2
        let fullURL = appDelegate.basicURL + ":8003" + url
        
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
                    print("likeAndKeepToggle 성공")
                case .failure(_):
                    print("likeAndKeepToggle 실패")
                }
                
        }
    }
    
    @IBAction func shareClick(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}








