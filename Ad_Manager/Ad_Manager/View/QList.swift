//
//  QList.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/29/24.
//

import SwiftUI

struct QList: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var selectedStation: String = "전체"
    let stations = ["전체", "강남", "잠실", "홍대입구"]

    var filteredPosts: [Post] {
        if selectedStation == "전체" {
            return firestoreManager.posts
        }
        return firestoreManager.posts.filter { $0.station == selectedStation }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Menu {
                        ForEach(stations, id: \.self) { station in
                            Button(station) {
                                withAnimation {
                                    selectedStation = station
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedStation)
                            Image(systemName: "chevron.down")
                        }
                        .frame(width: 125, height: 30)
                        .foregroundStyle(.black)
                        .scrollContentBackground(.hidden)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 0.6)
                        )
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                // 필터링된 리스트
                List(filteredPosts) { post in
                    NavigationLink(destination: Answer(post: post)) {
                        HStack(spacing: 20) {
                            Text(post.station)
                                .frame(width: 70)
                                .padding(.vertical)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.writeTime)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 130, alignment: .leading)
                            VStack(spacing: 9) {
                                Text(post.author)
                                    .font(.subheadline)
                                Text(post.isAnswer ? "답변완료" : "답변대기")
                                    .font(.caption)
                                    .foregroundColor(post.isAnswer ? .green : .gray)
                            }
                            .frame(width: 80)
                        }
                    }
                }
            }
            .navigationTitle("Q&A 목록")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar, content: {
                    NavigationLink(destination: InsertPost(), label: {
                        Image(systemName: "plus.circle")
                        Text("문의하기")
                    })
                })
            })
            .onAppear {
                firestoreManager.fetchPosts()
            }
        }
    }
}

#Preview {
    QList()
}
