import SwiftUI

struct ServiceCategoriesView: View {
    @State private var isAnimated = false
    
    // 服务类别数据
    let row1 = [
        CategoryItem(title: "陆运", color: "red3"),
        CategoryItem(title: "海运", color: "red3"),
        CategoryItem(title: "空运", color: "red3"),
    ]
    
    let row2 = [
        CategoryItem(title: "多式联运", color: "red3"),
        CategoryItem(title: "一件代发", color: "red3"),
        CategoryItem(title: "商家黄页", color: "red3"),
    ]
    
    let row3 = [
        CategoryItem(title: "招聘求职", color: "red3"),
        CategoryItem(title: "物流出租", color: "red3"),
        CategoryItem(title: "物流售卖", color: "red3"),
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // 第一行类别
            HStack(spacing: 8) {
                ForEach(0..<row1.count, id: \.self) { index in
                    CategoryItemView(
                        item: row1[index], 
                        index: index, 
                        isAnimated: isAnimated
                    )
                }
            }
            
            // 第二行类别
            HStack(spacing: 8) {
                ForEach(0..<row2.count, id: \.self) { index in
                    CategoryItemView(
                        item: row2[index], 
                        index: index + 3, 
                        isAnimated: isAnimated
                    )
                }
            }
            
            // 第三行类别
            HStack(spacing: 8) {
                ForEach(0..<row3.count, id: \.self) { index in
                    CategoryItemView(
                        item: row3[index], 
                        index: index + 6, 
                        isAnimated: isAnimated
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

// 类别项目数据模型
struct CategoryItem {
    let title: String
    let color: String
}

// 类别项目视图
struct CategoryItemView: View {
    let item: CategoryItem
    let index: Int
    let isAnimated: Bool
    
    var body: some View {
        Button(action: {
            // 点击处理（实际应用中添加功能）
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                
                Text(item.title)
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 4)
            }
            .frame(height: 65)
        }
        .buttonStyle(CategoryButtonStyle())
        .opacity(isAnimated ? 1 : 0)
        .scaleEffect(isAnimated ? 0.8 : 1)
        .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
    }
    
    // 根据颜色名称返回正确的背景色
    var backgroundColor: Color {
        switch item.color {
        case "red1":
            return Color.red.opacity(0.08)
        case "red2":
            return Color.red.opacity(0.12)
        case "red3":
            return Color.red.opacity(0.16)
        default:
            return Color.red.opacity(0.1)
        }
    }
}

// 类别按钮样式
struct CategoryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: Color.red.opacity(0.1), radius: 3, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ServiceCategoriesView()
}
