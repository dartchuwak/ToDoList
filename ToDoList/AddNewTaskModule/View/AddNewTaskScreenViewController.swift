//
//  AddNewTaskScreenViewController.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import UIKit
import SnapKit

protocol AddNewTaskViewProtocol: AnyObject {
    func showSuccess()
    func showError(_ message: String)
    func setDate(date: String)
}

class AddNewTaskScreenViewController: UIViewController {
    
    var presenter: AddNewTaskPresenterProtocol?
    
    let titleTextField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return view
    }()
    
    let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 51, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        return view
    }()
    
    let descriptionTextField: UITextField = {
        var view = UITextField()
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 66)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.attributedPlaceholder = NSAttributedString(
            string: "Описание",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")
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
        }
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButton.tintColor = UIColor.accent
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveButtonTapped() {
        presenter?.saveNewTask(title: titleTextField.text ?? "", description: descriptionTextField.text ?? "")
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
        let alert = UIAlertController(title: "Ошибка сохранения", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
               present(alert, animated: true, completion: nil)
    }
    
    
}
