//
//  userData.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/09.
//

import Foundation
import UIKit

struct userData: Codable {
    let folder: [Folder]?
}

struct Folder: Codable {
    let folderName: String?
    let createDate: String?
    let folderMemo: String?
    let file: [File]?
}

struct File: Codable {
    let canvasImage: String?
    let canvasCreateDate: String?
    let canvasModifiedDate: String?
}
