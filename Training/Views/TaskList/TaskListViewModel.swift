//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine

final class TaskListViewModel: ObservableObject {
    @Published var list: TaskList
    @Published var isSheetPresented: Bool = false
    @Published var text: String = ""

    init(list: TaskList) {
        self.list = list
    }

    func save() {
        guard !text.isEmpty else { return }
        list.add(text)
        dismissSheet()
    }

    func select(_ task: Task) {
        list.check(task)
    }

    func dismissSheet() {
        isSheetPresented = false
        text = ""
    }

    func presentSheet() {
        isSheetPresented = true
    }
}
