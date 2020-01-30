Include CommonInc

/// 販売情報の作成及び出荷指示の送信
Class WSHQ.Service.InitiateOutboundOrder Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	#;他のプロダクションの起動を待つ(固定で10秒)
	Set interval=10
	Set ProductionStartTime=$ZDATETIMEH($$$EnsRuntime("StartTime"),3)
	Set elapsedTimeSec=$SYSTEM.SQL.DATEDIFF("ss",ProductionStartTime,$ZTIMESTAMP)
	If elapsedTimeSec<interval {
		$$$LOGINFO("skipping OnCalculateMetrics interval:"_interval_" elapsedTimeSec:"_elapsedTimeSec)
		Return $$$OK
	}
	Set tSC=$$$OK
	#;ToDo: 外部から取得するのが望ましい。wsdcはネームスペース名では無いので注意(一致させるのも良いかもしれない)
	For wsdc="WSDC1","WSDC2" {
		Set tSC=..Exec(wsdc)  //ToDo: error check?
		If $$$ISERR(tSC) Quit
	}
	Return tSC
}

Method Exec(wsdc As %String) As %Status
{
	Set tSC=$$$OK
	Try {
		#;Pendingの入荷オーダをリトライする
		Set tSC=..ResendPendingOutboundOrder(wsdc)
		$$$THROWIFERROR(tSC)

		#;入荷オーダを新規作成
		Set tSC=..CreateOutboundOrder(wsdc)
		$$$THROWIFERROR(tSC)

		Set req=##class(WSHQ.Req.SendOutboundOrder).%New()
		Set req.DestWSDC=wsdc
		Set tSC=..SendRequestSync("WSDCRouter",req,.response)
		$$$THROWIFERROR(tSC)
	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	 
	 Return tSC
}

/// 販売オーダ(出荷オーダ)作成
/// 商品の選択や個数はは全くの乱数。
ClassMethod CreateOutboundOrder(wsdc As %String) As %Status
{
	Set tSC=$$$OK
	Try {
		Set sql(1)="INSERT INTO WSHQ_Data.OutboundOrder (DCコード,オーダ番号,出荷番号,オーダ日付,出荷予定日付,出荷先コード,商品コード,数量) VALUES (?,?,?,?,?,?,?,?)"
		Set sql(2)="SELECT 商品コード,売れ筋係数 FROM Common.ProductMaster WHERE ID=?"
		Set sql(3)="SELECT 実在庫,論理在庫 FROM WSHQ_Data.Inventory WHERE 商品コード=?"
		Set sql(4)="SELECT 1"
		Set sql(5)="UPDATE WSHQ_Data.Inventory SET 商品販売数量=商品販売数量+?,販売注文回数=販売注文回数+1 WHERE 商品コード=? AND DCコード=?"
		Set sql(6)="DELETE FROM WSHQ_Data.Shortage WHERE 商品コード=?"
		Set sql(7)="SELECT * FROM Common.ProductMaster WHERE ID<? ORDER BY ID ASC"

		For i=1:1:7 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			$$$THROWIFERROR(tSC)
		}

		Set today=##class(Common.Util).GetToday()
		Set isWeekend=0
		Set dayOfWeek=$SYSTEM.SQL.DAYOFWEEK(today) If (dayOfWeek=1)!(dayOfWeek=7) Set isWeekend=1

		#;以下、出荷先別に商品の出荷情報を生成するロジック。商品ごとに偏り(売れ筋)を出しつつ、適度なバラつきを持たせたいが...。
		#;このロジックだと、商品のIDが($$$NumOfItems+10)*2以降の商品は(まず)現れない。良いロジックが思い浮かばない。
		For i=1:1:10 {  // 出荷先コード
			Set 出荷番号=##class(WSHQ.Data.OutboundOrder).GetNewShipNo()
			#;オーダに含まれる商品の種類数
			Set NumOfItems=$R($$$NumOfItems)+10
			
			;Set maxid=##class(Common.ProductMaster).GetLastId()
			#;オーダに含まれる商品の種類数を5倍してるのは適当。データを確認いやすいよう、扱う全商品の種類数を制限している。
			Set maxid=$$$NumOfItems*5  ;少なすぎると商品の重複チェックが無限ループするので注意

			kill productSet
			Set cnt=1
			$$$SQLPREQUERY(rs(7),stmt(7),$$$SQLARGS(maxid)) Do rs(7).%Next()
			Do {
				Set 商品コード=rs(7).商品コード
				Set 売れ筋係数=rs(7).売れ筋係数
				If ($R(10)+1)<=(売れ筋係数*10) {Set productSet(cnt)=商品コード Set cnt=cnt+1 }
				If cnt>NumOfItems Quit
			} While (rs(7).%Next())
		
			If cnt<NumOfItems Set NumOfItems=cnt
			
			For j=1:1:NumOfItems {
						
				Set オーダ番号=##class(WSHQ.Data.OutboundOrder).GetNewOrderNo()
				Set オーダ日付=today
				Set 出荷先コード=##class(Common.CustomerMaster).GetCustomerCode(i)

				#;同一出荷先への出荷に商品の重複はないものとする
				/*
				Do {
					Set productRowid=$R(maxid)+1
					
				} While($D(productSet(productRowid)))
				Set productSet(productRowid)=""
				*/

				/*
				$$$SQLPREQUERY(rs(2),stmt(2),$$$SQLARGS(productRowid))
				Set 商品コード=rs(2).商品コード
				Set 売れ筋係数=rs(2).売れ筋係数
				Set 数量=$NUMBER(($R(10)+20)*売れ筋係数,0)  ;売れ筋係数は0.1～1.0の範囲。乱数>ベースにしてしまうと偏差が大きくなりすぎる。
				*/
				Set 商品コード=productSet(j)
				Set 数量=($R(10)+20)+$SELECT(isWeekend=1:20,1:0) //週末は数が多い
				
				#;在庫の確認
				#;実在庫<販売数量の場合、即日(出荷予定日付=today)でオーダを満たせない。->出荷予定日付はヌルのまま。
				#;在庫不足の場合、即時発注オーダを発行するべきか？
				
				$$$SQLPREQUERY(rs(3),stmt(3),$$$SQLARGS(商品コード))
				If rs(3).%SQLCODE=100 { $$$LOGERROR("shoudn't happen") continue}
				If (rs(3).実在庫<数量) { 
					#;欠品情報を登録
					Do ..StoreShortageInfo(商品コード,rs(3).実在庫,数量)
					
					Set 出荷予定日付=""

					#;発注オーダを実行？
					#;ToDo
				}
				Else { 
					$$$SQLPREUPD(rs(6),stmt(6),$$$SQLARGS(商品コード))

					Set 出荷予定日付=today
					#;在庫情報を更新
					$$$SQLPREUPD(rs(5),stmt(5),$$$SQLARGS(数量,商品コード,wsdc))
		 			If rs(5).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!") continue}
				}

				$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(wsdc,オーダ番号,出荷番号,オーダ日付,出荷予定日付,出荷先コード,商品コード,数量))
			}
			
		}
	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	 
	Return tSC
}

ClassMethod StoreShortageInfo(商品コード, 実在庫数, 発注数) As %Status
{
	Set tSC=$$$OK
	Try {
		Set sql(1)="INSERT INTO WSHQ_Data.Shortage (商品コード,実在庫数,発注数,記録日時) VALUES (?,?,?,?)"
		Set sql(2)="UPDATE WSHQ_Data.Shortage Set 実在庫数=?,発注数=?,記録日時=? WHERE 商品コード=?"
		Set sql(3)="UPDATE WSHQ_Data.Inventory SET 販売欠品回数=販売欠品回数+1 WHERE 商品コード=?"

		For i=1:1:3 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}
		Set 記録日時=$ZDATETIME($H,3)
		Set rs(1)=stmt(1).%Execute(商品コード,実在庫数,発注数,記録日時) 
		If rs(1).%SQLCODE=-119 {
			$$$SQLPREUPD(rs(2),stmt(2),$$$SQLARGS(実在庫数,発注数,記録日時,商品コード))
			If rs(2).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!") Quit}
		}
		Else {
			$$$DSQLERRCHECK(rs(1)) 
		}
		
		$$$SQLPREUPD(rs(3),stmt(3),$$$SQLARGS(商品コード))

	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	 
	Return tSC
}

ClassMethod ResendPendingOutboundOrder(wsdc As %String) As %Status
{
	Set tSC=$$$OK
	Try {
		Set sql(1)="UPDATE WSHQ_Data.OutboundOrder Set 出荷予定日付=? where ID=?"
		Set sql(2)="SELECT 実在庫,論理在庫 FROM WSHQ_Data.Inventory WHERE 商品コード=? AND DCコード=?"
		Set sql(3)="INSERT INTO WSHQ_Data.DiscardedByShortage (DCコード,商品コード,実在庫数,発注数,記録日時) VALUES (?,?,?,?,?)"
		Set sql(4)="UPDATE WSHQ_Data.Inventory SET 商品販売数量=商品販売数量+? WHERE 商品コード=? AND DCコード=?"
		Set sql(5)="DELETE FROM WSHQ_Data.Shortage WHERE 商品コード=?"
		Set sql(6)="DELETE FROM WSHQ_Data.OutboundOrder where ID=?"
		

		For i=1:1:6 {
			Set stmt(i)=##class(%SQL.Statement).%New()
			Set tSC=stmt(i).%Prepare(sql(i))
			If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }
		}

		Set sql="SELECT * FROM WSHQ_Data.OutboundOrder where DCコード=? AND 出荷予定日付 is null and オーダ日付<?" //オーダ日と同じ日には再処理しない
		Set today=##class(Common.Util).GetToday() 

		Set rs=##class(%SQL.Statement).%ExecDirect(,sql,wsdc,today) Do rs.%Next() 
		$$$DSQLERRCHECK(rs) 
		If rs.%SQLCODE=100 Quit

		Set 出荷予定日付=today
		Do {
			w !,rs.オーダ番号
			Set id=rs.ID
			Set 商品コード=rs.商品コード
			Set 数量=rs.数量

			#;在庫の確認
			$$$SQLPREQUERY(rs(2),stmt(2),$$$SQLARGS(商品コード,wsdc))
			If rs(2).%SQLCODE=100 { $$$LOGERROR("shoudn't happen") Continue}
			If (rs(2).実在庫<数量) { 
				Do ..StoreShortageInfo(商品コード,rs(2).実在庫,数量)
				#;この時点でいまだに商品不足の場合、要求自身を削除する
				#;ToDo: これでは、出荷数で需要を計算しているロジックに実際の需要が反映されない。
				$$$SQLPREUPD(rs(6),stmt(6),$$$SQLARGS(id))

				$$$SQLPREUPD(rs(3),stmt(3),$$$SQLARGS(wsdc,商品コード,rs(2).実在庫,数量,$ZDATETIME($H,3)))
				#;$$$LOGWARNING("在庫不足により出荷指示を破棄　商品コード:"_商品コード_"　数量:"_数量_"  実在庫数:"_rs(2).実在庫)
				Continue
			}
			Else { 
				$$$SQLPREUPD(rs(5),stmt(5),$$$SQLARGS(商品コード))
				$$$SQLPREUPD(rs(1),stmt(1),$$$SQLARGS(出荷予定日付,id))
				
				#;在庫情報を更新
				$$$SQLPREUPD(rs(4),stmt(4),$$$SQLARGS(数量,商品コード,wsdc))
 				If rs(4).%SQLCODE=100 { $$$LOGERROR("shouldn't happen!!!") continue}
			}

		} While (rs.%Next())
	}
	Catch e {
		$$$CATCH(e,tSC)
	}
	 
	Return tSC
}

}
