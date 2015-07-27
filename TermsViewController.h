//
//  TermsViewController.h
//  v2
//
//  Created by Technologies33 on 20/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsList.h"
#import "Term.h"
#import "AppDelegate.h"

@interface TermsViewController : UITableViewController

@property(nonatomic,strong) TermsList *list;
@property(nonatomic,strong) NSMutableArray *terms;

@end
