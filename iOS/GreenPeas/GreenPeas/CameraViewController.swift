//
//  ViewController.swift
//  GreenPeas
//
//  Created by Calvin Tantio on 23/2/19.
//  Copyright © 2019 Calvin Tantio. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    let cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 160, y: UIScreen.main.bounds.height - 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"camera"), for: .normal)
        button.backgroundColor = .white
        return button
    }()

    let captureSession = AVCaptureSession()

    // input
    var backCamera: AVCaptureDevice?

    // output
    var photoOutput: AVCapturePhotoOutput?
    var imageOutput: UIImage?

    // preview layer
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            guard let self = self else { return }
            if response {
                self.setUpCameraButton()
                self.setUpCamera()
            } else {
                self.dismiss(animated: true)
            }
        }

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }

    @objc
    private func back() {
        dismiss(animated: true, completion: nil)
    }

    private func setUpCameraButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cameraButton.addTarget(self, action: #selector(self.capture), for: .touchUpInside)
            self.view.addSubview(self.cameraButton)
        }
    }

    private func setUpCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        backCamera = AVCaptureDevice.default(for: .video)

        // output settings
        photoOutput = AVCapturePhotoOutput()

        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera!)
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(photoOutput!)

            // set up camera preview layer
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view.layer.addSublayer(self.cameraPreviewLayer!)
                self.cameraPreviewLayer?.frame = self.view.layer.frame
                self.view.bringSubviewToFront(self.cameraButton)
            }
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

            captureSession.startRunning()
        } catch {
            print(error)
        }
    }

    @objc
    private func capture() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeLinear, animations: {

            // make the button grow and become dark gray
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.cameraButton.frame.size.height = self.cameraButton.frame.size.height * 2
                self.cameraButton.frame.size.width = self.cameraButton.frame.size.width * 2

                self.cameraButton.frame.origin.x = self.cameraButton.frame.origin.x - (self.cameraButton.frame.size.width / 4)
                self.cameraButton.frame.origin.y = self.cameraButton.frame.origin.y - (self.cameraButton.frame.size.height / 4)
                self.cameraButton.layer.cornerRadius = 0.5 * self.cameraButton.bounds.size.width
                self.cameraButton.backgroundColor = UIColor(red: 0.329, green: 0.753, blue: 0.012, alpha: 1)

            }

            // restore the button to original size and color
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.cameraButton.frame = CGRect(x: 160, y: UIScreen.main.bounds.height - 100, width: 50, height: 50)
                self.cameraButton.layer.cornerRadius = 0.5 * self.cameraButton.bounds.size.width
                self.cameraButton.backgroundColor = .white
            }
        }, completion: nil)

        let settings = AVCapturePhotoSettings()
        settings.livePhotoVideoCodecType = .jpeg
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        self.imageOutput = UIImage(data: data!)
        alerting()
//        upload(img: imageOutput!)
//        print(imageOutput)
    }

//    private func upload(img: UIImage) {
//        let imageData = img.jpegData(compressionQuality: 90)!
//        let url = URL(string: "https://us-central1-green-peas.cloudfunctions.net/clientPost")
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.httpBody = imageData
//
//        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
//            (data, response, error) -> Void in
//            if let data = data {
//                print("success")
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        })
//
//        task.resume()
//    }

    private func alerting() {
        let alertController = UIAlertController(title: "Processing Photo", message: "Finding similar products in store", preferredStyle: .alert)

        let action1 = UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: "photosTaken")
            self.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(action1)

        self.present(alertController, animated: true, completion: nil)
    }

//    private func upload() {
//        let url = URL(string: "https://us-central1-green-peas.cloudfunctions.net/clientPost")!
//        var request = URLRequest(url: url)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        let parameters: [String: Any] = [
//            "id": 13,
//            "name": "Jack & Jill"
//        ]
//        request.httpBody = parameters.percentEscaped().data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                let response = response as? HTTPURLResponse,
//                error == nil else {                                              // check for fundamental networking error
//                    print("error", error ?? "Unknown error")
//                    return
//            }
//
//            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//        }
//
//        task.resume()
//    }
}

