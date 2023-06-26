//
//  photoPreview.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit

///
class photoPreviewView: UIView {
    
    enum Modes {
        
        case vertical
        
        case horizontal
    }
    
    var originalImage: UIImage? = nil {
        didSet {
            originalImageView.image = originalImage
            setNeedsLayout()
        }
    }
    
    var resultImage: UIImage? = nil {
        didSet {
            resultImageView.image = originalImage
            setNeedsLayout()
        }
    }
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViews(in: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(needDrawFilter), name: FilterEventBus.shared.key, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let context = CIContext()
    
    /// [CP] from ``MAFPreviewImageView``
    @objc private func needDrawFilter(_ sender: Notification) {
        let trans = MAFTransaction.Trans(type: .filterSlider)
        MAFTransaction.shared.commit(trans)
        
        MAFTransaction.shared.register(
            to: trans.commitId,
            key: .filter
        ) { [weak self] completed in
            ///
            func fail() {
                DispatchQueue.main.async {
                    completed?()
                }
            }
            
            func getCI(from image: UIImage) -> CIImage? {
                var ci = image.ciImage
                if ci == nil, let cg = image.cgImage {
                    ci = CIImage(cgImage: cg)
                }
                if ci == nil {
                    ci = CIImage(image: image)
                }
                return ci
            }
            
            DispatchQueue.global().async {
                let startTime = Date().timeIntervalSince1970 * 1000
                
                guard let image = self?.originalImage,
                      let ci = getCI(from: image) else {
                    fail()
                    return
                }
                let oldScale = image.scale
                let oldOrientation = image.imageOrientation
                var result: CIImage? = ci
                
//                for (_, model) in FilterEventBus.shared.filters.enumerated() {
//                    if let value = result {
//                        model.filter.setValue(value, forKey: kCIInputImageKey)
//                        model.syncParams()
//                        result = model.filter.outputImage ?? model.filter.value(forKey: kCIOutputImageKey) as? CIImage
//                    }
//                }
                
                // test
                for (_, model) in FilterEventBus.shared.filters.enumerated() {
                    if let filter = CIFilter(name: model.name),
                       let inputImage = result {
                        filter.setValue(inputImage, forKey: kCIInputImageKey)
                        model.sliders.forEach({ param in
                            if param.current > param.min {
                                filter.setValue(param.current, forKey: param.name)
                            }
                        })
                        if let output = filter.outputImage ?? filter.value(forKey: kCIOutputImageKey) as? CIImage {
                            result = output
                        }
                    }
                }
                
                guard let res = result,
                    let cg = self?.context.createCGImage(res, from: ci.extent) else {
                    fail()
                    return
                }
                /// 预解码
                // let decode = MAFDatasManager.imageDecode(from: UIImage(cgImage: cg, scale: oldScale, orientation: oldOrientation))
                let decode = UIImage(cgImage: cg, scale: oldScale, orientation: oldOrientation)
                
                let endTime = Date().timeIntervalSince1970 * 1000
                
                let drawTime = endTime - startTime
                
                DispatchQueue.main.async {
                    self?.timeLabel.text = "单次渲染耗时：\(String(format: "%.1f", drawTime))毫秒"
                    self?.resultImageView.image = decode
                    completed?()
                }
            }
        }
    }
    
    //MARK: View
    
    private var scale: CGFloat {
        // AVMakeRect(aspectRatio: , insideRect: )
        var scale: CGFloat = 1.0
        if let w = originalImage?.size.width, w > 0,
           let h = originalImage?.size.height, h > 0 {
            scale = h / w
        }
        return scale
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(UIScreen.main.bounds.size)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: size.width * scale * 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        originalImageView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.width * scale)
        resultImageView.frame = CGRect(x: 0, y: originalImageView.frame.maxY, width: originalImageView.frame.size.width, height: originalImageView.frame.size.height)
        
        timeLabel.frame = CGRect(x: 16.0, y: 16.0, width: 150.0, height: 20.0)
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(originalImageView)
        box.addSubview(resultImageView)
        box.addSubview(timeLabel)
    }
    
    private lazy var originalImageView: UIImageView = {
        let originalImageView = UIImageView()
        originalImageView.contentMode = .scaleAspectFit
        return originalImageView
    }()
    
    private lazy var resultImageView: UIImageView = {
        let resultImageView = UIImageView()
        resultImageView.contentMode = .scaleAspectFit
        return resultImageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        timeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        timeLabel.textColor = MAFColorAdapter.LightGrayA
        timeLabel.text = " "
        timeLabel.textAlignment = .center
        return timeLabel
    }()
}

