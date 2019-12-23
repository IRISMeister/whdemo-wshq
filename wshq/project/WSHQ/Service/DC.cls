Include (CommonInc, Ensemble)

Class WSHQ.Service.DC Extends EnsLib.SOAP.Service
{

Parameter ADAPTER;

Parameter SERVICENAME = "WSHQ.DC";

Parameter NAMESPACE = "http://tempuri.org";

Parameter USECLASSNAMESPACES = 1;

/// 発注オーダを倉庫から受信し、その要求を(1)メーカに送信 (2)本日入荷出来る分があれば、倉庫にも送信
/// 発注オーダを受信
Method ReceiveInboundOrder(req As WSHQ.WS.InboundOrderContainer) As %Status [ WebMethod ]
{
	Set tSC=$$$OK
	Try {
		Set st=$ZH
		Set sql(1)="INSERT INTO WSHQ_Data.InboundOrder (DCコード,オーダ番号,オーダ日付,商品コード,数量) VALUES (?,?,?,?,?)"
		Set stmt(1)=##class(%SQL.Statement).%New()
		Set tSC=stmt(1).%Prepare(sql(1))
		$$$THROWIFERROR(tSC)
		
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set DCコード=req.WSDCName
		Set count=req.Messages.Count()
		For i=1:1:count {
			Set order=req.Messages.GetAt(i)
			Set オーダ番号=order.オーダ番号
			Set オーダ日付=order."オーダ日付"
			Set 商品コード=order."商品コード"
			Set 数量=order."数量"
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(DCコード,オーダ番号,オーダ日付,商品コード,数量))
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en=$ZH
		$$$LOGINFO("WSDCから発注オーダを受信:"_count_"件 経過(秒):"_(en-st))

		Set SendReq=##class(WSHQ.Req.SendInboundOrder).%New()
		Set SendReq.DestWSDC=req.WSDCName  ;"WSDC1" ;ここはreqや送信元のサービス名などから取得すべき
		
		#;Operationへの送信でエラーが発生した場合、次回の受信時にあわせて再実行されるのでここでは何もしない。
		#;Operation上で送信エラーやクラッシュが発生した場合も、DBはロールバックされるので、次回の受信時にあわせて再送信される。
		#;こういう「キーだけ渡し」はトレース上は見通しがあまりよくないが、実装例としてこのままにしておく。
		#;Set tSC=..SendRequestSync("MAKER",SendReq,.response) 	//メーカに発注情報を送信
		Set tSC=..SendRequestSync("MAKERR",SendReq,.response) 	//メーカに発注情報を送信
		Set tSC=..SendRequestSync("WSDCRouter",SendReq,.response)  		//入荷予定をWSDCに送信
		

	}
	Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	}
	
	Return tSC
}

/// 倉庫から入荷確定情報の受信
/// DCでの入荷検品処理時に入荷確定分の情報を受け取り、在庫管理を更新する
ClassMethod ReceiveReceivingOrder(req As WSHQ.WS.ReceivingOrderContainer) As %Status [ WebMethod ]
{

#dim msg as WSDC.WS.ReceivingOrder
	Set tSC=$$$OK

	Try {
		Set st=$ZH
		Set sql(1)="UPDATE WSHQ_Data.Inventory SET 商品入荷数量=商品入荷数量+? WHERE 商品コード=? and DCコード=?"
		For i=1:1:1 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$THROWIFERROR(tSC)
		}
		
		Set rs=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set DCコード=req.WSDCName
		Set count=req.Messages.Count()
		For i=1:1:count {
			Set order=req.Messages.GetAt(i)
			Set 商品コード=order."商品コード"
			Set 数量=order."数量"
			#;$$$LOGINFO("入荷確定受信:商品コード"_商品コード_" 数量:"_数量)
			If 商品コード="" { $$$LOGERROR("不正な入荷確定受信:商品コード"_商品コード_" 数量:"_数量) }
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(数量,商品コード,DCコード))
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"COMMIT")
		Set en=$ZH
		$$$LOGINFO("WSDCから入荷確定情報受信:"_count_"件 経過(秒):"_(en-st))

	}
	Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	}
	
	Return tSC
}

}
