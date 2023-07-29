//
//  ViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 25/07/23.
//

import UIKit

class Screen1ViewController: UIViewController {
    
    var isButtonClickedWoman = false
    var isButtonClickedMen = false
    var buttonWomanClickCount = 0
    var buttonMenClickCount = 0
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = CGFloat(20)
        }
    }
    @IBOutlet weak var menContainer: UIView!{
        didSet{
            menContainer.layer.cornerRadius = CGFloat(10)
        }
    }
    
    @IBOutlet weak var womenContainer: UIView!{
        didSet{
            womenContainer.layer.cornerRadius = CGFloat(10)
        }
    }
    
    enum ButtonStatus {
           case normal, firstClick, secondClick
       }

       var womenButtonStatus: ButtonStatus = .normal
       var menButtonStatus: ButtonStatus = .normal
    
    @objc private func womenButtonTapped() {
         switch womenButtonStatus {
         case .normal:
             womenButtonStatus = .firstClick
             womenContainer.backgroundColor = UIColor(hex: "#9775FA")
             menContainer.backgroundColor = UIColor(hex: "#F5F6FA")
         case .firstClick:
             womenButtonStatus = .secondClick
             goToNextScreen()
         case .secondClick:
             womenButtonStatus = .normal
             womenContainer.backgroundColor = UIColor(hex: "#F5F6FA")
         }
     }

     @objc private func menButtonTapped() {
         switch menButtonStatus {
         case .normal:
             menButtonStatus = .firstClick
             menContainer.backgroundColor = UIColor(hex: "#9775FA")
             womenContainer.backgroundColor = UIColor(hex: "#F5F6FA")
         case .firstClick:
             menButtonStatus = .secondClick
             goToNextScreen()
         case .secondClick:
             menButtonStatus = .normal
             menContainer.backgroundColor = UIColor(hex: "#F5F6FA")
         }
     }

     private func goToNextScreen() {
         let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Screen2ViewController") as! Screen2ViewController
         self.navigationController?.pushViewController(nextViewController, animated: true)
     }
    
    @IBAction func skipAction(_ sender: UIButton) {
        guard let initialLoginSignUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Screen2ViewController") as? Screen2ViewController else { return }
        
        self.navigationController?.pushViewController(initialLoginSignUp, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let womenTapGesture = UITapGestureRecognizer(target: self, action: #selector(womenButtonTapped))
               womenContainer.addGestureRecognizer(womenTapGesture)

               let menTapGesture = UITapGestureRecognizer(target: self, action: #selector(menButtonTapped))
               menContainer.addGestureRecognizer(menTapGesture)
    }


}

