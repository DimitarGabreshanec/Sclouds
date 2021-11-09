//
//  ReportDetailsTableViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/10/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import CoreLocation
import AVKit
import QuickLook

class ReportDetailsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, QLPreviewControllerDataSource {
    var reportResponse: ReportResponse? = nil
    var location: CLLocation? = appDelegate.locManager.location
    var selectedReportType: ReportType?
    var selectedOrganizations: [OrganizationModel] = []
    var selectedOrganizationZone: OrganizationZone?
    var addressText: String = appDelegate.addressStr ?? "Failed to determine location."
    var descriptionText: String?
    var isAnonymous: Bool = false
    var attachments: [ReportAttachment] = []
    let imagePicker = UIImagePickerController()
    var selectedPhotoLocalURLForPreview: URL? = nil
    
    // MARK: - Lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if let report = self.reportResponse, (report.attachmentPaths?.count ?? 0) <= 0 {
            self.refreshReport()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshReport), name: Notification.Name.ReportAttachmentsUploadedSuccessfully, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Only refresh location if creating a new report
        if self.reportResponse == nil {
            self.refreshLocation()
        }
    }
    
    deinit {
        NSLog("~~~~ ReportDetailsTableViewController released")
    }
    
    @objc
    func refreshReport() {
        GetAllReportsService().getAllReports(
            success: { reports in
                self.reportResponse = reports.filter({ $0.id == (self.reportResponse?.id ?? -1) }).first
                
                // See if there are any local attachments that can be displayed
                if let response = self.reportResponse, let count = self.reportResponse?.attachmentPaths?.count, count <= 0 {
                    self.attachments = ReportAttachmentHelper().getReportAttachments(for: response)
                }
                
                self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .none)
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 2)], with: .none)
        },
            failure: { _ in
                // Do nothing
        }
        )
    }
    
    
    func refreshLocation() {
        guard let loc = self.location else {
            return
        }
        // SwiftLoader.show(animated: true)
        GetOrganizationZoneService().getOrganizationZone(
            location: loc,
            success: { [weak self] orgZone in
                self?.selectedOrganizationZone = orgZone
                guard let displayAddress = orgZone.displayAddress else {
                    getAddressFromLocation(loc: loc) { [weak self] (address) in
                        SwiftLoader.hide()
                        // Update address row
                        self?.addressText = address ?? "Unknown location"
                        self?.tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .fade)
                    }
                    return
                }
                // SwiftLoader.hide()
                self?.addressText = displayAddress
                self?.tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .fade)
            },
            failure: { error in
                getAddressFromLocation(loc: loc) { [weak self] (address) in
                    // SwiftLoader.hide()
                    // Update address row
                    self?.addressText = address ?? "Unknown location"
                    self?.tableView.reloadRows(at: [IndexPath(item: 2, section: 0)], with: .fade)
                }
        }
        )
    }
    
    func buildReport() -> Report? {
        guard let latitude = self.location?.coordinate.latitude, let longitude = self.location?.coordinate.longitude else {
            self.showAlertWithActions("Error", message: "Failed to determine location.", actions: nil)
            return nil
        }
        
        return Report(
            description: self.descriptionText,
            address: self.addressText,
            latitude: String(format: "%.6f", latitude),
            longitude: String(format: "%.6f", longitude),
            reportTypeID: self.selectedReportType?.id,
            organizations: self.selectedOrganizations.map{ $0.id ?? "" },
            zoneID: self.selectedOrganizationZone?.zoneID,
            zoneFloorID: self.selectedOrganizationZone?.zoneFloorID,
            isAnonymous: self.isAnonymous
        )
    }
    
    // MARK: - IBActions
    
    @IBAction func addAttachmentsTapped() {
        self.showAddAttachmentOptions()
    }
    
    @IBAction func goToMapPin() {
        if let _ = self.location {
            self.performSegue(withIdentifier: "goToMapPin", sender: nil)
        } else {
            self.showAlertWithActions("Error", message: "Failed to get location. Please try again later.", actions: nil)
        }
    }
    
    @IBAction func goToReportTypes() {
        self.performSegue(withIdentifier: "goToReportTypes", sender: nil)
    }
    
    @IBAction func goToReportDescription() {
        self.performSegue(withIdentifier: "goToReportDescription", sender: nil)
    }
    
    @IBAction func goToReportOrganizations() {
        let searchMyOrganizationVC = StoryboardManager.contactStoryBoard().getController(identifier: "SearchMyOrganizationVC") as! SearchMyOrganizationViewController
        searchMyOrganizationVC.presenter = .reports
        let navigationController = UINavigationController(rootViewController: searchMyOrganizationVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToReportDetailsTable(_ unwindSegue: UIStoryboardSegue) {
        if let mapPinController = unwindSegue.source as? MapPinViewController {
            self.location = mapPinController.location
            self.refreshLocation()
        }
        else if let reportTypesController = unwindSegue.source as? ReportTypesViewController {
            self.selectedReportType = reportTypesController.selectedReportType
            self.tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .fade)
        }
        else if let reportDescriptionController = unwindSegue.source as? ReportDescriptionViewController {
            self.descriptionText = reportDescriptionController.descriptionText
            self.tableView.reloadRows(at: [IndexPath(item: 4, section: 0)], with: .fade)
        }
        else if let searchOrganizationsController = unwindSegue.source as? SearchMyOrganizationViewController {
            self.selectedOrganizations.append(contentsOf: searchOrganizationsController.selectedOrganizations)
            self.tableView.reloadSections([1], with: .fade)
            self.tableView.reloadRows(at: [IndexPath(item: 4, section: 0)], with: .fade)
        }
    }
    
    @IBAction func isAnonymousChanged(sender: UISwitch) {
        self.isAnonymous = sender.isOn
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    private func showAddAttachmentOptions() {
        let menuAddContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuAddContactVC") as! MenuAddContactViewController
        menuAddContactVC.modalPresentationStyle = .overCurrentContext
        menuAddContactVC.isAddOrganization = false
        menuAddContactVC.isFromReport = true
        
        menuAddContactVC.addContactButtonAction = {
            // Add photo
            if self.attachments.filter({ $0.type == .photo }).count < 4 {
                self.selectAttachment(mediaType: "public.image", allowsEditing: false)
            } else {
                self.showAlertWithActions("Error", message: "You have already attached the maximum number of allowed photos.", actions: nil)
            }
        }
        menuAddContactVC.manuallyAddButtonAction = {
            // Add video
            if self.attachments.filter({ $0.type == .video }).count < 2 {
                self.selectAttachment(mediaType: "public.movie", allowsEditing: true)
            } else {
                self.showAlertWithActions("Error", message: "You have already attached the maximum number of allowed videos.", actions: nil)
            }
        }
        present(menuAddContactVC, animated: false, completion: nil)
    }
    
    func selectAttachment(mediaType: String, allowsEditing: Bool) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Select an option", preferredStyle: .actionSheet)
        
        // Cancel Action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
        }
        
        // Take Picture Action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Use Camera", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.presentImagePicker(sourceType: .camera, mediaType: mediaType, allowsEditing: allowsEditing)
            }
        }
        
        // Choose Picture Action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            self.presentImagePicker(sourceType: .photoLibrary, mediaType: mediaType, allowsEditing: allowsEditing)
        }
        
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.addAction(takePictureAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType, mediaType: String, allowsEditing: Bool) {
        self.imagePicker.allowsEditing = allowsEditing
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.imagePicker.mediaTypes = [mediaType]
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let url = NSURL.fileURL(withPath: NSTemporaryDirectory())
            let fileName = "\(NSUUID().uuidString).jpeg"
            if image.jpegData(compressionQuality: 0.2)?.save(path: url.path, fileName: fileName) ?? false {
                self.attachments.append(
                    ReportAttachment(
                        type: .photo,
                        status: .pending,
                        localURL: url.appendingPathComponent(fileName)
                    )
                )
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .fade)
                }
            }
        }
            
        else if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let asset = AVAsset(url: url)
            let duration = asset.duration
            let time = CMTimeGetSeconds(duration)
            
            guard time <= 120 else {
                self.showAlertWithActions("Error", message: "Video can't be more than 2 minutes long.", actions: nil)
                return
            }
            
            let data = try! Data(contentsOf: url)
            let fileSize = Double(data.count / 1048576) //Convert in to MB
            print("File size in MB: ", fileSize)
            
            SwiftLoader.show(title: "Compressing video", animated: true)
            
            let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
            self.compressVideo(inputURL: url, outputURL: compressedURL) { (exportSession) in
                guard let session = exportSession else {
                    return
                }
                
                switch session.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    guard let compressedData = try? Data(contentsOf: compressedURL) else {
                        return
                    }
                    print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                    
                    self.attachments.append(
                        ReportAttachment(
                            type: .video,
                            status: .pending,
                            localURL: compressedURL
                        )
                    )
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .fade)
                    }
                case .failed:
                    break
                case .cancelled:
                    break
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMapPin" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers.first as! MapPinViewController
            if let loc = location {
                destination.location = loc
            }
        }
        else if segue.identifier == "goToReportTypes" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers.first as! ReportTypesViewController
            destination.selectedReportType = self.selectedReportType
        }
        else if segue.identifier == "goToReportDescription" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers.first as! ReportDescriptionViewController
            destination.descriptionText = self.descriptionText
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // All static fields
            return 6
        case 1: // All organizations
            if let report = self.reportResponse {
                return report.organizations?.count ?? 0
            } else {
                return self.selectedOrganizations.count
            }
        case 2: // Send anonymously
            return 1
        default:
            return 6
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDateCell", for: indexPath) as! ReportDateCell
                if let report = self.reportResponse {
                    cell.dateLabel.text = report.createdAt?.toDate()?.presentableDateTime
                } else {
                    cell.dateLabel.text = Date().presentableDateTime
                }
                return cell
            case 1:
                if let report = self.reportResponse {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTypeReadOnlyCell", for: indexPath) as! ReportTypeReadOnlyCell
                    cell.typeLabel.text = report.reportType
                    cell.idLabel.text = report.maintenanceID
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTypeSelectionCell", for: indexPath) as! ReportTypeSelectionCell
                    cell.reportTypeLabel.text = self.selectedReportType?.name
                    return cell
                }
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportLocationCell", for: indexPath) as! ReportLocationCell
                if let report = self.reportResponse {
                    cell.addressLabel.text = report.address
                    cell.mapButton.isHidden = true
                } else {
                    cell.addressLabel.text = self.addressText
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportAttachmentsCell", for: indexPath) as! ReportAttachmentsCell
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, for: indexPath.row)
                if let report = self.reportResponse {
                    cell.addMediaButton.isHidden = true
                    if let count = report.attachmentPaths?.count, count > 0 {
                        cell.showCollectionView()
                    } else if self.attachments.count > 0 {
                        cell.showCollectionView()
                    } else {
                        cell.hideCollectionView()
                    }
                } else {
                    self.attachments.count > 0 ? cell.showCollectionView() : cell.hideCollectionView()
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDescriptionCell", for: indexPath) as! ReportDescriptionCell
                if let report = self.reportResponse {
                    cell.descriptionLabel.text = report.description
                    cell.addEditButton.isHidden = true
                } else {
                    cell.descriptionLabel.text = self.descriptionText
                    if let text = self.descriptionText, !text.isEmpty {
                        cell.addEditButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        cell.addEditButton.setTitle("Edit", for: .normal)
                        cell.addEditButton.setTitleColor(UIColor(named: "sc-electric-blue"), for: .normal)
                        cell.addEditButton.titleLabel?.font = UIFont(name: "CircularStd-Book", size: 16)
                        cell.addEditButton.setImage(nil, for: .normal)
                    } else {
                        cell.addEditButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                        cell.addEditButton.setTitle("Add Details", for: .normal)
                        cell.addEditButton.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                        cell.addEditButton.titleLabel?.font = UIFont(name: "CircularStd-Book", size: 14)
                        cell.addEditButton.setImage(UIImage(named: "add-small")!, for: .normal)
                    }
                }
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportOrganizationHeaderCell", for: indexPath) as! ReportOrganizationHeaderCell
                if let _ = self.reportResponse {
                    cell.addButton.isHidden = true
                    cell.titleLabel.text = "Sent To"
                } else {
                    cell.titleLabel.text = "Reporting To"
                }
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportOrganizationCell", for: indexPath) as! ReportOrganizationCell
            if let report = self.reportResponse, let organization = report.organizations?[indexPath.row] {
                cell.orgNameLabel.text = organization.name
                cell.orgAddressLabel.text = ""
                cell.removeButton.isHidden = true
                let placeholder = UIImage.init(named: "sams_logo")
                if let logo = organization.logo, logo != "" {
                    loadImage(logo, cell.orgImageView, activity: nil, defaultImage: placeholder)
                }
                cell.orgImageView.roundRadius()
            } else {
                let organization = self.selectedOrganizations[indexPath.row]
                cell.orgNameLabel.text = organization.organization_name
                cell.orgAddressLabel.text = organization.address
                cell.removeAction = { [weak self] in
                    // Make sure the correct indexPath is used by the closure
                    if let indexPath = tableView.indexPath(for: cell) {
                        self?.selectedOrganizations.remove(at: indexPath.row)
                        self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                cell.orgImageView.contentMode = .scaleAspectFill
                cell.orgImageView.clipsToBounds = true
                cell.orgImageView.roundRadius()
                let placeholder = UIImage.init(named: "sams_logo")
                cell.orgImageView.image = placeholder
                if let logo = organization.logo, logo != "" {
                    loadImage(logo, cell.orgImageView, activity: nil, defaultImage: placeholder)
                }
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
            return cell
        case 2:
            if let response = self.reportResponse {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportStatusCell", for: indexPath) as! ReportStatusCell
                cell.profileImageView.image = cell.profileImageView.image?.withRenderingMode(.alwaysTemplate)
                cell.profileImageView.tintColor = .darkGray
                cell.statusLabel.text = ReportAttachmentHelper().getStatus(for: response).rawValue.uppercased()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReportAnonymousCell", for: indexPath) as! ReportAnonymousCell
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let report = self.reportResponse {
            if let count = report.attachmentPaths?.count, count > 0 {
                return count
            } else {
                return self.attachments.count
            }
        } else {
            return self.attachments.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportAttachmentsCollectionCell", for: indexPath) as! ReportAttachmentsCollectionCell
        if let report = self.reportResponse {
            if let count = report.attachmentPaths?.count, count > 0 {
                let path = report.attachmentPaths?[indexPath.row]
                cell.thumbnailView.image = UIImage(named: "dummy")
                cell.removeButton.isHidden = true
                cell.showSpinner()
                
                DownloadReportAttachment().download(
                    fullPath: path,
                    progressCallback: { (totalBytesRead, totalBytesExpectedToRead) in
                        // Do nothing
                },
                    completionCallback: { localURL in
                        cell.hideSpinner()
                        if let url = localURL {
                            let type: ReportAttachmentType = url.isImage ? .photo : .video
                            let attachment = ReportAttachment(reportID: report.id ?? -1, type: type, status: .delivered, localURL: url)
                            cell.thumbnailView.image = attachment.thumbnail
                        }
                }
                )
            } else {
                let attachment = self.attachments[indexPath.row]
                cell.thumbnailView.image = attachment.thumbnail
                cell.removeButton.isHidden = true
                cell.hideSpinner()
            }
            return cell
        } else {
            let attachment = self.attachments[indexPath.row]
            cell.thumbnailView.image = attachment.thumbnail
            cell.removeButton.isHidden = false
            cell.hideSpinner()
            cell.removeAction = { [weak self] in
                // Make sure the correct indexPath is used by the closure
                if let indexPath = collectionView.indexPath(for: cell) {
                    self?.attachments.remove(at: indexPath.row)
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [indexPath])
                    }, completion: { _ in
                        self?.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .none)
                    })
                }
            }
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let report = self.reportResponse {
            if let attachments = report.attachmentPaths, attachments.count > 0  {
                if let localURL = FileManager.cachedFileURL(remotePath: attachments[indexPath.row]) {
                    self.preview(localURL: localURL)
                }
            } else {
                let attachment = self.attachments[indexPath.row]
                if let localURL = attachment.localURL {
                    self.preview(localURL: localURL)
                }
            }
        } else {
            let attachment = self.attachments[indexPath.row]
            if let localURL = attachment.localURL {
                self.preview(localURL: localURL)
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 124)
    }
    
    func preview(localURL: URL) {
        if localURL.isImage {
            self.previewPhoto(localURL: localURL)
        } else {
            self.previewVideo(localURL: localURL)
        }
    }
    
    func previewVideo(localURL: URL) {
        let player = AVPlayer(url: localURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    // MARK: - QLPreviewControllerDataSource
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.selectedPhotoLocalURLForPreview! as QLPreviewItem
    }
    
    func previewPhoto(localURL: URL) {
        self.selectedPhotoLocalURLForPreview = localURL
        let previewQL = QLPreviewController()
        previewQL.dataSource = self
        previewQL.currentPreviewItemIndex = 0
        self.present(previewQL, animated: true, completion: nil)
    }
}
