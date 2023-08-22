//
//  BrandVAViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import UIKit

class BrandVAViewController: UIViewController {
    private var categoryTableVM = CategoryTableViewModel()
    private var categoryBrandVA = [DescriptionBrand]()
    
    //MARK: IBOutlet
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var brandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.categoryTableVM.getDataCategories { [weak self] category in
                guard let categoryResponse = category else { return }
                self?.categoryBrandVA.append(contentsOf: categoryResponse.description)
                self?.countItems.text = String((self?.categoryBrandVA.count)!)
                self?.brandCollection.reloadData()
            }
        }
        
        brandCollection.dataSource = self
        brandCollection.delegate = self
        brandCollection.register(BrandCollectionViewCell.nib(), forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        brandCollection.reloadData()
    }
    
    //MARK: IBAction
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BrandVAViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryBrandVA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellBrand = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else { return UICollectionViewCell() }
    
        cellBrand.labelBrand.text = categoryBrandVA[indexPath.row].name.capitalized
        cellBrand.imageBrand.setImageWithPlugin(url: categoryBrandVA[indexPath.row].logo_url)
    
        return cellBrand
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
    
}
