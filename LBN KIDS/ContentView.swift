import SwiftUI


struct ContentView: View {
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var navigateToGameSelection = false
    @StateObject private var viewModel = UserViewModel()
    @State private var rotationAngle: Angle = .degrees(0) // Stato per l'angolo di rotazione
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Sfondointro")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Nome
                    CustomTextField(
                        placeholder: "Nome",
                        text: $viewModel.name,
                        onChange: { viewModel.validateInputs() }
                    )
                    
                    // Cognome
                    CustomTextField(
                        placeholder: "Cognome",
                        text: $viewModel.surname,
                        onChange: { viewModel.validateInputs() }
                    )
                    
                    // Età
                    TextField("Età", text: $viewModel.age)
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .font(.body)
                        .padding(.horizontal, 16)
                        .onChange(of: viewModel.age) { _ in
                            viewModel.validateInputs()
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Chiudi") {
                                    hideKeyboard()
                                }
                            }
                        }
                    
                    // Bottone per iniziare il gioco con animazione di oscillazione
                    Button(action: {
                        viewModel.saveUserData()
                        navigateToGameSelection = true
                        print("Navigazione verso la selezione del gioco")
                    }) {
                        Text("Inizia il Gioco")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(viewModel.isButtonDisabled ? Color.gray : Color.orange)
                            .cornerRadius(8)
                            .padding(.top, 20)
                            // Aggiungi l'effetto di oscillazione
                            .rotationEffect(rotationAngle)
                            .animation(
                                viewModel.isButtonDisabled ? nil :
                                    Animation.easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true),
                                value: rotationAngle
                            )
                    }
                    .disabled(viewModel.isButtonDisabled)
                    .onAppear {
                        // Imposta una rotazione leggera per l'oscillazione
                        rotationAngle = .degrees(5) // Rotazione massima di 5 gradi
                    }
                    
                    Spacer()
                }
                .onAppear {
                    audioPlayer.preloadBackgroundMusic()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        audioPlayer.playBackgroundMusic()
                    }
                }
                .onDisappear {
                    audioPlayer.stopBackgroundMusic()
                }
                .navigationDestination(isPresented: $navigateToGameSelection) {
                    GameSelectionView()
                }
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// ViewModel per la logica dell'utente
class UserViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var age: String = ""
    @Published var isButtonDisabled: Bool = true
    
    init() {
        loadUserData()
        validateInputs()
    }
    
    // Carica i dati salvati in UserDefaults
    func loadUserData() {
        name = UserDefaults.standard.string(forKey: "nome") ?? ""
        surname = UserDefaults.standard.string(forKey: "cognome") ?? ""
        age = UserDefaults.standard.string(forKey: "età") ?? ""
    }
    
    // Salva i dati in UserDefaults
    func saveUserData() {
        UserDefaults.standard.set(name, forKey: "nome")
        UserDefaults.standard.set(surname, forKey: "cognome")
        UserDefaults.standard.set(age, forKey: "età")
        
        // Log to show that data is saved locally
        print("Dati salvati in UserDefaults.")
    }
    
    // Valida i dati inseriti (Nome, Cognome, Età)
    func validateInputs() {
        let isNameValid = !name.isEmpty
        let isSurnameValid = !surname.isEmpty
        let isAgeValid = !age.isEmpty
        isButtonDisabled = !(isNameValid && isSurnameValid && isAgeValid)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var onChange: () -> Void
    
    var body: some View {
        TextField(placeholder, text: $text, onEditingChanged: { _ in onChange() })
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .font(.body)
            .padding(.horizontal, 16)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
