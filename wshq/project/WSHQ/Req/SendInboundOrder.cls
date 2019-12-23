Class WSHQ.Req.SendInboundOrder Extends Ens.Request
{

Property DestWSDC As %String;

Storage Default
{
<Data name="SendInboundOrderDefaultData">
<Subscript>"SendInboundOrder"</Subscript>
<Value name="1">
<Value>DestWSDC</Value>
</Value>
</Data>
<DefaultData>SendInboundOrderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
