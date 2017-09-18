//
//  FormManagers.swift

import Foundation

final class FormManagers {
    private var formObjects: [FormManager]

    convenience init() {
        self.init(with: FormManager())
    }

    init(with form: FormManager) {
        formObjects = [form]
    }

    var defaultForm: FormManager {
        return formObjects[0]
    }

    func form(with formId: String) -> FormManager? {
        return formObjects.first(where: { $0.formId == formId })
    }

    @discardableResult
    func addForm(with formId: String) -> FormManager {
        if form(with: formId) == nil {
            formObjects.append(FormManager(formId: formId))
        }
        // swiftlint:disable:next force_unwrapping
        return form(with: formId)!
    }

    func addForm(_ form: FormManager) {
        formObjects = formObjects.filter { $0.formId != form.formId }
        formObjects.append(form)
    }
}
