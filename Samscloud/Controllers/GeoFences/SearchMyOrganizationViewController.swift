//
//  SearchMyOrganizationViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/15/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

enum SearchOrgnizationPresenter {
    case reports
}

protocol SearchOrganizationDelegate {
    func didfinish()
}

class SearchMyOrganizationViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showSearchButton: UIButton!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var searchViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emptyView: UIView!
    
    var presenter: SearchOrgnizationPresenter? = nil
    var selectedOrganizations: [OrganizationModel] = [] {
        didSet {
            addBarButton.activatedOfNavigationBar(
                selectedOrganizations.count > 0
            )
        }
    }
    var isAddOrganization = false
    var delegate:SearchOrganizationDelegate?
    
    var list = [OrganizationModel]()
    var visibleList = [OrganizationModel]()
    
    var selectedIndex:Int = -1{
        didSet{
            if selectedIndex != -1 {
               addBarButton.activatedOfNavigationBar(true)
            }else{
                addBarButton.activatedOfNavigationBar(false)
            }
        }
    }
    
    var addBarButton:UIButton!
    
}







// MARK:- Life cycle
extension SearchMyOrganizationViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        
        searchTextField.userStoppedTypingHandler = {
            if self.presenter == .reports {
                self.serachOrganization()
            } else {
                let txt = self.searchTextField.text ?? ""
                if !txt.isEmpty {
                    self.serachOrganization()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    func setupViews() {
        
        title = (presenter == .reports ? "Search Organization" : "Search Organizations")
        searchContainerView.layer.cornerRadius = 8
        
        prepareTableView()
        prepareTextField()
        prepareNavigation()
        
        if presenter == .reports {
            getAllOrganizations()
        }
        
        addBarButton = creatCustomBarButton(title: "Add")
        addBarButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addBarButton.activatedOfNavigationBar(false)
        let addBarButtonItem = UIBarButtonItem(customView: addBarButton)
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func getAllOrganizations() {
        GetAllOrganizationsService().getAllOrganizations(
            success: { organizations in
                self.list = organizations
                if self.presenter == .reports {
                    self.list = self.list.filter({ $0.who_can_join != "Private" })
                }
                self.list.forEach({ $0.updateDistance() })
                self.list.sort(by: { $0.distance < $1.distance })
                self.visibleList = self.list
                self.tableView.reloadData()
            },
            failure: { error in
                self.showAlertWithActions("Error", message: "Failed to fetch organizations.", actions: nil)
            }
        )
    }
    
    private func prepareTextField() {
        let placeHolder = (presenter == .reports ?  "Search geofence community" : "Search your geofence community")
        searchTextField.attributedPlaceholder = attributedString(placeHolder: placeHolder)
        searchTextField.textColor = UIColor.blackTextColor()
        searchTextField.font = UIFont.circularStdBook(size: 13)
    }
    
    
    private func prepareTableView() {
        let nib = UINib(nibName: MyOrganizationsTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MyOrganizationsTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    
    @objc func addButtonAction() {
        if presenter == .reports {
            self.performSegue(withIdentifier: "unwindToReportDetailsTable", sender: nil)
        } else if visibleList[selectedIndex].who_can_join == "Private" {
            addPrivateOrganization()
        } else{
            addOrganization()
        }
    }
    
    private func attributedString(placeHolder: String) -> NSAttributedString {
        let font = UIFont.circularStdBook(size: 13)
        let placeholderColor = UIColor(hexString: "939393")
        let attributed = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: placeholderColor])
        return attributed
    }
}










// MARK: - UITableViewDataSource
extension SearchMyOrganizationViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if visibleList.count == 0 {return 0}
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyOrganizationsTableViewCell.identifier, for: indexPath) as! MyOrganizationsTableViewCell
        if presenter == .reports {
            cell.presenter = .reports
        } else {
            cell.presenter = nil
        }
        let organization = visibleList[indexPath.row]
        cell.organization = visibleList[indexPath.row]
        cell.moreButton.isHidden = true
        
        if indexPath.row == selectedIndex {
           cell.checkImageView.image = UIImage.init(named: "checked")
        }else{
            cell.checkImageView.image = UIImage.init(named: "check")
        }
        if cell.organization?.who_can_join == "Private" {
            cell.checkImageView.isHidden = true
        }else{
            cell.checkImageView.isHidden = false
        }
        cell.policeButton.isHidden = organization.dispatch == false
        cell.notificationButton.isHidden = organization.alert == false
        return cell
    }
}







// MARK: - UITableViewDelegate
extension SearchMyOrganizationViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if presenter == .reports {
            let cell = tableView.cellForRow(at: indexPath) as! MyOrganizationsTableViewCell
            cell.presenter = .reports
            let organization = self.visibleList[indexPath.row]
            if self.selectedOrganizations.contains(where: { (o) -> Bool in
                o.id == organization.id && organization.id != nil
            }) {
                cell.checkImageView.image = UIImage(named: "check")
                self.selectedOrganizations.removeAll { (o) -> Bool in
                    o.id == organization.id && organization.id != nil
                }
            } else {
                cell.checkImageView.image = UIImage.init(named: "checked")
                self.selectedOrganizations.append(organization)
            }
        } else {
            if list[indexPath.row].who_can_join == "Private" {
                addPrivateOrganization()
            }else{
                if selectedIndex == indexPath.row {selectedIndex = -1}else{selectedIndex = indexPath.row}
            }
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 36))
        headerView.backgroundColor = UIColor(hexString: "F4F4F4")
        
        // Handle contact name label
        let contactNameLabel = UILabel(frame: CGRect(x: 20,
                                                     y: 0,
                                                     width: tableView.frame.width - 40,
                                                     height: headerView.frame.height))
        //let sortedkeys = Array(filterOrganizationsDict.keys).sorted() { $0 < $1 }
        contactNameLabel.text = "Results"
        contactNameLabel.textColor = UIColor.mainColor()
        contactNameLabel.font = UIFont.circularStdMedium(size: 18)
        headerView.addSubview(contactNameLabel)
        
        return headerView
    }
}








// MARK: - IBActions
extension SearchMyOrganizationViewController {
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        
    }
    
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    
    
    @IBAction func showSearchButtonAction(_ sender: UIButton) {
        searchViewCenterXConstraint.isActive = false
        searchViewLeadingConstraint.isActive = true
        searchViewTrailingConstraint.isActive = true
        showSearchButton.isHidden = true
        searchTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}











// MARK:- Serach Organzation API
extension SearchMyOrganizationViewController:MenuAddContactDelegate {
    
    
    func serachOrganization() {
        
        guard self.presenter != .reports else {
            if let keywords = self.searchTextField.text?.trimmingCharacters(in: .whitespaces), keywords.count > 0 {
                self.visibleList = self.list.filter({
                    ($0.organization_name ?? "").lowercased().contains(keywords.lowercased())
                })
            } else {
                self.visibleList = self.list
            }
            self.selectedOrganizations = []
            self.tableView.reloadData()
            return
        }
        
        guard let keyword = self.searchTextField.text else {return}
        
        let url = BASE_URL + Constants.SEARCH_ORG
        SwiftLoader.show(title:"Please Wait...", animated: false)
        let param:[String:Any] = ["search_query":keyword]
        
        ApiManager.shared.GETApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                 print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                
                print(json)
                
                if code != 200 {
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                if let array = json.array {
                    
                    self.list = array.decode()
                    self.list.forEach({$0.updateDistance()})
                    self.list = self.list.sorted(by: {$0.distance < $1.distance})
                    
                    self.visibleList = self.list
                    self.tableView.reloadData()
                    self.emptyView.isHidden = self.visibleList.count > 0
                }
            }
        }
    }
    
    
    
    func addOrganization() {
        
        guard let id = visibleList[selectedIndex].id else {return}
        
        let url = BASE_URL + Constants.ADD_ORG
        
        SwiftLoader.show(title:"Adding...", animated: false)
        
        let param:[String:Any] = ["organization":id]
        
        ApiManager.shared.POSTApi(url, param: param, header: header()) { (respnse, error, statuCode) in
            
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                
                print(json)
                
                if code == 200 || code == 201{
                    self.clickOnBack()
                    self.delegate?.didfinish()
                    return
                }
                let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                showAlert(msg: msg, title: "Error", sender: self)
            }
        }
    }

    
    
    func addPrivateOrganization() {
        
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = true
        menuAddContactVC.isAddProCode = true
        menuAddContactVC.delegate = self
    
        present(menuAddContactVC, animated: false, completion: nil)
    }
    
    
    func didFinishAdding() {
        self.delegate?.didfinish()
        self.clickOnBack()
    }
    
    func didclickMenu(arrOrgan: Organization) {
        
    }
}






