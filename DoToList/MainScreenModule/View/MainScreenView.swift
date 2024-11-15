//
//  MainScreenView.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    func updateTableView(tasks: [TaskModel])
    func showError(error: String)
}

class MainScreenView: UIViewController {
    var presenter: MainScreenPresenterProtocol?
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    let taskCountLabel = UILabel()
    
    let toolbar = UIToolbar()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")
        self.title = "Задачи"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchBar()
        setupToolbar()
        setupTableView()
        // presenter?.fetchTasks()
        presenter?.loadTasks()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadTasks()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(toolbar.snp.top)
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.tintColor = .lightGray
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = UIColor(named: "bgGray")
        searchBar.searchTextField.textColor = .lightGray
        
        let micImage = UIImage(systemName: "circle")
        let imageView:UIImageView = UIImageView(image: micImage)
        searchBar.searchTextField.rightView = imageView
        searchBar.searchTextField.rightViewMode = .always
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.rightView?.tintColor = .lightGray
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        customizeSearchBar()
    }
    
    private func customizeSearchBar() {
        let textField = searchBar.searchTextField
        addMicrophoneIcon(to: textField)
    }
    
    private func addMicrophoneIcon(to textField: UITextField) {
        let micButton = UIButton(type: .custom)
        let micImage = UIImage(systemName: "microphone")
        micButton.setImage(micImage, for: .normal)
        micButton.tintColor = UIColor.white
        micButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        textField.rightView = micButton
        textField.rightViewMode = .always
    }
    
    private func setupToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNewTask))
        addButton.tintColor = .accent
        taskCountLabel.text = presenter?.tasksCount()
        taskCountLabel.textColor = .white
        taskCountLabel.font = UIFont.systemFont(ofSize: 16)
        taskCountLabel.sizeToFit()
        let textItem = UIBarButtonItem(customView: taskCountLabel)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, textItem, flexibleSpace, addButton]
        toolbar.isTranslucent = false
        toolbar.tintColor = .black
        toolbar.barTintColor = UIColor(named: "bgGray")
        toolbar.backgroundColor = .black
        view.addSubview(toolbar)
        
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(49)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc private func addNewTask() {
        presenter?.addNewTask()
    }
}

extension MainScreenView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        let count = presenter.todos.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else { return UITableViewCell() }
        guard let presenter else { return UITableViewCell() }
        let task = presenter.todo(at: indexPath.row)
        cell.configure(with: task , at: indexPath, presenter: presenter)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
    }
}

extension MainScreenView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //   presenter?.fetchData(searchText: searchText)
    }
}

extension MainScreenView: MainViewProtocol {
    func updateTableView(tasks: [TaskModel]) {
        tableView.reloadData()
        taskCountLabel.text = tasks.count.description
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
