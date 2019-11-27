// MARK: - AnyFetchableService

import OpenCombine

public struct AnyFetchableService<Element, Failure>
where
    Element: Fetchable,
    Failure: Error {
    
    private let _fetch: (
        FetchRequest<Element>
    )
    -> AnyPublisher<FetchResponse<Element>, Failure>
    
    public init<S>(_ service: S)
    where
        S: FetchableService,
        S.Element == Element,
        S.Failure == Failure { self._fetch = service.fetch }
    
}

// MARK: - FetchableService

extension AnyFetchableService: FetchableService {
    
    public func fetch(
        _ request: FetchRequest<Element>
    )
    -> AnyPublisher<FetchResponse<Element>, Failure> { _fetch(request) }
    
}
