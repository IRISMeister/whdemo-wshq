Class WSHQ.Res.SendOutboundOrder Extends Ens.Response
{

Property DestWSDC As %String;

Property Status As %String;

Storage Default
{
<Data name="SendOutboundOrderDefaultData">
<Subscript>"SendOutboundOrder"</Subscript>
<Value name="1">
<Value>DestWSDC</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>SendOutboundOrderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
