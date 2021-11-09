//
//  DispatchHomeViewController.swift
//  Samscloud
//
//  Created by An Phan on 2/20/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class DispatchHomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var arrowRightImageView: UIImageView!
    @IBOutlet weak var myRoutesButton: UIButton!
    @IBOutlet weak var idButton: UIButton!
    @IBOutlet weak var escalateButton: UIButton!
    @IBOutlet weak var engageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var incidentImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var activeResponderLabel: UILabel!
    @IBOutlet weak var dispatchHomeSwitch: UISwitch!
    @IBOutlet weak var runScenarioButton: UIButton!
    @IBOutlet weak var emergencyMSGButton: UIButton!
    @IBOutlet weak var shadownView: UIView!
    @IBOutlet weak var actionListContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chirpButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var isPopToArView = false
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove border line of navigationController
        navigationController?.navigationBar.shadowImage = UIImage()
        
        prepareNavigation()
        prepareShadowView()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                        height: chirpButton.frame.maxY + 4)
        contentViewHeightConstraint.constant = chirpButton.frame.maxY + 4
        
        // Show home chirp page
        if isPopToArView {
            isPopToArView = false
            
            performSegue(withIdentifier: "presentHomeChirpSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEmergencyReponseSegue" {
            let vc = segue.destination as! DispatchEmergencyResponseViewController
            
            // Handle `View` button
            vc.viewButtonAction = {
                self.performSegue(withIdentifier: "showIncidentDetailSegue", sender: nil)
            }
            
            // Handle `accept` button
            vc.acceptButtonAction = {
                let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentVC") as! OngoingIncidentViewController
                ongoingIncidentVC.isDispatchHome = true
                
                self.navigationController?.pushViewController(ongoingIncidentVC, animated: false)
            }
        }
        else if segue.identifier == "presentHomeChirpSegue" {
            let vc = segue.destination as! DispatchHomeChirpViewController
            
            // Handle `my groups` button
            // Open chirp groups page
            vc.myGroupsButtonAction = {
                let geoFencesVC = StoryboardManager.contactStoryBoard().getController(identifier: "GeoFencesVC") as! GeoFencesViewController
                geoFencesVC.isDispatchHomeChirp = true
                
                self.navigationController?.pushViewController(geoFencesVC, animated: true)
            }
            
            // Handle `add` button
            vc.addButtonAction = {
                let newMessageVC = StoryboardManager.contactStoryBoard().getController(identifier: "NewMessageVC") as! NewMessageViewController
                newMessageVC.isAddButtonHomeChirp = true
                
                self.navigationController?.pushViewController(newMessageVC, animated: true)
            }
        }
    }
    
    // MARK: - Methods
    
    @objc func notificationButtonAction() {
        showNotificationPage()
    }
    
    @objc func settingsButtonAction() {
        performSegue(withIdentifier: "showEmergencyReponseSegue", sender: nil)
    }
    
    // MARK: - Private methods
    
    private func prepareNavigation() {
        navigationItem.hidesBackButton = true
        
        let logo = UIImageView(frame: CGRect(x: 3, y: 0, width: 160, height: 36))
        logo.clipsToBounds = false
        logo.image = UIImage(named: "home-logo")
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 41))
        view.clipsToBounds = false
        view.addSubview(logo)
        
        // Set left navigationItem
        let logoBarButtonItem = UIBarButtonItem(customView: view)
        navigationItem.leftBarButtonItems = [logoBarButtonItem]
        
        // Set right navigationItem
        let notificationBarButtonItem = UIBarButtonItem(image: UIImage(named: "homeNotification"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(notificationButtonAction))
        notificationBarButtonItem.imageInsets.top = -5
        
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(settingsButtonAction))
        menuBarButtonItem.imageInsets.top = -5
        navigationItem.rightBarButtonItems = [menuBarButtonItem, notificationBarButtonItem]
    }
    
    private func prepareShadowView() {
        actionListContainerView.layer.applySketchShadow(color: UIColor.black, alpha: 0.25, x: 0, y: 2, blur: 4, spread: 0)
    }
    
    private func prepareView() {
        runScenarioButton.roundRadius()
        emergencyMSGButton.roundRadius()
        runScenarioButton.bordered(withColor: UIColor.mainColor(), width: 1)
        emergencyMSGButton.bordered(withColor: UIColor.mainColor(), width: 1)
        arrowRightImageView.tintColor = .white
        arrowRightImageView.image = UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate)
        tableView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        incidentImageView.image = UIImage(named: "firstAid")?.withRenderingMode(.alwaysTemplate)
        incidentImageView.tintColor = UIColor.mainColor()
    }
    
    private func showTabBar(defaultIndex: Int) {
        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = defaultIndex
        
        navigationController?.pushViewController(mainTabBarVC, animated: true)
    }
    
    private func showNotificationPage() {
        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = 4
        mainTabBarVC.isNotification = true
        
        self.navigationController?.pushViewController(mainTabBarVC, animated: true)
    }
    
    // MARK: - IBActions

    @IBAction func myRoutesButtonAction(_ sender: UIButton) {
        // Push from storyBoard
    }
    
    @IBAction func idButtonAction(_ sender: UIButton) {
        let facialRecognitionVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "FacialRecognitionVC") as! FacialRecognitionViewController
        facialRecognitionVC.isFromHome = true
        
        navigationController?.pushViewController(facialRecognitionVC, animated: true)
    }
    
    @IBAction func escalateButtonAction(_ sender: UIButton) {
        let dispatchSOSResponderVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchSOSResponderVC") as! DispatchSOSResponderViewController
        
        navigationController?.pushViewController(dispatchSOSResponderVC, animated: true)
    }
    
    @IBAction func engageButtonAction(_ sender: UIButton) {
        let engageStartVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "EngageStartVC") as! EngageStartViewController
        
        navigationController?.pushViewController(engageStartVC, animated: true)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
    
    @IBAction func runscenarioButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func emergencyMsgButtonAction(_ sender: UIButton) {
        let dispatchCreateMessageVC = StoryboardManager.dispatchStoryBoard().getController(identifier: "DispatchCreateMessageVC") as! DispatchCreateMessageViewController
        
        navigationController?.pushViewController(dispatchCreateMessageVC, animated: true)
    }
    
    @IBAction func incidentsButtonAction(_ sender: UIButton) {
        // Show incident page
        showTabBar(defaultIndex: 2)
    }
    
    @IBAction func reportsButtonAction(_ sender: UIButton) {
        // Show report page
        let mainTabBarVC = StoryboardManager.contactStoryBoard().getController(identifier: "MainTabBarVC") as! TabBarViewController
        mainTabBarVC.defaultIndex = 3
        mainTabBarVC.isReport = true
        
        navigationController?.pushViewController(mainTabBarVC, animated: true)
    }
    
    @IBAction func teamButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showTeamContactSegue", sender: nil)
    }
    
    @IBAction func messagesButtonAction(_ sender: UIButton) {
        showTabBar(defaultIndex: 1)
    }
    
    @IBAction func chirpButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "presentHomeChirpSegue", sender: nil)
    }
}

// MARK: - UITableViewDataSource

extension DispatchHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DispatchHomeTableViewCell.notificationIdentifier, for: indexPath) as! DispatchHomeTableViewCell
            cell.prepareNotificationCell()
            cell.liveButton.isHidden = indexPath.row == 1
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DispatchHomeTableViewCell.teamIdentifier, for: indexPath) as! DispatchHomeTableViewCell
            cell.prepareTeamCell()
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension DispatchHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: DispatchHomeView = DispatchHomeView.fromNib()
        headerView.titleLabel.text = section == 0 ? "NOTIFICATIONS" : "TEAM"
        headerView.backgroundColor = UIColor(hexString: "F4F4F4")
        
        // Handle `more` button of Notification
        headerView.moreButtonAction = {
            if section == 0 {
                self.showNotificationPage()
            }
            else {
                self.performSegue(withIdentifier: "showTeamContactSegue", sender: nil)
            }
        }
        
        return headerView
    }
}
