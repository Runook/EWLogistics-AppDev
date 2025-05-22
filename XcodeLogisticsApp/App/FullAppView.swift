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
                gradient: Gradient(colors: [Color.red.opacity(0.2), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView()
                LocationInputsView()
                ServiceCategoriesView()
                NewsSectionView()
                Spacer()
                BottomNavigationView(selectedTab: <#Binding<Int>#>)
            }
        }
    }
}

#Preview {
    FullAppView()
        .environmentObject(DesignSystem())
}
