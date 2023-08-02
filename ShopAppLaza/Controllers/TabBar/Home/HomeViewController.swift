//
//  HomeViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
    
    var produk = [WelcomeElement]()
    var category = Categories()
    var loggedInUser: UserElement?
    
    private lazy var menuButton: UIButton = {
        let menuButton = UIButton.init(type: .custom)
        menuButton.setImage(UIImage(named: "Menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        menuButton.frame = CGRect(x: 20, y: 90, width: 45, height: 45)
        return menuButton
    }()

    @objc func menuButtonAction() {
//        present(menu, animated: true)
        present(withIdentifier: "SideMenu")
        print("This is sde menu")
    }
    
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
    
    @IBOutlet weak var collectionBrand: UICollectionView!
    @IBOutlet weak var collectionArraival: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.leftSide = true
        menu.menuWidth = 300
        menu.blurEffectStyle = .prominent

        DispatchQueue.main.async {
            self.getDataCategories { [weak self] category in
                self?.category.append(contentsOf: category)
                self?.collectionBrand.reloadData()
            }
            self.getDataProduct { [weak self] products in
                self?.produk.append(contentsOf: products)
                self?.collectionArraival.reloadData()
            }
        }
        
        setupTabBarItemImage()
        view.addSubview(menuButton)
        view.addSubview(keranjangButton)
        applyConstraints()
        
        //Collection of Choose Brand
        collectionBrand.delegate = self
        collectionBrand.dataSource = self
        collectionBrand.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        
        //Collection of New Arrival
        collectionArraival.delegate = self
        collectionArraival.dataSource = self
        collectionArraival.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            keranjangButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            keranjangButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keranjangButton.widthAnchor.constraint(equalToConstant: 45),
            keranjangButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionBrand {
            return category.count
        }
        return produk.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionBrand {
            guard let cellBrand = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else { return
                UICollectionViewCell() }
            let category = category[indexPath.row]
            cellBrand.labelBrand.text = category.capitalized
            return cellBrand
        } else {
            guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
            let newArraival = produk[indexPath.row]
            cellNewArraival.setImageWithPlugin(url: newArraival.image)
            cellNewArraival.titleProduk.text = newArraival.title
            cellNewArraival.priceProduk.text = String(newArraival.price)
            
            return cellNewArraival
        }
    }
    
    func getDataProduct(completion: @escaping (Welcome) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else { print("Invalid URL.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let products = try JSONDecoder().decode(Welcome.self, from: data)

                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
    
    func getDataCategories(completion: @escaping (Categories) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products/categories") else { print("Invalid URL.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let categories = try JSONDecoder().decode(Categories.self, from: data)
                DispatchQueue.main.async {
                    completion(categories)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionBrand {
            return CGSize(width: 150, height: 50)
        }
        return CGSize(width: 160, height: 270)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collectionBrand {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collectionBrand {
            return 10
        }
        return 20
    }

}
