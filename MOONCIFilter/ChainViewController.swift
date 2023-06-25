//
//  ChainViewController.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

///
class ChainViewController: UIViewController {
    
    private var cells = FilterEventBus.shared.filters
    
    weak var delegate: ChildsNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
        
        tableView.reloadData()
    }
    
    //MARK: View
    
    override func viewDidLayoutSubviews() {
        customBar.frame = CGRect(x: 0, y: 0, width: view.bounds.maxX, height: 44.0)
        tableView.frame = CGRect(x: 0, y: customBar.frame.maxY, width: view.bounds.maxX, height: view.bounds.maxY - 44.0)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(customBar)
        box.addSubview(tableView)
    }
    
    private lazy var customBar: CustomNavigationView = {
        let customBar = CustomNavigationView()
        customBar.title = "滤镜链"
        customBar.isRoot = true
        return customBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
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
        if indexPath.row < cells.count {
            let detailVC = DetailViewController()
            detailVC.delegate = delegate
            detailVC.cells = cells[indexPath.row].sliders
            delegate?.pushToChild(detailVC)
        }
    }
}

extension ChainViewController: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = cells[sourceIndexPath.row]
        cells.remove(at: sourceIndexPath.row)
        cells.insert(item, at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        
        FilterEventBus.shared.draw()
    }
    
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

