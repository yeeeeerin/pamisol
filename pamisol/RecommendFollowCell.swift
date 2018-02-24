//
//  RecommendFollowCell.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 9..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit

class RecommendFollowCell: UITableViewCell {

    @IBOutlet var storeName: UILabel!
    @IBOutlet var menuImg: UIImageView!
    @IBOutlet var id: UILabel!
    @IBOutlet var menuName: UILabel!
    @IBOutlet var menuGrade: UILabel!
    @IBOutlet var menuText: UILabel!
    
    @IBOutlet var storeBtn: DLRadioButton!
    var followStore:Bool = false
    var followUser:Bool = false
    
    @IBAction func radioPressed(_ sender: DLRadioButton) {
        if sender.tag == 0{
            followStore = sender.isSelected
        }else{
            followUser = sender.isSelected
        }
    }
    
    func isCheck(){
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
