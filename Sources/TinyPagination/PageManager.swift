//enum PageState<Element, Failure> where Failure: Error {
//
//    case inactive
//
//    case fetching
//
//    case completed(Result<(elements: [Element], next))
//
//}

//struct PageElement<Content, Cursor> {
//
//    var content: Content
//
//    var cursor: Cursor
//
//}

public protocol Fetchable {
    
    associatedtype Cursor: Equatable
    
    var cursor: Cursor { get }
    
}

enum FetchCondition<Element, Failure> where Element: Fetchable, Failure: Error {
    
    case inactive
    
    case fetching
    
    case fetched(elements: [Element])
    
    case failure(Failure)
    
}

public struct FetchRequest<Element> where Element: Fetchable {
    
    public var fetchCursor: Element.Cursor?
    
    public var fetchCount: Int
    
    public init(fetchCursor: Element.Cursor? = nil, fetchCount: Int = 10) {
        
        precondition(fetchCount > 0)
        
        self.fetchCursor = fetchCursor
        
        self.fetchCount = fetchCount
        
    }
    
}

// MARK: - Equatable

extension FetchRequest: Equatable where Element: Equatable { }

public typealias FetchResult<Element, Failure> = Result<(elements: [Element], previousCursor: Element.Cursor?, nextCursor: Element.Cursor?), Failure> where Element: Fetchable, Failure: Error

public protocol FetchableService {
    
    associatedtype Element: Fetchable
    
    func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Error>) -> Void
    )
    
}

public struct AnyFetchableService<Element> where Element: Fetchable {
    
    private let _fetch: (
        _ request: FetchRequest<Element>,
        _ completion: @escaping (FetchResult<Element, Error>) -> Void
    )
    -> Void
    
    public init<S>(_ service: S)
    where
        S: FetchableService,
        S.Element == Element { self._fetch = service.fetch }
    
}

extension AnyFetchableService: FetchableService {
    
    public func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Error>) -> Void
    ) { _fetch(request, completion) }
    
}

final class PageManager<Element> where Element: Fetchable {

    private let service: AnyFetchableService<Element>
    
    init<S>(service: S)
    where
        S: FetchableService,
        S.Element == Element { self.service = AnyFetchableService(service) }

    enum Page {

        case start(FetchRequest<Element>), previous, next

    }
    
    private var startPageFetchRequest: FetchRequest<Element>?

    private var previousPageCursor: Element.Cursor?
    
    /// Indicate whether the previous page exists.
    var containsPreviousPage: Bool { previousPageCursor != nil }
    
    private var nextPageCursor: Element.Cursor?
    
    /// Indicate whether the next page exists.
    var containsNextPage: Bool { nextPageCursor != nil }
    
    func fetch(
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
            
            startPageFetchRequest = fetchRequest
            
            service.fetch(fetchRequest, completion: interpolation)
            
        case .previous:
        
            guard let startPageFetchRequest = startPageFetchRequest else { preconditionFailure("No start fetch request.") }
            
            guard let previousPageCursor = previousPageCursor else { preconditionFailure("No previous page.") }
            
            let previousPageFetchRequest = FetchRequest<Element>(
                fetchCursor: previousPageCursor,
                fetchCount: startPageFetchRequest.fetchCount
            )
            
            service.fetch(previousPageFetchRequest, completion: interpolation)
            
        case .next:
            
            guard let startPageFetchRequest = startPageFetchRequest else { preconditionFailure("No start fetch request.") }
            
            guard let nextPageCursor = nextPageCursor else { preconditionFailure("No next page.") }
            
            let nextPageFetchRequest = FetchRequest<Element>(
                fetchCursor: nextPageCursor,
                fetchCount: startPageFetchRequest.fetchCount
            )
            
            service.fetch(nextPageFetchRequest, completion: interpolation)
            
        }
        
    }

}
