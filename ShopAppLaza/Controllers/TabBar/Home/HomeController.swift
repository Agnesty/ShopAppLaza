//
//  HomeControllerViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit
import SideMenu

class HomeController: UIViewController {
    
    var loggedInUser: UserElement?
    
    private lazy var menuButton: UIButton = {
        let menuButton = UIButton.init(type: .custom)
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        menuButton.frame = CGRect(x: 20, y: 90, width: 45, height: 45)
        return menuButton
    }()
    
    @objc func menuButtonAction() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = homeStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
        vc.delegate = self
        let sideMenu = SideMenuNavigationController(rootViewController: vc)
        
        self.sideMenuNav = sideMenu
        
        sideMenu.presentationStyle = .menuSlideIn
        sideMenu.blurEffectStyle = .prominent
        sideMenu.leftSide = true
        sideMenu.menuWidth = 330
        present(sideMenu, animated: true)
        print("This is side menu baru")
    }
    
    private var sideMenuNav: SideMenuNavigationController?
    
    private lazy var keranjangButton: UIButton = {
        let keranjangButton = UIButton.init(type: .custom)
        keranjangButton.setImage(UIImage(named: "Cart"), for: .normal)
        keranjangButton.addTarget(self, action: #selector(keranjangButtonAction), for: .touchUpInside)
        keranjangButton.translatesAutoresizingMaskIntoConstraints = false
        return keranjangButton
    }()
    
    @objc func keranjangButtonAction() {
        //Action jika keranjang button di klik
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Home"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItemImage()
        view.addSubview(menuButton)
        view.addSubview(keranjangButton)
        applyConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(NewArrivalTableViewCell.nib(), forCellReuseIdentifier: NewArrivalTableViewCell.identifier)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            keranjangButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            keranjangButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keranjangButton.widthAnchor.constraint(equalToConstant: 45),
            keranjangButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            guard let cellCategory = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell else { return UITableViewCell() }
            cellCategory.onReload = { [weak self] in
                self?.tableView.reloadData()
            }
            return cellCategory
        } else {
            guard let cellProduct = tableView.dequeueReusableCell(withIdentifier: NewArrivalTableViewCell.identifier, for: indexPath) as? NewArrivalTableViewCell else { return UITableViewCell() }
            cellProduct.onReload = { [weak self] in
                self?.tableView.reloadData()
            cellProduct.delegate = self
            }
            return cellProduct
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 1 {
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension HomeController: NewArrivalDidSelectItemDelegate {
    func NewArrivalItemSelectNavigation(didSelectItemAt indexPath: IndexPath, productModel: WelcomeElement) {
        guard let detailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        self.navigationController?.pushViewController(detailView, animated: true)
        detailView.product = productModel
        
    }
    
}

extension HomeController: SideMenuControllerDelegate {
    
    func logoutPressed() {
        sideMenuNav?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
}
