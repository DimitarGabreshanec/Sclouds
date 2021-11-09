//
//  AVAsset.swift
//  Samscloud
//
//  Created by Shahzeb Khan on 11/30/19.
//  Copyright © 2019 Subcodevs. All rights reserved.
//

import Foundation
import AVKit

extension AVAsset {
    var thumbnail: UIImage? {
        let assetImageGenerator = AVAssetImageGenerator(asset: self)

        var time = self.duration
        time.value = min(time.value, 2)

        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
}
