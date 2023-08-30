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
    var dataCart: DataCart?
    var allSizes: AllSize?
    
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
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Order"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        getAllCartData()
        let countProduct = dataCart?.products?.count
        if countProduct == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        
        cartVM.getAllSize(isMockApi: false) { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSizes = allSize
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
        
        cartTableVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllCartData()
        let countProduct = dataCart?.products?.count
        if countProduct == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
    }
    
    //MARK: IBAction
    @IBAction func checkoutBtnAction(_ sender: UIButton) {
        guard let performOrderConfirmed = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController else { return }
        self.navigationController?.pushViewController(performOrderConfirmed, animated: true)
    }
    @IBAction func addressBtnAction(_ sender: UIButton) {
        guard let performAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController else { return }
        performAddress.delegate = self
        self.navigationController?.pushViewController(performAddress, animated: true)
    }
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        guard let performPaymentMethod = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController else { return }
        self.navigationController?.pushViewController(performPaymentMethod, animated: true)
    }
    
    //MARK: FUNCTION
    func getAllCartData() {
        DispatchQueue.main.async {
            self.cartVM.getProducInCart(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] cartProduct in
                self?.dataCart = cartProduct.data
                if let orderInfo = self?.dataCart?.orderInfo {
                    self?.subtotalPrice.text = "Rp \(orderInfo.subTotal)"
                    self?.shippingCost.text = "Rp \(orderInfo.shippingCost)"
                    self?.totalPrice.text = "Rp \(orderInfo.total)"
                }
                self?.tableView.reloadData()
            }
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
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countProduct = dataCart?.products?.count
        if countProduct == 0 {
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
            cartTableVM.increaseQuantityCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                if bool == true {
                    self.getAllCartData()
                    completion(dataCart.quantity)
                }
            }
        }
    }
    func decreaseQuantityCart(cell: CartTableViewCell, completion: @escaping (Int) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            let getSizeId = getSizeId(forSize: dataCart.size)
            cartTableVM.decreaseQuantityCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                if bool == true {
                    self.getAllCartData()
                    completion(dataCart.quantity)
                }
            }
        }
    }
    func deleteProductCart(cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            let getSizeId = getSizeId(forSize: dataCart.size)
            cartTableVM.deleteProductCart(isMockApi: false, productId: dataCart.id, sizeId: getSizeId, accessTokenKey: APIService().token!) { bool in
                if bool == true {
                    self.getAllCartData()
                }
            }
        }
    }
}

extension CartViewController: PassingDataAddresDelegate {
    func didFinishPassingData(city: String, country: String) {
        addressLabel.text = city
        cityLabel.text = country
    }
}
