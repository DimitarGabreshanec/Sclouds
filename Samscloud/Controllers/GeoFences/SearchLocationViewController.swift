//
//  SearchLocationViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/26/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapViewImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var isDispatchLocation = false
    var locationNames = ["Davison Girl’s School", "Davison Sewing"]
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location"
        searchBar.placeholder = "Search"
        containerViewBottomConstraint.constant = -containerView.frame.height
        mapViewImageView.image = UIImage(named: isDispatchLocation ? "mapLocation-dispatch" : "big-map")
        
        createBackBarButtonItem()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        containerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - Private methods
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

// MARK: - UITableViewDataSource

extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        cell.locationNameLabel.text = locationNames[indexPath.row]
        cell.bottomView.isHidden = indexPath.row == 1
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultLocationVC = StoryboardManager.contactStoryBoard().getController(identifier: "ResultLocationVC") as! ResultLocationViewController
        resultLocationVC.titleText = locationNames[indexPath.row]
        resultLocationVC.isDispatchLocation = true
        
        navigationController?.pushViewController(resultLocationVC, animated: true)
    }
}
