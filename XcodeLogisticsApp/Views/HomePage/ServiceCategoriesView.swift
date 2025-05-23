import SwiftUI

struct ServiceCategoriesView: View {
    @State private var isAnimated = false
    @State private var showTransportService = false
    
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
        VStack(spacing: 0) {
            // 第一行类别
            HStack(spacing: -10) {
                ForEach(0..<row1.count, id: \.self) { index in
                    CategoryItemView(
                        item: row1[index], 
                        index: index, 
                        isAnimated: isAnimated,
                        showTransportService: $showTransportService
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
                        showTransportService: $showTransportService
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
                        showTransportService: $showTransportService
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
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if item.title == "陆运" {
                showTransportService = true
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPressed ? pressedBackgroundColor : backgroundColor)
                
                VStack(spacing: 6) {
                    Image(systemName: item.icon)
                        .font(.system(size: 20))
                        .foregroundColor(isPressed ? pressedTextColor : textColor)
                    
                    Text(item.title)
                        .font(.system(size: 14))
                        .foregroundColor(isPressed ? pressedTextColor : textColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 65)
        }
        .buttonStyle(CategoryButtonStyle(isPressed: $isPressed))
        .opacity(isAnimated ? 1 : 0)
        .scaleEffect(isAnimated ? 0.8 : 1)
        .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
    }
    
    // 根据颜色名称返回正确的背景色
    var backgroundColor: Color {
        switch item.color {
        case "lightGreen1":
            return Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.18)
        case "lightGreen2":
            return Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.22)
        case "lightGreen3":
            return Color(red: 102/255, green: 187/255, blue: 106/255).opacity(0.25)
        default:
            return Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.2)
        }
    }
    
    // 按下时的背景色（更深）
    var pressedBackgroundColor: Color {
        switch item.color {
        case "lightGreen1":
            return Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.35)
        case "lightGreen2":
            return Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.4)
        case "lightGreen3":
            return Color(red: 102/255, green: 187/255, blue: 106/255).opacity(0.45)
        default:
            return Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.4)
        }
    }
    
    // 根据颜色名称返回正确的文字色
    var textColor: Color {
        switch item.color {
        case "lightGreen1":
            return Color(red: 102/255, green: 187/255, blue: 106/255)
        case "lightGreen2":
            return Color(red: 76/255, green: 175/255, blue: 80/255)
        case "lightGreen3":
            return Color(red: 56/255, green: 142/255, blue: 60/255)
        default:
            return Color(red: 76/255, green: 175/255, blue: 80/255)
        }
    }
    
    // 按下时的文字色（更深）
    var pressedTextColor: Color {
        switch item.color {
        case "lightGreen1":
            return Color(red: 76/255, green: 175/255, blue: 80/255)
        case "lightGreen2":
            return Color(red: 56/255, green: 142/255, blue: 60/255)
        case "lightGreen3":
            return Color(red: 46/255, green: 125/255, blue: 50/255)
        default:
            return Color(red: 56/255, green: 142/255, blue: 60/255)
        }
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
