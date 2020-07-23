//Copyright © 2019 Apple Inc.

//swiftlint:disable line_length
//Permission is hereby granted, free of charge, to any person obtaininga copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//swiftlint:disable line_length
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Speech
protocol SpeechViewControllerDelegate: class {
    func speechControllerDidFinish(with results: [SFTranscription])
}

import UIKit

public class SpeechViewController: UIViewController, SFSpeechRecognizerDelegate {
    // MARK: Properties

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    private var recognitionTask: SFSpeechRecognitionTask?

    private let audioEngine = AVAudioEngine()

    // MARK: View Controller Lifecycle

    var recordButton: UIButton!
    weak var delegate: SpeechViewControllerDelegate?
    var wordConstraints: [String]?

    public override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.lightPurple

        recordButton = UIButton(type: .custom)
        recordButton.addTarget(self, action: #selector(recordButtonTouched), for: .touchDown)
        recordButton.addTarget(self, action: #selector(recordButtonReleased), for: .touchUpInside)
        recordButton.backgroundColor = UIColor.darkPink
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        recordButton.frame = CGRect(x: 200, y: 100, width: 50, height: 50)
        recordButton.layer.cornerRadius = 35
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.imageView?.contentMode = .scaleAspectFill
        recordButton.contentVerticalAlignment = .fill
        recordButton.contentHorizontalAlignment = .fill
        recordButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        recordButton.tintColor = .white
        recordButton.adjustsImageWhenHighlighted = false
        recordButton.showsTouchWhenHighlighted = false

        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 70),
            recordButton.heightAnchor.constraint(equalToConstant: 70)
        ])

    }

    public func setContext(context: [String]?) {
        wordConstraints = context
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                case .denied:
                    self.recordButton.isEnabled = false
                case .restricted:
                    self.recordButton.isEnabled = false
                case .notDetermined:
                    self.recordButton.isEnabled = false
                default:
                    self.recordButton.isEnabled = false
                }
            }
        }
    }

    private func startRecording() throws {

        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil

        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.taskHint = .search
        if let wordConstraints = wordConstraints {
            recognitionRequest?.contextualStrings = wordConstraints
        }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true

        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }

        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                // Update the text view with the results.
                isFinal = result.isFinal
                if isFinal {
                    self.delegate?.speechControllerDidFinish(with: result.transcriptions)
                }
            }

            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordButton.isEnabled = true

            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024,
                             format: recordingFormat) { (buffer: AVAudioPCMBuffer, _ : AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    // MARK: SFSpeechRecognizerDelegate

    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }

    // MARK: Record Button Actions

    @objc func recordButtonTouched() {
        do {
            try startRecording()
            recordButton.backgroundColor = .purple
        } catch {
            recordButton.setTitle("Recording Not Available", for: [])
        }
    }

    @objc func recordButtonReleased() {
        recordButton.backgroundColor = .darkPink
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
        }
    }
}
