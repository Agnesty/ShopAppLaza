//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

class AddressViewController: UIViewController {

    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cardAddress: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardAddress.dataSource = self
        cardAddress.delegate = self
        cardAddress.register(CardAddressTableViewCell.nib(), forCellReuseIdentifier: CardAddressTableViewCell.identifier)
        cardAddress.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAddressAction(_ sender: UIButton) {
        guard let performAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        self.navigationController?.pushViewController(performAddress, animated: true)
    }
    
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardAddressTableViewCell.identifier, for: indexPath) as? CardAddressTableViewCell else { return UITableViewCell() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
