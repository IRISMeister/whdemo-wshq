/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.HQ.CLS?WSDL=1
Class WSDC.HQ.ReceivingOrderContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ReceivingOrderContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of WSDC.HQ.ReceivingOrder(XMLITEMNAME = "ReceivingOrder", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Storage Default
{
<Data name="ReceivingOrderContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
</Data>
<DataLocation>^WSDC.HQ.ReceivingOr9905D</DataLocation>
<DefaultData>ReceivingOrderContainerDefaultData</DefaultData>
<IdLocation>^WSDC.HQ.ReceivingOr9905D</IdLocation>
<IndexLocation>^WSDC.HQ.ReceivingOr9905I</IndexLocation>
<StreamLocation>^WSDC.HQ.ReceivingOr9905S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
