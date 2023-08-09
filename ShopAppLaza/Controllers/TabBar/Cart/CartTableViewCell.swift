//
//  CartTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let identifier = "tableViewCart"
    static func nib() -> UINib {
        return UINib(nibName: "CartTableViewCell", bundle: nil)
    }
    
    var currentNumber = 0
    
    //MARK: IBOutlet
    @IBOutlet weak var imageProduct: UIImageView!{
        didSet{
            imageProduct.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var labelNameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var jumlahProduct: UILabel!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateLabelJumlahProduct()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: IBAction
    @IBAction func decreaseBtnTapped(_ sender: UIButton) {
        decreaseBtn.tintColor = UIColor(hex: "#AF52DE")
        if currentNumber > 0 {
            currentNumber -= 1
        }
        updateLabelJumlahProduct()
        decreaseBtn.tintColor = UIColor(hex: "#8F959E")
    }
    @IBAction func increaseBtnTapped(_ sender: UIButton) {
        increaseBtn.tintColor = UIColor(hex: "#AF52DE")
        currentNumber += 1
        updateLabelJumlahProduct()
        increaseBtn.tintColor = UIColor(hex: "#8F959E")
    }
    
    //MARK: FUNCTION
    func updateLabelJumlahProduct() {
        jumlahProduct.text = "\(currentNumber)"
    }
    
}