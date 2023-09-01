//
//  HomeControllerViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit
import SideMenu
import JWTDecode

protocol searchProductHomeProtocol: AnyObject {
    func searchProdFetch(isActive: Bool, textString: String)
}

class HomeController: UIViewController {
    var loggedInUser: UserElement?
    var isValidToken = false
    private var sideMenuNav: SideMenuNavigationController?
    private var homeVM = HomeViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
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
    }
    
    //Setting tabbar names
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        view.addSubview(menuButton)
        jwtExpired()
        if isValidToken {
            setUpTableView()
        }
    }
    
    func jwtExpired() {
        do {
            let jwt = try decode(jwt: APIService().token!)
            if jwt.expired {
                isValidToken = false
                updateUsers()
            } else {
                isValidToken = true
            }
            
        } catch {
            print("ini gagal")
        }
    }
    func setUpTableView() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.register(NewArrivalTableViewCell.nib(), forCellReuseIdentifier: NewArrivalTableViewCell.identifier)
    }
    
    func updateUsers() {
        guard let refreshToken = KeychainManager.keychain.getToken(service: Token.refresh.rawValue) else {
            print("Refresh token is nil")
            self.navigationController?.popToRootViewController(animated: false)
            return
        }
        APIService.refreshTokenAsync(isMockApi: false, refreshTokenKey: refreshToken) { refreshedToken in
            print("Refreshed token:", refreshedToken)
        }
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
            cellCategory.delegate = self
            return cellCategory
        } else {
            guard let cellProduct = tableView.dequeueReusableCell(withIdentifier: NewArrivalTableViewCell.identifier, for: indexPath) as? NewArrivalTableViewCell else { return UITableViewCell() }
            cellProduct.onReload = { [weak self] in
                self?.tableView.reloadData()
                self?.homeVM.delegateSearch = cellProduct
            }
            cellProduct.delegate = self
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
    func ViewAllNewArrivalPush() {
        print("ViewAllNewArrivalPush")
        guard let performViewAllNewArrival = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "NewArriveVAViewController") as? NewArriveVAViewController else { return }
        self.navigationController?.pushViewController(performViewAllNewArrival, animated: true)
    }
    func NewArrivalItemSelectNavigation(didSelectItemAt indexPath: IndexPath, productModel: WelcomeElement) {
        print("NewArrivalItemSelectNavigation")
        guard let newArrivalDetailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        self.navigationController?.pushViewController(newArrivalDetailView, animated: true)
        newArrivalDetailView.productId = productModel.id
        newArrivalDetailView.product = productModel
    }
}

extension HomeController: CategoryBrandSelectItemDelegate {
    func ViewAllBrandPush() {
        guard let performVABrand = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "BrandVAViewController") as? BrandVAViewController else { return }
        self.navigationController?.pushViewController(performVABrand, animated: true)
    }
    
    func CategoryItemSelectNavigation(didSelectItem indexPath: IndexPath, category: DescriptionBrand) {
        guard let categoryDetailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "CategoryDetailView") as? CategoryDetailView else { return }
        categoryDetailView.name = category.name
        categoryDetailView.img = category.logo_url
        self.navigationController?.pushViewController(categoryDetailView, animated: true)
    }
}

extension HomeController: SideMenuControllerDelegate {
    func logoutPressed() {
        sideMenuNav?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HomeController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeVM.performSearch(with: searchText)
        tableView.reloadData()
    }
}
