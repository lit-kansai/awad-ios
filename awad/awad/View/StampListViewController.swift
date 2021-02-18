//
//  StampListViewController.swift
//  awad
//
//  Created by tomoya tanaka on 2021/01/30.
//

import UIKit

class StampListViewController: UIViewController {
	
	let titleHeader: Header = Header(imageName: "stamp")
	let background: BackgroundUIImageView = BackgroundUIImageView(imageName: "stampBackground")
	let achievementRatioLabel: UILabel = UILabel()
	var stamp: UIImageView = UIImageView(image: #imageLiteral(resourceName: "monument"))
	let stampBackground: UIView = UIView()
	var stampTitleLabel: UILabel = UILabel()
	var stampDescriptionLabel: UILabel = UILabel()
	let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	var stampCollectionView: UICollectionView!
	let stampInformation: [[Any]] = [
		[#imageLiteral(resourceName: "monument"), "公園スタンプ", "公園でゲットした \n お手洗いも合ってちょうど良かったね。" ],
		[#imageLiteral(resourceName: "slime"), "スライムスタンプ", "スライムでゲットした \n お手洗いも合ってちょうど良かったね。"],
		[#imageLiteral(resourceName: "shrine"), "神社スタンプ", "神社でゲットした \n お手洗いも合ってちょうど良かったね。"]
	]
		
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupView()
		self.addConstraints()
		stampCollectionView.dataSource = self
		stampCollectionView.delegate = self
		stampCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)
		titleHeader.animate()
		// アニメーション
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
}

extension StampListViewController {
	func setupView() {
		stampCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		
		background.activateConstraint(parent: view)
		titleHeader.activateConstraint(parent: view)
		
		stampBackground.addSubview(stamp)
		view.addSubview(achievementRatioLabel)
		view.addSubview(stampBackground)
		view.addSubview(stampTitleLabel)
		view.addSubview(stampDescriptionLabel)
		view.addSubview(stampCollectionView)
		
		flowLayout.minimumLineSpacing = 35
		stampBackground.backgroundColor = .white
		stampBackground.layer.cornerRadius = 18
		stamp.contentMode = .scaleAspectFit
		stampTitleLabel.font = UIFont(name: "Keifont", size: 20)
		stampTitleLabel.text = "公園スタンプ"
		
		stampDescriptionLabel.font = UIFont(name: "Keifont", size: 15)
		stampDescriptionLabel.text = "公園でゲットした \n お手洗いも合ってちょうど良かったね。"
		stampDescriptionLabel.textAlignment = .center
		stampDescriptionLabel.numberOfLines = 0
		
		achievementRatioLabel.textColor = #colorLiteral(red: 0.9503150582, green: 0.9693611264, blue: 0.9732105136, alpha: 1)
		let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "10/20")
		attributedString.addAttribute(NSAttributedString.Key.kern, value: 3, range: NSRange(location: 0, length: attributedString.length))
		achievementRatioLabel.attributedText = attributedString
		stampCollectionView.backgroundColor = .clear
	}
	
	func addConstraints() {
		stampBackground.translatesAutoresizingMaskIntoConstraints = false
		stamp.translatesAutoresizingMaskIntoConstraints = false
		stampTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		stampDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		achievementRatioLabel.translatesAutoresizingMaskIntoConstraints = false
		stampCollectionView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			stampBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
			stampBackground.heightAnchor.constraint(equalTo: stampBackground.widthAnchor),
			stampBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.18),
			
			stamp.centerXAnchor.constraint(equalTo: stampBackground.centerXAnchor),
			stamp.centerYAnchor.constraint(equalTo: stampBackground.centerYAnchor),
			stamp.widthAnchor.constraint(equalTo: stampBackground.widthAnchor, multiplier: 0.9),
			stamp.heightAnchor.constraint(equalTo: stampBackground.heightAnchor, multiplier: 0.9),
			
			stampTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampTitleLabel.topAnchor.constraint(equalTo: stampBackground.bottomAnchor, constant: 30),
			
			stampDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stampDescriptionLabel.topAnchor.constraint(equalTo: stampTitleLabel.bottomAnchor, constant: 10),
			
			achievementRatioLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.6),
			achievementRatioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			
			stampCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
			stampCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
			stampCollectionView.topAnchor.constraint(equalTo: achievementRatioLabel.bottomAnchor, constant: 40),
			stampCollectionView.leadingAnchor.constraint(equalTo: achievementRatioLabel.leadingAnchor)
		])
	}
}

extension StampListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		let imageView: UIImageView = UIImageView(image: (stampInformation[indexPath.row % 3][0] as! UIImage))
		cell.addSubview(imageView)
		cell.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
			imageView.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.9),
			imageView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.9)
		])
		cell.backgroundColor = .white
		cell.layer.cornerRadius = 9
		
		let selectedBGView: UIView = UIView(frame: cell.frame)
		selectedBGView.layer.borderWidth = 3
		selectedBGView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		selectedBGView.backgroundColor = .white
		selectedBGView.layer.cornerRadius = 9
		cell.selectedBackgroundView = selectedBGView
		
		return cell
	}
	
}

extension StampListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		stamp.image = stampInformation[indexPath.row % 3][0] as? UIImage
		stampTitleLabel.text = stampInformation[indexPath.row % 3][1] as? String
		stampDescriptionLabel.text = stampInformation[indexPath.row % 3][2] as? String
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true  // 変更
	}

	func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		return true  // 変更
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
}

extension StampListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.2, height: collectionView.frame.width * 0.2)
		}
}
