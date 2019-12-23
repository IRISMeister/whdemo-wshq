/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.HQ.CLS?WSDL=1
Class WSDC.HQ.ShippingOrderContainer Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ShippingOrderContainer";

Parameter XMLSEQUENCE = 1;

Property Messages As list Of WSDC.HQ.ShippingOrder(XMLITEMNAME = "ShippingOrder", XMLNAME = "Messages", XMLPROJECTION = "COLLECTION");

Storage Default
{
<Data name="ShippingOrderContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
</Data>
<DataLocation>^WSDC.HQ.ShippingOrd83E1D</DataLocation>
<DefaultData>ShippingOrderContainerDefaultData</DefaultData>
<IdLocation>^WSDC.HQ.ShippingOrd83E1D</IdLocation>
<IndexLocation>^WSDC.HQ.ShippingOrd83E1I</IndexLocation>
<StreamLocation>^WSDC.HQ.ShippingOrd83E1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
