//
//  NewArrivalTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit

protocol NewArrivalDidSelectItemDelegate: AnyObject {
    func NewArrivalItemSelectNavigation(didSelectItemAt indexPath: IndexPath, productModel: WelcomeElement)
    func ViewAllNewArrivalPush()
}

class NewArrivalTableViewCell: UITableViewCell {
    static let identifier = "newArrivalTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "NewArrivalTableViewCell", bundle: nil)
    }
    var onReload: (() -> Void)?
    var productAPI = [WelcomeElement]()
    private var newArrivalTableVM = NewArrivalTableViewModel()
    weak var delegate: NewArrivalDidSelectItemDelegate?
    var searchTextActive: Bool = false
    var filterProduct: [WelcomeElement] = []
    
    //MARK: IBOutlet
    @IBOutlet weak var collectionNewArrival: DynamicHeightCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        newArrivalTableVM.newArrivalTableViewCell = self
        collectionNewArrival.delegate = self
        collectionNewArrival.dataSource = self
        collectionNewArrival.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.newArrivalTableVM.getDataProduct(isMockApi: false) { [weak self] produk in
                guard let produkResponse = produk else { return }
                self?.productAPI.append(contentsOf: produkResponse.data)
                self?.collectionNewArrival.reloadData()
                self?.onReload?()
            }
        }
    }
    
    @IBAction func viewAllNewArrival(_ sender: UIButton) {
        delegate?.ViewAllNewArrivalPush()
    }
    
}

extension NewArrivalTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchTextActive == true {
            print("apakah ini ada isinya:", filterProduct.count)
            return filterProduct.count
        } else {
            return min(6, productAPI.count)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        if searchTextActive == true {
            let filteredProduct = filterProduct[indexPath.item]
            cellNewArraival.imageProduct.setImageWithPlugin(url: filteredProduct.image_url)
            cellNewArraival.titleProduk.text = filteredProduct.name
            cellNewArraival.priceProduk.text = "Rp \(String(filteredProduct.price))"
        } else {
            if indexPath.row < productAPI.count {
                let newArraival = productAPI[indexPath.row]
                cellNewArraival.imageProduct.setImageWithPlugin(url: newArraival.image_url)
                cellNewArraival.titleProduk.text = newArraival.name
                cellNewArraival.priceProduk.text = "Rp \(String(newArraival.price))"
            }
        }
        return cellNewArraival
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 160, height: 295)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productModel = productAPI[indexPath.item]
        if searchTextActive == true {
            delegate?.NewArrivalItemSelectNavigation(didSelectItemAt: indexPath, productModel: productModel)
        } else {
            delegate?.NewArrivalItemSelectNavigation(didSelectItemAt: indexPath, productModel: productModel)
        }
    }
}

extension NewArrivalTableViewCell: searchProductHomeProtocol {
    func searchProdFetch(isActive: Bool, textString: String) {
        searchTextActive = isActive
        filterProduct = productAPI.filter { product in
            return product.name.localizedCaseInsensitiveContains(textString)
        }
        self.collectionNewArrival.reloadData()
    }
}
