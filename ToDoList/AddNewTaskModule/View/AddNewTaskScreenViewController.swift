//
//  AddNewTaskScreenViewController.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import UIKit
import SnapKit

protocol AddNewTaskViewProtocol: AnyObject {
    func showSuccess()
    func showError(_ message: String)
    func setDate(date: String)
}

final class AddNewTaskScreenViewController: UIViewController {
    
    var presenter: AddNewTaskPresenterProtocol?
    
    let titleTextField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("Название", comment: "newTask")
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return view
    }()
    
    let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 51, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    let descriptionTextField: UITextView = {
        var view = UITextView()
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 66)
        view.text = NSLocalizedString("Описание", comment: "newTask")
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .white
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        addSubviews()
        setupConstraints()
        setupNavigationBar()
        presenter?.prepareDate()
    }
    
    private func addSubviews() {
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextField)
    }
    
    private func setupConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
    
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(
            title: NSLocalizedString("Сохранить", comment: "addTask"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButton.tintColor = UIColor.accent
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveButtonTapped() {
        presenter?.saveNewTask(title: titleTextField.text, description: descriptionTextField.text)
    }
}

extension AddNewTaskScreenViewController: AddNewTaskViewProtocol {
    func setDate(date: String) {
        self.dateLabel.text = date
    }
    
    func showSuccess() {
        print("Success save")
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Ошибка сохранения", comment: "addTask"), message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: NSLocalizedString("Ок", comment: "addTask"), style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
    }
    
    
}
