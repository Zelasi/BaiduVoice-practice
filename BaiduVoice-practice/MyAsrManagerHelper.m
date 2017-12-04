//
//  MyAsrManagerHelper.m
//  BaiduVoice-practice
//
//  Created by 欧阳昌帅 on 2017/11/16.
//  Copyright © 2017年 0easy. All rights reserved.
//

#import "MyAsrManagerHelper.h"

#import "BDSEventManager.h"
#import "BDSASRDefines.h"
#import "BDSASRParameters.h"

#define kWait_time @300

//第一步：存储唯一示例
static MyAsrManagerHelper *_instance = nil;
//#error "请在官网新建应用，配置包名，并在此填写应用的 api key, secret key, appid(即appcode)"
const NSString *API_KEY = @"O2HtXGWwX7EsnlX9591oXVxX";
const NSString *SECRET_KEY = @"f129a033e071bdf2a622b774a6ef2d96";
const NSString *APP_ID = @"10364414";

@interface MyAsrManagerHelper()<BDSClientASRDelegate>

@property (nonatomic, strong) BDSEventManager *manager;

@end

@implementation MyAsrManagerHelper

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self configureBDVoice];
        
    }
    return self;
    
}

//第2步: 分配内存空间时都会调用这个方法. 保证分配内存alloc时都相同.
+ (id)allocWithZone:(struct _NSZone *)zone  {
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}
//第3步: 保证init初始化时都相同
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[MyAsrManagerHelper alloc] init];
        
    });
    return _instance;
}

//第4步: 保证copy时都相同
- (id)copyWithZone:(NSZone *)zone{
    
    return _instance;
    
}

-(void)configureBDVoice
{
    //创建相关接口对象
    BDSEventManager *manager = [BDSEventManager createEventManagerWithName:BDS_ASR_NAME];
    _manager = manager;
    //设置代理
    [_manager setDelegate:self];
    
    //配置参数
    //1.设置DEBUG_LOG的级别
    [_manager setParameter:@(EVRDebugLogLevelTrace) forKey:BDS_ASR_DEBUG_LOG_LEVEL];
    //2.配置API_KEY 和 SECRET_KEY 和 APP_ID
    [_manager setParameter:@[API_KEY, SECRET_KEY] forKey:BDS_ASR_API_SECRET_KEYS];
    [_manager setParameter:APP_ID forKey:BDS_ASR_OFFLINE_APP_CODE];
    //3.配置端点检测
    
    //第一种检测
    //    NSString *modelVAD_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
    //    NSLog(@"modelVAD_filepath = %@",modelVAD_filepath);
    //    [_manager setParameter:modelVAD_filepath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
    //    [_manager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
    
    //第二种检测
//    NSString *mfe_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_dnn" ofType:@"dat"];
//    //设置MFE模型文件
//    [_manager setParameter:mfe_dnn_filepath forKey:BDS_ASR_MFE_DNN_DAT_FILE];
//    NSString *cmvn_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_cmvn" ofType:@"dat"];
//    //设置MFE CMVN文件路径
//    [_manager setParameter:cmvn_dnn_filepath forKey:BDS_ASR_MFE_CMVN_DAT_FILE];
//    
//    [_manager setParameter:kWait_time forKey:BDS_ASR_MFE_MAX_SPEECH_PAUSE];
//    [_manager setParameter:kWait_time forKey:BDS_ASR_MFE_MAX_WAIT_DURATION];
    
    //4.开启语义理解
    [_manager setParameter:@(YES) forKey:BDS_ASR_ENABLE_NLU];
    [_manager setParameter:@"15361" forKey:BDS_ASR_PRODUCT_ID];
    
    //长按设置
    [_manager setParameter:@(YES) forKey:BDS_ASR_VAD_ENABLE_LONG_PRESS];
    [_manager setParameter:@(NO) forKey:BDS_ASR_ENABLE_LONG_SPEECH];
    [_manager setParameter:@(NO) forKey:BDS_ASR_NEED_CACHE_AUDIO];
    [_manager setParameter:@"" forKey:BDS_ASR_OFFLINE_ENGINE_TRIGGERED_WAKEUP_WORD];
    
    [_manager setParameter:nil forKey:BDS_ASR_AUDIO_FILE_PATH];
    [_manager setParameter:nil forKey:BDS_ASR_AUDIO_INPUT_STREAM];
    
    //    self.isStartRecord = YES;
    
}

-(void)VoiceRecognitionClientWorkStatus:(int)workStatus obj:(id)aObj
{
    switch (workStatus) {
        case EVoiceRecognitionClientWorkStatusNewRecordData: {
            NSLog(@"EVoiceRecognitionClientWorkStatusNewRecordData");
            break;
        }
            
        case EVoiceRecognitionClientWorkStatusStartWorkIng: {
            NSLog(@"EVoiceRecognitionClientWorkStatusStartWorkIng");
            break;
        }
        case EVoiceRecognitionClientWorkStatusStart: {
            NSLog(@"EVoiceRecognitionClientWorkStatusStart");
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: {
            NSLog(@"EVoiceRecognitionClientWorkStatusEnd");
            break;
        }
        case EVoiceRecognitionClientWorkStatusFlushData: {
            NSLog(@"EVoiceRecognitionClientWorkStatusFlushData");
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: {
            NSLog(@"EVoiceRecognitionClientWorkStatusFinish");
            
            NSLog(@"aObj = %@",aObj);
            
            NSArray *contentArr = aObj[@"results_recognition"];
            NSString *contentStr = contentArr[0];
            
            NSLog(@"contentStr = %@",contentStr);
            if (self.asrBlock) {
                self.asrBlock(contentStr);
            }
            break;
        }
        case EVoiceRecognitionClientWorkStatusMeterLevel: {
            NSLog(@"EVoiceRecognitionClientWorkStatusMeterLevel");
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel: {
            NSLog(@"EVoiceRecognitionClientWorkStatusCancel");
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: {
            NSLog(@"EVoiceRecognitionClientWorkStatusError");
            break;
        }
        case EVoiceRecognitionClientWorkStatusLoaded: {
            NSLog(@"EVoiceRecognitionClientWorkStatusLoaded");
            break;
        }
        case EVoiceRecognitionClientWorkStatusUnLoaded: {
            NSLog(@"EVoiceRecognitionClientWorkStatusUnLoaded");
            break;
        }
        case EVoiceRecognitionClientWorkStatusChunkThirdData: {
            NSLog(@"EVoiceRecognitionClientWorkStatusChunkThirdData");
            break;
        }
        case EVoiceRecognitionClientWorkStatusChunkNlu: {
            NSLog(@"EVoiceRecognitionClientWorkStatusChunkNlu");
            break;
        }
        case EVoiceRecognitionClientWorkStatusChunkEnd: {
            NSLog(@"EVoiceRecognitionClientWorkStatusChunkEnd");
            break;
        }
        case EVoiceRecognitionClientWorkStatusFeedback: {
            NSLog(@"EVoiceRecognitionClientWorkStatusFeedback");
            break;
        }
        case EVoiceRecognitionClientWorkStatusRecorderEnd: {
            NSLog(@"EVoiceRecognitionClientWorkStatusRecorderEnd");
            break;
        }
        case EVoiceRecognitionClientWorkStatusLongSpeechEnd: {
            NSLog(@"EVoiceRecognitionClientWorkStatusLongSpeechEnd");
            break;
        }
        default:
            break;
    }
}

- (void)start{
    
    [_manager sendCommand:BDS_ASR_CMD_START];
    
}

- (void)stop{
    
    [_manager sendCommand:BDS_ASR_CMD_STOP];
    
}

- (void)setAutoStop:(BOOL)autoStop{
    
    _autoStop = autoStop;
    
    if (_autoStop) {
        
        NSString *mfe_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_dnn" ofType:@"dat"];
        //设置MFE模型文件
        [_manager setParameter:mfe_dnn_filepath forKey:BDS_ASR_MFE_DNN_DAT_FILE];
        NSString *cmvn_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_cmvn" ofType:@"dat"];
        //设置MFE CMVN文件路径
        [_manager setParameter:cmvn_dnn_filepath forKey:BDS_ASR_MFE_CMVN_DAT_FILE];
        
        [_manager setParameter:kWait_time forKey:BDS_ASR_MFE_MAX_SPEECH_PAUSE];
        [_manager setParameter:kWait_time forKey:BDS_ASR_MFE_MAX_WAIT_DURATION];
        
    }else{
        
        NSString *modelVAD_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
        NSLog(@"modelVAD_filepath = %@",modelVAD_filepath);
        [_manager setParameter:modelVAD_filepath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
        [_manager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
        
    }
    
}

@end
