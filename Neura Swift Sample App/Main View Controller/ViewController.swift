//
//  ViewController.swift
//  Push Notifications Test
//
//  Created by Neura on 7/10/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import UIKit
import NeuraSDK
import KRProgressHUD

class ViewController: UIViewController {
    //MARK: Properties
    let neuraSDK = NeuraSDK.shared
    
    //MARK: IBOutlets
    
    @IBOutlet weak var permissionsListButton: RoundedButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    @IBOutlet weak var phoneVerificationBtn: RoundedButton!
    @IBOutlet weak var neuraStatusLabel: UILabel!
    @IBOutlet weak var sdkVersionLabel:  UILabel!
    @IBOutlet weak var appVersionLabel:  UILabel!
    
    @IBOutlet weak var neuraSymbolTop:    UIImageView!
    @IBOutlet weak var neuraSymbolBottom: UIImageView!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        phoneVerificationBtn.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateSymbolState()
        self.updateAuthenticationLabelState()
        self.updateAuthenticationButtonState()
    }
    
    // MARK: - UI Updated based on authentication state
    func updateSymbolState() {
        let isConnected = NeuraSDK.shared.isAuthenticated()
        self.neuraSymbolTop.alpha    = isConnected ? 1.0 : 0.3
        self.neuraSymbolBottom.alpha = isConnected ? 1.0 : 0.3
    }
    
    func updateAuthenticationButtonState() {
        let authState = NeuraSDK.shared.authenticationState()
        var title = ""
        switch authState {
        case .authenticatedAnonymously, .authenticated:
            title = "Disconnect"
            
        case .requestingAuthenticationFromServer:
            title = "Connecting..."
            
        default:
            title = "Connect to Neura"
        }
        self.loginButton.setTitle(title, for: .normal)
    }
   
    
    func updateAuthenticationLabelState() {
        let authState = NeuraSDK.shared.authenticationState()
        var text = ""
        var color = UIColor.black
        switch authState {
        case .requestingAuthenticationFromServer:
            color = .blue
            text = "Requested tokens..."
        case .authenticated, .authenticatedAnonymously:
            color = UIColor(red: 0, green: 0.4, blue: 0, alpha: 1.0)
            if let neuraUserId = NeuraSDK.shared.neuraUserId() {
                text = "Connected (\(neuraUserId))"                
            } else {
                text = "Connected"
            }
            
        case .failed:
            color = .red
            text = "Failed receiving tokens"
        default:
            color = .darkGray
            text = "Disconnected"
        }
        self.neuraStatusLabel.text = text
        self.neuraStatusLabel.textColor = color
    }
    
    //MARK: Authentication
    func loginToNeura() {
        self.showBlockingProgress()
        
        
        /*An anonymous based authentication request (without user validation)
        Uses iOS vendor identifier to identify the user.*/
        
        let request = NeuraAnonymousAuthenticationRequest()
        
        //Use to authenticate the app
        NeuraSDK.shared.authenticate(with: request) { result in
            if let error = result.error {
                // Handle authentication errors if required
                NSLog("login error = %@", error);
                self.showAlert(title: "Login error", message: error.localizedDescription)
                self.hideBlockingProgress()
                return
            }
            
            // Handle success failure
            if result.success {
                // Successful authentication
                // (access token will be received by push)
                
                //set external id
                let id = NExternalId(externalId: "[one signal requested id]")
                NeuraSDK.shared.externalId = id
                
                self.neuraAuthStateUpdated()
            } else {
                // Handle failed login.
                self.showAlert(title: "Login failed", message: nil)
            }
            self.hideBlockingProgress()
        }
    }
    
    func logoutFromNeura(){
        guard NeuraSDK.shared.isAuthenticated() else { return }
        self.showBlockingProgress()
        NeuraSDK.shared.logout { result in
            // Handle errors if required
            self.hideBlockingProgress()
            self.neuraAuthStateUpdated()
        }
    }
    
    //
    // MARK: - NeuraAuthenticationStateDelegate
    //
    
    func neuraAuthStateUpdated() {
        self.updateAuthenticationLabelState()
        self.updateSymbolState()
        self.updateAuthenticationButtonState()
    }
    
    //
    // MARK: - User alerts
    //
    func showUserNotLoggedInAlert() {
        self.showAlert(title: "The user is not logged in", message: nil)
    }
    
    func showAlert(title: String?, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //
    // MARK: - Blocking progress
    //
    func showBlockingProgress() {
        KRProgressHUD.show()
    }
    
    func hideBlockingProgress() {
        KRProgressHUD.dismiss()
    }
    
    //
    // MARK: - UI Setup
    //
    func setupUI() {
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red: 0.2102, green: 0.7655, blue: 0.9545, alpha: 1).cgColor

        //Get the SDK and app version
        let sdkText = "SDK Version: \(neuraSDK.getVersion()!)"
        self.sdkVersionLabel.text = sdkText
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let appVersion = nsObject as! String
        self.appVersionLabel.text = appVersion
        
        // Auth State
        self.neuraAuthStateUpdated()
    }
    
    //
    // MARK: - IBAction Functions
    //
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        if neuraSDK.isAuthenticated() {
            self.logoutFromNeura()
            self.loginButton.setTitle("Connect and request permissions", for: UIControl.State())
        } else {
            self.loginToNeura()
        }
    }
}
