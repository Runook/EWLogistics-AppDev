# AppAuth-iOS Integration Guide for AWS Cognito

## 概述

基于您提供的代码，我们可以使用AppAuth-iOS库来实现更安全和标准的OAuth流程。

## 1. 添加AppAuth-iOS依赖

### 使用Swift Package Manager

1. 在Xcode中打开项目
2. 选择 `File` → `Add Package Dependencies...`
3. 输入URL: `https://github.com/openid/AppAuth-iOS`
4. 点击 `Add Package`

### 或者手动添加到Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/openid/AppAuth-iOS", from: "1.6.0")
]
```

## 2. 更新的配置信息

根据您提供的信息，我们已经更新了`CognitoConfig.swift`：

```swift
// 正确的OIDC Issuer URL
static let issuer = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_485fDc354"

// Client ID
static let clientId = "3rr0e53q70up5jekt8t9ltbtj"

// 回调URI
static let redirectUri = "ewlogisticsapp://callback"
static let logoutUri = "ewlogisticsapp://callback"
```

## 3. AppAuth-iOS实现示例

### 导入库

```swift
import AppAuth
import AuthenticationServices
```

### 实现OAuth流程

```swift
class AppAuthManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var authState: OIDAuthState?
    @Published var errorMessage = ""
    
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    func authenticateWithCognito() {
        // 1. 发现配置
        guard let issuerURL = URL(string: CognitoConfig.issuer) else {
            errorMessage = "Invalid issuer URL"
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuerURL) { [weak self] configuration, error in
            DispatchQueue.main.async {
                guard let config = configuration else {
                    self?.errorMessage = "Error retrieving discovery document: \(error?.localizedDescription ?? "Unknown error")"
                    return
                }
                self?.performAuthRequest(with: config)
            }
        }
    }
    
    private func performAuthRequest(with configuration: OIDServiceConfiguration) {
        // 2. 构建认证请求
        guard let redirectURL = URL(string: CognitoConfig.redirectUri) else {
            errorMessage = "Invalid redirect URI"
            return
        }
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: CognitoConfig.clientId,
            scopes: CognitoConfig.scopes,
            redirectURL: redirectURL,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        
        // 3. 执行认证流程
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let presentingViewController = window.rootViewController else {
            errorMessage = "Cannot find presenting view controller"
            return
        }
        
        currentAuthorizationFlow = OIDAuthState.authState(
            byPresenting: request,
            presenting: presentingViewController
        ) { [weak self] authState, error in
            DispatchQueue.main.async {
                if let authState = authState {
                    self?.authState = authState
                    self?.isAuthenticated = true
                    print("Got authorization tokens. Access token: \(authState.lastTokenResponse?.accessToken ?? "NO_TOKEN")")
                } else {
                    self?.errorMessage = "Authorization error: \(error?.localizedDescription ?? "Unknown error")"
                    print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func getUserInfo() {
        guard let authState = authState,
              let userinfoEndpoint = authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint else {
            errorMessage = "Userinfo endpoint not declared in discovery document"
            return
        }
        
        authState.performAction { [weak self] accessToken, idToken, error in
            guard let accessToken = accessToken else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No access token available"
                }
                return
            }
            
            var urlRequest = URLRequest(url: userinfoEndpoint)
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "Network error: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let data = data else {
                        self?.errorMessage = "No data received"
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("User info success: \(json)")
                        }
                    } catch {
                        self?.errorMessage = "JSON Serialization Error: \(error.localizedDescription)"
                    }
                }
            }
            task.resume()
        }
    }
    
    func logout() {
        guard let authState = authState,
              let endSessionEndpoint = authState.lastAuthorizationResponse.request.configuration.discoveryDocument?.endSessionEndpoint else {
            print("EndSession endpoint not declared in discovery document")
            performLocalLogout()
            return
        }
        
        // 构建登出URL
        var components = URLComponents(url: endSessionEndpoint, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: CognitoConfig.clientId),
            URLQueryItem(name: "logout_uri", value: CognitoConfig.logoutUri)
        ]
        
        if let logoutURL = components.url {
            UIApplication.shared.open(logoutURL, options: [:]) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.performLocalLogout()
                    } else {
                        self?.errorMessage = "Failed to open logout URL"
                    }
                }
            }
        }
    }
    
    private func performLocalLogout() {
        authState = nil
        isAuthenticated = false
        errorMessage = ""
        currentAuthorizationFlow = nil
    }
}
```

## 4. 在SwiftUI中使用

```swift
struct AuthView: View {
    @StateObject private var appAuthManager = AppAuthManager()
    
    var body: some View {
        VStack {
            if appAuthManager.isAuthenticated {
                VStack {
                    Text("已登录!")
                        .foregroundColor(.green)
                    
                    Button("获取用户信息") {
                        appAuthManager.getUserInfo()
                    }
                    
                    Button("登出") {
                        appAuthManager.logout()
                    }
                }
            } else {
                Button("使用AppAuth登录") {
                    appAuthManager.authenticateWithCognito()
                }
            }
            
            if !appAuthManager.errorMessage.isEmpty {
                Text(appAuthManager.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}
```

## 5. 更新Info.plist

确保您的URL Scheme已正确配置：

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>ewlogisticsapp</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>ewlogisticsapp</string>
        </array>
    </dict>
</array>
```

## 6. AppAuth vs ASWebAuthenticationSession对比

### AppAuth-iOS 优势:
- ✅ **标准合规**: 完全符合OAuth 2.0和OIDC标准
- ✅ **自动发现**: 使用OIDC Discovery自动获取端点
- ✅ **安全性**: 支持PKCE，更安全的流程
- ✅ **Token管理**: 自动处理token刷新
- ✅ **跨平台**: iOS和macOS支持

### ASWebAuthenticationSession 优势:
- ✅ **简单**: 系统自带，无需额外依赖
- ✅ **轻量**: 适合简单的OAuth流程

## 7. 推荐

对于生产环境，强烈推荐使用AppAuth-iOS，因为它提供了更完整和安全的OAuth实现。

## 8. AWS Cognito控制台配置

确保在AWS Cognito控制台中配置：

1. **App Client回调URLs**:
   - `ewlogisticsapp://callback`
   - `ewlogisticsapp://`

2. **OAuth 2.0 flows**:
   - ✅ Authorization code grant (AppAuth推荐)
   - ✅ Implicit grant (备选)

3. **OAuth 2.0 scopes**:
   - ✅ openid
   - ✅ email
   - ✅ profile

4. **Domain**: 确保域名 `us-east-1485fdc354.auth.us-east-1.amazoncognito.com` 已激活 