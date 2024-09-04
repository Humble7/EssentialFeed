//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 3/9/24.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliverEmptyOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveDeliverEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_retrieve_deliverFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    func test_insert_deliverNoErrorOnEmptyCache() {
        let sut = makeSUT()
        assertThatInsertDeliverNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_deliverNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridePreviouslyInsertedCacheValues() {
        
    }
    
    func test_delete_deliverNoErrorOnEmptyCache() {
        
    }
    
    func test_delete_emptyPreviouslyInsertedCache() {
        
    }
    
    func test_delete_deliverNoErrorOnNonEmptyCache() {
        
    }
    
    func test_storeSideEffects_runSerially() {
        
    }
    
    // - MARK: Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
