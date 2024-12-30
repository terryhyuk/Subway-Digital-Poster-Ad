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
        
        var body: some View {
            TabView(selection: $selection, content: {
                PredictView()
                    .tabItem({
                        Image(systemName: "people")
                        Text("예상승객")
                    })
                    .tag(1)
                
                QList()
                    .tabItem({
                        Image(systemName: "post")
                        Text("문의하기")
                    })
                    .tag(2)
            })
        }
}

#Preview {
    TabbarView()
}
