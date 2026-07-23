//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine
import Foundation

final class TodoTaskListViewModel: ObservableObject {
    @Published var list: TodoTaskList
    @Published var isSheetPresented: Bool = false
    @Published var text: String = ""

    init(list: TodoTaskList) {
        self.list = list
    }

    func save() {
        guard !text.isEmpty else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            return
        }
        list.add(trimmedText)
        list.add(text)
        dismissSheet()
    }
    
    func uncompletedTasksCount() -> Int {
        list.unCompletedTasksCount
    }

    func delete(_ todoTask: TodoTask) {
        list.delete(todoTask)
    }

    func select(_ todoTask: TodoTask) {
        list.check(todoTask)
    }

    func dismissSheet() {
        isSheetPresented = false
        text = ""
    }

    func presentSheet() {
        isSheetPresented = true
    }
}
