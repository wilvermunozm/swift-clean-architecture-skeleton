import SwiftUI

struct AppScaffold<Content: View>: View {
    @Environment(\.viinderTheme) private var theme
    
    private let topBar: (() -> AnyView)?
    private let bottomBar: (() -> AnyView)?
    private let floatingActionButton: (() -> AnyView)?
    private let content: () -> Content
    private let horizontalPadding: CGFloat
    
    init(
        topBar: (() -> AnyView)? = nil,
        bottomBar: (() -> AnyView)? = nil,
        floatingActionButton: (() -> AnyView)? = nil,
        horizontalPadding: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.topBar = topBar
        self.bottomBar = bottomBar
        self.floatingActionButton = floatingActionButton
        self.horizontalPadding = horizontalPadding
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                if let topBar = topBar {
                    topBar()
                }
                
                ZStack {
                    theme.colors.background.ignoresSafeArea()
                    
                    VStack {
                        content()
                            
                            .padding(.horizontal, horizontalPadding)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if let bottomBar = bottomBar {
                    bottomBar()
                }
            }
            
            if let floatingActionButton = floatingActionButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingActionButton()
                            .padding(.trailing, 16)
                            .padding(.bottom, bottomBar != nil ? 72 : 16)
                    }
                }
            }
        }
        .background(theme.colors.background)
        
    }
    
}
