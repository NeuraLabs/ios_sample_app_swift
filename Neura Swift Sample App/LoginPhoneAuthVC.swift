//
//  loginPhoneAuthVC.swift
//  Neura Swift Sample App
//
//  Created by Neura on 03/04/2018.
//  Copyright © 2018 beauNeura. All rights reserved.
//

import Foundation
import NeuraSDK

class LoginPhoneAuthVC: UIViewController, CountryCodeDelegate{
    
    @IBOutlet weak var countryCodeTf: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBAction func acceptAction(_ sender: Any) {
        let request = NeuraAuthenticationRequest(controller: self)
        let phone = countryCodeTf.text! + phoneNumberTF.text!
        request.phone = phone
        request.authenticationType = .phoneInjection
        
        
        NeuraSDK.shared.authenticate(with: request, callback: {
            result in
            if result.success {
                print("sucess")
            }
        })
        
        
        
        
        //        self.phoneNumber = [NSString stringWithFormat:@"+%@%@", self.countryCodeTF.text, self.phoneNumberTF.text];
        //        NSString *phone = [self enteredPhoneNumber:self.phoneNumber shakeOnError:YES];
        //
        //        if (phone && !self.isWatingForCode) {
        //            [self registerWithPhone:phone];
        //
        //        } else if (self.isWatingForCode) {
        //            [self verifyCode];
        //        }
    }
    
    @IBAction func backBtnActoin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            if let vc = (segue.destination as! UINavigationController).topViewController as? LoginCountrySelectorTVC{
                vc.countryCodeDelegate = self
            }
        }
    }
}
