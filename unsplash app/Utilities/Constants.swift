import UIKit
import SwiftUICore

import SwiftUI

struct Constants {
    struct Layout {
        static let horizontalPadding: CGFloat = 25
        static let verticalPadding: CGFloat = 80
        static let buttonHeight: CGFloat = 50
        static let logoSize: CGSize = CGSize(width: 200, height: 150)
        static let textFieldHeight: CGFloat = 50
    }

    struct Spacing {
        static let logoToTextField: CGFloat = 48
        static let bottomToButton: CGFloat = 50
    }

    struct Colors {
        static let searchButtonColor = Color.pink
    }

    struct SFSymbols {
        static let circle = "circle"
        static let circleFilled = "circle.fill"
        static let circleSlash = "circle.slash"
        static let heart = "heart"
        static let heartFilled = "heart.fill"
        static let paintPalette = "paintpalette"
    }

    struct Images {
        static let placeholderImage = "imagePlaceholder"
        static let ubLogo = "UB-Logo"
        static let emptyStateLogo = "empty-state-logo"
    }
}
