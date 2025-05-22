import SwiftUI

struct NewsSectionView: View {
    @State private var isAnimated = false
    
    // 示例新闻数据
    let newsItems = [
        NewsItem(
            title: "物流行业黑名单更新",
            description: "2025年物流行业失信人员名单",
            date: "2025-05-21",
            imageUrl: "news1"
        ),
        NewsItem(
            title: "卡车司机视频直播",
            description: "最新跨境物流政策解读与分析",
            date: "2025-05-20",
            imageUrl: "news2"
        ),
        NewsItem(
            title: "智慧物流发展前景",
            description: "人工智能在物流领域的应用展望",
            date: "2024-03-19",
            imageUrl: "news3"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题栏
            HStack {
                Text("物流资讯")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(DesignSystem.Colors.Label.primary)
                
                Spacer()
                
                Button(action: {
                    // 更多按钮点击事件
                }) {
                    Text("更多")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            // 新闻列表
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(newsItems.enumerated()), id: \.element.id) { index, item in
                        NewsCard(item: item)
                            .opacity(isAnimated ? 1 : 0)
                            .offset(x: isAnimated ? 0 : 50)
                            .animation(
                                DesignSystem.Animation.spring.delay(0.1 * Double(index)),
                                value: isAnimated
                            )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation {
                isAnimated = true
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
    
    var body: some View {
        Button(action: {
            // 新闻点击事件
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // 新闻图片
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
                    .frame(width: 200, height: 120)
                    .overlay(
                        Image(systemName: "newspaper.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    // 新闻标题
                    Text(item.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                        .lineLimit(1)
                    
                    // 新闻描述
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                        .lineLimit(2)
                    
                    // 发布日期
                    Text(item.date)
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.Label.tertiary)
                }
                .padding(.horizontal, 8)
            }
            .frame(width: 200)
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
