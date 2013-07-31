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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.isClickedArray.count; i++) {
        // only layout opened cells
        if ([[self.isClickedArray objectAtIndex:i] boolValue]) {
            CollapseClickCell *cell = [self.dataArray objectAtIndex:i];
            
            float contentHeight = ((UIView *)[cell.ContentView.subviews lastObject]).frame.size.height;
            
            // cell content height is changed
            if (contentHeight != cell.ContentView.frame.size.height) {
                float offset = cell.ContentView.frame.size.height - contentHeight;
                
                CGRect contentViewFrame = CGRectMake(cell.ContentView.frame.origin.x, cell.ContentView.frame.origin.y, cell.ContentView.frame.size.width, contentHeight);
                
                cell.ContentView.frame = contentViewFrame;
                cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.ContentView.frame.origin.y + cell.ContentView.frame.size.height + kCCPad);
                [self repositionCollapseClickCellsBelowIndex:i withOffset:-1*offset];
            }
        }
    }
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
        if ([(id)CollapseClickDelegate respondsToSelector:@selector(colorForCollapseClickTitleViewAtIndex:)]) {
            cell.TitleView.backgroundColor = [CollapseClickDelegate colorForCollapseClickTitleViewAtIndex:xx];
        }
        else {
            cell.TitleView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        }
        
        
        // Set cell.TitleLabel's Color
        if ([(id)CollapseClickDelegate respondsToSelector:@selector(colorForTitleLabelAtIndex:)]) {
            cell.TitleLabel.textColor = [CollapseClickDelegate colorForTitleLabelAtIndex:xx];
        }
        else {
            cell.TitleLabel.textColor = [UIColor whiteColor];
        }
        
        
        // Set cell.TitleArrow's Color
        if ([(id)CollapseClickDelegate respondsToSelector:@selector(colorForTitleArrowAtIndex:)]) {
            [cell.TitleArrow drawWithColor:[CollapseClickDelegate colorForTitleArrowAtIndex:xx]];
        }
        else {
            [cell.TitleArrow drawWithColor:[UIColor colorWithWhite:0.0 alpha:0.35]];
        }
        
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
    BOOL isOpen = NO;
    
    // Cell is OPEN -> CLOSED
    if ([[self.isClickedArray objectAtIndex:titleButton.tag] boolValue] == YES) {
        [self closeCollapseClickCellAtIndex:titleButton.tag animated:YES];
    }
    // Cell is CLOSED -> OPEN
    else {
        [self openCollapseClickCellAtIndex:titleButton.tag animated:YES];
        isOpen = YES;
    }
    
    // Call delegate method
    if ([(id)CollapseClickDelegate respondsToSelector:@selector(didClickCollapseClickCellAtIndex:isNowOpen:)]) {
        [CollapseClickDelegate didClickCollapseClickCellAtIndex:titleButton.tag isNowOpen:isOpen];
    }
}

#pragma mark - Open CollapseClickCell
-(void)openCollapseClickCellAtIndex:(int)index animated:(BOOL)animated {
    // Check if it's not open first
    if ([[self.isClickedArray objectAtIndex:index] boolValue] != YES) {
        float duration = 0;
        if (animated) {
            duration = 0.25;
        }
        [UIView animateWithDuration:duration animations:^{
            // Resize Cell
            CollapseClickCell *cell = [self.dataArray objectAtIndex:index];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.ContentView.frame.origin.y + cell.ContentView.frame.size.height + kCCPad);
            
            // Change Arrow orientation
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
            cell.TitleArrow.transform = transform;
            
            // Change isClickedArray
            [self.isClickedArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
            
            // Reposition all CollapseClickCells below Cell
            [self repositionCollapseClickCellsBelowIndex:index withOffset:cell.ContentView.frame.size.height + kCCPad];
        }];
    }
}

-(void)openCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated {
    // This works off of NSNumbers for each Index
    for (int ii = 0; ii < indexArray.count; ii++) {
        id indexID = indexArray[ii];
        if ([indexID isKindOfClass:[NSNumber class]]) {
            [self openCollapseClickCellAtIndex:[indexID intValue] animated:animated];
        }
    }
    
}



#pragma mark - Close CollapseClickCell
-(void)closeCollapseClickCellAtIndex:(int)index animated:(BOOL)animated {
    // Check if it's open first
    if ([[self.isClickedArray objectAtIndex:index] boolValue] == YES) {
        float duration = 0;
        if (animated) {
            duration = 0.25;
        }
        [UIView animateWithDuration:duration animations:^{
            // Resize Cell
            CollapseClickCell *cell = [self.dataArray objectAtIndex:index];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, kCCHeaderHeight);
            
            // Change Arrow orientation
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            cell.TitleArrow.transform = transform;
            
            // Change isClickedArray
            [self.isClickedArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
            
            // Reposition all CollapseClickCells below Cell
            [self repositionCollapseClickCellsBelowIndex:index withOffset:-1*(cell.ContentView.frame.size.height + kCCPad)];
        }];
    }
}

-(void)closeCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated {
    // This works off of NSNumbers for each Index
    for (int ii = 0; ii < indexArray.count; ii++) {
        id indexID = indexArray[ii];
        if ([indexID isKindOfClass:[NSNumber class]]) {
            [self closeCollapseClickCellAtIndex:[indexID intValue] animated:animated];
        }
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


#pragma mark - Content View for Cell
-(UIView *)contentViewForCellAtIndex:(int)index {
    CollapseClickCell *cell = [self.subviews objectAtIndex:index];
    return cell.ContentView;
}

@end
