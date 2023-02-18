//
//  CanvasDataSource.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/10.
//

import UIKit

class CanvasDataSource: NSObject, Codable {
    var data: [Canvas] = []
    
    func addData(_ canvas: Canvas) {
        data.append(canvas)
    }
    func delete(_ idx: Int) {
        if idx >= 0 {
            data.remove(at: idx)
        }
    }
    func findTargetedIndexWithUUID(_ data: [Canvas], selectedUUID: String) -> Int{
        var targetIndex = -1
        if !data.isEmpty {
            for i in 0..<data.count {
                if data[i].canvasId == selectedUUID{
                    targetIndex = i
                }
            }
        }
        return targetIndex
    }
}

class Canvas: NSObject, Codable {
    var canvasId: String?
    var canvasImageUrl: String?
    var canvasName: String?
    var createdDate: String?
    
    init(id: String?, canvasImageUrl: String?, name: String?, date: String?) {
        self.canvasId = id
        self.canvasImageUrl = canvasImageUrl
        self.canvasName = name
        self.createdDate = date
    }
}

