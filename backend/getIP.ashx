<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
//using System.Text.Json;
//using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

public class Handler : IHttpHandler {

	private string getClientIp(HttpRequest request){
		
		string ip;
		
	    if (!string.IsNullOrEmpty((request.ServerVariables["HTTP_CLIENT_IP"]))) {
			ip = request.ServerVariables["HTTP_CLIENT_IP"];
		} else if (!string.IsNullOrEmpty((request.ServerVariables["HTTP_X_REAL_IP"]))) {
			ip = request.ServerVariables["HTTP_X_REAL_IP"];
		} else if (!string.IsNullOrEmpty((request.ServerVariables["HTTP_X_FORWARDED_FOR"]))) {
			ip = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
			ip = Regex.Replace(ip,"/,.*/", ""); // hosts are comma-separated, client is first
		} else {
			ip = request.ServerVariables["REMOTE_ADDR"];
		}

		return ip; Regex.Replace(ip,"/^::ffff:/", "" );
	
	}
	
    public void ProcessRequest (HttpContext context) {

        HttpResponse r = context.Response;
		
		// Set caching
		r.Cache.SetNoStore();
		r.Cache.SetMaxAge(new TimeSpan(0,0,0));
		r.Cache.SetCacheability(HttpCacheability.NoCache);
		
		// Set type data
		r.ContentType = "application/json; charset=utf-8";
		

		// Get data to return	
		String ip = getClientIp(context.Request);

	
		// return it
		r.Write( "{\"processedString\":\"" );
		r.Write(ip);
		r.Write("\",\"rawIspInfo\":\"\"}");
		
		/*
				r.Write(
			jsonSerializer.Serialize(
				new
				{
					processedString = "Hello World",
					rawIspInfo = ""
				}
			)
		);
		*/
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}