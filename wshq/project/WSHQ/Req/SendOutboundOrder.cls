Class WSHQ.Req.SendOutboundOrder Extends Ens.Request
{

Property DestWSDC As %String;

Storage Default
{
<Data name="SendOutboundOrderDefaultData">
<Subscript>"SendOutboundOrder"</Subscript>
<Value name="1">
<Value>DestWSDC</Value>
</Value>
</Data>
<DefaultData>SendOutboundOrderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
