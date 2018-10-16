//
//  CommentCell.swift
//  DevChallenge
//
//  Created by Igor Tudoran on 10/16/18.
//  Copyright © 2018 Igor Tudoran. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
