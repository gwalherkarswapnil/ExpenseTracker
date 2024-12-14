import SwiftUI

import SwiftUI

struct ChatView: View {
    var theme: Theme = Theme.orangeTheme
    
    @State private var messages: [ChatMessage] = []
    @State private var messageText: String = ""
    @State private var isTyping: Bool = false
    
    private let chatGPTService = ChatGPTService()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .transition(.move(edge: message.isSentByUser ? .trailing : .leading))
                                .padding(.vertical, 5)
                        }
                        
                        if isTyping {
                            TypingIndicatorView()
                        }
                    }
                }
                
                HStack {
                    TextField("Enter message", text: $messageText)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    
                    Button(action: sendMessage) {
                        Text("Send")
                            .bold()
                            .foregroundColor(theme.primaryColor)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        // Add user message
        let newMessage = ChatMessage(text: messageText, isSentByUser: true, hasGraphic: false, graphic: nil)
        withAnimation {
            messages.append(newMessage)
        }
        messageText = ""
        
        // Show typing indicator and fetch ChatGPT response
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isTyping = false
            fetchChatGPTResponse(for: newMessage.text)
        }
    }
    
    private func fetchChatGPTResponse(for userMessage: String) {
        chatGPTService.sendMessage(message: userMessage) { resultString in
      
                let botReply = ChatMessage(
                    text: resultString ?? "",
                    isSentByUser: false,
                    hasGraphic: false,
                    graphic: nil
                )
                    messages.append(botReply)
                
        
            }
        }
    }
    
struct TypingIndicatorView: View {
    @State private var dots: [Bool] = [true, false, false]

    var body: some View {
        HStack {
            ForEach(0..<dots.count, id: \.self) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 10, height: 10)
                    .scaleEffect(dots[index] ? 1.2 : 1)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: dots[index])
            }
        }
        .onAppear {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dots = [false, true, false]
                }
            }
        }
    }
}


#Preview {
    ChatView()
}
