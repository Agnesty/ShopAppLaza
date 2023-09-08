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
    func goToWishlist()
    func goToCart()
    func goToProfile()
    func goToChangePassword()
}

class SideMenuController: UIViewController {
    weak var delegate: SideMenuControllerDelegate?
    private let profileVM = ProfilViewModel()
    var contentDataUser: UserElement?
    
    //MARK: IBOutlet
    @IBOutlet weak var menuBack: UIButton!
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = CGFloat(imageUser.frame.width/2)
        }
    }
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var password: UIButton!
    @IBOutlet weak var order: UIButton!
    @IBOutlet weak var myCards: UIButton!
    @IBOutlet weak var wishlist: UIButton!
    @IBOutlet weak var orderAction: UIButton!
    @IBOutlet weak var myCardsAction: UIButton!
    @IBOutlet weak var wishlistAction: UIButton!
    @IBOutlet weak var namaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.getUserData()
       
        if let firstname = UserDefaults.standard.string(forKey: "loggedInFirstName"){
            namaLabel.text = "\(firstname.capitalized)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDarkMode()
    }
    
    //MARK: IBAction
    @IBAction func dismissSideMenu(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        showAlert2(title: nil, message: "Are you sure to logout?") {
            // Menghapus data dari UserDefaults
            KeychainManager.keychain.deleteToken()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            // Mengarahkan pengguna kembali ke root view controller
            self.delegate?.logoutPressed()
        }
    }
    @IBAction func myCartButtonAction(_ sender: UIButton) {
        self.delegate?.goToCart()
    }
    @IBAction func myProfileButtonAction(_ sender: UIButton) {
        self.delegate?.goToProfile()
    }
    @IBAction func wishlist(_ sender: UIButton) {
        self.delegate?.goToWishlist()
    }
    @IBAction func passwordAction(_ sender: UIButton) {
        self.delegate?.goToChangePassword()
    }
    @IBAction func switchMode(_ sender: UISwitch) {
        if sender.isOn {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.setValue(true, forKey: "darkmode")
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.setValue(false, forKey: "darkmode")
        }
    }
    
    
    //MARK: FUNCTION
    func getUserData() {
        //        profileVM.getUserProfile(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] userdata in
        //            DispatchQueue.main.async { [weak self] in
        //                self?.contentDataUser = userdata
        //                print("apakah ini benar: \(userdata)")
        //                DispatchQueue.main.async {
        //                    if let contentData = self?.contentDataUser?.data {
        //                        self?.namaLabel.text = contentData.fullName
        //                        self?.imageUser.setImageWithPlugin(url: contentData.imageUrl ?? "")
        //                    }
        //                }
        //            }
        //        }
        if let dataProfile = KeychainManager.keychain.getProfileToKeychain(service: Token.saveProfile.rawValue) {
            self.contentDataUser = dataProfile
            DispatchQueue.main.async { [weak self] in
                if let contentData = self?.contentDataUser?.data {
                    self?.namaLabel.text = contentData.fullName
                    self?.imageUser.setImageWithPlugin(url: contentData.imageUrl ?? "")
                }
            }
        } else {
            return print("data kosong")
        }
    }
    func checkDarkMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkmode")
        if isDarkMode {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
            switchMode.isOn = true
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let appDelegate = windowScene.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
            }
            switchMode.isOn = false
        }
    }
}
