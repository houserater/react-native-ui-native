//
//  RNUINExamplesTableViewController.m
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "RNUINExamplesTableViewController.h"
#import "RNUINExampleViewController.h"

#import <RNUINative/RNUINativeManager.h>

@interface RNUINExamplesTableViewController ()

@property (strong, nonatomic) NSArray *examples;

@end

@implementation RNUINExamplesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [RNUINativeManager loadDataWithHandler:@"ExamplesList.findExamples()" completionBlock:^(NSArray *examples, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to ExamplesList.findExamples()" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        self.examples = examples;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exampleCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.examples[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showExample"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.examples[indexPath.row];
        RNUINExampleViewController *controller = (RNUINExampleViewController *)[[segue destinationViewController] topViewController];
        [controller setExample:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

@end
