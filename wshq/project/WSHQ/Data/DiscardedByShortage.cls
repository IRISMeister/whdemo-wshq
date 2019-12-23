Class WSHQ.Data.DiscardedByShortage Extends %Persistent
{

Property 商品コード As %String;

Property 実在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property DCコード As %String;

Property 記録日時 As %TimeStamp;

Storage Default
{
<Data name="DiscardedByShortageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>商品コード</Value>
</Value>
<Value name="3">
<Value>実在庫数</Value>
</Value>
<Value name="4">
<Value>発注数</Value>
</Value>
<Value name="5">
<Value>DCコード</Value>
</Value>
<Value name="6">
<Value>記録日時</Value>
</Value>
</Data>
<DataLocation>^WSHQ.Data.DiscardedByShortageD</DataLocation>
<DefaultData>DiscardedByShortageDefaultData</DefaultData>
<IdLocation>^WSHQ.Data.DiscardedByShortageD</IdLocation>
<IndexLocation>^WSHQ.Data.DiscardedByShortageI</IndexLocation>
<StreamLocation>^WSHQ.Data.DiscardedByShortageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
