# AIdea Skfetch

### App Feature

<table>
<tr>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219871706-dddf36b4-bbc2-475c-926e-f66075c51c0f.png" width="220" height="450" />
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870119-5040b0af-532b-4dd9-a13f-3b5d50226173.gif" width="220" height="450"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870117-f5b56d0a-8883-4f6b-bf52-adc0f1aaa341.gif" width="220" height="450"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/219870897-d8b300eb-e4cb-49e5-8025-5135242246a4.gif" width="220" height="450"/>
</td>
</tr>
</table>


### App Description

&nbsp; 이 앱은 사용자의 `Idea`를 [Dell:2의 OpenAI]("https://platform.openai.com/docs/api-reference/images/create") 이미지 생성을 통하여 쉽고 간편하게 그림을 그릴 수 있도록 앱입니다.
&nbsp; `OpenAI`을 통해 사용자는 단순히 키워드를 입력하여 고품질 이미지를 `쉽게` 생성할 수 있으므로 `최소한의 노력`으로 다양한 시각적 요소를 스케치에 `통합`할 수 있습니다.
&nbsp; 아티스트, 디자이너 또는 단순히 자신의 창의적인 측면을 탐구하려는 사람이든 관계없이 새롭고 흥미로운 방식으로 아이디어를 `실현`하는 데 사용할 수 있습니다.

### How to run

```
> cd AIdeaSkfetch-iOS
> open AIdeaSkfetch-iOS.xcodeproj
> ...
```

### Core Features

스케치 앱의 주요 기능인 스케치를 위해서 `Canvas`모델을 사용합니다.
```Swift
class Canvas: NSObject, Codable {
    var canvasId: String?
    var canvasImageUrl: String?
    var canvasName: String?
    var createdDate: String?
    init(id: String?, canvasImageUrl: String?, name: String?, date: String?) {...}
}
```
주요 기능 중에는 그릴때 필요한 `브러시`, `지우개`, `실행취소 / 다시실행`과 같은 다양한 기능과 브러시 너비, 불투명도 및 색상 설정을 조정하는 설정이 포함되어 있습니다.
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
추가적으로, 이 앱은 `collection view`를 사용하여 각각의 생성된 스케치에 대한 간단한 저장 및 불러오기를 `iOS FileManager`를 사용합니다.
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
`Setting ViewController`는 브러시 폭, 투명도, 색상과 같은 도구 설정을 할 수 있는 `Setting View`를 작동시키며, 이 기능을 통하여 `CanvasView`의 값을 update합니다.
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
`Search ViewController`는 이 앱의 중요한 기능인 API 키워드 검색을 작동시키며, `Search View`를 모달로 4개의 이미지를 보여주며 원하는 이미지를 선택할 수 있습니다.
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
선택된 이미지는 delegate protocol을 통하여 `CanvasView`의 `drawImage`에 fetch 하여 수정가능하게 합니다.
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
이 기능들은 사용자에게 아이디어를 스케치 할때에 영감을 제공합니다.





