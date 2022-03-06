//
//  ViewController.swift
//  Practice_PinLayout
//
//  Created by Jinwoo Kim on 3/6/22.
//

import UIKit
import Combine
import PinLayout

final class ViewController: UIViewController {
    private var primaryTitleLabel: UILabel!
    private var secondaryTitleLabel: UILabel!
    private var creditCardItemViews: [CreditCardItemView.CreditType: CreditCardItemView] = [:]
    private var highlightedCreditCardItemViews: [CreditCardItemView] = []
    
    private var cancellableBag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        configurePrimaryTitleLabel()
        configureSecondaryTitleLabel()
        configureCreditCardItemViews()
        bind()
    }
    
    private func setAttributes() {
        view.backgroundColor = .white
    }
    
    private func configurePrimaryTitleLabel() {
        let primaryTitleLabel: UILabel = .init()
        primaryTitleLabel.backgroundColor = .clear
        primaryTitleLabel.textColor = .black
        primaryTitleLabel.text = "카드사 선택하기"
        view.addSubview(primaryTitleLabel)
        self.primaryTitleLabel = primaryTitleLabel
    }
    
    private func configureSecondaryTitleLabel() {
        let secondaryTitleLabel: UILabel = .init()
        secondaryTitleLabel.backgroundColor = .clear
        secondaryTitleLabel.textColor = .gray
        secondaryTitleLabel.text = "추가 환급액 확인을 위해 연동할 카드사를 선택해 주세요."
        view.addSubview(secondaryTitleLabel)
        self.secondaryTitleLabel = secondaryTitleLabel
    }
    
    private func configureCreditCardItemViews() {
        CreditCardItemView.CreditType.allCases.forEach { creditType in
            let item: CreditCardItemView = .init(with: creditType, delegate: self)
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.cornerRadius = 10.0
            item.layer.shadowOpacity = 0.2
            self.view.addSubview(item)
            self.creditCardItemViews[creditType] = item
        }
    }
    
    private func bind() {
        view.publisher(for: \.frame, options: [.initial, .new])
            .removeDuplicates()
            .receive(on: OperationQueue.main)
            .sink { [weak self] _ in
                self?.relayout()
            }
            .store(in: &cancellableBag)
    }
    
    private func relayout() {
        primaryTitleLabel.pin.top(view.pin.safeArea.top).left(view.pin.safeArea.left).margin(30.0).sizeToFit()
        secondaryTitleLabel.pin.below(of: primaryTitleLabel, aligned: .left).sizeToFit()
        
        CreditCardItemView.CreditType.allCases.forEach { creditType in
            let item: CreditCardItemView = self.creditCardItemViews[creditType]!
            
            item.pin.width((100 / 3)%)
            item.pin.sizeToFit(.height)
            
            let row: Int = (creditType.rawValue / 3)
            let column: Int = (creditType.rawValue % 3)
            
            switch row {
            case 0:
                switch column {
                case 0:
                    item.pin.below(of: self.secondaryTitleLabel, aligned: .left)
                default:
                    let leadingItem: CreditCardItemView = self.creditCardItemViews[.init(rawValue: (row * 3) + (column - 1))!]!
                    item.pin.top(to: self.secondaryTitleLabel.edge.bottom)
                    item.pin.left(to: leadingItem.edge.right)
                }
            default:
                let topItem: CreditCardItemView = self.creditCardItemViews[.init(rawValue: ((row - 1) * 3 + column))!]!
                
                switch column {
                case 0:
                    item.pin.below(of: topItem, aligned: .left)
                default:
                    let leadingItem: CreditCardItemView = self.creditCardItemViews[.init(rawValue: (row * 3) + (column - 1))!]!
                    item.pin.top(to: topItem.edge.bottom)
                    item.pin.left(to: leadingItem.edge.right)
                }
            }
        }
        
        highlightedCreditCardItemViews = []
    }
    
    private func toggleHighlightingtemView(_ itemView: CreditCardItemView) {
        let isHighlighted: Bool = highlightedCreditCardItemViews.contains(itemView)
        
        if isHighlighted {
            // TODO : 선택된 아이템만 업데이트하도록
            relayout()
        } else {
            UIView.animate(withDuration: 0.3) {
                itemView.pin.center()
            }
            highlightedCreditCardItemViews.append(itemView)
        }
    }
}

extension ViewController: CreditCardItemViewDelegate {
    func creditCardItemView(_ view: CreditCardItemView, didTapWithTapGesture: UITapGestureRecognizer) {
        toggleHighlightingtemView(view)
    }
}
