//
//  StoreMenuReviewCell.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 15..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class StoreMenuReviewCell: UITableViewCell {
    
    @IBOutlet var userid: UILabel!
    @IBOutlet var grade: UILabel!
    @IBOutlet var mainimg: UIImageView!
    @IBOutlet var reviewText: UILabel!
    @IBOutlet var like: UILabel!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet var comment: UILabel!
    
    
    @IBOutlet var collectionView: UICollectionView!
    var reviewImg:[String]=[]

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StoreMenuReviewCell:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuReviewImageCell",for:indexPath) as! StoreMenuReviewCollectionCell
        if !reviewImg.isEmpty{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let imgFullUrl:String = appDelegate.basicURL + ":8003/media/" + reviewImg[indexPath.row]
            
            Alamofire.request(imgFullUrl, method: .get).responseImage { response in
                switch response.result {
                case .success(let image):
                    cell.image.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return cell
    }
    
    
    
}
