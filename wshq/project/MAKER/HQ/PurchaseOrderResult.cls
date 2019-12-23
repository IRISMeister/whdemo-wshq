/// 次から作成されました: http://MACBETH:52773/csp/WSDEMO/MAKER.Service.HQ.CLS?WSDL=1
Class MAKER.HQ.PurchaseOrderResult Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "PurchaseOrderResult";

Parameter XMLSEQUENCE = 1;

Property オーダ番号 As %String(MAXLEN = "", XMLNAME = "オーダ番号");

Property 配送予定日付 As %Date(XMLNAME = "配送予定日付");

Storage Default
{
<Data name="PurchaseOrderResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>オーダ番号</Value>
</Value>
<Value name="3">
<Value>配送予定日付</Value>
</Value>
</Data>
<DataLocation>^MAKER.HQ.PurchaseOrderResultD</DataLocation>
<DefaultData>PurchaseOrderResultDefaultData</DefaultData>
<IdLocation>^MAKER.HQ.PurchaseOrderResultD</IdLocation>
<IndexLocation>^MAKER.HQ.PurchaseOrderResultI</IndexLocation>
<StreamLocation>^MAKER.HQ.PurchaseOrderResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
