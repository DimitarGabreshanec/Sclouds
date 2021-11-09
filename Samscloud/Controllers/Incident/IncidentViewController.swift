//
//  IncidentViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 @Auther : Irshad Ahmad
 @Class Description : Inciden List Class
 */
class IncidentViewController: UIViewController {
    
    // MARK:- IBOutlet
    /**
     @Auther : Irshad Ahmad
     @Description : IIBOutlet of Views
     */
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var noOngoingIncidentView: UIView!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var listDataContainerView: UIView!
    
    /**
     @Auther : Irshad Ahmad
     @Description : History Tab
     */
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    // MARK:- Global Variables
    /**
     @Auther : Irshad Ahmad
     @Description : Global Variables
     */
    var isIncidentHistory = false
    var ongoings = [OngoingIncidentModel]()
    var histories = [OngoingIncidentModel]()
    var selectedIndex:Int = 0
    
    deinit {
        print("⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎ deniniting IncidentViewController ⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎⚙︎")
    }
}









// MARK:- Life Cycle
/**
 @Auther : Irshad Ahmad
 @Description : Life Cycle
 */
extension IncidentViewController {
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        topTableViewConstraint.constant = -lineView.frame.maxY + 2.2
        prepareSegmentedControl()
        prepareTableView()
        loadCache()
        getOngoingIncident()
        getIncidentHistory()
        gridButton.isSelected = false
        
        title = "Incidents"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        self.tabBarController?.navigationItem.rightBarButtonItems = []
    }
    
    
    // MARK: - PRIVATE ACTIONS
    private func prepareSegmentedControl() {
        // SegmentControl for title
        let fontAttributeNormal = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.mainColor()]
        let fontAttributeSelected  = [NSAttributedString.Key.font: UIFont.circularStdMedium(size: 16),
                                      NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.removeBorder()
        segmentedControl.tintColor = UIColor.mainColor()
        segmentedControl.selectedSegmentIndex = isIncidentHistory ? 1 : 0
        segmentedControl.setTitleTextAttributes(fontAttributeNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(fontAttributeSelected, for: .selected)
        segmentedControl.selectedSegmentIndex = selectedIndex
        segmentContainerView.bordered(withColor: UIColor.mainColor(), width: 1, radius: 20)
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func showHideTableView() {
        listDataContainerView.isHidden = ongoings.count == 0
    }
    
    
}









// MARK:- IBActions
/**
 @Auther : Irshad Ahmad
 @Description : IBActions
 */
extension IncidentViewController {
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        print("SEGMENT CONTROLLER PRESSED - INCIDENT_VC")
        topTableViewConstraint.constant = sender.selectedSegmentIndex == 0 ? -lineView.frame.maxY + 2.2 : 3.2
        if sender.selectedSegmentIndex == 0 {
            showHideTableView()
        } else {
            listDataContainerView.isHidden = false
        }
        tableView.reloadData()
    }
    
    @IBAction func gridButtonAction(_ button: UIButton) {
        print("GRID BUTTON ACTION PRESSED - INCIDENT_VC")
        button.isSelected = !button.isSelected
        if button.isSelected {
            gridButton.setImage(UIImage(named: "listIcon")?.withRenderingMode(.alwaysTemplate), for: .selected)
            gridButton.tintColor = UIColor.mainColor()
            listButton.setImage(UIImage(named: "gridIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            listButton.tintColor = UIColor.black
        } else {
            gridButton.setImage(UIImage(named: "gridIcon")?.withRenderingMode(.alwaysOriginal), for: .selected)
            listButton.setImage(UIImage(named: "listIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        tableView.reloadData()
    }
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        print("LIST BUTTON PRESSED - INCIDENT_VC")
    }
}








/**
 @Auther : Irshad Ahmad
 @Description : API calls
 */
extension IncidentViewController {
    
    func loadCache() {
        if let json = UserDefaults.standard.getIncidentsCache() {
            if let array = json.array {
                self.ongoings = array.decode()
                self.tableView.reloadData()
                self.showHideTableView()
            }
        } else {
            SwiftLoader.show(title: "Loading...", animated: true)
        }
        if let jsonJistory = UserDefaults.standard.getIncidentsHistoryCache() {
            if let array = jsonJistory.array {
                self.histories = array.decode()
                self.tableView.reloadData()
                self.showHideTableView()
            }
        }
    }
    
    /**
     @Auther : Irshad Ahmad
     @Description : get ongoing incident list from server
     */
    func getOngoingIncident() {
        
        let url = ongoingIncidentUrl()
        
        APIsHandler.GETApi(url, param: nil, header: header()) { [weak self](response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 401 { // handle for refresh token
                    return
                }
                if let array = json.array {
                    UserDefaults.standard.setIncidentsCache(json)
                    self?.ongoings = array.decode()
                    self?.tableView.reloadData()
                    self?.showHideTableView()
                }
            }
        }
    }
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : get ongoing incident history from server
     */
    func getIncidentHistory() {
        
        let url = incidentHistoryUrl()
        
        APIsHandler.GETApi(url, param: nil, header: header()) { [weak self] (response, error, statusCode) in
            
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                if code == 401 { // handle for refresh token
                    return
                }
                if let array = json.array {
                    UserDefaults.standard.setIncidentsHistoryCache(json)
                    self?.histories = array.decode()
                    self?.tableView.reloadData()
                    self?.showHideTableView()
                }
            }
        }
    }
    
    
    /**
     @Auther : Irshad Ahmad
     @Description : delete an  incident history from server
     */
    func deleteIncident(indexPath:IndexPath) {
        
        guard let id = histories[indexPath.row].id else {return}
        let url = incidentDetailUrl(id: id)
        SwiftLoader.show(title: "Deleting...", animated: true)
        APIsHandler.DELETEApi(url, param: nil, header: header()) { [weak self] (response, error, statusCode) in
            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = response, let code = statusCode {
                print(json,code)
                
                if code == 401 { // handle for refresh token
                    return
                }
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.tableView.reloadData()
                })
                self?.tableView.beginUpdates()
                if (self?.histories.count ?? 0) > 0 {
                    self?.histories.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                self?.tableView.endUpdates()
                CATransaction.commit()
            }
        }
    }
}











// MARK: - TABLE VIEW
/**
 @Auther : Irshad Ahmad
 @Description : Tablview Delegate & Data Source
 */
extension IncidentViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {return ongoings.count}
        return histories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentOngoingTableViewCell", for: indexPath) as! IncidentOngoingTableViewCell
            cell.incident = ongoings[indexPath.row]
            cell.bottomView.isHidden = ongoings.count == 1 || indexPath.row == ongoings.count - 1
            return cell
        } else {
        
            let identifier = gridButton.isSelected ? IncidentHistoryTableViewCell.listIdentifier : IncidentHistoryTableViewCell.identifier
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! IncidentHistoryTableViewCell
            
            cell.bottomView.isHidden = histories.count == 1 || indexPath.row == histories.count - 1
            cell.incident = histories[indexPath.row]
            
            // Handle `delete` button
            cell.deleteButtonAction = { [weak self] in
                let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] alert in
                    self?.deleteIncident(indexPath: indexPath)
                })
                deleteAction.setValue(UIColor(hexString: "f53c3c"), forKey: "titleTextColor")
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                self?.showActionSheet(nil, message: nil, actions: [cancelAction, deleteAction])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentNC") as! UINavigationController
            ongoingIncidentVC.modalPresentationStyle = .fullScreen
            let vc = ongoingIncidentVC.viewControllers.first as? OngoingIncidentViewController
            vc?.incident = ongoings[indexPath.row]
            DispatchQueue.main.async {
                self.present(ongoingIncidentVC, animated: true, completion: nil)
            }
        } else {
            let incidentHistoryNC = StoryboardManager.contactStoryBoard().getController(identifier: "IncidentHistoryNC") as! UINavigationController
            incidentHistoryNC.modalPresentationStyle = .fullScreen
            
            let incidentHistoryVC = incidentHistoryNC.topViewController as! IncidentHistoryViewController
            incidentHistoryVC.incidentModel = histories[indexPath.row]
            
            incidentHistoryVC.moreButtonAction = { [weak self] in
                self?.getIncidentHistory()
            }
            DispatchQueue.main.async {
                self.present(incidentHistoryNC, animated: true, completion: nil)
            }
        }
    }
}
