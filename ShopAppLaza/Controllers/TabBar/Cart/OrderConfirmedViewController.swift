//
//  OrderConfirmedViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class OrderConfirmedViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var goToOrderBtn: UIButton!{
        didSet{
            goToOrderBtn.layer.cornerRadius = CGFloat(10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToOrderAction(_ sender: UIButton) {
    }
    @IBAction func continueShopAction(_ sender: UIButton) {
    }
    
    
    
}
