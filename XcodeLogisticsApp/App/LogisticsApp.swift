import SwiftUI
import AuthenticationServices
import UIKit

class AuthenticationManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var idToken: String? = nil
    @Published var accessToken: String? = nil
    @Published var authSession: ASWebAuthenticationSession?
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // 简单登录方法（用于演示，实际应该调用Cognito）
    func login(email: String, password: String) -> Bool {
        // 简单的测试登录
        if email == "123" && password == "123" {
            isAuthenticated = true
            return true
        }
        // 实际环境中应该调用Cognito登录
        return false
    }
    
    // AWS Cognito登录 - 使用OAuth URL
    func loginWithCognito() {
        guard CognitoConfig.isConfigured else {
            showErrorMessage("❌ Cognito配置未完成，请在CognitoConfig.swift中设置正确的域名")
            return
        }
        
        // 打印所有配置信息
        print("🔧 AWS Cognito配置信息:")
        CognitoConfig.printAllURLs()
        
        let authUrlString = CognitoConfig.oauthURL
        print("🔗 使用的OAuth URL: \(authUrlString)")
        
        guard let authUrl = URL(string: authUrlString) else { 
            showErrorMessage("❌ Invalid Cognito OAuth URL")
            return 
        }
        
        let session = ASWebAuthenticationSession(
            url: authUrl,
            callbackURLScheme: "ewlogisticsapp"
        ) { [weak self] callbackURL, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ ASWebAuthenticationSession错误: \(error)")
                    self?.showErrorMessage("认证错误: \(error.localizedDescription)")
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    self?.showErrorMessage("认证被取消或失败")
                    return
                }
                
                print("🔙 收到回调URL: \(callbackURL.absoluteString)")
                self?.saveTokens(from: callbackURL)
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false // 改为false以便调试
        session.start()
        
        self.authSession = session
    }
    
    // AWS Cognito注册 - 使用OAuth URL
    func registerWithCognito() {
        guard CognitoConfig.isConfigured else {
            showErrorMessage("❌ Cognito配置未完成，请在CognitoConfig.swift中设置正确的域名")
            return
        }
        
        let authUrlString = CognitoConfig.signupURL
        print("🔗 Cognito Signup URL: \(authUrlString)")
        
        guard let authUrl = URL(string: authUrlString) else {
            showErrorMessage("❌ Invalid Cognito signup URL")
            return
        }
        
        let session = ASWebAuthenticationSession(
            url: authUrl,
            callbackURLScheme: "ewlogisticsapp"
        ) { [weak self] callbackURL, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showErrorMessage("注册错误: \(error.localizedDescription)")
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    self?.showErrorMessage("注册被取消或失败")
                    return
                }
                
                print("🔙 Callback URL: \(callbackURL.absoluteString)")
                self?.saveTokens(from: callbackURL)
            }
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false
        session.start()
        
        self.authSession = session
    }

    func saveTokens(from callbackURL: URL) {
        print("🔍 完整回调URL: \(callbackURL.absoluteString)")
        print("🔍 URL scheme: \(callbackURL.scheme ?? "nil")")
        print("🔍 URL host: \(callbackURL.host ?? "nil")")
        print("🔍 URL path: \(callbackURL.path)")
        print("🔍 URL query: \(callbackURL.query ?? "nil")")
        print("🔍 URL fragment: \(callbackURL.fragment ?? "nil")")
        
        // 检查是否有错误参数
        var errorParams: [String: String] = [:]
        
        // 首先检查fragment中的错误
        if let fragment = callbackURL.fragment {
            errorParams = fragment
                .components(separatedBy: "&")
                .reduce(into: [String: String]()) { dict, pair in
                    let parts = pair.components(separatedBy: "=")
                    if parts.count == 2 {
                        dict[parts[0]] = parts[1].removingPercentEncoding ?? parts[1]
                    }
                }
        }
        
        // 如果fragment中没有错误，检查query
        if errorParams.isEmpty, let query = callbackURL.query {
            errorParams = query
                .components(separatedBy: "&")
                .reduce(into: [String: String]()) { dict, pair in
                    let parts = pair.components(separatedBy: "=")
                    if parts.count == 2 {
                        dict[parts[0]] = parts[1].removingPercentEncoding ?? parts[1]
                    }
                }
        }
        
        // 处理AWS Cognito错误
        if let error = errorParams["error"] {
            let errorDescription = errorParams["error_description"] ?? "Unknown error"
            print("❌ AWS Cognito返回错误: \(error)")
            print("❌ 错误描述: \(errorDescription)")
            
            // 针对不同错误提供具体指导
            var userMessage = "AWS Cognito错误: \(errorDescription)"
            
            switch error {
            case "invalid_request", "unauthorized_client":
                userMessage = """
                🚫 AWS Cognito配置错误
                
                错误: \(errorDescription)
                
                请在AWS控制台中检查:
                1. App Client回调URL已添加: ewlogisticsapp://callback
                2. 启用OAuth流程: Implicit grant
                3. 启用范围: openid, email, profile
                4. 确保域名已激活
                """
                // 打印详细诊断信息
                CognitoConfig.printDiagnostics()
                
            case "access_denied":
                userMessage = "用户拒绝了授权请求"
                
            case "invalid_scope":
                userMessage = "OAuth范围配置错误，请检查AWS Cognito中的范围设置"
                
            default:
                userMessage = "AWS Cognito错误: \(error) - \(errorDescription)"
            }
            
            showErrorMessage(userMessage)
            return
        }
        
        // 尝试从fragment解析token
        var tokenParams: [String: String] = [:]
        
        if let fragment = callbackURL.fragment {
            print("🔍 解析Fragment: \(fragment)")
            tokenParams = fragment
                .components(separatedBy: "&")
                .reduce(into: [String: String]()) { dict, pair in
                    let parts = pair.components(separatedBy: "=")
                    if parts.count == 2 {
                        let key = parts[0]
                        let value = parts[1].removingPercentEncoding ?? parts[1]
                        dict[key] = value
                        print("  🔑 \(key): \(value)")
                    }
                }
        }
        
        // 如果fragment中没有token，尝试从query中解析
        if tokenParams.isEmpty, let query = callbackURL.query {
            print("🔍 Fragment中没有token，尝试解析Query: \(query)")
            tokenParams = query
                .components(separatedBy: "&")
                .reduce(into: [String: String]()) { dict, pair in
                    let parts = pair.components(separatedBy: "=")
                    if parts.count == 2 {
                        let key = parts[0]
                        let value = parts[1].removingPercentEncoding ?? parts[1]
                        dict[key] = value
                        print("  🔑 \(key): \(value)")
                    }
                }
        }
        
        // 提取tokens
        self.idToken = tokenParams["id_token"]
        self.accessToken = tokenParams["access_token"]
        let refreshToken = tokenParams["refresh_token"]
        
        print("🔐 解析结果:")
        print("  Access token: \(accessToken?.prefix(20) ?? "nil")...")
        print("  ID token: \(idToken?.prefix(20) ?? "nil")...")
        print("  Refresh token: \(refreshToken?.prefix(20) ?? "nil")...")
        
        // 检查是否有任何有效的token
        if let accessToken = accessToken, !accessToken.isEmpty {
            self.isAuthenticated = true
            showErrorMessage("🎉 登录成功！(Access Token)")
        } else if let idToken = idToken, !idToken.isEmpty {
            self.isAuthenticated = true
            showErrorMessage("🎉 登录成功！(ID Token)")
        } else if let authCode = tokenParams["code"] {
            // 如果返回的是授权码而不是token
            print("🔍 收到授权码: \(authCode)")
            showErrorMessage("收到授权码，需要交换token（暂未实现）")
        } else {
            showErrorMessage("认证失败：未获取到有效token。请检查AWS Cognito配置。")
            print("❌ 所有token参数: \(tokenParams)")
        }
    }
    
    private func showErrorMessage(_ message: String) {
        print(message)
        errorMessage = message
        showError = true
        
        // 3秒后自动隐藏错误信息
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showError = false
        }
    }
    
    // 诊断AWS Cognito配置
    func printDiagnostics() {
        print("\n" + String(repeating: "=", count: 50))
        CognitoConfig.printDiagnostics()
        print(String(repeating: "=", count: 50) + "\n")
    }

    func logout() {
        isAuthenticated = false
        idToken = nil
        accessToken = nil
        authSession = nil
        showError = false
        errorMessage = ""
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension AuthenticationManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // 修复iOS 15+ 兼容性问题
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window
        }
        // 备用方案
        return UIWindow()
    }
}


@main
struct LogisticsApp: App {
    @StateObject private var designSystem = DesignSystem()
    @StateObject private var authManager = AuthenticationManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(designSystem)
                .preferredColorScheme(.light)
                .onOpenURL { url in
                    // 处理深层链接回调
                    print("📱 App received URL: \(url.absoluteString)")
                    if url.scheme == "ewlogisticsapp" {
                        authManager.saveTokens(from: url)
                    }
                }
        }
    }
}

