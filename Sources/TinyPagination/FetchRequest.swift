// MARK: - FetchRequest

public struct FetchRequest<Element> where Element: Fetchable {
    
    public var fetchCursor: Element.Cursor?
    
    public var fetchLimit: Int
    
    public init(
        fetchCursor: Element.Cursor? = nil,
        fetchLimit: Int = 10
    ) {
        
        self.fetchCursor = fetchCursor
        
        self.fetchLimit = fetchLimit
        
    }
    
}

// MARK: - Equatable

extension FetchRequest: Equatable where Element: Equatable { }
