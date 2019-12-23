Class WSHQ.Util Extends %RegisteredObject
{

ClassMethod ClearAll() [ WebMethod ]
{
	Do ##class(WSHQ.Data.InboundOrder).%KillExtent() K ^WSHQ.Data.InboundOrder
	Do ##class(WSHQ.Data.OutboundOrder).%KillExtent() K ^WSHQ.Data.OutboundOrder
	Do ##class(WSHQ.Data.Inventory).%KillExtent()
	Do ##class(WSHQ.Data.Shortage).%KillExtent()
	
	#;初期在庫の作成
	Do ##class(WSHQ.Data.Inventory).Init()

	Do ##class(Ens.Purge).PurgeAll(.tDeletedCount,0,0,1)
	Do ##class(Ens.Director).CleanProduction()
}

}
