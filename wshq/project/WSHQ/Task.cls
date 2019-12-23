Include (CommonInc, Ensemble)

Class WSHQ.Task Extends %SOAP.WebService
{

Parameter ADAPTER;

Parameter SERVICENAME = "WSHQ";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

ClassMethod ClearAll() [ WebMethod ]
{
	Do ##class(WSHQ.Util).ClearAll()
	Do ##class(Ens.Purge).PurgeAll(.tDeletedCount,0,0,1)
	Do ##class(Ens.Director).CleanProduction()
	
	Do ##class(Ens.Activity.Utils).Purge("0s",,.c)
	Do ##class(Ens.Activity.Utils).Purge("0d",,.c)
}

ClassMethod StartProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StartProduction("WSHQ.Production.Production1")
}

ClassMethod StopProduction() As %Status [ WebMethod ]
{
	Return ##class(Ens.Director).StopProduction(,1)
}

}
