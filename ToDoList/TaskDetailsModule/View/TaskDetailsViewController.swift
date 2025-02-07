//
//  AddNewTaskScreenViewController.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import UIKit
import SnapKit

protocol TaskDetailsViewProtocol: AnyObject {
    func displayTask(_ task: TaskModel)
}

final class TaskDetailsViewController: UIViewController {
    
    var presenter: TaskDetailsPresenterProtocol?
    
    private let titleLabel: UITextField = {
        let label = UITextField()
        label.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 51, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font =  UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private let descriptionLabel: UITextView = {
        var view = UITextView()
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 66)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font =  UIFont.systemFont(ofSize: 16, weight: .regular)
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        addSubviews()
        setupConstraints()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(
            title: NSLocalizedString("Сохранить", comment: "details"),
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButton.tintColor = UIColor.accent
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveButtonTapped() {
        presenter?.updateTask(description: descriptionLabel.text, todo: titleLabel.text)
    }
}

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func displayTask(_ task: TaskModel) {
        titleLabel.text = task.todo
        descriptionLabel.text = task.description
        dateLabel.text = task.date
    }
}
