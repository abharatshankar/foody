//
//  EventReadyPageController.h
//  foodieApp
//
//  Created by ashwin challa on 2/13/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "LcnManager.h"
#import <MapKit/MapKit.h>
#import "VCFloatingActionButton.h"


@interface EventReadyPageController : UIViewController<floatMenuDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mapView;

@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollection;

@property (weak, nonatomic) IBOutlet UIView *friendsView;

@property (weak, nonatomic) IBOutlet UIButton *trailBtn;

@property (weak, nonatomic) IBOutlet UILabel *locationNameLbl;

@property (strong, nonatomic) IBOutlet UIView *mapShowView;

@property (strong, nonatomic) IBOutlet UICollectionView *membersCollection;
@property (strong, nonatomic) IBOutlet UIButton *eventButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;
@property (strong, nonatomic) IBOutlet UILabel *eventHighlightLbl;
@property (weak, nonatomic) IBOutlet UILabel *chatHighlightLbl;
@property (strong, nonatomic) IBOutlet UILabel *detailsHighlightLbl;
@property (strong, nonatomic) IBOutlet UICollectionView *GroupCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *iAmReadyButton;
@property (weak, nonatomic) IBOutlet UIButton *meunVote;


// detail view Components
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScroll;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;

@property (strong, nonatomic) IBOutlet UILabel *startMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *startDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLbl;

@property (strong, nonatomic) IBOutlet UILabel *endMonthLbl;
@property (strong, nonatomic) IBOutlet UILabel *endDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLbl;

@property (strong, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) IBOutlet UILabel *eventArea;
@property (strong, nonatomic) IBOutlet MKMapView *eventMap;
@property (strong, nonatomic) IBOutlet UIView *smallView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UIImageView *mapImage;

@property  NSString *  isFromMyEventsPage;

@property BOOL * isMarkerActive;

@property NSString * eventIdStr,
                   * startTimeFromBookings,
                   * endTimeFromBookings;


@property (weak, nonatomic) IBOutlet UITableView *chatTableView ;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITextField *chatTextfield;


@property NSMutableDictionary * presentEventsDict;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (strong, nonatomic) IBOutlet UILabel *goingCountLbl;
@property (strong, nonatomic) IBOutlet UILabel *interestedCountLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLbl;

@property (strong, nonatomic) IBOutlet UIButton *goingBtn;
@property (strong, nonatomic) IBOutlet UIButton *interestedBtn;
@property (strong, nonatomic) IBOutlet UIButton *cantGoBtn;
@property (weak, nonatomic) IBOutlet UIButton *equiDistanceButton;




// for vote functionality

@property (weak, nonatomic) IBOutlet UIView *voteView;

@property (weak, nonatomic) IBOutlet UIView *createVoteView;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelCreateVote;
@property (weak, nonatomic) IBOutlet UITextField *voteQuestionText;

@property (weak, nonatomic) IBOutlet UILabel *voteHighlightLbl;

@property (weak, nonatomic) IBOutlet UIView *startVoteView;

@property (weak, nonatomic) IBOutlet UIButton *cancelStartVote;


@property (weak, nonatomic) IBOutlet UITextField *questionText;
@property (weak, nonatomic) IBOutlet UITextField *option1Text;
@property (weak, nonatomic) IBOutlet UITextField *option2Text;
@property (weak, nonatomic) IBOutlet UITextField *option3Text;
@property (weak, nonatomic) IBOutlet UITextField *option4Text;

@property (weak, nonatomic) IBOutlet UIImageView *thumbsUpImg;



@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@property (weak, nonatomic) IBOutlet UITableView *voteTableView;






























@end
