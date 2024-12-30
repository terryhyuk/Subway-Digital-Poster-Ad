//
//  Post.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/29/24.
//

import Foundation
import FirebaseFirestore


struct Post: Identifiable {
    let id: String
    let answer: String
    let author: String
    let contents: String
    let isAnswer: Bool
    let isPublic: Bool
    let station: String
    let title: String
    let writeTime: String
}

// Firebase 매니저
class FirestoreManager: ObservableObject {
    @Published var post: Post?
    @Published var posts: [Post] = []
    
    // List fetch
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("post").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            
            self.posts = documents.map {doc -> Post in
                let data = doc.data()
                return Post(
                    id: doc.documentID,
                    answer: data["answer"] as? String ?? "",
                    author: data["author"] as? String ?? "",
                    contents: data["contents"] as? String ?? "",
                    isAnswer: data["isAnswer"] as? Bool ?? false,
                    isPublic: data["isPublic"] as? Bool ?? false,
                    station: data["station"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    writeTime: data["writeTime"] as? String ?? ""
                )
            }
        }
    }
    // Answer 입력/수정
    func updateAnswer(documentId: String, answer: String) {
           let db = Firestore.firestore()
           db.collection("post").document(documentId).updateData([
               "answer": answer,
               "isAnswer": true
           ]) { error in
               if let error = error {
                   print("Error updating document: \(error)")
               }
           }
       }
}
