//
//  NewPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var resetPassBtn: UIButton!
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return backButton
    }()
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.addSubview(backButton)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    @objc func disabledBtn(){
//        print("\(confirmPass.text) - \(newPassword.text)")
        if !confirmPassTF.hasText, !passwordTF.hasText {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = .gray
            return
        }
        
        if confirmPassTF.text == passwordTF.text{
            resetPassBtn.isEnabled = true
            resetPassBtn.backgroundColor = UIColor(hex: "#9775FA")
        } else  {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = .gray
        }
        
    }
    

}
