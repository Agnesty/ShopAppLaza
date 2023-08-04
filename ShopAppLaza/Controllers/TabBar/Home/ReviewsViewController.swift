//
//  ReviewsViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class ReviewsViewController: UIViewController {

    let dummyReviews = dummyPeopleReviews
    
    @IBOutlet weak var addReview: UIButton! {
        didSet{
            addReview.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var tableViewReviews: UITableView!
    
    @IBAction func addReviewAction(_ sender: UIButton) {
        guard let performAddReview = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddReviewController") as? AddReviewController else { return }
        self.navigationController?.pushViewController(performAddReview, animated: true)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewReviews.dataSource = self
        tableViewReviews.delegate = self
        tableViewReviews.register(ReviewsTableViewCell.nib(), forCellReuseIdentifier: ReviewsTableViewCell.identifier)
    }

}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.identifier, for: indexPath) as? ReviewsTableViewCell else { return UITableViewCell() }
        
        cell.imageSetFromURL(url: dummyReviews[indexPath.row].imageUser)
        cell.peopleName.text = dummyReviews[indexPath.row].name
        cell.textReviews.text = dummyReviews[indexPath.row].textReviews
        cell.reviews.text = dummyReviews[indexPath.row].rating
        cell.waktuReview.text = dummyReviews[indexPath.row].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
