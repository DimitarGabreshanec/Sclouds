//
//  NotificationViewController.swift
//  Samscloud
//
//  Created by An Phan on 1/25/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationViewController: BaseViewController, UITextViewDelegate {
    
    var isFromResponder = false
    
    @IBOutlet weak var noNotificationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - INIT
    
    var notifications = [NotificationListModel]()
    var limit:Int32 = 20
    var nextUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        
        prepareTableView()
        loadCache()
        getNotificationList(isPagination: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.cameraStop = false
        navigationController?.navigationBar.shadowImage = UIImage()
        prepareNavigation()
    }
    
    
    // MARK: - ACTIONS
    
    @objc func notificationButtonAction() {
        let notificationeAction = UIAlertAction(title: "Notification Settings", style: .default, handler: { alert in
            let notificationSettingsVC = StoryboardManager.menuStoryBoard().getController(identifier: "NotificationSettingsVC")
            self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(hexString: "f53c3c"), forKey: "titleTextColor")
        self.showActionSheet(nil, message: nil, actions: [cancelAction, notificationeAction])
    }
    
    @objc func closeButtonAction() {
        if isFromResponder {
            self.tabBarController?.navigationController?.popViewController(animated: false)
        } else {
            AppState.setHomeVC()
        }
    }
    
    @IBAction func clickOnViewIncident(_ sender: UIButton) {
        
        let noti = notifications[sender.tag]
        let incidentHistoryNC = StoryboardManager.contactStoryBoard().getController(identifier: "IncidentHistoryNC") as! UINavigationController
        incidentHistoryNC.modalPresentationStyle = .fullScreen
        
        let incidentHistoryVC = incidentHistoryNC.topViewController as! IncidentHistoryViewController
        incidentHistoryVC.incidentModel = noti.ended_incident_details
        //incidentHistoryVC.incident_id = noti.ended_incident_details?.incident_id
        self.present(incidentHistoryNC, animated: true, completion: nil)
        
    }
    
    // MARK: - PRIVATE ACTIONS
    
    private func fetchNotification() -> [String]{
        return ["1", "2", "3", "4", "5", "6"]
    }
    
    internal override func prepareNavigation() {
        navigationItem.hidesBackButton = true
        // Add barButtonItem for rightBarButton
        let notificationButton = UIButton()
        notificationButton.setImage(UIImage(named: "notificationSettings"), for: .normal)
        notificationButton.tintColor = UIColor.mainColor()
        notificationButton.addTarget(self, action: #selector(notificationButtonAction), for: .touchUpInside)
        let notificationBarButtonItem = UIBarButtonItem(customView: notificationButton)
        navigationItem.rightBarButtonItems = [notificationBarButtonItem]
        // Add barButtonItem for leftBarButton
        let closeButton = creatCustomBarButton(title: "Close")
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        let closeBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    private func prepareTableView() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func showAlert(indexPath: IndexPath) {
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { alert in
            CATransaction.begin()
            CATransaction.setCompletionBlock({ [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tableView.reloadData()
            })
            self.tableView.beginUpdates()
            if self.notifications.count > 0 {
                self.notifications.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .top)
            }
            self.tableView.endUpdates()
            CATransaction.commit()
        })
        deleteAction.setValue(UIColor(hexString: "ff3b30"), forKey: "titleTextColor")
        let viewAction = UIAlertAction(title: "View", style: .default, handler: { alert in
            // Doing something
        })
        let muteAction = UIAlertAction(title: "Mute", style: .default, handler: { alert in
            // Doing something
        })
        let unsubscribeAction = UIAlertAction(title: "Unsubscribe", style: .default, handler: { alert in
            // Doing something
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.showActionSheet("Home Depot",
                             message: nil,
                             actions: [cancelAction, viewAction, muteAction, unsubscribeAction, deleteAction])
    }
    
    
    
    // MARK: - TEXT_VIEW_DELEGATE
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "RequestCheckin" {
            print("Request Check in")
            return true
        } else if URL.absoluteString == "Respond" {
            print("Respond")
            return true
        }
        return false
    }
    
    
    
    
    
}








// MARK:- UITableView
extension NotificationViewController:UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let notification = notifications[indexPath.row]
        
        if notification.notification_type == "accept_contact" || notification.notification_type == "request-check-in"{
            return 118
        }else if notification.notification_type == "incident_ended" {
            return 75
        } else if notification.notification_type == "responder_alert" || notification.notification_type == "emergency_contact_response" || notification.notification_type == "contact-location-update" {
            return 70
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        let defaultImg = UIImage.init(named: "userAvatar")
        
        if notification.notification_type == "accept_contact" {
            let cell = tableView.dequeueReusableCell(withIdentifier: AcceptUserNotificationTableViewCell.identifier, for: indexPath) as! AcceptUserNotificationTableViewCell
            if let image = notification.contact_requested_user?.profile_logo {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            cell.userImageView.roundRadius()
            cell.arrowImageView.isHidden = true
            cell.userNameLabel.text = notification.contact_requested_user?.fullName()
            cell.addressLabel.text = "is requesting to add you as contact"
            cell.relationshipLabel.text = "Contact"
            let info:[AnyHashable:Any] = ["token":notification.contact_uuid ?? ""]
            
            cell.acceptButtonAction = { () in
                appDelegate.acceptRejectContact("Accepted", info: info) {
                    self.deleteNotification(id: notification.id ?? "", showLoader: false)
                }
            }
            
            cell.declineButtonAction = { () in
                appDelegate.acceptRejectContact("Rejected", info: info) {
                    self.deleteNotification(id: notification.id ?? "", showLoader: false)
                }
            }
            
            return cell
        }else if notification.notification_type == "incident_ended" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell2", for: indexPath) as! NotificationTableViewCell
            cell.textView.delegate = self
            
            let name = notification.user_ended_incident?.first_name ?? ""
            let dateStr = notification.date_created ?? ""
            
            cell.textView.text = "\(name) has ended an incident."
            cell.descLabel?.text = notification.ended_incident_details?.ending_message
            if let image = notification.user_ended_incident?.profile_logo {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            
            let agoTime = dateStr.syncDate()?.getElapsedInterval()
            cell.timeAgoLabel.text = agoTime
            cell.viewButton?.tag = indexPath.row
            
            return cell
        }else if notification.notification_type == "responder_alert" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell1", for: indexPath) as! NotificationTableViewCell
            cell.textView.delegate = self
            
            let incident = notification.start_incident_details
            let name = incident?.user?.first_name ?? ""
            let dateStr = notification.date_created ?? ""
            
            cell.textView.text = "\(name) is reporting an incident."
            cell.descLabel?.text = notification.start_incident_details?.emergency_message
            
            if let image = notification.start_incident_details?.user?.profile_logo {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            
            let agoTime = dateStr.syncDate()?.getElapsedInterval()
            cell.timeAgoLabel.text = agoTime
            cell.viewButton?.tag = indexPath.row
            
            if incident?.is_stopped == true || incident?.is_ended == true {
                cell.liveImageView?.isHidden = true
            }else{
                cell.liveImageView?.isHidden = false
            }
            
            return cell
        }else if notification.notification_type == "request-check-in" {
            let cell = tableView.dequeueReusableCell(withIdentifier: AcceptUserNotificationTableViewCell.identifier, for: indexPath) as! AcceptUserNotificationTableViewCell
            
            if let image = notification.emergency_contact_details?.user?.profile_logo {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            cell.userImageView.roundRadius()
            cell.arrowImageView.isHidden = true
            cell.userNameLabel.text = notification.user_request_checkin?.fullName()
            cell.addressLabel.text = "is requested for check-in."
            cell.relationshipLabel.text = "Contact"
            let info:[AnyHashable:Any] = ["contact":notification.emergency_contact_details?.id ?? ""]
            
            cell.acceptButtonAction = { () in
                appDelegate.acceptRejectRequestCheckin("Accepted", info: info) {
                    self.deleteNotification(id: notification.id ?? "", showLoader: false)
                }
            }
            
            cell.declineButtonAction = { () in
                appDelegate.acceptRejectRequestCheckin("Rejected", info: info) {
                    self.deleteNotification(id: notification.id ?? "", showLoader: false)
                }
            }
            
            return cell
        }else if notification.notification_type == "emergency_contact_response" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell1", for: indexPath) as! NotificationTableViewCell
            cell.textView.delegate = self
            
            let incident = notification.start_incident_details
            let name = notification.contact_requested_user1?.name ?? ""
            let dateStr = notification.date_created ?? ""
            
            if let image = notification.contact_requested_user1?.profile_image, image != "" {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            
            cell.textView.text = notification.message
            cell.descLabel?.text = notification.ended_incident_details?.emergency_message
            
            let agoTime = dateStr.syncDate()?.getElapsedInterval()
            cell.timeAgoLabel.text = agoTime
            cell.viewButton?.tag = indexPath.row
            cell.liveImageView?.isHidden = true
            return cell
        }else if notification.notification_type == "contact-location-update" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell1", for: indexPath) as! NotificationTableViewCell
            cell.textView.delegate = self
            
            let name = notification.location_updated_user?.first_name ?? ""
            let dateStr = notification.date_created ?? ""
            
            if let image = notification.location_updated_user?.profile_logo {
                if image != "" {
                    loadImage(image, cell.userImageView, activity: nil, defaultImage: defaultImg)
                }else{
                    cell.userImageView.image = defaultImg
                }
            }else{
                cell.userImageView.image = defaultImg
            }
            
            cell.textView.text = "\(name)"
            cell.descLabel?.text = "is accepted your check-in request"
            
            let agoTime = dateStr.syncDate()?.getElapsedInterval()
            cell.timeAgoLabel.text = agoTime
            cell.viewButton?.tag = indexPath.row
            cell.liveImageView?.isHidden = true
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete tapped....")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                completionHandler(true)
                
                let noti = self.notifications[indexPath.row]
                self.deleteNotification(id: noti.id ?? "", showLoader: true)
                
            }
            if #available(iOS 13.0, *) {
                deleteAction.image = UIImage(systemName: "trash")
            } else {
                deleteAction.image = UIImage.init(named: "delete")
            }
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        if notification.notification_type == "responder_alert" {
            let ongoingIncidentVC = StoryboardManager.contactStoryBoard().getController(identifier: "OngoingIncidentNC") as! UINavigationController
            ongoingIncidentVC.modalPresentationStyle = .fullScreen
            let vc = ongoingIncidentVC.viewControllers.first as? OngoingIncidentViewController
            vc?.incident = notification.start_incident_details
            self.present(ongoingIncidentVC, animated: true, completion: nil)
        }else if notification.notification_type == "incident_ended" {
            
        }else if notification.notification_type == "incident_ended" {
            
        }
    }
    
}









// MARK:- APIs
extension NotificationViewController {
    
    
    func getNotificationList(isPagination:Bool) {
        
        var url = BASE_URL + Constants.NOTIFICATIONS + "?limit=\(limit)&offset=\(notifications.count)"
        
        if isPagination, nextUrl != "", nextUrl != nil{
            url = nextUrl!
        }
        
//        SwiftLoader.show(title:"Loading...", animated: false)
        
        ApiManager.shared.GETApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            
//            SwiftLoader.hide()
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["non_field_errors"].array?.first?.stringValue ?? ""
                    Samscloud.showAlert(msg: msg, title: "Error", sender: self)
                    return
                }
                self.processNotifications(json)
                UserDefaults.standard.setNotificationsCache(json)
            }
        }
    }
    
    func processNotifications(_ json: JSON) {
        self.nextUrl = json["next"].string
        guard let array = json["results"].array else {return}
        // Pagination is not used in code
//        if isPagination {
//            let list:[NotificationListModel] = array.decode()
//            self.notifications.append(contentsOf: list)
//        }else{
            self.notifications = array.decode()
//        }
        self.tableView.reloadData()
        self.tableView.isHidden = self.notifications.count == 0
    }
    
    func loadCache() {
        if let json = UserDefaults.standard.getNotificationsCache() {
            self.processNotifications(json)
        }
    }
    
    
    func deleteNotification(id:String, showLoader:Bool) {
        
        let url = deleteNotificationURL(id: id)
        if showLoader { SwiftLoader.show(title:"Deleting...", animated: false) }
        
        ApiManager.shared.DELETEApi(url, param: nil, header: header()) { (respnse, error, statuCode) in
            if showLoader {
                SwiftLoader.hide()
            }
            if let err = error {
                print(err.localizedDescription)
            }else if let json = respnse, let code =  statuCode{
                print(json)
                if code != 200{
                    let msg = json["message"].string ?? ""
                    Samscloud.showAlert(msg: msg, title: "Error", sender: self)
                    return
                }else if code == 200 {
                    if let index = self.notifications.firstIndex(where: {$0.id == id}) {
                        self.notifications.remove(at: index)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}
