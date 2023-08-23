//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class AddAddressViewController: UIViewController {
    private let addAddressVM = AddAddressViewModel()
    
    
    //MARK: IBOutlet
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var savePrimaryAddress: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAddressVM.addAddressCtr = self
        
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveAddressAction(_ sender: UIButton) {
        print("save address")
        let isSwitchOn = savePrimaryAddress.isOn
        addAddressVM.addAddressCart(country: countryTF.text!, city: cityTF.text!, receiverName: nameTF.text!, phoneNumber: phoneNoTF.text!, isPrimary: isSwitchOn, accessTokenKey: APIService().token!)
    }
    
    
    //MARK: FUNCTIONS
    func goBackAfterAddAddress() {
        self.navigationController?.popViewController(animated: true)
    }
}
