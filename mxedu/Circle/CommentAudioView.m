//
//  CommentAudioView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentAudioView.h"

#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "SysCommon.h"
#import "mediaModel.h"


@implementation NSString (TimeString)

+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    else
    {
        return  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
}

@end

@interface CommentAudioView()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@end

@implementation CommentAudioView
{
    //Recording
    AVAudioRecorder *_audioRecorder;
    NSString *_recordingFilePath;
    BOOL _isRecording;
    CADisplayLink *meterUpdateDisplayLink;
    UILabel *recordingTime;
    UIImageView *recordBG;
    
    //Playing
    AVAudioPlayer *_audioPlayer;
    CADisplayLink *playProgressDisplayLink;
    
    BOOL _isPlaying;
    
    UIButton *_recordButton;
    UIButton *_playButton;
    UIButton *_trashButton;
    UIBarButtonItem *_pauseButton;
    
    NSString *_oldSessionCategory;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRecording];
        [self startUpdatingMeter];
    }
    return self;
}

-(void)setupRecording{
    //Unique recording URL
    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    _recordingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",fileName]];
    
    {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.layer.cornerRadius = GENERAL_SIZE(20);
        _playButton.layer.masksToBounds = YES;
        _playButton.backgroundColor = RGBCOLOR(187,222,251);
        [_playButton setImage:[UIImage imageNamed:@"ic_broadcasting"] forState:UIControlStateNormal];
        [_playButton setTitleColor:RGBCOLOR(88, 147, 244) forState:UIControlStateNormal];
        _playButton.titleLabel.font = LabelFont(24);
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_playButton];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(-GENERAL_SIZE(70));
            make.width.equalTo(@(GENERAL_SIZE(130)));
            make.height.equalTo(@(GENERAL_SIZE(60)));
        }];
        
        _trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _trashButton.layer.borderWidth = 1.0f;
        _trashButton.layer.borderColor = [RGBCOLOR(217, 217, 217) CGColor];
        _trashButton.layer.cornerRadius = GENERAL_SIZE(30);
        _trashButton.layer.masksToBounds = YES;
        [_trashButton setTitle:@"重录" forState:UIControlStateNormal];
        [_trashButton setTitleColor:RGBCOLOR(83, 83,83) forState:UIControlStateNormal];
        _trashButton.titleLabel.font = LabelFont(24);
        [_trashButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_trashButton];
        
        [_trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(GENERAL_SIZE(70));
            make.width.equalTo(@(GENERAL_SIZE(130)));
            make.height.equalTo(@(GENERAL_SIZE(60)));
        }];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_start"] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        [_recordButton addTarget:self action:@selector(recordingButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_recordButton];
        
        [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        recordBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_recordingt_time"]];
        [self addSubview:recordBG];
        
        [recordBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_recordButton.mas_right).offset(-10);
            make.bottom.equalTo(_recordButton.mas_top).offset(15);
        }];
        
        recordingTime = [[UILabel alloc]init];
        recordingTime.textColor = [UIColor whiteColor];
        recordingTime.textAlignment = NSTextAlignmentCenter;
        recordingTime.font = LabelFont(24);
        [recordBG addSubview:recordingTime];
        
        [recordingTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recordBG);
            make.centerY.equalTo(recordBG).offset(-2);
        }];
        
        
        _playButton.hidden = YES;
        _trashButton.hidden = YES;
        recordBG.hidden = YES;
    }
    
    // Define the recorder setting
    {
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_recordingFilePath] settings:recordSetting error:nil];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
    }
    
}

-(void)startUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [meterUpdateDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = nil;
}


// 录音
- (void)recordingButtonAction:(UIButton *)item
{
    if (_isRecording == NO)
    {
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_finish"] forState:UIControlStateNormal];
        _isRecording = YES;
        
        //UI Update
        {
            _playButton.hidden = YES;
            _trashButton.hidden = YES;
            _recordButton.hidden = NO;
            recordBG.hidden = NO;
        }
        
        /*
         Create the recorder
         */
        if ([[NSFileManager defaultManager] fileExistsAtPath:_recordingFilePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:_recordingFilePath error:nil];
        }
        
        _oldSessionCategory = [[AVAudioSession sharedInstance] category];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
    }
    else
    {
        _isRecording = NO;
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_start"] forState:UIControlStateNormal];
        _recordButton.hidden = NO;
        
        //UI Update
        {
            _playButton.hidden = NO;
            _trashButton.hidden = NO;
            _recordButton.hidden = YES;
            recordBG.hidden = YES;
        }
        
        [_audioRecorder stop];
        [[AVAudioSession sharedInstance] setCategory:_oldSessionCategory error:nil];
        
        [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
    }
}

// 播放
- (void)playAction:(UIButton *)item
{
    if (!_isPlaying) {
        _isPlaying = YES;
        _oldSessionCategory = [[AVAudioSession sharedInstance] category];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_recordingFilePath] error:nil];
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
        //UI Update
        {
            _recordButton.enabled = NO;
            _trashButton.enabled = NO;
        }
        
        //Start regular update
        {
            [_playButton setTitle:[NSString timeStringForTimeInterval:(_audioPlayer.duration-_audioPlayer.currentTime)] forState:UIControlStateNormal];
            
            [playProgressDisplayLink invalidate];
            playProgressDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayProgress)];
            [playProgressDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
    }else{
        _isPlaying = NO;
        
        //UI Update
        {
            _recordButton.enabled = YES;
            _trashButton.enabled = YES;
        }
        
        {
            [playProgressDisplayLink invalidate];
            playProgressDisplayLink = nil;
        }
        
        _audioPlayer.delegate = nil;
        [_audioPlayer stop];
        _audioPlayer = nil;
        
        [[AVAudioSession sharedInstance] setCategory:_oldSessionCategory error:nil];
        
        [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
    }
}

-(void)deleteAction:(UIButton*)item
{
    [[NSFileManager defaultManager] removeItemAtPath:_recordingFilePath error:nil];
    
    _recordButton.hidden = NO;
    _playButton.hidden = YES;
    _trashButton.hidden = YES;

}

#pragma mark - Update Meters

- (void)updateMeters
{
    [_audioRecorder updateMeters];
    
    CGFloat normalizedValue = pow (10, [_audioRecorder averagePowerForChannel:0] / 20);
    
    if (_audioRecorder.isRecording)
    {
        recordingTime.text = [NSString timeStringForTimeInterval:_audioRecorder.currentTime];
    }
}

#pragma mark - Update Play Progress

-(void)updatePlayProgress
{
    [_playButton setTitle:[NSString timeStringForTimeInterval:(_audioPlayer.duration-_audioPlayer.currentTime)] forState:UIControlStateNormal];
}


#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _isPlaying = NO;
    [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    mediaModel *audioModel = [[mediaModel alloc] init];
    audioModel.type = @"2";
    audioModel.timeLong = recordingTime.text;
    audioModel.localpath = _recordingFilePath;
    audioModel.image = [UIImage imageNamed:@"ic_audio"];
    audioModel.isExit=NO;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    //    NSLog(@"%@: %@",NSStringFromSelector(_cmd),error);
}

-(void)dealloc{
    _audioPlayer.delegate = nil;
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    _audioRecorder.delegate = nil;
    [_audioRecorder stop];
    _audioRecorder = nil;
    
    [self stopUpdatingMeter];
}


@end
