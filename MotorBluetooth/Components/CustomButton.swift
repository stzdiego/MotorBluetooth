import SwiftUI

struct CustomButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    
    @State private var isPressed = false
    @State private var timer: Timer? = nil
    @State private var dateStart: Date? = nil
    
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        HStack {
            ZStack {
                content()
                    .padding()
            }
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                    dateStart = Date()
                    action()
                    startTimer()
                }
                .onEnded { _ in
                    isPressed = false
                    stopTimer()
                }
        )
        .frame(height: 20)
        .foregroundColor(.black)
        .background(isEnabled ? (isPressed ? Color.gray.opacity(0.2) : Color.white) : Color.gray.opacity(0.3))
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.2), radius: isPressed ? 0.4 : 0.8, x: 0, y: 0.8)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                if Date().timeIntervalSince(dateStart!) > 2.0 {
                    action()
                }
                
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct CustomTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(action: {
            print("Pressed New")
        }) {
            HStack(spacing: 0){
                Text("R")
                    .fontWeight(.bold)
                Text("educir")
            }
            .frame(width: 100)
        }
        .padding()
    }
}
