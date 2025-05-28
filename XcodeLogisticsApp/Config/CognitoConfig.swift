//
//  CognitoConfig.swift
//  东西方物流
//
//  Created by 熙御安 on 5/28/25.
//

import Foundation

struct CognitoConfig {
    // AWS Cognito 配置 - 来自用户提供的正确信息
    static let clientId = "3rr0e53q70up5jekt8t9ltbtj"
    static let redirectUri = "ewlogisticsapp://callback"
    static let logoutUri = "ewlogisticsapp://callback"
    static let redirectUriAlternative = "ewlogisticsapp://" // 备选回调URL
    
    // OIDC Issuer URL - 用于自动发现端点
    static let issuer = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_485fDc354"
    
    // 传统域名（用于手动构建URL的备选方案）
    static let domain = "us-east-1485fdc354.auth.us-east-1.amazoncognito.com"
    
    // 获取当前使用的回调URL
    static var currentRedirectUri: String {
        return redirectUri
    }
    
    // OAuth 范围 - 修复invalid_scope错误
    static let scopes = ["openid", "email", "profile"]
    static let scopesString = "openid email profile"
    
    // 不同的scope编码格式尝试
    static let scopesStringEncoded = "openid+email+profile"
    static let scopesStringSpaceEncoded = "openid%20email%20profile"
    static let scopesMinimal = "openid"
    static let scopesMinimalEncoded = "openid"
    
    // AppAuth-iOS 配置信息
    static var appAuthConfig: [String: String] {
        return [
            "issuer": issuer,
            "clientId": clientId,
            "redirectUri": redirectUri,
            "logoutUri": logoutUri,
            "scopes": scopesString
        ]
    }
    
    // 传统 Cognito URLs (作为备选方案) - 使用最小scope
    static var loginURL: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/login?response_type=token&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesMinimal)"
    }
    
    static var signupURL: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/signup?response_type=token&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesMinimal)"
    }
    
    // OAuth授权URL（Implicit Grant - 返回token）- 使用最小scope先测试
    static var oauthURL: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/oauth2/authorize?response_type=token&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesMinimal)"
    }
    
    // OAuth授权URL - 使用空格编码的scope
    static var oauthURLSpaceEncoded: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/oauth2/authorize?response_type=token&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesStringSpaceEncoded)"
    }
    
    // OAuth授权URL - 使用完整scope但加号编码
    static var oauthURLPlusEncoded: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/oauth2/authorize?response_type=token&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesStringEncoded)"
    }
    
    // 授权码模式URL（Authorization Code Grant - 返回授权码）
    static var oauthCodeURL: String {
        let encodedRedirectUri = currentRedirectUri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentRedirectUri
        return "https://\(domain)/oauth2/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(encodedRedirectUri)&scope=\(scopesMinimal)"
    }
    
    // 验证配置是否有效
    static var isConfigured: Bool {
        return !issuer.isEmpty && !clientId.isEmpty && !redirectUri.isEmpty
    }
    
    // 调试用：打印所有配置信息
    static func printAllURLs() {
        print("🔗 AWS Cognito配置信息:")
        print("  OIDC Issuer: \(issuer)")
        print("  Client ID: \(clientId)")
        print("  Redirect URI: \(redirectUri)")
        print("  Logout URI: \(logoutUri)")
        print("  Scopes: \(scopesString)")
        print("")
        print("🔗 测试URL配置:")
        print("  Domain: \(domain)")
        print("  OAuth URL (minimal): \(oauthURL)")
        print("  OAuth URL (space encoded): \(oauthURLSpaceEncoded)")
        print("  OAuth URL (plus encoded): \(oauthURLPlusEncoded)")
        print("  Login URL: \(loginURL)")
        print("  Signup URL: \(signupURL)")
        print("  OAuth Code URL: \(oauthCodeURL)")
        print("  Alternative Redirect URI: \(redirectUriAlternative)")
    }
    
    // AWS Cognito配置诊断
    static func printDiagnostics() {
        print("🔧 AWS Cognito配置诊断:")
        print("  OIDC Issuer: \(issuer)")
        print("  Client ID: \(clientId)")
        print("  Redirect URI: \(redirectUri)")
        print("  Logout URI: \(logoutUri)")
        print("  Domain: \(domain)")
        print("  Scopes: \(scopesString)")
        print("")
        print("⚠️  检测到 'invalid_scope' 错误，尝试以下解决方案:")
        print("  1. 在AWS Cognito控制台 > App Client Settings中:")
        print("     - 确保启用 Cognito User Pool")
        print("     - 确保回调URL中添加: \(redirectUri)")
        print("     - 确保回调URL中添加: \(redirectUriAlternative)")
        print("  2. 在OAuth 2.0设置中:")
        print("     - 启用 Authorization code grant 或 Implicit grant")
        print("     - 在 'Allowed OAuth Scopes' 中勾选: openid, email, profile")
        print("  3. 确保域名已激活: \(domain)")
        print("  4. 确保User Pool ID正确: us-east-1_485fDc354")
        print("")
        print("🧪 测试URL (使用最小scope):")
        print("   \(oauthURL)")
        print("")
        print("💡 推荐使用AppAuth-iOS库进行更安全的OAuth流程")
        print("   Issuer URL: \(issuer)")
    }
} 