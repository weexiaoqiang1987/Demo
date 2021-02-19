//
//  ViewController.m
//  webviewtest
//
//  Created by admin on 2020/12/16.
//

#import "ViewController.h"
#import "ViewControllerOne.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目录";
    
}

- (IBAction)transiitionClick:(id)sender {
    ViewControllerOne *vc = [[ViewControllerOne alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
