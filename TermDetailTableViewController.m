//
//  WordDetailTableViewController.m
//  v2
//
//  Created by Technologies33 on 21/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "TermDetailTableViewController.h"
#import "TermListViewController.h"
#import "Term.h"
#import "SearchImages.h"
#import "LazyImageView.h"
#import "UIImageView+WebCache.h"

@implementation TextCell



@end

@interface TermDetailTableViewController ()<TermListViewControllerDelegate, SearchImagesDelegate>

@property (strong, nonatomic) NSMutableArray *detailTableDatasourceArray;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

//
@property (strong, nonatomic) IBOutlet UIScrollView *imageContainerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *imagePageControl;

@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activitiIndicator;

@property (strong, nonatomic) IBOutlet UIImageView *errorImageView;

@property (nonatomic, strong) UIWebView *webView;
@property (assign) CGFloat textCellHeight;
@end

@implementation TermDetailTableViewController
@synthesize term;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    if ([self isFavorite:term]) {
        [_favoriteButton setSelected:YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    lexiDictionary = [[Dictionary alloc] initWithTerm:term];
    [self.navigationItem setTitle:[[lexiDictionary word] uppercaseString]];

    [self setDataSourceDictionary];
    [self searchImage : term];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
    [ImageModel imInstanse].downloadedImageDictionary = nil;
    [ImageModel imInstanse].downloadingImageDictionary = nil;
}

/*-(NSArray *) getData {
    NSString *detail = @"";
    //    detail = [detail stringByAppendingString:[lexiDictionary getDefinition]];
    //    detail = [detail stringByAppendingString:@"\n\nParts of speech :\n\n"];
    NSArray *partsOfSpeech = [lexiDictionary getPartsOfSpeech];
    NSArray *arr;
    for (NSString *partOfSpeech in partsOfSpeech) {
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",partOfSpeech]];
        
        detail = [detail stringByAppendingString:@"\nDefinitions:\n\n"];
        arr = [lexiDictionary getDefinitionsForPartOfSpeech:partOfSpeech];
        for (NSString *def in arr) {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@\n",def]];
        }
        
        detail = [detail stringByAppendingString:@"\nExample Sentences:\n"];
        arr = [lexiDictionary getExampleSentenceForPartOfSpeech:partOfSpeech];
        for (NSString *ex in arr) {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@, ",ex]];
        }
        
        detail = [detail stringByAppendingString:@"\nSynonyms:\n\n"];
        arr = [lexiDictionary getSynonymsForPartOfSpeech:partOfSpeech];
        for (NSString *syn in arr) {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@, ",syn]];
        }
    }
    
    NSInteger strLength = [detail length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:24];
    //    [attString addAttribute:NSParagraphStyleAttributeName
    //                      value:style
    //                      range:NSMakeRange(0, strLength)];
    
    return [NSArray arrayWithObject:detail];
}*/
-(NSArray *) getData {
    NSString *detail = @"<html><body id=\"foo\">";
    NSArray *partsOfSpeech = [lexiDictionary getPartsOfSpeech];
    
    
    NSArray *arr;
    for (NSString *partOfSpeech in partsOfSpeech) {
        arr = [lexiDictionary getDefinitionsForPartOfSpeech:partOfSpeech];
        NSString *definitions = @"";
        for (NSString *def in arr) {
            definitions = [definitions stringByAppendingString:[NSString stringWithFormat:@"%@",def]];
        }
//        definitions = ([arr count]) ? [NSString stringWithFormat:@"\
//                                    <div style=\"font-family:Helvetica; font-style:italic;\">%@</div><br>\
//                                    <div>%@</div>",@"Definitions:", definitions] : @"";
        
        arr = [lexiDictionary getExampleSentenceForPartOfSpeech:partOfSpeech];
        NSString *examples = @"";
        for (NSString *ex in arr) {
            examples = [examples stringByAppendingString:[NSString stringWithFormat:@"%@",ex]];
        }
//        examples = ([arr count]) ? [NSString stringWithFormat:@"\
//                                    <div style=\"font-family:Helvetica; font-style:italic;\">%@</div><br>\
//                                    <div>%@</div>",@"Example Sentences:", examples] : @"";
        
        arr = [lexiDictionary getSynonymsForPartOfSpeech:partOfSpeech];
        NSString *synonyms = @"";
        for (NSString *syn in arr)
            synonyms = [synonyms stringByAppendingString:[NSString stringWithFormat:@"%@, ",syn]];
        
        synonyms = [synonyms stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
        
//        synonyms = ([arr count]) ? [NSString stringWithFormat:@"\
//                                    <div style=\"font-family:Helvetica; font-style:italic;\">%@</div><br>\
//                                    <div>%@</div>",@"Synonyms:", synonyms] : @"";

        
//        NSString *string = [NSString stringWithFormat:@"<br>\
//                  <div style=\"font-family:Helvetica-bold\">%@</div> <br>\
//                         <div class=\"definition-wrap\"><div style=\"display:block; float:left; width:75%%;\">   %@ <br> %@ <br> %@</div></div>",partOfSpeech, definitions, examples, synonyms];
        NSError *error = nil;
        NSString *detailHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detaildefinition" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
        
        detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[PartOfSpeech]]]" withString:partOfSpeech];
        if ([definitions length]) {
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[DefinitionTitle]]]" withString:@"Definition:"];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Definition]]]" withString:definitions];
        }else{
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:10px;color:black;\"><i>[[[DefinitionTitle]]]</i></span><br><br>" withString:@""];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:12px;color:black;\">[[[Definition]]]</span><br><br>" withString:@""];
        }
        
        if ([examples length]) {
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[ExampleTitle]]]" withString:@"Examples:"];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Example]]]" withString:examples];
        }else{
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:10px;color:black;\"><i>[[[ExampleTitle]]]</i></span><br><br>" withString:@""];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:12px;color:black;\">[[[Example]]]</span><br><br>" withString:@""];
        }
        
        if ([synonyms length]) {
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[SynonymTitle]]]" withString:@"Synonyms:"];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Synonym]]]" withString:synonyms];
        }else{
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:10px;color:black;\"><i>[[[SynonymTitle]]]</i></span><br><br>" withString:@""];
            detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"<span style=\"font-size:12px;color:black;\">[[[Synonym]]]</span><br><br>" withString:@""];
        }

        detail = [detail stringByAppendingString:detailHtml];
    }
    detail = [detail stringByAppendingString:@"</body></html>"];
    NSLog(@"detail = %@",detail);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:24];

//    NSInteger strLength = [detail length];
//    [attString addAttribute:NSParagraphStyleAttributeName
//                      value:style
//                      range:NSMakeRange(0, strLength)];
    
    return [NSArray arrayWithObject:detail];
}


- (IBAction)exampleEdittingEnded:(id)sender {
    
}

- (IBAction)mneuomicEdittingEnded:(id)sender {
    
}

#pragma mark - Tableview Datasource & Delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return  [_detailTableDatasourceArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_detailTableDatasourceArray[section] count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionDetailArray =_detailTableDatasourceArray[indexPath.section];
    switch (indexPath.section) {
        case 0:{
            TextCell *cell = (TextCell*)[tableView dequeueReusableCellWithIdentifier:@"termDetailCellIdentifier"];
            [cell.textContentWebView loadHTMLString:sectionDetailArray[indexPath.row] baseURL:nil];
//            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[sectionDetailArray[indexPath.row] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            cell.textLabel.attributedText = attributedString;
            return cell;
        }
            break;
        case 1:{
            TermTextFieldTableViewCell *cell = (TermTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"termtextFieldCellIdentifier"];
            [cell setTermCellType:TermCellTypeExample];
            cell.textField.text = sectionDetailArray[indexPath.row];
            cell.addButton.hidden = ([sectionDetailArray[indexPath.row] length]) ? YES : NO;
            [cell setDelegate:self];
            return cell;
        }
            break;
        case 2:{
            TermTextFieldTableViewCell *cell = (TermTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"termtextFieldCellIdentifier"];
            cell.textField.text = sectionDetailArray[indexPath.row];
            [cell setTermCellType:TermCellTypeMneuomic];
            [cell setDelegate:self];
            cell.addButton.hidden = ([sectionDetailArray[indexPath.row] length]) ? YES : NO;
            return cell;
        }
            break;
    
        default:{
//            TermTextFieldTableViewCell *cell = (TermTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"termtextFieldCellIdentifier"];
//            [cell setTermCellType:TermCellTypeExample];
//            [cell setDelegate:self];
//            cell.textLabel.text = sectionDetailArray[indexPath.row];
//            return cell;
        }
            break;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return [self getHeightForText:_detailTableDatasourceArray[indexPath.section][indexPath.row]];//_textCellHeight;
        }
            break;
        default:{
            return 44.0f;
        }
            break;
    }
    return 44.0f;
}

#pragma mark - Support
- (CGFloat) getHeightForText : (NSString *) text{
//    NSAttributedString *attrStr = ... // your attributed string
//    CGFloat width = 300; // whatever your desired width is
//    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * (60.0f / 100.0f), 0)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    label.attributedText = attributedString;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    height += 20.0f;
    return height;
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30.0f, 0)];
//    webView.delegate = self;
//    [webView loadHTMLString:text baseURL:nil];
//    return [webView.scrollView contentSize].width;
    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(290.0f, 999999.0f)];
//    size.height += 30.0f;
//    NSLog(@"Height : %f   Width : %f ",size.height,size.width);
//    return size.height;
    return 0.0f;
}

- (void) setDataSourceDictionary{
    if (_detailTableDatasourceArray == nil)
        _detailTableDatasourceArray = [NSMutableArray array];
    
    [_detailTableDatasourceArray addObject:[self getData]];
    [_detailTableDatasourceArray addObject:[self getExamplesForTerm:term]];
    [_detailTableDatasourceArray addObject:[self getMnuoemicForTerm:term]];
    
//    _webView = nil;
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 30.0f, 0)];
//    webView.delegate = self;
//    [webView loadHTMLString:_detailTableDatasourceArray[0][0] baseURL:nil];
//    _webView = webView;
//    webView = nil;
}

-  (NSArray *) getExamplesForTerm : (NSString *) term_{
    if (term_ == nil)
        return [NSArray arrayWithObject:@""];

    //get mneuomic value from data source
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Example" predicate:[NSString stringWithFormat:@"term = \"%@\"", term_]];
    NSError *error = nil;
    NSArray *exampleArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    NSMutableArray *exampleTermArray = [NSMutableArray array];
    
    for (Example *example in exampleArray) {
        [exampleTermArray addObject:example.example];
    }

    
    //add last blank cell
    [exampleTermArray addObject:@""];
    
    return [NSArray arrayWithArray:exampleTermArray];
}

-  (NSArray *) getMnuoemicForTerm : (NSString *) term_{
    if (term_ == nil)
        return [NSArray arrayWithObject:@""];
    
    //get mneuomic value from data source
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Mneuomic" predicate:[NSString stringWithFormat:@"term = \"%@\"", term_]];
    NSError *error = nil;
    NSArray *mneuomicArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    NSMutableArray *mnuoemicTermArray =  [NSMutableArray array];
    
    for (Mneuomic *mnemonic in mneuomicArray) {
        [mnuoemicTermArray addObject:mnemonic.mneuomic];
    }
    
    //add last blank cell
    [mnuoemicTermArray addObject:@""];
    
    return [NSArray arrayWithArray:mnuoemicTermArray];
}

//- (Term *) getTerm{
//    if (term == nil) {
//        //create new term
//        
//    }
//    return term;
//}

- (BOOL) isText : (NSString *) text matchedWith : (NSArray *) texts{
    for (NSString *txt in texts) {
        if ([txt isEqualToString:text]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - TermTextFieldCellDelegate
- (void) termTextfiedCell : (TermTextFieldTableViewCell *) cell textEditingDidEnd : (UITextField *) textField{
    if (![textField.text length])
        return;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *sectionDetailArray =[_detailTableDatasourceArray[indexPath.section] mutableCopy];

    switch (cell.termCellType) {
        case TermCellTypeExample:
            if ([self isText:textField.text matchedWith:sectionDetailArray]){
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Same exaple already exits.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
                return;
            }

            [CoreDataSupport saveExample:textField.text forTerm:term];
            break;

        case TermCellTypeMneuomic:
            if ([self isText:textField.text matchedWith:sectionDetailArray]){
                [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Same mneuomic already exits.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
                return;
            }

            [CoreDataSupport saveMneuomic:textField.text forTerm:term];
            break;
            
        default:
            break;
    }
    

    //update
    [sectionDetailArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    [_detailTableDatasourceArray replaceObjectAtIndex:indexPath.section
                                          withObject:[NSArray arrayWithArray:sectionDetailArray]];
    
}

- (void) termTextfiedCell : (TermTextFieldTableViewCell *) cell addButtonTouched : (UIButton *) button{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *sectionDetailArray =[_detailTableDatasourceArray[indexPath.section] mutableCopy];
    [sectionDetailArray addObject:@""];
    [button removeFromSuperview];
    
    //update
    [_detailTableDatasourceArray replaceObjectAtIndex:indexPath.section
                                           withObject:[NSArray arrayWithArray:sectionDetailArray]];
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailToTermList"]) {
        TermListViewController *termListViewController = segue.destinationViewController;
        termListViewController.delegate = self;
        termListViewController.isAddingTerm = TRUE;
    }
}

#pragma mark - Favorite

- (IBAction)addToFavoriteButtonTouched:(id)sender {
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
    //    imageView.frame = CGRectZero;
    
    //    CGRect frame = _favoriteButton.frame;
    //    CGPoint center = _favoriteButton.center;
    
    UIButton *button = (UIButton *) sender;
    //    NSString *buttonTitle = [button titleForState:UIControlStateNormal];
    //    if ([buttonTitle isEqualToString:NSLocalizedString(@"Favorite", nil)]) {
    //
    //    }else{
    //        [_favoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    //        [_favoriteButton.imageView startAnimating];
    //        [self performSelector:@selector(moveToTermList) withObject:nil afterDelay:1.0f];
    //    }
    
    if (![button isSelected]) {
        [self performSelector:@selector(moveToTermList) withObject:nil afterDelay:0.09f];
        [button setSelected:YES];
    }else{
        //        [_favoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        //        [_favoriteButton.imageView startAnimating];
    }
}

- (void) moveToTermList{
    //    [_favoriteButton setImage:nil forState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"DetailToTermList" sender:nil];
}


- (BOOL) isFavorite : (NSString *) word{
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Term" predicate:[NSString stringWithFormat:@"word = \"%@\"", word]];
    NSError *error = nil;
    NSArray *termArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    NSLog(@"termArray = %@", termArray);
    return [termArray count];
}

- (void)termListViewControllerDidCancel:(TermListViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)termListViewController:(TermListViewController *)controller didAddToTermList:(TermsList *)list
{
    //NSLog(@"%@",list.name);
    [controller.navigationController popViewControllerAnimated:YES];
    
    NSManagedObjectContext *context = [[AppDelegate instance] managedObjectContext];
    Term *termO= [NSEntityDescription
                 insertNewObjectForEntityForName:@"Term"
                 inManagedObjectContext:context];
    termO.word = term;
    termO.list = list;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

#pragma mark - Search Image
- (void) searchImage : (NSString *) word{
    if ([self isBadWord:word]) {
        [_errorImageView setHidden:NO];
        [_activitiIndicator startAnimating];
        return;
    }
    
    SearchImages *obj = [[SearchImages alloc] initWithDelegate:self];
    [obj searchImageForWord:word];
    [_activitiIndicator startAnimating];
}

- (BOOL) isBadWord : (NSString *) word{
    for (NSString *badWord in APP_DELEGATE.badWordArray) {
        if ([word isEqualToString:badWord]) {
            return YES;
        }
    }
    return NO;
}

//SearchImagesDelegate
- (void) searchResult : (id) result error : (NSError *)error{
    [_activitiIndicator stopAnimating];
    
    NSLog(@"result = %@", result);
    if (error == nil && result[@"error"] == nil && result != nil) {
//        _imageDetailDictionary = (NSDictionary *) result;
//        [self loadWordDetail];//call again after image is available
        // Set up the image we want to scroll & zoom and add it to the scroll view
//        self.pageImages = [NSArray arrayWithObjects:
//                           [UIImage imageNamed:@"photo1.png"],
//                           [UIImage imageNamed:@"photo2.png"],
//                           [UIImage imageNamed:@"photo3.png"],
//                           [UIImage imageNamed:@"photo4.png"],
//                           [UIImage imageNamed:@"photo5.png"],
//                           nil];
        self.pageImages = result[@"items"];
        
        NSInteger pageCount = self.pageImages.count;
        
        // Set up the page control
        self.imagePageControl.currentPage = 0;
        self.imagePageControl.numberOfPages = pageCount;
        
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
        
        // Set up the content size of the scroll view
        CGSize pagesScrollViewSize = self.imageContainerScrollView.frame.size;
        self.imageContainerScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
        
        // Load the initial set of pages that are on screen
        [self loadVisiblePages];
    }
}

- (void) imageDownloaded : (id) image error : (NSError *)error{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1) {
        // Load the pages which are now on screen
        [self loadVisiblePages];
    }
}


#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.imageContainerScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.imageContainerScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.imagePageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.imageContainerScrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] initWithFrame:frame];
        [newPageView sd_setImageWithURL:[NSURL URLWithString:self.pageImages[page][@"link"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [newPageView setContentMode:UIViewContentModeScaleAspectFill];
        [newPageView.layer setMasksToBounds:YES];
        newPageView.frame = frame;
        [self.imageContainerScrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (NSArray *) getGoogleImageUrlArray : (NSDictionary *) dictionary{
    return dictionary[@"items"];
}

#pragma mark - WebView Delegate
- (void) webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *output = [_webView stringByEvaluatingJavaScriptFromString:@"document.height"];
    NSLog(@"height: %@, wvHeight = %f", output, _webView.scrollView.contentSize.height);
    _textCellHeight = [output floatValue];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error - %@", error.localizedDescription);
}



@end