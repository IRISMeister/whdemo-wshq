Class WSHQ.Operation.DefaultAlert Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As Ens.Response) As %Status
{
	$$$LOGERROR("デフォルトのアラートを受信")
	Quit $$$OK
}

}
