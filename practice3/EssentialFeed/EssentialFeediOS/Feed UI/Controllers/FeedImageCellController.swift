//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
    private let viewModel: FeedImageViewModel<UIImage>
    
    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }
    
    func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description

        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
        
        cell.onRetry = viewModel.loadImageData
        
        return cell
    }
    
    func preload() {
        viewModel.preload()
    }
    
    func cancelLoad() {
        viewModel.cancelLoad()
    }
}
