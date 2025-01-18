//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit

protocol FeedRefreshViewControllerDelete {
    func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    @IBOutlet var view: UIRefreshControl?
    
    var delegate: FeedRefreshViewControllerDelete?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
    
}
