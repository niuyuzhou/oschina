//
//  ReportView.h
//  oschina
//
//  Created by chenhaoxiang on 14-4-21.
//
//

#import <UIKit/UIKit.h>

@interface ReportView : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *reasonContent;

-(IBAction) clickReport:(id)sender;
-(IBAction) clickBackground:(id)sender;

@end
