//
//  WalletViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit
import CreditCardForm

class WalletViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "MyCards"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()

        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardPaymentCollectionViewCell.nib(), forCellWithReuseIdentifier: CardPaymentCollectionViewCell.identifier)
    }

}

extension WalletViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardPaymentCollectionViewCell.identifier, for: indexPath) as? CardPaymentCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 300, height: 200)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
}
