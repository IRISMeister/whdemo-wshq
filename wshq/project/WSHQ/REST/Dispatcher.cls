Include (CommonInc, Ensemble)

Class WSHQ.REST.Dispatcher Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/Receive/:inout" Method="POST" Call="Receive"/>
</Routes>
}

ClassMethod Receive(inout As %String) As %Status
{
	If inout="IN" { Set tServiceName="DCIn" }
	ElseIf inout="RECV" { Set tServiceName="DCRecv" }
	Else {
		#; unknown request
		Set resultContainer={}
		Set resultContainer.Messages=[]
		Set resultContainer.Count=0
		Set resultContainer.Status='$$$OK
		Do resultContainer.%ToJSON()
		Return '$$$OK 
	}

	Set tSC=##class(Ens.Director).CreateBusinessService(tServiceName,.tService)
	Set tSC = tService.ProcessInput(,.output)
	Return tSC
}

}
