//
//  TabbarView.swift
//  Ad_Manager
//
//  Created by 노민철 on 12/30/24.
//

import SwiftUI

struct TabbarView: View {
    // 탭 번호
    @State var selection = 0
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        TabView(selection: $selection, content: {
            PredictView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("예상승객")
                }
                .tag(0)

            QList()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("문의하기")
                }
                .tag(1)
        })
        .navigationTitle(getNavigationTitle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .onTapGesture {
                        loginManager.logout()
                    }
            })
        }
    }
    
    private func getNavigationTitle() -> String {
        switch selection {
        case 0:
            return "예상승객"
        case 1:
            return "Q&A 목록"
        default:
            return ""
        }
    }
}

#Preview {
    TabbarView()
}
