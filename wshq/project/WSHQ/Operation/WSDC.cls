Include CommonInc

Class WSHQ.Operation.WSDC Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Property Adapter As EnsLib.SOAP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// 入荷(仕入)情報を倉庫に送信
/// 蓄積された入荷予定レコードを倉庫に送信する。
/// ただし、倉庫には本日入荷予定分のみ
Method DoInboundOrder(pRequest As WSHQ.Req.SendInboundOrder, Output pResponse As WSHQ.Res.SendInboundOrder) As %Status
{

	Set tSC=$$$OK

	Try {
		Set st=$ZH
		Set pResponse=##class(WSHQ.Res.SendInboundOrder).%New()
		Set DCコード=pRequest.DestWSDC
		Set pResponse.DestWSDC=DCコード
		#;倉庫送信
		Set sql(1)="Update WSHQ_Data.InboundOrder Set DC配信済み=1 WHERE ID=?"
		For i=1:1:1 {		
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		Set SendCount=0

		Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")

		Set today=##class(Common.Util).GetToday() 
		Set sql="SELECT * FROM WSHQ_Data.InboundOrder WHERE 配送予定日付<=? and DC配信済み=0 and メーカ配信済み=1 and DCコード=?"
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today,DCコード))
		If rs.%SQLCODE=100 Quit

		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		Set container=##class(WSDC.HQ.ReceivingOrderContainer).%New()
		Do {
			w rs.オーダ番号,!
			Set order=##class(WSDC.HQ.ReceivingOrder).%New()
			Set order."オーダ番号"=rs.オーダ番号
			Set order."オーダ日付"=rs."オーダ日付"
			Set order."配送予定日付"=rs."配送予定日付"
			Set order."商品コード"=rs."商品コード"
			Set order."数量"=rs."数量"
			Set id=rs.ID
			Do container.Messages.Insert(order)
			
			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(id))

		} While (rs.%Next()) 

		If container.Messages.Count()>0 {
			Set tSC=..Adapter.InvokeMethod("ReceiveInbound",.WSResult,container)
			If $$$ISERR(tSC) {
				#; throw
				Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
			}
			
			#;送信エラーの際には、sql2実行内容をロールバックしてしまう。=> 次回の再送対象になる。
			If $$$ISERR(WSResult) {
				$$$LOGERROR("WSDCへの入荷予定情報の送信に失敗:"_$SYSTEM.Status.GetErrorText(WSResult))
			}
		}

		k rs
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")

		Set SendCount=container.Messages.Count()
		Set pResponse.Status="OK"

	}
	 Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	 }
	Set en=$ZH
	If SendCount>0 { $$$LOGINFO("入荷情報送信:"_SendCount_"件送信 経過(秒):"_(en-st)) }

	k rs
	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	Return tSC
}

/// 販売情報を倉庫に送信
Method DoOutboundOrder(pRequest As WSHQ.Req.SendOutboundOrder, Output pResponse As WSHQ.Res.SendOutboundOrder) As %Status
{
	Set tSC=$$$OK

	Try {
		Set st=$ZH
		#;蓄積された販売情報を倉庫に送信する。
		Set pResponse=##class(WSHQ.Res.SendOutboundOrder).%New()
		Set pResponse.DestWSDC=pRequest.DestWSDC

		#;倉庫送信
		Set sql(1)="Update WSHQ_Data.OutboundOrder Set DC配信済み=1 WHERE ID=?"
		For i=1:1:1 {		
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		Set SendCount=0
				
		Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")

		Set sql="SELECT * FROM WSHQ_Data.OutboundOrder WHERE 出荷予定日付=? and DC配信済み=0"
		Set today=##class(Common.Util).GetToday() 
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today))
		If rs.%SQLCODE=100 Quit

		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")
		
		Set container=##class(WSDC.HQ.ShippingOrderContainer).%New()
		Do {
			w rs.オーダ番号,!
			Set order=##class(WSDC.HQ.ShippingOrder).%New()
			Set order."オーダ番号"=rs.オーダ番号
			Set order."出荷番号"=rs.出荷番号
			Set order."オーダ日付"=rs."オーダ日付"
			Set order."商品コード"=rs."商品コード"
			Set order."数量"=rs."数量"
			Set order.出荷予定日付=rs.出荷予定日付
			Set order.出荷先コード=rs.出荷先コード
			Set id=rs.ID
			Do container.Messages.Insert(order)

			$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(id))

		} While (rs.%Next()) 

		Set tSC=..Adapter.InvokeMethod("ReceiveOutbound",.WSResult,container)
		If $$$ISERR(tSC) {
			#; throw
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		k rs
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")

		Set SendCount=container.Messages.Count()
		Set pResponse.Status="OK"

	}
	 Catch e {
		#;掛け捨てのロールバック
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	 }
	Set en=$ZH,elapsed=en-st
	if elapsed>10 {
		$$$LOGWARNING("販売情報送信 :"_SendCount_"件送信 経過(秒):"_(elapsed))
	}
	Else {
		$$$LOGINFO("販売情報送信 :"_SendCount_"件送信 経過(秒):"_(elapsed))
	}
	k rs
	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	$$$DSQLERRCHECK(rs)
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSHQ.Req.SendInboundOrder"> 
		<Method>DoInboundOrder</Method>
	</MapItem>
	<MapItem MessageType="WSHQ.Req.SendOutboundOrder"> 
		<Method>DoOutboundOrder</Method>
	</MapItem>
</MapItems>
}

}
