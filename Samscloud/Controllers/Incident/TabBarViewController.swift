//
//  TabBarViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/24/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var defaultIndex = 0
    var isPopToVC = false
    var isReport = false
    var isNotification = false
    var isIncidentHistory = false
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Attribute text
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularStdMedium(size: 11)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularStdMedium(size: 11)], for: .selected)
        self.tabBar.unselectedItemTintColor = UIColor.blackTextColor()
        // Display report tab
        if isReport {
            self.tabBar.items?[3].selectedImage = UIImage(named: "report")
            self.tabBar.items?[3].image = UIImage(named: "default-report")
            self.tabBar.items?[3].title = "Report"
            if let controllers = self.viewControllers {
                controllers.forEach { (vc) in
                    if vc is MyOrganizationsViewController {
                        let vc = vc as! MyOrganizationsViewController
                        vc.isReport = isReport
                        print("MyOrganizationsViewController")
                    }
                }
            }
        }
        if let controllers = self.viewControllers {
            controllers.forEach { (vc) in
                if let nav = vc as? UINavigationController {
                    if nav.visibleViewController is NotificationViewController{
                        let vc = nav.topViewController as! NotificationViewController
                        vc.isFromResponder = isNotification
                    }
                }
                if vc is IncidentViewController {
                    let incidentVC = vc as! IncidentViewController
                    incidentVC.isIncidentHistory = isIncidentHistory
                }
            }
        }
        // Set current viewController
        self.selectedIndex = defaultIndex
        if defaultIndex == 2 {
            title = "Incidents"
        } else if defaultIndex == 1 {
            title = "My Organizations"
             let str = "Add"
            let addButton = creatCustomBarButton(title: str)
                       addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
                       let addBarButtonItem = UIBarButtonItem(customView: addButton)
                       self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        } else if defaultIndex == 3 {
            title = isReport ? "Reports" : "My Organizations"
            var str = "Add"
            if isReport {str = "New"}
            let addButton = creatCustomBarButton(title: str)
            addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
            let addBarButtonItem = UIBarButtonItem(customView: addButton)
            self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        }
        prepareNavigation()
        navigationController?.isNavigationBarHidden = defaultIndex == 4
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidLoad()
//        self.delegate = self
//        // Attribute text
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularStdMedium(size: 11)], for: .normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.circularStdMedium(size: 11)], for: .selected)
//        self.tabBar.unselectedItemTintColor = UIColor.blackTextColor()
//        // Display report tab
//        if isReport {
//            self.tabBar.items?[3].selectedImage = UIImage(named: "report")
//            self.tabBar.items?[3].image = UIImage(named: "default-report")
//            self.tabBar.items?[3].title = "Report"
//            if let controllers = self.viewControllers {
//                controllers.forEach { (vc) in
//                    if vc is MyOrganizationsViewController {
//                        let vc = vc as! MyOrganizationsViewController
//                        vc.isReport = isReport
//                        print("MyOrganizationsViewController")
//                    }
//                }
//            }
//        }
//        if let controllers = self.viewControllers {
//            controllers.forEach { (vc) in
//                if let nav = vc as? UINavigationController {
//                    if nav.visibleViewController is NotificationViewController{
//                        let vc = nav.topViewController as! NotificationViewController
//                        vc.isFromResponder = isNotification
//                    }
//                }
//                if vc is IncidentViewController {
//                    let incidentVC = vc as! IncidentViewController
//                    incidentVC.isIncidentHistory = isIncidentHistory
//                }
//            }
//        }
//        // Set current viewController
//        self.selectedIndex = defaultIndex
//        if defaultIndex == 2 {
//            title = "Incidents"
//        } else if defaultIndex == 1 {
//            title = "My Organizations"
//        } else if defaultIndex == 3 {
//            title = isReport ? "Reports" : "My Organizations"
//            var str = "Add"
//            if isReport {str = "New"}
//            let addButton = creatCustomBarButton(title: str)
//            addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
//            let addBarButtonItem = UIBarButtonItem(customView: addButton)
//            self.navigationItem.rightBarButtonItems = [addBarButtonItem]
//        }
//        prepareNavigation()
//        navigationController?.isNavigationBarHidden = defaultIndex == 4
//    }
    @objc func addButtonAction() {
        if isReport {
            newReportButtonAction()
        }else{
           showAddOrganizationPage()
        }
    }
    
    @objc func newReportButtonAction() {
        let reportDetailVC = StoryboardManager.reportsStoryBoard().getController(identifier: "ReportDetailVC")
        self.navigationController?.pushViewController(reportDetailVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.currentVC = self
        // Set current viewController
        if isPopToVC {
            self.isPopToVC = false
            self.selectedIndex = defaultIndex
        }
        translucentNavigationBar()
    }
    
    
    // MARK: - PRIVATE ACTIONS
    
    private func prepareNavigation() {
        createBackBarButtonItem()
    }
    
    
    // MARK: - TAB_BAR_DELEGATE
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1 {
            AppState.setHomeVC()
        }
        else if viewController.tabBarItem.tag == 2 {
            title = "My Organizations"
        } else if viewController.tabBarItem.tag == 3 {
            title = "Incident"
        } else if viewController.tabBarItem.tag == 4 {
            title = isReport ? "Reports" : "Geo-Fences"
            if viewController is GeoFencesViewController {
                let reportVC = viewController as! GeoFencesViewController
                reportVC.isReport = isReport
                reportVC.showReportContainerView()
            }
        }
        // Show/hide navigation
        navigationController?.isNavigationBarHidden = viewController.tabBarItem.tag == 5
    }
    
    
    
}






extension TabBarViewController :SearchOrganizationDelegate,MenuAddContactDelegate{
    
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
        let vc = self.viewControllers?[3] as? MyOrganizationsViewController
        vc?.getOrganizationList()
        
        let vc1 = self.viewControllers?[1] as? MyOrganizationsViewController
               vc1?.getOrganizationList()
               
    }
    
    func didFinishAdding() {
        let vc = self.viewControllers?[3] as? MyOrganizationsViewController
        vc?.getOrganizationList()
        let vc1 = self.viewControllers?[1] as? MyOrganizationsViewController
               vc1?.getOrganizationList()
    }
    
    func didclickMenu(arrOrgan: Organization) {
        
    }
    
}
