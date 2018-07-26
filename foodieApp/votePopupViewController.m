//
//  votePopupViewController.m
//  foodieApp
//
//  Created by Bharat shankar on 22/05/18.
//  Copyright © 2018 Bhargav. All rights reserved.
//

#import "votePopupViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "ServiceManager.h"
#import "ServiceInitiater.h"
#import "UIImageView+WebCache.h"
#import "SingleTon.h"
#import "UIViewController+ENPopUp.h"
#import "voteCollectionCell.h"


@interface votePopupViewController ()
{
    SingleTon * singleTonInstance;

    NSMutableDictionary * requestDict1;
    NSMutableArray * voteOptionsArray,* pathStoreArray;
    BOOL * isButton1,* isButton2,* isButton3,* isButton4;
}
@end

@implementation votePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleTonInstance=[SingleTon singleTonMethod];
    
    voteOptionsArray = [[NSMutableArray alloc]init];

    self.voteButton.hidden = YES;
    isButton1 = YES;
    isButton2 = YES;
    isButton3 = YES;
    isButton4 = YES;
    
    [ Utilities addShadowtoView: self.view1 ];
    [ Utilities addShadowtoView: self.view2 ];
    [ Utilities addShadowtoView: self.view3 ];
    [ Utilities addShadowtoView: self.view4 ];
    
    pathStoreArray = [[NSMutableArray alloc]init];
    
    NSLog(@"votes array to this screen is %@",singleTonInstance.votesArray);
    
    if (![singleTonInstance.voteOption1 isEqualToString:@""]) {
        self.view1.hidden = NO;
        self.voteLab1.text = [Utilities null_ValidationString:singleTonInstance.voteOption1];
    }
    else
    {
        self.view1.hidden = YES;
    }
    
    if (![singleTonInstance.voteOption2 isEqualToString:@""]) {
        self.view2.hidden = NO;
        self.voteLab2.text = [Utilities null_ValidationString:singleTonInstance.voteOption2];
    }
    else
    {
        self.view2.hidden = YES;
    }
    
    if (![singleTonInstance.voteOption3 isEqualToString:@""]){
        self.view3.hidden = NO;
        self.voteLab3.text = [Utilities null_ValidationString:singleTonInstance.voteOption3];
    }
    else
    {
        self.view3.hidden = YES;
    }
    
    if (![singleTonInstance.voteOption4 isEqualToString:@""]) {
        self.view4.hidden = NO;
        self.voteLab4.text = [Utilities null_ValidationString:singleTonInstance.voteOption4];
    }
    else
    {
        self.view4.hidden = YES;
        
    }
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1option:(id)sender {

    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        self.voteButton.hidden = NO;

        [sender setSelected:YES];
    }
}
- (IBAction)button2option:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        self.voteButton.hidden = NO;

        [sender setSelected:YES];
    }
}
- (IBAction)button3option:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        self.voteButton.hidden = NO;

        [sender setSelected:YES];
    }
}
- (IBAction)button4option:(id)sender {
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        self.voteButton.hidden = NO;

        [sender setSelected:YES];
    }
}

- (IBAction)voteButtonAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self dismissPopUpViewController];
        
    });
}

#pragma mark - collectionview delegates


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return singleTonInstance.votesArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    voteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"voteCollectionCell" forIndexPath:indexPath];
    
    cell.questionLabel.text = [Utilities null_ValidationString:[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"question"] ];
    
    cell.optionLbl1.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option1"] objectForKey:@"option_name"] ];
    
    cell.optionLbl2.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option2"] objectForKey:@"option_name"] ];
    
    cell.optionLbl3.text = [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option3"] objectForKey:@"option_name"] ];
    
    cell.optionLbl4.text =  [Utilities null_ValidationString:[[[singleTonInstance.votesArray objectAtIndex:indexPath.row] objectForKey:@"option4"] objectForKey:@"option_name"] ];
    
    cell.optionButton1.tag = indexPath.row;
    cell.optionButton2.tag = indexPath.row;
    cell.optionButton3.tag = indexPath.row;
    cell.optionButton4.tag = indexPath.row;
    cell.voteButon.tag = indexPath.row;

    [cell.optionButton1 addTarget:self action:@selector(option1_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton2 addTarget:self action:@selector(option2_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton3 addTarget:self action:@selector(option3_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton4 addTarget:self action:@selector(option4_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.voteButon addTarget:self action:@selector(cellVoteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (pathStoreArray.count) {
        
    }

    
    return cell;

}


-(void)option1_Clicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [voteOptionsArray removeObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option1"] ];
        [pathStoreArray removeObject:[NSString stringWithFormat:@"%d",btn.tag]];
    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [voteOptionsArray addObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option1"] ];
        [pathStoreArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];
    }

    

}

-(void)option2_Clicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [voteOptionsArray removeObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option2"] ];
        [pathStoreArray removeObject:[NSString stringWithFormat:@"%d",btn.tag]];

    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [voteOptionsArray addObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option2"] ];
        [pathStoreArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];

    }
}

-(void)option3_Clicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [voteOptionsArray removeObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option3"] ];
        [pathStoreArray removeObject:[NSString stringWithFormat:@"%d",btn.tag]];

    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [voteOptionsArray addObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option3"] ];
        [pathStoreArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];

    }
}

-(void)option4_Clicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"mark.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [voteOptionsArray removeObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option4"] ];
        [pathStoreArray removeObject:[NSString stringWithFormat:@"%d",btn.tag]];

    } else {
        [sender setImage:[UIImage imageNamed:@"mark_active.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        [voteOptionsArray addObject:[[singleTonInstance.votesArray objectAtIndex:btn.tag]objectForKey:@"option4"] ];
        [pathStoreArray addObject:[NSString stringWithFormat:@"%d",btn.tag]];

    }
}

-(void)cellVoteAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"selected vote options are %@",voteOptionsArray);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if (voteOptionsArray.count) {
        UIButton *btn;
        [voteOptionsArray removeAllObjects];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
