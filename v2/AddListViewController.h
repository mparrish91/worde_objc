//
//  AddListViewController.h
//  v2
//
//  Created by malcolm on 7/12/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsList.h"

@class AddListViewController;

@protocol AddListViewControllerDelegate <NSObject>
- (void)addListViewControllerDidCancel:(AddListViewController *)controller;
- (void)addListViewController:(AddListViewController *)controller didAddTermListWithName:(NSString *)name;

@end


@interface AddListViewController : UITableViewController

@property (nonatomic, weak) id <AddListViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
