Class WSHQ.DC.WSHQ.DCSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ReceiveInboundOrder(req As WSHQ.DC.InboundOrderContainer) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceiveInboundOrder").Invoke($this,"http://tempuri.org/WSHQ.Service.DC.ReceiveInboundOrder",.req)
}

Method ReceiveReceivingOrder(req As WSHQ.DC.ReceivingOrderContainer) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceiveReceivingOrder").Invoke($this,"http://tempuri.org/WSHQ.Service.DC.ReceiveReceivingOrder",.req)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://macbeth:52773/csp/WSDEMO/WSHQ.Service.DC.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "WSHQ.DC";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
