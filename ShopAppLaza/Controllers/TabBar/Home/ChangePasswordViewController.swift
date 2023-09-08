//
//  ChangePasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/09/23.
//

import UIKit

protocol accessSideMenuDelegate: AnyObject {
    func accessSideMenu()
}

class ChangePasswordViewController: UIViewController {
    private let changePassVM = ChangePassViewModel()
    weak var delegate: accessSideMenuDelegate?
    
    //MARK: IBOutlet
    @IBOutlet weak var oldPassTF: UITextField!{
        didSet{
            oldPassTF.isSecureTextEntry = true
            oldPassTF.borderStyle = .none
        }
    }
    @IBOutlet weak var newPassTF: UITextField!{
        didSet{
            newPassTF.isSecureTextEntry = true
            newPassTF.borderStyle = .none
        }
    }
    @IBOutlet weak var confirmPassTF: UITextField!{
        didSet{
            confirmPassTF.isSecureTextEntry = true
            confirmPassTF.borderStyle = .none
        }
    }
    @IBOutlet weak var checkOldPass: UIButton!{
        didSet{
            checkOldPass.isHidden = true
        }
    }
    @IBOutlet weak var checkNewPass: UIButton!{
        didSet{
            checkNewPass.isHidden = true
        }
    }
    @IBOutlet weak var checkConfirmPass: UIButton!{
        didSet{
            checkConfirmPass.isHidden = true
        }
    }
    @IBOutlet weak var eyeOldPass: UIButton!
    @IBOutlet weak var eyeNewPass: UIButton!
    @IBOutlet weak var eyeConfirmPass: UIButton!
    @IBOutlet weak var oldPassErrorLabel: UILabel!
    @IBOutlet weak var newPassErrorLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        changePassVM.navigateToBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        changePassVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
        saveBtn.isEnabled = false
        oldPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        newPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    @objc func disabledBtn(){
        //Pemunculan check pada oldPassword
        if !oldPassErrorLabel.isHidden {
            saveBtn.isEnabled = false
            checkOldPass.isHidden = true
        } else {
            saveBtn.isEnabled = true
            checkOldPass.isHidden = false
        }
        
        //Pemunculan check pada newPassword
        if !newPassErrorLabel.isHidden {
            saveBtn.isEnabled = false
            checkNewPass.isHidden = true
        } else {
            saveBtn.isEnabled = true
            checkNewPass.isHidden = false
        }
        
        //Jika text belum diisi pada textfield maka tombol belum bisa diklik
        if !oldPassTF.hasText, !newPassTF.hasText, !confirmPassTF.hasText {
            saveBtn.isEnabled = false
            saveBtn.backgroundColor = UIColor(hex: "#8E8E93")
            saveBtn.titleLabel?.textColor = .systemBackground
            return
        }
        
        //Jika password dan confirmPass sama, buttonnya baru bisa diklik
        if confirmPassTF.text == newPassTF.text{
            saveBtn.isEnabled = true
            checkConfirmPass.isHidden = false
            saveBtn.backgroundColor = UIColor(hex: "#9775FA")
        } else  {
            saveBtn.isEnabled = false
            checkConfirmPass.isHidden = true
            saveBtn.backgroundColor = UIColor(hex: "#8E8E93")
            saveBtn.tintColor = .white
        }
    }
    
    //MARK: IBAction
    @IBAction func oldPassAction(_ sender: UITextField) {
        if let password = oldPassTF.text
        {
            if let errorMessage = Regex.shared.invalidPassword(password) {
                oldPassErrorLabel.text = errorMessage
                oldPassErrorLabel.isHidden = false
            } else {
                oldPassErrorLabel.isHidden = true
            }
        }
    }
    @IBAction func newPassAction(_ sender: UITextField) {
        if let password = newPassTF.text
        {
            if let errorMessage = Regex.shared.invalidPassword(password) {
                newPassErrorLabel.text = errorMessage
                newPassErrorLabel.isHidden = false
            } else {
                newPassErrorLabel.isHidden = true
            }
        }
    }
    @IBAction func eyeActionOldPass(_ sender: UIButton) {
        hideEyePass(object: oldPassTF, sender: sender)
    }
    @IBAction func eyeActionNewPass(_ sender: UIButton) {
        hideEyePass(object: newPassTF, sender: sender)
    }
    @IBAction func eyeActionConfirmPass(_ sender: UIButton) {
        hideEyePass(object: confirmPassTF, sender: sender)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.accessSideMenu()
    }
    @IBAction func saveAction(_ sender: UIButton) {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.changePassword()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    
    //MARK: FUNCTION
    func hideEyePass(object: UITextField, sender: UIButton) {
        let isHidden = object.isSecureTextEntry
        object.isSecureTextEntry = !isHidden
        
        let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    func changePassword() {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.changePassVM.changePass(oldPass: (self?.oldPassTF.text)!, newPass: (self?.newPassTF.text)!, confirmPass: (self?.confirmPassTF.text)!, isMockApi: false, accessTokenKey: APIService().token!)
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
}
