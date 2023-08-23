//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

class AddressViewController: UIViewController {
    private let addressVM = AddressViewModel()
    var allAddresses: AllAddress?
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cardAddress: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressVM.getAllAddress(accessTokenKey: APIService().token!) { allAddress in
            DispatchQueue.main.async { [weak self] in
                self?.allAddresses = allAddress
                print("ini bagian allAddress:", allAddress)
                self?.cardAddress.reloadData()
            }
        }
        
        cardAddress.dataSource = self
        cardAddress.delegate = self
        cardAddress.register(CardAddressTableViewCell.nib(), forCellReuseIdentifier: CardAddressTableViewCell.identifier)
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
        return allAddresses?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardAddressTableViewCell.identifier, for: indexPath) as? CardAddressTableViewCell else { return UITableViewCell() }
        let addressCell = allAddresses?.data?[indexPath.row]
        cell.receiveName.text = addressCell?.receiverName
        cell.phoneNo.text = addressCell?.phoneNumber
        cell.address.text = addressCell?.city
        cell.cityCountry.text = addressCell?.country
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
