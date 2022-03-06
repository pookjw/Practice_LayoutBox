//
//  CreditCardItemView.swift
//  Practice_FlexLayout
//
//  Created by Jinwoo Kim on 3/6/22.
//

import UIKit
import FlexLayout

protocol CreditCardItemViewDelegate: AnyObject {
    func creditCardItemView(_ view: CreditCardItemView, didTapWithTapGesture: UITapGestureRecognizer)
}

final class CreditCardItemView: UIView {
    enum CreditType: Int, CaseIterable {
        case shinhan = 0, samsung, hyundai, kookmin, lotte, woori, hana, nh, bc
        
        fileprivate var image: UIImage! {
            let imageName: String
            
            switch self {
            case .shinhan:
                imageName = "img_card_shinhan"
            case .samsung:
                imageName = "img_card_samsung"
            case .hyundai:
                imageName = "img_card_hyundai"
            case .kookmin:
                imageName = "img_card_hana-1"
            case .lotte:
                imageName = "img_card_lotte"
            case .woori:
                imageName = "img_card_woori"
            case .hana:
                imageName = "img_card_hana"
            case .nh:
                imageName = "img_card_nh"
            case .bc:
                imageName = "img_card_bc"
            }
            
            return UIImage(named: imageName, in: .main, with: nil)
        }
        
        fileprivate var title: String {
            switch self {
            case .shinhan:
                return "신한카드"
            case .samsung:
                return "삼성카드"
            case .hyundai:
                return "현대카드"
            case .kookmin:
                return "KB국민카드"
            case .lotte:
                return "롯데카드"
            case .woori:
                return "우리카드"
            case .hana:
                return "하나카드"
            case .nh:
                return "농협카드"
            case .bc:
                return "BC카드"
            }
        }
    }
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var tapGesture: UITapGestureRecognizer!
    private var creditType: CreditType!
    private weak var delegate: CreditCardItemViewDelegate!

    override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout(mode: .fitContainer)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 101.0, height: 80.0)
    }
    
    convenience init(with creditType: CreditType, delegate: CreditCardItemViewDelegate) {
        self.init()
        self.creditType = creditType
        self.delegate = delegate
        
        configureImageView()
        configureTitleLabel()
        configureTapGesture()
        configureLayoutContainer()
        setAttributes(with: creditType)
    }
    
    private func configureImageView() {
        let imageView: UIImageView = .init()
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = false
        addSubview(imageView)
        self.imageView = imageView
    }
    
    private func configureTitleLabel() {
        let titleLabel: UILabel = .init()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false
        addSubview(titleLabel)
        self.titleLabel = titleLabel
    }
    
    private func configureTapGesture() {
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(tapGestureTriggered(_:)))
        addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    private func configureLayoutContainer() {
        flex.direction(.column).padding(5.0).alignItems(.center).define { flex in
            flex.addItem(self.imageView).size(CGSize(width: 50.0, height: 40.0))
            flex.addItem(self.titleLabel)
        }
    }
    
    private func setAttributes(with creditType: CreditType) {
        backgroundColor = .white
        isUserInteractionEnabled = true
        imageView.image = creditType.image
        titleLabel.text = creditType.title
    }
    
    @objc private func tapGestureTriggered(_ sender: UITapGestureRecognizer) {
        delegate.creditCardItemView(self, didTapWithTapGesture: sender)
    }
}
