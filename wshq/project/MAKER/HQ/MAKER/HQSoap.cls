Class MAKER.HQ.MAKER.HQSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ReceivePurchaseOrder(req As MAKER.HQ.PurchaseOrderContainer) As MAKER.HQ.PurchaseOrderResultContainer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ReceivePurchaseOrder").Invoke($this,"http://tempuri.org/MAKER.Service.HQ.ReceivePurchaseOrder",.req)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://macbeth:52773/csp/WSDEMO/MAKER.Service.HQ.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "MAKER.HQ";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
