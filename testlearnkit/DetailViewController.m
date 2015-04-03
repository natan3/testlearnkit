//
//  DetailViewController.m
//  testlearnkit
//
//  Created by master on 2014/11/21.
//  Copyright (c) 2014年 naomi. All rights reserved.
//

#import "DetailViewController.h"
#import "IRKit/IRHTTPClient.h"
#import "IRKit/IRKit.h"


//#import "WZSignalLog.h"
#import <TMCache/TMCache.h>

@interface DetailViewController (){
    IRHTTPClient *_httpClient;
    IRSignals *_signals;
    NSMutableDictionary *_isSignal;
    
    UIPickerView *picker;
    UIButton *kanryo;
    UILabel *timeset;
    UIButton *gakusyu;
}

@end

@implementation DetailViewController
@synthesize signalid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _isSignal = [[NSMutableDictionary alloc] init];
    _signals = [[IRSignals alloc] init];
    [_signals loadFromStandardUserDefaultsKey:@"irkit.signals"];
    NSLog(@"%@", _signals);
    [self loadIsSignal];
//    [self startCapturing];
    
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(270, 100);
    sw.on = NO;
    // 値が変更された時にhogeメソッドを呼び出す
    [sw addTarget:self action:@selector(hoge:)
 forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.font = [UIFont fontWithName:@"AppleGothic" size:15];
    label.frame = CGRectMake(30, 50, 300, 100);
    label.text = @"家から500mの地点で\nスイッチを入れる";
    
    [self.view addSubview:label];
    
    UISwitch *sw1 = [[UISwitch alloc] init];
    sw1.center = CGPointMake(270, 160);
    sw1.on = NO;
    [sw1 addTarget:self action:@selector(showPicker:)
  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw1];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 2;
    label1.font = [UIFont fontWithName:@"AppleGothic" size:15];
    label1.frame = CGRectMake(30, 115, 300, 100);
    label1.text = @"毎朝時間指定で\nスイッチが入るようにする";
    
    [self.view addSubview:label1];
    
    
    gakusyu = [[UIButton alloc] init];
    gakusyu.backgroundColor = [UIColor colorWithRed:0.26 green:0.82 blue:0.32 alpha:1.0];
    gakusyu.layer.cornerRadius = 3.0f;
    gakusyu.frame = CGRectMake(50, 230, 200, 30);
    [gakusyu setTitle:@"信号を学習する" forState:UIControlStateNormal];
    [gakusyu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [gakusyu addTarget:self action:@selector(pressedGakusyu:)
     forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:gakusyu];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCapturing
{
    NSLog(@"startcapturing!!!!");
    if ([IRKit sharedInstance].countOfReadyPeripherals == 0) {
        NSLog(@"dame");
        return;
    }
    NSLog(@"startcapturing!");
    [gakusyu setTitle:@"信号を探しています" forState:UIControlStateNormal];
    
    __weak DetailViewController *me = self;
    if (!_httpClient) {
        _httpClient = [IRHTTPClient waitForSignalWithCompletion:^(NSHTTPURLResponse *res, IRSignal *signal, NSError *error) {
            if (signal) {
                [me didReceiveSignal:signal];
            }
        }];
    }
}


- (void)didReceiveSignal:(IRSignal *)signal
{
    
    NSLog( @"signal: %@", signal );
    //    NSData *data = [signal data];
    
    [_signals addSignalsObject:signal];
    [_signals saveToStandardUserDefaultsWithKey:@"irkit.signals"];
    
    //ボタンの番号
    NSString *st=[[NSString alloc] initWithFormat:@"%ld",signalid];
    //配列の長さ
    NSString *hoge = [[NSString alloc] initWithFormat:@"%ld", [_signals countOfSignals] - 1];
    //辞書に詰める
    [_isSignal setObject:hoge forKey:st];
    [self saveIsSignal];
    NSLog(@"%@", _isSignal);
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"リモコン登録";
    alert.message = @"完了しました";
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
    [gakusyu setTitle:@"信号を学習する" forState:UIControlStateNormal];
    
    _httpClient = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)hoge:(id)sender
{
    UISwitch *sw = sender;
    if (sw.on) {
        NSLog(@"スイッチがONになりました．");
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"エアコンオン";
        alert.message = @"家に近づいたらエアコンがオンになります。";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    } else {
        NSLog(@"スイッチがOFFになりました．");
    }
}

-(void)saveIsSignal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_isSignal];
    [defaults setObject:data forKey:@"theKey"];
}

-(NSMutableDictionary *)loadIsSignal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"theKey"];
    _isSignal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return _isSignal;
}

//picker表示
- (void)showPicker:(id)sender
{
    UISwitch *sw = sender;
    if (sw.on) {
        picker = [[UIPickerView alloc]init];
        picker.delegate = self;
        picker.dataSource = self;
        picker.showsSelectionIndicator = YES;
        picker.frame = CGRectMake(0, 300, 360, 180);
        [picker selectRow:2 inComponent:0 animated:NO];
        [picker selectRow:2 inComponent:1 animated:NO];
        [self.view addSubview:picker];
        
        kanryo = [[UIButton alloc] init];
        kanryo.backgroundColor = [UIColor colorWithRed:0.26 green:0.82 blue:0.32 alpha:1.0];
        kanryo.layer.cornerRadius = 3.0f;
        kanryo.frame = CGRectMake(250, 280, 50, 30);
        [kanryo setTitle:@"完了" forState:UIControlStateNormal];
        [kanryo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [kanryo addTarget:self action:@selector(removePicker:)
         forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:kanryo];
        
    } else {
        if(picker){
            [picker removeFromSuperview];
            [kanryo removeFromSuperview];
        }
        if(timeset){
            [timeset removeFromSuperview];
        }
    }
}

//完了ボタンが押されたとき
-(void)removePicker:(UIButton *)b{
    if(timeset){
        [timeset removeFromSuperview];
    }
    
    NSInteger val0 = [picker selectedRowInComponent:0];
    NSInteger val1 = [picker selectedRowInComponent:1];
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"毎朝設定";
    NSString *setteiTime = [NSString stringWithFormat:@"%ld時%ld分に設定されました", val0, val1*15];
    alert.message = setteiTime;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
    timeset = [[UILabel alloc] init];
    timeset.numberOfLines = 2;
    timeset.font = [UIFont fontWithName:@"AppleGothic" size:15];
    timeset.frame = CGRectMake(30, 150, 300, 100);
    setteiTime = [NSString stringWithFormat:@"%ld時%ld分に設定されています", val0, val1*15];
    timeset.text = setteiTime;
    
    [self.view addSubview:timeset];
    
    [picker removeFromSuperview];
    [b removeFromSuperview];
}

-(void)pressedGakusyu:(UIButton *)b{
    [self startCapturing];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

/**
 * ピッカーに表示する行数を返す
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 24;
            break;
            
        case 1: // 2列目
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

/**
 * 行のサイズを変更
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 100.0;
            break;
            
        case 1: // 2列目
            return 150.0;
            break;
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーに表示する値を返す
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%ld　時", row];
            break;
            
        case 1: // 2列目
            return [NSString stringWithFormat:@"%ld　分", row * 15];
            break;
        default:
            return 0;
            break;
    }
}


@end
