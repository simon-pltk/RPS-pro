//
//  CameraFeed.swift
//  RPS pro
//
//  Created by Simon Plotkin on 6/27/24.
//

/*

 Goal:
 * I want my app to show a live camera feed for about 5 whole seconds where three of those seconds are the countdown
and then by the time the player is supposed to throw out a move which then it runs machine learning code and determines which move you threw out
 and then sends you into another view where it determines the winner against you and another bot
 
 
 Plan:
 1. Have a global instance of the camera feed that exists across all views
 2.
 
 */
import AVFoundation
import CoreImage
import AVKit
import Vision

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
