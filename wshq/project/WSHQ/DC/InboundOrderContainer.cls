/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSHQ.Service.DC.CLS?WSDL=1
Class WSHQ.DC.InboundOrderContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "InboundOrderContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of WSHQ.DC.InboundOrder(XMLITEMNAME = "InboundOrder", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Property WSDCName As %String(MAXLEN = "", XMLNAME = "WSDCName");

Storage Default
{
<Data name="InboundOrderContainerDefaultData">
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
<DataLocation>^WSHQ.DC.InboundOrderContainerD</DataLocation>
<DefaultData>InboundOrderContainerDefaultData</DefaultData>
<IdLocation>^WSHQ.DC.InboundOrderContainerD</IdLocation>
<IndexLocation>^WSHQ.DC.InboundOrderContainerI</IndexLocation>
<StreamLocation>^WSHQ.DC.InboundOrderContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
