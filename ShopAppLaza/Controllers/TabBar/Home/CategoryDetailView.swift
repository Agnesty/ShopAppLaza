//
//  CardPaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit

class CategoryDetailView: UIViewController {
    private let categoryDetailVM = CategoryDetailViewModel()
    var idProduct: Int?
    var categoryDetail: DetailBrand?
    
    //MARK: IBOutlet
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var categoryBrandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetailVM.categoryDetailVC = self
        categoryDetailVM.getCategoryDetailById(id: idProduct!) { [weak self] detailBrand in
            DispatchQueue.main.async {
                self?.categoryDetail = detailBrand
                self?.logoImage.setImageWithPlugin(url: detailBrand.data.logo_url)
                self?.categoryBrandCollection.reloadData()
            }
        }
        
        categoryBrandCollection.dataSource = self
        categoryBrandCollection.delegate = self
        categoryBrandCollection.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CategoryDetailView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        if let categoryBrand = categoryDetail?.data {
            cell.imageProduct.setImageWithPlugin(url: categoryBrand.logo_url)
            cell.titleProduk.text = categoryBrand.name.capitalized
        }
        return cell
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
    
    
}
