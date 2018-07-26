//
//  descriptionViewController.h
//  foodieApp
//
//  Created by ashwin challa on 2/16/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface descriptionViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textViw;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
