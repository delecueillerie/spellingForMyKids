//
//  SPPhonemeList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPPhonemeList.h"
#import "APIKey.h"
#import "Phoneme.h"

@interface SPPhonemeList ()

@end

@implementation SPPhonemeList

- (NSString *) entityName {
    return @"Phoneme";
}

- (NSString *) sortDescriptor {
    return @"api";
}

- (NSString *) storyboardVCId {
    return @"APhoneme";
}

- (NSString *) titleNavigationBar:(id) sender {
    return @"Phoneme list";
}



////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//OVERRIDDEN METHOD
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadPhonemeList) forControlEvents:UIControlEventValueChanged];
}

- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [super configureCell:tableViewCell withObject:object];
    tableViewCell.textLabel.text = [object valueForKey:@"api"];
    NSLog(@"table view Cell %@", tableViewCell.textLabel.text);
    return tableViewCell;
}

- (void) setUpBarButtonItems {
    // Set up the buttons in navigationBar
    self.tabBarController.navigationItem.title=[self.delegate titleNavigationBar:self];
    if (!([self.delegate rowSelected:self] == rowSelectedOpenVC)) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    }
    else {
        //BECAREFULL this VC in not ont the top of navigation controller stack, it is the tab bar that is on the top!! thus customize navigation item of the tab bar
        //self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    }
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//TRIGERRED
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

- (void) downloadPhonemeList {
    SYSyncEngine *syncEngine = [SYSyncEngine sharedEngine];
    syncEngine.delegate = self;
    [syncEngine downloadPhoneme];
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//SYNC ENGINE DELEGATE
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

- (void) managedObjectContextUpdated {
    NSError *error =nil;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


@end
