//
//  CustomMessagesCollectionViewCellIncoming.swift
//  Night Owl
//
//  Created by Alex Albert on 7/6/18.
//  Copyright © 2018 Alex Albert. All rights reserved.
//

/*import UIKit
import JSQMessagesViewController

class CustomMessagesCollectionViewCellIncoming: JSQMessagesCollectionViewCellIncoming {

	var msgLbl : UILabel?
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		self.messageBubbleTopLabel?.textAlignment = NSTextAlignment.left
		self.cellBottomLabel?.textAlignment = NSTextAlignment.left
		
		
		msgLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 30))
		msgLbl!.textAlignment = .left
		msgLbl!.textColor = UIColor.black
		msgLbl!.numberOfLines = 0
		msgLbl!.lineBreakMode = .byWordWrapping
		msgLbl!.backgroundColor = UIColor.white
		msgLbl!.sizeToFit()
		self.contentView.addSubview(msgLbl!)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override class func cellReuseIdentifier() -> String
	{
		return "MyCustomIncomingCell"
	}
	
	override func layoutSubviews()
	{
		msgLbl!.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 30)
	}
	
	
    /*override func viewDidLoad() {
        super.viewDidLoad()

		self.incomingCellIdentifier = CustomMessagesCollectionViewCellIncoming.cellReuseIdentifier()
		
		self.collectionView.registerNib(CustomMessagesCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: self.incomingCellIdentifier)
    }

	override func awakeFromNib() {
		super.awakeFromNib()
		self.messageBubbleTopLabel.textAlignment = NSTextAlignment.left
		self.cellBottomLabel.textAlignment = NSTextAlignment.left
	}
	
	override class func nib() -> UINib {
		return UINib(nibName: "CustomMessagesCollectionViewCellIncoming", bundle: nil)
	}
	
	override class func cellReuseIdentifier() -> String {
		return "CustomMessagesCollectionViewCellIncoming"
	}*/

}*/
