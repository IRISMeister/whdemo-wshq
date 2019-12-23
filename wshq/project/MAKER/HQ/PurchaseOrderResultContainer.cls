/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/MAKER.Service.HQ.CLS?WSDL=1
Class MAKER.HQ.PurchaseOrderResultContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "PurchaseOrderResultContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of MAKER.HQ.PurchaseOrderResult(XMLITEMNAME = "PurchaseOrderResult", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Property Status As %xsd.base64Binary(XMLNAME = "Status");

Storage Default
{
<Data name="PurchaseOrderResultContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^MAKER.HQ.PurchaseOrd9394D</DataLocation>
<DefaultData>PurchaseOrderResultContainerDefaultData</DefaultData>
<IdLocation>^MAKER.HQ.PurchaseOrd9394D</IdLocation>
<IndexLocation>^MAKER.HQ.PurchaseOrd9394I</IndexLocation>
<StreamLocation>^MAKER.HQ.PurchaseOrd9394S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
