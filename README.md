# AIdea Skfetch

### App Feature

<table>
<tr>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219871706-dddf36b4-bbc2-475c-926e-f66075c51c0f.png" width="160" height="330"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870119-5040b0af-532b-4dd9-a13f-3b5d50226173.gif" width="160" height="330"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870117-f5b56d0a-8883-4f6b-bf52-adc0f1aaa341.gif" width="160" height="330"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870897-d8b300eb-e4cb-49e5-8025-5135242246a4.gif" width="160" height="330"/>
</td>
</tr>
</table>


### App Description

&nbsp;Our `new sketch app` is designed to make drawing easy and accurate, with a `special feature` that sets it apart from other sketching apps: `integration` with [`Dell:2's OpenAI-image generator`]("https://platform.openai.com/docs/api-reference/images/create").  

&nbsp;With this integration, users can easily generate `high-quality images` by simply `typing` in `keywords`, allowing them to `incorporate` a `wide variety` of `visual elements` into their sketches with minimal effort.  

&nbsp;Whether you're an artist, designer, or simply someone looking to `explore` your creative side, our sketch app is a powerful tool that can help you `bring your ideas` to life in new and exciting ways.   

### How to run

```
> cd AIdeaSkfetch-iOS
> open AIdeaSkfetch-iOS.xcodeproj
> ...
```

### Core Features

The main functions of the sketching app include using a digital `canvas` to create visual art, 
```Swift
class Canvas: NSObject, Codable {
    var canvasId: String?
    var canvasImageUrl: String?
    var canvasName: String?
    var createdDate: String?
    init(id: String?, canvasImageUrl: String?, name: String?, date: String?) {...}
}
```
which includes various features such as `brushes`, `erasers`, `undo/redo`, and settings to adjust the brush width, opacity, and color settings. 
```Swift
func drawSketch(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        ...
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        ...
        drawImage.alpha = opacity
        ...
        UIGraphicsEndImageContext()
    }
```
Additionally, the app uses a `collection view` to display saved sketches that are saved to disk using `iOS FileManager`, which provides easy `navigation` and `access` to saved sketches.
```Swift
class ImageFileManager {
    static let shared: ImageFileManager = ImageFileManager()
    func saveImage(image: UIImage, name: String, onSuccess: @escaping ((Bool) -> Void)) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        
        if let directory: NSURL = try? FileManager.default.url(for: .documentDirectory,  in: .userDomainMask,  appropriateFor: nil, create: false) as NSURL {
            do {
                try data.write(to: directory.appendingPathComponent(name)!)
                onSuccess(true)
            } catch let error as NSError {
                onSuccess(false)
            }
        }
    }
}
```

The `setting function` in the `Canvas` tool allows users to adjust various parameters, such as brush width, opacity, and color settings. The user can select the desired value by touching a corresponding circle. This feature allows for more customization and precision when creating art on the `canvas`.
```Swift
func setupSliders() {
        // brush
        brushCircularSlider.addTarget(self, action: #selector(updateBrush), for: .valueChanged)
        // opacity
        opacityCircularSlider.addTarget(self, action: #selector(updateOpacity), for: .valueChanged)
        // color
        colorPalletteSlider.addTarget(self, action: #selector(updateColors), for: .valueChanged)
        brightnessSlider.addTarget(self, action: #selector(matchColor), for: .valueChanged)
}
```

Another function of the app is the `search function` for images using keywords. It retrieves image data from the Dell:2 OPEN AI image generator and displays four images to the user, 
```Swift
SearchAPI.searchSketch(prompt: searchTerm, completion: { [weak self] result in
    guard let self = self else { return }
    switch result {
    case .success(let response):
        if let imageUrls: [Datum] = response.data {
        self.fetchedImageUrlList = imageUrls
        DispatchQueue.main.async { self.reloadInputViews() }
    case .failure(let failure):
         print("failure: \(failure)")
    }
})
```
allowing them to select one to display on the `canvas view controller`. 
```Swift
extension CanvasVC: SearchVCDelegate {
    func searchVCFinished(_ searchVC: SearchVC) {
        fetchedImageUrl = searchVC.fetchedImageUrl
        self.dataFetched = true
        self.fetchImageToCanvas()
        dismiss(animated: true)
    }
}
```

This feature provides users with more options and inspiration when creating art on the canvas.





