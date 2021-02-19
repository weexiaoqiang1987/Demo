//
//  ViewControllerTwo.m
//  webviewtest
//
//  Created by admin on 2021/2/4.
//

#import "ViewControllerTwo.h"
#import "ViewControllerThree.h"
#import "UIView+SetRect.h"

@interface ViewControllerTwo ()
@end

@implementation ViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    self.title = @"第二个控制器";
    self.view.backgroundColor = kRandomColor;
    
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(80, 150, 100, 40)];
    [dismiss setTitle:@"dismiss" forState:UIControlStateNormal];
    dismiss.backgroundColor = kRandomColor;
    [dismiss addTarget:self
                action:@selector(dismiss)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
    
    UIButton *pushbtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 150, 100, 40)];
    [pushbtn setTitle:@"pushVC" forState:UIControlStateNormal];
    pushbtn.backgroundColor = kRandomColor;
    [pushbtn addTarget:self
                action:@selector(pushVC)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushbtn];
     
    UIView *input = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
    input.backgroundColor = kRandomColor;
    
    self.textField= [[UITextField alloc] initWithFrame:CGRectMake(140, 250, 100, 40)];
    self.textField.backgroundColor = kRandomColor;
    [self.textField becomeFirstResponder];
    self.textField.inputAccessoryView = input;
    [self.view addSubview:self.textField];
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, Height-60, Width, 60)];
    self.searchView.backgroundColor = kRandomColor;
    [self.view addSubview:self.searchView];
}

- (void)addNotification {
    [[NSNotificationCenter  defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillChangeFrameNotify:)
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChangeFrameNotify:(NSNotification *)noti {
    NSDictionary *dict =  noti.userInfo;
    CGRect KeyboardFrame =  [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat KeyboardY =  KeyboardFrame.origin.y;
    NSTimeInterval timeInterval = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    UIViewAnimationCurve curve = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue];//动画曲线类型

    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:timeInterval animations:^{
        self.searchView.frame =  CGRectMake(0, KeyboardY - 80, Width, 60);
    }];
}

- (void)pushVC{
    ViewControllerThree *vc = [[ViewControllerThree alloc] init];
    vc.view.backgroundColor = UIColor.blueColor;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
