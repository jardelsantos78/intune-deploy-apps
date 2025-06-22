# --- Importações e Inicialização ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

$exePreenchidoAutomaticamente = $false

# Temas
$theme = @{
    Light = @{
        BackColor = [Drawing.Color]::White
        ForeColor = [Drawing.Color]::Black
        InputBack = [Drawing.Color]::White
        InputFore = [Drawing.Color]::Black
    }
    Dark = @{
        BackColor = [Drawing.Color]::FromArgb(0,8,10)
        ForeColor = [Drawing.Color]::White
        InputBack = [Drawing.Color]::FromArgb(10,20,25)
        InputFore = [Drawing.Color]::White
    }
}

# Labels
$lang = @{
    Title = "Intune Desktop Packager"
    ExeLabel = "Aplicativo IntuneWinAppUtil.exe :"
    SourceLabel = "Caminho de Origem dos arquivos :"
    FileLabel = "Arquivo de Instalação (.exe, .bat, .ps1 etc) :"
    OutputLabel = "Salvar .intunewin em :"
    Selecionar = "Selecionar"
    Execute = "Criar .intunewin"
    Limpar = "Limpar Formulário"
    Download = "Baixar IntuneWinAppUtil.exe"
    SuccessMessage = "Arquivo .intunewin criado com sucesso!"
    ErrorMessage = "Falha ao criar o arquivo .intunewin."
    WarningMessage = "O arquivo já existe. Para sobreescrever, clique em OK."
    WarningMessage1 = "Aviso"
    WarningMessage2 = "Sucesso"
    ErrorMessage1 = "Erro"
    AllFieldsWarning = "Preencha todos os campos."
    ExeNotFound = "IntuneWinAppUtil.exe não foi localizado."
    DarkMode = " Modo Escuro"
}

# --- Funções Utilitárias ---
function Verificar-CaminhoScript {
    try {
        if ($PSScriptRoot) {
            return $PSScriptRoot
        } elseif ($MyInvocation.MyCommand.Path) {
            return (Split-Path -Parent $MyInvocation.MyCommand.Path)
        } else {
            return (Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName))
        }
    } catch {
        Write-Warning "Erro ao determinar diretório do script: $_"
        return $null
    }
}
function Test-ImagemDisponivel {
    param([string]$path)
    if (Test-Path $path) {
        try {
            $stream = [System.IO.File]::Open($path, 'Open', 'Read', 'None')
            $stream.Close()
            return $true
        } catch { return $false }
    }
    return $false
}

function Baixar-ArquivoSeNecessario {
    param (
        [string]$caminhoArquivo,
        [string]$url
    )
    if (-not (Test-Path $caminhoArquivo)) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $caminhoArquivo -UseBasicParsing
        } catch {
            Write-Warning "Falha ao baixar arquivo '$caminhoArquivo': $_"
        }
    }
}

function Carregar-ImagemSegura {
    param ([string]$caminhoImagem)
    try {
        $fs = [System.IO.File]::Open($caminhoImagem, 'Open', 'Read', 'ReadWrite')
        $img = [System.Drawing.Image]::FromStream($fs)
        $fs.Close()
        return $img
    } catch {
        Write-Warning "Erro ao carregar imagem: $_"
        return $null
    }
}

function Mostrar-AlertaTemporizado {
    param (
        [string]$titulo,
        [string]$mensagem,
        [string]$iconeUrl = "https://i.ibb.co/LdCz0SYm/warning-icon.png"
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = $titulo
    $form.Size = '500,180'
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.ControlBox = $false
    $form.TopMost = $true
    $form.BackColor = [System.Drawing.Color]::White

    $imgTemp = "$env:TEMP\warning-icon.png"
    Baixar-ArquivoSeNecessario -caminhoArquivo $imgTemp -url $iconeUrl
    $image = Carregar-ImagemSegura -caminhoImagem $imgTemp

    if ($image) {
        $pictureBox = New-Object Windows.Forms.PictureBox
        $pictureBox.Image = $image
        $pictureBox.SizeMode = "StretchImage"
        $pictureBox.Size = '48,48'
        $pictureBox.Location = '20,35'
        $form.Controls.Add($pictureBox)
    }

    $label = New-Object Windows.Forms.Label
    $label.Text = $mensagem
    $label.Font = New-Object Drawing.Font("Segoe UI", 10)
    $label.AutoSize = $true
    $label.MaximumSize = '400,0'   # Limita largura e permite quebra
    $label.Location = '80,35'
    $label.TextAlign = 'MiddleLeft'
    $form.Controls.Add($label)

    $null = $form.Show()
    Start-Sleep -Seconds 5
    $form.Close()
}

function Mostrar-Mensagem {
    param (
        [string]$mensagem,
        [string]$titulo = "Mensagem",
        [string]$botao = "OK",
        [string]$icone = "Information"
    )
    [Windows.Forms.MessageBox]::Show($mensagem, $titulo, $botao, $icone) | Out-Null
}

function Registrar-Log {
    param (
        [string]$evento,
        [string]$exe,
        [string]$src,
        [string]$file,
        [string]$out,
        [string]$status = '',
        [Nullable[TimeSpan]]$duracao = $null,
        [string]$saida = ''
    )

    $logPath = Join-Path $scriptDir "Intune-Packager.log"
    $timestamp = (Get-Date).ToString("dd-MM-yyyy HH:mm:ss")
    $user = "$env:USERNAME ($env:USERDOMAIN\$env:USERNAME)"
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $psv = $PSVersionTable.PSVersion.ToString()
	$exeVer = if (Test-Path $exe) {
		(Get-Item $exe).VersionInfo.FileVersion
	} else {
		"?"
	}
    $fileInfo = Get-Item -Path $file -ErrorAction SilentlyContinue
    $fileSize = if ($fileInfo) { "{0:N1} MB" -f ($fileInfo.Length / 1MB) } else { "?" }
    $fileHash = if ($fileInfo) { (Get-FileHash -Path $file -Algorithm SHA256).Hash } else { "?" }

    $msg = @"
[$timestamp] $evento
   Usuário: $user
   OS: $os | PowerShell: $psv
   EXE: $exe | Versão: $exeVer
   SRC: $src
   FILE: $(Split-Path $file -Leaf) | Tamanho: $fileSize | SHA256: $fileHash
   OUT: $out
"@

    if ($status) { $msg += "   STATUS: $status`n" }
    if ($duracao) { $msg += "   Duração: $($duracao.ToString())`n" }
    if ($saida) { $msg += "   Saída: $saida`n" }

    $msg += "`n"
    Add-Content -Path $logPath -Value $msg -Encoding UTF8
}
# --- Diretório do Script ---
$scriptDir = Verificar-CaminhoScript
if (-not $scriptDir) {
    Mostrar-Mensagem -mensagem "Erro: Caminho do script não pôde ser determinado." -titulo "Erro Crítico" -icone "Error"
    exit
}

$SaveDataPath = Join-Path $scriptDir "SaveData.json"

# --- Salvar/Carregar configurações ---
function Carregar-Configuracao {
    if (Test-Path $SaveDataPath) {
        try {
            $data = Get-Content $SaveDataPath -Raw | ConvertFrom-Json
            $textBoxExe.Text  = $data.ExePath
            $textBoxSrc.Text  = $data.SourcePath
            $textBoxFile.Text = $data.FilePath
            $textBoxOut.Text  = $data.OutputPath
            $checkDark.Checked = $data.DarkMode
        } catch {}
    }
}

function Salvar-Configuracao {
    $data = @{
        ExePath    = $textBoxExe.Text
        SourcePath = $textBoxSrc.Text
        FilePath   = $textBoxFile.Text
        OutputPath = $textBoxOut.Text
        DarkMode   = $checkDark.Checked
    } | ConvertTo-Json
    $data | Set-Content $SaveDataPath
}

# --- Controles reutilizáveis para UI ---
function Select-Folder {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($dialog.ShowDialog() -eq 'OK') {
        return $dialog.SelectedPath
    } else {
        return $null
    }
}
function Select-File {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Todos os arquivos (*.*)|*.*"
    $dialog.Title = "Selecione um arquivo"
    if ($dialog.ShowDialog() -eq "OK") {
        return $dialog.FileName
    } else {
        return $null
    }
}
function New-Label { param($text, $location)
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Location = $location
    $lbl.Size = '400,20'
    $lbl.Font = New-Object Drawing.Font("Segoe UI",9.5,[Drawing.FontStyle]::Bold)
    return $lbl
}
function New-TextBox { param($location)
    $txt = New-Object Windows.Forms.TextBox
    $txt.Location = $location
    $txt.Size = '400,20'
    return $txt
}
function New-Button { param($text, $location, [ScriptBlock]$onClick, $size = '80,23')
    $btn = New-Object Windows.Forms.Button
    $btn.Text = $text
    $btn.Location = $location
    $btn.Size = $size
    $btn.Font = New-Object Drawing.Font("Segoe UI",9.5,[Drawing.FontStyle]::Bold)
    $btn.Add_Click($onClick)
    return $btn
}

# --- Aplicação de tema (claro ou escuro) ---
function Apply-Theme ($themeSet) {
    $form.BackColor = $themeSet.BackColor
    $form.ForeColor = $themeSet.ForeColor
    foreach ($ctrl in $form.Controls) {
        $ctrl.ForeColor = $themeSet.ForeColor
        if ($ctrl -is [System.Windows.Forms.TextBox] -or $ctrl -is [System.Windows.Forms.Button]) {
            $ctrl.BackColor = $themeSet.InputBack
            $ctrl.ForeColor = $themeSet.InputFore
        }
    }
}
function Mostrar-BarraProgresso {
    $progressForm = New-Object Windows.Forms.Form
    $progressForm.Text = "Empacotando arquivo..."
    $progressForm.Size = '400,100'
    $progressForm.StartPosition = "CenterScreen"
    $progressForm.FormBorderStyle = "FixedDialog"
    $progressForm.ControlBox = $false
    $progressForm.TopMost = $true

    $label = New-Object Windows.Forms.Label
    $label.Text = "Aguarde enquanto o arquivo está sendo empacotado..."
    $label.AutoSize = $true
    $label.Location = '10,10'
    $progressForm.Controls.Add($label)

    $progressBar = New-Object Windows.Forms.ProgressBar
    $progressBar.Location = '10,35'
    $progressBar.Size = '360,20'
    $progressBar.Style = 'Marquee'
    $progressBar.MarqueeAnimationSpeed = 30
    $progressForm.Controls.Add($progressBar)

    $job = Start-Job {
        Start-Sleep -Seconds 999 # Simulação longa — será encerrado externamente
    }

    $progressForm.Tag = $job
    return $progressForm
}
# --- Construção do Formulário Principal ---

$form = New-Object Windows.Forms.Form
$form.Text = $lang.Title
$form.Size = '700,400'
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::White

$iconPath = Join-Path $scriptDir "Intune-Desktop-Manager.ico"
if (Test-Path $iconPath) {
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
}

[int]$x = 180

# Campo EXE
$form.Controls.Add((New-Label $lang.ExeLabel "$x,20"))
$textBoxExe = New-TextBox "$x,40"
$form.Controls.Add($textBoxExe)
$btnSelectExe = New-Button $lang.Selecionar "$($x + 410),38" { $textBoxExe.Text = Select-File }
$form.Controls.Add($btnSelectExe)

# Origem
$form.Controls.Add((New-Label $lang.SourceLabel "$x,70"))
$textBoxSrc = New-TextBox "$x,90"
$form.Controls.Add($textBoxSrc)
$form.Controls.Add((New-Button $lang.Selecionar "$($x + 410),88" { $textBoxSrc.Text = Select-Folder }))

# Arquivo de Instalação
$form.Controls.Add((New-Label $lang.FileLabel "$x,120"))
$textBoxFile = New-TextBox "$x,140"
$form.Controls.Add($textBoxFile)
$form.Controls.Add((New-Button $lang.Selecionar "$($x + 410),138" {
    $initialDir = $textBoxSrc.Text
    if (-not (Test-Path $initialDir)) {
        $initialDir = $scriptDir  # Fallback para o diretório do script
    }

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = $initialDir
    $dialog.Filter = "Arquivos de Instalação (*.exe;*.bat;*.ps1)|*.exe;*.bat;*.ps1|Todos os arquivos (*.*)|*.*"
    $dialog.Title = "Selecione o arquivo de instalação"

    if ($dialog.ShowDialog() -eq "OK") {
        $textBoxFile.Text = $dialog.FileName
    }
}))

# Saída
$form.Controls.Add((New-Label $lang.OutputLabel "$x,170"))
$textBoxOut = New-TextBox "$x,190"
$form.Controls.Add($textBoxOut)
$form.Controls.Add((New-Button $lang.Selecionar "$($x + 410),188" { $textBoxOut.Text = Select-Folder }))

# Botão Criar
$btnRun = New-Button $lang.Execute "$x,230" {
    $exe = $textBoxExe.Text
    $src = $textBoxSrc.Text
    $file = $textBoxFile.Text
    $out = $textBoxOut.Text
	
    if (-not ($exe -and $src -and $file -and $out)) {
        Mostrar-Mensagem -mensagem $lang.AllFieldsWarning -titulo $lang.WarningMessage1 -icone "Error"
        return
    }
	Registrar-Log "Iniciando conversão" $exe $src $file $out
	
    if (-not (Test-Path $exe) -or -not (Test-Path $file)) {
        Mostrar-Mensagem -mensagem "Verifique os caminhos dos arquivos." -titulo $lang.ErrorMessage1 -icone "Error"
        return
    }

    $outputFile = Join-Path $out ("{0}.intunewin" -f ([IO.Path]::GetFileNameWithoutExtension($file)))
    if (Test-Path $outputFile) {
        $c = [Windows.Forms.MessageBox]::Show($lang.WarningMessage + "`n$outputFile", $lang.WarningMessage1, "OKCancel", "Warning")
        if ($c -eq "Cancel") { return }
        Remove-Item $outputFile -Force
    }

	$startTime = Get-Date
	Registrar-Log "Iniciando conversão" $exe $src $file $out

	# Mostra barra de progresso
	$progressForm = Mostrar-BarraProgresso
	$null = $progressForm.Show()

	try {
		Start-Process -FilePath $exe -ArgumentList "-c `"$src`" -s `"$file`" -o `"$out`"" -WindowStyle Hidden -Wait
		$dur = (Get-Date) - $startTime
		$progressForm.Close()

		$outputFile = Join-Path $out ("{0}.intunewin" -f ([IO.Path]::GetFileNameWithoutExtension($file)))
		if (Test-Path $outputFile) {
			Mostrar-Mensagem -mensagem $lang.SuccessMessage -titulo $lang.WarningMessage2 -icone "Information"
			Registrar-Log "Conversão concluída com sucesso" $exe $src $file $out -status "SUCESSO" -duracao $dur -saida $outputFile
		} else {
			Mostrar-Mensagem -mensagem $lang.ErrorMessage -titulo $lang.ErrorMessage1 -icone "Error"
			Registrar-Log "Arquivo de saída não gerado" $exe $src $file $out -status "FALHA" -duracao $dur
		}
	} catch {
		$dur = (Get-Date) - $startTime
		$progressForm.Close()
		Mostrar-Mensagem -mensagem "Erro na execução: $_" -titulo $lang.ErrorMessage1 -icone "Error"
		Registrar-Log "Erro na execução: $($_.Exception.Message)" $exe $src $file $out -status "ERRO" -duracao $dur
	}
} -size '140,30'
$form.Controls.Add($btnRun)

# Botão Limpar
$form.Controls.Add((New-Button $lang.Limpar "$($x + 150),230" {
    if (-not $exePreenchidoAutomaticamente) {
        $textBoxExe.Clear()
        $btnSelectExe.Visible = $true
    }

    $textBoxSrc.Clear()
    $textBoxFile.Clear()
    $textBoxOut.Clear()

    # Se o executável não existir, reexibe botão de download
    $btnDownload.Visible = $true
} -size '150,30'))

# Botão de download manual
$btnDownload = New-Button $lang.Download "$x,280" {
    $exePath = Join-Path $scriptDir "IntuneWinAppUtil.exe"
    try {
        Invoke-WebRequest `
            -Uri "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/refs/heads/master/IntuneWinAppUtil.exe" `
            -OutFile $exePath -UseBasicParsing

        Mostrar-Mensagem -mensagem "Download concluído com sucesso!" -titulo $lang.WarningMessage2 -icone "Information"
        $textBoxExe.Text = $exePath
        $exePreenchidoAutomaticamente = $true
        $btnSelectExe.Visible = $false
        $btnDownload.Visible = $false
    } catch {
        Mostrar-Mensagem -mensagem "Erro ao baixar IntuneWinAppUtil.exe.`n$_" -titulo $lang.ErrorMessage1 -icone "Error"
    }
} -size '150,50'
$form.Controls.Add($btnDownload)

# Checkbox modo escuro
$checkDark = New-Object Windows.Forms.CheckBox
$checkDark.Text = $lang.DarkMode
$checkDark.Location = '20,180'
$checkDark.Font = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Bold)
$checkDark.AutoSize = $true
$checkDark.Add_CheckedChanged({
    if ($checkDark.Checked) {
        Apply-Theme $theme.Dark
    } else {
        Apply-Theme $theme.Light
    }
    Atualizar-Logo
})
$form.Controls.Add($checkDark)

# Caixa da logo
$imgBox = New-Object Windows.Forms.PictureBox
$imgBox.SizeMode = 'StretchImage'
$imgBox.Size = '140,140'
$imgBox.Location = '20,20'
$form.Controls.Add($imgBox)

# Função para atualizar logo com base no tema
function Atualizar-Logo {
	$logoDark  = Join-Path $scriptDir "Logo_Dark.jpg"
	$logoClean = Join-Path $scriptDir "Logo_Clean.jpg"

	$logosFaltando = @()
	if (-not (Test-Path $logoDark))  { $logosFaltando += "Logo_Dark.jpg" }
	if (-not (Test-Path $logoClean)) { $logosFaltando += "Logo_Clean.jpg" }

	if ($logosFaltando.Count -gt 0) {
		if ($logosFaltando.Count -eq 1) {
			$mensagem = "O logotipo '$($logosFaltando[0])' não foi encontrado.`nEle será baixado automaticamente em alguns segundos..."
		} else {
			$lista = ($logosFaltando -join "', '")
			$mensagem = "Os logotipos '$lista' não foram encontrados.`nEles serão baixados automaticamente em alguns segundos..."
		}

		Mostrar-AlertaTemporizado `
			-titulo $lang.WarningMessage1 `
			-mensagem $mensagem
	}

    Baixar-ArquivoSeNecessario -caminhoArquivo $logoDark -url "https://i.ibb.co/tTRH4y0s/Logo-Dark.jpg"
    Baixar-ArquivoSeNecessario -caminhoArquivo $logoClean -url "https://i.ibb.co/bjwhR3yH/Logo-Clean.jpg"

    $logoPath = if ($checkDark.Checked) { $logoDark } else { $logoClean }

    if (Test-Path $logoPath) {
        try {
            if ($imgBox.Image) { $imgBox.Image.Dispose() }
            $imgBox.Image = [System.Drawing.Image]::FromFile($logoPath)
        } catch {
            Mostrar-Mensagem -mensagem "Erro ao carregar logotipo: $_" -titulo "Erro de Imagem" -icone "Error"
        }
    }
}
# --- Evento ao exibir o formulário ---
$form.Add_Shown({
    Carregar-Configuracao

    $exePath = Join-Path $scriptDir "IntuneWinAppUtil.exe"
    if (-not (Test-Path $exePath)) {
        Mostrar-AlertaTemporizado `
            -titulo $lang.WarningMessage1 `
            -mensagem ($lang.ExeNotFound + "`nO download será realizado automaticamente em alguns segundos...")
        try {
            Invoke-WebRequest `
                -Uri "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/refs/heads/master/IntuneWinAppUtil.exe" `
                -OutFile $exePath -UseBasicParsing
        } catch {
            Mostrar-Mensagem -mensagem "Erro ao baixar IntuneWinAppUtil.exe.`n$_" -titulo $lang.ErrorMessage1 -icone "Error"
        }
    }

    if (Test-Path $exePath) {
        $textBoxExe.Text = $exePath
        $exePreenchidoAutomaticamente = $true
        $btnSelectExe.Visible = $false
        $btnDownload.Visible = $false
    }

    if ($checkDark.Checked) {
        Apply-Theme $theme.Dark
    } else {
        Apply-Theme $theme.Light
    }

    Atualizar-Logo
    $textBoxExe.Focus()
})

# --- Evento ao fechar: salvar configurações ---
$form.Add_FormClosing({ Salvar-Configuracao })

# Enter ativa botão "Criar"
$form.AcceptButton = $btnRun

# Executar aplicação
[Windows.Forms.Application]::EnableVisualStyles()
[Windows.Forms.Application]::Run($form)