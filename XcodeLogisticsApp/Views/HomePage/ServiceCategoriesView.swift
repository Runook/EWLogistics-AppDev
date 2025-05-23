import SwiftUI

struct ServiceCategoriesView: View {
    @State private var isAnimated = false
    @State private var showTransportService = false
    @State private var showRecruitmentPage = false
    
    // 服务类别数据
    let row1 = [
        CategoryItem(title: "陆运", color: "lightGreen3", icon: "truck.box.fill"),
        CategoryItem(title: "海运", color: "lightGreen3", icon: "ferry.fill"),
        CategoryItem(title: "空运", color: "lightGreen3", icon: "airplane"),
    ]
    
    let row2 = [
        CategoryItem(title: "多式联运", color: "lightGreen3", icon: "arrow.triangle.swap"),
        CategoryItem(title: "一件代发", color: "lightGreen3", icon: "shippingbox.fill"),
        CategoryItem(title: "商家黄页", color: "lightGreen3", icon: "person.2.fill"),
    ]
    
    let row3 = [
        CategoryItem(title: "招聘求职", color: "lightGreen3", icon: "person.badge.plus.fill"),
        CategoryItem(title: "物流出租", color: "lightGreen3", icon: "house.fill"),
        CategoryItem(title: "物流售卖", color: "lightGreen3", icon: "cart.fill"),
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // 第一行类别
            HStack(spacing: -10) {
                ForEach(0..<row1.count, id: \.self) { index in
                    CategoryItemView(
                        item: row1[index], 
                        index: index, 
                        isAnimated: isAnimated,
                        showTransportService: $showTransportService,
                        showRecruitmentPage: $showRecruitmentPage
                    )
                }
            }
            
            // 第二行类别
            HStack(spacing: -10) {
                ForEach(0..<row2.count, id: \.self) { index in
                    CategoryItemView(
                        item: row2[index], 
                        index: index + 3, 
                        isAnimated: isAnimated,
                        showTransportService: $showTransportService,
                        showRecruitmentPage: $showRecruitmentPage
                    )
                }
            }
            
            // 第三行类别
            HStack(spacing: -10) {
                ForEach(0..<row3.count, id: \.self) { index in
                    CategoryItemView(
                        item: row3[index], 
                        index: index + 6, 
                        isAnimated: isAnimated,
                        showTransportService: $showTransportService,
                        showRecruitmentPage: $showRecruitmentPage
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showTransportService) {
            TransportServiceView()
        }
        .sheet(isPresented: $showRecruitmentPage) {
            RecruitmentView()
        }
    }
}

// 类别项目数据模型
struct CategoryItem {
    let title: String
    let color: String
    let icon: String
}

// 类别项目视图
struct CategoryItemView: View {
    let item: CategoryItem
    let index: Int
    let isAnimated: Bool
    @Binding var showTransportService: Bool
    @Binding var showRecruitmentPage: Bool
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if item.title == "陆运" {
                showTransportService = true
            } else if item.title == "招聘求职" {
                showRecruitmentPage = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(isPressed ? pressedBackgroundColor : backgroundColor)
                
                VStack(spacing: 8) {
                    Image(systemName: item.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(isPressed ? pressedTextColor : textColor)
                    
                    Text(item.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isPressed ? pressedTextColor : textColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, 6)
            }
            .frame(height: 85)
        }
        .buttonStyle(CategoryButtonStyle(isPressed: $isPressed))
        .opacity(isAnimated ? 1 : 0)
        .scaleEffect(isAnimated ? 0.8 : 1)
        .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
    }
    
    // 根据颜色名称返回正确的背景色
    var backgroundColor: Color {
        // 使用深亮绿色，像高速公路标志一样醒目
        return Color(red: 34/255, green: 139/255, blue: 34/255) // 森林绿色
    }
    
    // 按下时的背景色（更深）
    var pressedBackgroundColor: Color {
        // 按下时使用更深的绿色
        return Color(red: 25/255, green: 100/255, blue: 25/255) // 更深的森林绿色
    }
    
    // 根据颜色名称返回正确的文字色
    var textColor: Color {
        // 使用白色，确保在绿色背景上清晰可见
        return Color.white
    }
    
    // 按下时的文字色（保持白色）
    var pressedTextColor: Color {
        // 按下时保持白色，稍微透明
        return Color.white.opacity(0.9)
    }
}

// 类别按钮样式
struct CategoryButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: Color(red: 102/255, green: 187/255, blue: 106/255).opacity(0.2), radius: 3, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { pressed in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressed
                }
            }
    }
}

#Preview {
    ServiceCategoriesView()
}
