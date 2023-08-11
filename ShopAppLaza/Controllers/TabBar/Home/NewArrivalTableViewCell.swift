//
//  NewArrivalTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit

protocol NewArrivalDidSelectItemDelegate: AnyObject {
    func NewArrivalItemSelectNavigation(didSelectItemAt indexPath: IndexPath, productModel: WelcomeElement)
}

class NewArrivalTableViewCell: UITableViewCell {
    
    static let identifier = "newArrivalTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "NewArrivalTableViewCell", bundle: nil)
    }
    var onReload: (() -> Void)?
    var product: Welcome = Welcome()
    private var newArrivalTableVM = NewArrivalTableViewModel()
    weak var delegate: NewArrivalDidSelectItemDelegate?

    //MARK: IBOutlet
    @IBOutlet weak var collectionNewArrival: DynamicHeightCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newArrivalTableVM.newArrivalTableViewCell = self
        collectionNewArrival.delegate = self
        collectionNewArrival.dataSource = self
        collectionNewArrival.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.newArrivalTableVM.getDataProduct { [weak self] produk in
                self?.product.append(contentsOf: produk)
                self?.collectionNewArrival.reloadData()
                self?.onReload?()
            }
        }
    }
}

extension NewArrivalTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
            let newArraival = product[indexPath.row]
            cellNewArraival.imageProduct.setImageWithPlugin(url: newArraival.image)
            cellNewArraival.titleProduk.text = newArraival.title
            cellNewArraival.priceProduk.text = "$\(String(newArraival.price))"
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
        let productModel = product[indexPath.item]
        delegate?.NewArrivalItemSelectNavigation(didSelectItemAt: indexPath, productModel: productModel)
    }
}
