// MARK: - PageManager

public final class PageManager<Element> where Element: Fetchable {

    private let service: AnyFetchableService<Element>
    
    public init<S>(service: S)
    where
        S: FetchableService,
        S.Element == Element { self.service = AnyFetchableService(service) }

    private var startPageFetchRequest: FetchRequest<Element>?

    private var previousPageCursor: Element.Cursor?
    
    /// Indicate whether the previous page exists.
    public var containsPreviousPage: Bool { previousPageCursor != nil }
    
    private var nextPageCursor: Element.Cursor?
    
    /// Indicate whether the next page exists.
    public var containsNextPage: Bool { nextPageCursor != nil }
    
    public func fetch(
        _ page: Page,
        completion: @escaping (Result<[Element], Error>) -> Void
    ) {
    
        let interpolation: (FetchResult<Element, Error>) -> Void = { result in
            
            do {
                
                let (elements, previousCursor, nextCursor) = try result.get()

                switch page {
                
                case .start:
                    
                    self.previousPageCursor = previousCursor
                    
                    self.nextPageCursor = nextCursor
                    
                case .previous:
                    
                    self.previousPageCursor = previousCursor
                    
                case .next:
                    
                    self.nextPageCursor = nextCursor
                    
                }
                
                completion(.success(elements))
                
            }
            catch { completion(.failure(error)) }
            
        }
        
        switch page {
            
        case let .start(fetchRequest):
            
            previousPageCursor = nil
            
            nextPageCursor = nil
            
            startPageFetchRequest = fetchRequest
            
            service.fetch(fetchRequest, completion: interpolation)
            
        case .previous:
        
            if startPageFetchRequest == nil { preconditionFailure("No start fetch request.") }
            
            guard let previousPageCursor = previousPageCursor else { preconditionFailure("No previous page.") }
            
            service.fetch(
                FetchRequest(fetchCursor: previousPageCursor),
                completion: interpolation
            )
            
        case .next:
            
            if startPageFetchRequest == nil { preconditionFailure("No start fetch request.") }
            
            guard let nextPageCursor = nextPageCursor else { preconditionFailure("No next page.") }
            
            service.fetch(
                FetchRequest(fetchCursor: nextPageCursor),
                completion: interpolation
            )
            
        }
        
    }

}

// MARK: - Page

extension PageManager {
    
    public enum Page {

        case start(FetchRequest<Element>)
        
        case previous
        
        case next

    }
    
}
