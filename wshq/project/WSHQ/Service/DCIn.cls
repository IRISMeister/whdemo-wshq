Include CommonInc

Class WSHQ.Service.DCIn Extends Ens.BusinessService
{

/// 発注オーダを倉庫から受信し、その要求を(1)メーカに送信 (2)本日入荷出来る分があれば、倉庫にも送信
/// 発注オーダを受信
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
		Set sql(1)="INSERT INTO WSHQ_Data.InboundOrder (DCコード,オーダ番号,オーダ日付,商品コード,数量) VALUES (?,?,?,?,?)"
		Set stmt(1)=##class(%SQL.Statement).%New()
		Set tSC=stmt(1).%Prepare(sql(1))
		$$$ThrowOnError(tSC)
		
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set DCコード=req.WSDCName
		Set index=req.Count-1
		For i=0:1:index {
			Set order=req.Messages.%Get(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order.オーダ日付
			Set 商品コード=order.商品コード
			Set 数量=order.数量
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(DCコード,オーダ番号,オーダ日付,商品コード,数量))
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en=$ZH
		$$$LOGINFO("WSDCから発注オーダを受信:"_req.Count_"件 経過(秒):"_(en-st))

		Set SendReq=##class(WSHQ.Req.SendInboundOrder).%New()
		Set SendReq.DestWSDC=req.WSDCName  ;"WSDC1" ;ここはreqや送信元のサービス名などから取得すべき
		
		#;Operationへの送信でエラーが発生した場合、次回の受信時にあわせて再実行されるのでここでは何もしない。
		#;Operation上で送信エラーやクラッシュが発生した場合も、DBはロールバックされるので、次回の受信時にあわせて再送信される。
		#;こういう「キーだけ渡し」はトレース上は見通しがあまりよくないが、実装例としてこのままにしておく。
		Set tSC=..SendRequestSync("MAKER",SendReq,.response) 		//メーカに発注情報を送信
		Set tSC=..SendRequestSync("WSDCRouter",SendReq,.response)	//入荷予定をWSDCに送信
		

	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	Set resultContainer.Status=tSC
	Do resultContainer.%ToJSON()
	
	Return tSC
}

}
