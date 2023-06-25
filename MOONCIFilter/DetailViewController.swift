//
//  DetailViewController.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

///
class DetailViewController: UIViewController {
    
    var cells: [ParamSliderCellDataSource] = []
    
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
        customBar.title = "滤镜参数"
        customBar.isRoot = false
        customBar.backHandler = { [weak self] in
            self?.delegate?.popWithChild(self)
        }
        return customBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
         tableView.register(ParamSliderCell.self, forCellReuseIdentifier: String(describing: ParamSliderCell.self))
        return tableView
    }()
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do nth.
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ParamSliderCell.self)) as? ParamSliderCell else {
            return UITableViewCell()
        }
        if indexPath.row < cells.count {
            cell.configCell(model: cells[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
}

extension DetailViewController: ParamSliderCellDelegate {
    
    func sliderValueDidChanged(_ cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row, index < cells.count else {
            return
        }
        let item = cells[index]
        
    }
}

//MARK: -

///
protocol ParamSliderCellDataSource: AnyObject {
    
    var sliderTitle: String? { get }
    
    var sliderCurrent: String? { get }
    
    var sliderValue: Float { get set }
}
///
protocol ParamSliderCellDelegate: AnyObject {
    
    func sliderValueDidChanged(_ cell: UITableViewCell)
}

///
class ParamSliderCell: UITableViewCell {
    
    weak var delegate: ParamSliderCellDelegate?
    
    weak var model: ParamSliderCellDataSource?
    
    func configCell(model: ParamSliderCellDataSource) {
        self.model = model
        
        titleLabel.text = model.sliderTitle
        currentLabel.text = model.sliderCurrent
        slider.value = model.sliderValue
    }
    
    @objc private func sliderChangedEvent() {
        model?.sliderValue = slider.value
        
        titleLabel.text = model?.sliderTitle
        currentLabel.text = model?.sliderCurrent
        
        FilterEventBus.shared.draw()
        
        setNeedsLayout()
    }
    
    //MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        loadViews(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 4+20+4+34+4)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 4+20+4+34+4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 16.0, y: 4.0, width: titleLabel.bounds.size.width, height: 20.0)
        
        currentLabel.sizeToFit()
        currentLabel.frame = CGRect(x: bounds.maxX - currentLabel.bounds.maxX - 16.0, y: 4.0, width: currentLabel.bounds.size.width, height: 20.0)
        
        slider.frame = CGRect(x: 16.0, y: titleLabel.frame.maxY + 4.0, width: bounds.maxX - 32.0, height: 34.0)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(currentLabel)
        box.addSubview(slider)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        titleLabel.textColor = MAFColorAdapter.GrayA
        titleLabel.text = " "
        return titleLabel
    }()
    
    private lazy var currentLabel: UILabel = {
        let currentLabel = UILabel()
        currentLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        currentLabel.textColor = MAFColorAdapter.LightGrayA
        currentLabel.text = " "
        currentLabel.textAlignment = .right
        return currentLabel
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderChangedEvent), for: .valueChanged)
        return slider
    }()
    
}

