<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;

public class Handler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        HttpResponse r = context.Response;
		r.Cache.SetNoStore();
		r.Cache.SetMaxAge(new TimeSpan(0,0,0));
		r.Cache.SetCacheability(HttpCacheability.NoCache);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}