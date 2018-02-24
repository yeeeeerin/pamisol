//
//  ReviewListContainerCell.swift
//  pamisol
//
//  Created by 이예린 on 2018. 2. 12..
//  Copyright © 2018년 Yerin. All rights reserved.
//

import UIKit

class ReviewListContainerCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var like: UILabel!
    @IBOutlet var info: UILabel!
    @IBOutlet var menu: UILabel!
    @IBOutlet var store: UILabel!
    @IBOutlet var view: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
