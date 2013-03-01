CollapseClick
=============

A collapsible list that functions like a UITableView, except you can collapse and open cells on a click. Feed it UIViews for what is shown when each cell is open. Works via delegation similar to UITableView. *This is a UIScrollView Subclass.*


## Installation ##

Drag the included <code>CollapseClick.m, CollapseClick.h, CollapseClickCell.m, CollapseClickCell.h, CollapseClickCell.xib</code> files into your project.

Import CollapseClick.h into your ViewController.h file. Next, in InterfaceBuilder, drag a UIScrollView out into your ViewController. Click on the Identity Inspector (3rd icon from the left, in the Right Pane in XCode) and change the class to <code>CollapseClick</code>. Connect up your CollapseClick to your ViewController.h file. Now add the CollapseClickDelegate. Your interface should look like this now:

```shell
#import <UIKit/UIKit.h>
#import "CollapseClick.h"

@interface ViewController : UIViewController <CollapseClickDelegate> {
  __weak IBOutlet CollapseClick *myCollapseClick;
}

@end
```

You are now ready to roll.

## Using CollapseClick ##

CollapseClick works off of delegation, similar to how UITableView appropriates and displays its data. There are 4 delegate methods you can implement, 3 of which are required.

```shell
Required Delegate Methods:

// 1. Number of CollapseClickCells
//    - This is the number of cells to display, usually based
//      off your data source.

-(int)numberOfCellsForCollapseClick {
    return (int)newInt;
}



// 2. Title for each CollapseClickCell
//    - This is the text for the label that appears in the
//      clickable, header area of each cell.

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    return (NSString*)newTitle;
}



// 3. View for each CollapseClickCell\'s Content
//    - This is the View that appears when you OPEN a cell.
//    - This can be a .XIB, or a dynamically created view, etc.

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    return (UIView *)contentView;
}



// 4. Color of each CollapseClickCell\'s TitleView Background
//    - This is an optional method.
//    - This color is for the background of the clickable, header area.

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return (UIColor *)color;
}
```

Just implement these methods, and your customized CollapseClick will be good to go.


Reap What I Sow!
================

This project is distributed under the standard MIT License. Please use this and twist it in whatever fashion you wish - and recommend any cool changes to help the code.
