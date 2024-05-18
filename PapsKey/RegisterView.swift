import SwiftUI

struct RegisterView: View {
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationFailed: Bool = false
    @State private var registrationSuccess: Bool = false

    var body: some View {
        VStack {
            Text("Crear una cuenta")
                .font(.largeTitle)
                .padding(.bottom, 40)

            TextField("Nuevo usuario", text: $newUsername)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Nueva contraseña", text: $newPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Confirmar contraseña", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            if registrationFailed {
                Text("Las contraseñas no coinciden o el usuario ya existe")
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
            }

            if registrationSuccess {
                Text("Registro exitoso, puede iniciar sesión")
                    .foregroundColor(.green)
                    .padding(.bottom, 20)
            }

            Button(action: {
                let users = UserManager.shared.getUsers()
                if newPassword == confirmPassword && !users.keys.contains(newUsername) {
                    UserManager.shared.addUser(username: newUsername, password: newPassword)
                    registrationFailed = false
                    registrationSuccess = true
                } else {
                    registrationFailed = true
                }
            }) {
                Text("Registrar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        .padding()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
