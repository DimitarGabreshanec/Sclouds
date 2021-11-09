//
//  UploadReportAttachments.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/28/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class UploadReportAttachmentsService {
    let path = "reports/report-file-upload/"
    
    func upload(reportID: Int, attachments: [ReportAttachment], success: @escaping () -> (), failure: @escaping (String?) -> ()) {
        NetworkManager().upload(
            path: self.path,
            reportID: reportID,
            photos: ReportAttachmentHelper().extractURLs(attachments: attachments, type: .photo),
            videos: ReportAttachmentHelper().extractURLs(attachments: attachments, type: .video),
            headers: [ "Authorization": "Bearer \(DefaultManager().getToken() ?? "")" ],
            success: {
                success()
            },
            failure: { error in
                failure(error?.localizedDescription)
            }
        )
    }
}
