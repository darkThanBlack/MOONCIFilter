//
//  DetailViewController.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

///
class DetailViewController: UIViewController {
    
    private var cells: [ParamSliderCellDataSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
        
        mocks()
    }
    
    private func mocks() {
        let models: [ParamSliderModel] = [
            "inputBrightness"
        ].compactMap { name in
            return ParamSliderModel(name: name, min: -1, max: 1, def: 0)
        }
        cells = models
        
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
        }
        return cell
    }
}

//MARK: -

///
protocol ParamSliderCellDataSource: AnyObject {
    
    var sliderTitle: String? { get }
    
    var sliderValue: Float { get }
}
///
protocol ParamSliderCellDelegate: AnyObject {
    
    
    
}

///
class ParamSliderCell: UITableViewCell {
    
    weak var delegate: ParamSliderCellDelegate?
    
    func configCell(model: ParamSliderCellDataSource) {
        titleLabel.text = model.sliderTitle
        slider.value = model.sliderValue
    }
    
    @objc private func sliderChangedEvent() {
        
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
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 60.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 16.0, y: 0, width: titleLabel.bounds.size.width, height: titleLabel.bounds.size.height)
        
        let sSize = slider.sizeThatFits(CGSize(width: bounds.size.width - 32.0, height: bounds.size.height))
        slider.frame = CGRect(x: 16.0, y: titleLabel.frame.maxY, width: sSize.width, height: sSize.height)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(titleLabel)
        box.addSubview(slider)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        titleLabel.textColor = .lightText
        titleLabel.text = " "
        return titleLabel
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderChangedEvent), for: .valueChanged)
        return slider
    }()
    
}

