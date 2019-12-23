Class WSHQ.Data.Shortage Extends %Persistent
{

Property 商品コード As %String;

Property 実在庫数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 発注数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property DCコード As %String;

Property 記録日時 As %TimeStamp;

Index idx商品コード On 商品コード [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ShortageDefaultData">
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
<DataLocation>^WSHQ.Data.ShortageD</DataLocation>
<DefaultData>ShortageDefaultData</DefaultData>
<IdLocation>^WSHQ.Data.ShortageD</IdLocation>
<IndexLocation>^WSHQ.Data.ShortageI</IndexLocation>
<StreamLocation>^WSHQ.Data.ShortageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
