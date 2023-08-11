//
//  StatsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 09.01.13.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

@synthesize proxy;
@synthesize stats;
@synthesize index;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	proxy = [MpdProxy instance];
	stats = proxy.stats.toDictionary;
	index = [[NSArray alloc] initWithObjects:@"Artists", @"Albums", @"Songs", @"Played", @"Playtime", @"Updated", nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClicked {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)hrPlaytime:(NSUInteger)time {
	NSInteger seconds = time % 60;
	NSInteger tmp = time / 60;
	NSInteger hours = tmp / 60;
	NSInteger minutes = tmp % 60;
	
	return [NSString stringWithFormat:@"%i:%i:%i", hours, minutes, seconds];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return index.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatCell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSString *statName = [index objectAtIndex:indexPath.row];
	NSString *statNameLocalized = [NSString stringWithFormat:@"stats.%@", statName];
	cell.textLabel.text = NSLocalizedString(statNameLocalized, @"Zeilenbeschriftung");
	
	if ([statName rangeOfString:@"Playtime"].location != NSNotFound) {
		cell.detailTextLabel.text = [self hrPlaytime:proxy.stats.dbPlaytime];
	} else if ([statName rangeOfString:@"Updated"].location != NSNotFound) {
		NSDate *dbUpdateDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)proxy.stats.dbUpdate];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:NSLocalizedString(@"stats.Updated.timeformat", @"uhrzeit formatter string")];
		cell.detailTextLabel.text = [formatter stringFromDate:dbUpdateDate];
	} else {
		cell.detailTextLabel.text = [stats objectForKey:statName];
	}

//	"stats.Artists" = "Artists";
//	"stats.Albums" = "Albums";
//	"stats.Songs" = "Songs";
//	"stats.Played" = "Played";
//	"stats.Playtime" = "Playtime";
//	"stats.Updated" = "Updated";
//	 = "yyyy-MM-dd 'at' HH:mm";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
