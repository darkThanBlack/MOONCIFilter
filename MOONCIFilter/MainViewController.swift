//
//  MainViewController.swift
//  MOONCIFilter
//
//  Created by 徐一丁 on 2023/6/21.
//

import UIKit

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
        scrollView.frame = view.bounds
        
        let pSize = preview.sizeThatFits(view.bounds.size)
        preview.frame = CGRect(x: 0, y: 0, width: pSize.width, height: pSize.height)
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width, height: preview.frame.maxY)
        
        chainVC.view.frame = CGRect(x: 0, y: view.bounds.size.height / 2.0 + 8.0, width: view.bounds.size.width, height: view.bounds.size.height / 2.0 - 8.0)
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
        return chain
    }()
}

extension MainViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        preview.originalImage = image
        
        view.setNeedsLayout()
        
        picker.dismiss(animated: true)
    }
}
