//
//  TermListViewController.h
//  v2
//
//  Created by malcolm on 7/12/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddListViewController.h"

@class TermListViewController;

@protocol TermListViewControllerDelegate <NSObject>
- (void)termListViewControllerDidCancel:(TermListViewController *)controller;
- (void)termListViewController:(TermListViewController *)controller didAddToTermList:(TermsList *)list;

@end

@interface TermListViewController : UITableViewController <AddListViewControllerDelegate>

@property (nonatomic, weak) id <TermListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *termlists;
@property (assign) BOOL isAddingTerm;

@property (nonatomic,strong) IBOutlet UIBarButtonItem *leftBarButton;

@end
