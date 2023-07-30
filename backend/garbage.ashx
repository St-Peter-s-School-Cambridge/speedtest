<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;

public class Handler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        HttpResponse r = context.Response;
		
		// Set caching
		r.Cache.SetNoStore();
		r.Cache.SetMaxAge(new TimeSpan(0,0,0));
		r.Cache.SetCacheability(HttpCacheability.NoCache);
		
		// Set type data
		r.ContentType = "application/octet-stream";
		
		//Generate some random data to return
		Random rnd = new Random();
		Byte[] data = new Byte[1048576];
		rnd.NextBytes(data);
		
		// Work out how many chunks to send
		string ckSizeStr = context.Request["ckSize"];
		int ckSize=4;
		
		if(!String.IsNullOrEmpty(ckSizeStr) && int.TryParse(ckSizeStr,out ckSize)){
			if(ckSize>1024){
				ckSize=1024;
			}
		} else {
			ckSize=4;
		}
		
		// Send the data
		for(var i=0;i<ckSize;i++){
			r.BinaryWrite(data);
			r.Flush();
		}
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}