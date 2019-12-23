/// 過去に発注済みで、配送日待ちになっていたオーダ(WSHQ_Data.InboundOrder)を処理するための自発的な起動
Class WSHQ.Service.InitiateInboundOrder Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	Set tSC=$$$OK
	#;ToDo: 外部から取得するのが望ましい。wsdcはネームスペース名では無いので注意(一致させるのも良いかもしれない)
	For wsdc="WSDC1","WSDC2" {
		Set req=##class(WSHQ.Req.SendInboundOrder).%New()
		Set req.DestWSDC=wsdc
		Set tSC=..SendRequestSync("WSDCRouter",req,.response)
		If $$$ISERR(tSC) Quit
	}
	Return tSC
}

}
