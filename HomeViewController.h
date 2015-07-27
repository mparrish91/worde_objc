//
//  HomeViewController.h
//  v2
//
//  Created by Jack on 7/24/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Term.h"
#import "Dictionary.h"
#import "TermListViewController.h"
#import "AppDelegate.h"
#import "SearchImages.h"

@interface HomeViewController : UIViewController <TermListViewControllerDelegate, SearchImagesDelegate>

@property (nonatomic, strong)  Dictionary *dict;

@property(nonatomic,strong) IBOutlet UIImageView *imgView;
@property(nonatomic,strong) IBOutlet UILabel *lblWord;
@property(nonatomic,strong) IBOutlet UITextView *descText;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIWebView *definitionContentWebView;

-(IBAction)nextWord:(id)sender;

@end
