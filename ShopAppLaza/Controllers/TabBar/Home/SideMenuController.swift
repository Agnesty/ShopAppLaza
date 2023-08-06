//
//  SideMenuController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit
import SideMenu

protocol SideMenuControllerDelegate: AnyObject {
    func logoutPressed()
}

class SideMenuController: UIViewController {
    weak var delegate: SideMenuControllerDelegate?
    
    //MARK: IBOutlet
    @IBOutlet weak var menuBack: UIButton!
    @IBOutlet weak var imageUser: UIButton!
    @IBOutlet weak var sumOrders: UIButton!
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var accountInfo: UIButton!
    @IBOutlet weak var password: UIButton!
    @IBOutlet weak var order: UIButton!
    @IBOutlet weak var myCards: UIButton!
    @IBOutlet weak var wishlist: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var accountInfoAction: UIButton!
    @IBOutlet weak var passwordAction: UIButton!
    @IBOutlet weak var orderAction: UIButton!
    @IBOutlet weak var myCardsAction: UIButton!
    @IBOutlet weak var wishlistAction: UIButton!
    @IBOutlet weak var settingsAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBAction
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        showLogoutAlert()
    }
    
    //MARK: FUNCTION
    func showLogoutAlert() {
        let alert = UIAlertController(title: nil, message: "Anda yakin akan keluar?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            
            // Menghapus data dari UserDefaults
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "loggedInUsername")
            UserDefaults.standard.removeObject(forKey: "loggedInPassword")
            UserDefaults.standard.synchronize()
            
            // Mengarahkan pengguna kembali ke root view controller
            self.delegate?.logoutPressed()
        }
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
    }
}
