Class WSHQ.Production.Production1 Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="WSHQ.Production.Production1" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="AlertNotificationManager">Ens.Alerting.NotificationManager</Setting>
  <Setting Target="Adapter" Name="AlertNotificationRecipients">appuser</Setting>
  <Setting Target="Adapter" Name="AlertNotificationOperation">WSHQ.Operation.DefaultAlert</Setting>
  <Item Name="InitiateOutboundOrder" Category="" ClassName="WSHQ.Service.InitiateOutboundOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="出荷指示" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="DCIn" Category="" ClassName="WSHQ.Service.DCIn" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="DCRecv" Category="" ClassName="WSHQ.Service.DCRecv" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="InitiateInboundOrderProcess" Category="" ClassName="WSHQ.Service.InitiateInboundOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">15</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="InitiatePseudoClock" Category="" ClassName="WSHQ.Service.InitiatePseudoClock" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="StorageNamespace">WSHQ</Setting>
  </Item>
  <Item Name="WSDC1" Category="" ClassName="WSHQ.Operation.WSDC" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="URL">/csp/wsdc/dispatcher/Receive</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">wsdc1</Setting>
    <Setting Target="Adapter" Name="Credentials">default</Setting>
  </Item>
  <Item Name="WSDC2" Category="" ClassName="WSHQ.Operation.WSDC" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="URL">/csp/wsdc/dispatcher/Receive</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">wsdc2</Setting>
    <Setting Target="Adapter" Name="Credentials">default</Setting>
  </Item>
  <Item Name="MAKER" Category="" ClassName="WSHQ.Operation.MAKER" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">maker</Setting>
    <Setting Target="Adapter" Name="URL">/csp/maker/dispatcher/ReceivePurchaseOrder</Setting>
    <Setting Target="Adapter" Name="Credentials">default</Setting>
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="WSDCRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">WSHQ.Production.WSDCRouterRoutingRule</Setting>
    <Setting Target="Host" Name="ForceSyncSend">1</Setting>
    <Setting Target="Host" Name="ResponseFrom">WSDC1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="Alert" ClassName="Ens.Alerting.AlertManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="CreateManagedAlertRule">WSHQ.Rule.ManagedAlert</Setting>
  </Item>
  <Item Name="Ens.Alerting.NotificationManager" Category="Alert" ClassName="Ens.Alerting.NotificationManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="NotificationTransform">WSHQ.Transform.AlertNotify</Setting>
  </Item>
  <Item Name="WSHQ.Operation.DefaultAlert" Category="Alert" ClassName="WSHQ.Operation.DefaultAlert" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.EMail.AlertOperation" Category="Alert" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SMTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="Credentials">ensemble-email</Setting>
    <Setting Target="Host" Name="IncludeDetails">1</Setting>
    <Setting Target="Host" Name="IncludeNodeinSubject">1</Setting>
    <Setting Target="Adapter" Name="From">ensemble-production@localdomain.localhost</Setting>
    <Setting Target="Adapter" Name="Recipient">reciveall@localdomain.localhost</Setting>
    <Setting Target="Host" Name="IncludeManagedAlertHistory">2</Setting>
  </Item>
</Production>
}

}
