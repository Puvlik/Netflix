import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ child: Coordinator) {
        childCoordinators.removeAll(where: { $0 === child })
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}
