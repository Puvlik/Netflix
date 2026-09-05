import Foundation

protocol PerformValidationProtocol {
    func performValidation(_ validation: () throws -> Void, errorClosure: ((String?) -> Void)?) -> Bool
}

extension PerformValidationProtocol {
    func performValidation(_ validation: () throws -> Void, errorClosure: ((String?) -> Void)?) -> Bool {
        do {
            try validation()
            errorClosure?(nil)
            return true
        } catch {
            errorClosure?(error.localizedDescription)
            return false
        }
    }
}
