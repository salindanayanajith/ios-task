import UIKit
import RxSwift


/**
 The cell which displays a campaign.
 */
class CampaignCell: UICollectionViewCell {

    private let disposeBag = DisposeBag()
    
    static let headerFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
    static let descFont = UIFont(name: "HoeflerText-Regular", size: 12.0)

    /** Used to display the campaign's title. */
    @IBOutlet private(set) weak var nameLabel: UILabel!

    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    /** The image view which is used to display the campaign's mood image. */
    @IBOutlet private(set) weak var imageView: UIImageView!

    /** The mood image which is displayed as the background. */
    var moodImage: Observable<UIImage>? {
        didSet {
            moodImage?
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    self?.imageView.image = image
                    })
                .disposed(by: disposeBag)
        }
    }

    /** The campaign's name. */
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        assert(nameLabel != nil)
        assert(descriptionLabel != nil)
        assert(imageView != nil)
    }
    
    public func reorderComponents(ind: IndexPath)  {
        let screenSize = UIScreen.main.bounds
        
        //let imgFrame = imageView.frame
        let h1 = (screenSize.width/4) * 3
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screenSize.width, height: h1))
        
        let lines = nameLabel.text?.getLineCount(forFont: CampaignCell.headerFont!)
        var h2 = nameLabel.text?.getHeight(forFont: CampaignCell.headerFont!)
        if lines! > 2{
            h2 = ((h2!/CGFloat(lines!)) * 2) + 16
        }
        nameLabel.frame = CGRect(origin: CGPoint(x: 8, y: h1), size: CGSize(width: nameLabel.frame.size.width, height: h2!))
        
        let h3 = descriptionLabel.text?.getHeight(forFont: CampaignCell.descFont!)
        descriptionLabel.frame = CGRect(origin: CGPoint(x: 0, y: h1+h2!+8), size: CGSize(width: nameLabel.frame.size.width, height: h3!))
        
        for constraint in self.nameLabel.constraints {
            if constraint.identifier == "headerLblConst" {
                constraint.constant = h2!
            }
        }
        for constraint in self.descriptionLabel.constraints {
            if constraint.identifier == "descLblConst" {
                constraint.constant = h3!
            }
        }
        
        self.nameLabel.layoutIfNeeded()
        self.descriptionLabel.layoutIfNeeded()
        
    }
}
