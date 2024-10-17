import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    backgroundView
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack {
                        Spacer().frame(height: Constants.Layout.verticalPadding)
                        
                        logoImage
                            .frame(width: Constants.Layout.logoSize.width, height: Constants.Layout.logoSize.height)
                        
                        Spacer().frame(height: Constants.Spacing.logoToTextField)
                        
                        textField
                        
                        Spacer()
                        
                        searchButton
                            .frame(height: Constants.Layout.buttonHeight)
                        
                        Spacer().frame(height: keyboardResponder.currentHeight > 0 ? keyboardResponder.currentHeight * 0.1 : Constants.Spacing.bottomToButton)
                    }
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.triggerEvent(.onAppear)
            }
            .onDisappear {
                viewModel.triggerEvent(.onDisappear)
            }
            .alert(item: $viewModel.alert) { alertState in
                Alert(
                    title: Text(alertState.title),
                    message: Text(alertState.message),
                    dismissButton: .default(Text("OK")) {
                        viewModel.triggerEvent(.dismissAlert)
                    }
                )
            }
            .navigationDestination(isPresented: $viewModel.navigateToPicturesList) {
                PicturesListView(viewModel: PictureViewModel(phrase: viewModel.phraseText))
            }
        }
        .accentColor(.red)
    }

    @ViewBuilder
    var backgroundView: some View {
            if let imageData = viewModel.backgroundImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .transition(.slide.animation(.easeOut))
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.clear
                    .edgesIgnoringSafeArea(.all)
            }
    }

    @ViewBuilder
    var logoImage: some View {
        if let ubLogo = UIImage(named: Constants.Images.ubLogo) {
            Image(uiImage: ubLogo.withTintColor(.secondaryLabel))
                .resizable()
                .scaledToFit()
        } else {
            Color.clear
        }
    }

    @ViewBuilder
    var textField: some View {
        TextField("Enter phrase", text: $viewModel.phraseText)
            .padding()
            .background(Color(UIColor.systemGray5).opacity(0.6))
            .cornerRadius(10)
            .textFieldStyle(PlainTextFieldStyle())
            .frame(height: Constants.Layout.textFieldHeight)
    }

    @ViewBuilder
    var searchButton: some View {
        CustomButton.searchButton {
            viewModel.triggerEvent(.searchTapped)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
