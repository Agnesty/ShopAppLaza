//
//  SideMenuViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 29/07/23.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var defaultHighlightedCell: Int = 0
    var delegate: SideMenuViewControllerDelegate?
    
    @IBOutlet weak var imageUser: UIButton!
    @IBOutlet weak var namaUser: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBAction func logoutBtnAction(_ sender: UIButton) {
    }
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "AI")!),
        SideMenuModel(icon: UIImage(named: "Pass")!),
        SideMenuModel(icon: UIImage(named: "Order")!),
        SideMenuModel(icon: UIImage(named: "MC")!),
        SideMenuModel(icon: UIImage(named: "Wish")!),
        SideMenuModel(icon: UIImage(named: "Settings")!),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView?.delegate = self
        sideMenuTableView?.dataSource = self
        sideMenuTableView?.register(SideMenuTableViewCell.nib(), forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        
        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.sideMenuTableView?.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }
        
        sideMenuTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sideMenuCell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else { fatalError("xib doesn't exist") }
        
        sideMenuCell.sideMenuBtn.image = self.menu[indexPath.row].icon
        
        //Selected Color of Side Menu
//        let myCustomSelectionColorView = UIView()
//        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
//        sideMenuCell.selectedBackgroundView = myCustomSelectionColorView
        
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    

}
