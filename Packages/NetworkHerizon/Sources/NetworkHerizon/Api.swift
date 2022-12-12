
import Foundation
public struct API {
    var baseURL: CustomStringConvertible {
        // TODO: - Add More Base URL For Deferent Target
        "https://api.themoviedb.org/3"
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

