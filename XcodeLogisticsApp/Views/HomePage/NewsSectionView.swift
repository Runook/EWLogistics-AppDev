import SwiftUI

struct NewsSectionView: View {
    @State private var isAnimated = false
    @State private var selectedTab = 0
    
    // 示例数据
    let eventItems = [
        NewsItem(
            title: "物流行业交流会",
            description: "2025年物流行业发展趋势研讨会",
            date: "2025-05-21",
            imageUrl: "event1"
        ),
        NewsItem(
            title: "物流技术展览会",
            description: "最新物流自动化设备展示",
            date: "2025-05-20",
            imageUrl: "event2"
        )
    ]
    
    let newsItems = [
        NewsItem(
            title: "物流行业黑名单更新",
            description: "2025年物流行业失信人员名单",
            date: "2025-05-21",
            imageUrl: "news1"
        ),
        NewsItem(
            title: "最新政策解读",
            description: "跨境物流新规详解",
            date: "2025-05-20",
            imageUrl: "news2"
        )
    ]
    
    let videoItems = [
        NewsItem(
            title: "卡车司机日常",
            description: "跨境运输实况直播",
            date: "直播中",
            imageUrl: "video1"
        ),
        NewsItem(
            title: "仓储管理技巧",
            description: "专业仓储管理员经验分享",
            date: "2024-03-19",
            imageUrl: "video2"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题栏
            HStack {
                Text("资讯中心")
                    .font(.system(size: 18, weight: .medium))
                .foregroundColor(DesignSystem.Colors.Label.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 10)
            
            // 分类标签
            HStack(spacing: 20) {
                TabButton2(title: "事件论坛", isSelected: selectedTab == 0) {
                    withAnimation { selectedTab = 0 }
                }
                
                TabButton2(title: "新闻资讯", isSelected: selectedTab == 1) {
                    withAnimation { selectedTab = 1 }
                }
                
                TabButton2(title: "视频直播", isSelected: selectedTab == 2) {
                    withAnimation { selectedTab = 2 }
                }
            }
            .padding(.horizontal, 20)
            
            // 内容区域
            TabView(selection: $selectedTab) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(eventItems) { item in
                            NewsCard(item: item, isEvent: true)
                        }
        }
                    .padding(.horizontal, 20)
                }
                .tag(0)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(newsItems) { item in
                            NewsCard(item: item, isEvent: false)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .tag(1)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(videoItems) { item in
                            NewsCard(item: item, isVideo: true)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 180)
        }
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

// 分类标签按钮
struct TabButton2: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? .red : DesignSystem.Colors.Label.secondary)
                
                Rectangle()
                    .fill(isSelected ? Color.red : Color.clear)
                    .frame(height: 2)
            }
        }
    }
}

// 新闻数据模型
struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: String
    let imageUrl: String
}

// 新闻卡片视图
struct NewsCard: View {
    let item: NewsItem
    var isEvent: Bool = false
    var isVideo: Bool = false
    
    var body: some View {
        Button(action: {
            // 新闻点击事件
        }) {
            VStack(alignment: .leading, spacing: 6) {
                // 新闻图片
                ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                gradient: Gradient(colors: [
                                    Color.red.opacity(0.7),
                                    Color.red.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                        )
                        .frame(width: 160, height: 90)
                    
                    if isVideo {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    } else if isEvent {
                        Image(systemName: "calendar")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "newspaper.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    
                    if isVideo && item.date == "直播中" {
                        VStack {
                            Spacer()
                            HStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 6, height: 6)
                                Text("直播中")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.6))
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    // 标题
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                        .lineLimit(1)
                    
                    // 描述
                    Text(item.description)
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                        .lineLimit(2)
                    
                    // 日期
                    Text(item.date)
                        .font(.system(size: 10))
                        .foregroundColor(DesignSystem.Colors.Label.tertiary)
                }
                .padding(.horizontal, 6)
            }
            .frame(width: 160)
            .background(DesignSystem.Colors.Fill.tertiary)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(NewsCardButtonStyle())
    }
}

// 新闻卡片按钮样式
struct NewsCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    NewsSectionView()
}
