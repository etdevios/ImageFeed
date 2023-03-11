//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.02.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private var backButton: UIButton!
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        
        webView.navigationDelegate = self
        
        downloadWebContent()
        createViews()
        addSubviews()
        addViewConstraints()
    }
    
    private func updateProgress() {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    private func createViews() {
        view.backgroundColor = .ypWhite
        backButton = {
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setImage(UIImage(named: "nav_back_button"), for: .normal)
            return button
        }()
        
            progressView.progressViewStyle = .default
            progressView.progressTintColor = .ypBlack
    }
    
    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func addSubviews() {
        [webView, backButton, progressView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func addViewConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
        ])
    }
}

//MARK: private methods
private extension WebViewViewController {
    private func downloadWebContent() {
        var urlComponents = URLComponents(string: K.API.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: K.API.accessKey),
            URLQueryItem(name: "redirect_uri", value: K.API.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: K.API.accessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//MARK: WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
