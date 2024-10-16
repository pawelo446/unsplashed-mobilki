import Foundation
import SwiftUI

enum ColorPicker: String, CaseIterable {
    case black_and_white, black, white, yellow, orange, red, purple, magenta, green, teal, blue

    var systemImageName: String {
        switch self {
        case .black_and_white:
            return "circle.lefthalf.fill"
        case .black:
            return "circle.fill"
        case .white:
            return "circle"
        case .yellow:
            return "circle.fill"
        case .orange:
            return "circle.fill"
        case .red:
            return "circle.fill"
        case .purple:
            return "circle.fill"
        case .magenta:
            return "circle.fill"
        case .green:
            return "circle.fill"
        case .teal:
            return "circle.fill"
        case .blue:
            return "circle.fill"
        }
    }
    
    var name: String {
        switch self {
        case .black_and_white:
            return "B&W"
        case .black:
            return "Black"
        case .white:
            return "white"
        case .yellow:
            return "yellow"
        case .orange:
            return "orange"
        case .red:
            return "red"
        case .purple:
            return "purple"
        case .magenta:
            return "magenta"
        case .green:
            return "green"
        case .teal:
            return "teal"
        case .blue:
            return "blue"
        }
    }

    var color: Color {
        switch self {
        case .black_and_white:
            return .white
        case .black:
            return .black
        case .white:
            return .white
        case .yellow:
            return .yellow
        case .orange:
            return .orange
        case .red:
            return .red
        case .purple:
            return .purple
        case .magenta:
            return .pink
        case .green:
            return .green
        case .teal:
            return .teal
        case .blue:
            return .blue
        }
    }
}
