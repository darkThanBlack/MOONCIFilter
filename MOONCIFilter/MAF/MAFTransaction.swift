//
//  MAFTransactions.swift
//  MountingAndFraming
//
//  Created by 徐一丁 on 2023/5/29.
//

import UIKit

/// 事务类型
enum MAFTransTypes: String {
    /// select image step 01
    case updateImageRef
    /// select image step 02
    case updateImageData
    /// select image step 03
    case updateImageUI
    /// 色彩调节
    case filterSlider
    
    var tasks: [String] {
        var datas: [MAFTaskKeys] = []
        switch self {
        case .updateImageRef:
            datas = [.queryImage, .storeImage]
        case .updateImageData:
            datas = [.userSize, .smartColor]
        case .updateImageUI:
            datas = [.filter]
        case .filterSlider:
            datas = [.filter]
        }
        return datas.map { $0.rawValue }
    }
}

/// 任务类型
enum MAFTaskKeys: String {
    /// 从缓存读取图片
    case queryImage
    /// 将图片同步到缓存
    case storeImage
    /// 确定图片尺寸
    case userSize
    /// 获取智能颜色
    case smartColor
    /// 应用 CIFilter 滤镜
    case filter
}

/// 事件管道
///
/// imporve: assert(isTimeout)
/// improve: assert(isMainThread)
class MAFTransaction {
    
    static let shared = MAFTransaction()
    
    private var transList: [MAFTransaction.Trans?] = []
    
    func commit(_ value: MAFTransaction.Trans) {
        var index: Int = -2
        for (idx, item) in transList.enumerated() {
            if item?.type == value.type {
                index += 1
            }
            if index == 0 {
                index = idx
                break
            }
        }
        if index > 0 {
            transList[index] = nil
            transList.remove(at: index)
        }
        transList.append(value)
    }
    
    func register(to commitId: String, key: MAFTaskKeys, action: ((_ completed: (() -> Void)?) -> Void)?) {
        register(to: commitId, key: key.rawValue, action: action)
    }
    
    private func register(to commitId: String, key: String, action: ((_ completed: (() -> Void)?) -> Void)?) {
        guard let trans = transList.first(where: { $0?.commitId == commitId }),
              let task = trans?.tasks[key] else {
            return
        }
        task.action = action
        
        fire()
    }
    
    private var runner: MAFTransaction.Trans? = nil
    
    private func fire() {
        guard runner == nil else {
            return
        }
        guard transList.count > 0 else {
            return
        }
        guard let tran = transList.first(where: { $0?.canFire == true }) else {
            return
        }
        runner = tran
        
        runner?.tasks.forEach({ (_, task: MAFTransaction.Task) in
            task.action?({ [weak self] in
                task.isFinished = true
                if self?.runner?.isRunning == true {
                    return
                }
                self?.runner?.allTaskCompleted?()
                self?.transList.removeAll(where: { $0?.commitId == self?.runner?.commitId })
                self?.runner = nil
                
                self?.fire()
            })
        })
    }
}

extension MAFTransaction {
    
    class Trans {
        
        let commitId: String = "\(Date().timeIntervalSince1970)"
        
        let type: String
        
        private(set) var tasks: [String: MAFTransaction.Task]
        
        private(set) var allTaskCompleted: (()->())?
        
        var canFire: Bool {
            if tasks.contains(where: { $0.value.action == nil }) {
                return false
            }
            return true
        }
        
        var isRunning: Bool {
            if tasks.contains(where: { $0.value.isFinished == false }) {
                return true
            }
            return false
        }
        
        init(type: String, tasks: [String], allTaskCompleted: (() -> Void)? = nil) {
            self.type = type
            var dict: [String: MAFTransaction.Task] = [:]
            tasks.forEach { key in
                dict[key] = MAFTransaction.Task(key: key)
            }
            self.tasks = dict
            self.allTaskCompleted = allTaskCompleted
        }
        
        convenience init(type: MAFTransTypes, allTaskCompleted: (() -> Void)? = nil) {
            self.init(
                type: type.rawValue,
                tasks: type.tasks,
                allTaskCompleted: allTaskCompleted
            )
        }
    }
    
    class Task {
        
        let key: String
        
        var action: ((_ completed: (() -> Void)?) -> Void)? = nil
        
        var isFinished: Bool = false
        
        init(key: String) {
            self.key = key
        }
    }
}
