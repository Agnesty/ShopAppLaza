//
//  FavoriteViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Favorite"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()

        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        // Do any additional setup after loading the view.
    }
    

}
