//
//  TableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "tableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
    var onReload: (() -> Void)?
    private var category: Categories = Categories()
    private var categoryTableVM = CategoryTableViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var labelNewArrival: UILabel!
    @IBOutlet weak var collectionBrand: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryTableVM.categoryTableViewCell = self
        collectionBrand.delegate = self
        collectionBrand.dataSource = self
        collectionBrand.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.categoryTableVM.getDataCategories { [weak self] category in
                self?.category.append(contentsOf: category)
                self?.collectionBrand.reloadData()
                self?.onReload?()
                }
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellBrand = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else { return UICollectionViewCell() }
            cellBrand.labelBrand.text = category[indexPath.row].capitalized
            return cellBrand
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
}
