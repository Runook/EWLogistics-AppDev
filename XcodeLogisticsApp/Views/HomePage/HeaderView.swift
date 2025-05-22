import SwiftUI

struct HeaderView: View {
    @State private var searchText = ""
    @State private var showLocationSheet = false
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // 位置按钮
                Button(action: {
                    showLocationSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                        
                        Text("定位地址")
                            .font(.system(size: 17))
                            .foregroundColor(DesignSystem.Colors.Label.primary)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(ScaleButtonStyle())
                
                // 搜索框
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundColor(Color.red.opacity(0.6))
                    
                    TextField("搜索栏", text: $searchText)
                        .font(.system(size: 17))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(DesignSystem.Colors.Fill.tertiary)
                .cornerRadius(10)
                .opacity(isAnimated ? 1 : 0)
                .scaleEffect(isAnimated ? 1 : 0.8, anchor: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                BlurView(style: .systemThinMaterial)
            )
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(DesignSystem.Colors.separator)
                    .opacity(0.8),
                alignment: .bottom
            )
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.spring) {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showLocationSheet) {
            LocationPickerView()
        }
    }
}

// 位置选择器页面
struct LocationPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Text("当前位置")
                Text("上海市")
                Text("北京市")
                Text("广州市")
                Text("深圳市")
            }
            .navigationTitle("选择地点")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.red))
        }
    }
}

// 按钮缩放效果
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    HeaderView()
}
