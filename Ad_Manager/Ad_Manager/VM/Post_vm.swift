//
//  Post_vm.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/30/24.
//

import FirebaseFirestore
import Foundation

class FirestoreManager: ObservableObject {
    @Published var post: Post?
    @Published var posts: [Post] = []

    func formatTimestamp(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC+9")
        let date = timestamp.dateValue()
        return dateFormatter.string(from: date)
    }

    // List fetch
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("post").order(by: "writeTime", descending: true).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }

            self.posts = documents.map { doc -> Post in
                let data = doc.data()
                let timestamp = data["writeTime"] as? Timestamp ?? Timestamp()
                let writeTime = self.formatTimestamp(timestamp)

                return Post(
                    id: doc.documentID,
                    answer: data["answer"] as? String ?? "",
                    author: data["author"] as? String ?? "",
                    contents: data["contents"] as? String ?? "",
                    isAnswer: data["isAnswer"] as? Bool ?? false,
                    isPublic: data["isPublic"] as? Bool ?? false,
                    station: data["station"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    writeTime: writeTime
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

    // Insert
    func addPost(title: String, contents: String, author: String, station: String, ispublic: Bool) {
        let db = Firestore.firestore()

        let newPost = [
            "title": title,
            "contents": contents,
            "author": author,
            "station": station,
            "answer": "",
            "isAnswer": false,
            "isPublic": ispublic,
            "writeTime": String(Date().description)
        ] as [String: Any]

        db.collection("post").addDocument(data: newPost) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully added")
            }
        }
    }
}
