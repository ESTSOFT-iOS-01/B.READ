//
//  WebView.swift
//  B.READ
//
//  Created by 김도연 on 6/1/25.
//

import WebKit
import SwiftUI

struct WebView: UIViewControllerRepresentable {
  var url: URL

  func makeUIViewController(context: Context) -> CustomWebViewController {
    let controller = CustomWebViewController()
    controller.url = url
    return controller
  }

  func updateUIViewController(_ uiViewController: CustomWebViewController, context: Context) {
    uiViewController.url = url
    uiViewController.loadWebPageIfNeeded()
  }
}

#Preview {
  WebView(url: URL(string: "http://www.naver.com")!)
}

final class CustomWebViewController: UIViewController, WKNavigationDelegate {
  var url: URL?
  private var webView: WKWebView!
  private var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // WebView setup
    webView = WKWebView(frame: .zero)
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(webView)
    
    // Activity Indicator setup
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .green5
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)
    
    // Layout
    NSLayoutConstraint.activate([
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadWebPageIfNeeded()
  }
  
  func loadWebPageIfNeeded() {
    guard let url else { return }
    webView.load(URLRequest(url: url))
  }
  
  // MARK: - WKNavigationDelegate
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicator.startAnimating()
    activityIndicator.isHidden = false
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
  }
  
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
  }
}
