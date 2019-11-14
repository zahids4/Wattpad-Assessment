import Foundation
import Network
import Alamofire

class NetworkManager {
    private init() {}
    static let shared = NetworkManager()
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func startNetworkMonitor() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                // Present alert that connection was lost but
                // stories that have been downloaded can be used
                print("No connection.")
            }

            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
    }
}
