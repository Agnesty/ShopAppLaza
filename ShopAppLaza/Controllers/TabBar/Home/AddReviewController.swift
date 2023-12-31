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
//        addReviewVM.addReviewCtr = self
        updateRating()
        addReviewVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
        addReviewVM.navigateToReview = { [weak self] in
            self?.goToReview()
        }
        
    }
    
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: CustomSlider) {
        updateRating()
    }
    
    @IBAction func submitReviewAction(_ sender: UIButton) {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.addReview()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    
    //MARK: FUNCTION
    private func updateRating() {
        newRatingValue = Double(slider.value)
        self.contentStar.text = formatValue(newRatingValue)
    }
    func formatValue(_ value: Double) -> String {
        return String(format: "%.1f", value)
    }
    func goToReview() {
        self.navigationController?.popViewController(animated: true)
    }
    func addReview() {
        addReviewVM.AddReview(isMockApi: false, id: self.idProduct!, accessTokenKey: APIService().token!, comment: textView.text!, rating: Double(formatValue(Double(slider.value)))!)
    }
}
