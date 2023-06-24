//
//  ChainViewController.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

protocol FilterChainDelegate: AnyObject {
    
    func pushToFilterDetail(with model: FilterBaseModel)
}

///FliterChain
class ChainViewController: UIViewController {
    
    private var cells: [FilterBaseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadViews(in: view)
        
        mocks()
    }
    
    private func mocks() {
        let models: [FilterBaseModel] = [
            "CIColorControls"
        ].compactMap { name in
            return FilterBaseModel(name: name)
        }
        self.cells = models
        
        tableView.reloadData()
    }
    
    //MARK: View
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
         tableView.register(FliterChainCell.self, forCellReuseIdentifier: String(describing: FliterChainCell.self))
        return tableView
    }()
}

extension ChainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension ChainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FliterChainCell.self)) as? FliterChainCell else {
            return UITableViewCell()
        }
        if indexPath.row < cells.count {
            cell.configCell(model: cells[indexPath.row])
        }
        return cell
    }
}

///
protocol FliterChainCellDataSource {
    
    var cellTitle: String? { get }
}

///
class FliterChainCell: UITableViewCell {
    
    func configCell(model: FliterChainCellDataSource) {
        titleLabel.text = model.cellTitle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 16.0, y: 0.0, width: bounds.size.width - 32.0, height: bounds.size.height)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = .darkText
        titleLabel.text = " "
        return titleLabel
    }()
}

