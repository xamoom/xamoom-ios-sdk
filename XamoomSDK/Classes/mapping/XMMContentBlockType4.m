//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlockType4.h"

@implementation XMMContentBlockType4


#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock4TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock4TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"LinkBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"LinkBlockTableViewCell"];
  }
  
  //set title, text, linkUrl and linkType
  if(self.title != nil && ![self.title isEqualToString:@""])
    cell.titleLabel.text = self.title;
  
  cell.linkTextLabel.text = self.text;
  cell.linkUrl = self.linkUrl;
  cell.linkType = self.linkType;
  
  //change style of the cell according to the linktype
  //[cell changeStyleAccordingToLinkType];
  
  return cell;
}

@end
