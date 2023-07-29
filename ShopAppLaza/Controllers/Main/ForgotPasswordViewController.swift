//
//  ForgotPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
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

    @IBAction func confirmAction(_ sender: UIButton) {
        guard let resetPassword = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController else { return }
        self.navigationController?.pushViewController(resetPassword, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        emailTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }

    @objc func disabledBtn(){
        if !emailTF.hasText {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = .gray
            return
        } else {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor(hex: "#9775FA")
        }
       
        
    }
    
}
