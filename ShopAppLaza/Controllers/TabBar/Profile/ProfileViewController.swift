//
//  EditDataProfileViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 20/08/23.
//

import UIKit

class ProfileViewController: UIViewController {
    private let profileVM = ProfilViewModel()
    var contentDataUser: UserElement?
    
    //MARK: IBOutlet
    @IBOutlet weak var imagePhoto: UIImageView!{
        didSet{
            imagePhoto.layer.cornerRadius = CGFloat(imagePhoto.frame.width/2)
        }
    }
    @IBOutlet weak var viewFullnanem: UIView!{
        didSet{
            viewFullnanem.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var viewUsername: UIView!{
        didSet{
            viewUsername.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            viewEmail.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!{
        didSet{
            editProfileBtn.layer.cornerRadius = CGFloat(10)
        }
    }

    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Profile"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()

        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.getDataProfile()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    
    //MARK: IBAction
    @IBAction func editDataAction(_ sender: UIButton) {
        guard let performEditPage = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        performEditPage.contentDataUser = contentDataUser
        self.navigationController?.pushViewController(performEditPage, animated: true)
    }
    
    //MARK: FUNCTION
    func getDataProfile() {
        profileVM.getUserProfile(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] userdata in
            self?.contentDataUser = userdata
            DispatchQueue.main.async {
                self?.fullnameLabel.text = self?.contentDataUser?.data.fullName
                self?.usernameLabel.text = self?.contentDataUser?.data.username
                self?.emailLabel.text = self?.contentDataUser?.data.email
                self?.imagePhoto.setImageWithPlugin(url: self?.contentDataUser?.data.imageUrl ?? "")
            }
        }
    }
    
}
