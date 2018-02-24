//
//  StoreViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 1. 23..
//  Copyright © 2018년 Yerin. All rights reserved.
//
//스토어부분 피드를 보여주는 view
//EEF0F0

import UIKit
import PinterestLayout
import Alamofire

class StoreFeedViewController: PinterestVC {
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let text = "Some text.\n Some text.\n Some text.\n Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text."
    
    var nextURL:String = ""
    
    var page:Int!
    var currentURL = ""
    let pageNationCount:Int = 6
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextURL = ""
        page = 0
        currentURL = ""
        self.items = []
        
        storeFeedUI()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let url:String = appDelegate.basicURL + ":8003/feeds/" + String(appDelegate.profilePK)+"/store/"
        getJsonData(fullURL: url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewInsets()
        setupLayout()
        
        
        
        
        
    }
    
    func storeFeedUI() {
        //네비게이션바
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //text layout 부분
    func textLayout(storetxt:String, menutxt:String, menuStatustxt:String, infotxt:String, liketxt:String, commentCounttxt:String, reviewertxt:String) -> NSAttributedString{
        
        let fulltext = storetxt + menutxt + menuStatustxt + "\n" +
                        infotxt + "\n" +
                        liketxt + "\n" +
                        commentCounttxt + "\n" +
                        reviewertxt
        
        var mutableString_store = NSMutableAttributedString()
        mutableString_store = NSMutableAttributedString(string: fulltext, attributes: nil)
        
        mutableString_store.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: storetxt.count + menutxt.count))
        
        mutableString_store.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: menuStatustxt.count))
        
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
            //getJsonData(fullURL: nextURL)
            print("scrollViewDidScroll(_ scrollView: UIScrollView)")
            if (!items.isEmpty && !nextURL.isEmpty) && currentURL != nextURL{
                getJsonData(fullURL: nextURL)
            }
        }
 
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


extension StoreFeedViewController{
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
                                
                                let storefeed_object = data["storefeed_object"] as! [String:Any]
                                
                                //text에 들어갈 변수들
                                var storetxt:String = "스마일게이트."
                                var menutxt:String = " "
                                var menuStatustxt:String = ""
                                var infotxt:String = ":베이컨 밥 존맛존맛짱존맛탱 좋아좋아 완전좋아" //설명
                                var liketxt:String = "♥yerin님 외 18명"
                                var commentCounttxt:String = "1개의 댓글이 있습니다"
                                var reviewertxt:String = "yerin. 맛있어요!"
                                
                                //notice라면??
                                if data["content_type"] as! String == "notice"{
                                    
                                    storetxt = storefeed_object["store"] as! String
                                    print("Store Text")
                                    print(storefeed_object["store"] as! String)
                                    infotxt = storefeed_object["text"] as! String
                                    
                                    print(storetxt )
                                    print(infotxt)
                                    
                                    //댓글
                                    if let notice_comments = storefeed_object["notice_comment"] as? [[String:Any]]{
                                        
                                        commentCounttxt = String(notice_comments.count)+"개의 댓글이 있습니다."
                                        print(commentCounttxt)
                                        
                                        for comment in notice_comments{
                                            reviewertxt = (comment["profile"] as! String) + ". " + (comment["text"] as! String)
                                            print(reviewertxt)
                                            break
                                        }
                                        
                                    }
                                }
                                //menu라면??
                                else if data["content_type"] as! String == "menu"{
                                    storetxt = storefeed_object["store"] as! String
                                    print("Store Text")
                                    menutxt = storefeed_object["name"] as! String
                                    infotxt = storefeed_object["description"] as! String
                                    
                                    //댓글
                                    if let notice_comments = storefeed_object["notice_comment"] as? [[String:Any]]{
                                        
                                        commentCounttxt = String(notice_comments.count)+"개의 댓글이 있습니다."
                                        print(commentCounttxt)
                                        
                                        for comment in notice_comments{
                                            reviewertxt = (comment["profile"] as! String) + ". " + (comment["text"] as! String)
                                            print(reviewertxt)
                                            break
                                        }
                                        
                                    }
                                    
                                    print(menutxt)
                                    print(infotxt)
                                }
                                
                                
                                
                                //좋아요
                                if let like_user:[String] = storefeed_object["like_user"] as? [String]{

                                    if like_user.isEmpty{
                                        liketxt = "좋아요가 없습니다."
                                    }
                                    else{
                                        liketxt = "♥"+like_user[0] + "님 외" + String(storefeed_object["like_user_count"] as! Int) + "명"
                                    }
                                    
                                    print(liketxt)
                                }
                                
                                let mutableStr = self.textLayout(storetxt: storetxt,menutxt: menutxt,menuStatustxt: menuStatustxt,infotxt: infotxt,liketxt: liketxt,commentCounttxt: commentCounttxt,reviewertxt: reviewertxt)
                                
                                //image
                                let imgUrl:String = appDelegate.basicURL+":8003"+(storefeed_object["image"] as! String)
                                print(imgUrl)
                                var img:UIImage!
                                
                                Alamofire.request(imgUrl, method: .get).responseImage { response in
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




