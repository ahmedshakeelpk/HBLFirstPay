//
//  cellLinkedAccount.swift
//  First Pay
//
//  Created by Irum Butt on 21/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellLinkedAccount: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var LabelName: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var buttonback: UIButton!
    @IBOutlet weak var backView: UIView!
   
    @IBOutlet weak var buttonImgChecked: UIButton!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccNo: UILabel!
}
