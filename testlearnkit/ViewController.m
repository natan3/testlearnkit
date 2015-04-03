//
//  ViewController.m
//  testlearnkit
//
//  Created by master on 2014/11/21.
//  Copyright (c) 2014年 naomi. All rights reserved.
//

#import "ViewController.h"
#import "IRKit/IRHTTPClient.h"
#import "IRKit/IRKit.h"
#import "DetailViewController.h"

@interface ViewController () <IRNewPeripheralViewControllerDelegate> {
    IRSignals *_signals;
    NSMutableDictionary *_isSignal;
    UILabel *_label;
    NSInteger ondo;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setState];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"リモコン一覧";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"編集" style:UIBarButtonItemStylePlain target:self action:@selector(kirikae:)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    for(int i = 0; i < 9; i++){  // ボタンにする画像を生成する
        UIButton *btn = [[UIButton alloc] init];
        if(i == 0){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/onswitch.png"];
            btn.frame = CGRectMake(20, 80, 130, 130);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if (i == 1){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/offswitch.png"];
            btn.frame = CGRectMake(170, 80, 60, 60);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 2){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/change.png"];
            btn.frame = CGRectMake(170, 150, 60, 60);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }else if(i == 3){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/up.png"];
            btn.frame = CGRectMake(240, 80, 60, 60);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 4){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/down.png"];
            btn.frame = CGRectMake(240, 150, 60, 60);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 5){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/zentou.png"];
            btn.frame = CGRectMake(15, 300, 65, 65);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 6){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/choukou.png"];
            btn.frame = CGRectMake(90, 300, 65, 65);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 7){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/mamekyu.png"];
            btn.frame = CGRectMake(165, 300, 65, 65);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        else if(i == 8){
            UIImage *img = [UIImage imageNamed:@"/Users/naomi/Desktop/codes/layout/layout/icons/lightoff.png"];
            btn.frame = CGRectMake(240, 300, 65, 65);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
        }
        
        // ボタンが押された時にhogeメソッドを呼び出す
        [btn addTarget:self action:@selector(addingItem:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btn.layer.borderWidth = 2.0f;
        //枠線の色
        btn.layer.borderColor = [[UIColor grayColor] CGColor];
        //角丸
        btn.layer.cornerRadius = 10.0f;
        
        [self.view addSubview:btn];
    }
    
    for(int i = 10; i < 14; i++){
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(30 + (i - 10)*70, 230, 300, 50);
        _label.tag = i;
        if(i == 10){
            _label.text = @"エアコン";
        }else if(i == 11){
            _label.text = @"暖房";
        }else if(i == 12){
            NSString *str = [NSString stringWithFormat:@"%ld C", ondo];
            _label.text = str;
        }else if(i == 13){
            _label.text = @"OFF";
        }
        [self.view addSubview:_label];
    }
    
    
//    _isSignal = [[NSMutableDictionary alloc] init];
//    
//    [self loadIsSignal];
//    NSLog(@"%@", _isSignal);
//    // Do any additional setup after loading the view, typically from a nib.
//    [_signals loadFromStandardUserDefaultsKey:@"irkit.signals"];
//    NSLog(@"%@", _signals);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//画面ロード
-(void)viewWillAppear:(BOOL)animated{
    if ([IRKit sharedInstance].countOfReadyPeripherals == 0) {
        IRNewPeripheralViewController *vc = [[IRNewPeripheralViewController alloc] init];
        vc.delegate = self;
        [self presentViewController:vc
                           animated:YES
                         completion:^{
                             NSLog(@"presented");
                         }];
    }else{
        _isSignal = [[NSMutableDictionary alloc] init];
        [self loadIsSignal];
        NSLog(@"%@", _isSignal);
        
        // Do any additional setup after loading the view, typically from a nib.
        _signals = [[IRSignals alloc]init];
        [_signals loadFromStandardUserDefaultsKey:@"irkit.signals"];
        NSLog(@"%@", _signals);
        
        if(self.editing){
            self.title = @"リモコン一覧";
            self.navigationItem.leftBarButtonItem.title = @"編集";
            self.editing = 0;
        }
    }
}

-(void)kirikae:(UIBarButtonItem*)b{
    if(!self.editing){
        self.title = @"編集中";
        b.title = @"完了";
        self.editing = 1;
    }
    else{
        self.title = @"リモコン一覧";
        b.title = @"編集";
        self.editing = 0;
    }
}


#pragma mark - IRNewPeripheralViewControllerDelegate

- (void)newPeripheralViewController:(IRNewPeripheralViewController *)viewController
            didFinishWithPeripheral:(IRPeripheral *)peripheral {
    NSLog( @"peripheral: %@", peripheral );
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@"dismissed");
                             }];
}

-(void)addingItem:(UIBarButtonItem*)b{
    NSString *tmp = [[NSString alloc] initWithFormat:@"%ld", b.tag];
    if(self.editing){
        DetailViewController* detailViewController = [DetailViewController new];
        //delegateをクリアする
        //clear delegate
        self.navigationController.delegate = nil;
        //push it.
        [self.navigationController pushViewController:detailViewController animated:YES];
        detailViewController.signalid = b.tag;
    }else{
        if([_isSignal objectForKey:tmp]){
            NSInteger signum = [[_isSignal objectForKey:tmp] intValue];
            if([_signals objectInSignalsAtIndex:signum] != nil){
                NSLog(@"ThereIsThisSignal%ld", b.tag);
                [[_signals objectInSignalsAtIndex:signum] sendWithCompletion:^(NSError *error) {
                    NSLog(@"sent error: %@", error);
                }];
            }
        }else{
            NSLog(@"unRegistered%ld", b.tag);
        }
        //ONbutton tapped
        if(b.tag == 0){
            UILabel* tempLabel = (UILabel*)[self.view viewWithTag:13];
            tempLabel.text = @"ON";
        }
        //OFFbutton tapped
        if(b.tag == 1){
            UILabel* tempLabel = (UILabel*)[self.view viewWithTag:13];
            tempLabel.text = @"OFF";
        }
        if(b.tag == 3){
            ondo += 1;
            UILabel* tempLabel = (UILabel*)[self.view viewWithTag:12];
            NSString *str = [NSString stringWithFormat:@"%ld C", ondo];
            tempLabel.text = str;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
            [ud setInteger:ondo forKey:@"ondo"];
            [ud synchronize];
        }
        if(b.tag == 4){
            ondo -= 1;
            UILabel* tempLabel = (UILabel*)[self.view viewWithTag:12];
            NSString *str = [NSString stringWithFormat:@"%ld C", ondo];
            tempLabel.text = str;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
            [ud setInteger:ondo forKey:@"ondo"];
            [ud synchronize];
        }
    }
    
}


//リモコン機能


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) { // 現在編集モードです。
    }
}

- (void)newSignalViewController:(IRNewSignalViewController *)viewController
            didFinishWithSignal:(IRSignal *)signal {
    NSLog( @"signal: %@", signal );

//    [self dismissViewControllerAnimated:YES
//                             completion:^{
//                                 NSLog(@"dismissed");
//                             }];
    
    _signals = [[IRSignals alloc] init];
}

-(NSMutableDictionary *)loadIsSignal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"theKey"];
    _isSignal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return _isSignal;
}

-(void)saveIsSignal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_isSignal];
    [defaults setObject:data forKey:@"theKey"];
}

-(void)setState{
    //    NSUserDefaults *state = [NSUserDefaults standardUserDefaults];  // 取得
    //    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    //    [defaults setObject:@"暖房" forKey:@"danbo"];
    //    [defaults setObject:@"24" forKey:@"ondo"];
    //    [defaults setObject:@"ON" forKey:@"ison"];
    //    [state registerDefaults:defaults];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    ondo = [ud integerForKey:@"ondo"];  // KEY_Iの内容をint型として取得;
}

@end
