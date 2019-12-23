/// 発注オーダ
Class WSHQ.Data.InboundOrder Extends %Persistent
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property メーカ配信済み As %Boolean [ InitialExpression = 0 ];

Property DC配信済み As %Boolean [ InitialExpression = 0 ];

Property オーダ受信日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

Property DCコード As %String;

Index idx配送予定日付 On 配送予定日付;

Index idxオーダ番号 On オーダ番号;

Index idxオーダ日付 On オーダ日付;

Index idxDC配信済み On DC配信済み;

Index idxDCコード On DCコード;

Index idxメーカ配信済み On メーカ配信済み;

// DCコード+商品コードのprimaryKeyは張らない事。同じ商品が繰り返し発注されることは当然ある。

/*
ClassMethod GetNewOrderNo()
{
	Set o=$INCREMENT(^WSHQ.Data.InboundOrder)
	Return "IO"_$REPLACE($J(o,8)," ","0")
}
*/
Storage Default
{
<Data name="InboundOrderDefaultData">
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
<Value>配送予定日付</Value>
</Value>
<Value name="5">
<Value>商品コード</Value>
</Value>
<Value name="6">
<Value>数量</Value>
</Value>
<Value name="7">
<Value>メーカ配信済み</Value>
</Value>
<Value name="8">
<Value>DC配信済み</Value>
</Value>
<Value name="9">
<Value>オーダ受信日時</Value>
</Value>
<Value name="10">
<Value>DCコード</Value>
</Value>
</Data>
<DataLocation>^WSHQ.Data.InboundOrderD</DataLocation>
<DefaultData>InboundOrderDefaultData</DefaultData>
<IdLocation>^WSHQ.Data.InboundOrderD</IdLocation>
<IndexLocation>^WSHQ.Data.InboundOrderI</IndexLocation>
<StreamLocation>^WSHQ.Data.InboundOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
