//
//  NewPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var resetPassBtn: UIButton!
    @IBOutlet weak var strongCheck: UILabel!{
        didSet{
            strongCheck.isHidden = true
        }
    }
    
    //IBAction
    @IBAction func resetPassAction(_ sender: UIButton) {
        guard let performLogin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(performLogin, animated: true)
    }
    
    @IBAction func hidePassButton(_ sender: UIButton) {
        hideEyePass(object: passwordTF, sender: sender)
    }
    
    @IBAction func hideConfirmPass(_ sender: UIButton) {
        hideEyePass(object: confirmPassTF, sender: sender)
    }
    
    func hideEyePass(object: UITextField, sender: UIButton) {
        let isHidden = object.isSecureTextEntry
        object.isSecureTextEntry = !isHidden
        
        let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        resetPassBtn.isEnabled = false
        
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    @objc func disabledBtn(){
        
        //Memunculkan Strong Check pada Password
        let strongCheck = passwordTF.text ?? ""
        let validStrong = strongCheck.count > 8
        resetPassBtn.isEnabled = strongCheck.count > 8
        
        if validStrong {
            self.strongCheck.isHidden = false
        } else {
            self.strongCheck.isHidden = true
        }
        
        if !confirmPassTF.hasText, !passwordTF.hasText {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = UIColor(hex: "#8E8E93")
            resetPassBtn.titleLabel?.textColor = .systemBackground
            return
        }
        
        if confirmPassTF.text == passwordTF.text{
            resetPassBtn.isEnabled = true
            resetPassBtn.backgroundColor = UIColor(hex: "#9775FA")
        } else  {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = UIColor(hex: "#8E8E93")
            resetPassBtn.tintColor = .white
        }
        
    }
    

}
