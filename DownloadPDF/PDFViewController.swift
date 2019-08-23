//
//  PDFViewController.swift
//  DownloadPDF
//
//  Created by Prabhakar Kasi on 8/22/19.
//  Copyright © 2019 20DayOffice. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    private let pdfURL: URL
    private let document: PDFDocument!
    private let outline: PDFOutline?
    private let pdfView = PDFView()
    private let thumbnailView = PDFThumbnailView()
    private var outlineButton = UIButton()

    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        self.document = PDFDocument(url: pdfURL)
        self.outline = document.outlineRoot
        pdfView.document = document
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPDFView()
        setupThumbnailView()
        setupOutlineButton()

        // Close the PDFViewer after 3 seconds until we add close button
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func setupPDFView() {
        view.addSubview(pdfView)
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false

        // Add contstraints
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupThumbnailView() {
        thumbnailView.pdfView = pdfView
        thumbnailView.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.thumbnailSize = CGSize(width: 80, height: 100)
        thumbnailView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(thumbnailView)
        
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add contstraints
        thumbnailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        thumbnailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thumbnailView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        thumbnailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupOutlineButton() {
        outlineButton = UIButton(frame: CGRect(x: view.frame.maxX - 90, y: 45, width: 60, height: 50))
        outlineButton.layer.cornerRadius = outlineButton.frame.width / 2
        outlineButton.setTitle("三", for: .normal)
        outlineButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        outlineButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        outlineButton.setTitleColor(.white, for: .normal)
        outlineButton.backgroundColor = .black
        outlineButton.alpha = 0.8
        view.addSubview(outlineButton)
        outlineButton.addTarget(self, action: #selector(toggleOutline(sender:)), for: .touchUpInside)
    }
    
    @objc func toggleOutline(sender: UIButton) {
        guard let outline = self.outline else {
            print("PDF has no outline")
            return
        }
        
        let outlineViewController = OutlineTableViewController(outline: outline, delegate: self)
        outlineViewController.preferredContentSize = CGSize(width: 300, height: 400)
        outlineViewController.modalPresentationStyle = .popover
        
        let popoverPresentationController = outlineViewController.popoverPresentationController
        popoverPresentationController?.sourceView = outlineButton
        popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width/2, y: sender.frame.height, width: 0, height: 0)
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.delegate = self
        
        self.present(outlineViewController, animated: true, completion: nil)
    }
}


extension PDFViewController: OutlineDelegate {
    func goTo(page: PDFPage) {
        pdfView.go(to: page)
    }
}

extension PDFViewController: UIPopoverPresentationControllerDelegate {
    
}
