//
//  TermTextFieldTableViewCell.m
//  v2
//
//  Created by Developer on 27/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//
#import "TermTextFieldTableViewCell.h"
@implementation TermTextFieldTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
    
    //disable add button initially
    [_addButton setEnabled:NO];
    [_textField setDelegate:self];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
} 
//setter for TermCellType
- (void) setTermCellType:(TermCellType)termCellType{
    _termCellType = termCellType;
    
    switch (termCellType) {
        case TermCellTypeExample:
            _textField.placeholder = NSLocalizedString(@"My example sentence", nil);
            break;
        case TermCellTypeMneuomic:
            _textField.placeholder = NSLocalizedString(@"My mneuomic phrases", nil);
            break;
            
        default:
            break;
    }
}
- (IBAction)addButtonTouched:(id)sender {
    [_delegate termTextfiedCell:self addButtonTouched:(UIButton *) sender];
}
#pragma mark -
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_delegate termTextfiedCell:self textEditingDidEnd:textField];
    
    //disable add button if textfield is blank
    if (![textField.text length]) [_addButton setEnabled:NO];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string length] || ([textField.text length] > 1 && ([string length] == 0))) {
        [_addButton setEnabled:YES];
    }else{
        //disable add button initially or when editing end
        [_addButton setEnabled:NO];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end