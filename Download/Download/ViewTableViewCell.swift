//
//  ViewTableViewCell.swift
//  Download
//
//  Created by 张书孟 on 2018/10/10.
//  Copyright © 2018年 zsm. All rights reserved.
//

import UIKit

class ViewTableViewCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect(x: 20, y: contentView.frame.size.height/2 - 20, width: 100, height: 40))
        nameLabel.textColor = UIColor.black
        nameLabel.backgroundColor = UIColor.green
        return nameLabel
    }()
    
    private lazy var progressLabel: UILabel = {
        let progressLabel = UILabel(frame: CGRect(x: 120, y: contentView.frame.size.height/2 - 20, width: 100, height: 40))
        progressLabel.textColor = UIColor.black
        progressLabel.backgroundColor = UIColor.orange
        return progressLabel
    }()
    
    private lazy var stateBtn: UIButton = {
        let stateBtn = UIButton(frame: CGRect(x: contentView.frame.size.width - 50, y: contentView.frame.size.height/2 - 20, width: 80, height: 40))
        stateBtn.backgroundColor = UIColor.red
        stateBtn.addTarget(self, action: #selector(stateBtnClick(sender:)), for: .touchUpInside)
        return stateBtn
    }()
    
    private var model: DownloadModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubviews()
    }
    
    func update(model: DownloadModel) {
        self.model = model
        nameLabel.text = model.model.name
        
        if let url = model.model.url, let model1 = model.getDownloadModel(url: url) {
            stateBtn.setTitle(state(state: DownloadManager.default.isCompletion(url: url) ? .completed : model.states), for: .normal)
            progressLabel.text = "\(model1.progress)"
        } else {
            progressLabel.text = "0.0"
            stateBtn.setTitle(state(state: model.states), for: .normal)
        }
    }
    
    func updateView(model: DownloadDescModel) {
        progressLabel.text = "\(model.progress)"
    }
    
    @objc private func stateBtnClick(sender: UIButton) {
        
        guard let downloadModel = model else {
            return
        }
        
        DownloadManager.default.download(model: downloadModel, progress: { (progress, receivedSize, expectedSize) in
            debugPrint("progress: \(progress) -- receivedSize: \(receivedSize) -- expectedSize: \(expectedSize)")

        }) { (state) in
        }
    }
    
    private func state(state: DownloadState) -> String {
        switch state {
        case .start:
            return "下载中"
        case .completed:
            return "完成"
        case .waiting:
            return "等待"
        case .suspended:
            return "暂停"
        default:
            return "开始"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewTableViewCell {
    
    private func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(stateBtn)
        
    }
}