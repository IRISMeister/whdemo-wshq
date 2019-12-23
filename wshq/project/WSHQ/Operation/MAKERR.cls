Include CommonInc

/// 発注情報をメーカに送信。応答に含まれる配送予定日付を発注情報(WSHQ_Data.InboundOrder)に反映。
Class WSHQ.Operation.MAKERR Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

// Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// 発注オーダレコードをメーカ(納品業者)に送信する。本部の商品管理台帳を更新する。
Method Exec(pRequest As WSHQ.Req.SendInboundOrder, Output pResponse As Ens.Response) As %Status
{

	Set tSC=$$$OK

	Try {
		Set st=$ZH
		Set pResponse=##class(Ens.Response).%New()

		Set sql(1)="Update WSHQ_Data.InboundOrder Set メーカ配信済み=1,配送予定日付=? WHERE オーダ番号=? AND DCコード=?"
		Set sql(2)="INSERT INTO WSHQ_Data.Inventory (DCコード,商品コード,商品発注数量) VALUES (?,?,?)"
		Set sql(3)="UPDATE WSHQ_Data.Inventory SET 商品発注数量=商品発注数量+?,商品発注回数=商品発注回数+1 WHERE 商品コード=? AND DCコード=?"
		
		For i=1:1:3 {		
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ COMMITTED")
		Set DCコード=pRequest.DestWSDC
		Set today=##class(Common.Util).GetToday() 
		#;この時点では配送予定日付は空なので条件として使えない
		Set sql="SELECT * FROM WSHQ_Data.InboundOrder WHERE オーダ日付<=? AND メーカ配信済み=0 and DCコード=?"
		$$$SQLDIRECTQUERY(rs,sql,$$$SQLARGS(today,DCコード))
		If rs.%SQLCODE=100 Quit

		Set rs0=##class(%SQL.Statement).%ExecDirect(,"START TRANSACTION")

		#;Set container=##class(MAKER.HQ.PurchaseOrderContainer).%New()
		#;Set container.WSDCName=DCコード
		Set container={}
		Set container.Count=0
		Set container.WSDCName=DCコード
		Set container.Messages=[]
		Do {
			#;w rs.オーダ番号,!
			Set container.Count=container.Count+1
			/*
			Set order=##class(MAKER.HQ.PurchaseOrder).%New()
			Set order."オーダ番号"=rs.オーダ番号
			Set order."オーダ日付"=rs."オーダ日付"
			Set order."商品コード"=rs."商品コード"
			Set order."数量"=rs."数量"
			Set id=rs.ID
			Do container.Messages.Insert(order)
			*/
			Set order={}
			Set order.オーダ番号=rs.オーダ番号
			Set order.オーダ日付=rs."オーダ日付"
			Set order.商品コード=rs."商品コード"
			Set order.数量=rs."数量"
			Set id=rs.ID
			Do container.Messages.%Push(order)
			
 			Set rs(2)=stmt(2).%Execute(DCコード,rs.商品コード,rs.数量) 
 			If rs(2).%SQLCODE=-119 {
				$$$SQLPREUPD(rs(3),stmt(3),$$$SQLARGS(rs.数量,rs.商品コード,DCコード))
 				If rs(3).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!")}
 			}
 			Else {
	 			If rs(2).%SQLCODE'=0 Write !,"SQLCODE:",rs(2).%SQLCODE," Error:",rs(2).%Message Throw ##class(%Exception.SQL).CreateFromSQLCODE(rs(2).SQLCODE,rs(2).%Message)
 			}
		} While (rs.%Next()) 


		#;Set tSC=..Adapter.InvokeMethod("ReceivePurchaseOrder",.WSResult,container)
		#; ContentTypeを設定する方法が不明。application/jsonにしたい。utf8にしたい。
		Set tSC=..Adapter.Post(.HttpResponse,,container.%ToJSON())
		If $$$ISERR(tSC) {
			#; throw
			Throw ##class(%Exception.StatusException).CreateFromStatus(tSC)
		}
		Set WSResult={}.%FromJSON(HttpResponse.Data)
		
		#;メーカからの応答に含まれる"配送予定日付"をWSHQ_Data.InboundOrderに反映。
		If $ISOBJECT(WSResult) {
			If $$$ISERR(WSResult.Status) { 
				$$$LOGERROR("メーカでエラー発生:"_$SYSTEM.Status.GetErrorText(WSResult.Status))
				;Throw?
			}
			Set cnt=0
			/*
			For i=1:1:WSResult.Messages.Count() {
				Set result=WSResult.Messages.GetAt(i)
				$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(result.配送予定日付,result.オーダ番号,DCコード))
				If result.配送予定日付=today { Set cnt=cnt+1 }
			}
			*/
			For i=0:1:WSResult.Count-1 {
				Set result=WSResult.Messages.%Get(i)
				$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(result.配送予定日付,result.オーダ番号,DCコード))
				If result.配送予定日付=today { Set cnt=cnt+1 }
			}

		}
		k rs
		Set rs0=##class(%SQL.Statement).%ExecDirect(,"COMMIT")

		Set en=$ZH
		#;$$$LOGINFO("本日入荷件数/総件数:"_cnt_"/"_container.Messages.Count()_" 経過(秒):"_(en-st))
		$$$LOGINFO("本日入荷件数/総件数:"_cnt_"/"_container.Count_" 経過(秒):"_(en-st))

	}
	 Catch e {
		#;掛け捨てのロールバック
		#;Exception発生時は$$$LOGINFOなども全て削除されてしまう(つまりデバッグ情報など入れても見れない)。何か回避策が望まれる。
		Set rs=##class(%SQL.Statement).%ExecDirect(,"ROLLBACK")
		Do e.Log()
		Set tSC = e.AsStatus()
		$$$LOGERROR($SYSTEM.Status.GetErrorText(tSC))
	 }
	 
	 k rs
	Set rs=##class(%SQL.Statement).%ExecDirect(,"SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
	Return tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="WSHQ.Req.SendInboundOrder"> 
		<Method>Exec</Method>
	</MapItem>
</MapItems>
}

}