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

#import "XMMContentBlockType5.h"

@implementation XMMContentBlockType5


#pragma mark - XMMTableViewRepresentation

- (UITableViewCell *)tableView:(UITableView *)tableView representationAsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock5TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EbookBlockTableViewCell"];
  if (cell == nil) {
    [tableView registerNib:[UINib nibWithNibName:@"XMMContentBlock5TableViewCell" bundle:nil]
    forCellReuseIdentifier:@"EbookBlockTableViewCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"EbookBlockTableViewCell"];
  }
  
  //set title, artist and downloadUrl
  if(self.title != nil && ![self.title isEqualToString:@""])
    cell.titleLabel.text = self.title;
  
  cell.artistLabel.text = self.artist;
  cell.downloadUrl = self.fileId;
  
  return cell;
}

@end
