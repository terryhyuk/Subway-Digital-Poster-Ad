//
//  Answer.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/26/24.
//

import SwiftUI

struct Answer: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var answer: String = ""
    
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
                  Section {
                      TextField("", text: $title)
                          .textFieldStyle(.plain)
                  }
                  
                  Section(header: Text("문의내용")) {
                      TextField("", text: $content)
                          .textFieldStyle(.plain)
                  }
                  
                  Section(header: Text("답변")) {
                      TextEditor(text: $answer)
                          .frame(minHeight: 200)
                  }
                  
                  HStack (spacing: 30, content: {
                      Spacer()
                      Button(action: {
                          // Submit action
                          firestoreManager.updateAnswer(documentId: post.id, answer: answer)
                          dismiss()
                      }) {
                          Text("Submit/Edit")
                              .frame(width: 100)
                              .padding()
                              .background(Color(.systemTeal).opacity(0.2))
                              .foregroundStyle(Color.gray)
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
                              .foregroundStyle(Color.gray)
                              .cornerRadius(30)
                      }
                      Spacer()
                  })
                  .listRowBackground(Color.clear)
              }
              .navigationTitle("답변하기")
              .navigationBarTitleDisplayMode(.inline)
          }
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
