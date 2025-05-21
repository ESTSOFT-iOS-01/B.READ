//
//  BarcodeScannerView.swift
//  B.READ
//
//  Created by 김도연 on 5/20/25.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

// MARK: - (S)BarcodeScannerView
struct BarcodeScannerView: View {
  @State private var inputImage: UIImage?
  @Binding var isbnNumber: String
  
  var body: some View {
    CustomCameraRepresentable(image: self.$inputImage, isbnNumber: $isbnNumber)
  }
}

// MARK: - (S)CustomCameraRepresentable
struct CustomCameraRepresentable: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  @Binding var isbnNumber: String
  
  func makeUIViewController(context: Context) -> CustomCameraController {
    let controller = CustomCameraController()
    controller.delegate = context.coordinator
    context.coordinator.bindPublisher(from: controller)
    
    return controller
  }
  
  func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self, isbnNumber: $isbnNumber)
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    let parent: CustomCameraRepresentable
    
    private var cancellables = Set<AnyCancellable>()
    @Binding var isbnNumber: String
    
    init(_ parent: CustomCameraRepresentable, isbnNumber: Binding<String>) {
      self.parent = parent
      _isbnNumber = isbnNumber
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      if let imageData = photo.fileDataRepresentation() {
        parent.image = UIImage(data: imageData)
      }
    }
    
    func bindPublisher(from controller: CustomCameraController) {
      controller.$scannedISBN
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
          self?.isbnNumber = value
          // isbnNumber가 비워지면 currentDetected 초기화 트리거
          if value.isEmpty {
            controller.resetTrigger = true
          }
        }
        .store(in: &cancellables)
    }
  }
}

// MARK: - UIViewController
class CustomCameraController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  var image: UIImage?
  var captureSession = AVCaptureSession()
  var currentCamera: AVCaptureDevice?
  var photoOutput: AVCapturePhotoOutput?
  var metadataOutput: AVCaptureMetadataOutput?
  var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
  
  @Published var scannedISBN: String = ""
  @Published var resetTrigger: Bool = false
  
  private var currentDetected: String = ""
  private var cancellables = Set<AnyCancellable>()
  
  var delegate: AVCapturePhotoCaptureDelegate?
  
  func didTapRecord() {
    let settings = AVCapturePhotoSettings()
    photoOutput?.capturePhoto(with: settings, delegate: delegate!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    setupCaptureSession()
    setupDevice()
    setupInputOutput()
    bindResetTrigger()
    setupPreviewLayer()
    captureSession.startRunning()
    
  }
  
  private func bindResetTrigger() {
    $resetTrigger
      .removeDuplicates()
      .filter { $0 == true }
      .sink { [weak self] _ in
        self?.currentDetected = ""
        self?.resetTrigger = false
      }
      .store(in: &cancellables)
  }
  
  func setupCaptureSession() {
    captureSession.sessionPreset = AVCaptureSession.Preset.photo
  }
  
  func setupDevice() {
    self.currentCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
  }
  
  func setupInputOutput() {
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
      captureSession.addInput(captureDeviceInput)
      photoOutput = AVCapturePhotoOutput()
      
      photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
      
      captureSession.addOutput(photoOutput!)
      metadataOutput = AVCaptureMetadataOutput()
      
      if metadataOutput != nil {
        captureSession.addOutput(metadataOutput!)
        metadataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput?.metadataObjectTypes = [.ean13]
      } else {
        return
      }
    } catch {
      print(error)
    }
    
  }
  
  func setupPreviewLayer() {
    self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    self.cameraPreviewLayer?.connection?.videoRotationAngle = 90.0
    self.cameraPreviewLayer?.frame = CGRect(
      x: 0,
      y: 0,
      width: self.view.frame.width,
      height: self.view.frame.width
    )
    self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
  }
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
          let value = object.stringValue,
          currentDetected != value else { return }
    
    // 중복 방지용 내부 상태 갱신
    currentDetected = value
    
    // 외부에 전달
    scannedISBN = value
  }
}
