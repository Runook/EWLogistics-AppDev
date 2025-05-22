import SwiftUI

struct LocationInputsView: View {
    @State private var startLocation = ""
    @State private var endLocation = ""
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 12) {
            // 起点输入框
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                
                TextField("请输入起点", text: $startLocation)
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.Label.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(DesignSystem.Colors.Fill.tertiary)
            .cornerRadius(10)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 10)
            
            // 终点输入框
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 8, height: 8)
                
                TextField("请输入终点", text: $endLocation)
                    .font(.system(size: 17))
                    .foregroundColor(DesignSystem.Colors.Label.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(DesignSystem.Colors.Fill.tertiary)
            .cornerRadius(10)
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
    }
}

#Preview {
    LocationInputsView()
}
