//
//  InviteFriendSearchNumberCell.swift
//  HBLFMB
//
//  Created by Apple on 19/04/2023.
//

import UIKit

class InviteFriendSearchNumberCell: UITableViewCell {
    @IBOutlet weak var viewBackGround: UIView!
    
    @IBOutlet weak var buttonInvite: UIButton!
    @IBOutlet weak var viewUserImageBackGround: UIView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewUserImageBackGround.circle()
        
        buttonInvite.radius(color: .clrGreen)
        buttonInvite.circle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
