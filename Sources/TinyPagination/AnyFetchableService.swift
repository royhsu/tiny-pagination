// MARK: - AnyFetchableService

public struct AnyFetchableService<Element, Failure> where Element: Fetchable, Failure: Error {
    
    private let _fetch: (
        _ request: FetchRequest<Element>,
        _ completion: @escaping (FetchResult<Element, Failure>) -> Void
    )
    -> Void
    
    public init<S>(_ service: S)
    where
        S: FetchableService,
        S.Element == Element,
        S.Failure == Failure { self._fetch = service.fetch }
    
}

// MARK: - FetchableService

extension AnyFetchableService: FetchableService {
    
    public func fetch(
        _ request: FetchRequest<Element>,
        completion: @escaping (FetchResult<Element, Failure>) -> Void
    ) { _fetch(request, completion) }
    
}
