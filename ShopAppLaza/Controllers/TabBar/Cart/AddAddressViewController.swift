//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class AddAddressViewController: UIViewController {
    private let addAddressVM = AddAddressViewModel()
    var userAddresses: DataAllAddress?
    var trueUpdate: Bool?
    
    //MARK: IBOutlet
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var savePrimaryAddress: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let previousValue = userAddresses {
            nameTF.text = previousValue.receiverName
            countryTF.text = previousValue.country
            cityTF.text = previousValue.city
            phoneNoTF.text = previousValue.phoneNumber
            let isPrimary = previousValue.isPrimary
            if isPrimary == nil {
                savePrimaryAddress.isOn = false
            } else {
                savePrimaryAddress.isOn = true
            }
        }
        
        addAddressVM.navigateToBack = { [weak self] in
            self?.goBackAfterAddAddress()
            
        }
        addAddressVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveAddressAction(_ sender: UIButton) {
        print("save address")
        let isSwitchOn = savePrimaryAddress.isOn
        if trueUpdate == true {
            print("isi true update")
            if let address = userAddresses {
                APIService().refreshTokenIfNeeded { [weak self] in
                    self?.addAddressVM.editAddressById(isMockApi: false, id: address.id, accessTokenKey: APIService().token!, country: (self?.countryTF.text)!, city: (self?.cityTF.text)!, receiverName: (self?.nameTF.text)!, phoneNo: (self?.phoneNoTF.text)!, isPrimary: isSwitchOn)
                } onError: { errorMessage in
                    print(errorMessage)
                }
                trueUpdate = false
            }
        } else {
            print("isi false update")
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.addAddressVM.addAddressCart(isMockApi: false, country: (self?.countryTF.text)!, city: (self?.cityTF.text)!, receiverName: (self?.nameTF.text)!, phoneNumber: (self?.phoneNoTF.text)!, isPrimary: isSwitchOn, accessTokenKey: APIService().token!)
            } onError: { errorMessage in
                print(errorMessage)
            }
        }
    }
    
    
    //MARK: FUNCTIONS
    func goBackAfterAddAddress() {
        self.navigationController?.popViewController(animated: true)
    }
}
