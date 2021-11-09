//
//  ReportAttachment.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/28/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import AVKit

class ReportAttachment: NSObject, NSCoding {
    var reportID: Int
    var type: ReportAttachmentType
    var localURL: URL?
    var status: ReportAttachmentStatus
    var createdAt: Date
    
    init(reportID: Int = -1, type: ReportAttachmentType, status: ReportAttachmentStatus, localURL: URL) {
        self.reportID = reportID
        self.type = type
        self.localURL = localURL
        self.status = status
        self.createdAt = Date()
    }
    
    var thumbnail: UIImage {
        switch self.type {
        case .photo:
            if let url = self.localURL, let image = UIImage(contentsOfFile: url.path) {
                return image
            } else {
                return UIImage(named: "dummy")!
            }
        case .video:
            if let url = self.localURL, let image = AVAsset(url: url).thumbnail {
                return image
            } else {
                return UIImage(named: "dummy")!
            }
        default:
            return UIImage(named: "dummy")!
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.reportID, forKey: "reportID")
        coder.encode(self.type.rawValue, forKey: "type")
        coder.encode(self.localURL, forKey: "localURL")
        coder.encode(self.status.rawValue, forKey: "status")
        coder.encode(self.createdAt, forKey: "createdAt")
    }
    
    required init?(coder: NSCoder) {
        self.reportID = coder.decodeInteger(forKey: "reportID")
        self.localURL = coder.decodeObject(forKey: "localURL") as? URL
        self.createdAt = coder.decodeObject(forKey: "createdAt") as? Date ?? Date()
        
        self.type = .unknown
        if let type = coder.decodeObject(forKey: "type") as? String {
            if let type = ReportAttachmentType(rawValue: type) {
                self.type = type
            }
        }
        
        self.status = .delivered
        if let status = coder.decodeObject(forKey: "status") as? String {
            if let status = ReportAttachmentStatus(rawValue: status) {
                self.status = status
            }
        }
        super.init()
    }
}
