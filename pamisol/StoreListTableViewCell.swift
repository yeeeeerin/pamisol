//
//  StoreListTableViewCell.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 18..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {

    @IBOutlet var userimg: UIImageView!
    @IBOutlet var userID: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
