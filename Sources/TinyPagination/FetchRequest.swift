// MARK: - FetchRequest

public struct FetchRequest<Element> where Element: Fetchable {
    
    public var fetchCursor: Element.Cursor?
    
    public init(fetchCursor: Element.Cursor? = nil) { self.fetchCursor = fetchCursor }
    
}

// MARK: - Equatable

extension FetchRequest: Equatable where Element: Equatable { }
