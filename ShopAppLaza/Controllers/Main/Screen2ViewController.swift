//
//  Screen2ViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 25/07/23.
//

import UIKit

class Screen2ViewController: UIViewController {
    
    private let screen2VM = Screen2ViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var facebookUI: UIButton!{
        didSet{
            facebookUI.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var twitterUI: UIButton!{
        didSet{
            twitterUI.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var googleUI: UIButton!{
        didSet{
            googleUI.layer.cornerRadius = CGFloat(10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        screen2VM.screen2ViewCtr = self
        
        //Check User apakah sudah login atau belum
        if let isLoggedIn = screen2VM.isLoggedIn(), isLoggedIn {
            // Lakukan tindakan jika pengguna sudah login
            print("Pengguna sudah login.")
            guard let performHome = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarControllerViewController") as? TabBarControllerViewController else { return }
            self.navigationController?.pushViewController(performHome, animated: true)
        } else {
            // Lakukan tindakan jika pengguna belum login
            print("Pengguna belum login.")
        }
        
    }
    
    //MARK: IBAction
    @IBAction func facebookAction(_ sender: UIButton) {}
    @IBAction func twitterAction(_ sender: UIButton) {}
    @IBAction func googleAction(_ sender: UIButton) {}
    @IBAction func signInAction(_ sender: UIButton) {
        guard let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    @IBAction func createAccountAction(_ sender: UIButton) {
        guard let createAccount = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.navigationController?.pushViewController(createAccount, animated: true)
    }

}
