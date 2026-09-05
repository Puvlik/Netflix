import UIKit

extension UICollectionView {
    func register(cellClasses: UICollectionViewCell.Type...) {
        cellClasses.forEach({
            register($0.self, forCellWithReuseIdentifier: String(describing: $0))
        })
    }
    
    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
}
