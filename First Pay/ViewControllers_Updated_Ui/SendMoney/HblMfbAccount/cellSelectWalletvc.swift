//
//  cellSelectWalletvc.swift
//  First Pay
//
//  Created by Irum Butt on 13/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellSelectWalletvc: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblBankNem: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (selected) {
            lblBankNem.textColor = UIColor(hexValue: 0x00CC96)
        } else {
            lblBankNem.textColor = UIColor.black
        }
    }
    
}
