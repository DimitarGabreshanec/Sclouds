//
//  MyOrganizationsViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/14/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MyOrganizationsViewController: UIViewController, UITextFieldDelegate {
    
    var organizations = [OrganizationModel]()
    let user = User()
   
    var filteredList = [OrganizationModel]()
    var isSearching = false
    var isReport = false
    var reports: [ReportResponse] = []
    var visibleReports: [ReportResponse] = []
    var orgResponse : [ReportOrganizationResponse] = []
    var location:CLLocation?
    
    
    @IBOutlet weak var mapView: GMSMapView!{
           didSet{
               if mapView != nil {
                   mapView.isMyLocationEnabled = true
                   mapView.settings.myLocationButton = true
                   
                   if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"){
                       mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
                   }
       
               }
           }
       }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var showSearchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var leadingSearchViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSearchViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXSearchViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var reportContainerView: UIView!
    @IBOutlet weak var listTitleButton: UIButton!
    @IBOutlet weak var listButtonAction: UIButton!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    
    // MARK: - INIT
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "My Organizations"
//        reportContainerView.isHidden = !isReport
//              
//              getOrganizationList()
//              prepareTextField()
//              searchContainerView.layer.cornerRadius = 8
//              prepareNavigation()
//              prepareTableView()
//              if isReport {
//                  mapViewHeight.constant = 0
//                  let placeHolder = "Search Reports"
//                  searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
//                  searchTextField.textColor = UIColor.blackTextColor()
//                  searchTextField.font = UIFont.circularStdBook(size: 13)
//              }
//              
//              location = appDelegate.currentLocation
//              animateZoomLevel(zoom: 14)
//        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "My Organizations"
        reportContainerView.isHidden = !isReport
        loadCache()
        getOrganizationList()
        prepareTextField()
        searchContainerView.layer.cornerRadius = 8
        prepareNavigation()
        prepareTableView()
        if isReport {
            mapViewHeight.constant = 0
            let placeHolder = "Search Reports"
            searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
            searchTextField.textColor = UIColor.blackTextColor()
            searchTextField.font = UIFont.circularStdBook(size: 13)
        }
        
        location = appDelegate.currentLocation
        animateZoomLevel(zoom: 14)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getReports()
//        reportContainerView.isHidden = !isReport
//
//        getOrganizationList()
//        prepareTextField()
//        searchContainerView.layer.cornerRadius = 8
//        prepareNavigation()
//        prepareTableView()
//        if isReport {
//            mapViewHeight.constant = 0
//            let placeHolder = "Search Reports"
//            searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
//            searchTextField.textColor = UIColor.blackTextColor()
//            searchTextField.font = UIFont.circularStdBook(size: 13)
//        }
//
//        location = appDelegate.currentLocation
//        animateZoomLevel(zoom: 14)
    }
    
    private func getReports() {
        GetAllReportsService().getAllReports(
            success: { reports in
                let reports = reports.sorted(by: {
                    $0.createdAt?.toDate() ?? Date() > $1.createdAt?.toDate() ?? Date()
                })
                self.reports = reports
                self.visibleReports = reports
                self.reportTableView.reloadData()
            },
            failure: { error in
                self.showAlertWithActions("Error", message: "Oops! Something went wrong.", actions: nil)
            }
        )
    }
    
    // MARK: - ACTIONS
    
    @objc func addButtonAction() {
        showAddOrganizationPage()
    }
    
    private func fetchOrganizations() -> [Organization] {
        var orgnizationArray = [Organization]()
        let nameArray =  ["Baylor University", "Baylor University", "KPRC News 13"]
        for name in nameArray {
            let instance = Organization.init(with: name)
            orgnizationArray.append(instance)
        }
        return orgnizationArray
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 13)
        let placeholderColor = UIColor(hexString: "939393")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
    
    private func prepareTextField() {
        let placeHolder = "Search your geofence community"
        searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
        searchTextField.textColor = UIColor.blackTextColor()
        searchTextField.font = UIFont.circularStdBook(size: 13)
    }
    
    private func prepareNavigation() {
        createBackBarButtonItem()
        let addButton = creatCustomBarButton(title: "Add")
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        addBarButtonItem.action = #selector(addButtonAction)
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    
    private func prepareTableView() {
        let nib = UINib(nibName: MyOrganizationsTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MyOrganizationsTableViewCell.identifier)
        tableView.register(nib, forCellReuseIdentifier: ReportTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    private func animationSearch(isSearch: Bool) {
        centerXSearchViewConstraint.isActive = !isSearch
        leadingSearchViewConstraint.isActive = isSearch
        trailingSearchViewConstraint.isActive = isSearch
        showSearchButton.isHidden = isSearch
        if isSearch {
            searchTextField.becomeFirstResponder()
        } else {
            searchTextField.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getOrganizationList() {
        
        let url = BASE_URL + Constants.ORGANIZATION_LIST
        
//        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
//            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                self.organizations = json.array?.decode() ?? []
                UserDefaults.standard.setOrganizationsCache(json)
                self.processOrganizationsArray()
            }
        }
    }
    
    func processOrganizationsArray() {
        self.organizations.forEach({
                
                if let lat = $0.latitude , let long = $0.longitude {
                    let marker = GMSMarker.init()
                    marker.title = $0.organization_name
                    marker.snippet = $0.address
                    marker.isTappable = true
                    marker.icon = UIImage.init(named: "map_icon")
                    marker.position = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                    marker.map = self.mapView
                }
        
            })
        
        self.tableView?.reloadData()
    }
    
    func loadCache() {
        if let json = UserDefaults.standard.getOrganizationsCache() {
            self.organizations = json.array?.decode() ?? []
            self.processOrganizationsArray()
        }
    }
    
    
    func getParam()->[String:AnyObject] {
        var dictionary = [String:AnyObject]()
        dictionary.updateValue(NSNumber.init(value: 0), forKey: "user_id")
        dictionary.updateValue(NSNumber.init(value: 28.5355), forKey: "latitute")
        dictionary.updateValue(NSNumber.init(value: 77.3910), forKey: "longitite")
        return dictionary
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        animationSearch(isSearch: true)
    }
    
    @IBAction func locationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        guard !isReport else {
            if text.count > 0 {
                visibleReports = reports.filter({
                    $0.reportType?.localizedCaseInsensitiveContains(text) ?? false
                })
            } else {
                visibleReports = reports
            }
            reportTableView.reloadData()
            return
        }
        
        if text.count > 0 {
            isSearching = true
            filteredList = organizations.filter({
                $0.organization_name!.localizedCaseInsensitiveContains(text)
            })
        }else{
            isSearching = false
        }
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}










extension MyOrganizationsViewController :UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reportTableView {
            return visibleReports.count
        }
        if isSearching {return filteredList.count}
        return organizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == reportTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            let report = visibleReports[indexPath.row]
            cell.reportNameLabel.text = "Report - \(report.reportType ?? "")"
            cell.addressLabel.text = report.address ?? ""
            cell.timeLabel.text = report.createdAt?.toDate()?.presentableDateTime
            cell.moreButtonAction = { [weak self] in
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { alert in
                    SwiftLoader.show(animated: true)
                    DeleteReportService().deleteReport(
                        reportID: report.id ?? -1,
                        success: {
                            SwiftLoader.hide()
                            self?.getReports()
                        },
                        failure: { _ in
                            SwiftLoader.hide()
                            self?.showAlertWithActions("Error", message: "Oops! Something went wrong.", actions: nil)
                        }
                    )
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                self?.showActionSheet(nil, message: nil, actions: [cancelAction, deleteAction])
            }
           return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: MyOrganizationsTableViewCell.identifier, for: indexPath) as! MyOrganizationsTableViewCell
        let organization = isSearching == false ? organizations[indexPath.row] : filteredList[indexPath.row]
        
        cell.checkImageView.isHidden = true
        cell.nameLabel.text = organization.organization_name
        cell.addressLabel.text = organization.address
     
        if let lat = organization.latitude , let long = organization.longitude {
            if appDelegate.currentLocation != nil{
                let loc1 = CLLocation.init(latitude: lat, longitude: long)
                let distance = loc1.distance(from: appDelegate.currentLocation)/1609.34
                let str = String.init(format: "%.2f miles", Float(distance))
                cell.rangeButton.setTitle(str, for: .normal)
            }
        }
        if let img = organization.logo, img != ""{
            loadImage(img, cell.organizationImageView, activity: nil, defaultImage: nil)
        }else{
            cell.organizationImageView.image = UIImage.init(named: "logo-landing")
        }
        cell.moreButtonAction = { [weak self] in
            self?.showOptions(indexPath: indexPath)
        }
        cell.policeButton.isHidden = organization.dispatch == false
        cell.notificationButton.isHidden = organization.alert == false
        return cell
    }
    
    private func showOptions(indexPath: IndexPath) {
        let organization = isSearching == false ? organizations[indexPath.row] : filteredList[indexPath.row]
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { alert in
        
            SwiftLoader.show(animated: true)
                               OrganizationDeleteService().deleteOrganization(
                                organizationID: Int(organization.id ?? "") ?? -1,
                                   success: {
                                       SwiftLoader.hide()
                                    self.getOrganizationList()
                                   },
                                   failure: { _ in
                                       SwiftLoader.hide()
                                       self.showAlertWithActions("Error", message: "Oops! Something went wrong.", actions: nil)
                                   }
                               )
            
        })
        
        deleteAction.setValue(UIColor(hexString: "ff3b30"), forKey: "titleTextColor")
        
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { alert in
            let vc = OrganizationDetailViewController.instanse()
            vc.organization = organization
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        let muteAction = UIAlertAction(title: "Mute", style: .default, handler: { alert in
            // Doing something
        })
        
        let unsubscribeAction = UIAlertAction(title: "Unsubscribe", style: .default, handler: { alert in
            // Doing something
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.showActionSheet(organization.organization_name,
                             message: nil,
                             actions: [cancelAction, viewAction, muteAction, unsubscribeAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isReport {
            let report = self.reports[indexPath.row]
            let reportDetailVC = StoryboardManager.reportsStoryBoard().getController(identifier: "ReportDetailVC") as! ReportDetailsContainerViewController
            reportDetailVC.report = report
            self.navigationController?.pushViewController(reportDetailVC, animated: true)
        }else{
            let organization = isSearching == false ? organizations[indexPath.row] : filteredList[indexPath.row]
            let vc = OrganizationDetailViewController.instanse()
            vc.organization = organization
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}








extension MyOrganizationsViewController :SearchOrganizationDelegate,MenuAddContactDelegate{
    
    private func showAddOrganizationPage() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = true
        menuAddContactVC.delegate = self
        
        menuAddContactVC.addContactButtonAction = {
            print("addContactButtonAction")
            let searchMyOrganizationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
            searchMyOrganizationVC.isAddOrganization = true
            searchMyOrganizationVC.delegate = self
            self.navigationController?.pushViewController(searchMyOrganizationVC, animated: true)
        }
        
        menuAddContactVC.searchProCodeButtonAction = {
            print("searchProCodeButtonAction")
        }
        
        menuAddContactVC.errorProCodeButtonAction = {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let message = "Enter a valid ProCode."
            self.showAlertWithActions("Error",
                                      message: message,
                                      actions: [okAction])
        }
        present(menuAddContactVC, animated: false, completion: nil)
    }
    
    
    func didfinish() {
        self.getOrganizationList()
    }
    
    func didFinishAdding() {
        self.getOrganizationList()
    }
    
    func didclickMenu(arrOrgan: Organization) {
        
    }
    
}







// MARK:- MKMapViewDelegate...
extension MyOrganizationsViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let location = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            mapView?.removeObserver(self, forKeyPath: "myLocation")
            self.animateZoomLevel(zoom: 14)
        }
    }
    
    
    func animateZoomLevel(zoom:CGFloat) {
        let zoomAnimation = CABasicAnimation(keyPath: kGMSLayerCameraZoomLevelKey)
        zoomAnimation.fromValue = 5
        zoomAnimation.toValue = zoom
        zoomAnimation.duration = CFTimeInterval(2.5)
        
        mapView?.layer.add(zoomAnimation, forKey: nil)
        perform(#selector(updateCamera), with: nil, afterDelay: 2.3)
    }
    
    
    
    @objc func  updateCamera() {
        
        if let loc = self.location {
            let camera = GMSCameraPosition.camera(withLatitude: appDelegate.currentLocation.coordinate.latitude, longitude: appDelegate.currentLocation.coordinate.longitude, zoom: 17.0)
            mapView.camera = camera
        }
    }
    
}
