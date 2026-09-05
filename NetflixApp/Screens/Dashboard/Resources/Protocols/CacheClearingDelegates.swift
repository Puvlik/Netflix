// MARK: - CacheRefreshableDelegate
protocol CacheRefreshableDelegate: AnyObject {
    func refreshAfterCacheCleared()
}

// MARK: - CacheClearingDelegate
protocol CacheClearingDelegate: AnyObject {
    func didClearLocalCache()
}
