//
//  ViewController.swift
//  20. Data Persistence
//
//  Created by Sesili Tsikaridze on 05.11.23.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Please Sing In"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextfield = {
        let usernameTextfield = UITextField()
        usernameTextfield.placeholder = "  username"
        usernameTextfield.layer.cornerRadius = 10
        usernameTextfield.backgroundColor = .systemGray6
        usernameTextfield.layer.borderWidth = 1
        usernameTextfield.layer.borderColor = UIColor.systemGray5.cgColor
        usernameTextfield.layer.opacity = 1
        usernameTextfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return usernameTextfield
    }()
    
    private let passwordTextfield = {
        let passwordTextfield = UITextField()
        passwordTextfield.placeholder = "  password"
        passwordTextfield.layer.cornerRadius = 10
        passwordTextfield.backgroundColor = .systemGray6
        passwordTextfield.layer.borderWidth = 1
        passwordTextfield.layer.borderColor = UIColor.systemGray5.cgColor
        passwordTextfield.layer.opacity = 1
        passwordTextfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return passwordTextfield
    }()
    
    private let signInButton = {
        let button = UIButton()
        button.backgroundColor = .darkPink
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let mainStackView = {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        signInButtonAction()
    }
    
    //MARK: - Private functions
    
    private func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(usernameTextfield)
        mainStackView.addArrangedSubview(passwordTextfield)
        mainStackView.addArrangedSubview(signInButton)
    }
    
    private func addConstraints() {
        stackViewConstraints()
        mainStackView.setCustomSpacing(60, after: titleLabel)
        mainStackView.setCustomSpacing(60, after: passwordTextfield)
    }
    
    private func stackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    private func signInButtonAction() {
        signInButton.addAction(UIAction(handler: { [weak self] _  in
            self?.signInButtonClicked()
        }), for: .touchUpInside)
    }
    
    
    private func signInButtonClicked() {
        
        keyChainSave()
        
        if passwordTextfield.text?.isEmpty == true || usernameTextfield.text?.isEmpty == true {
            alert(title: "Empty fields", message: "please fill both fields")
        }
        
        guard let username = usernameTextfield.text else { return }
        guard let password = passwordTextfield.text else { return }
        
        let existingUser = UserDefaults.standard.bool(forKey: username)
        
        let userPassword = getPassword()
        
        if existingUser == false {
            if password == userPassword {
                let noteList = NoteListViewController()
                navigationController?.pushViewController(noteList, animated: true)
            } else {
                alert(title: "wrong password", message: "please enter correct password")
            }
        } else {
            let noteList = NoteListViewController()
            navigationController?.pushViewController(noteList, animated: true)
            
        }
        
    }
    
    private func keyChainSave() {
        
        if let username = usernameTextfield.text, let password = passwordTextfield.text {
            do {
                try KeyChainManager.save(service: "Notes", account: username, password: password.data(using: .utf8) ?? Data())
            } catch {
                print(error)
            }
        }
    }
    
    private func getPassword() -> String {
        var password: String = ""
        
        if let username = usernameTextfield.text {
            guard let data = KeyChainManager.get(service: "Notes", account: username) else {
                print("failed load password")
                return ""
            }
            password = String(decoding: data, as: UTF8.self)
        }
        return password
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)    }
}


class KeyChainManager {
    
    enum KeyChainError: Error {
        case unknown(OSStatus)
    }
    
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
        
        print("saved")
    }
    
    static func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("read status \(status)")
        return result as? Data
    }
    
}

