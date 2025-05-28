import SwiftUI

struct AuthView: View {
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isButtonPressed = false
    @EnvironmentObject private var designSystem: DesignSystem
    @EnvironmentObject private var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.3), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Logo
                    Image(systemName: "cube.box")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                        .padding(.top, 50)
                    
                    // 标题
                    Text(isLogin ? "欢迎回来" : "创建账号")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // 切换按钮
                    Picker("Mode", selection: $isLogin) {
                        Text("登录").tag(true)
                        Text("注册").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        if !isLogin {
                            // 用户名输入框（仅注册时显示）
                            CustomTextField(
                                text: $username,
                                placeholder: "用户名",
                                systemImage: "person"
                            )
                        }
                        
                        // 邮箱输入框
                        CustomTextField(
                            text: $email,
                            placeholder: "邮箱",
                            systemImage: "envelope"
                        )
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        
                        // 密码输入框
                        CustomSecureField(
                            text: $password,
                            placeholder: "密码",
                            systemImage: "lock"
                        )
                        
                        if !isLogin {
                            // 确认密码输入框（仅注册时显示）
                            CustomSecureField(
                                text: $confirmPassword,
                                placeholder: "确认密码",
                                systemImage: "lock"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal, 20)
                    }
                    
                    // Cognito错误信息显示
                    if authManager.showError {
                        Text(authManager.errorMessage)
                            .foregroundColor(authManager.errorMessage.contains("🎉") ? .green : .red)
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                    }
                    
                    // 主按钮
                    Button(action: {
                        withAnimation(DesignSystem.Animation.spring) {
                            isButtonPressed = true
                            handleAuthentication()
                        }
                        // 重置按钮状态
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isButtonPressed = false
                        }
                    }) {
                        Text(isLogin ? "登录" : "注册")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(DesignSystem.Layout.CornerRadius.button)
                            .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .appleButton()
                    .animation(DesignSystem.Animation.spring, value: isButtonPressed)
                    
                    // 分隔线和AWS Cognito登录
                    VStack(spacing: 15) {
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            Text("或")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 20)
                        
                        // AWS Cognito登录按钮
                        Button(action: {
                            print("🔘 AWS Cognito button tapped - isLogin: \(isLogin)")
                            if isLogin {
                                authManager.loginWithCognito()
                            } else {
                                authManager.registerWithCognito()
                            }
                        }) {
                            HStack {
                                Image(systemName: "lock.shield")
                                    .font(.system(size: 16))
                                Text(isLogin ? "使用 AWS 登录" : "使用 AWS 注册")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.Layout.CornerRadius.button)
                                    .stroke(Color(red: 76/255, green: 175/255, blue: 80/255), lineWidth: 1.5)
                            )
                            .cornerRadius(DesignSystem.Layout.CornerRadius.button)
                        }
                        .padding(.horizontal, 20)
                        
                        // AWS Cognito诊断按钮
                        Button(action: {
                            authManager.printDiagnostics()
                        }) {
                            HStack {
                                Image(systemName: "wrench.and.screwdriver")
                                    .font(.system(size: 14))
                                Text("AWS 诊断")
                                    .font(.caption)
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    if isLogin {
                        // 忘记密码按钮（仅登录时显示）
                        Button("忘记密码？") {
                            // TODO: 实现忘记密码逻辑
                        }
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func handleAuthentication() {
        showError = false
        
        if isLogin {
            // 登录逻辑
            if authManager.login(email: email, password: password) {
                // 登录成功
                showError = false
            } else {
                showError = true
                errorMessage = "邮箱或密码错误"
            }
        } else {
            // 注册逻辑
            if password != confirmPassword {
                showError = true
                errorMessage = "两次输入的密码不一致"
                return
            }
            // TODO: 实现注册逻辑
            showError = true
            errorMessage = "注册功能暂未实现"
        }
    }
}

// 自定义文本输入框
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

// 自定义密码输入框
struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

#Preview {
    AuthView()
        .environmentObject(DesignSystem())
        .environmentObject(AuthenticationManager())
} 
 