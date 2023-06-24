//
//  FilterModel.swift
//  MOONCIFilter
//
//  Created by 月之暗面 on 2023/6/24.
//

import UIKit


///
class FilterBaseModel {
    
    let filter: CIFilter
    
    init?(name: String) {
        guard let f = CIFilter(name: name) else {
            return nil
        }
        self.filter = f
    }
}

extension FilterBaseModel: FliterChainCellDataSource {
    
    var cellTitle: String? {
        return filter.name
    }
}

class ParamBaseModel {
    
    let name: String
    
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
