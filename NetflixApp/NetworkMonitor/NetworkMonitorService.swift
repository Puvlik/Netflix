import Foundation
import Network

enum NetworkStatus {
    case unknown
    case connected
    case disconnected
}

// MARK: - Network Monitor Service
@Observable
@MainActor
final class NetworkMonitorService {
    var status: NetworkStatus = .unknown
    private let monitor = NWPathMonitor()
    private var canceller: TaskCanceller?
    
    init() {
        let monitor = self.monitor
        let task = Task { [weak self] in
            guard let self else { return }
            for await path in monitor {
                self.status = (path.status == .satisfied) ? .connected : .disconnected
            }
            
            monitor.cancel()
        }
        
        self.canceller = TaskCanceller(task)
    }
}

// MARK: - Task Canceller
final class TaskCanceller: Sendable {
    let task: Task<Void, Never>
    
    init(_ task: Task<Void, Never>) {
        self.task = task
    }
    
    deinit {
        task.cancel()
    }
}
