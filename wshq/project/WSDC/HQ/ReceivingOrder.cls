/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/WSDC.Service.HQ.CLS?WSDL=1
Class WSDC.HQ.ReceivingOrder Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "ReceivingOrder";

Parameter XMLSEQUENCE = 1;

Property オーダ番号 As %String(MAXLEN = "", XMLNAME = "オーダ番号");

Property オーダ日付 As %Date(XMLNAME = "オーダ日付");

Property 配送予定日付 As %Date(XMLNAME = "配送予定日付");

Property 商品コード As %String(MAXLEN = "", XMLNAME = "商品コード");

Property 数量 As %Numeric(XMLNAME = "数量");

Storage Default
{
<Data name="ReceivingOrderDefaultData">
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
</Data>
<DataLocation>^WSDC.HQ.ReceivingOrderD</DataLocation>
<DefaultData>ReceivingOrderDefaultData</DefaultData>
<IdLocation>^WSDC.HQ.ReceivingOrderD</IdLocation>
<IndexLocation>^WSDC.HQ.ReceivingOrderI</IndexLocation>
<StreamLocation>^WSDC.HQ.ReceivingOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
