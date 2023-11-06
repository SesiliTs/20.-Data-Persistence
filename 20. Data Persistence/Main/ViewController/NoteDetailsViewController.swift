//
//  NoteDetailsViewController.swift
//  20. Data Persistence
//
//  Created by Sesili Tsikaridze on 06.11.23.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .lightGray
        return titleLabel
    }()
    
    var titleTextView = UITextView()
    
    private let bodyLabel = {
        let bodyLabel = UILabel()
        bodyLabel.text = "Note"
        bodyLabel.font = .systemFont(ofSize: 16, weight: .bold)
        bodyLabel.textColor = .lightGray
        return bodyLabel
    }()
    
    var bodyTextView = UITextView()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        navigationControllerSetup()
        addConstraints()
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
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
