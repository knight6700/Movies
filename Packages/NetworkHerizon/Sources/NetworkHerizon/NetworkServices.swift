import Foundation

// Cusom Network error
public enum NetworkError: Error {
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    case failedSerialization

    public var customDescription: String {
        switch self {
        case let .requestFailed(description): return "Request Failed error -> \(description)"
        case .invalidData: return "Invalid Data error)"
        case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
        case .jsonParsingFailure: return "JSON Parsing Failure error)"
        case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
        case .noInternet: return "No internet connection"
        case .failedSerialization: return "serialisation print for debug failed."
        }
    }
}
public struct NetworkService {

    public init(urlSession: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
     var urlSession = URLSession.shared
     var decoder = JSONDecoder()
    
    public func fetch<T: Decodable>(
            type: T.Type,
            with api: API,
            body: Encodable?) async throws -> T { // 1
          
            // intialise url session
                let (data, response) = try await urlSession.data(for: generateQueryURLReqst(for: api, body: body))
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.requestFailed(description: "unvalid response")
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.responseUnsuccessful(description: "status code \(httpResponse.statusCode)")
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // 3 try to decoding
                return try decoder.decode(type, from: data)
            } catch {
                // catch error
                print(error)
                throw NetworkError.jsonConversionFailure(description: error.localizedDescription)
            }
        }
     func generateQueryURLReqst(for api: API, body: Encodable?) -> URLRequest {
        .init(url: URL(string: "\(api.baseURL)/\(api.endpoint)\(body?.asURLParameter ?? "")")!)
    }

}
