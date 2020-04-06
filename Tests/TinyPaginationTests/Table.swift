// MARK: - Table

import Foundation
import Combine
import TinyPagination

struct Table<Content> {
    
    private var rows: [TableRow<Content>]
    
    init(contents: [Content] = []) {
        
        self.rows = zip(contents.indices, contents)
            .map { index, content in

                TableRow(
                    cursor: TableCursor(offset: index, limit: 1),
                    content: content
                )

            }
        
    }
    
}

// MARK: - Equatable

extension Table: Equatable where Content: Equatable { }

// MARK: - FetchableService

extension Table: FetchableService {
    
    func fetch(
        _ request: FetchRequest<TableRow<Content>>
    )
    -> AnyPublisher<FetchResponse<TableRow<Content>>, Error> {
        
        Deferred {
            
            Future { promise in
            
                DispatchQueue.global(qos: .background).async {
                    
                    let rowIndices = self.rows.indices
                    
                    let currentPageCursor: TableCursor
                    
                    let previousPageCursor: TableCursor?
                    
                    if let fetchCursor = request.fetchCursor {
                        
                        currentPageCursor = fetchCursor
                        
                        let expectedPreviousRange = (currentPageCursor.offset - currentPageCursor.limit)..<currentPageCursor.offset
                        
                        let validPreviousRange = rowIndices.clamped(
                            to: expectedPreviousRange
                        )
                        
                        previousPageCursor = (currentPageCursor.offset == 0)
                            ? nil
                            : TableCursor(
                                offset: validPreviousRange.lowerBound,
                                limit: validPreviousRange.count
                            )
                        
                    }
                    else {
                        
                        currentPageCursor = TableCursor(offset: 0)
                        
                        previousPageCursor = nil
                        
                    }
                    
                    let currentStartOffset = currentPageCursor.offset
                    
                    guard rowIndices.contains(currentStartOffset) else {

                        promise(
                            .failure(FetchError.rowsNotFound(currentPageCursor))
                        )

                        return

                    }
                    
                    let currentEndOffset = currentStartOffset + currentPageCursor.limit - 1
                    
                    let nextStartOffset = currentEndOffset + 1
                    
                    let containsNext = nextStartOffset < self.rows.count
                    
                    let nextCursor: TableCursor?
                    
                    if containsNext {
                    
                        let expectedNextRange = nextStartOffset..<(nextStartOffset + currentPageCursor.limit)
                        
                        let validNextRange = rowIndices.clamped(
                            to: expectedNextRange
                        )
                        
                        nextCursor = TableCursor(
                            offset: validNextRange.lowerBound,
                            limit: validNextRange.count
                        )
                        
                    }
                    else { nextCursor = nil }
                    
                    let fetchRange = (currentStartOffset..<nextStartOffset).clamped(to: rowIndices)
                    
                    let fetchRows = Array(self.rows[fetchRange])

                    promise(
                        .success(
                            FetchResponse(
                                elements: fetchRows,
                                previousPageCursor: previousPageCursor,
                                nextPageCursor: nextCursor
                            )
                        )
                    )
                    
                }
                
            }
            
        }
            .eraseToAnyPublisher()
        
    }
    
}

// MARK: - FetchError

extension Table {
    
    enum FetchError: Error {
        
        /// Cannot find rows for the given cursor.
        case rowsNotFound(TableCursor)
        
    }
    
}
