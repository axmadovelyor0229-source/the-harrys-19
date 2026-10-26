$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$enc = New-Object Text.UTF8Encoding $false
$t = [IO.File]::ReadAllText("$root\work\index.html")
$css = [IO.File]::ReadAllText("$root\src\v20.css")
$js = [IO.File]::ReadAllText("$root\src\v20_core.js") + "`n" + [IO.File]::ReadAllText("$root\src\v20_excel.js") + "`n" + [IO.File]::ReadAllText("$root\src\v20_equipment.js") + "`n" + [IO.File]::ReadAllText("$root\src\v20_boot.js")
$logo = [IO.File]::ReadAllText("$root\orig\logo.b64")

function Must($text, $needle) { if (-not $text.Contains($needle)) { throw "Marker not found: $needle" } }

# logo: one copy in CSS
$t = $t.Replace('<img src="__LOGO__" alt="the harry''s logo">', '<i class="hl-img" role="img" aria-label="the harry''s logo"></i>')
$t = $t.Replace('<img src="__LOGO__" alt="the harry''s">', '<i class="hl-img" role="img" aria-label="the harry''s"></i>')
if ($t.Contains('__LOGO__')) { throw 'Unreplaced logo placeholder' }
$js = $js.Replace('<img src="${document.querySelector(''.brand img'')?.src||''''}" alt="the harry''s">', '<i class="hl-img" role="img" aria-label="the harry''s"></i>')
$logoCss = "`n.hl-img{display:block;flex:none;width:32px;height:32px;background:url(`"$logo`") center/contain no-repeat;filter:drop-shadow(0 4px 10px rgba(0,0,0,.18))}.login-brand .hl-img{width:44px;height:44px}.expense-donut-center .hl-img{width:74px;height:74px;filter:none}@media(max-width:900px){.expense-donut-center .hl-img{width:66px;height:66px}}`n"

Must $t '</style>'
$i = $t.IndexOf('</style>')
$t = $t.Substring(0, $i) + $css + $logoCss + $t.Substring($i)

Must $t '/*__V20_LAYER__*/'
$t = $t.Replace('/*__V20_LAYER__*/', $js)

$early = "try{loadOperationalState()}catch(e){console.error('loadOperationalState',e)}"
$first = $t.IndexOf($early); $last = $t.LastIndexOf($early)
if ($first -ge 0 -and $first -ne $last) { $t = $t.Remove($first, $early.Length) }

[IO.File]::WriteAllText("$root\work\app.html", $t, $enc)
"built: " + (Get-Item "$root\work\app.html").Length + " bytes"
