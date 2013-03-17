//
//  ViewController.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    myCollapseClick.delegate = self;
    myCollapseClick.CollapseClickDelegate = self;
    [myCollapseClick reloadCollapseClick];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


  ///////////////////////////
 // CollapseClickDelegate //
///////////////////////////

-(int)numberOfCellsForCollapseClick {
    return 5;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"Test 1 Header";
            break;
        case 1:
            return @"Test 2 Header";
            break;
        case 2:
            return @"Test 3 Header";
            break;
            
        default:
            return [NSString stringWithFormat:@"LOLOL %d", index];
            break;
    }
}


-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithRed:71/255.0f green:201/255.0f blue:110/255.0f alpha:1.0];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.35];
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return test1View;
            break;
        case 1:
            return test2View;
            break;
        case 2:
            return test3View;
            break;
            
        default:
            return test1View;
            break;
    }
}


  ///////////////////////////
 // CollapseClick Methods //
///////////////////////////

- (IBAction)testScrollCellsMethod:(id)sender {
    [myCollapseClick scrollToCollapseClickCellAtIndex:2 animated:YES];
}
@end
