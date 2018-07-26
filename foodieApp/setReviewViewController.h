//
//  setReviewViewController.h
//  buzzedApp
//
//  Created by ashwin challa on 8/17/17.
//  Copyright © 2017 adroitent.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setReviewViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)publishReviewAction:(id)sender;

@property NSString * merchantIdStr;
@property (strong, nonatomic) IBOutlet UIImageView *reviewImg;

@end
