/// ダミーの日付を極短時間で進める
Class WSHQ.Service.InitiatePseudoClock Extends Ens.BusinessMetric
{

Method OnCalculateMetrics() As %Status
{
	#;ProductionやBusinessHost起動直後にいきなり1日進むのを抑止
	Set last=##class(Common.Util).GetTodayLastUpdate()
	Set elapsedTimeSec=$SYSTEM.SQL.DATEDIFF("ss",last,$H)
	Set interval=..Adapter.CallInterval
	If interval>elapsedTimeSec {
		$$$LOGINFO("skipping increment. interval:"_interval_" elapsedTimeSec:"_elapsedTimeSec)
		Quit $$$OK
	}
	Do ##class(Common.Util).IncrementToday()
	$$$LOGINFO("現在の日付:"_$ZDATE(##class(Common.Util).GetToday(),3))
	Quit $$$OK
}

}
