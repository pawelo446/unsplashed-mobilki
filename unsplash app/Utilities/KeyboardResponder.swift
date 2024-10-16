import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { notification in
                self.handleKeyboard(notification: notification)
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func handleKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                currentHeight = keyboardFrame.height
            }
        } else {
            currentHeight = 0
        }
    }
}
