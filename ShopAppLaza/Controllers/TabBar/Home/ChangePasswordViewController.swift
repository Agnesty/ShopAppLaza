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
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        changePassVM.navigateToBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        changePassVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    //MARK: IBAction
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
    func changePassword() {
        changePassVM.changePass(oldPass: oldPassTF.text!, newPass: newPassTF.text!, confirmPass: confirmPassTF.text!, isMockApi: false, accessTokenKey: APIService().token!)
    }

    

}
