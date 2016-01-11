//
//  PicturePreviewVC.m
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "PicturePreviewVC.h"

@interface PicturePreviewVC ()<UIScrollViewDelegate>
{

    IBOutlet UIScrollView   *_scrollView;

    IBOutlet UILabel        *numberLabelText;
    
    IBOutlet UILabel        *_imageTitleLabel;
    
    IBOutlet UITextView     *_imageContentLabel;
    
    
    NSArray                 *_imageArray;
    NSInteger               _initSelectedIndex;
    
}

@end

@implementation PicturePreviewVC


- (void)dealloc
{
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(numberLabelText);
    RELEASE_SAFELY(_imageArray);
    RELEASE_SAFELY(_imageTitleLabel);
    RELEASE_SAFELY(_imageContentLabel);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(numberLabelText);
    RELEASE_SAFELY(_imageArray);
    RELEASE_SAFELY(_imageTitleLabel);
    RELEASE_SAFELY(_imageContentLabel);
    [super viewDidUnload];
}

-(void) loadColorConfig
{
    _imageTitleLabel.textColor = ColorForHexKey(AppColor_Label_Text);
    _imageContentLabel.textColor = ColorForHexKey(AppColor_Label_Text);
    numberLabelText.textColor = ColorForHexKey(AppColor_Label_Text);
}

-(id)initWithImageModelArray:(NSArray *)imageModelArray selectedIndex:(NSInteger)index
{
    if (self = [super init])
    {
        _imageArray = imageModelArray;
        
        _initSelectedIndex = index;
    }

    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:[AppColorHelper preferredStatusBarStyle]];
}


-(void)configViewController
{
    [super configViewController];
    
    self.navigationController.navigationBar.hidden = YES;
    
    float imageHeight = 0;
    
    if(iPhone5)
        imageHeight=(_scrollView.height / 2.0);
    else
        imageHeight = (_scrollView.height -150) / 2.0;
    
    
    float y = (_scrollView.height - imageHeight) / 2.0;

    for (int i = 0; i<_imageArray.count ; i++)
    {
        ImageModel *imageModel = _imageArray[i];
        WebImageView *imageView = [[WebImageView alloc] initWithFrame: CGRectMake(_scrollView.width * i,0,_scrollView.width,imageHeight)];
        imageView.top =  y;
        [imageView setImageWithUrlString:imageModel.image_big placeholderImage:KBigPlaceHodlerImage];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.tag = i;
        [_scrollView addSubview:imageView];
    }
    [_scrollView setContentSize:CGSizeMake(_imageArray.count *320, 0)];
    _scrollView.delegate = self;

    [_scrollView setContentOffset:CGPointMake(_initSelectedIndex * 320, 0)];

    [self refreshData];
}


-(void) refreshData
{
    CGPoint offset = _scrollView.contentOffset;
    int x=offset.x;
    
    int pageIndex = (x/320);
    
    ImageModel *imageModel = _imageArray[pageIndex];
    _imageTitleLabel.text = imageModel.image_title;
    _imageContentLabel.text = imageModel.image_desc;
    numberLabelText.text=[NSString stringWithFormat:@"%d/%d",pageIndex+1, (int)_imageArray.count];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshData];
}

-(Boolean)isCustomNavigationBar
{
    return NO;
}


- (IBAction)backAction:(id)sender
{
    [self actionClickNavigationBarLeftButton];
}

@end
