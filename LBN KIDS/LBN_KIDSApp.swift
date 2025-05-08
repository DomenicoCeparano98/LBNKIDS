import SwiftUI
import Firebase

@main
struct LBN_KIDSApp: App {
    // Inizializza Firebase
    init() {
        FirebaseApp.configure()  // Configura Firebase all'avvio dell'app
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // Avvia la ContentView come schermata iniziale
        }
    }
}
