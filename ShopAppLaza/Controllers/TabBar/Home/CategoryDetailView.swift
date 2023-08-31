//
//  CardPaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit

class CategoryDetailView: UIViewController {
    private let categoryDetailVM = CategoryDetailViewModel()
    var name: String = ""
    var img: String = ""
    var categoryDetail = [Datum]()
    var isAscendingOrder = true
    
    //MARK: IBOutlet
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var sortBtn: UIButton!{
        didSet{
            sortBtn.setImage(UIImage(systemName: ""), for: .normal)
            sortBtn.setTitle(" Sort", for: .normal)
        }
    }
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var categoryBrandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()
        categoryDetailVM.getDetailBrandById(isMockApi: false, name: name) { [weak self] produkBrand in
            DispatchQueue.main.async {
                self?.categoryDetail = produkBrand.data
                print("ini adalah produk brand", produkBrand)
                self?.countItems.text = String((self?.categoryDetail.count)!) + Utils.setItemsWord(dataItem: (self?.categoryDetail.count)!)
                self?.logoImage.setImageWithPlugin(url: self!.img)
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
    @IBAction func sortAction(_ sender: UIButton) {
        toggleSortOrder()
    }
    
    //MARK: FUNCTION
    func toggleSortOrder() {
        isAscendingOrder.toggle()
        sortData()
    }
    func sortData() {
        if sortBtn.currentImage == UIImage(systemName: ""){
            sortBtn.setTitle(" Sort", for: .normal)
            sortBtn.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        } else if isAscendingOrder {
            categoryDetail.sort { $0.name < $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.first.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" A-Z", for: .normal)
        } else if !isAscendingOrder {
            categoryDetail.sort { $0.name > $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.last.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" Z-A", for: .normal)
        }
        categoryBrandCollection.reloadData()
    }
    
}

extension CategoryDetailView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countProduct = categoryDetail.count
        if countProduct == 0 {
            self.noItemLabel.isHidden = false
        } else {
            self.noItemLabel.isHidden = true
            }
        return countProduct
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        let categoryBrand = categoryDetail[indexPath.row]
        cell.imageProduct.setImageWithPlugin(url: categoryBrand.imageURL)
        cell.titleProduk.text = categoryBrand.name.capitalized
        cell.priceProduk.text = "Rp \(String(categoryBrand.price))"
        
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailCategoryView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        self.navigationController?.pushViewController(detailCategoryView, animated: true)
        let categoryBrand = categoryDetail[indexPath.row]
        detailCategoryView.productId = categoryBrand.id
    }
    
}
