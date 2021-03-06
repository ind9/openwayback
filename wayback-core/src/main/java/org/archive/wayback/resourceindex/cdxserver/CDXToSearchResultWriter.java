package org.archive.wayback.resourceindex.cdxserver;

import org.archive.cdxserver.CDXQuery;
import org.archive.cdxserver.writer.CDXWriter;
import org.archive.format.cdx.FieldSplitFormat;
import org.archive.wayback.core.SearchResults;

public abstract class CDXToSearchResultWriter extends CDXWriter {
	
	protected CDXQuery query;
	protected String msg = null;
	
	public CDXToSearchResultWriter(CDXQuery query)
	{
		this.query = query;
	}

	@Override
    public void begin() {
	    // TODO Auto-generated method stub
    }

	@Override
    public void writeResumeKey(String resumeKey) {
	    // TODO Auto-generated method stub   
    }

	@Override
    public void end() {
	    // TODO Auto-generated method stub
    }
	
	public abstract SearchResults getSearchResults();
	
	public CDXQuery getQuery()
	{
		return query;
	}
	
	@Override
	public void printError(String msg)
	{
		this.msg = msg;
	}
	
	public String getErrorMsg()
	{
		return msg;
	}
	
	@Override
    public FieldSplitFormat modifyOutputFormat(FieldSplitFormat format) {
	    return format;
    }
}
