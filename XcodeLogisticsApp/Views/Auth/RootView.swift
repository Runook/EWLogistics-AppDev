//
//  RootView.swift
//  东西方物流
//
//  Created by 熙御安 on 5/28/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        if authManager.isAuthenticated {
            FullAppView()
        } else {
            AuthView()
        }
    }
}
