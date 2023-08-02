//
//  NewArrivalTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 01/08/23.
//

import UIKit

class NewArrivalTableViewCell: UITableViewCell {
    
    private var product: Welcome = Welcome()
    
    static let identifier = "newArrivalTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "NewArrivalTableViewCell", bundle: nil)
    }
    
    var onReload: (() -> Void)?

    @IBOutlet weak var collectionNewArrival: DynamicHeightCollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awake from nib NewArrivalTableViewCell")
        
        collectionNewArrival.delegate = self
        collectionNewArrival.dataSource = self
        collectionNewArrival.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        
        DispatchQueue.main.async {
            self.getDataProduct { [weak self] produk in
                self?.product.append(contentsOf: produk)
                self?.collectionNewArrival.reloadData()
                self?.onReload?()
            }
        }
//        self.collectionNewArrival.collectionViewLayout.invalidateLayout()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
    
    
}

extension NewArrivalTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("dequeue product table collection view cell")
            guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }

            let newArraival = product[indexPath.row]
            cellNewArraival.setImageWithPlugin(url: newArraival.image)
            cellNewArraival.titleProduk.text = newArraival.title
            cellNewArraival.priceProduk.text = String(newArraival.price)
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
