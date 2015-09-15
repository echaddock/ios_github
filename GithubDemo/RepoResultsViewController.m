//
//  RepoResultsViewController.m
//  GithubDemo
//
//  Created by Nicholas Aiwazian on 9/15/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "RepoResultsViewController.h"
#import "MBProgressHUD.h"
#import "GithubRepo.h"
#import "GithubRepoSearchSettings.h"
#import "GithubCell.h"
#import "UIImageView+AFNetworking.h"

@interface RepoResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) GithubRepoSearchSettings *searchSettings;
@property (nonatomic, strong) NSArray *results;
@end

@implementation RepoResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchSettings = [[GithubRepoSearchSettings alloc] init];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    [self doSearch];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (GithubCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GithubCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GithubCell"];
    GithubRepo *repo = self.results[indexPath.row];
    NSLog(@"%@", repo);

    cell.descriptionLabel.text = repo.repoDescription;
    cell.nameLabel.text = repo.name;
    [cell.avatar setImageWithURL:[NSURL URLWithString:repo.ownerAvatarURL]];
    cell.starsLabel.text = [NSString stringWithFormat:@"%li", repo.stars];
    [cell.starImage setImage:[UIImage imageNamed:@"star"]];
    cell.ownerLabel.text = repo.ownerHandle;
    cell.forksLabel.text = [NSString stringWithFormat:@"%li",repo.forks];
    [cell.forkImage setImage:[UIImage imageNamed:@"fork"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (void)doSearch {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [GithubRepo fetchRepos:self.searchSettings successCallback:^(NSArray *repos) {
        for (GithubRepo *repo in repos) {
            NSLog(@"%@", [NSString stringWithFormat:
                   @"Name:%@\n\tStars:%ld\n\tForks:%ld,Owner:%@\n\tAvatar:%@\n\t,Description:%@\n\t",
                          repo.name,
                          repo.stars,
                          repo.forks,
                          repo.ownerHandle,
                          repo.ownerAvatarURL,
                          repo.repoDescription
                   ]);
        }
        self.results = [[NSArray alloc] initWithArray:repos];
        
        NSLog(@"%@", self.results);

        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchSettings.searchString = searchBar.text;
    [searchBar resignFirstResponder];
    [self doSearch];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
