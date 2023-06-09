//
//  NanoLoanRepaySucessfulVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import PDFKit

class NanoLoanRepaySucessfullVC: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    
    @IBOutlet weak var labelFee: UILabel!
    @IBOutlet weak var buttonGetNewLoan: UIButton!
    @IBOutlet weak var buttonDownLoad: UIButton!
    
    @IBOutlet weak var buttonShare: UIButton!
    
    var modelPayActiveLoan: NanoLoanRepayConfirmationVC.ModelPayActiveLoan? {
        didSet {
            labelAmount.text = "Rs. \((modelPayActiveLoan?.data?.payableTotalAmount ?? 0).twoDecimal())"
            labelTransactionId.text = "\(modelPayActiveLoan?.data?.transRefNum ?? 0)"
            labelDateTime.text = modelPayActiveLoan?.data?.dateTime ?? ""
            labelFee.text = "Rs. \((modelPayActiveLoan?.data?.processingFee ?? 0).twoDecimal())"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCancel(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    @IBAction func buttonGetNewLoan(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    
    @IBAction func buttonDownLoad(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        let imageArray = [myImageScreenShot!]
        if let yourPDF = imageArray.makePDF() {
            if saveFile(pdfDocument: yourPDF) {
                self.showAlertCustomPopup(title: "Sucess!", message: "File Download sucessfully", iconName: .iconError)
            }
            else {
                self.showAlertCustomPopup(title: "Error!", message: "Error occured during saving PDF File", iconName: .iconError)
            }
        }
        else {
            self.showAlertCustomPopup(title: "Error!", message: "Error occured during created PDF File", iconName: .iconError)
        }
    }
    @IBAction func buttonShare(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        print(myImageScreenShot)
        myImageScreenShot?.shareScreenShot(viewController: self)
    }
}

func saveFile(pdfDocument: PDFDocument) -> Bool {
    let fileManager = FileManager.default
    
    do {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor:nil, create:true)

        let fileURL = documentDirectory.appendingPathComponent("pdfFile.pdf")
        // Get the raw data of your PDF document
        if let data = pdfDocument.dataRepresentation() {
            // The url to save the data to
            // Save the data to the url
            do {
                try! data.write(to: fileURL)
            } catch {
                //handle write error here
                print("Error")
            }
            do {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    print("FILE AVAILABLE")
                    return true
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } catch {
                print(error)
            }
        }
    } catch {
        print(error)
    }
    return false
}

extension Array where Element: UIImage {
    
      func makePDF()-> PDFDocument? {
        let pdfDocument = PDFDocument()
        for (index,image) in self.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: index)
        }
        return pdfDocument
    }
}
