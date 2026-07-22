//
//  File.swift
//  Training
//
//  Created by Redouane Amour on 15/07/2026.
//

import Combine

final class TaskListViewModel: ObservableObject {
    @Published var list: TaskList
    
    init(list: TaskList) {
        self.list = list
    }

    func select(_ task: Task) {
        list.check(task)
    }
}
