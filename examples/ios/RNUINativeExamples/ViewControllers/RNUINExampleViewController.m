//
//  RNUINExampleViewController.m
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "RNUINExampleViewController.h"

@interface RNUINExampleViewController ()

@property (nonatomic, strong) UIViewController <RNUINExampleControllerDelegate> *exampleController;
@property (nonatomic, strong) UIView *exampleView;

@end

@implementation RNUINExampleViewController

- (void)configureView {
    [self.exampleView removeFromSuperview];
    
    if (self.example) {
        self.navigationItem.title = self.example[@"title"];
        
        self.exampleController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:self.example[@"controller"]];
        [self.exampleController setExample:self.example];
        
        self.exampleView = self.exampleController.view;
        self.exampleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.exampleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.exampleView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)setExample:(NSDictionary *)example {
    if (_example != example) {
        _example = example;
        
        [self configureView];
    }
}

@end
