//
//  MapPinViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/12/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import GooglePlaces

class MapPinViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var locationSearchResultsView: UIView!
    @IBOutlet var locationSearchResultsViewHeightConstraint: NSLayoutConstraint!
    var locationSearchTableViewController: LocationSearchTableViewController!
    var location: CLLocation!
    let pin = GMSMarker()
    let sessionToken = GMSAutocompleteSessionToken.init()
    var delayTimer: Timer?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.prepareNavigation()
        self.setupMap()
        self.locationSearchResultsView.roundCorners([.bottomLeft, .bottomRight], radius: 30)
        self.hideSearchResults()
        self.updateMapView(shouldResetRegion: true)
        GMSPlacesClient.provideAPIKey(GoogleApiKey)
    }
    
    func setupMap() {
        self.mapView.delegate = self
        do {
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func hideSearchResults() {
        self.locationSearchTableViewController.predictions = []
        self.locationSearchTableViewController.tableView.reloadData()
        UIView.animate(
            withDuration: 0.25,
            animations: { [weak self] in
                self?.locationSearchResultsViewHeightConstraint.constant = 0
                self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.locationSearchResultsView.isHidden = true
            }
        )
    }
    
    func showSearchResults() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.locationSearchResultsViewHeightConstraint.constant = 300
            self?.view.layoutIfNeeded()
            self?.locationSearchResultsView.isHidden = false
        }
    }
    
    // MARK: - Google Places
    
    @objc func getSearchResultsDelayed(timer: Timer) {
        self.getSearchResults(query: timer.userInfo as? String)
    }
    
    func getSearchResults(query: String?) {
        guard let query = query else {
            return
        }
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: query, bounds: nil, boundsMode: .bias, filter: nil, sessionToken: self.sessionToken) { (predictions, error) in
            if let p = predictions, error == nil {
                self.locationSearchTableViewController.predictions = p
                self.locationSearchTableViewController.tableView.reloadData()
            }
        }
    }
    
    func selectLocation(placeID: String) {
        self.view.endEditing(true)
        self.searchBar.text = nil
        self.hideSearchResults()
        self.locationSearchTableViewController.predictions = []
        self.locationSearchTableViewController.tableView.reloadData()
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID) { (place, error) in
            if let p = place, error == nil {
                self.location = CLLocation(latitude: p.coordinate.latitude, longitude: p.coordinate.longitude)
                self.updateMapView(shouldResetRegion: true)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func saveButtonAction() {
        self.performSegue(withIdentifier: "unwindToReportDetailsTable", sender: nil)
    }
    
    // MARK: - Private
    
    private func prepareNavigation() {
        self.title = "Location"
        self.createBackBarButtonItem()
        
        // Add barButtonItem for rightBarButton
        let saveButton = creatCustomBarButton(title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    private func updateMapView(shouldResetRegion: Bool) {
        self.pin.position = self.location.coordinate
        self.pin.isDraggable = true
        self.pin.map = self.mapView
        if shouldResetRegion {
            self.mapView.animate(toZoom: 19)
        }
        self.mapView.animate(toLocation: self.location.coordinate)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let locationSearch as LocationSearchTableViewController:
            self.locationSearchTableViewController = locationSearch
        default:
            break
        }
    }
}

extension MapPinViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.location = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.view.endEditing(true)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.updateMapView(shouldResetRegion: false)
        self.view.endEditing(true)
    }
}

extension MapPinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespaces)
        self.delayTimer?.invalidate()
        
        guard searchText.count >= 3 else {
            self.hideSearchResults()
            return
        }
        self.showSearchResults()
        self.delayTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapPinViewController.getSearchResultsDelayed(timer:)), userInfo: searchText, repeats: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
