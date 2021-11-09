//
//  ReportAttachmentHelper.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/30/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class ReportAttachmentHelper {
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    // static let shared = ReportAttachmentHelper()
    
    func extractURLs(attachments: [ReportAttachment], type: ReportAttachmentType) -> [URL] {
        var urls: [URL] = []
        for a in attachments.filter({ $0.type == type }) {
            if let url = a.localURL {
                urls.append(url)
            }
        }
        return urls
    }
    
    func getReportAttachments(for report: ReportResponse) -> [ReportAttachment] {
        return UserDefaults()
                .getReportAttachments()
                .filter({ $0.reportID == report.id })
    }
    
    func getStatus(for report: ReportResponse) -> ReportAttachmentStatus {
        let pendingAttachmentsCount = UserDefaults()
                                        .getReportAttachments()
                                        .filter({ $0.reportID == report.id && $0.status == .pending })
                                        .count
        let failedAttachmentsCount = UserDefaults()
                                        .getReportAttachments()
                                        .filter({ $0.reportID == report.id && $0.status == .failed })
                                        .count
        
        if failedAttachmentsCount > 0 {
            return .failed
        } else if pendingAttachmentsCount > 0 {
            return .pending
        } else {
            return .delivered
        }
    }
    
    func moveToPermanentStorageAndUpload(reportID: Int, attachments: [ReportAttachment]) {
        self.registerBackgroundTask()
        
        let attachments: [ReportAttachment] = attachments.map{
            $0.reportID = reportID
            return $0
        }
        
        /* Move all files to documents folder */
        for a in attachments {
            do {
                if let sourceURL = a.localURL {
                    let documentsDirectoryURL = URL(fileURLWithPath: FileManager.documentsPath)
                    let destinationURL = documentsDirectoryURL.appendingPathComponent(sourceURL.lastPathComponent)
                    try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
                    a.localURL = destinationURL
                }
            } catch let error{
                print(error)
            }
        }
        
        /* Update report attachments records user defaults */
        UserDefaults().setReportAttachments(
            UserDefaults().getReportAttachments() + attachments
        )
        
        /* Upload attachments */
        UploadReportAttachmentsService().upload(
            reportID: reportID,
            attachments: attachments,
            success: {
                NSLog("~~~ Files uploaded successfully!")
                UserDefaults().setReportAttachments(
                    UserDefaults().getReportAttachments().filter({ $0.reportID != reportID })
                )
                attachments.forEach({
                    if let url = $0.localURL {
                        try? FileManager.default.removeItem(at: url)
                    }
                })
                NotificationCenter.default.post(name: Notification.Name.ReportAttachmentsUploadedSuccessfully, object: nil)
                self.endBackgroundTask()
            },
            failure: { error in
                NSLog("~~~ Some files failed to upload!")
                attachments.forEach({
                    $0.status = .failed
                })
                UserDefaults().setReportAttachments(
                    UserDefaults().getReportAttachments().filter({ $0.reportID != reportID }) + attachments
                )
                self.endBackgroundTask()
            }
        )
    }
    
    deinit {
        NSLog("~~~~ ReportAttachmentHelper released")
    }
    
    private func registerBackgroundTask() {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(self.backgroundTask != .invalid)
    }
      
    private func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = .invalid
    }
}
