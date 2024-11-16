//
//  AddNewTaskScreenViewController.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import UIKit
import SnapKit

protocol TaskDetailsViewProtocol: AnyObject {
    func displayTask(_ task: TaskModel)
}

class TaskDetailsViewController: UIViewController {
    
    var presenter: TaskDetailsPresenterProtocol?
    
    let titleLabel: UITextField = {
        let label = UITextField()
        label.text = "Add new task"
        label.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 51, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        view.attributedText = NSMutableAttributedString(string: "02/10/24", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }()
    
    let descriptionLabel: UITextField = {
        var view = UITextField()
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 66)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFPro-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        view.attributedText = NSMutableAttributedString(string: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.", attributes: [NSAttributedString.Key.kern: -0.43, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")
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
        presenter?.updateTask(description: descriptionLabel.text ?? "", todo: titleLabel.text ?? "")
    }
}

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func displayTask(_ task: TaskModel) {
            titleLabel.text = task.todo
            descriptionLabel.text = task.desctiption
          }
}
