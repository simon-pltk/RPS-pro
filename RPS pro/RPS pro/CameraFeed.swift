//
//  CameraFeed.swift
//  RPS pro
//
//  Created by Simon Plotkin on 6/27/24.
//

/*
 
 */
import AVFoundation
import CoreImage

class CameraFeed: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var permission = true
    private let context = CIContext()
    
    func checkPerms() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.permission = true
            
        case .notDetermined:
            self.requestPermissions()
            
        default:
            self.permission = false
        }
    }
    
    func requestPermissions() {
        
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permission = granted
        }
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permission else { return }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        guard captureSession.canAddInput(deviceInput) else { return }
        captureSession.addInput(deviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
        captureSession.sessionPreset = .photo
    }
    
    
    override init() {
        super.init()
        self.checkPerms()
        sessionQueue.async{ [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
}

extension CameraFeed: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        
        return cgImage
    }
}
