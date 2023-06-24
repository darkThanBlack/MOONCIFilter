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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(originalImageView)
        box.addSubview(resultImageView)
    }
    
    private lazy var originalImageView: UIImageView = {
        let originalImageView = UIImageView()
        originalImageView.contentMode = .scaleAspectFill
        return originalImageView
    }()
    
    private lazy var resultImageView: UIImageView = {
        let resultImageView = UIImageView()
        resultImageView.contentMode = .scaleAspectFill
        return resultImageView
    }()
}

