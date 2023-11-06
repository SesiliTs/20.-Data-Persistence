//
//  NoteListViewController.swift
//  20. Data Persistence
//
//  Created by Sesili Tsikaridze on 05.11.23.
//

import UIKit

protocol AddNewNoteDelegate: AnyObject {
    func addNewNote(with note: Note)
}

class NoteListViewController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Notes"
        titleLabel.font = .systemFont(ofSize: 30, weight: .black)
        return titleLabel
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var notesArray = notes
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupTableView()
        addConstraints()
        navigationControllerSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Private Functions
    
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tableView)
    }
    
    private func addConstraints() {
        stackViewConstraints()
    }
    
    private func setupTableView() {
        initTableView()
        registerTableViewCells()
    }
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerTableViewCells() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func stackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        ])
    }
    
    //MARK: - NavigationBar
    
    func navigationControllerSetup() {
        navigationController?.navigationBar.tintColor = .darkPink
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonClicked))
        
    }
    
    @objc private func plusButtonClicked() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.delegate = self
        navigationController?.pushViewController(addNoteViewController, animated: true)
    }
    
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailsViewController = NoteDetailsViewController()
        noteDetailsViewController.titleTextView = notesArray[indexPath.row].title
        noteDetailsViewController.bodyTextView = notesArray[indexPath.row].body
        navigationController?.pushViewController(noteDetailsViewController, animated: true)
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notesArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell {
            cell.configure(with: note)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension NoteListViewController: AddNewNoteDelegate {
    func addNewNote(with note: Note) {
        notesArray.append(note)
    }
}

