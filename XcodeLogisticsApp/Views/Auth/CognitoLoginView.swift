//
//  CognitoLoginView.swift
//  东西方物流
//
//  Created by 熙御安 on 5/28/25.
//

import SwiftUI
import AuthenticationServices

struct CognitoLoginView: View {
    @State private var authSession: ASWebAuthenticationSession?

    var body: some View {
        Button("使用 Cognito 登录") {
            startCognitoLogin()
        }
        .padding()
    }

    func startCognitoLogin() {
        let clientId = "3rr0e53q70up5jekt8t9ltbtj"
        let redirectUri = "ewlogisticsapp://callback"
        let domain = "us-east-1485fdc354.auth.us-east-1.amazoncognito.com" // 如 myapp.auth.us-east-1.amazoncognito.com
        let responseType = "token"  // 可选 "code" 或 "token"，推荐 token（免 server）

        let urlString = "https://\(domain)/login?response_type=\(responseType)&client_id=\(clientId)&redirect_uri=\(redirectUri)"
        guard let authUrl = URL(string: urlString) else { return }

        let session = ASWebAuthenticationSession(
            url: authUrl,
            callbackURLScheme: "ewlogisticsapp"  // 只写 scheme，无需路径
        ) { callbackURL, error in
            guard let callbackURL = callbackURL else {
                print("Login canceled or failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // 提取 token
            if let fragment = callbackURL.fragment {
                let tokenParams = fragment.components(separatedBy: "&").reduce(into: [String: String]()) { dict, param in
                    let pair = param.components(separatedBy: "=")
                    if pair.count == 2 {
                        dict[pair[0]] = pair[1]
                    }
                }
                print("🔐 Tokens from Cognito:")
                print("Access token: \(tokenParams["access_token"] ?? "")")
                print("ID token: \(tokenParams["id_token"] ?? "")")
                print("Refresh token: \(tokenParams["refresh_token"] ?? "")")
            }
        }

        session.presentationContextProvider = UIApplication.shared.windows.first?.rootViewController as? ASWebAuthenticationPresentationContextProviding
        session.prefersEphemeralWebBrowserSession = true
        session.start()

        self.authSession = session  // 保留引用避免释放
    }
}
