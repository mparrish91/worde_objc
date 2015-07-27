//
//  TermTextFieldTableViewCell.h
//  v2
//
//  Created by Developer on 27/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TermTextFieldTableViewCell;

@protocol TermTextFieldCellDelegate <NSObject>

- (void) termTextfiedCell : (TermTextFieldTableViewCell *) cell textEditingDidEnd : (UITextField *) textField;
- (void) termTextfiedCell : (TermTextFieldTableViewCell *) cell addButtonTouched : (UIButton *) button;

@end

typedef enum{
    TermCellTypeExample,
    TermCellTypeMneuomic
} TermCellType;

@interface TermTextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (assign, nonatomic) TermCellType termCellType;

@property (strong, nonatomic) id <TermTextFieldCellDelegate> delegate;

- (IBAction)addButtonTouched:(id)sender;
@end
