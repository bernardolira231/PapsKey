import Foundation

class UserManager {
    static let shared = UserManager()
    private let userDefaults = UserDefaults.standard
    private let userKey = "users"
    private let passwordKeyPrefix = "passwords_"
    private let currentUserKey = "currentUser"
    
    private init() {}
    
    func getUsers() -> [String: String] {
        return userDefaults.dictionary(forKey: userKey) as? [String: String] ?? [:]
    }
    
    func addUser(username: String, password: String) {
        var users = getUsers()
        users[username] = password
        userDefaults.set(users, forKey: userKey)
    }
    
    func addPassword(forUser username: String, password: String, description: String) {
        let key = passwordKeyPrefix + username
        var passwords = userDefaults.dictionary(forKey: key) as? [String: String] ?? [:]
        passwords[description] = password
        userDefaults.set(passwords, forKey: key)
    }
    
    func getPasswords(forUser username: String) -> [String: String] {
        let key = passwordKeyPrefix + username
        return userDefaults.dictionary(forKey: key) as? [String: String] ?? [:]
    }
    
    func setCurrentUser(username: String) {
        userDefaults.set(username, forKey: currentUserKey)
    }
    
    func getCurrentUser() -> String? {
        return userDefaults.string(forKey: currentUserKey)
    }
    
    func logout() {
        userDefaults.removeObject(forKey: currentUserKey)
    }
}
