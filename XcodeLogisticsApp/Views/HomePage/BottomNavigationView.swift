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
                .padding(.bottom, -10)
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
    @State private var searchText = ""
    @State private var selectedCategory = 0
    @State private var isAnimated = false
    
    // 消息分类
    let categories = ["全部", "系统", "订单", "客服"]
    
    // 示例消息数据
    let messages = [
        MessageItem(
            id: 1,
            avatar: "bell.fill",
            title: "系统通知",
            lastMessage: "您的订单已发货，预计3天内到达",
            time: "10:30",
            unreadCount: 2,
            messageType: .system
        ),
        MessageItem(
            id: 2,
            avatar: "truck.box.fill",
            title: "订单SH2025001",
            lastMessage: "货物已到达目的地仓库",
            time: "09:15",
            unreadCount: 1,
            messageType: .order
        ),
        MessageItem(
            id: 3,
            avatar: "person.fill",
            title: "客服小李",
            lastMessage: "您好，关于您的运输需求我们已经安排...",
            time: "昨天",
            unreadCount: 0,
            messageType: .service
        ),
        MessageItem(
            id: 4,
            avatar: "exclamationmark.triangle.fill",
            title: "运输异常提醒",
            lastMessage: "订单BJ2025002运输路线变更通知",
            time: "昨天",
            unreadCount: 1,
            messageType: .system
        ),
        MessageItem(
            id: 5,
            avatar: "checkmark.circle.fill",
            title: "订单GZ2025003",
            lastMessage: "运输完成，请确认收货",
            time: "2天前",
            unreadCount: 0,
            messageType: .order
        )
    ]
    
    var filteredMessages: [MessageItem] {
        if selectedCategory == 0 {
            return messages
        } else {
            let type: MessageType = [.system, .order, .service][selectedCategory - 1]
            return messages.filter { $0.messageType == type }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                        
                        TextField("搜索消息", text: $searchText)
                            .font(.system(size: 16))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.15), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.08)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 分类标签
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            CategoryTag(
                                title: categories[index],
                                isSelected: selectedCategory == index,
                                action: { selectedCategory = index }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 消息列表
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredMessages.enumerated()), id: \.element.id) { index, message in
                            MessageRow(message: message, index: index, isAnimated: isAnimated)
                            
                            if index < filteredMessages.count - 1 {
                                Divider()
                                    .padding(.leading, 70)
                            }
                        }
                    }
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 10)
            }
            .navigationTitle("消息")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(DesignSystem.Animation.spring) {
                    isAnimated = true
                }
            }
        }
    }
}

// 消息类型枚举
enum MessageType {
    case system, order, service
}

// 消息数据模型
struct MessageItem {
    let id: Int
    let avatar: String
    let title: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let messageType: MessageType
}

// 分类标签组件
struct CategoryTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)

                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? 
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.2), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// 消息行组件
struct MessageRow: View {
    let message: MessageItem
    let index: Int
    let isAnimated: Bool
    
    var body: some View {
        Button(action: {
            // 进入具体消息对话页面
        }) {
            HStack(spacing: 12) {
                // 头像
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 102/255, green: 187/255, blue: 106/255).opacity(0.8), Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: message.avatar)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                // 消息内容
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.Label.primary)
                        
                        Spacer()
                        
                        Text(message.time)
                            .font(.system(size: 12))
                            .foregroundColor(DesignSystem.Colors.Label.tertiary)
                    }
                    
                    HStack {
                        Text(message.lastMessage)
                            .font(.system(size: 14))
                            .foregroundColor(DesignSystem.Colors.Label.secondary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        if message.unreadCount > 0 {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 255/255, green: 59/255, blue: 48/255))
                                    .frame(width: 20, height: 20)
                                
                                Text("\(message.unreadCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.clear)
        }
        .buttonStyle(MessageRowButtonStyle())
        .opacity(isAnimated ? 1 : 0)
        .offset(x: isAnimated ? 0 : -20)
        .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
    }
}

// 消息行按钮样式
struct MessageRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? 
                Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.1) : 
                Color.clear
            )
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
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
