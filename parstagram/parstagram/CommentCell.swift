//
//  CommentCell.swift
//  parstagram
//
//  Created by Jonah Tjandra on 4/1/22.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var usernameComment: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
