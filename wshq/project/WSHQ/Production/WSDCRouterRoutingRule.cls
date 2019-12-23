/// 
Class WSHQ.Production.WSDCRouterRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="WSHQ.Production.Production1">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="r1">
<when condition="Document.DestWSDC=&quot;WSDC1&quot;">
<send transform="" target="WSDC1"></send>
<return></return>
</when>
<when condition="Document.DestWSDC=&quot;WSDC2&quot;">
<send transform="" target="WSDC2"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
