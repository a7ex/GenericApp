//
//  FormManager.swift

import Foundation

final class FormManager {
    let formId: String

    private var values = [String: Any]()

    convenience init() {
        self.init(formId: UUID().uuidString)
    }
    init(formId: String, metaData: FormMetaData? = nil) {
        self.formId = formId
    }
    func setValue(_ val: Any, forKey key: String) {
        values[key] = val
    }
    func value(for key: String) -> Any? {
        return values[key]
    }
    func removeValue(forKey key: String) {
        values.removeValue(forKey: key)
    }
    var parameterList: [String: Any] {
        return values
    }
}
