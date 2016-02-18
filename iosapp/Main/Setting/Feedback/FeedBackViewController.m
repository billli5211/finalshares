//
//  FeedBackViewController.m
//  iosapp
//
//  Created by 李萍 on 16/1/11.
//  Copyright © 2016年 oschina. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Utils.h"
#import "Config.h"
#import "OSCAPI.h"
#import "AppDelegate.h"

#import <AFNetworking.h>
#import <AFOnoResponseSerializer.h>
#import <Ono.h>
#import <ReactiveCocoa.h>
#import <MBProgressHUD.h>

@interface FeedBackViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *stringType;
@property (nonatomic, strong) UIImage *image;

@end

@implementation FeedBackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(sendFeedback)];
    
    [self setLayout];
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [_feedbackTextView.rac_textSignal map:^(NSString *feedback) {
        return @(feedback.length > 0);
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor themeColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    _stringType = @"程序错误";
    
    self.printscrenImagView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeprintscreen)];
    [self.printscrenImagView addGestureRecognizer:tap1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}

- (void)setLayout
{
    _feedbackTextView.placeholder = @"请提出您的意见与建议";
    _feedbackTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_feedbackTextView];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        _feedbackTextView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
        _feedbackTextView.textColor = [UIColor titleColor];
    }
}

#pragma mark - 选择意见类型

- (IBAction)selectedFeedBackType:(UIButton *)sender {
    if (sender.tag == 1) {
        [_programErrorView setImage:[UIImage imageNamed:@"feedback_selected"] forState:UIControlStateNormal];
        [_recommentFunctionView setImage:[UIImage imageNamed:@"feedback_unSelected"] forState:UIControlStateNormal];
        _stringType = @"程序错误";
    } else if (sender.tag == 2) {
        [_programErrorView setImage:[UIImage imageNamed:@"feedback_unSelected"] forState:UIControlStateNormal];
        [_recommentFunctionView setImage:[UIImage imageNamed:@"feedback_selected"] forState:UIControlStateNormal];
        _stringType = @"功能建议";
    }
}

#pragma mark - 选择截图
- (void)takeprintscreen
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择图片"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"相机", @"相册", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Device has no camera"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        
    } else {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^ {
        _printscrenImagView.image = _image;
    }];
}

#pragma mark - 隐藏软键盘
- (void)HideKeyBoard
{
    [_feedbackTextView resignFirstResponder];
}

#pragma mark - 发送反馈信息

- (void)sendFeedback
{
    _HUD = [Utils createHUD];
    _HUD.labelText = @"正在发送反馈";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", OSCAPI_PREFIX, OSCAPI_MESSAGE_PUB]
       parameters:@{
                    @"uid"      : @([Config getOwnID]),
                    @"receiver" : @(2609904),
                    @"content"  : [NSString stringWithFormat:@"[iOS-主站-%@]\n%@", _stringType, _feedbackTextView.text]
                    }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:[Utils compressImage:_image]
                                name:@"file"
                            fileName:@"img.jpg"
                            mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [_HUD hide:YES];
            MBProgressHUD *HUD = [Utils createHUD];
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.labelText = @"发送成功，感谢您的反馈";
            [HUD hide:YES afterDelay:2];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            _HUD.mode = MBProgressHUDModeCustomView;
            _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _HUD.labelText = @"网络异常，发送失败";
            [_HUD hide:YES afterDelay:1.0];
        }];
    
}


@end
