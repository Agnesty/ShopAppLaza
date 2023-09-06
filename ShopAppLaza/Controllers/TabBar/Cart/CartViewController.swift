//
//  KeranjangViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class CartViewController: UIViewController {
    private let cartVM = CartViewModel()
    private let cartTableVM = CartTableViewModel()
    private let addressVM = AddressViewModel()
    var dataCart: DataCart?
    var allSizes: AllSize?
    var allAddresses: DataAllAddress?
    var idAddress: Int?
    var productsCheckout = [DataProductCheckout]()
    var chooseBank: String?
    
    //MARK: IBOutlet
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutBtn: UIButton!{
        didSet{
            checkoutBtn.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var imageDelivery: UIImageView!{
        didSet{
            imageDelivery.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var imagePayment: UIImageView!{
        didSet{
            imagePayment.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var subtotalPrice: UILabel!
    @IBOutlet weak var shippingCost: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Order"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        getAllAddress()
        getAllSize()
        
        self.addressLabel.text = self.allAddresses?.country
        self.cityLabel.text = self.allAddresses?.city
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        cartTableVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
        cartVM.navigateToHome = { [weak self] in
            self?.goToConfirmCheckout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        getAllCartData()
    }
    
    //MARK: IBAction
    @IBAction func checkoutBtnAction(_ sender: UIButton) {
        APIService().refreshTokenIfNeeded { [weak self] in
            if self?.idAddress == nil, self?.productsCheckout.isEmpty ?? true, self?.chooseBank?.isEmpty ?? true {
                self?.showAlert(title: nil, message: "Please add products, select a card, and choose an address before you checkout.")
            } else if self?.idAddress == nil, self?.productsCheckout.isEmpty ?? true {
                self?.showAlert(title: nil, message: "Please add products and choose an address first.")
            } else if self?.idAddress == nil, self?.chooseBank?.isEmpty ?? true {
                self?.showAlert(title: nil, message: "Please select a card and choose an address first.")
            } else if self?.productsCheckout.isEmpty ?? true, self?.chooseBank?.isEmpty ?? true {
                self?.showAlert(title: nil, message: "Please add products and select a card.")
            } else if self?.idAddress == nil {
                self?.showAlert(title: "Address", message: "Please choose your address first")
            } else if self?.productsCheckout.isEmpty ?? true {
                self?.showAlert(title: "Your cart is empty", message: "Please add products before you checkout.")
            } else if self?.chooseBank?.isEmpty ?? true {
                self?.showAlert(title: "Card not selected", message: "Please select a card before you checkout.")
            } else {
                guard let id = self?.idAddress else {
                    self?.showAlert(title: "Address", message: "Please choose your address first")
                    return
                }
                guard let products = self?.productsCheckout else {
                    self?.showAlert(title: "Your cart is empty", message: "Please add products before you checkout.")
                    return
                }
                guard let bank = self?.chooseBank else {
                    self?.showAlert(title: "Card not selected", message: "Please select a card before you checkout.")
                    return
                }
                self?.cartVM.checkout(isMockApi: false, accessTokenKey: APIService().token!, products: products, addressId: id, bank: bank)
            }
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    @IBAction func addressBtnAction(_ sender: UIButton) {
        guard let performAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController else { return }
        performAddress.delegate = self
        self.navigationController?.pushViewController(performAddress, animated: true)
    }
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        guard let performPaymentMethod = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController else { return }
        performPaymentMethod.delegate = self
        self.navigationController?.pushViewController(performPaymentMethod, animated: true)
    }
    
    //MARK: FUNCTION
    func getAllCartData() {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.cartVM.getProducInCart(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] cartProduct in
                self?.dataCart = cartProduct.data
                self?.productsCheckout.removeAll()
                cartProduct.data.products?.forEach { productCarts in
                    let cartProduct = DataProductCheckout(id: productCarts.id, quantity: productCarts.quantity)
                    self?.productsCheckout.append(cartProduct)
                    self?.tableView.reloadData()
                }
                if let orderInfo = self?.dataCart?.orderInfo {
                    self?.subtotalPrice.text = "Rp \(orderInfo.subTotal)"
                    self?.shippingCost.text = "Rp \(orderInfo.shippingCost)"
                    self?.totalPrice.text = "Rp \(orderInfo.total)"
                }
                self?.tableView.reloadData()
            }
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    func getSizeId(forSize size: String) -> Int {
        var sizeId = -1
        guard let allSizeData = allSizes?.data else { return sizeId }
        for index in 0..<allSizeData.count {
            if allSizeData[index].size == size {
                sizeId = allSizeData[index].id
                break
            }
        }
        return sizeId
    }
    func getAllAddress() {
        addressVM.getAllAddress(isMockApi: false, accessTokenKey: APIService().token!) { allAddress in
            DispatchQueue.main.async { [weak self] in
                self?.allAddresses = allAddress.data?.first(where: {$0.isPrimary == true})
                self?.addressLabel.text = self?.allAddresses?.country
                self?.cityLabel.text = self?.allAddresses?.city
            }
        }
    }
    func getAllSize() {
        cartVM.getAllSize(isMockApi: false) { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSizes = allSize
            }
        }
    }
    func goToConfirmCheckout() {
        guard let performOrderConfirmed = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController else { return }
        self.navigationController?.pushViewController(performOrderConfirmed, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countProduct = dataCart?.products?.count
        if countProduct == nil {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        return countProduct ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        if let dataCart = dataCart?.products?[indexPath.row] {
            cell.labelNameProduct.text = dataCart.productName
            cell.imageProduct.setImageWithPlugin(url: dataCart.imageURL)
            cell.jumlahProduct.text = "\(dataCart.quantity)"
            cell.priceProduct.text = "Rp \(dataCart.price)"
            cell.sizeLabel.text = "Size: \(dataCart.size)"
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension CartViewController: deleteProductInCartProtocol {
    func updateCountProduct(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            completion(dataCart.quantity)
        }
    }
    func increaseQuantityCart(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            let getSizeId = getSizeId(forSize: dataCart.size)
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.cartTableVM.increaseQuantityCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                    if bool == true {
                        self?.getAllCartData()
                        completion(dataCart.quantity)
                    }
                }
            } onError: { errorMessage in
                print(errorMessage)
            }
        }
    }
    func decreaseQuantityCart(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            let getSizeId = getSizeId(forSize: dataCart.size)
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.cartTableVM.decreaseQuantityCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                    if bool == true {
                        self?.getAllCartData()
                        completion(dataCart.quantity)
                    }
                }
            } onError: { errorMessage in
                print(errorMessage)
            }
            
        }
    }
    func deleteProductCart(cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            let getSizeId = getSizeId(forSize: dataCart.size)
            APIService().refreshTokenIfNeeded { [weak self] in
                self?.cartTableVM.deleteProductCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                    if bool == true {
                        self?.getAllCartData()
                    }
                }
            } onError: { errorMessage in
                print(errorMessage)
            }
        }
    }
}

extension CartViewController: PassingDataAddresDelegate {
    func didFinishPassingData(city: String, country: String, id: Int) {
        addressLabel.text = city
        cityLabel.text = country
        idAddress = id
    }
}

extension CartViewController: PassingDataCardDelegate {
    func PassingDataCard(cardNumber: String, bank: String) {
        self.cardNumber.text = cardNumber
        self.chooseBank = bank
    }
}
