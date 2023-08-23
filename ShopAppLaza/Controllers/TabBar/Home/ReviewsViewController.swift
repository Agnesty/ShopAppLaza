//
//  ReviewsViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class ReviewsViewController: UIViewController {
    private var reviewsVM = ReviewsViewModel()
    let dummyReviews = dummyPeopleReviews
    var idProduct: Int?
    var allReviews: AllReviews?
    
    //MARK: IBOutlet
    @IBOutlet weak var totalItem: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var addReview: UIButton! {
        didSet{
            addReview.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var tableViewReviews: UITableView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewReviews.dataSource = self
        tableViewReviews.delegate = self
        tableViewReviews.register(ReviewsTableViewCell.nib(), forCellReuseIdentifier: ReviewsTableViewCell.identifier)
        getReviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       getReviews()
    }
    
    //MARK: IBAction
    @IBAction func addReviewAction(_ sender: UIButton) {
        guard let performAddReview = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddReviewController") as? AddReviewController else { return }
        performAddReview.idProduct = idProduct
        self.navigationController?.pushViewController(performAddReview, animated: true)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: FUNCTION
    func ratingStarData(rating: Double) {
        var collectStar = [Star]()
        var colors = [UIColor]()
        var isHalfStarAdded = false
        for index in 1...5 {
            if isHalfStarAdded {
                collectStar.append(Star.emptyStar)
                colors.append(.systemYellow)
                continue
            }
            let idx = Double(index)
            if idx <= rating {
                collectStar.append(Star.fullStar)
                colors.append(.systemYellow)
            } else if idx - rating > 0, idx - rating < 1 {
                collectStar.append(Star.halfStar)
                colors.append(.systemYellow)
                isHalfStarAdded = true
            } else {
                collectStar.append(Star.emptyStar)
                colors.append(.systemYellow)
            }
        }
        star1.image = UIImage(systemName: collectStar[0].rawValue)
        star2.image = UIImage(systemName: collectStar[1].rawValue)
        star3.image = UIImage(systemName: collectStar[2].rawValue)
        star4.image = UIImage(systemName: collectStar[3].rawValue)
        star5.image = UIImage(systemName: collectStar[4].rawValue)
        star1.tintColor = colors[0]
        star2.tintColor = colors[1]
        star3.tintColor = colors[2]
        star4.tintColor = colors[3]
        star5.tintColor = colors[4]
    }
    func getReviews() {
        guard let idProduk = idProduct else { return }
        reviewsVM.getAllReviews(id: idProduk) { allReview in
            DispatchQueue.main.async { [weak self] in
                self?.allReviews = allReview
                self?.totalItem.text = "\(allReview.data.total)"
                self?.averageRatingLabel.text = "\(allReview.data.ratingAvrg)"
                self?.ratingStarData(rating: allReview.data.ratingAvrg)
                self?.tableViewReviews.reloadData()
            }
        }
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviews?.data.reviews.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.identifier, for: indexPath) as? ReviewsTableViewCell else { return UITableViewCell() }
        if let reviews = self.allReviews?.data.reviews[indexPath.row] {
            cell.imageUser.setImageWithPlugin(url: reviews.imageURL)
            cell.peopleName.text = "\(reviews.fullName)"
            cell.textReviews.text = "\(reviews.comment)"
            cell.reviews.text = "\(reviews.rating)"
            cell.ratingStarData(rating: reviews.rating)
            cell.waktuReview.text = "\(DateTimeUtils.shared.formatReview(date: reviews.createdAt))"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
