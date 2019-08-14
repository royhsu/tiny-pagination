// MARK: - FetchResult

public typealias FetchResult<Element, Failure> = Result<(elements: [Element], previousCursor: Element.Cursor?, nextCursor: Element.Cursor?), Failure> where Element: Fetchable, Failure: Error
