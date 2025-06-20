# 📁 Deploy de Aplicativos com Arquivo .intunewin

Para aplicativos personalizados ou instaladores não MSI, é possível empacotar arquivos `.exe`, `.bat`, etc. em formato `.intunewin`.

## ✅ Pré-requisitos

- Ferramenta [Microsoft Win32 Content Prep Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool).
- Arquivos de instalação prontos.
- Parâmetros de instalação silenciosa.
   > **Dica**: consulte os sites [SilentInstalHQ](https://silentinstallhq.com/) ou [Manage Engine Endpoint Central](https://www.manageengine.com/products/desktop-central/software-installation/latest-software.html) para descobrir os parâmetros de instalação silenciosa.

## 📦 Criando o pacote .intunewin

```bash
IntuneWinAppUtil -c <pasta_do_instalador> -s <arquivo_setup.exe> -o <pasta_de_saida>
```

## 🚀 Etapas no Intune

1. Acesse o [Centro de Administração do Intune](https://intune.microsoft.com).
2. Vá em **Aplicativos > Todos os aplicativos > Adicionar**.
3. Selecione **App do Windows (Win32)**.
4. Faça upload do arquivo `.intunewin`.
5. Preencha os campos de nome, descrição e editor.
6. Configure os programas de instalação e desinstalação, requisitos e detecção.
7. Atribua aos grupos.
8. Conclua o processo e acompanhe a implantação.

---
