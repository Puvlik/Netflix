import Foundation

extension Optional where Wrapped == String {
    var safeTrimmed: String {
        return self?.trimmingCharacters(in: .whitespacesAndNewlines) ?? Strings.Common.emptyString
    }
    
    func convertToTMDBDate() -> Date {
        guard let self = self else {
            return Date.distantPast
        }

        return DateFormatter.baseDateFormatter.date(from: self) ?? Date.distantPast
    }
    
    func extractReleaseYearAsString() -> String {
        guard let self, let date = DateFormatter.baseDateFormatter.date(from: self) else {
            return Strings.Common.emptyString
        }

        let year = Calendar.current.component(.year, from: date)
        return String(year)
    }
    
    func transformToUserFriendlyString() -> String {
        guard let self, let date = DateFormatter.baseDateFormatter.date(from: self) else {
            return Strings.MovieDetails.movieReleaseDateNotFound
        }

        return DateFormatter.monthFirstDateFormatter.string(from: date)
    }
}
