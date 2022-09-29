// SwiftyLiveApi
// ↳ LALogbookPage.swift
//
// Created by:
// Alexander Nikitin - @sqeezelemon

import Foundation

/// A page from the logbook.
public struct LALogbookPage<T: Decodable>: Decodable {
    public init(pageIndex: Int, totalPages: Int, totalCount: Int, hasPreviousPage: Bool, hasNextPage: Bool, data: [T]) {
        self.pageIndex = pageIndex
        self.totalPages = totalPages
        self.totalCount = totalCount
        self.hasPreviousPage = hasPreviousPage
        self.hasNextPage = hasNextPage
        self.data = data
    }
    
    /// Index of the current page, starting from `1`.
    public var pageIndex: Int
    /// Total amount of pages available.
    public var totalPages: Int
    /// Total amount of entries available.
    public var totalCount: Int
    /// Whether there's a page before this one.
    public var hasPreviousPage: Bool
    /// Whether there's a page after this one.
    public var hasNextPage: Bool
    /// Entries for the current page.
    public var data: [T]
}
