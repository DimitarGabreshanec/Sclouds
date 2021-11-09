//
//  DownloadReportAttachment.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 12/8/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation

class DownloadReportAttachment {
    func download(fullPath: String?, progressCallback: @escaping (Int64, Int64) -> Void, completionCallback: @escaping (URL?) -> Void) {
        guard let fullPath = fullPath else {
            completionCallback(nil)
            return
        }
        guard let url = FileManager.cachedFileURL(remotePath: fullPath) else {
            NetworkManager().download(
                fullPath,
                progressCallback: { (totalBytesRead, totalBytesExpectedToRead) in
                    progressCallback(totalBytesRead, totalBytesExpectedToRead)
                },
                completionCallback: { localURL in
                    completionCallback(localURL)
                }
            )
            return
        }
        completionCallback(url)
    }
}
