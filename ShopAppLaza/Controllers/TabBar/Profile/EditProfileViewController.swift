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
    var img: UIImage?
    
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var imagePhoto: UIImageView!{
        didSet{
            imagePhoto.layer.cornerRadius = CGFloat(imagePhoto.frame.width/2)
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
        setupTabBarItemImage()
        imagePicker.delegate = self
        profileVM.profileViewCtr = self
        
    }
    
    //MARK: IBAction
    
    @IBAction func backButtonAction(_ sender: UIButton) {
       backBtn()
    }
    @IBAction func chooseImageAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
               
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editDataAction(_ sender: UIButton) {
        print("kamu bau")
        guard let img = img else {
            showAlert(title: "Upss..", message: "Please choose your image.")
            print("kamu belum memasukkan image")
            return }
        profileVM.putRequest(image: img, accessTokenKey: APIService().token!, fullname: fullnameTF.text!, username: usernameTF.text!, email: emailTF.text!)
    }
    
    //MARK: FUNCTIONS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePhoto.contentMode = .scaleAspectFit
            imagePhoto.image = pickedImage
            img = pickedImage
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


    
 
