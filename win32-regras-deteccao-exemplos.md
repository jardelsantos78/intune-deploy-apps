# 🧪 Exemplos Práticos – Regras de Detecção no Intune (Win32)

Este guia complementa a etapa de **Regras de Detecção** ao adicionar aplicativos Win32 no Intune, fornecendo exemplos aplicáveis nos cenários mais comuns.

---

## 📁 Detecção por Arquivo ou Pasta

Verifica a existência de um arquivo instalado pelo aplicativo.

- **Tipo:** Arquivo  
- **Caminho:** `C:\Program Files\ImageResizer`  
- **Arquivo:** `ImageResizer.exe`  
- **Tipo de detecção:** Existência do arquivo

> 💡 Útil para instaladores `.exe` que não criam entradas no registro.

---

## 🧾 Detecção por Registro (Registry)

Verifica a presença de uma chave de registro que o instalador cria.

- **Tipo:** Registro  
- **Caminho da Chave:** `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6026BD89-5CCA-4A47-8012-08FDA0E935A}`  
- **Propriedade:** `DisplayName`  
- **Valor:** `Image Resizer`  
- **Tipo de detecção:** Valor de propriedade

> 🔎 Ideal para aplicativos `.msi`, pois estes geralmente criam registros automatizados no sistema.

---

## 💻 Detecção via Script PowerShell

Perfeito para cenários mais complexos, como verificações personalizadas.

```powershell
# Detecta se o arquivo executável existe em qualquer pasta Program Files
$paths = @(
    "C:\Program Files\ImageResizer\ImageResizer.exe",
    "C:\Program Files (x86)\ImageResizer\ImageResizer.exe"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        exit 0  # Detecção bem-sucedida
    }
}
exit 1  # Aplicativo não encontrado
```

- Salve como `.ps1` e carregue na opção **“Usar script de detecção personalizado”**

> 🧠 Scripts são ideais para lidar com múltiplos caminhos, verificações condicionais ou apps empacotados de forma personalizada.

---

## 📌 Boas práticas

- Utilize **uma única regra confiável** para evitar falsos positivos/negativos
- Teste o instalador localmente antes de definir a regra
- Evite regras baseadas em arquivos temporários ou removíveis
