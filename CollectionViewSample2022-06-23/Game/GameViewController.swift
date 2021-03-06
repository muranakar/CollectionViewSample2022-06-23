//
//  ViewController.swift
//  CollectionViewSample2022-06-23
//
//  Created by 村中令 on 2022/06/23.
//
// 参考URL: https://qiita.com/sgr-ksmt/items/56b11a61a545147c3aa3

import UIKit

class GameViewController: UIViewController {
    @IBOutlet private weak var coinNumLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var correctValueLabel: UILabel!

    private var columnsNum: Int
    private var levelNum: Int
    private var totalCoin: Int
    private var oneGameGetCoin: Int = 0
    private var randomValues: [String] = []
    private var correctRandomValue: String = ""
    private var characterType: CharacterType
    private var missCount: Int = 0
    private var gameFinishType: GameFinishType?
    // MARK: - タイマー関係のプロパティ
    let time:Float = 60.0
    var cnt:Float = 0
    var count: Float { time - cnt }
    var GameTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: characterType)
        configureViewCoinLabel()
        navigationController?.setNavigationBarHidden(true, animated: true)
        GameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countDown(timer: )),
            userInfo: nil,
            repeats: true
        )
    }

    private func configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: CharacterType) {
        let columnsNumPow = Int(pow(Double(columnsNum), 2))
        randomValues = Array(CsvConversion.convertFacilityInformationFromCsv(characterType: characterType).shuffled()[0...columnsNumPow - 1])
        correctRandomValue = randomValues.randomElement()!
        correctValueLabel.text = correctRandomValue
        collectionView.reloadData()
    }

    required init?(coder: NSCoder,levelNum: Int,characterType: CharacterType) {
        self.levelNum = levelNum
        self.columnsNum = levelNum + 1
        self.totalCoin = CoinRepository.load() ?? 0
        self.characterType = characterType
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Timer関係
    @objc func countDown(timer: Timer) {
        //カウントを１減らす
        cnt += 1
        //タイマーを止める
        if count < 0 {
            GameTimer?.invalidate()
            CoinRepository.save(coinNum: totalCoin)
            gameFinishType = .timeOut
            performSegue(withIdentifier: "result", sender: nil)
        }
    }
    // MARK: - View関係　アニメーションなど
    private func configureViewCoinLabel() {
        coinNumLabel.text = "×  \(CoinRepository.load() ?? 0)"
    }
    // TODO: アニメーション理解していない。
    private func configureViewCorrectAnswerImageView() {
        let imageView = UIImageView.init(image: UIImage(systemName: "circle"))
        imageView.tintColor = .red
        imageView.backgroundColor = UIColor(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        UIView.animate(withDuration: 1.0) {
                imageView.alpha = 0.01
        } completion: { bool in
            imageView.removeFromSuperview()
        }
    }
    private func configureViewIncorrectAnswerImageView() {

        let imageView = UIImageView.init(image: UIImage(systemName: "xmark"))
        imageView.tintColor = UIColor(named: "string")
        imageView.backgroundColor = UIColor(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        UIView.animate(withDuration: 1.0) {
                imageView.alpha = 0.01
        } completion: { bool in
            imageView.removeFromSuperview()
        }
    }
}
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomValues.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                           for: indexPath) as! CollectionViewCell
        cell.configure(text: randomValues[indexPath.row])

        return cell
    }

}

private extension GameViewController {
    @IBSegueAction
    func makeResultVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ResultViewController? {
        return ResultViewController(
            coder: coder,gameFinishType: gameFinishType!,oneGameGetCoin: oneGameGetCoin
        )
    }

    @IBAction
    func backToGameViewController(segue: UIStoryboardSegue) {
    }
}


extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let isCorrectValue = randomValues[indexPath.row] == correctRandomValue
        if isCorrectValue {
            // 正解したときの処理
            switch characterType {
            case .hiragana:
                totalCoin += 1 * (levelNum + 1)
                oneGameGetCoin += 1 * (levelNum + 1)
            case .katakana:
                totalCoin += 2 * (levelNum + 1)
                oneGameGetCoin += 2 * (levelNum + 1)
            case .emoji:
                totalCoin += 3 * (levelNum + 1)
                oneGameGetCoin += 3 * (levelNum + 1)
            case .kanzi:
                totalCoin += 5 * (levelNum + 1)
                oneGameGetCoin += 5 * (levelNum + 1)
            }
            CoinRepository.save(coinNum: totalCoin)
            configureRandomValueAndCorrectRandomValueAndCollectionViewReload(characterType: characterType)
            configureViewCoinLabel()
            configureViewCorrectAnswerImageView()
        } else {
            //　不正解だったときの処理
            configureViewIncorrectAnswerImageView()
            missCount += 1
            if missCount == 5 {
                GameTimer?.invalidate()
                CoinRepository.save(coinNum: totalCoin)
                gameFinishType = .missBySelection
                performSegue(withIdentifier: "result", sender: nil)
            }
        }
    }

}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize : CGFloat = self.collectionView.bounds.width / CGFloat(columnsNum) - 2
        return CGSize(width: cellSize, height: cellSize)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
