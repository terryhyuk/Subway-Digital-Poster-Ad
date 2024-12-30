//
//  QList.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/29/24.
//

import SwiftUI

struct QList: View {
    @StateObject private var firestoreManager = FirestoreManager()
    
    var body: some View {
        NavigationStack {
            List(firestoreManager.posts) { post in
                NavigationLink(destination: Answer(post: post)){
                    HStack(spacing: 20, content: {
                        Text(post.station)
                            .frame(width: 30)
                            .padding()
                        VStack(spacing: 8, content: {
                            Text(post.title)
                                .font(.headline)
                            
                            Text(String(post.writeTime))
                                .font(.caption)
                                .foregroundColor(.gray)
                        })
                        .frame(width: 130, alignment: .leading)
                        VStack(content: {
                            Text(post.author)
                                .font(.subheadline)
                            
                            Text(post.isAnswer ? "답변완료" : "답변대기")
                                .font(.caption)
                                .foregroundColor(post.isAnswer ? .green : .gray)
                        })
                        .frame(width: 80)
                    })
                }
            }
            .navigationTitle("Q&A 목록")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                firestoreManager.fetchPosts()
            }
        }
    }
}

#Preview {
    QList()
}
