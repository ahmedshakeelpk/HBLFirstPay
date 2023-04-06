//
//  UIViewControllerExtension.swift
//  First Pay
//
//  Created by Apple on 06/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertCustomPopup(title:String? = "", message: String? = "", imageIcon: String? = nil, buttonName: [String]? = ["OK"], viewController: UIViewController) {
        let alertCustomPopup = UIStoryboard.init(name: "AlertPopup", bundle: nil).instantiateViewController(withIdentifier: "AlertPopupMessage") as! AlertPopupMessage
        alertCustomPopup.modalPresentationStyle = .overFullScreen
        viewController.present(alertCustomPopup, animated: true)
    }
}
