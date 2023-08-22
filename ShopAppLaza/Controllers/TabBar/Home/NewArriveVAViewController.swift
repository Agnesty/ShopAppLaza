//
//  NewArriveVAViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import UIKit

class NewArriveVAViewController: UIViewController {
    
    private var newArrivalTableVM = NewArrivalTableViewModel()
    var productAPI = [WelcomeElement]()

    //MARK: IBOutlet
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var newArrivalCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newArrivalCollection.dataSource = self
        newArrivalCollection.delegate = self
        newArrivalCollection.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.newArrivalTableVM.getDataProduct { [weak self] produk in
                guard let produkResponse = produk else { return }
                self?.productAPI.append(contentsOf: produkResponse.data)
                self?.countItems.text = String((self?.productAPI.count)!)
                self?.newArrivalCollection.reloadData()
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NewArriveVAViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productAPI.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
            let newArraival = productAPI[indexPath.row]
            cellNewArraival.imageProduct.setImageWithPlugin(url: newArraival.image_url)
            cellNewArraival.titleProduk.text = newArraival.name
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
}
