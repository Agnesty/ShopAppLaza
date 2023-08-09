//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class AddressViewController: UIViewController {

    //MARK: IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
