//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 1/1/25.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.validateCache()
        
        store.completeRetrieval(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteCacheOnLessThanSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let feed = uniqueImageFeed()
        let lessThanSevenDaysTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        
        sut.load { _ in }
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deleteCacheOnSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let feed = uniqueImageFeed()
        let sevenDaysTimestamp = fixedCurrentDate.adding(days: -7)
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_deleteCacheOnMoreThanSevenDaysOldCache() {
        let fixedCurrentDate = Date()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let feed = uniqueImageFeed()
        let moreThanSevenDaysTimestamp = fixedCurrentDate.adding(days: -7).adding(days: -1)
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    // MARK- Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
}
