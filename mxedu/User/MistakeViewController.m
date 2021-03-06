//
//  MistakeViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MistakeViewController.h"

#import "AuthManager.h"
#import "CourseManager.h"
#import "ExamManager.h"
#import "Question.h"
#import "QuestionOption.h"
#import "SysCommon.h"
#import "Masonry.h"
#import "SysCommon.h"
#import "CourseManager.h"
#import "Question.h"
#import "QuestionOption.h"
#import "Correctness.h"
#import "QuestionResultViewController.h"
#import <WebViewJavascriptBridge.h>


@interface MistakeViewController ()

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) NSMutableArray *questionArray;
@property (nonatomic) int currentIndex; //当前第几道题
@property (nonatomic) NSMutableArray *correctnessArray;//答题结果


@end

@implementation MistakeViewController{
    UIButton *preButton;
    UIButton *nextButton;
    UILabel *subjectNoLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{
    
    self.title = @"错题集";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    
    UITextView *tipText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    tipText.font = [UIFont systemFontOfSize:16.0];
    tipText.textColor = RGBCOLOR(255, 102, 92);
    tipText.text = @" 已有398702人复习 错误率33%";
    [self.view addSubview:tipText];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    // js调用ios方法
    [_bridge registerHandler:@"mathObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *optionIndex = [data objectForKey:@"optionIndex"];
        [self chooseAnswer:optionIndex];
        
        if (_currentIndex<[_questionArray count]-1) {
            if (_currentIndex==[_questionArray count]-2) {
                [nextButton setTitle:@"提交" forState:UIControlStateNormal];
            }
            _currentIndex++;
            preButton.hidden = NO;
            subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
            [self setupQuestion:_questionArray Index:_currentIndex];
        }else{
            [self submitAnswerToServer];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.view addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-60);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@1);
    }];
    
    preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal] ;
    [preButton addTarget:self action:@selector(clickPrevious:) forControlEvents:UIControlEventTouchDown];
    [preButton setTitle:@"上一题" forState:UIControlStateNormal];
    [self.view addSubview:preButton];
    
    subjectNoLabel = [[UILabel alloc]init];
    subjectNoLabel.textColor = RGBCOLOR(144, 144, 144);
    [self.view addSubview:subjectNoLabel];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchDown];
    [nextButton setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [subjectNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    
    _currentIndex = 0;
    preButton.hidden = YES;
    
    if (_objectId) {
        [self fetchWrongSubjectList];
    }
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchWrongSubjectList{
    NSString *userId = @"";
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchWrongSubjectListWithID:_objectId Type:@"1" UserId:userId Success:^(QuestionListResult *result) {
        _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
        if ([_questionArray count]>0) {
            if([_questionArray count]==1){
                [nextButton setTitle:@"提交" forState:UIControlStateNormal];
            }
            [self loadExamplePage:_webView];
            [self setupQuestion:_questionArray Index:_currentIndex];
            subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
            _correctnessArray = [NSMutableArray arrayWithCapacity:[_questionArray count]];
        }else{
            nextButton.hidden = YES;
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"question" ofType:@"html" inDirectory:@"MathJax/html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)setupQuestion:(NSArray*)questionArray Index:(int)currentIndex{
    Question *question =[questionArray objectAtIndex:currentIndex];
    NSMutableDictionary *questionData = [NSMutableDictionary dictionaryWithCapacity:[question.optionList count]+1];
    NSString *content = [question.question stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
    [questionData setObject:content forKey:@"title"];
    int i = 0;
    NSString *rightanswer;
    NSString *currentChoice;
    for (QuestionOption *option in question.optionList) {
        i++;
        if (option.content&&![option.content isEqualToString:@""]) {
            [questionData setObject:option.content forKey:[NSString stringWithFormat:@"option%d",i]];
            if([option.isanswer isEqualToString:@"1"]){
                rightanswer =[NSString stringWithFormat:@"%d",64+i];
            }
            if (option.isCurrentChosen==1) {
                currentChoice = [NSString stringWithFormat:@"%d", i-1];
            }
        }
    }
    [questionData setObject:rightanswer forKey:@"rightanswer"];
    [questionData setObject:@"1" forKey:@"showAnswer"];
    if (currentChoice) {
        [questionData setObject:currentChoice forKey:@"currentChoice"];
    }
    NSString *hint = question.hint?[question.hint stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]:@"暂无解析";
    [hint stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
    [questionData setObject:hint forKey:@"hint"];
    [questionData setObject:question.pic?question.pic:@"" forKey:@"pic"];
    [questionData setObject:question.hintpic?question.hintpic:@"" forKey:@"hintpic"];
    [_bridge callHandler:@"javascriptHandler" data:questionData responseCallback:^(id response) {
        NSLog(@"javascriptHandler responded: %@", response);
    }];
}


-(void)clickPrevious:(UIButton*)button{
    //    [_bridge callHandler:@"previousClickHandler" data:questionData responseCallback:^(id response) {
    //    }];
    
    if (_currentIndex>0) {
        [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
        _currentIndex--;
        if (_currentIndex==0) {
            preButton.hidden = YES;
        }
        subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
        [self setupQuestion:_questionArray Index:_currentIndex];
    }
}

-(void)clickNext:(UIButton*)button{
    [_bridge callHandler:@"nextClickHandler" data:nil responseCallback:^(id response) {
    }];
}

#pragma choose answer
-(void)chooseAnswer:(NSString *)optionIndex{
    Question *question =[_questionArray objectAtIndex:_currentIndex];
    Correctness *correct = [[Correctness alloc]init];
    correct.no = question.questionId;
    if (optionIndex) {
        QuestionOption *option = question.optionList[[optionIndex intValue]];
        option.isCurrentChosen = 1;
        [question.optionList replaceObjectAtIndex:[optionIndex intValue] withObject:option];
        [_questionArray replaceObjectAtIndex:_currentIndex withObject:question];
        correct.optId = option.optionId;
        correct.isCorrect = option.isanswer;
    }else{
        correct.isCorrect = @"2";
    }
    
    correct.timeSpan = @"10";
    _correctnessArray[_currentIndex] = correct;
}

// 提交答案
-(void)submitAnswerToServer{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        CourseManager *cm = [[CourseManager alloc]init];
        NSString *answerJson = [self jsonStringFromDictionary];
        [cm submitQuestionAnswerWithId:am.userInfo.userId answer:answerJson type:@"1" Success:^(QuestionListResult *result) {
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(NSString*)jsonStringFromDictionary{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_correctnessArray count]];
    for (Correctness *correctness in _correctnessArray) {
        if (correctness.optId) {
            NSDictionary *answerDict = [NSDictionary dictionaryWithObjectsAndKeys:correctness.no,@"no",correctness.optId,@"optId",correctness.timeSpan,@"timeSpan", nil];
            [array addObject:answerDict];
        }
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}



@end