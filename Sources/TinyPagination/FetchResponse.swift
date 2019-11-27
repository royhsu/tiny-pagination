// MARK: - FetchResponse

public struct FetchResponse<Element> where Element: Fetchable {
    
    /// The fetched elements.
    public var elements: [Element]
    
    /// Cursor for the previous page.
    public var previousPageCursor: Element.Cursor?
    
    /// Cursor for the next page.
    public var nextPageCursor: Element.Cursor?
    
    public init(
        elements: [Element],
        previousPageCursor: Element.Cursor? = nil,
        nextPageCursor: Element.Cursor? = nil
    ) {
        
        self.elements = elements
        
        self.previousPageCursor = previousPageCursor
        
        self.nextPageCursor = nextPageCursor
        
    }
    
}

