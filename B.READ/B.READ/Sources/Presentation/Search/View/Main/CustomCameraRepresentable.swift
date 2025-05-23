//
//  CustomCameraRepresentable.swift
//  B.READ
//
//  Created by 김도연 on 5/20/25.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

// MARK: - (S)CustomCameraRepresentable
struct CustomCameraRepresentable: UIViewControllerRepresentable {
  @Binding var isbnNumber: String
  @Binding var noCamera: Bool
  
  internal func makeUIViewController(context: Context) -> CustomCameraController {
    let controller = CustomCameraController()
    context.coordinator.bindPublisher(from: controller)
    
    return controller
  }
  
  internal func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
  }
  
  
  internal func makeCoordinator() -> Coordinator {
    Coordinator(self, isbnNumber: $isbnNumber, noCamera: $noCamera)
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    let parent: CustomCameraRepresentable
    
    private var cancellables = Set<AnyCancellable>()
    @Binding var isbnNumber: String
    @Binding var noCamera: Bool
    
    init(
      _ parent: CustomCameraRepresentable,
      isbnNumber: Binding<String>,
      noCamera: Binding<Bool>
    ) {
      self.parent = parent
      _isbnNumber = isbnNumber
      _noCamera = noCamera
    }
    
    internal func bindPublisher(from controller: CustomCameraController) {
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
      
      controller.$noCamera
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
          self?.noCamera = value
        }
        .store(in: &cancellables)
    }
  }
}

// MARK: - UIViewController
class CustomCameraController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  private var captureSession = AVCaptureSession()
  private var currentCamera: AVCaptureDevice?
  private var metadataOutput: AVCaptureMetadataOutput?
  private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
  
  @Published var scannedISBN: String = ""
  @Published var resetTrigger: Bool = false
  @Published var noCamera: Bool = false
  
  private var currentDetected: String = ""
  private var cancellables = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !captureSession.isRunning {
      DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.startRunning()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if captureSession.isRunning {
      DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.stopRunning()
      }
    }
  }
  
  deinit {
    print("camera deinitialized")
  }
  
  private func setup() {
    setupCaptureSession()
    setupDevice()
    setupInputOutput()
    bindResetTrigger()
    setupPreviewLayer()
    
  }
  
  private func bindResetTrigger() {
    $resetTrigger
      .removeDuplicates()
      .filter { $0 }
      .sink { [weak self] _ in
        self?.currentDetected = ""
        self?.resetTrigger = false
      }
      .store(in: &cancellables)
  }
  
  private func setupCaptureSession() {
    captureSession.sessionPreset = .photo
  }
  
  private func setupDevice() {
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
      noCamera = true
      return
    }
    
    currentCamera = device
  }
  
  private func setupInputOutput() {
    do {
      // MARK: - 카메라 입력
      guard let currentCamera else {
        noCamera = true
        return
      }
      let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
      if captureSession.canAddInput(captureDeviceInput) {
        captureSession.addInput(captureDeviceInput)
      }
      
      let metadataOutput = AVCaptureMetadataOutput()
      if captureSession.canAddOutput(metadataOutput) {
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.ean13]
        self.metadataOutput = metadataOutput
      }
    } catch {
      print(error)
    }
    
  }
  
  private func setupPreviewLayer() {
    cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    cameraPreviewLayer?.videoGravity = .resizeAspectFill
    cameraPreviewLayer?.connection?.videoRotationAngle = 90.0
    cameraPreviewLayer?.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: view.frame.width
    )
    
    if let previewLayer = cameraPreviewLayer {
      view.layer.insertSublayer(previewLayer, at: 0)
    }
  }
  
  internal func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
          let value = object.stringValue,
          currentDetected != value else { return }
    
    // 중복 방지용 내부 상태 갱신
    currentDetected = value
    
    // 외부에 전달
    scannedISBN = value
  }
}
