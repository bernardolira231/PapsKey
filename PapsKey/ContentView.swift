import SwiftUI

struct ContentView: View {
    @State private var passwordLength = 12
    @State private var generatedPassword = ""
    @State private var showingSheet = false
    @State private var selectedSocialNetwork = ""
    @State private var isLoggedOut = false
    @State private var passwords: [String: String] = [:]
    @State private var includeUppercase = true
    @State private var includeNumbers = true
    @State private var includeSymbols = true
    @State private var showCopiedAlert = false
    @State private var showAdvancedSettings = false

    var body: some View {
        if isLoggedOut {
            LoginView()
        } else {
            NavigationView {
                VStack {
                    Text("PapsKey🔑")
                        .font(.title)
                        .padding()
                    Spacer()
                    
                    Stepper(value: $passwordLength, in: 8...32, step: 1) {
                        Text("Longitud de la Contraseña: \(passwordLength)")
                    }
                    .padding()
                    
                    DisclosureGroup("Configuraciones avanzadas", isExpanded: $showAdvancedSettings) {
                        Toggle("Incluir Mayúsculas", isOn: $includeUppercase)
                            .padding(.vertical, 5)
                        
                        Toggle("Incluir Números", isOn: $includeNumbers)
                            .padding(.vertical, 5)
                        
                        Toggle("Incluir Símbolos", isOn: $includeSymbols)
                            .padding(.vertical, 5)
                    }
                    .padding()
                    
                    Button(action: {
                        generatedPassword = generateSecurePassword(length: passwordLength)
                    }) {
                        Text("Generar Contraseña")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        UIPasteboard.general.string = generatedPassword
                    }) {
                        Text(generatedPassword)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {
                        selectedSocialNetwork = "" // Restablecer el valor aquí
                        showingSheet = true
                    }) {
                        Text("Guardar Contraseña")
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        Form {
                            Section(header: Text("Red Social")) {
                                TextField("Ingrese el nombre de la red social", text: $selectedSocialNetwork)
                            }
                            Section(header: Text("Contraseña")) {
                                Text(generatedPassword)
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                if let currentUser = UserManager.shared.getCurrentUser() {
                                    UserManager.shared.addPassword(forUser: currentUser, password: generatedPassword, description: selectedSocialNetwork)
                                    passwords = UserManager.shared.getPasswords(forUser: currentUser)
                                }
                                showingSheet = false // Cerrar el popup después de guardar
                            }) {
                                Text("Guardar")
                            }
                        }
                        .padding()
                    }
                    
                    Spacer() // Espacio para empujar el contenido hacia arriba

                    Text("Contraseñas Guardadas")
                        .font(.title2)
                        .padding(.top)
                    
                    ScrollView {
                        ForEach(passwords.keys.sorted(), id: \.self) { key in
                            VStack(alignment: .leading) {
                                Text(key)
                                    .font(.headline)
                                Text(passwords[key] ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Divider()
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .padding([.leading, .trailing, .bottom])
                            .onTapGesture {
                                UIPasteboard.general.string = passwords[key]
                                showCopiedAlert = true
                            }
                        }
                    }
                }
                .navigationBarTitle("", displayMode: .inline) // Oculta el título de la barra de navegación
                .navigationBarItems(trailing: Menu {
                    Button(action: {
                        UserManager.shared.logout()
                        isLoggedOut = true
                    }) {
                        Text("Cerrar Sesión")
                        Image(systemName: "person.fill.xmark")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .foregroundColor(.blue)
                })
                .alert(isPresented: $showCopiedAlert) {
                    Alert(
                        title: Text("Contraseña copiada"),
                        message: Text("La contraseña ha sido copiada al portapapeles."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding()
            .onAppear {
                if let currentUser = UserManager.shared.getCurrentUser() {
                    passwords = UserManager.shared.getPasswords(forUser: currentUser)
                }
            }
        }
    }
    
    func generateSecurePassword(length: Int) -> String {
        var characters = "abcdefghijklmnopqrstuvwxyz"
        if includeUppercase {
            characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if includeNumbers {
            characters += "0123456789"
        }
        if includeSymbols {
            characters += "!@#$%^&*()_+{}[]|\"<>?"
        }
        
        guard !characters.isEmpty else {
            return ""
        }
        
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
