//
//  ViewController.swift
//  DownloadPDF
//
//  Created by Prabhakar Kasi on 8/21/19.
//  Copyright © 2019 20DayOffice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var downloadButton:UIButton!
    var pdfURL: URL? {
        didSet {
            print("Cached location \(String(describing: pdfURL))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    @IBAction func viewPdfButtonTapped(_ sender: UIButton) {
        guard let pdfURL = self.pdfURL else {
            print("pdfURL is nil")
            return
        }
        
        guard let resourcePath = Bundle.main.url(forResource: "swift", withExtension: "pdf") else {
            print("resource is nil")
            return
        }
        
        let pdfViewController = PDFViewController(pdfURL: resourcePath)
        present(pdfViewController, animated: true, completion: nil)
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation", location)
        
        // cerate destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        
        guard let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

