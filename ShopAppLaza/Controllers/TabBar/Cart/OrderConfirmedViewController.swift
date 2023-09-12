//
//  OrderConfirmedViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

protocol checkoutProtocol: AnyObject {
    func goTohome()
}

class OrderConfirmedViewController: UIViewController {
    weak var delegate: checkoutProtocol?

    //MARK: IBOutlet
    @IBOutlet weak var goToOrderBtn: UIButton!{
        didSet{
            goToOrderBtn.layer.cornerRadius = CGFloat(10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    //MARK: IBAction

    @IBAction func goToOrderAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueShopAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.goTohome()
    }
    
    
    
}
