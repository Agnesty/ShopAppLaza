//
//  AddReviewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class AddReviewController: UIViewController {
    var newRatingValue: Double = 0
    
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
        
        updateRating()
    }
    
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: CustomSlider) {
        updateRating()
    }
    
    private func updateRating() {
        newRatingValue = Double(slider.value)
        self.contentStar.text = AddReviewController.formatValue(newRatingValue)
    }
    
    private class func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}
