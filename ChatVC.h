//
//  ChatVC.h
//  Setup
//
//  Created by TopsTech on 02/02/2015.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface ChatVC : UIViewController <HPGrowingTextViewDelegate> {
    IBOutlet UITableView *tblChat;
    
    NSMutableArray *arrShare;
    
    HPGrowingTextView *txtViewMessage;
    
    IBOutlet UIView *viewSendMessage;
    IBOutlet UIView *viewTableHeader;
    IBOutlet UIView *viewHeader;
}

-(IBAction)btnSendClick:(id)sender;

@end
