/// 入荷確定情報
Class WSHQ.WS.InboundOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Property オーダ番号 As %String;

Property オーダ日付 As %Date;

Property 配送予定日付 As %Date;

Property 商品コード As %String;

Property 数量 As %Numeric(SCALE = 0);

Property オーダ作成日時 As %TimeStamp [ InitialExpression = {$ZDATETIME($H,3)} ];

}
