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
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.getUserData()
        } onError: { errorMessage in
            print(errorMessage)
        }
        if let firstname = UserDefaults.standard.string(forKey: "loggedInFirstName"){
            namaLabel.text = "\(firstname.capitalized)"
        }
    }
    
    //MARK: IBAction
    @IBAction func dismissSideMenu(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        showLogoutAlert()
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
        if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first {
            if sender.isOn {
                window.overrideUserInterfaceStyle = .dark
                return
            }
            window.overrideUserInterfaceStyle =  .light
            return
        }
    }
    
    
    //MARK: FUNCTION
    func getUserData() {
        profileVM.getUserProfile(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] userdata in
            DispatchQueue.main.async { [weak self] in
                self?.contentDataUser = userdata
                print("apakah ini benar: \(userdata)")
                DispatchQueue.main.async {
                    if let contentData = self?.contentDataUser?.data {
                        self?.namaLabel.text = contentData.fullName
                        self?.imageUser.setImageWithPlugin(url: contentData.imageUrl ?? "")
                    }
                }
            }
        }
    }
    func showLogoutAlert() {
        let alert = UIAlertController(title: nil, message: "Anda yakin akan keluar?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            
            // Menghapus data dari UserDefaults
            KeychainManager.keychain.deleteToken()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            // Mengarahkan pengguna kembali ke root view controller
            self.delegate?.logoutPressed()
        }
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
    }
}
