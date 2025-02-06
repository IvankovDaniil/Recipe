import SwiftUI

enum MainFlowTab {
    case recipt
    case favourites
    case settings
}

struct MainFlow: View {
    @Environment(\.viewModel) var viewModel
    @Environment(\.userViewModel) var userViewModel
    
    @State private var currentTab: MainFlowTab = .recipt
    private let buttons: [TabBarButtonConfiguration] =
    [TabBarButtonConfiguration(title: "Рецепты",
                               icon: "list.dash",
                               tab: .recipt),
     
     TabBarButtonConfiguration(title: "Закрепленные",
                               icon: "heart.fill",
                               tab: .favourites),
     
     TabBarButtonConfiguration(title: "Настройки",
                               icon: "gear",
                               tab: .settings)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                ReciptFlow()
                    .tag(MainFlowTab.recipt)
                FavouritesFlow()
                    .tag(MainFlowTab.favourites)
                SettingsFlow()
                    .tag(MainFlowTab.settings)
            }
            .safeAreaInset(edge: .bottom) {
                TabBarLabel(buttons: buttons, currentTab: $currentTab)
                    .background(
                        Color.white
                            .background(BlurView(style: .systemThinMaterial))
                            .ignoresSafeArea(edges: .bottom)
                    )
            }
        }
        .task {
            do {
                if let viewModel = viewModel {
                    try await viewModel.loadRecipes()
                }
            } catch {
                viewModel?.allRecipe = []
            }
        }
    }
}

private struct TabBarLabel: View {
    let buttons: [TabBarButtonConfiguration]
    @Binding var currentTab: MainFlowTab
    
    @State private var indicatorPosition: CGFloat = 0
    @State private var indicatorWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue)
                .padding(.horizontal, 12)
                .frame(width: indicatorWidth)
                .offset(x: indicatorPosition)
                .animation(.easeInOut(duration: 0.3), value: indicatorPosition)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                ForEach(buttons) { button in
                    TabBarButtons(config: button, isSelected: button.tab == currentTab, action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentTab = button.tab
                            updateIndicator(for: button)
                        }
                    })
                }
            }
        }
        .frame(height: 60)
        .onAppear {
            updateIndicator(for: buttons.first(where: { $0.tab == currentTab }) ?? buttons.first!)
        }
    }
    
    private func updateIndicator(for button: TabBarButtonConfiguration) {
        if let buttonIndex = buttons.firstIndex(where: { $0.tab == button.tab }) {
            let width = UIScreen.main.bounds.width / CGFloat(buttons.count)
            let position = CGFloat(buttonIndex) * width
            indicatorPosition = position
            indicatorWidth = width
        }
    }
}



private struct TabBarButtonConfiguration: Identifiable {
    var id: MainFlowTab { tab }
    
    let title: String
    let icon: String
    let tab: MainFlowTab
}

private struct TabBarButtons: View {
    let config: TabBarButtonConfiguration
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 0) {
                Image(systemName: config.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .blue)
                    .padding(.top, 5)
                
                Text(config.title)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .blue)
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
        }
    }
}


#Preview {
    MainFlow()
}

