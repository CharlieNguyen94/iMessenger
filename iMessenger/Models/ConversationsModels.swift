//
//  ConversationsModels.swift
//  iMessenger
//
//  Created by Charlie Nguyen on 17/08/2021.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
