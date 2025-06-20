## 🧭 O que é o `{GUID}`?

O `{GUID}` — abreviação de *Globally Unique Identifier* — é um identificador global único usado para distinguir de forma exclusiva cada instalação de aplicativo no Windows, especialmente os instalados via arquivos MSI.

Esse identificador é essencial para operações de automação como desinstalações silenciosas e gerenciamento remoto via Microsoft Intune. Ele permite que o sistema identifique com precisão qual versão do software deve ser manipulada, evitando conflitos com outros aplicativos semelhantes.

No contexto do Intune, o `{GUID}` é frequentemente utilizado na linha de desinstalação, no seguinte formato:

```cmd
msiexec /x "{GUID}" /quiet
```

### 🔍 Descobrindo o GUID de um Aplicativo MSI via PowerShell

Este guia mostra como identificar o `{GUID}` de um aplicativo instalado no Windows, informação essencial para configurar corretamente a desinstalação silenciosa no Intune.

### ✅ Pré-requisitos

- O aplicativo deve estar instalado na máquina de teste.
- A execução de scripts PowerShell deve ser permitida.

### 💻 Etapas

1. **Abra o PowerShell como administrador.**

2. **Execute o seguinte comando para listar todos os aplicativos MSI com seus respectivos GUIDs:**

```powershell
Get-WmiObject -Class Win32_Product | Select-Object Name, IdentifyingNumber
```

3. **Localize o nome do aplicativo desejado** na lista exibida. O valor da coluna `IdentifyingNumber` será o GUID.

### 🎯 Dica: Buscar um aplicativo específico

Você pode filtrar a busca por nome para agilizar a localização do GUID:

```powershell
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*NomeDoApp*" } | Select Name, IdentifyingNumber
```

Substitua `"NomeDoApp"` por parte do nome do aplicativo.

## ⚠️ Observações

- Esse comando pode causar uma revalidação silenciosa dos instaladores MSI na máquina. Para inspeção sem impactos, considere usar ferramentas como o [Regedit](https://learn.microsoft.com/en-us/windows/win32/sbscs/registry-entries-for-installed-applications) ou o utilitário **Orca**.
- O `{GUID}` deve ser usado na linha de desinstalação como:

```cmd
msiexec /x "{GUID}" /quiet
```
