//
//  AddNoteViewController.swift
//  20. Data Persistence
//
//  Created by Sesili Tsikaridze on 06.11.23.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: AddNewNoteDelegate?
    
    private let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .lightGray
        return titleLabel
    }()
    
    private let titleTextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .bold)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        textView.isEditable = true
        return textView
    }()
    
    private let bodyLabel = {
        let bodyLabel = UILabel()
        bodyLabel.text = "Note"
        bodyLabel.font = .systemFont(ofSize: 16, weight: .bold)
        bodyLabel.textColor = .lightGray
        return bodyLabel
    }()
    
    private let bodyTextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        textView.isEditable = true
        return textView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        addConstraints()
        navigationControllerSetup()
    }
    
    //MARK: - Private Methods
    
    private func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(titleTextView)
        mainStackView.addArrangedSubview(bodyLabel)
        mainStackView.addArrangedSubview(bodyTextView)
    }
    
    private func addConstraints() {
        stackViewConstraints()
    }
    
    private func stackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    //MARK: - NavigationBar
    
    func navigationControllerSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
    }
    
    @objc private func doneButtonClicked() {
        if titleTextView.text.isEmpty == false || bodyTextView.text.isEmpty == false {
            let note = Note(title: titleTextView, body: bodyTextView)
            self.delegate?.addNewNote(with: note)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
