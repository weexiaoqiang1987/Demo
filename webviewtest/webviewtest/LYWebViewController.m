//
//  LYWebViewController.m
//  Test
//
//  Created by DHY on 2021/1/29.
//

#import "LYWebViewController.h"
#import <WebKit/WebKit.h>

@class MyScriptMessageHandler;
@protocol MyScriptMessageHandlerDelegate <NSObject>

@optional
- (void)calledCloseWebViewInHandler:(MyScriptMessageHandler *)handler;

@end
/// 关闭当前webview控制器的js回调处理类
@interface MyScriptMessageHandler : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<MyScriptMessageHandlerDelegate> delegate;

- (instancetype)initWithDelegate:(id<MyScriptMessageHandlerDelegate>)delegate;

+ (instancetype)handlerWithDelegate:(id<MyScriptMessageHandlerDelegate>)delegate;

@end
@implementation MyScriptMessageHandler

- (instancetype)initWithDelegate:(id<MyScriptMessageHandlerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

+ (instancetype)handlerWithDelegate:(id<MyScriptMessageHandlerDelegate>)delegate{
    return [[MyScriptMessageHandler alloc] initWithDelegate:delegate];
}

#pragma mark - MyScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(calledCloseWebViewInHandler:)]) {
        [self.delegate calledCloseWebViewInHandler:self];
    }
}

@end

// close即：js回调方法
static NSString * const kJavaScriptCloseHandler = @"close";

@interface LYWebViewController ()<MyScriptMessageHandlerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LYWebViewController

- (void)dealloc{
    if (@available(iOS 14.0, *)) {
        [self.webView.configuration.userContentController removeAllScriptMessageHandlers];
    } else {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kJavaScriptCloseHandler];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 这里的clickUrl是根据实际业务获取的,用于展示广告页
    self.clickUrl = @"http://192.168.10.44:8080/?type=4&sign=SceSz8Z%20pWp57uIBDwTgU37PNpSWqhuR6X1%20x3zqijnMiDUm%2F4HKFPc93MXxh9NFZ7WkexSWf2Hi43Ri&ri=5c1a876f1fa1804353088e3209b43c57";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 让webview上的视频可以自动播放
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else {
        if (@available(iOS 9.0, *)) {
            config.requiresUserActionForMediaPlayback = NO;
        } else {
            config.mediaPlaybackRequiresUserAction = NO;
        }
    }
    WKUserContentController *content = [[WKUserContentController alloc] init];
    [content addScriptMessageHandler:[MyScriptMessageHandler handlerWithDelegate:self] name:kJavaScriptCloseHandler];
    config.userContentController = content;
    config.allowsInlineMediaPlayback = YES; // 让webview上的视频支持非全屏播放
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    
    NSString *urlStr = [self.clickUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // 防止URL中存在中文字符
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self.view addSubview:self.webView];
    
    if (@available(iOS 13.0, *)) {
        self.webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    } else {
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

/// 页面布局
- (void)viewWillLayoutSubviews{
    CGRect rect = self.view.bounds;
    rect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    rect.size.height -= rect.origin.y;
    self.webView.frame = rect; // 这里确保状态栏不会这样webview视图，防止网页中的按钮被状态栏遮挡，无法点击。
}

#pragma mark - MyScriptMessageHandlerDelegate
- (void)calledCloseWebViewInHandler:(MyScriptMessageHandler *)handler{
    [self.navigationController popViewControllerAnimated:YES];// 这里是close回调处理方法，根据自己的实际情况，来关闭当前viewController
}

@end
