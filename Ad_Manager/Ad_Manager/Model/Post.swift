//
//  Post.swift
//  Ad_Manager
//
//  Created by Marley Jeong on 12/29/24.
//

import Foundation

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
