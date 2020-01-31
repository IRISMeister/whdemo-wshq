Include CommonInc

Class WSHQ.Service.DCIn Extends Ens.BusinessService
{

/// WSHQ.REST.Dispatcher(REST Dispatcher)からコールされる。
/// 発注オーダを倉庫(WSDC)から受信し、その要求を(1)メーカに送信 (2)本日入荷出来る分があれば、倉庫にも送信
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
		Set sql(1)="INSERT INTO WSHQ_Data.InboundOrder (DCコード,オーダ番号,オーダ日付,商品コード,数量) VALUES (?,?,?,?,?)"
		Set stmt(1)=##class(%SQL.Statement).%New()
		Set tSC=stmt(1).%Prepare(sql(1))
		$$$ThrowOnError(tSC)
		
		#;発注オーダを取得
		Set req={}.%FromJSON(%request.Content)

		Do ##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

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

		Do ##class(%SQL.Statement).%ExecDirect(,"COMMIT")

		Set en=$ZH
		$$$LOGINFO("WSDCから発注オーダを受信:"_req.Count_"件 経過(秒):"_(en-st))

		Set SendReq=##class(WSHQ.Req.SendInboundOrder).%New()
		Set SendReq.DestWSDC=req.WSDCName  ;"WSDC1"
		
		#;メーカへの発注情報作成・送信は、"MAKER" Operationで実施。ここはトリガを送信しているに過ぎない。
		#;"MAKER" Operationへの送信でエラーが発生しても、次回に再実行されるのでここでは何もしない。
		#;"MAKER" Operation上で送信エラーやクラッシュが発生した場合も、"MAKER"内でDBがロールバックされる(未処理状態に戻る)ので、やはり次回に再処理される。
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
