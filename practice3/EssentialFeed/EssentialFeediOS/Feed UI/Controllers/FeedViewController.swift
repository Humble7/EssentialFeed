//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by ChenZhen on 10/1/25.
//

import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]()
    private var tasks = [IndexPath: FeedImageDataLoaderTask]()
    
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        tableView.prefetchDataSource = self
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load { [weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = cellModel.location == nil
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        let loadImage = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            self.startTask(forRowAt: indexPath, cell: cell)
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
//    iOS 15 Update
//    On iOS 15+, the cell lifecycle behavior changed. For performance reasons, when the cell is removed from the table view and quickly added back (e.g., by
//    scrolling up and down fast), the data source may not recreate the cell anymore using the cellForRow method if there's a cached cell for
//    that IndexPath.
//    If there’s a cached cell for that IndexPath, it'll just call willDisplayCell to avoid recreating a cell that’s already cached. This is more performant.
//    However, we cancel requests on didEndDisplayingCell and only load them again if cellForRow is called. In this scenario, there's a possibility of
//    the cached cell becoming visible again and never displaying an image until cellForRow is called after scrolling the table up and down again.
//    So on iOS 15+, if we cancel any resource loading on didEndDisplayingCell, we must load/reload those resources on willDisplayCell.
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedImageCell, cell.feedImageView.image == nil else { return }
        startTask(forRowAt: indexPath, cell: cell)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = tableModel[indexPath.row]
            _ = imageLoader?.loadImageData(from: cellModel.url) { _ in }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelTask(forRowAt: indexPath)
        }
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
    
    private func startTask(forRowAt indexPath: IndexPath, cell: FeedImageCell) {
        let cellModel = tableModel[indexPath.row]
        tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { [weak cell] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            cell?.feedImageView.image = image
            cell?.feedImageRetryButton.isHidden = (image != nil)
            cell?.feedImageContainer.stopShimmering()
        }
    }
    
}
