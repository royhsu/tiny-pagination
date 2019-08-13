// MARK: - TableRow

import TinyPagination

struct TableRow<Content> {
    
    var cursor: TableCursor
    
    var content: Content
    
}

// MARK: - Equatable

extension TableRow: Equatable where Content: Equatable { }

// MARK: - Fetchable

extension TableRow: Fetchable { }
