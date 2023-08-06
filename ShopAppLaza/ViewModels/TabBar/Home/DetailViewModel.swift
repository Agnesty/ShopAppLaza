//
//  DetailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class DetailViewModel {
    var detailViewCtr: DetailViewController?
    let sizes = ["S", "M", "L", "XL", "2XL"]
    
    func setProduct() {
        guard let unwrappedVC = detailViewCtr else { return }
        unwrappedVC.imageProduct.setImageWithPlugin(url: (unwrappedVC.product?.image)!)
        unwrappedVC.categoryBrand.text = unwrappedVC.product?.category.rawValue.capitalized
        unwrappedVC.titleBarang.text = unwrappedVC.product?.title
        unwrappedVC.priceLabel.text = "$\(unwrappedVC.product?.price ?? 0)"
        unwrappedVC.descriptionLabel.text = unwrappedVC.product?.description
        unwrappedVC.ratingLabel.text = "\(unwrappedVC.product?.rating.rate ?? 0)"
    }
    
}
