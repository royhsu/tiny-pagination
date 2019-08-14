// MARK: - AnyFetchableService

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

// MARK: - FetchableService

extension AnyFetchableService: FetchableService {
    
    public func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Error>) -> Void
    ) { _fetch(request, completion) }
    
}
