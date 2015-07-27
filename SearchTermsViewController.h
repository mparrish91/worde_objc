//
//  SearchTermsViewController.h
//  v2
//
//  Created by Technologies33 on 20/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Term.h"
#import "AppDelegate.h"
#import "Lexicontext.h"

@interface SearchTermsViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dictResults;
@property (nonatomic, strong) NSMutableArray *wordListResults;
@property (nonatomic, strong) IBOutlet UITableView *tblSearchResults;
@property (nonatomic, strong) IBOutlet UISearchBar *termSearchBar;
@end
