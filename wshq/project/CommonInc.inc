ROUTINE CommonInc [Type=INC]
#define NumOfItems 50

#define SQLERRCHECK If SQLCODE'=0,SQLCODE'=100 Throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,$G(%msg))
#define DSQLERRCHECK(%x) If %x.%SQLCODE'=0,%x.%SQLCODE'=100 Throw ##class(%Exception.SQL).CreateFromSQLCODE(%x.SQLCODE,%x.%Message)

#def1arg SQLARGS(%x) %x
#define SQLEXECQUERY(%x,%y,%z) Set %x=##class(%SQL.Statement).%ExecDirect(,%y,%z) Do %x.%Next() 
#define SQLEXECUPDATE(%x,%y,%z) Set %x=##class(%SQL.Statement).%ExecDirect(,%y,%z)

#define SQLEXECUTEQUERY(%x,%y,%z) Set %x=%y.%Execute(%z) Do %x.%Next() 
#define SQLEXECUTEUPDATE(%x,%y,%z) Set %x=%y.%Execute(%z)

#define THROWIFERROR(%x) If $$$ISERR(%x) { Throw ##class(%Exception.StatusException).CreateFromStatus(%x) } 

 // !!! It sets and kills zzplace,zzerrs,zzi variables !!!
#define CATCH(%x,%y) Do ##class(%SQL.Statement).%ExecDirect(,"ROLLBACK") ##continue 
 Do %x.Log() Set zzplace="" Set %y=%x.AsStatus() ##continue 
 if '%x.%IsA("SystemException"){ Do %x.StackAsArray(.zzerrs) f zzi=1:1:zzerrs { Set zzplace=zzerrs(zzi,"PLACE")_"/"_zzplace} Set zzplace=$C(13,10)_"Stack:"_zzplace  } ##continue
 $$$LOGERROR($SYSTEM.Status.GetErrorText(%y)_zzplace) k zzplace,zzerrs,zzi

 //#define DEBUG

#ifdef DEBUG

#define SQLDIRECTUPD(%x,%y,%z) ##Continue
 $$$SQLEXECUPDATE(%x,%y,%z) ##Continue
 w %y,! ##Continue
 $$$DSQLERRCHECK(%x)

#define SQLDIRECTQUERY(%x,%y,%z) ##Continue
 $$$SQLEXECQUERY(%x,%y,%z) ##Continue
 w %y,! ##Continue
 $$$DSQLERRCHECK(%x)
 
#define SQLPREUPD(%x,%y,%z) ##Continue
 $$$SQLEXECUTEUPDATE(%x,%y,%z) ##Continue
 If %y.%GetImplementationDetails(,.##Unique(new)) W ##Unique(old),! ##Continue
 $$$DSQLERRCHECK(%x)

#define SQLPREQUERY(%x,%y,%z) ##Continue
 $$$SQLEXECUTEQUERY(%x,%y,%z) ##Continue
 If %y.%GetImplementationDetails(,.##Unique(new)) W ##Unique(old),! ##Continue
 $$$DSQLERRCHECK(%x)

#Else

#define SQLDIRECTUPD(%x,%y,%z) ##Continue
 $$$SQLEXECUPDATE(%x,%y,%z) ##Continue
 $$$DSQLERRCHECK(%x)

#define SQLDIRECTQUERY(%x,%y,%z) ##Continue
 $$$SQLEXECQUERY(%x,%y,%z) ##Continue
 $$$DSQLERRCHECK(%x)

#define SQLPREUPD(%x,%y,%z) ##Continue
 $$$SQLEXECUTEUPDATE(%x,%y,%z) ##Continue
 $$$DSQLERRCHECK(%x)

#define SQLPREQUERY(%x,%y,%z) ##Continue
 $$$SQLEXECUTEQUERY(%x,%y,%z) ##Continue
 $$$DSQLERRCHECK(%x)

#Endif

