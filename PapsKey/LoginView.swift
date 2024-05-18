import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var authenticationFailed: Bool = false
    @State private var showRegisterView: Bool = false

    var body: some View {
        if isAuthenticated {
            ContentView()
        } else {
            VStack {
                Text("PapsKey🔑")
                    .font(.largeTitle)
                    .padding(.bottom, 40)

                TextField("Usuario", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)

                if authenticationFailed {
                    Text("Usuario o contraseña incorrectos")
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }

                Button(action: {
                    let users = UserManager.shared.getUsers()
                    if let storedPassword = users[username], storedPassword == password {
                        isAuthenticated = true
                        UserManager.shared.setCurrentUser(username: username)
                        authenticationFailed = false
                    } else {
                        authenticationFailed = true
                    }
                }) {
                    Text("Iniciar Sesión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }

                Button(action: {
                    showRegisterView = true
                }) {
                    Text("Crear una cuenta")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
                .sheet(isPresented: $showRegisterView) {
                    RegisterView()
                }
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
