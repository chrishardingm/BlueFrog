//
//  DifficultyOptions.swift
//  BlueFrog
//
//  Created by Chris Harding on 2/1/21.
//

import Foundation

enum DifficultyOptions: String, CaseIterable {
    case Easy, Medium, Hard
    
    var description: String {
        switch self {
        case .Easy:
            return "Easy"
        case .Medium:
            return "Medium"
        case .Hard:
            return "Hard"
        }
    }
}
