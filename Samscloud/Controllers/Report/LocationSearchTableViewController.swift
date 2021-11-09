//
//  LocationSearchTableViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/15/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSearchTableViewController: UITableViewController {
    var predictions: [GMSAutocompletePrediction] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.predictions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchResultCell", for: indexPath) as! LocationSearchResultCell
        let prediction = self.predictions[indexPath.row]
        cell.nameLabel.text = prediction.attributedPrimaryText.string
        cell.addressLabel.text = prediction.attributedFullText.string
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let prediction = self.predictions[indexPath.row]
        let parent = self.parent as! MapPinViewController
        parent.selectLocation(placeID: prediction.placeID)
    }
}
