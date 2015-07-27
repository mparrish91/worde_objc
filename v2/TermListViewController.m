//
//  TermListViewController.m
//  v2
//
//  Created by malcolm on 7/12/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "TermListViewController.h"
#import "TermsList.h"
#import "AppDelegate.h"
#import "TermsViewController.h"

@interface TermListViewController ()

@end

@implementation TermListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    if (self.isAddingTerm) {
        [self.leftBarButton setTitle:@"Cancel"];
        self.title = @"Select Favourite";
        self.navigationItem.leftBarButtonItem = self.leftBarButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.title = @"My Favourites";
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    self.termlists = [[self fetchRecordsFrom:@"TermsList"
                                      where:nil
                           epressionKeyPath:nil
                        expresstionFunction:nil
                                    orderBy:@"name"
                                  assending:YES] mutableCopy];
    [self.tableView reloadData];
}

- (NSArray *) fetchRecordsFrom : (NSString *) tableName
                         where : (NSString *) conditions
              epressionKeyPath : (NSString *) expressionKeyPath
           expresstionFunction : (NSString *) expressionsFunction
                       orderBy : (NSString *) orderColumn
                     assending : (BOOL) condition{
    NSLog(@"tableName = %@, conditions = %@",tableName, conditions);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[[AppDelegate instance] managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    if(orderColumn != nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:orderColumn ascending:condition];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    //setting up predicate
    if (conditions != nil) {
        NSPredicate *pridicate  = [NSPredicate predicateWithFormat:conditions];
        [fetchRequest setPredicate:pridicate];
    }
    
    //setting expressions
    if (expressionKeyPath != nil && expressionsFunction != nil) {
        // Create an expression for the key path.
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:expressionKeyPath];
        
        // Create an expression to represent the minimum value at the key path 'creationDate'
        NSExpression *expression = [NSExpression expressionForFunction:expressionsFunction arguments:[NSArray arrayWithObject:keyPathExpression]];
        
        // Create an expression description using the minExpression and returning a date.
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        
        // The name is the key that will be used in the dictionary for the return value.
        [expressionDescription setName:@"expression"];
        [expressionDescription setExpression:expression];
        [expressionDescription setExpressionResultType:NSDateAttributeType];
        
        // Set the request's properties to fetch just the property represented by the expressions.
        [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    }
    
    NSError *error;
    NSArray *fetchedObjects = [[[AppDelegate instance] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    /*if (![fetchedObjects count] || error){
     [CommonClass showAlert:@"Data not available!"];
     return nil;
     }*/
    
    return fetchedObjects;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)leftBarButtonAction:(id)sender
{
    if (self.isAddingTerm) {
        [self.delegate termListViewControllerDidCancel:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.termlists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TermListCell"];
    
    TermsList *termlist = self.termlists[indexPath.row];
    cell.textLabel.text = termlist.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d words",[termlist.word count]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TermsList *termlist = (self.termlists)[indexPath.row];
    if (self.isAddingTerm)
    {
        [self.delegate termListViewController:self didAddToTermList:termlist];
    }
    else
    {
        [self performSegueWithIdentifier:@"GoToTerms" sender:termlist];
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
         NSManagedObjectContext *context = [[AppDelegate instance] managedObjectContext];
        [context deleteObject:[self.termlists objectAtIndex:indexPath.row]];
        NSError * error = nil;
        if (![context save:&error])
        {
            NSLog(@"Error ! %@", error);
        }
        [self.termlists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *alphabets = [[NSMutableArray alloc] initWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    
    //Remove the last object (extra), '#' from the array.
    [alphabets removeLastObject];
    
    return [NSArray arrayWithArray:alphabets];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 0;
}

#pragma mark - PlayerDetailsViewControllerDelegate
- (void)addListViewControllerDidCancel:(AddListViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addListViewController:(AddListViewController *)controller didAddTermListWithName:(NSString *)name
{
    
    NSManagedObjectContext *context = [[AppDelegate instance] managedObjectContext];
    TermsList *termsList = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"TermsList"
                                      inManagedObjectContext:context];
    termsList.name = name;
   
    NSError *error;
    if (![context save:&error]) {
    }
    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    
    [self.termlists addObject:termsList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.termlists count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddTermList"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        AddListViewController *addListViewController = [navigationController viewControllers][0];
        addListViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"GoToTerms"]) {
        
        TermsViewController *termsViewController = (TermsViewController*) segue.destinationViewController;
        termsViewController.list = (TermsList*)sender;
    }
}

@end
