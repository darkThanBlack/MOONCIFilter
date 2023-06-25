//
//  MainViewController.swift
//  MOONCIFilter
//
//  Created by 徐一丁 on 2023/6/21.
//

import UIKit

class FilterEventBus {
    
    static let shared = FilterEventBus()
    private init() {}
    
    let key = NSNotification.Name("k_fiilter_draw")
    
    var filters: [FilterModel] = [
        FilterModel(name: "CISharpenLuminance", sliders: [
            ParamSliderModel(name: "inputSharpness", min: 0, max: 2, def: 0.4),
            ParamSliderModel(name: "inputRadius", min: 0, max: 20, def: 1.69)
        ]),
        FilterModel(name: "CIColorControls", sliders: [
            ParamSliderModel(name: "inputBrightness", min: 0.3, max: 0.7, def: 0.5),
            ParamSliderModel(name: "inputContrast", min: 0, max: 4, def: 2),
            ParamSliderModel(name: "inputSaturation", min: 0, max: 2, def: 1)
        ])
    ].compactMap({ $0 })
    
    func draw() {
        NotificationCenter.default.post(name: key, object: nil)
    }
}

protocol ChildsNavigationDelegate: AnyObject {
    
    func pushToChild(_ viewController: UIViewController?)
    
    func popWithChild(_ viewController: UIViewController?)
}

///Main
class MainViewController: UIViewController {
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(scrollView)
        scrollView.addSubview(preview)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageEvent(button:)))
        self.navigationItem.rightBarButtonItems = [addItem]
        
        
        addChild(chainVC)
        self.view.addSubview(chainVC.view)
    }
    
    //MARK: Event
    
    @objc private func addImageEvent(button: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: View
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.size.height * 0.7)
        
        let pSize = preview.sizeThatFits(view.bounds.size)
        preview.frame = CGRect(x: 0, y: 0, width: pSize.width, height: pSize.height)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: preview.frame.maxY)
        
        let cHeight = view.bounds.size.height * 0.3
        chainVC.view.frame = CGRect(x: 0, y: view.bounds.maxY - cHeight + 8.0, width: view.bounds.size.width, height: cHeight - 8.0 - 34.0)
    }
    
    private func loadViews(in box: UIView) {
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var preview: photoPreviewView = {
        let preview = photoPreviewView()
        return preview
    }()
    
    private lazy var chainVC: ChainViewController = {
        let chain = ChainViewController()
        chain.delegate = self
        return chain
    }()
    
    private var detailVC: DetailViewController? = nil
}

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        preview.originalImage = image
        
        preview.setNeedsLayout()
        preview.layoutIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        picker.dismiss(animated: true)
    }
}

extension MainViewController: ChildsNavigationDelegate {
    
    func pushToChild(_ viewController: UIViewController?) {
        guard let vc = viewController else { return }
        
        addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.frame = chainVC.view.frame
        vc.didMove(toParent: self)
    }
    
    func popWithChild(_ viewController: UIViewController?) {
        guard let vc = viewController else { return }
        
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
}
