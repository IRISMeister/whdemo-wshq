/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/MAKER.Service.HQ.CLS?WSDL=1
Class MAKER.HQ.PurchaseOrderContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "PurchaseOrderContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of MAKER.HQ.PurchaseOrder(XMLITEMNAME = "PurchaseOrder", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Property WSDCName As %String(MAXLEN = "", XMLNAME = "WSDCName");

Storage Default
{
<Data name="PurchaseOrderContainerDefaultData">
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
<DataLocation>^MAKER.HQ.PurchaseOrd49F1D</DataLocation>
<DefaultData>PurchaseOrderContainerDefaultData</DefaultData>
<IdLocation>^MAKER.HQ.PurchaseOrd49F1D</IdLocation>
<IndexLocation>^MAKER.HQ.PurchaseOrd49F1I</IndexLocation>
<StreamLocation>^MAKER.HQ.PurchaseOrd49F1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
