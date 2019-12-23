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
	
	New $NAMESPACE
	Set $NAMESPACE="WSDEMO"
	Do ##class(Ens.Activity.Utils).Purge("0s",,.c)
	Do ##class(Ens.Activity.Utils).Purge("0d",,.c)
}

}
