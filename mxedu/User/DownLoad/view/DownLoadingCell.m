//
//  DownLoadingCell.m
//  NTreat
//
//  Created by 周冉 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DownLoadingCell.h"
#import "DownloadModal.h"
#import "SDMyStrokeControl.h"
#import "UIImageView+WebCache.h"
#import "SUIButton.h"
#import "DownloadManager.h"
#import "SDTool.h"
#import "SysCommon.h"
@interface DownLoadingCell()<
DownloadStatusDelget
>

@property (nonatomic,strong) UIImageView *imageViewSelect;
@property (nonatomic,strong) SDMyStrokeControl *strokeControl;
@property (nonatomic,strong) UIImageView *imageviewThum;
@property (nonatomic,strong) UIView *viewZhezhao;
@property (nonatomic,strong) UILabel *labelTotalPlayTime;
@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UIView *viewPerson;
@property (nonatomic,strong) UIImageView *imageViewPerson;
@property (nonatomic,strong) UILabel *labelAuthor;
@property (nonatomic,strong) UIView *viewVideoSize;
@property (nonatomic,strong) UIImageView *imageViewVideoSize;
@property (nonatomic,strong) UILabel *labelVideoSize;
@property (nonatomic,strong) UIView *labelLine;
@property (nonatomic,strong) UIView *viewPercent;

@property (nonatomic,strong) UILabel *labelProgressHint;
@property (nonatomic,strong) UILabel *labelProgress;
@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) SUIButton *buttonStatus;
@end


@implementation DownLoadingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    _downloadModal.delegate = nil;
    [self.contentView removeObserver:self forKeyPath:@"frame"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"])
    {
        [self setUpViewSelect];
    }
}

#pragma mark 事件
- (void)changeDownLoadStatus:(SUIButton *)btn
{
    if(_localVideoCellTyp == eAllinMyLocalVideoCellDoing )
    {
        if([_downloadModal downloadStatusType] == eDownloadStatusOn)
        {
            [[DownloadManager sharedDownloadManager] pauseASessionTask:_downloadModal];
            [[DownloadManager sharedDownloadManager] remakeDownloads];
        }
        else if([_downloadModal downloadStatusType] == eDownloadStatusWait)
        {
            [[DownloadManager sharedDownloadManager] pauseASessionTask:_downloadModal];
        }
        else if([_downloadModal downloadStatusType] == eDownloadStatusPause)
        {
            [[DownloadManager sharedDownloadManager] startASessionTask:_downloadModal];
        }
        [self setUpViewDownLoadStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshDownloadVideoStatus", ) object:nil];
    }
}

#pragma mark 辅助
- (void)uploadProgressView
{
    NSString *stringTotalSize = [_downloadModal stringTotalSize];
    
   
    
    NSString *strCurSize = [[_downloadModal curloadSize] stringValue];
    
    double percent = [strCurSize doubleValue] / [stringTotalSize doubleValue];
    
    if(_labelProgress)
    {
        [_labelProgress setText:[NSString stringWithFormat:@"%.2f%@",percent * 100,@"%"]];
    }
    
    if(_labelProgressHint)
    {
        _labelProgressHint.text = [NSString stringWithFormat:@"%@/%@",[SDTool getFileSizeString: strCurSize],
                                   [SDTool getFileSizeString: stringTotalSize]];
    }
    
    if(_progressView)
    {
        [_progressView setProgress:percent];
    }
}

- (BOOL)canDownload
{

    return NO;
}

// 设置
- (void)setIsSEditing:(BOOL)isSEditing
{
    _isSEditing = isSEditing;
    [self setUpViewSelect];
}

- (void)setIsSelecting:(BOOL)isSelecting
{
    _isSelecting = isSelecting;
    [self setUpViewSelect];
}

#pragma mark UI
- (void)reloadSubview:(DownloadModal *)downloadModal
{
    downloadModal.delegate = self;
    _downloadModal = downloadModal;
    [self setUp];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}

// CellUnSelect CellSelected
- (void)setUp
{
    [[self.contentView subviews] valueForKey:@"removeFromSuperview"];
    
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = 0;
    
    // 选择
    if(_isSEditing == YES)
    {
        [self setUpViewSelect];
    }
    else if([_imageViewSelect isHidden] == NO)
    {
        [_imageViewSelect setHidden:YES];
    }
    
    if(_strokeControl == nil)
    {
        
        _strokeControl = [[SDMyStrokeControl alloc] init];
    }
    if([_strokeControl isDescendantOfView:self.contentView] == NO)
    {
        [self.contentView addSubview:_strokeControl];
    }
    
    spaceXStart = 10 * kScreenScaleWidth;
    spaceYStart = 10 ;
    [_strokeControl setFrame:CGRectMake(spaceXStart,spaceYStart, 107 * kScreenScaleWidth, 72 )];
    
    // 缩略图
    if(_imageviewThum == nil)
    {
        _imageviewThum = [[UIImageView alloc] init];
        [_imageviewThum setUserInteractionEnabled:YES];
    }
    if([_imageviewThum isDescendantOfView:_strokeControl] == NO)
    {
        [_strokeControl addSubview:_imageviewThum];
    }
    _imageviewThum.backgroundColor = [UIColor whiteColor];
    [_imageviewThum setFrame:CGRectMake(1.5, 1.5, CGRectGetWidth(_strokeControl.bounds) - 3.0, CGRectGetHeight(_strokeControl.bounds) - 3.0)];
    if(_downloadModal.stringImgDownloadPath)
    {
        if([_downloadModal.stringImgDownloadPath hasPrefix:@"/var"])
        {
            NSRange range = [_downloadModal.stringImgDownloadPath rangeOfString:kImgListPath];
            if(range.location != NSNotFound && range.length)
            {
                NSString *subPathString = [_downloadModal.stringImgDownloadPath substringFromIndex:range.location];
                _downloadModal.stringImgDownloadPath = [kDocPath stringByAppendingString:subPathString];
            }
        }
        
        [_imageviewThum setImage:[UIImage imageWithContentsOfFile:_downloadModal.stringImgDownloadPath]];
    }
    else
    {
        if(_downloadModal.stringShowImageURL){
            [_imageviewThum sd_setImageWithURL:[NSURL URLWithString:_downloadModal.stringShowImageURL] placeholderImage:[UIImage imageNamed:@"ic_video"]] ;
        }
    }
    
    // 遮罩
    if(!_viewZhezhao)
    {
        _viewZhezhao = [[UIView alloc] init];
        [_viewZhezhao setUserInteractionEnabled:YES];
        [_viewZhezhao setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        [_viewZhezhao setFrame:_strokeControl.bounds];
    }
    if([_viewZhezhao isDescendantOfView:_strokeControl] == NO)
    {
        [_strokeControl addSubview:_viewZhezhao];
    }
    
    // 状态
    if(_localVideoCellTyp == eAllinMyLocalVideoCellDoing)
    {
        [self setUpViewDownLoadStatus];
    }
    
    // 总长
    if(_labelTotalPlayTime == nil)
    {
        _labelTotalPlayTime = [[UILabel alloc] init];
        [_labelTotalPlayTime setBackgroundColor:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.5f]];
        [_labelTotalPlayTime setTextAlignment:NSTextAlignmentCenter];
        [_labelTotalPlayTime setFont:[UIFont systemFontOfSize:7]];
        [_labelTotalPlayTime setTextColor:[UIColor whiteColor]];
        [_labelTotalPlayTime setNumberOfLines:2];
    }
    if([_labelTotalPlayTime isDescendantOfView:_strokeControl] == NO)
    {
        [_strokeControl addSubview:_labelTotalPlayTime];
    }
    [_labelTotalPlayTime setText:[_downloadModal stringPlayTime]];
    [_labelTotalPlayTime setFrame:CGRectMake(0, CGRectGetMaxY(_strokeControl.bounds) - 20, CGRectGetWidth(_imageviewThum.bounds) / 2.0, 20)];
    
    // 标题
    if(_labelTitle == nil)
    {
        _labelTitle = [[UILabel alloc] init];
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [_labelTitle setTextAlignment:NSTextAlignmentLeft];
//        [_labelTitle setFont:Font_Hei(13)];
//        [_labelTitle setTextColor:kCellTextColor];
        [_labelTitle setNumberOfLines:2];
    }
    if([_labelTitle isDescendantOfView:self.contentView] == NO)
    {
        [self.contentView addSubview:_labelTitle];
    }
    [_labelTitle setText:[_downloadModal stringVideoName]];
    
    spaceXStart = CGRectGetMaxX(_strokeControl.frame) + 10 * kScreenScaleWidth;
    spaceYStart = 10 * kScreenScaleHeight;
    [_labelTitle setFrame:CGRectMake(spaceXStart, spaceYStart, (SCREEN_WIDTH - spaceXStart - 10 * kScreenScaleWidth), 20)];
    
    if(_localVideoCellTyp == eAllinMyLocalVideoCellOver)
    {
        // 作者
        if(_viewPerson == nil)
        {
            _viewPerson = [[UIView alloc] init];
        }
        if([_viewPerson isDescendantOfView:self.contentView] == NO)
        {
            [self.contentView addSubview:_viewPerson];
        }
        spaceYStart = CGRectGetMaxY(_labelTitle.bounds) + 30 * kScreenScaleHeight;
        CGSize sizeViewPerson = CGSizeMake(100, 20);
        [self setUpViewPerson:_viewPerson insize:&sizeViewPerson];
        [_viewPerson setFrame:CGRectMake(spaceXStart-15, spaceYStart, sizeViewPerson.width, sizeViewPerson.height)];
        
        // 大小
        if(_viewVideoSize == nil)
        {
            _viewVideoSize = [[UIView alloc] init];
            _viewVideoSize.backgroundColor = [UIColor clearColor];
        }
        if([_viewVideoSize isDescendantOfView:self.contentView] == NO)
        {
            [self.contentView addSubview:_viewVideoSize];
        }
        spaceXStart += (SCREEN_WIDTH - spaceXStart - 140 * kScreenScaleWidth) / 2.0;
        spaceYStart = CGRectGetMaxY(_labelTitle.bounds) + 30 * kScreenScaleHeight;
        CGSize sizeViewVideoSize = CGSizeMake(0, 0);
        [self setUpViewVideoSize:_viewVideoSize insize:&sizeViewVideoSize];
        [_viewVideoSize setFrame:CGRectMake(spaceXStart, spaceYStart, sizeViewVideoSize.width, sizeViewVideoSize.height)];
    }
    else
    {
        // 进度
        if(_viewPercent == nil)
        {
            _viewPercent = [[UIView alloc] init];
            _viewPercent.backgroundColor = [UIColor clearColor];
        }
        if([_viewPercent isDescendantOfView:self.contentView] == NO)
        {
            [self.contentView addSubview:_viewPercent];
        }
        spaceXStart = CGRectGetMaxX(_strokeControl.frame) + 10 * kScreenScaleWidth;
        CGSize sizeViewVideoSize = CGSizeMake((SCREEN_WIDTH - spaceXStart - 10 * kScreenScaleWidth), 0);
        [self setUpViewDownLoadPercent:_viewPercent insize:&sizeViewVideoSize];
        [_viewPercent setFrame:CGRectMake(spaceXStart, CGRectGetMaxY(_strokeControl.frame) - sizeViewVideoSize.height,
                                          sizeViewVideoSize.width-(_isSEditing?50:0), sizeViewVideoSize.height)];
    }
    
    // line
    if(_labelLine == nil)
    {
        _labelLine = [[UIView alloc] init];
        [_labelLine setBackgroundColor:kCelleSepCorlor];
    }
    if([_labelLine isDescendantOfView:self.contentView] == NO)
    {
        [self.contentView addSubview:_labelLine];
    }
    [_labelLine setFrame:CGRectMake(0, CGRectGetMaxY(_strokeControl.frame) + 10 * kScreenScaleHeight - kCellLineHeight, SCREEN_WIDTH, kCellLineHeight)];
}

// 选择
- (void)setUpViewSelect
{
    if(_imageViewSelect == nil)
    {
        _imageViewSelect = [[UIImageView alloc] init];
    }
    if([_imageViewSelect isDescendantOfView:self] == NO)
    {
        [self insertSubview:_imageViewSelect belowSubview:self.contentView];
    }
    
    [_imageViewSelect setFrame:CGRectMake((CGRectGetMinX(self.contentView.frame) - 20 )/2.0 + (10 * kScreenScaleWidth)/2.0, (CGRectGetHeight(self.bounds) - 20)/2.0, 20, 20)];
    [_imageViewSelect setHidden:!_isSEditing];
    
    if(_isSelecting == NO)
    {
        [_imageViewSelect setImage:[UIImage imageNamed:@"CellSelect.png"]];
    }
    else if(_isSelecting == YES)
    {
        [_imageViewSelect setImage:[UIImage imageNamed:@"CellSelected.png"]];
    }
}

- (void)setUpViewPerson:(UIView *)viewParent insize:(CGSize *)size
{
    CGFloat subWidth = 0;
    CGFloat subHeight = 0;
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = 0;
    
    // 作者logo
    if(_imageViewPerson == nil)
    {
        _imageViewPerson = [[UIImageView alloc] init];
        [_imageViewPerson setImage:[UIImage imageNamed:@"zy_headImg"]];
    }
    if([_imageViewPerson isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_imageViewPerson];
    }
    [_imageViewPerson setFrame:CGRectMake(0, 0, 11, 11)];
    
    if(subHeight < 11)
    {
        subHeight = 11;
    }
    if(subWidth < 11)
    {
        subWidth = 11;
    }
    
    // 作者
    if(_labelAuthor == nil)
    {
        _labelAuthor = [[UILabel alloc] init];
        [_labelAuthor setTextAlignment:NSTextAlignmentLeft];
        _labelAuthor.font = [UIFont systemFontOfSize:11];
       
    }
    if([_labelAuthor isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_labelAuthor];
    }
    if(@"")
    {
        [_labelAuthor setText:@"1个视频、"];
        spaceXStart += CGRectGetWidth(_imageViewPerson.bounds) + 5 *kScreenScaleWidth;
        CGSize sizeAuther = [_labelAuthor.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
           [_labelAuthor setFrame:CGRectMake(spaceXStart, spaceYStart, sizeAuther.width, sizeAuther.height)];
        if(subHeight < sizeAuther.height)
        {
            subHeight = sizeAuther.height;
        }
        if(subWidth < spaceXStart + sizeAuther.width)
        {
            subWidth = spaceXStart + sizeAuther.width;
        }
    }
    
    // 局中
    CGPoint centerImg = _imageViewPerson.center;
    centerImg.y = subHeight / 2.0;
    [_imageViewPerson setCenter:centerImg];
    
    CGPoint centerLabelAuthor = _labelAuthor.center;
    centerLabelAuthor.y = subHeight / 2.0;
    [_labelAuthor setCenter:centerLabelAuthor];
    
    size -> width = subWidth;
    size -> height = subHeight;
}

- (void)setUpViewVideoSize:(UIView *)viewParent insize:(CGSize *)size
{
    CGFloat subWidth = 0;
    CGFloat subHeight = 0;
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = 0;
    
    // 大小logo
    if(_imageViewVideoSize == nil)
    {
        _imageViewVideoSize = [[UIImageView alloc] init];
        [_imageViewVideoSize setImage:[UIImage imageNamed:@"RAM_Image"]];
    }
    if([_imageViewVideoSize isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_imageViewVideoSize];
    }
    [_imageViewVideoSize setFrame:CGRectMake(0, 0, 11, 11)];
    
    if(subHeight < 11)
    {
        subHeight = 11;
    }
    if(subWidth < 11)
    {
        subWidth = 11;
    }
    
    // 大小
    if(_labelVideoSize == nil)
    {
        _labelVideoSize = [[UILabel alloc] init];
        [_labelVideoSize setBackgroundColor:[UIColor clearColor]];
        [_labelVideoSize setTextAlignment:NSTextAlignmentLeft];
        _labelVideoSize.font = [UIFont systemFontOfSize:11];
//        [_labelVideoSize setFont:Font_XiHei(11)];
//        [_labelVideoSize setTextColor:kColumTextColor];
    }
    if([_labelVideoSize isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_labelVideoSize];
    }
    
    if([_downloadModal stringTotalSize])
    {
    
        NSString *stringTotalSize = [_downloadModal stringTotalSize];
      
        NSString *strTotalSize = [SDTool getFileSizeString:stringTotalSize];
        [_labelVideoSize setText:strTotalSize];
        
        spaceXStart += CGRectGetWidth(_imageViewVideoSize.bounds) + 5 * kScreenScaleWidth;
       CGSize sizeTotal = [strTotalSize sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        
        [_labelVideoSize setFrame:CGRectMake(spaceXStart, spaceYStart, sizeTotal.width, sizeTotal.height)];
        
        if(subHeight < sizeTotal.height)
        {
            subHeight = sizeTotal.height;
        }
        if(subWidth < spaceXStart + sizeTotal.width)
        {
            subWidth = spaceXStart + sizeTotal.width;
        }
    }
    
    // 局中
    CGPoint centerImg = _imageViewVideoSize.center;
    centerImg.y = subHeight / 2.0;
    [_imageViewVideoSize setCenter:centerImg];
    
    CGPoint centerLabelAuthor = _labelVideoSize.center;
    centerLabelAuthor.y = subHeight / 2.0;
    [_labelVideoSize setCenter:centerLabelAuthor];
    
    size -> width = subWidth;
    size -> height = subHeight;
}

- (void)setUpViewDownLoadPercent:(UIView *)viewParent insize:(CGSize *)insize
{
    CGFloat spaceXStart = 0;
    CGFloat spaceYStart = 0;
    CGFloat spaceXEnd = insize -> width;
    
    // 文案
    if(_labelProgressHint == nil)
    {
        _labelProgressHint = [[UILabel alloc] init];
        [_labelProgressHint setBackgroundColor:[UIColor clearColor]];
        [_labelProgressHint setTextAlignment:NSTextAlignmentLeft];
        [_labelProgressHint setFont:[UIFont systemFontOfSize:11]];
    }
    if([_labelProgressHint isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_labelProgressHint];
    }
    
    _labelProgressHint.text = @"";
    if([_downloadModal downloadStatusType] == eDownloadStatusPause)
    {
        _labelProgressHint.text = @"已暂停,点击下载";
    }
    else if([_downloadModal downloadStatusType] == eDownloadStatusWait)
    {
        _labelProgressHint.text = @"等待下载中";
    }
    else if([_downloadModal downloadStatusType] == eDownloadStatusOn)
    {
       
        
        NSString *stringTotalSize = _downloadModal.stringTotalSize;
        
//        NSString *stringTotalSize = [_downloadModal stringTotalSize];
        NSString *strCurSize = [[_downloadModal curloadSize] stringValue];
        _labelProgressHint.text = [NSString stringWithFormat:@"%@/%@",[SDTool getFileSizeString:strCurSize],
                                   [SDTool getFileSizeString: stringTotalSize]];
    }
    else{
        _labelProgressHint.text = @"";
    }
    
    //    CGSize sizeTotal = [_labelProgressHint.text sizeWithFont:Font_XiHei(10)];
    CGSize sizeTotal = [_labelProgressHint.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
    [_labelProgressHint setFrame:CGRectMake(spaceXStart, spaceYStart, 150, sizeTotal.height)];
    
    // 百分比
    if(_labelProgress == nil)
    {
        _labelProgress = [[UILabel alloc] init];
        [_labelProgress setBackgroundColor:[UIColor clearColor]];
        [_labelProgress setTextAlignment:NSTextAlignmentRight];
        [_labelProgress setFont:[UIFont systemFontOfSize:11]];
        [_labelProgress setTextColor:[UIColor lightGrayColor]];
    }
    if([_labelProgress isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_labelProgress];
    }
    
 
    
    NSString *stringTotalSize = _downloadModal.stringTotalSize;
    
//    NSString *stringTotalSize = [_downloadModal stringTotalSize];
    NSString *strCurSize = [[_downloadModal curloadSize] stringValue];
    
    double percent = [strCurSize doubleValue] / [stringTotalSize doubleValue];
    [_labelProgress setText:[NSString stringWithFormat:@"%.2f%@",percent * 100,@"%"]];
    CGSize sizePercent = [_labelProgressHint.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [_labelProgress setFrame:CGRectMake(spaceXEnd - 70-(_isSEditing?50:0), spaceYStart, 70, sizePercent.height)];
    
    spaceYStart += CGRectGetHeight(_labelProgress.frame) + 5;
    
    // 进度条
    if(_progressView == nil)
    {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f];
        _progressView.progressTintColor = kNavBgColor;
    }
    if([_progressView isDescendantOfView:viewParent] == NO)
    {
        [viewParent addSubview:_progressView];
    }
    [_progressView setFrame:CGRectMake(spaceXStart, spaceYStart, insize -> width-(_isSEditing?50:0), 6)];
    [_progressView setProgress:percent];
    
    spaceYStart += CGRectGetHeight(_progressView.frame);
    
    insize -> height = spaceYStart;
}

- (void)setUpViewDownLoadStatus
{
    // 状态按钮
    if(_buttonStatus == nil)
    {
        _buttonStatus = [SUIButton buttonWithType:UIButtonTypeCustom];
        [_buttonStatus setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_buttonStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_buttonStatus titleLabel] setFont:[UIFont systemFontOfSize:11]];
        [_buttonStatus addTarget:self action:@selector(changeDownLoadStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    if([_buttonStatus isDescendantOfView:_strokeControl] == NO)
    {
        [_strokeControl addSubview:_buttonStatus];
    }
    [_buttonStatus setFrame:CGRectMake(0, 0, 70, 20)];
    
    switch ([_downloadModal downloadStatusType]) {
        case eDownloadStatusOn:
            [_buttonStatus setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
            [_buttonStatus setTitle:@"下载中" forState:UIControlStateNormal];
            break;
        case eDownloadStatusPause:
            [_buttonStatus setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
            [_buttonStatus setTitle:@"暂停中" forState:UIControlStateNormal];
            break;
        case eDownloadStatusWait:
            [_buttonStatus setImage:nil forState:UIControlStateNormal];
            [_buttonStatus setTitle:@"等待中" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [_buttonStatus setCenter:CGPointMake(CGRectGetWidth(_strokeControl.bounds) / 2.0, CGRectGetHeight(_strokeControl.bounds) / 2.0)];
}

#pragma delget
- (void)updateDownloadProgress:(DownloadModal *)downloadModal
{
    if(downloadModal == _downloadModal)
    {
        [self uploadProgressView];
    }
}


@end
