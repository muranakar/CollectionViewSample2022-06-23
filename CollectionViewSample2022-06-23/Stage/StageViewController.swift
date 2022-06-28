//
//  StageViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/29.
//

import UIKit

class StageViewController: UIViewController {
    private var coin: Int
    private var characterType: CharacterType

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder: NSCoder,characterType: CharacterType) {
        self.coin = CoinRepository.load() ?? 0
        self.characterType = characterType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
