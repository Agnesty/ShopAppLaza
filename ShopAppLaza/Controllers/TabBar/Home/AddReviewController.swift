//
//  AddReviewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class AddReviewController: UIViewController {

    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var slider: CustomSlider!{
        didSet{
            slider.sliderHeight = CGFloat(18)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
