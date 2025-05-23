import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomePageView()
                    .tag(0)
                
                OrdersView()
                    .tag(1)
                
                Color.clear // 占位，不显示任何内容
                    .tag(2)
                
                MessagesView()
                    .tag(3)
                
                ProfileView()
                    .tag(4)
            }
            
            BottomNavigationView(selectedTab: $selectedTab)
                .padding(.bottom, 30)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    @State private var isAnimated = false
    
    var body: some View {
        // 底部导航栏背景
        ZStack {
            BlurView(style: .systemThinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(DesignSystem.Colors.separator)
                        .opacity(0.8),
                    alignment: .top
                )
            
            // 导航栏内容
            HStack(spacing: 0) {
                // 首页
                TabButton(
                    icon: "house.fill",
                    title: "首页",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 }
                )
                
                // 订单
                TabButton(
                    icon: "doc.text.fill",
                    title: "订单",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
                
                // 中间的发布按钮
                Button(action: {
                    // 发布功能
                    selectedTab = 2
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: Color(red: 102/255, green: 187/255, blue: 106/255).opacity(0.5), radius: 10, x: 0, y: 4)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -5)
                .scaleEffect(isAnimated ? 1 : 0.01)
                .animation(DesignSystem.Animation.spring.delay(0.1), value: isAnimated)
                
                // 消息
                TabButton(
                    icon: "message.fill",
                    title: "消息",
                    isSelected: selectedTab == 3,
                    action: { selectedTab = 3 }
                )
                
                // 我的
                TabButton(
                    icon: "person.fill",
                    title: "我的",
                    isSelected: selectedTab == 4,
                    action: { selectedTab = 4 }
                )
            }
        }
        .frame(height: 83)
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

// 各个主要页面的视图
struct HomePageView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView()
                    LocationInputsView()
                    ServiceCategoriesView()
                    NewsSectionView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct OrdersView: View {
    var body: some View {
        NavigationView {
            Text("订单页面")
                .navigationTitle("订单")
        }
    }
}

struct MessagesView: View {
    var body: some View {
        NavigationView {
            Text("消息页面")
                .navigationTitle("消息")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("个人中心")
                .navigationTitle("我的")
        }
    }
}

// 底部导航栏按钮
struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? Color(red: 76/255, green: 175/255, blue: 80/255) : DesignSystem.Colors.Label.tertiary)
                    
                    Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? Color(red: 76/255, green: 175/255, blue: 80/255) : DesignSystem.Colors.Label.tertiary)
        }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
