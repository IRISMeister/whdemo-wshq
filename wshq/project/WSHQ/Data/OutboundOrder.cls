/// 発注オーダ
Class WSHQ.Data.OutboundOrder Extends %Persistent
{

Property オーダ番号 As %String;

Property 出荷番号 As %String;

Property オーダ日付 As %Date;

Property 出荷予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property DC配信済み As %Boolean [ InitialExpression = 0 ];

Property オーダ作成日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Property 出荷先コード As %String;

Property DCコード As %String;

Index idxオーダ番号 On オーダ番号;

Index idx出荷番号 On 出荷番号;

Index idxオーダ日付 On オーダ日付;

Index idx出荷予定日付 On 出荷予定日付;

Index idxDC配信済み On DC配信済み;

Index idxDCコード On DCコード;

// DCコード+商品コードのprimaryKeyは張らない事。同じ商品が繰り返し注文されることは当然ある。

ClassMethod GetNewOrderNo()
{
	Set o=$INCREMENT(^WSHQ.Data.OutboundOrder)
	Return "OO"_$REPLACE($J(o,8)," ","0")
}

ClassMethod GetNewShipNo()
{
	Set o=$INCREMENT(^WSHQ.Data.OutboundOrder)
	Return "SO"_$REPLACE($J(o,8)," ","0")
}

Storage Default
{
<Data name="OutboundOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>オーダ日付</Value>
</Value>
<Value name="4">
<Value>出荷予定日付</Value>
</Value>
<Value name="5">
<Value>商品コード</Value>
</Value>
<Value name="6">
<Value>数量</Value>
</Value>
<Value name="7">
<Value>DC配信済み</Value>
</Value>
<Value name="8">
<Value>オーダ作成日時</Value>
</Value>
<Value name="9">
<Value>出荷先コード</Value>
</Value>
<Value name="10">
<Value>出荷番号</Value>
</Value>
<Value name="11">
<Value>DCコード</Value>
</Value>
</Data>
<DataLocation>^WSHQ.Data.OutboundOrderD</DataLocation>
<DefaultData>OutboundOrderDefaultData</DefaultData>
<IdLocation>^WSHQ.Data.OutboundOrderD</IdLocation>
<IndexLocation>^WSHQ.Data.OutboundOrderI</IndexLocation>
<StreamLocation>^WSHQ.Data.OutboundOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
