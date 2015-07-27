//
//  WordDetailTableViewController.h
//  v2
//
//  Created by Technologies33 on 21/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Dictionary.h"
#import "CoreDataSupport.h"
#import "TermTextFieldTableViewCell.h"

@interface TextCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIWebView *textContentWebView;
@end


//termtextFieldCellIdentifier
@interface TermDetailTableViewController : UITableViewController<UIScrollViewDelegate,UITextViewDelegate, TermTextFieldCellDelegate, UIWebViewDelegate> {
    Dictionary *lexiDictionary;
}

@property (nonatomic, strong) NSString *term;

@end
