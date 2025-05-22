import SwiftUI

struct BottomNavigationView: View {
    @State private var selectedTab = 0
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
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
                    }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.red.opacity(0.3), radius: 10, x: 0, y: 4)
                            
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
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    
                    // 我的
                    TabButton(
                        icon: "person.fill",
                        title: "我的",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )
                }
            }
            .frame(height: 83)
        }
        .ignoresSafeArea(.keyboard)
        .padding(.bottom, 30) // 调整底部位置，使其上移
        .onAppear {
            withAnimation {
                isAnimated = true
            }
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
                    .foregroundColor(isSelected ? .red : DesignSystem.Colors.Label.tertiary)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .red : DesignSystem.Colors.Label.tertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    BottomNavigationView()
}
