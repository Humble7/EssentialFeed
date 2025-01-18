//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    lazy var view: UIRefreshControl = loadView()
    
    private let loadFeed: () -> Void
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
}
