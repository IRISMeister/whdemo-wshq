Class WSHQ.Res.SendInboundOrder Extends Ens.Response
{

Property DestWSDC As %String;

Property Status As %String;

Storage Default
{
<Data name="SendInboundOrderDefaultData">
<Subscript>"SendInboundOrder"</Subscript>
<Value name="1">
<Value>DestWSDC</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>SendInboundOrderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
