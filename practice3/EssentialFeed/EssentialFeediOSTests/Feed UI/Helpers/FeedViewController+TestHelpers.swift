//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit
import EssentialFeediOS

extension FeedViewController {
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func feedImageView(at index: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let indexPath = IndexPath(row: index, section: feedImagesSection)
        return dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    private var feedImagesSection: Int {
        return 0
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing ?? false
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            
            let fakeRefreshControl = FakeRefreshControl()
            refreshControl?.allTargets.forEach { target in
                refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                    fakeRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
                }
            }
            
            refreshControl = fakeRefreshControl
        }
        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}
