//
//  WalletViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit
import CreditCardForm

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private let profileVM = EditProfileViewModel()
    let imagePicker = UIImagePickerController()
    var contentDataUser: UserElement?
    var profileVC : ProfileViewController?
    
    //MARK: IBOutlet
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.isEnabled = false
        }
    }
    @IBOutlet weak var imagePhoto: UIImageView!{
        didSet{
            imagePhoto.layer.cornerRadius = CGFloat(imagePhoto.frame.width/2)
        }
    }
    @IBOutlet weak var viewLoading: UIView!{
        didSet{
            viewLoading.isHidden = true
        }
    }
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!{
        didSet{
            indicatorLoading.isHidden = true
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
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameTF.text = contentDataUser?.data.fullName
        usernameTF.text = contentDataUser?.data.username
        emailTF.text = contentDataUser?.data.email
        imagePhoto.setImageWithPlugin(url: contentDataUser?.data.imageUrl ?? "")
        setupTabBarItemImage()
        imagePicker.delegate = self
        profileVM.navigateToBack = { [weak self] in
            self?.backBtn()
        }
        profileVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        profileVC?.getDataProfile()
        backBtn()
    }
    @IBAction func chooseImageAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func editDataAction(_ sender: UIButton) {
        guard let img = imagePhoto.image else { return }
        viewLoading.isHidden = false
        indicatorLoading.isHidden = false
        indicatorLoading.startAnimating()
        DispatchQueue.main.async {
            self.profileVM.loading = {
                self.viewLoading.isHidden = true
                self.indicatorLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.profileVM.putRequest(isMockApi: false, image: img, accessTokenKey: APIService().token!, fullname: (self?.fullnameTF.text)!, username: (self?.usernameTF.text)!, email: (self?.emailTF.text)!)
            } onError: { errorMessage in
                print(errorMessage)
            }
        }
    }
    
    //MARK: FUNCTIONS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePhoto.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func backBtn() {
        self.navigationController?.popViewController(animated: true)
    }
}




