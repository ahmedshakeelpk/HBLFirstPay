//
//  barCodeVC.swift
//  MLKitFirebase
//
//  Created by MacMini on 17/12/2020.
//

import UIKit
import AVFoundation
import CoreVideo
import MLKit
protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}
class barCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    private let detectors: [Detector] = [
        //.onDeviceText,
        .onDeviceBarcode
      ]
    private var isCapturing = false
    weak var delegate: QRScannerViewDelegate?
    var fetchcnic : String?
    var overlays: UIView = UIView()
    private var currentDetector: Detector = .onDeviceBarcode
    private var isUsingFrontCamera = false
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblSccaniing: UILabel!
    private lazy var previewOverlayView: UIImageView = {
        
      precondition(isViewLoaded)
      let previewOverlayView = UIImageView(frame: .zero)
      previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
      previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return previewOverlayView
    }()

    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return annotationOverlayView
    }()

    private var lastDetector: Detector?

    // MARK: - IBOutlets
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var buttonsView: UIView!
    @IBOutlet private weak var textLb: UILabel!
    @IBOutlet private weak var savebtn: UIButton!
    @IBOutlet private weak var scanbtn: UIButton!
    
    var returnScanvalue: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblSccaniing.text = "Scaning your's CNIC".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
        addTransparentOverlayWithCirlce()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      startSession()
    }
    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)

      stopSession()
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      previewLayer.frame = cameraView.frame
    }

   
    @IBAction func scanbtn(_ sender: UIButton) {
        textLb.text = ""
        startSession()
    }
    @IBAction func savebtn(_ sender: UIButton) {
        textLb.text = ""
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ScanNLVC") as! ScanNLVC
        print("cnic ic:" ,fetchcnic)
         vc.scancnic = fetchcnic!
        self.navigationController!.pushViewController(vc, animated: true)
      
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func switchCamera(_ sender: Any) {
      isUsingFrontCamera = !isUsingFrontCamera
      removeDetectionAnnotations()
      setUpCaptureSessionInput()
    }
    
private func scanBarcodesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
  // Define the options for a barcode detector.
    let format = BarcodeFormat.all
  let barcodeOptions = BarcodeScannerOptions(formats: format)

  // Create a barcode scanner.
  let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
  var barcodes: [Barcode]
  do {
    barcodes = try barcodeScanner.results(in: image)
    
  } catch let error {
    print("Failed to scan barcodes with error: \(error.localizedDescription).")
    return
  }
  weak var weakSelf = self
  DispatchQueue.main.sync {
    guard let strongSelf = weakSelf else {
      print("Self is nil!")
      return
    }
    strongSelf.updatePreviewOverlayView()
    strongSelf.removeDetectionAnnotations()
  }
  guard !barcodes.isEmpty else {
    print("Barcode scanner returrned no results.")
    return
  }
  DispatchQueue.main.sync {
    guard let strongSelf = weakSelf else {
      print("Self is nil!")
      return
    }
    for barcode in barcodes {
      let normalizedRect = CGRect(
        x: barcode.frame.origin.x / width,
        y: barcode.frame.origin.y / height,
        width: barcode.frame.size.width / width,
        height: barcode.frame.size.height / height
      )
      let convertedRect = strongSelf.previewLayer.layerRectConverted(
        fromMetadataOutputRect: normalizedRect
      )
      UIUtilities.addRectangle(
        convertedRect,
        to: strongSelf.annotationOverlayView,
        color: UIColor.white.withAlphaComponent(0.5)
      )
  
      let label = UILabel(frame: convertedRect)
      label.text = barcode.rawValue
      textLb.text = barcode.rawValue
   
//        annotationOverlayView
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeFirst()
        textLb.text?.removeLast()
        fetchcnic = barcode.rawValue
        returnScanvalue?(textLb.text ?? "")
    let array = textLb.text?.components(separatedBy: "")
        print(array)
        let firstName = array?[0]
      label.adjustsFontSizeToFitWidth = true
    
      strongSelf.annotationOverlayView.addSubview(label)
        self.stopSession()
        self.navigationController?.popViewController(animated: true)
        
    }
  }
}


//
//private func recognizeTextOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
//  var recognizedText: Text
//  do {
//    recognizedText = try TextRecognizer.textRecognizer().results(in: image)
//  } catch let error {
//    print("Failed to recognize text with error: \(error.localizedDescription).")
//    return
//  }
//  weak var weakSelf = self
//  DispatchQueue.main.sync {
//    guard let strongSelf = weakSelf else {
//      print("Self is nil!")
//      return
//    }
//    strongSelf.updatePreviewOverlayView()
//    strongSelf.removeDetectionAnnotations()
//
//    // Blocks.
//    for block in recognizedText.blocks {
//      let points = strongSelf.convertedPoints(
//        from: block.cornerPoints, width: width, height: height)
//      UIUtilities.addShape(
//        withPoints: points,
//        to: strongSelf.annotationOverlayView,
//        color: UIColor.purple
//      )
//
//      // Lines.
//      for line in block.lines {
//        let points = strongSelf.convertedPoints(
//          from: line.cornerPoints, width: width, height: height)
//        UIUtilities.addShape(
//          withPoints: points,
//          to: strongSelf.annotationOverlayView,
//          color: UIColor.orange
//        )
//
//        // Elements.
//        for element in line.elements {
//          let normalizedRect = CGRect(
//            x: element.frame.origin.x / width,
//            y: element.frame.origin.y / height,
//            width: element.frame.size.width / width,
//            height: element.frame.size.height / height
//          )
//          let convertedRect = strongSelf.previewLayer.layerRectConverted(
//            fromMetadataOutputRect: normalizedRect
//          )
//          UIUtilities.addRectangle(
//            convertedRect,
//            to: strongSelf.annotationOverlayView,
//            color: UIColor.green
//          )
//          let label = UILabel(frame: convertedRect)
//          label.text = element.text
//          label.adjustsFontSizeToFitWidth = true
//          strongSelf.annotationOverlayView.addSubview(label)
//        }
//      }
//    }
//  }
//}
//     MARK: - Private

    private func setUpCaptureSessionOutput() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.beginConfiguration()
        // When performing latency tests to determine ideal capture settings,
        // run the app in 'release' mode to get accurate performance metrics
        strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
        ]
        output.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
        output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
        guard strongSelf.captureSession.canAddOutput(output) else {
          print("Failed to add capture session output.")
          return
        }
        strongSelf.captureSession.addOutput(output)
        strongSelf.captureSession.commitConfiguration()
      }
    }

    private func setUpCaptureSessionInput() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        let cameraPosition: AVCaptureDevice.Position = strongSelf.isUsingFrontCamera ? .front : .back
        guard let device = strongSelf.captureDevice(forPosition: cameraPosition) else {
          print("Failed to get capture device for camera position: \(cameraPosition)")
          return
        }
        do {
          strongSelf.captureSession.beginConfiguration()
          let currentInputs = strongSelf.captureSession.inputs
          for input in currentInputs {
            strongSelf.captureSession.removeInput(input)
          }

          let input = try AVCaptureDeviceInput(device: device)
          guard strongSelf.captureSession.canAddInput(input) else {
            print("Failed to add capture session input.")
            return
          }
          strongSelf.captureSession.addInput(input)
          strongSelf.captureSession.commitConfiguration()
        } catch {
          print("Failed to create capture device input: \(error.localizedDescription)")
        }
      }
    }

    private func startSession() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.startRunning()
      }
    }

    private func stopSession() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.stopRunning()
      }
    }

    private func setUpPreviewOverlayView() {
      cameraView.addSubview(previewOverlayView)
      NSLayoutConstraint.activate([
        previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
        previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
        previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
      ])
    }

    private func setUpAnnotationOverlayView() {
      cameraView.addSubview(annotationOverlayView)
      NSLayoutConstraint.activate([
        annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
        annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
        annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
      ])
    }

    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
      if #available(iOS 10.0, *) {
        let discoverySession = AVCaptureDevice.DiscoverySession(
          deviceTypes: [.builtInWideAngleCamera],
          mediaType: .video,
          position: .unspecified
        )
        return discoverySession.devices.first { $0.position == position }
      }
      return nil
    }

    private func presentDetectorsAlertController() {
      let alertController = UIAlertController(
        title: Constant.alertControllerTitle,
        message: Constant.alertControllerMessage,
        preferredStyle: .alert
      )
      weak var weakSelf = self
      detectors.forEach { detectorType in
        let action = UIAlertAction(title: detectorType.rawValue, style: .default) {
          [unowned self] (action) in
          guard let value = action.title else { return }
          guard let detector = Detector(rawValue: value) else { return }
          guard let strongSelf = weakSelf else {
            print("Self is nil!")
            return
          }
          strongSelf.currentDetector = detector
          strongSelf.removeDetectionAnnotations()
        }
        if detectorType.rawValue == self.currentDetector.rawValue { action.isEnabled = false }
        alertController.addAction(action)
      }
      alertController.addAction(UIAlertAction(title: Constant.cancelActionTitleText, style: .cancel))
      present(alertController, animated: true)
    }

    private func removeDetectionAnnotations() {
      for annotationView in annotationOverlayView.subviews {
        annotationView.removeFromSuperview()
      }
    }

    private func updatePreviewOverlayView() {
      guard let lastFrame = lastFrame,
        let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
      else {
        return
      }
      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
      let context = CIContext(options: nil)
      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
        return
      }
      let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
      if isUsingFrontCamera {
        guard let rotatedCGImage = rotatedImage.cgImage else {
          return
        }
        let mirroredImage = UIImage(
          cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
        previewOverlayView.image = mirroredImage
      } else {
        previewOverlayView.image = rotatedImage
      }
    }

    private func convertedPoints(
      from points: [NSValue]?,
      width: CGFloat,
      height: CGFloat
    ) -> [NSValue]? {
      return points?.map {
        let cgPointValue = $0.cgPointValue
        let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
        let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        let value = NSValue(cgPoint: cgPoint)
        return value
      }
    }

    private func normalizedPoint(
      fromVisionPoint point: VisionPoint,
      width: CGFloat,
      height: CGFloat
    ) -> CGPoint {
      let cgPoint = CGPoint(x: point.x, y: point.y)
      var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
      normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
      return normalizedPoint
    }
    
    private func resetManagedLifecycleDetectors(activeDetector: Detector) {
      if activeDetector == self.lastDetector {
        // Same row as before, no need to reset any detectors.
        return
      }
      self.lastDetector = activeDetector
    }
  }

  // MARK: AVCaptureVideoDataOutputSampleBufferDelegate

  extension barCodeVC: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(
      _ output: AVCaptureOutput,
      didOutput sampleBuffer: CMSampleBuffer,
      from connection: AVCaptureConnection
    ) {
      guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        print("Failed to get image buffer from sample buffer.")
        return
      }
      // Evaluate `self.currentDetector` once to ensure consistency throughout this method since it
      // can be concurrently modified from the main thread.
      let activeDetector = self.currentDetector
      resetManagedLifecycleDetectors(activeDetector: activeDetector)

      lastFrame = sampleBuffer
      let visionImage = VisionImage(buffer: sampleBuffer)
      let orientation = UIUtilities.imageOrientation(
        fromDevicePosition: isUsingFrontCamera ? .front : .back
      )

      visionImage.orientation = orientation
      let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
      let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
     
      //switch activeDetector {
     // case .onDeviceBarcode:
        scanBarcodesOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
        
      //case .onDeviceText:
       // recognizeTextOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
        guard
          let localModelFilePath = Bundle.main.path(
            forResource: Constant.localModelFile.name,
            ofType: Constant.localModelFile.type
          )
        else {
          print("Failed to find custom local model file.")
          return
        }
     // }
    }
  }
// MARK: - Constants

public enum Detector: String {
  case onDeviceBarcode = "Barcode Scanning"
 // case onDeviceText = "Text Recognition"

}

private enum Constant {
  static let alertControllerTitle = "Vision Detectors"
  static let alertControllerMessage = "Select a detector"
  static let cancelActionTitleText = "Cancel"
  static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
  static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
  static let noResultsMessage = "No Results"
  static let localModelFile = (name: "bird", type: "tflite")
  static let labelConfidenceThreshold = 0.75
  static let smallDotRadius: CGFloat = 4.0
  static let lineWidth: CGFloat = 3.0
  static let originalScale: CGFloat = 1.0
  static let padding: CGFloat = 10.0
  static let resultsLabelHeight: CGFloat = 200.0
  static let resultsLabelLines = 5
  static let imageLabelResultFrameX = 0.4
  static let imageLabelResultFrameY = 0.1
  static let imageLabelResultFrameWidth = 0.5
  static let imageLabelResultFrameHeight = 0.8
}


extension barCodeVC{
    func createOverlay() -> UIView {

        let overlayView = UIView(frame: self.view.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)



        let path = CGMutablePath()

        path.addRoundedRect(in: CGRect(x: 140, y: overlayView.center.y-140, width: overlayView.frame.width-300, height: 200), cornerWidth: 5, cornerHeight: 5)


        path.closeSubpath()
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 3.0
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = UIColor.clear.cgColor

        overlayView.layer.addSublayer(shape)

        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
//        maskLayer.fillRule = CAShapeLayerFillRule.

        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true

        return overlayView
    }

    func addTransparentOverlayWithCirlce()
    {
        overlays = createOverlay()
        view.addSubview(overlays)
        view.addSubview(buttonsView)
        self.cameraView.sendSubview(toBack: overlays)
        
    }
}

extension barCodeVC: AVCapturePhotoCaptureDelegate {
  
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      
        isCapturing = false
        print("photo", photo, photo.fileDataRepresentation())
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error while generating image from photo capture data.");
            return
        }
     }
 
}

