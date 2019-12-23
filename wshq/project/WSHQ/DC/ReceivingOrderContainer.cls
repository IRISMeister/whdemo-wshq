/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSHQ.Service.DC.CLS?WSDL=1
Class WSHQ.DC.ReceivingOrderContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ReceivingOrderContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of WSHQ.DC.ReceivingOrder(XMLITEMNAME = "ReceivingOrder", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Property WSDCName As %String(MAXLEN = "", XMLNAME = "WSDCName");

Storage Default
{
<Data name="ReceivingOrderContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
<Value name="3">
<Value>WSDCName</Value>
</Value>
</Data>
<DataLocation>^WSHQ.DC.ReceivingOr9905D</DataLocation>
<DefaultData>ReceivingOrderContainerDefaultData</DefaultData>
<IdLocation>^WSHQ.DC.ReceivingOr9905D</IdLocation>
<IndexLocation>^WSHQ.DC.ReceivingOr9905I</IndexLocation>
<StreamLocation>^WSHQ.DC.ReceivingOr9905S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
