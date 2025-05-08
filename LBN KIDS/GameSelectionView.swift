import SwiftUI

struct GameSelectionView: View {
    @State private var isAnimating = false // Stato per gestire l'animazione
    
    var body: some View {
        ZStack {
            // Sfondo
            Image("Sfondointro")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Pulsante Quiz
                Button(action: {
                    print("Quiz selezionato")
                    // Aggiungi qui la logica per il gioco Quiz
                }) {
                    Text("Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 36)
                        .padding(.horizontal, 58)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .shadow(color: .orange.opacity(isAnimating ? 0.8 : 0.2), radius: 10, x: 0, y: 0) // Effetto bagliore
                .rotationEffect(.degrees(isAnimating ? 8 : -8)) // Rotazione più pronunciata
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                // Pulsante Arcade
                Button(action: {
                    print("Arcade selezionato")
                    // Aggiungi qui la logica per il gioco Arcade
                }) {
                    Text("Arcade")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 36)
                        .padding(.horizontal, 58)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
                .shadow(color: .orange.opacity(isAnimating ? 0.8 : 0.2), radius: 100, x: 0, y: 0) // Effetto bagliore
                .rotationEffect(.degrees(isAnimating ? 8 : -8)) // Rotazione più pronunciata
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                Spacer()
            }
        }
        .onAppear {
            isAnimating = true // Avvia l'animazione quando la vista appare
        }
    }
}

struct GameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameSelectionView()
    }
}
