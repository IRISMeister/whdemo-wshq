Class WSHQ.Data.Inventory Extends %Persistent
{

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 60;

Property 商品コード As %String;

Property 商品販売数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 商品発注数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 発注回数
Property 商品発注回数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 商品入荷数量 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 論理在庫 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {論理在庫} = {商品発注数量}-{商品販売数量} }, SqlComputed ];

Property 実在庫 As %Numeric(SCALE = 0) [ Calculated, SqlComputeCode = { Set {実在庫} = {商品入荷数量}-{商品販売数量} }, SqlComputed ];

/// 販売の注文を欠品により受け付け出来なかった回数
Property 販売欠品回数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

/// 販売の注文を受け付けた回数
Property 販売注文回数 As %Numeric(SCALE = 0) [ InitialExpression = 0 ];

Property 欠品率 As %Numeric(SCALE = 2) [ Calculated, SqlComputeCode = { Set {欠品率} = $SELECT({販売注文回数}=0:0,1:{販売欠品回数}/{販売注文回数}) }, SqlComputed ];

Property DCコード As %String;

Index idx商品コード On 商品コード;

Index pkey On (DCコード, 商品コード) [ PrimaryKey, Unique ];

ClassMethod Init()
{
	#;ToDo: 外部から取得するのが望ましい。wsdc<>ネームスペース名では無いので注意(一致させるのも良いかもしれない)
	For wsdc="WSDC1","WSDC2" {
		Do ..InitExec(wsdc)
	}
}

ClassMethod InitExec(wsdc As %String)
{
#define DECODE(%x) $ZSTRIP(%x,"<>P")
	
	Set file="/home/irisowner/MEDIS20130628.TXT"
	Try {
		Set sql1="INSERT INTO WSHQ_Data.Inventory (DCコード,商品コード,商品入荷数量,商品発注数量) VALUES (?,?,?,?)"
		Set stmt1=##class(%SQL.Statement).%New()
		Set tSC=stmt1.%Prepare(sql1)
		If $$$ISERR(tSC) { Throw ##class(%Exception.StatusException).CreateFromStatus(tSC) }

		Set fs=##class(%Stream.FileCharacter).%New()
		Set fs.Filename=file
		Set rec=fs.ReadLine()  //skip header line

 		Set DCコード=wsdc
		Set 平均出庫量=1000		//とりあえず固定で。WSDCのWSDC.Data.Inventoryの入荷数量の初期値(Init()内)と合わせる事。
		Set 安全在庫数=平均出庫量/2
		Set cnt=0

		While ('fs.AtEnd) {
			Set rec=fs.ReadLine()
			Set cnt=cnt+1 If cnt>1000 { Quit }
			Set 基準番号=$$$DECODE($P(rec,",",1))
			Set リードタイム=(基準番号#3)+5
				Set 商品コード=基準番号
				Set リードタイム=リードタイム
				Set 商品入荷数量=平均出庫量*(リードタイム+1)+安全在庫数  // *100  //初期の在庫数。(純粋な需要をはかるために一時的に100倍)
				Set 商品発注数量=商品入荷数量
				Set rs1=stmt1.%Execute(DCコード,商品コード,商品入荷数量,商品発注数量) 
				If rs1.%SQLCODE'=0,rs1.%SQLCODE'=100 Write !,"SQLCODE:",rs1.%SQLCODE," Error:",rs1.%Message ;Throw ##class(%Exception.SQL).CreateFromSQLCODE(rs1.SQLCODE,rs1.%Message)
		}
	}
	Catch e {
		Do e.Log()
		Set tSC = e.AsStatus()
		zw e
	}
}

Storage Default
{
<Data name="InventoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>商品コード</Value>
</Value>
<Value name="3">
<Value>商品販売数量</Value>
</Value>
<Value name="4">
<Value>商品発注数量</Value>
</Value>
<Value name="5">
<Value>商品入荷数量</Value>
</Value>
<Value name="6">
<Value>DCコード</Value>
</Value>
<Value name="7">
<Value>欠品回数</Value>
</Value>
<Value name="8">
<Value>注文回数</Value>
</Value>
<Value name="9">
<Value>販売欠品回数</Value>
</Value>
<Value name="10">
<Value>販売注文回数</Value>
</Value>
<Value name="11">
<Value>購入送信回数</Value>
</Value>
<Value name="12">
<Value>商品発注回数</Value>
</Value>
</Data>
<DataLocation>^WSHQ.Data.InventoryD</DataLocation>
<DefaultData>InventoryDefaultData</DefaultData>
<IdLocation>^WSHQ.Data.InventoryD</IdLocation>
<IndexLocation>^WSHQ.Data.InventoryI</IndexLocation>
<StreamLocation>^WSHQ.Data.InventoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
