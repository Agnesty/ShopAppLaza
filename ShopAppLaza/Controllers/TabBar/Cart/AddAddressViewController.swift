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
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var savePrimaryAddress: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addAddressVM.addAddressCtr = self
        if let previousValue = userAddresses {
            nameTF.text = previousValue.receiverName
            countryTF.text = previousValue.country
            cityTF.text = previousValue.city
            phoneNoTF.text = previousValue.phoneNumber
            addressTF.text = previousValue.city
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
                addAddressVM.editAddressById(isMockApi: false, id: address.id, accessTokenKey: APIService().token!, country: countryTF.text!, city: cityTF.text!, receiverName: nameTF.text!, phoneNo: phoneNoTF.text!, isPrimary: isSwitchOn)
                trueUpdate = false
            }
        } else {
            print("isi false update")
            addAddressVM.addAddressCart(isMockApi: false, country: countryTF.text!, city: cityTF.text!, receiverName: nameTF.text!, phoneNumber: phoneNoTF.text!, isPrimary: isSwitchOn, accessTokenKey: APIService().token!)
        }
    }
    
    
    //MARK: FUNCTIONS
    func goBackAfterAddAddress() {
        self.navigationController?.popViewController(animated: true)
    }
}
