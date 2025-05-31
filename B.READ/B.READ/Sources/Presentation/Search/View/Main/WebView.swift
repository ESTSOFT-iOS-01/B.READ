//
//  WebView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import WebKit
import SwiftUI

struct WebView : UIViewControllerRepresentable {
  var url: URL
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<WebView>) -> CustomWebViewContorller {
    return CustomWebViewContorller()
  }
  
  func updateUIViewController(_ uiViewController: CustomWebViewContorller, context: UIViewControllerRepresentableContext<WebView>) {
    uiViewController.url = url
  }
}

#Preview {
  WebView(url: URL(string: "http://www.naver.com")!)
}

class CustomWebViewContorller: UIViewController {
  var url: URL?
  private var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView = WKWebView(frame: .zero)
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)

    NSLayoutConstraint.activate([
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let url else { return }
    webView.load(URLRequest(url: url))
  }
}

