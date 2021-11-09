//
//  ReportDetailsContainerViewController.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/10/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import UIKit
import AVKit

class ReportDetailsContainerViewController: UIViewController {
    @IBOutlet var submitCancelView: UIView!
    @IBOutlet var submitCancelViewHeightConstraint: NSLayoutConstraint!
    var reportDetailsTableViewController: ReportDetailsTableViewController!
    var report: ReportResponse? = nil
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let report = self.report {
            if ReportAttachmentHelper().getStatus(for: report) == .failed {
                let resubmitAction = UIAlertAction(title: "Retry", style: .default, handler: { alertAction in
                    ReportAttachmentHelper().moveToPermanentStorageAndUpload(
                        reportID: report.id ?? -1,
                        attachments: ReportAttachmentHelper().getReportAttachments(for: report)
                    )
                    self.navigationController?.popViewController(animated: true)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { alertAction in })
                self.showAlertWithActions("Error", message: "Some media failed to upload. Please try again.", actions: [cancelAction, resubmitAction])
            }
        }
    }
    
    func setupView() {
        self.title = "Report Details"
        self.createBackBarButtonItem()
        self.submitCancelView.layer.cornerRadius = 20
        self.submitCancelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if self.report == nil {
            self.showSubmitCancelView()
        } else {
            self.hideSubmitCancelView()
        }
    }
    
    func showSubmitCancelView() {
        self.submitCancelView.isHidden = false
        self.submitCancelViewHeightConstraint.constant = 105
    }
    
    func hideSubmitCancelView() {
        self.submitCancelView.isHidden = true
        self.submitCancelViewHeightConstraint.constant = 0
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitTapped() {
        if let report = self.reportDetailsTableViewController.buildReport(), report.isValid {
           self.submit(report: report)
        } else {
            self.showAlertWithActions(
                "Error",
                message: "All fields are required, except photos/videos.",
                actions: nil
            )
        }
    }
    
    func submit(report: Report) {
        SwiftLoader.show(animated: true)
        SubmitReportService().submitReport(
            report: report,
            success: { reportResponse in
                SwiftLoader.hide()
                ReportAttachmentHelper().moveToPermanentStorageAndUpload(
                    reportID: reportResponse.id ?? -1,
                    attachments: self.reportDetailsTableViewController.attachments
                )
                self.navigationController?.popViewController(animated: true)
            },
            failure: { error in
                print(error ?? "nil")
                SwiftLoader.hide()
                self.showAlertWithActions("Error", message: "Oops! Something went wrong.", actions: nil)
            }
        )
    }
    
    func uploadAttachments(reportID: Int, attachments: [ReportAttachment]) {
        UploadReportAttachmentsService().upload(
            reportID: reportID,
            attachments: attachments,
            success: {
                SwiftLoader.hide()
                self.navigationController?.popViewController(animated: true)
                // TODO: Do something
            },
            failure: { error in
                SwiftLoader.hide()
                self.showAlertWithActions("Error", message: "Some attachments failed to upload. Please try again.", actions: nil)
                // TODO: Do something
            }
        )
    }
    
    deinit {
        NSLog("~~~~ ReportDetailsContainerViewController released")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let reportDetailsTableVC as ReportDetailsTableViewController:
            reportDetailsTableVC.reportResponse = self.report
            self.reportDetailsTableViewController = reportDetailsTableVC
        default:
            break
        }
    }

}
