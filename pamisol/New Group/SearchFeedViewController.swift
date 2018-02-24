//
//  SearchFeedViewController.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 11..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import PinterestLayout
import Alamofire

private let reuseIdentifier = "Cell"

class SearchFeedViewController: PinterestVC{

    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let text = "Some text.\n Some text.\n Some text.\n Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text.Some text."
    
    //text에 들어갈 변수들
    var storetxt:String = "스마일게이트."
    var menutxt:String = " 회사밥"
    var menuStatustxt:String = "메뉴추가"
    var infotxt:String = ":베이컨 밥 존맛존맛짱존맛탱 좋아좋아 완전좋아" //설명
    var liketxt:String = "♥yerin님 외 18명"
    var commentCounttxt:String = "1개의 댓글이 있습니다"
    var reviewertxt:String = "yerin. 맛있어요!"
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getInitDataFeed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewInsets()
        setupLayout()
        
        
    }
    
    /*
     API서버를 통해 json데이터를 얻어오는 함수
     */
    func getJsonData(){
        //토큰 저장
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let Auth_header = ["Authorization":"Token "+appDelegate.token]
        
        //데이터 가져오는 부분
        Alamofire.request("http://192.168.0.10:8003/profile/1/", method: .get, encoding: JSONEncoding.default, headers: Auth_header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
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
    
    /*
     datafeed에 뿌려줄 피드를 생성하는 함수
     */
    func getInitDataFeed() {
        
        let mutableStr = textLayout(storetxt: storetxt,menutxt: menutxt,menuStatustxt: menuStatustxt,infotxt: infotxt,liketxt: liketxt,commentCounttxt: commentCounttxt,reviewertxt: reviewertxt)
        
        items = [
            PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "hh.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "hh.png")!, text: text, mutableString:mutableStr),
            PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr)
        ]
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
        
        let mutableStr = textLayout(storetxt: storetxt,menutxt: menutxt,menuStatustxt: menuStatustxt,infotxt: infotxt,liketxt: liketxt,commentCounttxt: commentCounttxt,reviewertxt: reviewertxt)
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            for _ in 0 ... 2{
                items.append(PinterestItem(image: UIImage(named: "gg.png")!, text: text, mutableString:mutableStr))
                items.append(PinterestItem(image: UIImage(named: "hh.png")!, text: text, mutableString:mutableStr))
            }
            self.collectionView?.reloadData()
        }
    }

}
