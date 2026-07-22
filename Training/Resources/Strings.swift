//
//  Resources.swift
//  Training
//
//  Created by Redouane Amour on 18/07/2026.
//

import Foundation

enum Resources {
    enum Titles {
        static let navigationStackTitle = "My Tasks"
        static let textFieldPlaceholder = "New task"
    }
    
    enum tasks {
        static let dummies: [String] = [
            "Buy milk",
            "Walk dog",
            "Read book",
            "Workout",
            "Call mom",
            "Pay bills",
            "Study Swift",
            "Clean desk",
            "Write code",
            "Plan trip"
        ]
        
        static let `default`: String = "Random task"
    }
}
