
import Foundation
public extension Encodable {
    var asDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(self)
            dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
        } catch {
            return dictionary
        }

        return dictionary
    }

    var asURLParameter: String {
        var components = URLComponents()
        components.queryItems = asDictionary.map {
            URLQueryItem(name: $0, value: "\($1)")
        }
        return components.url?.absoluteString ?? ""
    }
}
