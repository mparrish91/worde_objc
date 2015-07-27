//
//  HomeViewController.m
//  v2
//
//  Created by Jack on 7/24/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "HomeViewController.h"
#import "Lexicontext.h"
#import "CoreDataSupport.h"


@interface HomeViewController ()
@property (nonatomic, strong) NSDictionary *imageDetailDictionary;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
	rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
	leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer];
    
//    _favoriteButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    _favoriteButton.layer.borderWidth = 1.0f;
//    _favoriteButton.layer.cornerRadius = 4.0f;
//    [_favoriteButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i<15; i++) {
//        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png", i]]];
//    }
//    _favoriteButton.imageView.animationImages = array;
//    [_favoriteButton.imageView setContentMode:UIViewContentModeCenter];
//    _favoriteButton.imageView.animationDuration = 1.0f;
//    _favoriteButton.imageView.animationRepeatCount = 1.0f;

//    [_favoriteButton setBackgroundImage:[UIImage animatedImageNamed:@"heart" duration:2.0f] forState:UIControlStateHighlighted];
    
    // Do any additional setup after loading the view.
    [self nextWord:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [self thisWord:[self.dict word]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextWord:(id)sender {
    self.dict = [[Dictionary alloc] initWithRandomTerm];
    [self setData];
}

- (void) thisWord : (NSString *) word{
    self.dict = [[Dictionary alloc] initWithTerm:word];
    [self setData];
}

-(void)setData
{
    //[self performSelectorInBackground:@selector(setImage) withObject:nil];
    _imageDetailDictionary = nil;
    [self searchImage:[self.dict word]];
    
    /*detail = [detail stringByAppendingString:@"\n\nParts of speech :\n\n"];
    NSArray *partsOfSpeech = [self.dict getPartsOfSpeech];
    NSArray *arr;
    for (NSString *partOfSpeech in partsOfSpeech) {
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",partOfSpeech]];
        detail = [detail stringByAppendingString:@"\nDefinitions :\n"];
        arr = [self.dict getDefinitionsForPartOfSpeech:partOfSpeech];
        for (NSString *def in arr)
        {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@\n",def]];
        }
        detail = [detail stringByAppendingString:@"\nExample Sentences :\n"];
        arr = [self.dict getExampleSentenceForPartOfSpeech:partOfSpeech];
        for (NSStr ing *ex in arr)
        {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@\n",ex]];
        }
        detail = [detail stringByAppendingString:@"\nSynonyms :\n"];
        arr = [self.dict getSynonymsForPartOfSpeech:partOfSpeech];
        for (NSString *syn in arr)
        {
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"%@\n",syn]];
        }
    }*/
    
    [self loadWordDetail];
    
    if ([self isFavorite:[self.dict word]]) {
        [_favoriteButton setSelected:YES];
//        UIImage *image = [UIImage imageNamed:@"heart4.png"];
//        [_favoriteButton setImage:image forState:UIControlStateNormal];
//        [_favoriteButton setTitle:NSLocalizedString(@"Favorite", nil) forState:UIControlStateNormal];
    }else{
        [_favoriteButton setSelected:NO];
//        [_favoriteButton setImage:nil forState:UIControlStateNormal];
//        [_favoriteButton setTitle:NSLocalizedString(@"Add to a Favourites", nil) forState:UIControlStateNormal];
//        [_favoriteButton setUserInteractionEnabled:YES];
    }
}

- (void) loadWordDetail{
    NSString *htmlString = [self getDetailHtml:self.dict];
    [_definitionContentWebView setBackgroundColor:[UIColor clearColor]];
    [_definitionContentWebView setOpaque:NO];
    [_definitionContentWebView loadHTMLString:htmlString baseURL:nil];
}

- (NSString *) getDetailHtml : (Dictionary *) dictionary{
    NSLog(@"dictionary = %@", dictionary);
    NSString *detail = @"Def.";
    detail = [detail stringByAppendingString:[self.dict getDefinition]];
    
    /*
     content Place holder:
     [[[Word]]]
     [[[Pronunciation]]]
     [[[imageUrl]]]
     [[[DefTitle]]]
     [[[Definition]]]
     [[[ExampleSentences]]]
     */
    
    NSError *error = nil;
    NSString *detailHtml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"homedefinition" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Word]]]" withString:[dictionary word]];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Pronunciation]]]" withString:[NSString stringWithFormat:@"|%@|", [dictionary word]]];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[imageUrl]]]" withString:[self getGoogleImageUrlString:_imageDetailDictionary]];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[DefTitle]]]" withString:@"Def."];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[Definition]]]" withString:[[[dictionary definition] componentsSeparatedByString:@";"] firstObject]];
    detailHtml = [detailHtml stringByReplacingOccurrencesOfString:@"[[[ExampleSentences]]]" withString:[[[dictionary definition] componentsSeparatedByString:@";"] lastObject]];
    
    /*[NSString stringWithFormat:@"<html>\
                            <div style=\"font-family:verdana;font-size:20px\">%@</div>\
                            <div><img src=\"%@\"></div>\
                            <div>%@</div>\
                            </html>",
                            [dictionary word],
                            imageUrlString,
                            detail];*/
    return detailHtml;
}

- (BOOL) isFavorite : (NSString *) word{
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Term" predicate:[NSString stringWithFormat:@"word = \"%@\"", word]];
    NSError *error = nil;
    NSArray *termArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    NSLog(@"termArray = %@", termArray);
    return [termArray count];
}

//- (NSString *) pathForDefaultImage : (NSString *)imageName{
//    [[NSBundle mainBundle] pathForResource:<#(NSString *)#> ofType:<#(NSString *)#>]
//}

- (void) setImage {
    NSURL *imageUrl = [self getImageUrl:self.dict];
    NSLog(@"imageUrl = %@", imageUrl);
    if (imageUrl == nil)
        return;

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [self performSelectorOnMainThread:@selector(imageDownloaded:) withObject:image waitUntilDone:NO];
}

- (NSString *) getImageUrlString : (Dictionary *) dictionary{
    NSURL *imageUrl = [self getImageUrl:dictionary];
    if (imageUrl == nil)
        return @"http://placehold.it/175x90";
    return imageUrl.absoluteString;
}

- (NSString *) getGoogleImageUrlString : (NSDictionary *) dictionary{
    if (dictionary == nil)
        return @"http://placehold.it/175x90";
    
    return [dictionary[@"items"] firstObject][@"link"];
}


- (NSURL *) getImageUrl : (Dictionary *) dictionary {
    NSURL *imageUrl = [self.dict getImageForWord:[dictionary word]];
    if (imageUrl == nil || ![imageUrl isKindOfClass:[NSURL class]])
        return nil;
    return imageUrl;
}

- (void) imageDownloaded : (UIImage *) image{
    _imgView.image = image;
}

#pragma mark
#pragma mark-GestureRecognizer
- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
   [self nextWord:nil]; 
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
   [self nextWord:nil]; 
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToTermList"]) {
        TermListViewController *termListViewController = segue.destinationViewController;
        termListViewController.delegate = self;
        termListViewController.isAddingTerm = TRUE;
    }
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
    Term *term= [NSEntityDescription
                            insertNewObjectForEntityForName:@"Term"
                            inManagedObjectContext:context];
    term.word = self.dict.word;
    term.list = list;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

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
    [self performSegueWithIdentifier:@"homeToTermList" sender:nil];
}


#pragma mark - Search Image
- (void) searchImage : (NSString *) word{
    SearchImages *obj = [[SearchImages alloc] initWithDelegate:self];
    [obj searchImageForWord:word];
    
}

//SearchImagesDelegate
- (void) searchResult : (id) result error : (NSError *)error{
    NSLog(@"result = %@", result);
    if (error == nil && result[@"error"] == nil) {
        _imageDetailDictionary = (NSDictionary *) result;
        [self loadWordDetail];//call again after image is available
    }
}

- (void) imageDownloaded : (id) image error : (NSError *)error{
    
}
@end
