//
//  ChatBubble.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isSentByUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .animation(.easeInOut, value: message.text)
            } else {
                VStack(alignment: .leading) {
                    Text(message.text)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .animation(.easeInOut, value: message.text)

                    if message.hasGraphic, let graphic = message.graphic {
                        GraphicView(graphic: graphic)
                            .padding(.top, 5)
                    }
                }
                Spacer()
            }
        }
    }
}

