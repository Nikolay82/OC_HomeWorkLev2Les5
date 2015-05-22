//
//  ViewController.m
//  UseThread
//
//  Created by Nikolay on 22.05.15.
//  Copyright (c) 2015 gng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewTaskOne;

@property (strong, nonatomic) IBOutlet UILabel *labelTaskOne;

- (IBAction)btnDoTaskOne:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewTaskTwo;

@property (strong, nonatomic) IBOutlet UILabel *labelTaskTwo;

- (IBAction)btnDoTaskTwo:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewTaskThree;

@property (strong, nonatomic) IBOutlet UILabel *labelTaskThree;

- (IBAction)btnDoTaskThree:(id)sender;


@property (nonatomic, strong) NSThread * threadTaskTwo;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setView];
    
}


- (void) setView {
    
    self.viewTaskOne.layer.borderColor = [UIColor redColor].CGColor;
    self.viewTaskOne.layer.borderWidth = 1.0f;
    self.viewTaskOne.layer.cornerRadius = 3.0f;
    self.viewTaskOne.backgroundColor = [UIColor grayColor];
    self.labelTaskOne.text = @"Задача №1 не выполнена";
    
    self.viewTaskTwo.layer.borderColor = [UIColor redColor].CGColor;
    self.viewTaskTwo.layer.borderWidth = 1.0f;
    self.viewTaskTwo.layer.cornerRadius = 3.0f;
    self.viewTaskTwo.backgroundColor = [UIColor grayColor];
    self.labelTaskTwo.text = @"Задача №2 не выполнена";
    
    self.viewTaskThree.layer.borderColor = [UIColor redColor].CGColor;
    self.viewTaskThree.layer.borderWidth = 1.0f;
    self.viewTaskThree.layer.cornerRadius = 3.0f;
    self.viewTaskThree.backgroundColor = [UIColor grayColor];
    self.labelTaskThree.text = @"Задача №3 не выполнена";
}



- (void)doTaskOne {

    [self performSelectorOnMainThread:@selector(doingTaskOne) withObject:nil waitUntilDone:YES];

    for (int i = 0; i < 10000; i++) {
        NSLog(@"T1 = %i/10000", i);
    }
    
    [self performSelectorOnMainThread:@selector(didTaskOneDone) withObject:nil waitUntilDone:YES];
}


- (void)doingTaskOne {
    
    self.viewTaskOne.backgroundColor = [UIColor yellowColor];
    self.labelTaskOne.text = @"Задача №1 выполняется";
    
}

- (void)didTaskOneDone {

    self.viewTaskOne.backgroundColor = [UIColor greenColor];
    self.labelTaskOne.text = @"Задача №1 выполнена";

}


- (void)doTaskTwo {
    
    [self performSelectorOnMainThread:@selector(doingTaskTwo) withObject:nil waitUntilDone:YES];
    
    @autoreleasepool {
    
        for (int i = 0; i < 50000; i++) {
            NSLog(@"T2 = %i/50000", i);
        }
    }
    
    [self performSelectorOnMainThread:@selector(didTaskTwoDone) withObject:nil waitUntilDone:YES];
}

- (void)doingTaskTwo {
    
    self.viewTaskTwo.backgroundColor = [UIColor yellowColor];
    self.labelTaskTwo.text = @"Задача №2 выполняется";
    
}

- (void)didTaskTwoDone {
    
    self.viewTaskTwo.backgroundColor = [UIColor greenColor];
    self.labelTaskTwo.text = @"Задача №2 выполнена";
    
}



- (void)doTaskThree {
    
    @autoreleasepool {
     
        for (int i = 0; i < 100000; i++) {
            NSLog(@"T3 = %i/100000", i);
        }
        
    }
    
}

- (void)doingTaskThree {
    
    self.viewTaskThree.backgroundColor = [UIColor yellowColor];
    self.labelTaskThree.text = @"Задача №3 выполняется";
    
}

- (void)didTaskThreeDone {
    
    self.viewTaskThree.backgroundColor = [UIColor greenColor];
    self.labelTaskThree.text = @"Задача №3 выполнена";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDoTaskOne:(id)sender {
    
    [self performSelectorInBackground:@selector(doTaskOne) withObject:nil];

}

- (IBAction)btnDoTaskTwo:(id)sender {
    
    self.threadTaskTwo = [[NSThread alloc] initWithTarget:self selector:@selector(doTaskTwo) object:nil];
    self.threadTaskTwo.name = @"doTaskTwo";
    [self.threadTaskTwo start];
    
}

- (IBAction)btnDoTaskThree:(id)sender {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self doingTaskThree];
            
        });
        
        [self doTaskThree];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self didTaskThreeDone];
            
        });
        
    });
    
    
}
@end
