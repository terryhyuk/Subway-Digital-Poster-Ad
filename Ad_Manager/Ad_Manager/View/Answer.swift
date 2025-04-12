//
//  Answer.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/26/24.
//

import SwiftUI

struct Answer: View {
    @EnvironmentObject var loginManager: LoginManager
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var answer: String = ""
    @FocusState var isTextFieldFocused: Bool

    let post: Post

    @Environment(\.dismiss) private var dismiss

    init(post: Post) {
        self.post = post
        // State 변수 초기화
        _title = State(initialValue: post.title)
        _content = State(initialValue: post.contents)
        _answer = State(initialValue: post.answer)
    }

    var body: some View {
        NavigationStack {
            Form {
                HStack(content: {
                    Spacer()
                    Text("지하철역:")
                        .bold()
                    Text(post.station)
                    Spacer()
                    Text("작성자:")
                        .bold()
                    Text(post.author)
                })
                Section(header: Text("문의제목").bold().font(.callout)) {
                    TextField("", text: $title)
                        .frame(height: 50)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }
                Section(header: Text("문의내용").bold().font(.callout)) {
                    TextField("", text: $content)
                        .frame(height: 50)
                        .textFieldStyle(.roundedBorder)
                        .disabled(true)
                }

                Section(header: Text("답변").bold().font(.callout)) {
                    TextEditor(text: $answer)
                        .frame(minHeight: 200)
                        .keyboardType(.default)
                        .textEditorStyle(.automatic)
                        .disabled(!loginManager.isAdmin)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.black, lineWidth: 0.6)
                        )
                        .focused($isTextFieldFocused)
                }
                
                if loginManager.isAdmin {
                    HStack(spacing: 30, content: {
                        Spacer()
                        Button(action: {
                            // Submit action
                            if !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                firestoreManager.updateAnswer(documentId: post.id, answer: answer.trimmingCharacters(in: .whitespacesAndNewlines))
                                isTextFieldFocused = false
                                dismiss()
                            }
                        }) {
                            Text("Submit/Edit")
                                .frame(width: 100)
                                .padding()
                                .background(Color(.systemTeal).opacity(0.2))
                                .foregroundStyle(.black.opacity(0.6))
                                .cornerRadius(30)
                        }
                        Button(action: {
                            // Cancel action
                            dismiss()
                        }) {
                            Text("Cancel")
                                .frame(width: 100)
                                .padding()
                                .background(Color(.systemPink).opacity(0.2))
                                .foregroundStyle(.black.opacity(0.6))
                                .cornerRadius(30)
                        }
                        Spacer()
                    })
                    .listRowBackground(Color.clear)
                } else {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Cancel action
                            dismiss()
                        }) {
                            Text("Back")
                                .frame(width: 100)
                                .padding()
                                .background(Color(.systemBlue).opacity(0.2))
                                .foregroundStyle(.black.opacity(0.6))
                                .cornerRadius(30)
                        }
                        Spacer()
                    }
                }
                
            }
            .navigationTitle("답변하기")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .listSectionSpacing(.compact)
        }
//          .listRowSpacing(.compact)
    }
}

#Preview {
    Answer(post: Post(
        id: "sample",
        answer: "답변드립니다",
        author: "작성자 이름",
        contents: "강남역 문의",
        isAnswer: true,
        isPublic: true,
        station: "강남",
        title: "문의합니다",
        writeTime: "2024년 12월 26일 오후 4시 13분"
    ))
}
