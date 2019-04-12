//
//  ViewController.swift
//  Night Owl
//
//  Created by Alex Albert on 7/5/18.
//  Copyright © 2018 Alex Albert. All rights reserved.
//

import UIKit
import Firebase
import FSPagerView

class InitialViewController: UIViewController, FSPagerViewDataSource,FSPagerViewDelegate {
	
	let termsOfUseString = "Terms Last updated: July 18, 2018 Please read these Terms and Conditions ('Terms', 'Terms and Conditions') carefully before using the Night Owl mobile application (the 'Service') operated by Night Owl('us', 'we', or 'our'). Your access to and use of the Service is conditioned upon your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who wish to access or use the Service. By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you do not have permission to access the Service. Accounts: When you create an account with us, you guarantee that you are above the age of 13, and that the information you provide us is accurate, complete, and current at all times. Inaccurate, incomplete, or obsolete information may result in the immediate termination of your account on the Service. There is no tolerance for objectionable content or abusive users. You are responsible for maintaining the confidentiality of your account, including but not limited to the restriction of access to your computer and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password, whether your password is with our Service or a third-party service. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account. We reserve the right to refuse service, terminate accounts, remove or edit content in our sole discretion. Intellectual Property: The Service and its original content, features and functionality are and will remain the exclusive property of Night Owl and its licensors. The Service is protected by copyright, trademark, and other laws of both the United States and foreign countries. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Night Owl. Links To Other Websites: Our Service may contain links to third party websites or services that are not owned or controlled by Night Owl. Night Owl has no control over, and assumes no responsibility for the content, privacy policies, or practices of any third party websites or services. We do not warrant the offerings of any of these entities/individuals or their websites. You acknowledge and agree that Night Owl shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such third party websites or services. We strongly advise you to read the terms and conditions and privacy policies of any third party websites or services that you visit.Termination: We may terminate or suspend your account and bar access to the Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the Terms. If you wish to terminate your account, you may simply discontinue using the Service. All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability. Indemnification You agree to defend, indemnify and hold harmless Soothy Inc. and its licensee and licensors, and their employees, contractors, agents, officers and directors, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney's fees), resulting from or arising out of a) your use and access of the Service, by you or any person using your account and password, or b) a breach of these Terms. Limitation Of Liability: In no event shall Night Owl, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the Service; (ii) any conduct or content of any third party on the Service; (iii) any content obtained from the Service; and (iv) unauthorized access, use or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence) or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose. Disclaimer: Your use of the Service is at your sole risk. The Service is provided on an 'AS IS' and 'AS AVAILABLE' basis. The Service is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement or course of performance. Night Owl its subsidiaries, affiliates, and its licensors do not warrant that a) the Service will function uninterrupted, secure or available at any particular time or location; b) any errors or defects will be corrected; c) the Service is free of viruses or other harmful components; or d) the results of using the Service will meet your requirements. Exclusions: Some jurisdictions do not allow the exclusion of certain warranties or the exclusion or limitation of liability for consequential or incidental damages, so the limitations above may not apply to you. Governing Law: These Terms shall be governed and construed in accordance with the laws of California, United States, without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions of these Terms will remain in effect. These Terms constitute the entire agreement between us regarding our Service, and supersede and replace any prior agreements we might have had between us regarding the Service. Changes: We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will provide at least 30 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion. By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use the Service. Contact Us: If you have any questions about these Terms, please contact us."
	
	
	let imageNames = [#imageLiteral(resourceName: "Blue Owl"),#imageLiteral(resourceName: "Red Owl"),#imageLiteral(resourceName: "Green Owl"),#imageLiteral(resourceName: "Yellow Owl"),#imageLiteral(resourceName: "Purple Owl"),#imageLiteral(resourceName: "Grey Owl")]
	
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var nameField: UITextField!
	
	@IBOutlet weak var continueButton: UIButton!
	
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var tapToChooseLabel: UILabel!
	
	@IBOutlet weak var pagerView: FSPagerView!{
		didSet {
			self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
		}
	}
	
	
	var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		nameField.isHidden = true
		continueButton.isHidden = true
		continueButton.isEnabled = false
		tapToChooseLabel.isHidden = true
		infoLabel.isHidden = false
		
		pagerView.transformer = FSPagerViewTransformer(type: .overlap)
		pagerView.dataSource = self
		pagerView.delegate = self
		pagerView.isHidden = true
		pagerView.isInfinite = true
		pagerView.itemSize = CGSize(width: 80, height: 80)
		pagerView.interitemSpacing = 20
		
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(InitialViewController.getTime), userInfo: nil, repeats: true)
		
		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
		if launchedBefore  {
			print("Not first launch.")
		} else {
			print("First launch, setting UserDefault.")
			UserDefaults.standard.set(true, forKey: "launchedBefore")
			displayTerms()
		}
		
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timer?.invalidate()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func displayTerms(){
		let alertController = UIAlertController(title: "Terms of Use", message: termsOfUseString, preferredStyle: UIAlertControllerStyle.alert)
	
	let acceptAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
		
	})
	
	
	
	alertController.addAction(acceptAction)
		let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.40)
	alertController.view.addConstraint(height)
		self.present(alertController, animated: true, completion: nil)
}
	
	@IBAction func nameFieldDidChange(_ sender: Any) {
		if nameField.text != nil && nameField.text != ""{
			//continueButton.setImage(#imageLiteral(resourceName: "Selected next"), for: .normal)
			continueButton.isEnabled = true
		}else{
			continueButton.isEnabled = false
			//continueButton.setImage(#imageLiteral(resourceName: "Unselected next"), for: .normal)
		}
	}
	
	@IBAction func continueAction(_ sender: Any) {
		Variables.senderDisName = nameField.text!
		Auth.auth().signInAnonymously() { (authResult, error) in
			let user = authResult?.user
			print(1)
			if let uid = user?.uid {
				Variables.uid = uid
				print(uid
				)
				print(2)
				self.navigationController?.pushViewController(ChatViewController(), animated: true)
			}
		}
		
		
	}
	
	@objc func getTime(){
		// get the current date and time
		let currentDateTime = Date()
		// initialize the date formatter and set the style
		let formatter = DateFormatter()
		formatter.timeStyle = .medium
		formatter.dateStyle = .long
		// get the date time String from the date object
		formatter.string(from: currentDateTime)
		formatter.timeStyle = .medium
		formatter.dateStyle = .none
		//Displayable time
		let time = formatter.string(from: currentDateTime)
		timeLabel.text! = time
		
		let hour = Calendar.current.component(.hour, from: Date())
		if hour >= 21 /*21*/ || hour < 5 {
			print("Night Time")
			//present text field and login button
			nameField.isHidden = false
			continueButton.isHidden = false
			pagerView.isHidden = false
			tapToChooseLabel.isHidden = false
			infoLabel.isHidden = true
		}
	}
	
	public func numberOfItems(in pagerView: FSPagerView) -> Int {
		return imageNames.count
	}
	
	public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
		let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
		cell.imageView?.image = self.imageNames[index]
		cell.imageView?.contentMode = .scaleAspectFill
		cell.imageView?.clipsToBounds = true
		return cell
	}
	
	func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
		Variables.image = imageNames[index]
		pagerView.scrollToItem(at: index, animated: true)
	}
	
}

