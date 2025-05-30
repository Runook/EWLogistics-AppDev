import SwiftUI

struct LocationInputsView: View {
    @State private var startLocation = ""
    @State private var endLocation = ""
    @State private var isAnimated = false
    @State private var showCargoDetails = false
    
    var body: some View {
        VStack(spacing: 12) {
            // 起点输入框
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(red: 102/255, green: 187/255, blue: 106/255))
                    .frame(width: 8, height: 8)
                
                TextField("输入起点[邮编]", text: $startLocation)
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.Label.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.25)
            )

            .cornerRadius(10)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            // 终点输入框
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(red: 76/255, green: 175/255, blue: 80/255))
                    .frame(width: 8, height: 8)
                
                TextField("输入终点[邮编]", text: $endLocation)
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.Label.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.25)
            )

            .cornerRadius(10)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            // 货物详情按钮
            Button(action: {
                showCargoDetails = true
            }) {
                HStack {
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 16))
                    Text("货物详情")
                        .font(.system(size: 16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
            }
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .onAppear {
            withAnimation(DesignSystem.Animation.spring) {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showCargoDetails) {
            CargoDetailsView()
        }
    }
}

// 货物详情视图
struct CargoDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("货物名称", text: .constant(""))
                    TextField("货物重量 (kg)", text: .constant(""))
                    TextField("货物体积 (m³)", text: .constant(""))
                }
                
                Section(header: Text("特殊要求")) {
                    Toggle("需要冷藏", isOn: .constant(false))
                    Toggle("易碎品", isOn: .constant(false))
                    Toggle("危险品", isOn: .constant(false))
                }
                
                Section(header: Text("备注")) {
                    TextEditor(text: .constant(""))
                        .frame(height: 100)
                }
            }
            .navigationTitle("货物详情")
            .navigationBarItems(trailing: Button("完成") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255)))
        }
    }
}

#Preview {
    LocationInputsView()
}
