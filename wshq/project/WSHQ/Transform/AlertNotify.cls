Class WSHQ.Transform.AlertNotify Extends Ens.DataTransformDTL [ DependsOn = (Ens.Alerting.NotificationRequest, Ens.Alerting.Context.Notify) ]
{

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.Alerting.NotificationRequest' targetClass='Ens.Alerting.Context.Notify' create='existing' language='objectscript' >
<assign value='1' property='target.Notify' action='set' />
<assign value='"EnsLib.EMail.AlertOperation"' property='target.Targets.(1).TargetConfigName' action='set' />
<if condition='..Contains(source.ManagedAlert.AlertGroups,"AlertGroupCallTask")' >
<true>
<assign value='"taskdev@localdomain.localhost"' property='target.Targets.(1).AlertDestinations' action='append' />
</true>
<false>
<assign value='"ensembledev@localdomain.localhost"' property='target.Targets.(1).AlertDestinations' action='append' />
</false>
</if>
</transform>
}

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

}
