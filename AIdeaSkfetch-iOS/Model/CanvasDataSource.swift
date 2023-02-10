//
//  CanvasDataSource.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/10.
//

import UIKit

class CanvasDataSource {
    var data: [Canvas] = []
    
    func addData(_ canvas: Canvas) {
        data.append(canvas)
    }
    func delete(_ cellRow: Int) {
        data.remove(at: cellRow)
    }
}

class Canvas: Identifiable {
    let now = Date()
    let date = DateFormatter()
    var canvasId: String?
    var canvasImage: UIImage?
    var canvasName: String?
    var createdDate: String?
    var canvasCommands: [Command]
    
    init(id: String?, image: UIImage?, name: String?, date: String?, commands: [Command]) {
        self.canvasId = id
        self.canvasImage = image
        self.canvasName = name
        self.createdDate = date
        self.canvasCommands = commands
    }
}

struct Command {
    var drawLines: [String?]
}
