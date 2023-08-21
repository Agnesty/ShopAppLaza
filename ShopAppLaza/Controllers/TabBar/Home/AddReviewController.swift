//
//  AddReviewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class AddReviewController: UIViewController {
    var idProduct: Int?
    var newRatingValue: Double = 0
    private let addReviewVM = AddReviewViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var slider: CustomSlider!{
        didSet{
            slider.sliderHeight = CGFloat(18)
        }
    }
    @IBOutlet weak var contentStar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addReviewVM.addReviewCtr = self
        updateRating()
        
    }
    
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: CustomSlider) {
        updateRating()
    }
    
    @IBAction func submitReviewAction(_ sender: UIButton) {
        addReviewVM.AddReview(id: self.idProduct!, accessTokenKey: APIService().token!, comment: textView.text!, rating: Double(formatValue(Double(slider.value)))!)
        
    }
    private func updateRating() {
        newRatingValue = Double(slider.value)
        self.contentStar.text = formatValue(newRatingValue)
    }
    
    func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    
    func goToReview() {
        self.navigationController?.popViewController(animated: true)
//        guard let reviewAction = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as? ReviewsViewController else { return }
//        self.navigationController?.pushViewController(reviewAction, animated: true)
//        reviewAction.idProduct = idProduct
//        reviewAction.navigationItem.hidesBackButton = true
    }
}
