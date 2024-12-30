//
//  InsertPost.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/30/24.
//

import SwiftUI

struct InsertPost: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var title: String = ""
    @State private var contents: String = ""
    @State private var author: String = ""
    @State private var station: String = ""
    @State private var answer: String = ""
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    InsertPost()
}
