//
//  AsyncTask.swift

import Foundation

/// Simple task queue. It can process the tasks either in sequence or in parallel

struct AsyncTask {
    let taskId: String
    let closure: ((@escaping (Any?) -> Void, @escaping (Error) -> Void) -> Void)

    func execute(completion: (@escaping (Any?) -> Void), failure: (@escaping (Error) -> Void)) {
        closure(completion, failure)
    }
}

enum AsyncTaskMode {
    case inSequence
    case inParallel
}

class AsyncTaskToken {

    struct AsyncTaskResult {
        let taskId: String
        let result: Any?
        let error: Error?
    }

    private let tasks: [AsyncTask]
    private let mode: AsyncTaskMode
    private var isValid = true
    private var returnValues = [AsyncTaskResult]()

    @discardableResult
    init(tasks: [AsyncTask], mode: AsyncTaskMode, taskId: String = UUID().uuidString) {
        self.tasks = tasks
        self.mode = mode
    }

    deinit {
        // Automatically perform the animations when the token gets deallocated
        perform { (_) in
        }
    }

    func perform(completionHandler: @escaping ([AsyncTaskResult]) -> Void) {
        // To prevent the task from being executed twice, we invalidate
        // the token once its tasks has been performed
        guard isValid else { return }
        isValid = false

        returnValues = [AsyncTaskResult]()

        switch mode {
        case .inSequence:
            performTasks(tasks, completionHandler: completionHandler)
        case .inParallel:
            performTasksInParallel(tasks, completionHandler: completionHandler)
        }
    }

    private func performTasks(_ tasks: [AsyncTask], completionHandler: @escaping ([AsyncTaskResult]) -> Void) {

        // We call the completion handler when our exit condition is hit
        guard !tasks.isEmpty else {
            return completionHandler(returnValues)
        }

        var tasks = tasks
        let task = tasks.removeFirst()

        task.execute(completion: { (result) in
            self.returnValues.append(AsyncTaskResult(taskId: task.taskId, result: result, error: nil))
            self.performTasks(tasks, completionHandler: completionHandler)
        }) { (error) in
            self.returnValues.append(AsyncTaskResult(taskId: task.taskId, result: nil, error: error))
            completionHandler(self.returnValues)
        }
    }

    private func performTasksInParallel(_ tasks: [AsyncTask], completionHandler: @escaping ([AsyncTaskResult]) -> Void) {
        // If we have no animations, we can exit early
        guard !tasks.isEmpty else {
            return completionHandler(returnValues)
        }

        // In order to call the completion handler once all animations
        // have finished, we need to keep track of these counts
        var taskCount = tasks.count

        let taskCompletionHandler: (() -> Void) = { () in
            taskCount -= 1

            // Once all animations have finished, we call the completion handler
            if taskCount < 1 {
                completionHandler(self.returnValues)
            }
        }

        // Same as before, only with the call to the animation
        // completion handler added
        for task in tasks {
            task.execute(completion: { (result) in
                self.returnValues.append(AsyncTaskResult(taskId: task.taskId, result: result, error: nil))
                taskCompletionHandler()
            }, failure: { (error) in
                self.returnValues.append(AsyncTaskResult(taskId: task.taskId, result: nil, error: error))
                taskCompletionHandler()
            })
        }
    }
}
