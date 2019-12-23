/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.HQ.CLS?WSDL=1
Class WSDC.HQ.ShippingOrder Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ShippingOrder";

Parameter XMLSEQUENCE = 1;

Property オーダ番号 As %String(MAXLEN = "", XMLNAME = "オーダ番号");

Property 出荷番号 As %String(MAXLEN = "", XMLNAME = "出荷番号");

Property オーダ日付 As %Date(XMLNAME = "オーダ日付");

Property 出荷予定日付 As %Date(XMLNAME = "出荷予定日付");

Property 商品コード As %String(MAXLEN = "", XMLNAME = "商品コード");

Property 数量 As %Numeric(XMLNAME = "数量");

Property 出荷先コード As %String(MAXLEN = "", XMLNAME = "出荷先コード");

Storage Default
{
<Data name="ShippingOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>出荷番号</Value>
</Value>
<Value name="4">
<Value>オーダ日付</Value>
</Value>
<Value name="5">
<Value>出荷予定日付</Value>
</Value>
<Value name="6">
<Value>商品コード</Value>
</Value>
<Value name="7">
<Value>数量</Value>
</Value>
<Value name="8">
<Value>出荷先コード</Value>
</Value>
</Data>
<DataLocation>^WSDC.HQ.ShippingOrderD</DataLocation>
<DefaultData>ShippingOrderDefaultData</DefaultData>
<IdLocation>^WSDC.HQ.ShippingOrderD</IdLocation>
<IndexLocation>^WSDC.HQ.ShippingOrderI</IndexLocation>
<StreamLocation>^WSDC.HQ.ShippingOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
