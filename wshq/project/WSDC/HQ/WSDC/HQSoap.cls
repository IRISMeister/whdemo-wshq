Class WSDC.HQ.WSDC.HQSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ReceiveInbound(req As WSDC.HQ.ReceivingOrderContainer) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceiveInbound").Invoke($this,"http://tempuri.org/WSDC.Service.HQ.ReceiveInbound",.req)
}

Method ReceiveOutbound(req As WSDC.HQ.ShippingOrderContainer) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceiveOutbound").Invoke($this,"http://tempuri.org/WSDC.Service.HQ.ReceiveOutbound",.req)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://macbeth:52773/csp/WSDEMO/WSDC.Service.HQ.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "WSDC.HQ";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
