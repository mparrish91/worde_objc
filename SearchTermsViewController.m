//
//  SearchTermsViewController.m
//  v2
//
//  Created by Technologies33 on 20/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "SearchTermsViewController.h"
#import "TermDetailTableViewController.h"

@interface SearchTermsViewController ()

@end

@implementation SearchTermsViewController
@synthesize dictResults;
@synthesize wordListResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_termSearchBar setTintColor:[UIColor colorWithRed:76.0f/255.0f green:206.0f/255.0f blue:86.0f/255.0f alpha:1.0]];
}

- (void) viewDidAppear:(BOOL)animated{
    [_termSearchBar becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.wordListResults count];
    }
    else
    {
        return [self.dictResults count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    if (indexPath.section == 0) {
        Term *term = (self.wordListResults)[indexPath.row];
        cell.textLabel.text = term.word;
    }
    else
    {
        cell.textLabel.text = [self.dictResults objectAtIndex:indexPath.row];
    }
    
    //cell.detailTextLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        Term *_term = (self.wordListResults)[indexPath.row];
        [self performSegueWithIdentifier:@"GoToDetail" sender:_term.word];
    }else if (indexPath.section == 1){
        [self performSegueWithIdentifier:@"GoToDetail" sender:dictResults[indexPath.row]];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0 && [tableView numberOfRowsInSection:section] > 0)
        return @"Wordlist Results";
    else if(section == 1 && [tableView numberOfRowsInSection:section] > 0)
        return @"Dictionary Results";
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

#pragma mark - Search Implementation
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [dictResults removeAllObjects];
    [wordListResults removeAllObjects];
    
    if([searchText length] != 0) {
        [self searchTerm:searchText];
    }
    
    [self.tblSearchResults reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    [self searchTerm:searchBar.text];
}

-(void)searchTerm : (NSString*)searchText {
    NSManagedObjectContext *context = [[AppDelegate instance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Term" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(word beginswith[c] %@)", searchText];
    
    [fetchRequest setPredicate:predicate];
    NSError *error;

    self.wordListResults = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    
    NSDictionary *dict = [[Lexicontext sharedDictionary] wordsWithPrefix:searchText];
    self.dictResults = [NSMutableArray arrayWithArray:[dict objectForKey:@"Noun"]];
    //NSLog(@"%@",dictResults);
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GoToDetail"]) {
        TermDetailTableViewController *detailViewController = (TermDetailTableViewController*) segue.destinationViewController;
        detailViewController.term = (NSString *)sender;
    }
}


@end
