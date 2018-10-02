//
//  loginPhoneAuthVC.swift
//  Neura Swift Sample App
//
//  Created by Neura on 03/04/2018.
//  Copyright © 2018 beauNeura. All rights reserved.
//

import Foundation
import NeuraSDK
import KRProgressHUD

class LoginPhoneAuthVC: UIViewController, CountryCodeDelegate {
    
    @IBOutlet weak var countryCodeTf: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var codeNumberTF:  UITextField!
    
    @IBOutlet weak var whatIsNeuraBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var smsChargeLabel:  UILabel!
    @IBOutlet weak var screenDescLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    
    var phoneNumber:String?
    
    @IBAction func acceptAction(_ sender: Any) {
         self.view.endEditing(true)
        let request = NeuraAuthenticationRequest(controller: self)
        phoneNumber = countryCodeTf.text! + phoneNumberTF.text!
        request.authenticationType = .phoneInjection
        request.phone = phoneNumber
        KRProgressHUD.show()

        NeuraSDK.shared.authenticate(with: request, callback: {
            result in
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
                if result.success {
                     self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func backBtnActoin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termsAction(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        webVC.urlStr = "https://www.theneura.com/terms.html"
        self.present(webVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func whatIsNeuraAction(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
         webVC.urlStr = "https://www.theneura.com/whatisneura.html"
        self.present(webVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        
        let countryCode = CountryCodeHelepr.getCountryCallingCode(countryRegionCode:NSLocale.current.regionCode!)
        countryCodeTf.text = "+" + countryCode
        
        //add GestureRecognizer to dismiss key borad
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
  
    func codeWasChoosen(code: String) {
        countryCodeTf.text = code
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countryCodeSelectorSegue"{
            if let vc = (segue.destination as! UINavigationController).topViewController as? LoginCountrySelectorTVC {
                vc.countryCodeDelegate = self
            }
        }
    }
}
