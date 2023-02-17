//
//  CanvasDataSource.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/10.
//

import UIKit

class CanvasDataSource: NSObject {
    var data: [Canvas] = []
    
    func addData(_ canvas: Canvas) {
        data.append(canvas)
    }
    func delete(_ idx: Int) {
        data.remove(at: idx)
    }
    func findUUID(_ idx: Int, data: [Canvas]) -> String {
        return data[idx].canvasId!
    }
}

class Canvas: NSObject {
    var canvasId: String?
    var canvasImage: String?
    var canvasName: String?
    var createdDate: String?
    
    init(id: String?, image: String?, name: String?, date: String?) {
        self.canvasId = id
        self.canvasImage = image
        self.canvasName = name
        self.createdDate = date
    }
}
