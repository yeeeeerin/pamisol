//
//  ReviewFeedViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 11..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//reviewer 들 보여주는 피드 입니다.

import UIKit
import PinterestLayout
import Alamofire
import AlamofireImage

private let reuseIdentifier = "Cell"

class ReviewFeedViewController: PinterestVC {

    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let text = "Some text.\n Some text.\n Some text.\n Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text."
    
    
    var nextURL:String = ""
    var page:Int!
    var currentURL = ""
    let pageNationCount:Int = 6
    
    
    //text에 들어갈 변수들
    var storetxt:String = "스마일게이트."
    var menutxt:String = " 회사밥"
    var liketxt:String = "♥yerin님 외 18명"
    var id:String = "yerin."
    var infotxt:String = ":베이컨 밥 존맛존맛짱존맛탱 좋아좋아 완전좋아" //설명
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.items=[]
        nextURL = ""
        page = 0
        currentURL = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url:String = appDelegate.basicURL + ":8003/feeds/" + String(appDelegate.profilePK)+"/user/"
        getJsonData(fullURL: url)

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewInsets()
        setupLayout()
        
        
    }
    
    func reviewFeedUI() {
        //네비게이션바
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    

    
    func textLayout(storetxt:String, menutxt:String, id:String, infotxt:String, liketxt:String) -> NSAttributedString{
        
        let fulltext = liketxt + "\n" +
            id + infotxt + "\n" +
            "메뉴:" + menutxt + "|식당:" + storetxt
 
        var mutableString_store = NSMutableAttributedString()
        mutableString_store = NSMutableAttributedString(string: fulltext, attributes: nil)
        
        mutableString_store.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: storetxt.count + menutxt.count))

        mutableString_store.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: storetxt.count))

        return mutableString_store
    }
    
    //MARK: private
    
    private func setupCollectionViewInsets() {
        collectionView!.backgroundColor = UIColor.init(rgb: 0xEEF0F0)
        collectionView!.contentInset = UIEdgeInsets(
            top: 15,
            left: 5,
            bottom: 49,
            right: 5
        )
    }
    
    private func setupLayout() {
        let layout: PinterestLayout = {
            if let layout = collectionViewLayout as? PinterestLayout {
                return layout
            }
            let layout = PinterestLayout()
            
            collectionView?.collectionViewLayout = layout
            
            return layout
        }()
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    //무한 스크롤이 가능하도록 데이터를 계속 불러오는 함수
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        

        if offsetY > contentHeight - scrollView.frame.size.height {
            ////테이블
            print("scrollViewDidScroll(_ scrollView: UIScrollView)")
            if (!items.isEmpty && !nextURL.isEmpty) && currentURL != nextURL{
                getJsonData(fullURL: nextURL)
            }
        }
    }

}

extension ReviewFeedViewController{
    
    /*
     API서버를 통해 json데이터를 얻어오는 함수
     */
    func getJsonData(fullURL:String){
        //토큰 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        //let fullURL:String = appDelegate.basicURL + ":8003/feeds/" + String(appDelegate.profilePK)+"/store/"
        
        self.currentURL = fullURL
        
        //데이터 가져오는 부분
        Alamofire.request(fullURL, method: .get, encoding: JSONEncoding.default, headers: Auth_header)
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
                        
                        if self.nextURL.isEmpty{
                            
                            self.page = (JSON["count"] as! Int)/self.pageNationCount
                        }
                        
                        if (JSON["next"] as? String) != nil {
                            self.nextURL = JSON["next"] as! String
                        }else{
                            self.nextURL = ""
                        }
                        
                        if let results = JSON["results"] as? [[String:Any]]{
                            
                            for data in results{
                                
                                //text에 들어갈 변수들
                                var storetxt:String = "스마일게이트."
                                var menutxt:String = " 회사밥"
                                var liketxt:String = "♥yerin님 외 18명"
                                var id:String = "yerin."
                                var infotxt:String = ":베이컨 밥 존맛존맛짱존맛탱 좋아좋아 완전좋아" //설명
                                
                                storetxt = data["store"] as! String + "."
                                menutxt = " " + (data["menu"] as! String)
                                //liketxt = "♥"+
                                
                                //좋아요
                                if let like_user:[String] = data["like_user_list"] as? [String]{
                                    
                                    if like_user.isEmpty{
                                        liketxt = "좋아요가 없습니다."
                                    }
                                    else{
                                        liketxt = "♥"+like_user[0] + "님 외" + String(data["like_user_count"] as! Int) + "명"
                                    }
                                    
                                    print(liketxt)
                                }
                              
                                
                                let mutableStr = self.textLayout(storetxt:storetxt, menutxt:menutxt, id:id, infotxt:infotxt, liketxt:liketxt)
                                
                                //image
                                let imgUrl:String = data["image"] as! String
                                print(imgUrl)
                                var img:UIImage!
                                
                                let imgFullUrl:String = appDelegate.basicURL + ":8003/media/" + imgUrl
                                
                                Alamofire.request(imgFullUrl, method: .get).responseImage { response in
                                    switch response.result {
                                    case .success(let image):
                                        img = image
                                        self.items.append(PinterestItem(image: img, text: self.text, mutableString:mutableStr))
                                        self.collectionView?.reloadData()
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                //실패했을 시
                case .failure(_):
                    print("실패")
                    
                }
                
        }
        
    }
}







