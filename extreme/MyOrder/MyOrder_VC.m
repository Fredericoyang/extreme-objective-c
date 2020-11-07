//
//  MyOrder_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/10.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "MyOrder_VC.h"
#import "Embed_MyOrder_TVC.h"

@interface MyOrder_VC ()

@end

@implementation MyOrder_VC {
    UIButton *_selectedButton;
    Embed_MyOrder_TVC *_myOrder_TVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedButton = _topTapButtons[0];
}


//MARK:按下顶部标签按钮
- (IBAction)tapTopTapButton:(UIButton *)sender {
    if (_selectedButton != sender) {
        _selectedButton.selected = NO;
        _selectedButton = sender;
        _selectedButton.selected = YES;
        for (UIButton *button in _topTapButtons) {
            if (button == _selectedButton) {
                [_myOrder_TVC loadData];
            }
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    id destViewController = segue.destinationViewController;
    if (self == sender) { // embed
        if ([destViewController isKindOfClass:[EFBaseTableViewController class]]) {
            _myOrder_TVC = destViewController;
            _myOrder_TVC.tableViewHeight = SCREEN_HEIGHT-TOP_LAYOUT_HEIGHT-50;
            if (@available(iOS 11.0, *)) {
                _myOrder_TVC.tableViewHeight -= SAFEAREA_INSETS.bottom;
            }
        }
    }
}

@end
