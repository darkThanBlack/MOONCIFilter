//
//  CustomNavigationView.swift
//  MOONCIFilter
//
//  Created by 徐一丁 on 2023/6/25.
//

import UIKit

class CustomNavigationView: UIView {
    
    
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var isRoot: Bool = true {
        didSet {
            backButton.isHidden = isRoot ? true : false
            closeButton.isHidden = isRoot ? true : true
        }
    }
    
    var closeHandler: (() -> Void)?
    
    var backHandler: (() -> Void)?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadSubViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonEvent() {
        backHandler?()
    }
    
    @objc private func closeButtonEvent() {
        closeHandler?()
    }
    
    // MARK: View
    
    private lazy var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.white.cgColor
        return shape
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        shape.path = path.cgPath
        
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        backButton.bounds = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        backButton.center = CGPoint(x: 16.0, y: bounds.midY)
        
        closeButton.bounds = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        closeButton.center = CGPoint(x: bounds.maxX - 30.0  - 16.0, y: bounds.midY)
        
        singleLine.frame = CGRect(x: 0, y: bounds.maxY - 0.5, width: bounds.maxX, height: 0.5)
    }
    
    private func loadSubViews(in box: UIView) {
        box.layer.addSublayer(shape)
        
        box.addSubview(titleLabel)
        box.addSubview(backButton)
        box.addSubview(closeButton)
        box.addSubview(singleLine)
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = MAFColorAdapter.DarkGrayA
        titleLabel.text = " "
        return titleLabel
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ic_arrow_list_common_left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonEvent), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "ic_close_window"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonEvent), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var singleLine: UIView = {
        let singleLine = UIView()
        singleLine.backgroundColor = MAFColorAdapter.WhiteD
        return singleLine
    }()
}

//private class Test {
//
//    /// [旧] 状态栏高度
//    ///
//    /// * 改为计算属性
//    /// * 注意时机，需在 ``window.makeKeyAndVisable`` 执行完毕后使用
//    /// * 作为替代，可以考虑利用 ``layoutSubViews``, ``safeAreaLayout`` 等方案变通：
//    /// ```
//    ///   // 示例: HQHomeViewController
//    ///   if #available(iOS 11.0, *) {
//    ///       make.bottom.equalTo(box.safeAreaLayoutGuide.snp.top).offset(44.0)
//    ///   }
//    /// ```
//    public var StatusBarHeight: CGFloat {
//        get {
//            ///
//            func oldHeight() -> CGFloat {
//                let height = UIApplication.shared.statusBarFrame.size.height
//                if #available(iOS 11.0, *) {
//                    return getKeyWindow()?.safeAreaInsets.top ?? height
//                } else {
//                    return height
//                }
//            }
//
//            if #available(iOS 13.0, *) {
//                return getScene()?.statusBarManager?.statusBarFrame.size.height ?? oldHeight()
//            } else {
//                return oldHeight()
//            }
//        }
//        set {}
//    }
//
//    /// 非分屏 APP 适配 Scene
//    ///
//    /// * [Refer](https://stackoverflow.com/questions/57134259)
//    /// * ``activationState``: 刚启动时是 ``.foregroundInactive`` 而非 ``foregroundActive``
//    @available(iOS 13.0, *)
//    private func getScene() -> UIWindowScene? {
//        return UIApplication
//            .shared
//            .connectedScenes
//            .compactMap({ ($0 as? UIWindowScene) })
//            .first
//    }
//
//    /// 非分屏 APP 适配 Window
//    ///
//    /// * [Refer](https://stackoverflow.com/questions/57134259)
//    private func getKeyWindow() -> UIWindow? {
//        if #available(iOS 13.0, *) {
//            return getScene()?
//                .windows
//                .first(where: { $0.isKeyWindow })
//            ?? UIApplication.shared.keyWindow
//        } else {
//            return UIApplication.shared.keyWindow
//        }
//    }
//}
