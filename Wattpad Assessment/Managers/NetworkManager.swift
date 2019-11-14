import Foundation
import Network
import Alamofire

class NetworkManager {
    private init() {}
    static let shared = NetworkManager()
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
