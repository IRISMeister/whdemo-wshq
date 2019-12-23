/// 
Class WSHQ.Rule.ManagedAlert Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Alerting.Rule.CreateAlertAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Ens.Alerting.Context.CreateAlert" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="IsRecentManagedAlert(AlertRequest,300,1)">
<return>0</return>
</when>
<when condition="1">
<assign property="Owner" value="&quot;appuser&quot;"></assign>
<return>1</return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
