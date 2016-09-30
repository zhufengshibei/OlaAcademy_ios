//
//  HomeworkWebController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkWebController.h"

#import "SysCommon.h"
#import "Question.h"
#import "ExamManager.h"
#import <WebViewJavascriptBridge.h>

@interface HomeworkWebController ()

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) NSMutableArray *questionArray;

@end

@implementation HomeworkWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    // js调用ios方法
    [_bridge registerHandler:@"mathObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
    }];
    
    [self fetchQuestionList];
}

-(void)fetchQuestionList{
    if (_type==1) {
        CourseManager *cm = [[CourseManager alloc]init];
        [cm fetchQuestionWithPointId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray];
            }
        } Failure:^(NSError *error) {
            
        }];
    }else if(_type==2){
        ExamManager *em = [[ExamManager alloc]init];
        [em fetchQuestionWithExamId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray];
            }
        } Failure:^(NSError *error) {
        }];
    }
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"homework" ofType:@"html" inDirectory:@"MathJax/html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)setupQuestion:(NSArray*)questionArray{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:[NSString stringWithFormat:@"%ld",[questionArray count]] forKey:@"count"];
    int index=0;
    for (Question *question in questionArray){
        NSMutableDictionary *questionData = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *content = [question.question stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        [content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
        [questionData setObject:content forKey:@"title"];
        [dataDic setObject:questionData forKey:[NSString stringWithFormat:@"question%d",index]];
        index++;
    }
    [_bridge callHandler:@"javascriptHandler" data:dataDic responseCallback:^(id response) {
        NSLog(@"javascriptHandler responded: %@", response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
