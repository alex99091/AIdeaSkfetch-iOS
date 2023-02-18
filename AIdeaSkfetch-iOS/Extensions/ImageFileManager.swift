//
//  ImageFileManager.swift
//  AIdeaSkfetch-iOS
//
//  Created by BOONGKI KWAK on 2023/02/18.
//

import UIKit

class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    
    // Canvas의 UUID로 이미지 가져오기
    func getSavedImage(named: String) -> UIImage? {
        if let dir: URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                       appropriateFor: nil, create: false) {
            let path: String = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
            let image: UIImage? = UIImage(contentsOfFile: path)
            return image
        }
        return nil
    }
    // Canvas의 imageurlpath로부터 이미지가져오기
    
    // Canvas의 이미지 경로 저장
    func getSavedImageDir(named: String) -> String? {
        if let dir: URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                       appropriateFor: nil, create: false) {
            let path: String = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
            return path
        }
        return ""
    }
    
    func saveImage(image: UIImage, name: String, onSuccess: @escaping ((Bool) -> Void)) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        
        if let directory: NSURL = try? FileManager.default.url(for: .documentDirectory,
                                                               in: .userDomainMask,
                                                               appropriateFor: nil, create: false) as NSURL {
            do {
                try data.write(to: directory.appendingPathComponent(name)!)
                onSuccess(true)
            } catch let error as NSError {
                print("Could not saveImage🥺: \(error), \(error.userInfo)")
                onSuccess(false)
            }
        }
    }
    
    func deleteImage(named: String, onSuccess: @escaping ((Bool) -> Void)) {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        do {
            if let docuPath = directory.path {
                let fileNames = try FileManager.default.contentsOfDirectory(atPath: docuPath)
                for fileName in fileNames {
                    if fileName == named {
                        let filePathName = "\(docuPath)/\(fileName)"
                        try FileManager.default.removeItem(atPath: filePathName)
                        onSuccess(true)
                        return
                    }
                }
            }
        } catch let error as NSError {
            print("Could not deleteImage🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
