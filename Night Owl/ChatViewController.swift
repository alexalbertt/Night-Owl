//
//  ChatViewController.swift
//  Night Owl
//
//  Created by Alex Albert on 7/5/18.
//  Copyright © 2018 Alex Albert. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {

	let ref = Database.database().reference()
	
	var messages = [JSQMessage]()
	
	lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
	lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
	
	var timer: Timer?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		senderId = Variables.uid
		senderDisplayName = Variables.senderDisName
		observeMessages()
		
		collectionView.backgroundColor = UIColor.black
		self.inputToolbar.contentView.textView.keyboardAppearance = UIKeyboardAppearance.dark
		self.inputToolbar.contentView.leftBarButtonItem = nil
		self.inputToolbar.contentView.textView.backgroundColor = UIColor.lightGray
		
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ChatViewController.checkTime), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
	}
	
	private func setupIncomingBubble() -> JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
	}
	
	@objc func checkTime(){
		let hour = Calendar.current.component(.hour, from: Date())
		if hour < 21 /*21*/ && hour >= 5 {
			self.navigationController?.popToRootViewController(animated: false)
		}
	}
	
	private func observeMessages() {
		let messageRef = ref.child("MainChatRoom").child("Messages")
		
		let messageQuery = messageRef.queryLimited(toLast:25)
		
		let newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) in
			
			let messageData = snapshot.value as! Dictionary<String, AnyObject>
			
			
			if  let data        = snapshot.value as? [String: AnyObject],
				let id          = data["sender_id"] as? String,
				let name        = data["name"] as? String,
				let text        = data["text"] as? String,
				let time        = data["time"] as? TimeInterval,
				!text.isEmpty
			{
				if let message = JSQMessage(senderId: id, senderDisplayName: name, date: Date(timeIntervalSince1970: time), text: text)
				{
					self.messages.append(message)
					
					self.finishReceivingMessage()
				}
				
			}else {
				print("Error! Could not decode message data")
			}
		})
		
	}
	
	func reportUser(userId: String){
		let actionSheetController = UIAlertController(title: "Are you sure you want to report this user?", message: "We review reports within minutes of them being submitted. If a user has acted inappropriately they will be banned.", preferredStyle: .actionSheet)
		
		let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
			print("Cancel")
			
		}
		actionSheetController.addAction(cancelActionButton)
		
		let otherActionButton = UIAlertAction(title: "Yes", style: .default) { action -> Void in
			
			self.ref.child("reports").child(userId).setValue(true)
			let filteredMessages = self.messages.filter { !$0.senderId.contains(userId) }
			self.messages = filteredMessages
			self.collectionView.reloadData()
			self.reportUserAlert()
		}
		actionSheetController.addAction(otherActionButton)
		self.present(actionSheetController, animated: true, completion: nil)
	}
	
	func reportUserAlert(){
		let alert = UIAlertController(title: "User reported👍", message: "Thank you for reporting users in order to keep Night Owl a safe place to hang out and meet new people. Our team will review the person in question.", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Cool", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
		if let reportedUser = messages[indexPath.item].senderId{
			reportUser(userId: reportedUser)
		}
			
	}
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
		return messages[indexPath.item]
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
	
		let message = messages[indexPath.item]
		if message.senderId == senderId {
			cell.textView!.textColor = UIColor.black
			cell.messageBubbleContainerView.backgroundColor! = UIColor.white
		}else {
			cell.textView!.textColor = UIColor.black
			cell.messageBubbleContainerView.backgroundColor! = UIColor.white
		}
		cell.messageBubbleContainerView.layer.cornerRadius = 15
		cell.messageBubbleContainerView.layer.masksToBounds = true
		
		return cell
	}
	
	override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
		let messageRef = ref.child("MainChatRoom").child("Messages").childByAutoId()
		let currentTime = Date()
		let currentTimePassed = currentTime.timeIntervalSince1970
		let timeInt = Int(currentTimePassed)
		
		let message = ["sender_id": senderId, "name": senderDisplayName, "text": text, "time" : timeInt] as [String : Any]
		
		messageRef.setValue(message)
		finishSendingMessage()
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
		/*let message = messages[indexPath.item]
		if message.senderId == senderId {
			return outgoingBubbleImageView
		}else {
			return incomingBubbleImageView
		}*/
		return nil
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
		let message = messages[indexPath.item]
		var image = #imageLiteral(resourceName: "Grey Owl")
		if message.senderId == senderId{
			image = Variables.image
		}else{
			if message.senderId.caseInsensitiveHasPrefix("a") || message.senderId.caseInsensitiveHasPrefix("g") || message.senderId.caseInsensitiveHasPrefix("m") || message.senderId.caseInsensitiveHasPrefix("s") || message.senderId.caseInsensitiveHasPrefix("y"){
				image = #imageLiteral(resourceName: "Grey Owl")
			}else if message.senderId.caseInsensitiveHasPrefix("b") || message.senderId.caseInsensitiveHasPrefix("h") || message.senderId.caseInsensitiveHasPrefix("n") || message.senderId.caseInsensitiveHasPrefix("t") || message.senderId.caseInsensitiveHasPrefix("z"){
				image = #imageLiteral(resourceName: "Purple Owl")
			}else if message.senderId.caseInsensitiveHasPrefix("c") || message.senderId.caseInsensitiveHasPrefix("i") || message.senderId.caseInsensitiveHasPrefix("o") || message.senderId.caseInsensitiveHasPrefix("u"){
				image = #imageLiteral(resourceName: "Yellow Owl")
			}else if message.senderId.caseInsensitiveHasPrefix("d") || message.senderId.caseInsensitiveHasPrefix("j") || message.senderId.caseInsensitiveHasPrefix("p") || message.senderId.caseInsensitiveHasPrefix("v"){
				image = #imageLiteral(resourceName: "Green Owl")
			}else if message.senderId.caseInsensitiveHasPrefix("e") || message.senderId.caseInsensitiveHasPrefix("k") || message.senderId.caseInsensitiveHasPrefix("q") || message.senderId.caseInsensitiveHasPrefix("w"){
				image = #imageLiteral(resourceName: "Red Owl")
			}else if message.senderId.caseInsensitiveHasPrefix("f") || message.senderId.caseInsensitiveHasPrefix("l") || message.senderId.caseInsensitiveHasPrefix("r") || message.senderId.caseInsensitiveHasPrefix("x"){
				image = #imageLiteral(resourceName: "Blue Owl")
			}else{
				return nil
			}
		}
		let avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
		return avatarImage
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a MM-dd"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.amSymbol = "AM"
		dateFormatter.pmSymbol = "PM"
		let message = messages[indexPath.item]
		let dateString = dateFormatter.string(from:message.date as Date)
		
		return NSAttributedString.init(string: message.senderDisplayName + " @ " + dateString)
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
		return 20.0
	}
}
extension String {
	func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
		return lowercased().starts(with: prefix.lowercased())
	}
}


