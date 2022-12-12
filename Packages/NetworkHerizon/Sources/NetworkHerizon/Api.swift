
import Foundation
public struct API {
    
    var baseURL: CustomStringConvertible {
        #if DEBUG
        return "https://api.themoviedb.org/3"
        #elseif RELEASE
        return "https://api.themoviedb.org/3"
        #endif
    }

    let endpoint: CustomStringConvertible

    var headers: [String: String?] {
        let dictionary = ["Accept": "application/json",
                          "Content-Type": "application/json"]
        return dictionary
    }

    public init(endpoint: CustomStringConvertible) {
        self.endpoint = endpoint
    }
}

