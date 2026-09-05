import Foundation

extension Date {
    func convertToTMDBTypeString() -> String {
        DateFormatter.baseDateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static let baseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let monthFirstDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
}
