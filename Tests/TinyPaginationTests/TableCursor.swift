// MARK: - TableCursor

struct TableCursor {
    
    var offset: Int
    
    var limit = 10
    
}

// MARK: - Equatable

extension TableCursor: Equatable { }
