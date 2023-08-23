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
        cartTableVM.cartTableVC = self
        setupTabBarItemImage()
        getAllCartData()
        
        cartVM.getAllSize { allSize in
            DispatchQueue.main.async { [weak self] in
                self?.allSizes = allSize
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.nib(), forCellReuseIdentifier: CartTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllCartData()
    }
    
    //MARK: IBAction
    @IBAction func checkoutBtnAction(_ sender: UIButton) {
        guard let performOrderConfirmed = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmedViewController") as? OrderConfirmedViewController else { return }
        self.navigationController?.pushViewController(performOrderConfirmed, animated: true)
    }
    @IBAction func addressBtnAction(_ sender: UIButton) {
        guard let performAddress = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController else { return }
        self.navigationController?.pushViewController(performAddress, animated: true)
    }
    @IBAction func paymentBtnAction(_ sender: UIButton) {
        guard let performPaymentMethod = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController else { return }
        self.navigationController?.pushViewController(performPaymentMethod, animated: true)
    }
    
    //MARK: FUNCTION
    func getAllCartData() {
        DispatchQueue.main.async {
            self.cartVM.getProducInCart(accessTokenKey: APIService().token!) { [weak self] cartProduct in
                self?.dataCart = cartProduct.data
                self?.tableView.reloadData()
            }
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCart?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        if let dataCart = dataCart?.products?[indexPath.row] {
            cell.labelNameProduct.text = dataCart.productName
            cell.imageProduct.setImageWithPlugin(url: dataCart.imageURL)
            cell.jumlahProduct.text = "\(dataCart.quantity)"
            cell.priceProduct.text = "$\(dataCart.price)"
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
    func deleteProductCart(cell: CartTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let dataCart = dataCart?.products?[indexPath.row] {
            
            var sizeId = -1
            guard let allSizeData = allSizes?.data else { return }
            for index in 0..<allSizeData.count {
                print("ini index:", index)
                if allSizeData[index].size == dataCart.size {
                    print("ini ke2 index:", allSizeData[index].size)
                    print("ini ke 3 index", dataCart.size)
                    sizeId = allSizeData[index].id
                    break
                }
            }
            print(sizeId)
            cartTableVM.deleteProductCart(productId: dataCart.id, sizeId: sizeId, accessTokenKey: APIService().token!) { bool in
                if bool == true {
                    self.getAllCartData()
                }
            }
            
            
        }
    }
    
    
}
