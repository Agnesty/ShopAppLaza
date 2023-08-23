//
//  TableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit

protocol CategoryBrandSelectItemDelegate: AnyObject {
    func CategoryItemSelectNavigation(didSelectItem indexPath: IndexPath, category: DescriptionBrand)
    func ViewAllBrandPush()
}

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "tableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
    var onReload: (() -> Void)?
    private var category = [DescriptionBrand]()
    private var categoryTableVM = CategoryTableViewModel()
    weak var delegate: CategoryBrandSelectItemDelegate?
    
    //MARK: IBOutlet
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var collectionBrand: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryTableVM.categoryTableViewCell = self
        collectionBrand.delegate = self
        collectionBrand.dataSource = self
        collectionBrand.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.categoryTableVM.getDataCategories { [weak self] category in
                guard let categoryResponse = category else { return }
                self?.category.append(contentsOf: categoryResponse.description)
                self?.collectionBrand.reloadData()
                self?.onReload?()
                }
        }
    }
    
    //MARK: IBAction
    
    @IBAction func viewAllBrand(_ sender: UIButton) {
        delegate?.ViewAllBrandPush()
    }
    
//        func brandSizeForItemAt(sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let padding: CGFloat = 10
//            guard let item = viewModel.getBrandOnIndex(index: indexPath.item) else {
//                return CGSize(width: 50, height: 50)
//            }
//            let itemWidth = item.size(withAttributes: [
//                NSAttributedString.Key.font : FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 17)
//            ]).width
//            return CGSize(width: itemWidth + padding * 2, height: 50)
//        }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(5, category.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellBrand = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < category.count {
            cellBrand.labelBrand.text = category[indexPath.row].name.capitalized
            cellBrand.imageBrand.setImageWithPlugin(url: category[indexPath.row].logo_url)
        }
            return cellBrand
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = category[indexPath.row]
        delegate?.CategoryItemSelectNavigation(didSelectItem: indexPath, category: category)
    }
}
