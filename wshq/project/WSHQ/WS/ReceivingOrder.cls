/// 入荷確定情報
Class WSHQ.WS.ReceivingOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

}
