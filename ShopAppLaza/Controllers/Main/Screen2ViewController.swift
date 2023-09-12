//
//  Screen2ViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 25/07/23.
//

import UIKit
import GoogleSignIn

class Screen2ViewController: UIViewController {
    
    private let screen2VM = Screen2ViewModel()
    
    //MARK: IBOutlet
    
    @IBOutlet weak var facebookUI: UIButton!
    
    @IBOutlet weak var twitterUI: UIButton!
    
    @IBOutlet weak var googleUI: UIButton!{
        didSet{
            googleUI.layer.cornerRadius = CGFloat(10)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        screen2VM.screen2ViewCtr = self
        
        //        //Check User apakah sudah login atau belum
        //        if let isLoggedIn = screen2VM.isLoggedIn(), isLoggedIn {
        //            // Lakukan tindakan jika pengguna sudah login
        //            print("Pengguna sudah login.")
        //            guard let performHome = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarControllerViewController") as? TabBarControllerViewController else { return }
        //            self.navigationController?.pushViewController(performHome, animated: true)
        //        } else {
        //            // Lakukan tindakan jika pengguna belum login
        //            print("Pengguna belum login.")
        //        }
        
    }
    
    //MARK: IBAction
    @IBAction func googleAction(_ sender: UIButton) {
        //        openSharedURL(appURL: "googlegmail://", webURL: "https://mail.google.com/")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            // If sign in succeeded, display the app's main content View.
            print("Sign in success: \(String(describing: signInResult.user.profile?.email))")
        }
        
        
    }
    @IBAction func signInAction(_ sender: UIButton) {
        guard let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    @IBAction func createAccountAction(_ sender: UIButton) {
        guard let createAccount = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.navigationController?.pushViewController(createAccount, animated: true)
    }
    
    //MARK: FUNCTION
    private func openSharedURL(appURL: String, webURL: String) {
        guard let appURL = URL(string: appURL) else {
            print("Invalid URL: \(appURL)")
            return
        }
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if app is not installed, open URL inside Safari
            guard let webURL = URL(string: webURL) else {
                print("Invalid URL: \(webURL)")
                return
            }
            application.open(webURL)
        }
    }
    
    
    
}
