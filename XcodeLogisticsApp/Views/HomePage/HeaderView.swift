import SwiftUI

struct HeaderView: View {
    @State private var searchText = ""
    @State private var showLocationSheet = false
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 47) // 为状态栏添加空间
            
            VStack(spacing: 16) {
                // 顶部问候和通知
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("早上好 👋")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.Label.primary)
                        
                        Text("找到最适合的物流服务")
                            .font(.system(size: 14))
                            .foregroundColor(DesignSystem.Colors.Label.secondary)
                    }
                    
                    Spacer()
                    
                    // 通知图标
                    Button(action: {
                        // 通知功能
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "bell")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                        }
                    }
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 搜索栏和位置
                VStack(spacing: 12) {
                    // 主搜索框
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                        
                        TextField("搜索物流服务、公司、路线...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundColor(DesignSystem.Colors.Label.primary)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignSystem.Colors.Label.tertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .scaleEffect(isAnimated ? 1 : 0.95)
                    
                    // 位置选择器
                    Button(action: {
                        showLocationSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                            
                            Text("当前位置")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(DesignSystem.Colors.Label.primary)
                            
                            Text("上海市")
                                .font(.system(size: 15))
                                .foregroundColor(DesignSystem.Colors.Label.secondary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(DesignSystem.Colors.Label.tertiary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 248/255, green: 249/255, blue: 250/255))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(
            // 简洁的纯色背景
            Rectangle()
                .fill(Color(red: 250/255, green: 252/255, blue: 253/255))
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
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
            .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255)))
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
