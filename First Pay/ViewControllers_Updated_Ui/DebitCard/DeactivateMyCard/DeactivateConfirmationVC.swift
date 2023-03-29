//
//  DeactivateConfirmationVC.swift
//  First Pay
//
//  Created by Irum Butt on 15/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class DeactivateConfirmationVC: BaseClassVC {
    var flag = "false"
    var getDebitDetailsObj : GetDebitCardModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postalAddress(tapGestureRecognizer:)))
        imageYes.isUserInteractionEnabled = true
        imageYes.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(branchAddress(tapGestureRecognizer:)))
        imageNo.isUserInteractionEnabled = true
        imageNo.addGestureRecognizer(tap)
       
        
        // Do any additional setup after loading the view.
    }
    
    
   
    @IBOutlet weak var labelNo: UILabel!
    @IBOutlet weak var labelYes: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var imageNo: UIImageView!
    @IBOutlet weak var imageYes: UIImageView!
   
   
    
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: false)
    }
    @objc func postalAddress(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imageYes.image = image
            labelYes.textColor = UIColor(hexValue: 0xCC6801)
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imageYes.image = image
            labelYes.textColor = .white
            imageYes.contentMode =  .scaleToFill
            
            let emptyimage = UIImage(named: "Rectangle 6")
            imageNo.image = emptyimage
            labelNo.textColor =  UIColor(hexValue: 0xCC6801)
            flag = "true"
//            apicall
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as!  ActivationFourDigitNumberVc
            isFromDeactivate = true
            self.navigationController?.pushViewController(vc, animated: true)
           
            
            
            
        }
      
        
        
        
    }
    @objc func branchAddress(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if flag == "true"
        {
            let image = UIImage(named: "Rectangle 6")
            imageNo.image = image
            labelNo.textColor = UIColor(hexValue: 0xCC6801)
           
            
            flag  = "false"
        }
        
        else
        {
            let image = UIImage(named: "Rectangle Orange")
            imageNo.image = image
            labelNo.textColor = .white
            imageNo.contentMode =  .scaleToFill
          
            let emptyimage = UIImage(named: "Rectangle 6")
            imageYes.image = emptyimage
            labelYes.textColor =  UIColor(hexValue: 0xCC6801)
            flag = "true"
    
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
            self.present(vc, animated: true)
            
        }
    }
    
    
}
