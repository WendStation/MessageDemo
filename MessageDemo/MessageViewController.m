//
//  MessageViewController.m
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "messageCellFrame.h"
#import "MessageCell.h"
#import "KeyboardView.h"
#import "Header.h"
#import "MJRefresh/MJRefresh.h"
#import "Function.h"

#define KeyBoardHeight 40

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,KeyboardViewDelegate,MessageCellDelegate,UITextViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) KeyboardView *keyBordView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *newDataArray;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *oldTime;
@property (nonatomic,assign) CGFloat previousTextViewContentHeight;
@property (nonatomic,assign) CGFloat normalTextViewContentHeight;
@property (nonatomic,strong) NSString *content;

@end

static NSString *const cellIdentifier = @"message";

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyBordView];
    
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:cellIdentifier];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initWithData];
    self.dataArray = self.newDataArray;
    [self tableViewScrollCurrentIndexPath: self.dataArray.count animated:YES];
}

/**
 *  初始化新数据，在这里是上拉刷新时候，产生的新的数据，改这里产生数据源
 */
- (void)initWithData
{
    //这句话主要是在算第一个的时候能显示时间
    self.oldTime = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    self.newDataArray = [NSMutableArray arrayWithCapacity:data.count];
    for(NSDictionary *dict in data){
        MessageCellFrame *cellFrame = [[MessageCellFrame alloc]init];
        MessageModel *model = [MessageModel modelWithDict:dict];
        NSString *time = [Function compareTimeWithOldTime:self.oldTime NewTime:model.message[@"time"]];
        //必须要有
        cellFrame.oldTime = self.oldTime;
        if (time) {
            cellFrame.isTimeShow = YES;
            cellFrame.CurrentTimeStr = time;
        }else
        {
            cellFrame.isTimeShow = NO;
        }
        self.oldTime = model.message[@"time"];
         cellFrame.model = model;
        
        [self.newDataArray addObject:cellFrame];
    }
    
}
/**
 *  把新数据插入现在的数据里，不用做修改
 */
-(void)insertNewDataToCurrentData
{
    NSEnumerator *enumertor = [self.newDataArray reverseObjectEnumerator];
    for (MessageCellFrame* cellFrame in enumertor) {
        [self.dataArray insertObject:cellFrame atIndex:0];
    }
}
#pragma mark - 键盘的监听
- (void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-40-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:236.0 green:235.0 blue:243.0 alpha:1.0];
        [_tableView registerClass:[MessageCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_bg_default"]];
        
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        //下拉
//        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
 
        
    }
    return _tableView;
}
-(KeyboardView *)keyBordView
{
    if (_keyBordView == nil) {
        _keyBordView = [[KeyboardView alloc]initWithFrame:CGRectMake(0, ScreenHeight-KeyBoardHeight, ScreenWidth, KeyBoardHeight)];
        _keyBordView.delegate = self;
       
    }
    return _keyBordView;
}
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
        
    }
    return _dataArray;
}
- (NSMutableArray *)newDataArray
{
    if (_newDataArray == nil) {
        _newDataArray = [[NSMutableArray alloc]init];
    }
    return _newDataArray;
}
- (NSString *)oldTime
{
    if (_oldTime == nil) {
        _oldTime = @"0";
    }
    return _oldTime;
    
}

#pragma mark - 上拉刷新下拉加载
//下拉加载数据
-(void)downRefresh
{
    //初始化新数据
    [self initWithData];
    //把新输入插入到旧数据
    [self insertNewDataToCurrentData];
    //原理是从服务器拉数据,
    [self.tableView.header endRefreshing];
    [self.tableView reloadData];
    
    [self tableViewScrollCurrentIndexPath:self.newDataArray.count+1 animated:NO];
    
    
}
- (void)upRefresh
{
    
}


#pragma mark - tableVIew代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.cellFrame = self.dataArray[indexPath.row];
    return cell;
}
-(BOOL)compareTimeOld:(NSString *)oldTime newTime:(NSString *)newTime
{
    if ([newTime intValue]-[oldTime intValue]>5*60*60) {
        return YES;
    }
    return NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataArray[indexPath.row] cellHeight] ;
}

#pragma mark - cell的代理
//cell的代理，即点击内容播放声音
- (void)MessageCell:(MessageCell *)messageCell tapContent:(NSString *)content
{
    NSLog(@"%s",__func__);
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - scroolView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 开始、结束记录声音协议
- (void)beginRecord
{
    NSLog(@"%s",__func__);
}

- (void)stopRecord
{
    NSLog(@"结束录音....");
    NSLog(@"%s",__func__);
}

#pragma mark - keyboardView代理

//sendButton的代理
- (void)sendMessage
{
    self.content = [self.keyBordView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![self.content isEqualToString:@""]) {
        [self sendMessage:self.keyBordView.textView];
    }
    else
    {
        self.keyBordView.textView.text=@"";
        NSLog(@"您输入的是空格");
    }
    [self KeyboardVIew:self.keyBordView textViewHeightChange:self.keyBordView.textView];

}
- (void)KeyboardVIew:(KeyboardView *)keyboardView textFileBegin:(UITextField *)textField
{
    [self tableViewScrollCurrentIndexPath:self.dataArray.count animated:YES];
}
- (void)tableViewScrollCurrentIndexPath:(NSInteger)dataArrayIndex animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataArrayIndex-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

-(void)sendMessage:(UITextView *)textView
{
    MessageCellFrame *cellFrame = [[MessageCellFrame alloc] init];
    

    //生成自己的model
    NSDate* date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSDate* newdate = [[NSDate alloc]initWithTimeIntervalSinceNow:60*5];
    NSTimeInterval newtime = [newdate timeIntervalSince1970];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",self.content,@"content",[NSString stringWithFormat:@"%f",time],@"time", nil];
    NSString *avatar = @"http://img5.imgtn.bdimg.com/it/u=3494656842,1664655621&fm=21&gp=0.jpg";
    NSDictionary *dict = @{@"messageId":@"2321",@"from":@"11450",@"groupId":@"226",@"to":@"0",@"message":message,@"creationTime":@"2015-12-10 14:44:04",@"name":@"老王",@"avatar":avatar};
    NSLog(@"current time %lf",time);
    NSLog(@"5分钟之后时间 %lf",newtime);
    MessageModel *model = [MessageModel modelWithDict:dict];
    cellFrame.isErrorImageShow = YES;
    cellFrame.isIndeicatorShow = YES;
    
    cellFrame.model = model;
    
    [self.dataArray addObject:cellFrame];
    [self.tableView reloadData];
    
    textView.text = @"";
    
    //滚动到当前行
    [self tableViewScrollCurrentIndexPath:self.dataArray.count animated:YES];

}

- (BOOL)KeyboardVIew:(KeyboardView *)keyboardView sendMessage:(UITextView *)textView currentMessage:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        self.content = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![self.content isEqualToString:@""]) {
            [self sendMessage:textView];
        }
        else
        {
            //如果输入的是空格可以进一步处理
            textView.text = @"";
            NSLog(@"您输入的是空格");
        }
        //恢复原始状态
        [self KeyboardVIew:keyboardView textViewDidChang:textView];
        return NO;
    }
    return YES;
}

-(void)KeyboardVIew:(KeyboardView *)keyboardView textViewBegin:(UITextView *)textView
{
    [textView becomeFirstResponder];

    if(!self.previousTextViewContentHeight)
    {
        CGFloat maxHeight = [self.keyBordView maxHeight];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
        CGFloat textViewContentHeight = size.height;
        self.previousTextViewContentHeight = textViewContentHeight;
    }
    [self tableViewScrollCurrentIndexPath:self.dataArray.count animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
//改变textView的高度
-(void)KeyboardVIew:(KeyboardView *)keyboardView textViewHeightChange:(UITextView *)textView
{
    [self tableViewScrollCurrentIndexPath:self.dataArray.count animated:YES];
    textView.text = @"";
    if(!self.previousTextViewContentHeight)
    {
        CGFloat maxHeight = [self.keyBordView maxHeight];
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
        CGFloat textViewContentHeight = size.height;
        self.previousTextViewContentHeight = textViewContentHeight;
    }
    [self KeyboardVIew:keyboardView textViewDidChang:textView];

}

-(void)KeyboardVIew:(KeyboardView *)keyboardView textViewDidChang:(UITextView *)textView
{
    
    CGFloat maxHeight = [self.keyBordView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //改变控件的位置
        [self ChangeHeight:changeInHeight isShrinking:isShrinking];
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}

-(void)ChangeHeight:(CGFloat)changeInHeight isShrinking:(BOOL)isShrinking
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,0.0f,self.tableView.contentInset.bottom + changeInHeight, 0.0f);
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                         [self tableViewScrollCurrentIndexPath:self.dataArray.count animated:YES];
                         
                         if(isShrinking) {
                             [self.keyBordView adjustTextViewHeightBy:changeInHeight];
                         }
                         CGRect inputViewFrame = self.keyBordView.frame;
                         self.keyBordView.frame = CGRectMake(0.0f,inputViewFrame.origin.y - changeInHeight,inputViewFrame.size.width,inputViewFrame.size.height + changeInHeight);
                         self.keyBordView.backImageView.frame = self.keyBordView.bounds;
                         
                         if(!isShrinking) {
                             [self.keyBordView adjustTextViewHeightBy:changeInHeight];
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
