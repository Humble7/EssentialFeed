//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
    
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
    
    var isShowingRetryAction: Bool {
        !feedImageRetryButton.isHidden
    }
    
    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var isShowingLocation: Bool {
        !locationContainer.isHidden
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
}

