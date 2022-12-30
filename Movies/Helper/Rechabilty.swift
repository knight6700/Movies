import Network
import SwiftUI

// An enum to handle the network status
enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject , Equatable{
    static func == (lhs: Monitor, rhs: Monitor) -> Bool {
        return true
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .connected

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            Task.detached { @MainActor in
                if path.status == .satisfied {
                    print("No connection.")

                    self.status = .connected

                } else {
                    print("We're connected!")
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
