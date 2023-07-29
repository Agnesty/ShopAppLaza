//
//  WalletViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changePassTF: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBAction func doneBtnAction(_ sender: UIButton) {        
        guard let newPassword = changePassTF.text, !newPassword.isEmpty else {
                // Menampilkan alert karena password kosong
                let alert = UIAlertController(title: "Error", message: "Password cannot be empty.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            // Jika password tidak kosong, lanjutkan dengan mengubahnya dan menyimpan ke UserDefaults
            let oldPassword = UserDefaults.standard.string(forKey: "loggedInPassword")
            UserDefaults.standard.set(newPassword, forKey: "loggedInPassword")

            if let updatedPassword = UserDefaults.standard.string(forKey: "loggedInPassword") {
                // Menampilkan alert bahwa password berhasil diganti dan menunjukkan apa yang diganti
                let alert = UIAlertController(title: "Password Changed", message: "Password berhasil diganti.\n\nOld Password: \(oldPassword ?? "")\nNew Password: \(updatedPassword)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print("Old Password is : " + (oldPassword ?? ""))
                print("New Password is : " + updatedPassword)
            }

        
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
        UserDefaults.standard.removeObject(forKey: "loggedInPassword")
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.removeObject(forKey: "loggedInUsername"))
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wallet"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()

        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        
        // Mengambil data dari UserDefaults
        if let username = UserDefaults.standard.string(forKey: "loggedInUsername"),
            let email =  UserDefaults.standard.string(forKey: "loggedInEmail") {
            // Menampilkan data di label
            usernameLabel.text = ": \(username)"
            emailLabel.text = ": \(email)"
        }
        
    }

}
