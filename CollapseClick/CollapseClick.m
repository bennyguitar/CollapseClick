//
//  CollapseClick.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClick.h"

@implementation CollapseClick
@synthesize CollapseClickDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isClickedArray = [[NSMutableArray alloc] initWithCapacity:[CollapseClickDelegate numberOfCellsForCollapseClick]];
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:[CollapseClickDelegate numberOfCellsForCollapseClick]];
        [self reloadCollapseClick];
    }
    return self;
}


#pragma mark - Load Data
-(void)reloadCollapseClick {
    // Set Up: Height
    float totalHeight = 0;
    
    // If Arrays aren't Init'd, Init them
    if (!(self.isClickedArray)) {
        self.isClickedArray = [[NSMutableArray alloc] initWithCapacity:[CollapseClickDelegate numberOfCellsForCollapseClick]];
    }
    
    if (!(self.dataArray)) {
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:[CollapseClickDelegate numberOfCellsForCollapseClick]];
    }
    
    // Make sure they are clear
    [self.isClickedArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    // Remove all subviews
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    // Add cells
    for (int xx = 0; xx < [CollapseClickDelegate numberOfCellsForCollapseClick]; xx++) {
        // Create Cell
        CollapseClickCell *cell = [CollapseClickCell newCollapseClickCellWithTitle:[CollapseClickDelegate titleForCollapseClickAtIndex:xx] index:xx content:[CollapseClickDelegate viewForCollapseClickContentViewAtIndex:xx]];
        
        
        // Set cell.TitleView's backgroundColor
        // FIXME: So it works
        if ([self respondsToSelector:@selector(colorForCollapseClickTitleViewAtIndex:)]) {
            cell.TitleView.backgroundColor = [CollapseClickDelegate colorForCollapseClickTitleViewAtIndex:xx];
        }
        
        // For Now:
        cell.TitleView.backgroundColor = [CollapseClickDelegate colorForCollapseClickTitleViewAtIndex:xx];
        
        
        // Set cell.TitleLabel's Color
        // FIXME: So it works
        if ([self respondsToSelector:@selector(colorForTitleLabelAtIndex:)]) {
            cell.TitleLabel.textColor = [CollapseClickDelegate colorForTitleLabelAtIndex:xx];
        }
        
        // For Now:
        cell.TitleLabel.textColor = [CollapseClickDelegate colorForTitleLabelAtIndex:xx];
        
        
        // Set cell.ContentView's size
        cell.ContentView.frame = CGRectMake(0, kCCHeaderHeight + kCCPad, self.frame.size.width, cell.ContentView.frame.size.height);
        
        // Set cell's size
        cell.frame = CGRectMake(0, totalHeight, self.frame.size.width, kCCHeaderHeight);
        
        
        // Add target to Button
        [cell.TitleButton addTarget:self action:@selector(didSelectCollapseClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // Add cell
        [self addSubview:cell];
        
        // Add to DataArray & isClickedArray
        [self.isClickedArray addObject:[NSNumber numberWithBool:NO]];
        [self.dataArray addObject:cell];
        
        // Calculate totalHeight
        totalHeight += kCCHeaderHeight + kCCPad;
    }
    
    // Set self's ContentSize and ContentOffset
    [self setContentSize:CGSizeMake(self.frame.size.width, totalHeight)];
    [self setContentOffset:CGPointZero];
}



#pragma mark - Reposition Cells
-(void)repositionCollapseClickCellsBelowIndex:(int)index withOffset:(float)offset {
    for (int yy = index+1; yy < self.dataArray.count; yy++) {
        CollapseClickCell *cell = [self.dataArray objectAtIndex:yy];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + offset, cell.frame.size.width, cell.frame.size.height);
    }
    
    // Resize self.ContentSize
    CollapseClickCell *lastCell = [self.dataArray objectAtIndex:self.dataArray.count - 1];
    [self setContentSize:CGSizeMake(self.frame.size.width, lastCell.frame.origin.y + lastCell.frame.size.height + kCCPad)];
}


#pragma mark - Did Click
-(void)didSelectCollapseClickButton:(UIButton *)titleButton {
    // Cell is OPEN -> CLOSED
    if ([[self.isClickedArray objectAtIndex:titleButton.tag] boolValue] == YES) {
        // Resize Cell
        CollapseClickCell *cell = [self.dataArray objectAtIndex:titleButton.tag];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCCHeaderHeight);
        
        // Change isClickedArray
        [self.isClickedArray replaceObjectAtIndex:titleButton.tag withObject:[NSNumber numberWithBool:NO]];
        
        // Reposition all CollapseClickCells below Cell
        [self repositionCollapseClickCellsBelowIndex:titleButton.tag withOffset:-1*(cell.ContentView.frame.size.height + kCCPad)];
    }
    
    // Cell is CLOSED -> OPEN
    else {
        // Resize Cell
        CollapseClickCell *cell = [self.dataArray objectAtIndex:titleButton.tag];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.ContentView.frame.origin.y + cell.ContentView.frame.size.height + kCCPad);
        
        // Change isClickedArray
        [self.isClickedArray replaceObjectAtIndex:titleButton.tag withObject:[NSNumber numberWithBool:YES]];
        
        // Reposition all CollapseClickCells below Cell
        [self repositionCollapseClickCellsBelowIndex:titleButton.tag withOffset:cell.ContentView.frame.size.height + kCCPad];
    }
    
}


#pragma mark - CollapseClickCell for Index
-(CollapseClickCell *)collapseClickCellForIndex:(int)index {
    if ([[self.dataArray objectAtIndex:index] isKindOfClass:[CollapseClickCell class]]) {
        return [self.dataArray objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - Scroll To Cell
-(void)scrollToCollapseClickCellAtIndex:(int)index animated:(BOOL)animated {
    CollapseClickCell *cell = [self.dataArray objectAtIndex:index];
    [self setContentOffset:CGPointMake(cell.frame.origin.x, cell.frame.origin.y) animated:animated];
}



#pragma mark - Insert Cell at Index
-(void)insertNewCellWithTitle:(NSString *)title viewForContent:(UIView *)content atIndex:(int)index {
    // Fill In!
}


@end
