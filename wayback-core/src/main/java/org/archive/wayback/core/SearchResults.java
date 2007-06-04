/* SearchResults
 *
 * $Id$
 *
 * Created on 12:52:13 PM Nov 9, 2005.
 *
 * Copyright (C) 2005 Internet Archive.
 *
 * This file is part of wayback.
 *
 * wayback is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * any later version.
 *
 * wayback is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser Public License for more details.
 *
 * You should have received a copy of the GNU Lesser Public License
 * along with wayback; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.archive.wayback.core;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Properties;

import org.archive.wayback.WaybackConstants;

/**
 *
 *
 * @author brad
 * @version $Date$, $Revision$
 */
public class SearchResults {
	/**
	 * List of SearchResult objects for index records matching a query
	 */
	private ArrayList<SearchResult> results = null;
	/**
	 * 14-digit timestamp of first capture date contained in the SearchResults
	 */
	private String firstResultDate;
	/**
	 * 14-digit timestamp of last capture date contained in the SearchResults
	 */
	private String lastResultDate;
	/**
	 * Expandable data bag for tuples associated with the search results, 
	 * likely examples might be "total matching documents", "index of first 
	 * document returned", etc. 
	 */
	private Properties filters = new Properties();
	
	/**
	 * Constructor
	 */
	public SearchResults() {
		super();
		results = new ArrayList<SearchResult>();
	}
	/**
	 * @return true if no SearchResult objects, false otherwise.
	 */
	public boolean isEmpty() {
		return results.isEmpty();
	}
	
	/**
	 * append a result
	 * @param result
	 */
	public void addSearchResult(final SearchResult result) {
		addSearchResult(result,true);
	}
	/**
	 * add a result to this results, at either the begginning or at the end,
	 * depending on the append argument
	 * @param result
	 *            SearchResult to add to this set
	 * @param append 
	 */
	public void addSearchResult(final SearchResult result, final boolean append) {
		String resultDate = result.get(WaybackConstants.RESULT_CAPTURE_DATE);
		if((firstResultDate == null) || 
				(firstResultDate.compareTo(resultDate) > 0)) {
			firstResultDate = resultDate;
		}
		if((lastResultDate == null) || 
				(lastResultDate.compareTo(resultDate) < 0)) {
			lastResultDate = resultDate;
		}
		if(append) {
			results.add(result);
		} else {
			results.add(0,result);
		}
	}
	
	/**
	 * @return number of SearchResult objects contained in these SearchResults
	 */
	public int getResultCount() {
		return results.size();
	}
	
	/**
	 * @return an Iterator that contains the SearchResult objects
	 */
	public Iterator<SearchResult> iterator() {
		return results.iterator();
	}
	/**
	 * @return Returns the firstResultDate.
	 */
	public String getFirstResultDate() {
		return firstResultDate;
	}
	/**
	 * @return Returns the lastResultDate.
	 */
	public String getLastResultDate() {
		return lastResultDate;
	}

	/**
	 * @param key
	 * @return boolean, true if key 'key' exists in filters
	 */
	public boolean containsFilter(String key) {
		return filters.containsKey(key);
	}

	/**
	 * @param key
	 * @return value of key 'key' in filters
	 */
	public String getFilter(String key) {
		return filters.getProperty(key);
	}

	/**
	 * @param key
	 * @param value
	 * @return previous String value of key 'key' or null if there was none
	 */
	public String putFilter(String key, String value) {
		return (String) filters.setProperty(key, value);
	}
	/**
	 * @return Returns the filters.
	 */
	public Properties getFilters() {
		return filters;
	}
	/**
	 * @param wbRequest
	 * @return The closest SearchResult to the request.
	 * @throws ParseException
	 */
	public SearchResult getClosest(WaybackRequest wbRequest) {

		SearchResult closest = null;
		long closestDistance = 0;
		SearchResult cur = null;
		Timestamp wantTimestamp;
		wantTimestamp = Timestamp.parseBefore(wbRequest
				.get(WaybackConstants.REQUEST_EXACT_DATE));

		Iterator itr = results.iterator();
		while (itr.hasNext()) {
			cur = (SearchResult) itr.next();
			long curDistance;
			Timestamp curTimestamp = Timestamp.parseBefore(cur
					.get(WaybackConstants.RESULT_CAPTURE_DATE));
			curDistance = curTimestamp.absDistanceFromTimestamp(wantTimestamp);
			
			if ((closest == null) || (curDistance < closestDistance)) {
				closest = cur;
				closestDistance = curDistance;
			}
		}
		return closest;
	}
}