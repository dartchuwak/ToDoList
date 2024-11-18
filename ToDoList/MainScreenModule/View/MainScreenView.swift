//
//  MainScreenView.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import UIKit
import SnapKit
import CoreData

protocol MainViewProtocol: AnyObject {
    func updateTableView(tasks: [TaskModel])
    func updateTaskCountLabel(count: Int)
    func showError(error: String)
}

class MainScreenView: UIViewController {
    var presenter: MainScreenPresenterProtocol?
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private let taskCountLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgGray
        return view
    }()
    
    private let toolbar = UIToolbar()
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")
        self.title = "Задачи"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchBar()
        setupView()
        setupTableView()
        presenter?.fetchTasks()
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
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.tintColor = .lightGray
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.searchTextField.backgroundColor = UIColor(named: "bgGray")
        searchBar.searchTextField.textColor = .lightGray
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    
    private func setupView() {
        let addButton = UIButton(type: .system)
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        addButton.setImage(UIImage(named: "add"), for: .normal)
        let clearButton = UIButton(type: .system)
        clearButton.addTarget(self, action: #selector(clearTasks), for: .touchUpInside)
        clearButton.setImage(UIImage(systemName: "trash"), for: .normal)
        bottomView.addSubview(addButton)
        bottomView.addSubview(clearButton)
        bottomView.addSubview(taskCountLabel)
        view.addSubview(bottomView)
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(13)
        }
        
        clearButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(13)
        }
        
        taskCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(addButton.snp.centerY)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(83)
        }
    }
    
    @objc private func addNewTask() { presenter?.addNewTask() }
    @objc private func clearTasks() { clearCoreData() }
    
    
    //Используется для отладки
    func clearCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        let entities = persistentStoreCoordinator.managedObjectModel.entities
        for entity in entities {
            guard let entityName = entity.name else { continue }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                print("Успешно удалены данные из сущности \(entityName)")
            } catch {
                print("Ошибка при удалении данных из сущности \(entityName): \(error)")
            }
        }
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
        cell.configure(with: task , at: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.didSelectTask(at: index)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                print("Поделиться задачей")
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.presenter?.didTapDeleteTask(at: index)
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        guard let cell = tableView.cellForRow(at: .init(row: Int(identifier) ?? 0, section: 0)) as? TodoTableViewCell else { return nil }
        let parameters = UIPreviewParameters()
        return UITargetedPreview(view: cell.textView, parameters: parameters)
    }
    
    func tableView( _ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration ) -> UITargetedPreview? {
        guard let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? TodoTableViewCell else { return nil }
        //  cell.resetSnapKit()
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        return nil
    }
}

extension MainScreenView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.perfomSearch(text: searchText)
    }
}

extension MainScreenView: MainViewProtocol {
    func updateTableView(tasks: [TaskModel]) {
        tableView.reloadData()
    }
    
    func updateTaskCountLabel(count: Int) {
        taskCountLabel.text = String("\(count.description) задачи")
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MainScreenView: TodoTableViewCellDelegate {
    func didTapStatusImage(at indexPath: IndexPath) {
        presenter?.toggleTaskCompletion(at: indexPath.row)
    }
}
