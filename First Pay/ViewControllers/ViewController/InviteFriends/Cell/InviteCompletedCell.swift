//
//  InviteCompletedCell.swift
//  HBLFMB
//
//  Created by Apple on 18/04/2023.
//

import UIKit

class InviteCompletedCell: UITableViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageViewBackGround: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    var sentInviteFriendList: InviteAFriends.SentInviteFriendList! {
        didSet {
            if let name = sentInviteFriendList.inviteeName {
                labelTitle.text = name
            }
            else {
                labelTitle.text = sentInviteFriendList.mobileNo
            }
            
            labelPhoneNumber.text = sentInviteFriendList.mobileNo
            labelPhoneNumber.textColor = .clrOrange
            
            imageViewUser.setImage(string: sentInviteFriendList.inviteeName ?? "NA", color: .clrGreenWithOccupacy20, colorText: .clrBlack)
            imageViewUser.circle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBackGround.radius(radius: 12, color: .lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
