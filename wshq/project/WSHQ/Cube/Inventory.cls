/// 
Class WSHQ.Cube.Inventory Extends %DeepSee.CubeDefinition [ DependsOn = WSHQ.Data.Inventory, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Inventory" displayName="Inventory" disabled="false" abstract="false" sourceClass="WSHQ.Data.Inventory" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
<expression name="ProductDetails" sourceExpression='%cube.GetProductDetails(%source.商品コード)'  />
  <dimension name="商品コード" disabled="false" hasAll="false" allCaption="All 商品コード" allDisplayName="商品コード" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="商品コード" disabled="false" sourceProperty="商品コード" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="商品" disabled="false" hasAll="true" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false">
     <level sourceExpression="$LI(%expression.ProductDetails,1)" name="メーカ" disabled="false" list="false" useDisplayValue="false">
       </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false">
     <level sourceExpression="$LI(%expression.ProductDetails,2)" name="分類" disabled="false" list="false" useDisplayValue="false">
       </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false">
     <level sourceExpression="$LI(%expression.ProductDetails,3)" name="リードタイム" disabled="false" list="false" useDisplayValue="false">
       </level>
    </hierarchy>
  </dimension>
  
  <dimension name="DCコード" disabled="false" hasAll="false" allCaption="All DCコード" allDisplayName="DCコード" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DCコード" disabled="false" sourceProperty="DCコード" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="商品入荷数量" disabled="false" sourceProperty="商品入荷数量" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="商品発注回数" disabled="false" sourceProperty="商品発注回数" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="商品発注数量" disabled="false" sourceProperty="商品発注数量" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="商品販売数量" disabled="false" sourceProperty="商品販売数量" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="実在庫" disabled="false" sourceProperty="実在庫" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="論理在庫" disabled="false" sourceProperty="論理在庫" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="販売欠品回数" disabled="false" sourceProperty="販売欠品回数" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="販売注文回数" disabled="false" sourceProperty="販売注文回数" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

ClassMethod GetProductDetails(prodid As %String) As %String
{
	Set makerid="",class="",leadtime=""
	Set sql="SELECT メーカコード,分類,リードタイム from Common.ProductMaster WHERE 商品コード=?"
 	Set rs=##class(%SQL.Statement).%ExecDirect(,sql,prodid) 
	Do rs.%Next()
	Set makerid=rs.メーカコード
	Set class=rs.分類
	Set leadtime=rs.リードタイム
 		
	Quit $LISTBUILD(makerid,class,leadtime)
}

Parameter DOMAIN;

}
