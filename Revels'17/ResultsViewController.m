//
//  ResultsViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsTableViewCell.h"
#import "ResultsJSONModel.h"
#import "EventStore+CoreDataClass.h"

@interface ResultsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray <EventStore *> *events;
@property (weak,nonatomic) IBOutlet UITableView *resultsTableView;

@end

@implementation ResultsViewController{
    NSMutableArray *resultsArray;
    NSManagedObjectContext *context;
    NSFetchRequest *fetchEvents;
}

- (void)loadResultsFromApi
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        SVHUD_SHOW;
        @try {
            
            NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/results/"];
            NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
            NSError *error;
            
            if (mydata!=nil)
            {
                SVHUD_HIDE;
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
                
                resultsArray = [ResultsJSONModel getArrayFromJson:array];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [self.resultsTableView reloadData];
                });
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Results";
    context = [AppDelegate sharedManagedObjectContext];
    
    [self.resultsTableView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:@"resultsCell"];
    
    resultsArray = [NSMutableArray new];
    [self loadResultsFromApi];
    
    NSError *error;
    self.events = [context executeFetchRequest:[EventStore fetchRequest] error:&error];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ResultsTableViewCell *cell;
    ResultsJSONModel *model = [resultsArray objectAtIndex:indexPath.row];
    
    EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", model.catID, model.eventID]] firstObject];

    cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    
    cell.eventName.text = event.eventName;
    cell.categoryName.text = event.catName;
    cell.round.text = [NSString stringWithFormat:@"Round: %@",model.round];
    cell.resultLabel.text = [NSString stringWithFormat:@"Team: %@ Pos: %@",model.teamID,model.pos];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
