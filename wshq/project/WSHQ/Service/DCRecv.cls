Include CommonInc

Class WSHQ.Service.DCRecv Extends Ens.BusinessService
{

/// 倉庫から入荷確定情報の受信
/// DCでの入荷検品処理時に入荷確定分の情報を受け取り、在庫管理を更新する
Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Status
{

	Set %response.ContentType="application/json"
	Set %response.CharSet=%request.CharSet

	Set tSC=$$$OK
	Set resultContainer={}
	Set resultContainer.Messages=[]
	Set resultContainer.Count=0
	Try {
		Set st=$ZH
		Set req={}.%FromJSON(%request.Content)
		Set sql(1)="UPDATE WSHQ_Data.Inventory SET 商品入荷数量=商品入荷数量+? WHERE 商品コード=? and DCコード=?"
		For i=1:1:1 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$ThrowOnError(tSC)
		}
		
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set DCコード=req.WSDCName
		Set index=req.Count-1
		For i=0:1:index {
			Set order=req.Messages.%Get(i)
			Set 商品コード=order.商品コード
			Set 数量=order.数量
			#;$$$LOGINFO("入荷確定受信:商品コード"_商品コード_" 数量:"_数量)
			If 商品コード="" { $$$LOGERROR("不正な入荷確定受信:商品コード"_商品コード_" 数量:"_数量) }
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(数量,商品コード,DCコード))
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en=$ZH
		$$$LOGINFO("WSDCから入荷確定情報受信:"_req.Count_"件 経過(秒):"_(en-st))

	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	Set resultContainer.Status=tSC
	Do resultContainer.%ToJSON()
	
	Return tSC
}

}
