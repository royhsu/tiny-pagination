// MARK: - Table

import Foundation
import TinyPagination

struct Table<Content> {
    
    private var rows: [TableRow<Content>]
    
    init(contents: [Content]) {
        
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
        _ request: FetchRequest<TableRow<Content>>,
        completion: @escaping (FetchResult<TableRow<Content>, Error>) -> Void
    ) {
        
        DispatchQueue.global().async {
            
            let rowIndices = self.rows.indices
            
            let currentCursor: TableCursor
            
            let previousCursor: TableCursor?
            
            if let fetchCursor = request.fetchCursor {
                
                currentCursor = fetchCursor
                
                let expectingPreviousRange = (currentCursor.offset - currentCursor.limit)..<currentCursor.offset
                
                let validPreviousRange = rowIndices.clamped(to: expectingPreviousRange)
                
                previousCursor = (currentCursor.offset == 0)
                    ? nil
                    : TableCursor(offset: validPreviousRange.lowerBound, limit: validPreviousRange.count)
                
            }
            else {
                
                currentCursor = TableCursor(offset: 0)
                
                previousCursor = nil
                
            }
            
            let currentStartOffset = currentCursor.offset
            
            guard rowIndices.contains(currentStartOffset) else {

                completion(.failure(FetchError.notFound(currentCursor)))

                return

            }
            
            let currentEndOffset = currentStartOffset + currentCursor.limit - 1
            
            let nextStartOffset = currentEndOffset + 1
            
            let containsNext = nextStartOffset < self.rows.count
            
            let nextCursor: TableCursor?
            
            if containsNext {
            
                let expectingNextRange = nextStartOffset..<(nextStartOffset + currentCursor.limit)
                
                let validNextRange = rowIndices.clamped(to: expectingNextRange)
                
                nextCursor = TableCursor(offset: validNextRange.lowerBound, limit: validNextRange.count)
                
            }
            else { nextCursor = nil }
            
            let fetchRange = (currentStartOffset..<nextStartOffset).clamped(to: rowIndices)
            
            let fetchRows = Array(self.rows[fetchRange])

            completion(.success((fetchRows, previousCursor, nextCursor)))
            
        }
        
    }
    
}

// MARK: - FetchError

extension Table {
    
    enum FetchError: Error {
        
        case notFound(TableCursor)
        
    }
    
}
