//
//  Screen2ViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 25/07/23.
//

import UIKit

class Screen2ViewController: UIViewController {
    //IBOutlet
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
    
    //IBAction
    @IBAction func facebookAction(_ sender: UIButton) {
    }
    @IBAction func twitterAction(_ sender: UIButton) {
    }
    @IBAction func googleAction(_ sender: UIButton) {
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        guard let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        guard let createAccount = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.navigationController?.pushViewController(createAccount, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

    }

}
