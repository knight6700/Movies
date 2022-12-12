
import MoviesKyes

enum AppEnvironment {

    static var isLive: Bool {
        #if DEBUG
        return false
        #elseif RELEASE
        return true
        #endif
    }
    
    static var apiKey: String {
        isLive ? Keys.Release().moviesAPIKey : Keys.Debug().moviesAPIKey
    }
}
