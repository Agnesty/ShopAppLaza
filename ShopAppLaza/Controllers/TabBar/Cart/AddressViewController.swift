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
    
    //MARK: IBOutlet
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cardAddress: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressVM.detailViewCtr = self
        getAllAddress()
        let countAddress = allAddresses?.data?.count
        if countAddress == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        
        cardAddress.dataSource = self
        cardAddress.delegate = self
        cardAddress.register(CardAddressTableViewCell.nib(), forCellReuseIdentifier: CardAddressTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllAddress()
        let countAddress = allAddresses?.data?.count
        if countAddress == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addAddressAction(_ sender: UIButton) {
        guard let performAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        self.navigationController?.pushViewController(performAddress, animated: true)
    }
    
    //MARK: FUNCTION
    func getAllAddress() {
        addressVM.getAllAddress(accessTokenKey: APIService().token!) { allAddress in
            DispatchQueue.main.async { [weak self] in
                self?.allAddresses = allAddress
                print("ini bagian allAddress:", allAddress)
                self?.cardAddress.reloadData()
            }
        }
    }
    
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countAddress = allAddresses?.data?.count
        if countAddress == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        return countAddress ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardAddressTableViewCell.identifier, for: indexPath) as? CardAddressTableViewCell else { return UITableViewCell() }
        let addressCell = allAddresses?.data?[indexPath.row]
        cell.receiveName.text = addressCell?.receiverName
        cell.phoneNo.text = addressCell?.phoneNumber
        cell.address.text = addressCell?.city
        cell.cityCountry.text = addressCell?.country
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension AddressViewController: deleteAddressProtocol {
    func editAddress(cell: CardAddressTableViewCell) {
        guard let indexPath = cardAddress.indexPath(for: cell) else { return }
        guard let performUpdateAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        performUpdateAddress.userAddresses = allAddresses?.data?[indexPath.row]
        performUpdateAddress.trueUpdate = true
        self.navigationController?.pushViewController(performUpdateAddress, animated: true)
    }
    
    func deleteAddress(cell: CardAddressTableViewCell) {
        guard let indexPath = cardAddress.indexPath(for: cell) else { return }
        if let addressCell = allAddresses?.data?[indexPath.row] {
            addressVM.deleteAddressById(id: addressCell.id, accessTokenKey: APIService().token!) { bool in
                if bool == true {
                    self.getAllAddress()
                }
            }
        }
    }
    
    
}
