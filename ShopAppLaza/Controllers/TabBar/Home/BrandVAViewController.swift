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
    var isAscendingOrder = true
    
    //MARK: IBOutlet
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var sortBtn: UIButton!{
        didSet{
            sortBtn.setImage(UIImage(systemName: ""), for: .normal)
            sortBtn.setTitle("Sort", for: .normal)
        }
    }
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var brandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()
        DispatchQueue.main.async {
            self.categoryTableVM.getDataCategories(isMockApi: false) { [weak self] category in
                guard let categoryResponse = category else { return }
                self?.categoryBrandVA.append(contentsOf: categoryResponse.description)
                self?.countItems.text = String((self?.categoryBrandVA.count)!) + Utils.setItemsWord(dataItem: (self?.categoryBrandVA.count)!)
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
            categoryBrandVA.sort { $0.name < $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.first.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" A-Z", for: .normal)
        } else if !isAscendingOrder {
            categoryBrandVA.sort { $0.name > $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.last.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" Z-A", for: .normal)
        }
        brandCollection.reloadData()
    }
    
    
}

extension BrandVAViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countProduct = categoryBrandVA.count
        if countProduct == 0 {
            self.noItemLabel.isHidden = false
        } else {
            self.noItemLabel.isHidden = true
            }
        return countProduct
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("brandVA")
        let category = categoryBrandVA[indexPath.row]
        guard let categoryDetailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "CategoryDetailView") as? CategoryDetailView else { return }
        categoryDetailView.name = category.name
        categoryDetailView.img = category.logo_url
        self.navigationController?.pushViewController(categoryDetailView, animated: true)
    }
    
}
