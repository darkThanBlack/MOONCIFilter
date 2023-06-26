//
//  FilterModel.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit


///
class FilterModel {
    
    let name: String
    
    let filter: CIFilter
    
    let sliders: [ParamSliderModel]
    
    init?(name: String, sliders: [ParamSliderModel]) {
        guard let f = CIFilter(name: name) else {
            return nil
        }
        self.name = name
        self.filter = f
        self.sliders = sliders
    }
    
    func syncParams() {
        sliders.forEach({ param in
            if param.current > param.min {
                filter.setValue(param.current, forKey: param.name)
            } else {
                filter.setValue(nil, forKey: param.name)
            }
        })
    }
}

extension FilterModel: FliterChainCellDataSource {
    
    var cellTitle: String? {
        return filter.name
    }
}

class ParamBaseModel {
    
    let name: String
    
    // todo: value / key
    
    init(name: String) {
        self.name = name
    }
}

class ParamSliderModel: ParamBaseModel {
    
    var min: Float
    
    var max: Float
    
    var def: Float
    
    var current: Float
    
    init(name: String, min: Float, max: Float, def: Float) {
        self.min = min
        self.max = max
        self.def = def
        self.current = def
        super.init(name: name)
    }
}

extension ParamSliderModel: ParamSliderCellDataSource {
    
    var sliderTitle: String? {
        return name
    }
    
    var sliderCurrent: String? {
        return "滑块值: \(sliderValue), 实际值: \(current)"
    }
    
    /// [0, 1]
    var sliderValue: Float {
        set {
            current = min + newValue * (max - min)
        }
        get {
            return (current - min) / ((max - min) == 0 ? 1 : (max - min))
        }
    }
}
