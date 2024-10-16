import SwiftUI

struct CustomButton: View {
    let title: String
    let iconName: String
    let action: () -> Void
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                Text(title)
            }
            .foregroundColor(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                backgroundColor
                    .blur(radius: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(0.3)
            )
            .background(BlurView())
            .cornerRadius(10)
        }
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct BlurView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Material.ultraThin)
    }
}


extension CustomButton {
    
    // Predefined Search Button
    static func searchButton(action: @escaping () -> Void) -> some View {
        CustomButton(
            title: "Search",
            iconName: "magnifyingglass",
            action: action,
            foregroundColor: Color(UIColor.systemRed),
            backgroundColor: Color(UIColor.systemRed)
        )
    }
    
    // Predefined Share Button
    static func shareButton(action: @escaping () -> Void) -> some View {
        CustomButton(
            title: "Share Image",
            iconName: "square.and.arrow.up",
            action: action,
            foregroundColor: Color(UIColor.systemTeal),
            backgroundColor: Color(UIColor.systemGray6)
        )
    }

    // Predefined Save Button
    static func saveButton(action: @escaping () -> Void) -> some View {
        CustomButton(
            title: "Save Image",
            iconName: "square.and.arrow.down",
            action: action,
            foregroundColor: Color(UIColor.systemGreen),
            backgroundColor: Color(UIColor.systemGray6)
        )
    }

    // Predefined Twitter Button
    static func twitterButton(action: @escaping () -> Void) -> some View {
        CustomButton(
            title: "Twitter: yxvifilms",
            iconName: "checkmark",
            action: action,
            foregroundColor: Color(UIColor.systemBlue),
            backgroundColor: Color(UIColor.systemBlue.withAlphaComponent(0.6))
        )
    }

    // Predefined Instagram Button
    static func instagramButton(action: @escaping () -> Void) -> some View {
        CustomButton(
            title: "Instagram: yxvifilms",
            iconName: "camera",
            action: action,
            foregroundColor: Color(UIColor.systemRed),
            backgroundColor: Color(UIColor.systemRed.withAlphaComponent(0.6))
        )
    }
}
