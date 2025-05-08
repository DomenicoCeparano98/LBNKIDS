import AVFoundation
import SwiftUI

class AudioPlayer: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    // Precarica la musica di sottofondo
    func preloadBackgroundMusic() {
        let urlString = "https://pub-204e9727343d45d789a225cb20db81b7.r2.dev/GAMEKIDS2.mp3"
        guard let url = URL(string: urlString) else {
            print("URL non valido")
            return
        }

        URLSession.shared.downloadTask(with: url) { [weak self] location, _, error in
            guard let location = location, error == nil else {
                print("Errore nel download: \(error?.localizedDescription ?? "Errore sconosciuto")")
                return
            }

            do {
                let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("backgroundMusic.wav")
                try? FileManager.default.removeItem(at: tempFileURL)
                try FileManager.default.moveItem(at: location, to: tempFileURL)
                
                self?.audioPlayer = try AVAudioPlayer(contentsOf: tempFileURL)
                self?.audioPlayer?.enableRate = true
                self?.audioPlayer?.numberOfLoops = -1
                
                if let player = self?.audioPlayer {
                    print("Audio pre-caricato con successo")
                    print("Durata audio: \(player.duration) secondi")
                }
            } catch {
                print("Errore durante il pre-caricamento: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Avvia la musica di sottofondo
    func playBackgroundMusic() {
        guard let audioPlayer = audioPlayer else {
            print("Audio non caricato.")
            return
        }
        audioPlayer.play()
        print("Riproduzione audio avviata")
    }

    // Ferma la musica di sottofondo
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        print("Riproduzione audio interrotta")
    }
}
