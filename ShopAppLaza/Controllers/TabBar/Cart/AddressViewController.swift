//
//  AddressViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

protocol PassingDataAddresDelegate: AnyObject {
    func didFinishPassingData(city: String, country: String, id: Int)
}

class AddressViewController: UIViewController {
    private let addressVM = AddressViewModel()
    private let addAddressVM = AddAddressViewModel()
    var allAddresses: AllAddress?
    weak var delegate: PassingDataAddresDelegate?
    var selectedIndexPath: IndexPath?
    var clickCount = 0
    var sortedAddresses: [DataAllAddress]?
    
    //MARK: IBOutlet
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cardAddress: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardAddress.dataSource = self
        cardAddress.delegate = self
        cardAddress.register(CardAddressTableViewCell.nib(), forCellReuseIdentifier: CardAddressTableViewCell.identifier)
        addressVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.getAllAddress()
        } onError: { errorMessage in
            print(errorMessage)
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
        addressVM.getAllAddress(isMockApi: false, accessTokenKey: APIService().token!) { allAddress in
            DispatchQueue.main.async { [weak self] in
                self?.allAddresses = allAddress
                let primaryAddresses = self?.allAddresses?.data?.filter { $0.isPrimary != nil } ?? []
                let nonPrimaryAddresses = self?.allAddresses?.data?.filter { $0.isPrimary == nil } ?? []
                let combinedAddresses = primaryAddresses + nonPrimaryAddresses
                self?.allAddresses?.data = combinedAddresses
                print("Get all address")
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
        if let addressCell = allAddresses?.data?[indexPath.row] {
            cell.receiveName.text = addressCell.receiverName
            cell.phoneNo.text = addressCell.phoneNumber
            cell.address.text = addressCell.city
            cell.labelCountry.text = addressCell.country
            if addressCell.isPrimary == true {
                self.setViewIfPrimary(cell: cell)
            } else {
                self.setViewIfNonPrimary(cell: cell)
            }
        }
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CardAddressTableViewCell {
            let isPrimary = allAddresses?.data?[indexPath.row].isPrimary ?? false
            if isPrimary {
                self.setViewIfPrimary(cell: cell)
            } else {
                cell.viewContainer.backgroundColor = UIColor(named: "VCIfNonPrimary")
                cell.receiveName.textColor = .black
                cell.phoneNo.textColor = .black
                cell.address.textColor = .black
                cell.labelCountry.textColor = .black
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)
        clickCount += 1
           if selectedIndexPath == indexPath {
               if clickCount == 2 {
                   if let addressCell = allAddresses?.data?[indexPath.row] {
                       delegate?.didFinishPassingData(city: addressCell.city, country: addressCell.country, id: addressCell.id)
                   }
                   self.navigationController?.popViewController(animated: true)
                   clickCount = 0
               } else {
                   if let cell = tableView.cellForRow(at: indexPath) as? CardAddressTableViewCell {
                       cell.viewContainer.backgroundColor = UIColor(named: "VCIfPrimary") //ungu
                       cell.receiveName.textColor = .white
                       cell.phoneNo.textColor = .white
                       cell.address.textColor = .white
                       cell.labelCountry.textColor = .white
                   }
                   clickCount = 0
               }
           } else {
               selectedIndexPath = indexPath
               clickCount = 1
               if let cell = tableView.cellForRow(at: indexPath) as? CardAddressTableViewCell {
                   cell.viewContainer.backgroundColor = UIColor(named: "VCIfPrimary") //ungu
                   cell.receiveName.textColor = .white
                   cell.phoneNo.textColor = .white
                   cell.address.textColor = .white
                   cell.labelCountry.textColor = .white
               }
           }
    }
    func setViewIfPrimary(cell: CardAddressTableViewCell) {
        cell.viewContainer.backgroundColor = UIColor(named: "VCIfPrimary")?.withAlphaComponent(0.3)
        cell.viewContainer.layer.borderWidth = 1
        cell.viewContainer.layer.borderColor = UIColor(hex: "#9775FA")?.cgColor
        cell.receiveName.textColor = UIColor(named: "FontPrimary")
        cell.phoneNo.textColor = UIColor(named: "FontPrimary")
        cell.address.textColor = UIColor(named: "FontPrimary")
        cell.labelCountry.textColor = UIColor(named: "FontPrimary")
    }
    func setViewIfNonPrimary(cell: CardAddressTableViewCell) {
        cell.viewContainer.backgroundColor = UIColor(named: "VCIfNonPrimary")
        cell.viewContainer.layer.borderWidth = 0
        cell.viewContainer.layer.borderColor = nil
        cell.receiveName.textColor = .black
        cell.phoneNo.textColor = .black
        cell.address.textColor = .black
        cell.labelCountry.textColor = .black
    }
}

extension AddressViewController: deleteAddressProtocol {
    func editAddress(cell: CardAddressTableViewCell) {
        guard let indexPath = cardAddress.indexPath(for: cell) else { return }
        if let addressCell = allAddresses?.data?[indexPath.row] {
        if addressCell.isPrimary == true {
            self.setViewIfPrimary(cell: cell)
        } else {
            self.setViewIfNonPrimary(cell: cell)
        }
    }
        guard let performUpdateAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController else { return }
        performUpdateAddress.userAddresses = allAddresses?.data?[indexPath.row]
        performUpdateAddress.trueUpdate = true
        self.navigationController?.pushViewController(performUpdateAddress, animated: true)
    }
    func deleteAddress(cell: CardAddressTableViewCell) {
        guard let indexPath = cardAddress.indexPath(for: cell) else { return }
        if let addressCell = allAddresses?.data?[indexPath.row] {
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.addressVM.deleteAddressById(isMockApi: false, id: addressCell.id, accessTokenKey: APIService().token!) { status in
                    if status == true {
                        self?.getAllAddress()
                    }
                }
            } onError: { errorMessage in
                print(errorMessage)
            }
        }
    }
    
    
}
