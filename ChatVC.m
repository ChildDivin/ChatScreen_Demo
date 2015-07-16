//
//  ChatVC.m
//  Setup
//
//  Created by TopsTech on 02/02/2015.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "ChatVC.h"
#import "ChatShare.h"
#import "CustomChatCell.h"

#define k_OriginX 20
#define k_MessageWidth 230

@implementation ChatVC

#pragma mark -
#pragma mark View Life Cycle Start Method
- (void)viewDidLoad {
    [super viewDidLoad];

    arrShare = [[NSMutableArray alloc] init];
    
    tblChat.tableHeaderView = viewTableHeader;
    
    txtViewMessage.font = CustomFontBookWithSize(16);
    txtViewMessage = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    txtViewMessage.placeholderColor = [UIColor grayColor];
    txtViewMessage.backgroundColor = [UIColor clearColor];
    txtViewMessage.textColor = [UIColor blackColor];
    txtViewMessage.isScrollable = NO;
    txtViewMessage.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    txtViewMessage.returnKeyType = UIReturnKeyDefault;
    txtViewMessage.delegate = self;
    txtViewMessage.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    txtViewMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [viewSendMessage addSubview:txtViewMessage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    txtViewMessage.text = @"";
    txtViewMessage.placeholder = @"Type Message Here";
    
    ChatShare *shareObj = [[ChatShare alloc] init];
    shareObj.strMessage = @"This is testing...123This is testing...123This is testing...123";
    shareObj.strPersonFlag = @"Me";
    [arrShare addObject:shareObj];
    ChatShare *shareObj1 = [[ChatShare alloc] init];
    shareObj1.strMessage = @"BBBBBBBBBBBBBBBBBBBBBBBBBBBBB";
    shareObj1.strPersonFlag = @"Other";
    [arrShare addObject:shareObj1];
    ChatShare *shareObj2 = [[ChatShare alloc] init];
    shareObj2.strMessage = @"CCCC";
    shareObj2.strPersonFlag = @"Me";
    [arrShare addObject:shareObj2];
    ChatShare *shareObj3 = [[ChatShare alloc] init];
    shareObj3.strMessage = @"DDDDDDDDDDDDDDDDDDDDDDDDDDDDD";
    shareObj3.strPersonFlag = @"Other";
    [arrShare addObject:shareObj3];
    
    ChatShare *shareObj4 = [[ChatShare alloc] init];
    shareObj4.strMessage = @"AAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    shareObj4.strPersonFlag = @"Me";
    [arrShare addObject:shareObj4];
    ChatShare *shareObj5 = [[ChatShare alloc] init];
    shareObj5.strMessage = @"BBBBBBBBBBBBBBBBBBBB";
    shareObj5.strPersonFlag = @"Other";
    [arrShare addObject:shareObj5];
    ChatShare *shareObj6 = [[ChatShare alloc] init];
    shareObj6.strMessage = @"CCCCCCCCCCCCCCCCCCCCCCCCCCCCC";
    shareObj6.strPersonFlag = @"Me";
    [arrShare addObject:shareObj6];
    ChatShare *shareObj7 = [[ChatShare alloc] init];
    shareObj7.strMessage = @"DDDD";
    shareObj7.strPersonFlag = @"Other";
    [arrShare addObject:shareObj7];
    
    [tblChat reloadData];
    [self scrollTableToLastCell:NO];
}

#pragma mark -
#pragma mark – Button Click Methods
-(IBAction)btnSendClick:(id)sender
{
    txtViewMessage.text = [txtViewMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![[[Singleton sharedSingleton] removeNull:txtViewMessage.text] isEqualToString:@""] || txtViewMessage.text != nil) {
        // Call Web service
        [self hideKeyboard];
    }
}

#pragma mark -
#pragma mark TextView Notification Methods
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = viewSendMessage.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    viewSendMessage.frame = r;
    tblChat.frame = CGRectMake(tblChat.frame.origin.x, tblChat.frame.origin.y, tblChat.frame.size.width, viewSendMessage.frame.origin.y);
}

#pragma mark -
#pragma mark  Keyboard Notification Methods
-(void) keyboardWillShow:(NSNotification *)note{
    
    txtViewMessage.placeholder = @"";
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = viewSendMessage.frame;
    containerFrame.origin.y = tblChat.superview.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    viewSendMessage.frame = containerFrame;
    
    tblChat.frame = CGRectMake(tblChat.frame.origin.x, tblChat.frame.origin.y, tblChat.frame.size.width, containerFrame.origin.y);
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    txtViewMessage.placeholder = @"Type Message Here";
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect containerFrame = viewSendMessage.frame;
    containerFrame.origin.y = tblChat.superview.bounds.size.height - containerFrame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    viewSendMessage.frame = containerFrame;
    tblChat.frame = CGRectMake(tblChat.frame.origin.x, tblChat.frame.origin.y, tblChat.frame.size.width, viewSendMessage.frame.origin.y);
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Table view datasouce & delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrShare.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatShare *shareObj = [arrShare objectAtIndex:indexPath.row];
    
    CGSize sizeMessage = [[Singleton sharedSingleton] getSizeFromString:[[Singleton sharedSingleton] removeNull:shareObj.strMessage] width:k_MessageWidth fontName:CustomFontBookWithSize(14)];
    sizeMessage.height = sizeMessage.height+30;
    
    if(sizeMessage.height < 50)
        sizeMessage.height = 50;
    
    return sizeMessage.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomChatCell";
    CustomChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.showsReorderControl = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblBackground.layer.cornerRadius = 10;
        cell.lblBackground.layer.masksToBounds = YES;
    }
    
    int intBackgroundOriginX = k_OriginX;
    int intIconOriginX = 13;
    
    ChatShare *shareObj = [arrShare objectAtIndex:indexPath.row];
    cell.lblMessage.text = shareObj.strMessage;

    CGSize sizeMessage = [[Singleton sharedSingleton] getSizeFromString:[[Singleton sharedSingleton] removeNull:shareObj.strMessage] width:k_MessageWidth fontName:CustomFontBookWithSize(14)];
    
    if([shareObj.strPersonFlag isEqualToString:@"Me"]) {
        cell.lblBackground.backgroundColor = RGB(70, 70, 70);
        cell.lblMessage.textColor = [UIColor whiteColor];
        cell.imgViewBackground.image = [UIImage imageNamed:@"chat_bottum_icon_a.png"];
        
        intIconOriginX = cell.frame.size.width-45;
        intBackgroundOriginX = cell.frame.size.width-k_OriginX-sizeMessage.width-20;
    } else {
        cell.lblBackground.backgroundColor = [UIColor whiteColor];
        cell.lblMessage.textColor = [UIColor blackColor];
        cell.imgViewBackground.image = [UIImage imageNamed:@"chat_bottum_icon.png"];
    }
    
    cell.lblBackground.frame = CGRectMake(intBackgroundOriginX, 5, sizeMessage.width+25, sizeMessage.height+20);
    cell.lblMessage.frame = CGRectMake(cell.lblBackground.frame.origin.x+10, cell.lblBackground.frame.origin.y+10, cell.lblBackground.frame.size.width-10, sizeMessage.height);
    cell.imgViewBackground.frame = CGRectMake(intIconOriginX, cell.lblBackground.frame.origin.y+cell.lblBackground.frame.size.height-cell.imgViewBackground.frame.size.height, cell.imgViewBackground.frame.size.width, cell.imgViewBackground.frame.size.height);
    
    return cell;
}

#pragma mark -
#pragma mark Other methods
-(void)hideKeyboard {
    [txtViewMessage resignFirstResponder];
}

-(void)scrollTableToLastCell :(BOOL)boolValue {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrShare.count-1 inSection:0];
    [tblChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:boolValue];
}

@end
