package com.dbapp;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/*
 * Listing Auto Updater
 * 
 * A server side thread that periodically does checks for all auctions.
 * These checks include:
 * 		- Check if a listing needs to be closed
 * 		- Update the auto bids to beat the current max on a listing
 * 
 * These checks are done periodically based on the TIMEOUT_SECONDS.
 * Love Chief Sosa. 
 */
class ListingAutoUpdater extends Thread {
	private static final long TIMEOUT_SECONDS = 1;
	Connection c;

	public ListingAutoUpdater(Connection c) {
		this.c = c;
	}

	public void run() {
		while (true) {
			pollListings();
			updateAutoBids();
			try {
				Thread.sleep(TIMEOUT_SECONDS * 1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/*
	 * Go through our current set auto bids and check if they have been out bidded.
	 * If so, go to each relevant listing and attempt to outbid the current max as
	 * long as we do not violate the maximum set for the autobid.
	 */
	private void updateAutoBids() {
		try {
			//Inner query: find the maximum bidder per listing
			//Outer query: filter the auto bids table to only include auto bidders who are not the maximum bidders
			java.sql.PreparedStatement ps = c.prepareStatement(
					"SELECT ab.*, l.price " +
					"FROM auto_bids ab " +
					"INNER JOIN listings l ON l.l_id = ab.l_id " +
					"INNER JOIN( "  + 
						"SELECT l.l_id, p.username " +
						"FROM listings l " +
						"INNER JOIN bidson bd ON l.l_id = bd.l_id " +
						"INNER JOIN bids b ON bd.b_id = b.b_id   "+
						"INNER JOIN places p ON p.b_id = b.b_id "+
						"INNER JOIN (SELECT l_id, MAX(price) as price FROM listings GROUP BY l_id) as ll ON ll.price = b.price "+
					") as max_users "+
					"ON max_users.l_id = ab.l_id AND (max_users.username != ab.u_id OR max_users.username IS NULL) "+
					"WHERE l.closed = 0"
			);
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				String username = rs.getString(1);
				int lid = rs.getInt(2);
				double incr = rs.getDouble(3);
				double bidLim = rs.getDouble(4);
				double currBid = rs.getDouble(5);
				double listingPrice = rs.getDouble(6);
				
				double bid = listingPrice + incr;
				bid =  Math.round(bid * 100.0)/100.0;
				/* Is our next bid to post greater than what the user set as max? */
				if (bid < bidLim) {
					//update listing
					ps = c.prepareStatement("UPDATE listings SET price =(?) WHERE l_id = (?)");
					ps.setDouble(1, bid);
					ps.setInt(2, lid);
					ps.executeUpdate();
					
					//insert into bids
					ps = c.prepareStatement("INSERT INTO bids(price, dtime) VALUES(?,?)");
					ps.setDouble(1, bid);
					ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
					ps.executeUpdate();
					
					//insert into bidson
					ps = c.prepareStatement(
							"INSERT INTO bidson(b_id, l_id) VALUES((SELECT MAX(b_id) FROM bids),?)"
					);
					ps.setInt(1, lid);
					ps.executeUpdate();
					
					//insert into places
					ps = c.prepareStatement(
							"INSERT INTO places(b_id, username) VALUES((SELECT MAX(b_id) FROM bids),?)"
					);
					ps.setString(1, username);
					ps.executeUpdate();
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/*
	 * Poll the currently open listings and close them if they are past date.
	 * If they should be closed, check if the listing has met the minimum sell
	 * price. If it has met the sale price, generate a new sale.
	 */
	private void pollListings() {
		try {
			java.sql.PreparedStatement ps = c.prepareStatement(
				"SELECT l_id, dt, price, minsale FROM listings WHERE closed=0"
			);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				String lid = rs.getString(1);
				String price = rs.getString(3);
				String minsale = rs.getString(4);
				Timestamp close_time = rs.getTimestamp(2);
				Timestamp curr_time = new Timestamp(System.currentTimeMillis());

				Double p = Double.parseDouble(price);
				p = Math.round(p * 100.0)/100.0;
				Double m = Double.parseDouble(minsale);
				m = Math.round(m * 100.0)/100.0;
				if (close_time.before(curr_time) || close_time.equals(curr_time)) {
					ps = c.prepareStatement(
							"UPDATE listings SET closed=1 WHERE l_id=(?)"
					);
					ps.setString(1, lid);
					ps.executeUpdate();

					if (p >= m) {
						//add to sales table
						ps = c.prepareStatement(
								"INSERT INTO sales(dtime, amount) "
										+ "VALUES(?, ?)");
						ps.setTimestamp(1, curr_time);
						ps.setString(2, price);
						ps.executeUpdate();

						//add to generates table
						ps = c.prepareStatement(
								"INSERT INTO generates(s_id, l_id) "
										+ "VALUES((SELECT MAX(s_id) FROM sales), ?)");
						ps.setString(1, lid);
						ps.executeUpdate();
					}
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
