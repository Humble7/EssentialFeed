//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 9/1/25.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load() { _ in }
    }
    
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loaderSpy = LoaderSpy()
        _ = FeedViewController(loader: loaderSpy)
        
        XCTAssertEqual(loaderSpy.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loaderSpy = LoaderSpy()
        let sut = FeedViewController(loader: loaderSpy)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 1)
    }
    // MARKS: - Helpers
    
    class LoaderSpy: FeedLoader {

        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
