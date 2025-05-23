import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    
    func login(email: String, password: String) -> Bool {
        // 测试账号验证
        if email == "123" && password == "123" {
            isAuthenticated = true
            return true
        }
        return false
    }
    
    func logout() {
        isAuthenticated = false
    }
}

@main
struct LogisticsApp: App {
    @StateObject private var designSystem = DesignSystem()
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
            FullAppView()
                .environmentObject(designSystem)
                    .environmentObject(authManager)
                    .preferredColorScheme(.light)
            } else {
                AuthView()
                    .environmentObject(designSystem)
                    .environmentObject(authManager)
                    .preferredColorScheme(.light)
            }
        }
    }
}
