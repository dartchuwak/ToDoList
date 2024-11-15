//
//  ToDoCell.swift
//  DoToList
//
//  Created by Evgenii Mikhailov on 15.11.2024.
//

import Foundation
import UIKit
import SnapKit

class TodoTableViewCell: UITableViewCell {
    
    var presenter: MainScreenPresenterProtocol?
    var indexPath: IndexPath?
    
    static let identifier: String = "TodoTableViewCell"
    // UI элементы
    private let titleLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 22)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFPro-Medium", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        view.attributedText = NSMutableAttributedString(string: "Уборка в квартире  ", attributes: [NSAttributedString.Key.kern: -0.43, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 16)
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        view.attributedText = NSMutableAttributedString(string: "Провести генеральную уборку в квартире", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }()
    
    private let dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 288, height: 16)
        view.alpha = 0.5
        view.textColor = UIColor(red: 0.955, green: 0.955, blue: 0.955, alpha: 1)
        view.font = UIFont(name: "SFProText-Regular", size: 12)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        view.attributedText = NSMutableAttributedString(string: "02/10/24", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return view
    }()
    
    private let completedIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .accent
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка интерфейса
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCompleted))
        completedIndicator.addGestureRecognizer(tap)
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(completedIndicator)
        
        completedIndicator.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(completedIndicator.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with task: TaskModel, at indexPath: IndexPath, presenter: MainScreenPresenterProtocol) {
        self.indexPath = indexPath
        self.presenter = presenter
        titleLabel.text = task.todo
        dateLabel.text = task.date
        descriptionLabel.text = task.desctiption
        completedIndicator.image = task.completed ? UIImage(named: "icon_done") : UIImage(named: "icon")
        completedIndicator.tintColor = task.completed ? .green : .gray
    }
    
    @objc func toggleCompleted() {
        print("tapped")
    }
}
