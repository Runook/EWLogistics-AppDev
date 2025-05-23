import SwiftUI

struct TransportServiceView: View {
    @State private var searchText = ""
    @State private var isAnimated = false
    
    // 定义服务商数据
    let services: [[String]] = [
        ["整车", "零担", "专线"],
        ["码头", "提海柜", "回程车"],
        ["AMAZON", "WALMART", "FEDEX"],
        ["UPS", "USPS", "4PX"],
        ["USKY", "WAYFAIR", "NEWEGG"],
        ["SHEIN", "TIKTOK", "TEMU"]
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // 搜索栏
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜索栏", text: $searchText)
                    .font(.system(size: 17))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.red.opacity(0.15), Color.red.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            // 服务商按钮网格
            VStack(spacing: 12) {
                ForEach(services, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { service in
                            Button(action: {
                                // 处理按钮点击
                            }) {
                                Text(service)
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .onAppear {
            withAnimation(DesignSystem.Animation.spring) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    TransportServiceView()
} 