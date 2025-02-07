//
//  ToDoCell.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 05.02.2025.
//

import Foundation
import UIKit
import SnapKit

protocol TodoTableViewCellDelegate: AnyObject {
    func didTapStatusImage(at indexPath: IndexPath)
}

final class TodoTableViewCell: UITableViewCell {
    weak var delegate: TodoTableViewCellDelegate?
    var indexPath: IndexPath?
    static let identifier: String = "TodoTableViewCell"
    
    let textView = UIView()
    
    private let titleLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 22)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = 1
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 16)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.numberOfLines = 2
        return view
    }()
    
    private let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private let completedIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCompleted))
        completedIndicator.addGestureRecognizer(tap)
        backgroundColor = .clear
        
        textView.addSubview(titleLabel)
        textView.addSubview(descriptionLabel)
        textView.addSubview(dateLabel)
        
        contentView.addSubview(completedIndicator)
        contentView.addSubview(textView)
        
        completedIndicator.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(completedIndicator.snp.trailing)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func updateSnapKit() {
        titleLabel.snp.updateConstraints { make in
            make.top.equalTo(textView.snp.top).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        dateLabel.snp.updateConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func resetSnapKit() {
        titleLabel.snp.updateConstraints { make in
            make.top.equalTo(textView.snp.top).offset(12)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        descriptionLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        dateLabel.snp.updateConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with task: TaskModel, at indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = task.todo
        dateLabel.text = task.date
        descriptionLabel.text = task.description
        let image = task.completed ? UIImage(systemName: Images.checkmark) : UIImage(systemName: Images.circle)
        completedIndicator.image = image
        completedIndicator.tintColor = task.completed ? .accent : .gray
        titleLabel.textColor = task.completed ? .lightGray : .white
        descriptionLabel.textColor = task.completed ? .lightGray : .white
    }
    
    @objc func toggleCompleted() {
        guard let indexPath = indexPath else { return }
        delegate?.didTapStatusImage(at: indexPath)
    }
}
