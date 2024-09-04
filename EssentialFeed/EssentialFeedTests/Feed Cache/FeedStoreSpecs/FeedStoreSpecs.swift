//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 2/9/24.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliverEmptyOnEmptyCache()

    func test_retrieve_hasNoSideEffectsOnEmptyCache()

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()

    func test_retrieve_deliverFoundValuesOnNonEmptyCache()

    func test_insert_deliverNoErrorOnEmptyCache()

    func test_insert_deliverNoErrorOnNonEmptyCache()

    func test_insert_overridePreviouslyInsertedCacheValues()

    func test_delete_deliverNoErrorOnEmptyCache()
    
    func test_delete_hasNoSideEffectsOnEmptyCache()

    func test_delete_emptyPreviouslyInsertedCache()

    func test_delete_deliverNoErrorOnNonEmptyCache()

    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliverFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliverErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliverErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableFeedStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
