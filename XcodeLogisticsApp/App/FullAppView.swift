//
//  FullAppView.swift
//  XcodeLogisticsApp
//
//  Created by 熙御安 on 5/21/25.
//

import SwiftUI

struct FullAppView: View {
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.3), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            MainTabView()
        }
    }
}

#Preview {
    FullAppView()
        .environmentObject(DesignSystem())
}
