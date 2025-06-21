# 📁 Deploy de Aplicativos com Arquivo .intunewin

Para aplicativos personalizados ou instaladores não MSI, é possível encapsular arquivos `.exe`, `.bat` etc em formato `.intunewin`.

## ✅ Pré-requisitos

- Ferramenta [Microsoft Win32 Content Prep Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool).
   > **Nota:** há diversas ferramentas na internet que servem como frontend GUI para o aplicativo da Microsoft sendo assim, para facilitar o processo de criação será disponibilizado neste repositório o código script Powershell de um frontend que estou desenvolvendo para uso interno. Para saber mais, consulte [Intune Desktop Packager](./GUI/intune_gui.md)
- Arquivos de instalação prontos (como instaladores .exe, .msi, .bat, .cmd, .ps1 etc.).
- Parâmetros de instalação silenciosa.
   > **Dica**: consulte os sites [SilentInstalHQ](https://silentinstallhq.com/) ou [Manage Engine Endpoint Central](https://www.manageengine.com/products/desktop-central/software-installation/latest-software.html) para descobrir os parâmetros de instalação silenciosa.

## 📦 Criando o pacote .intunewin

### Utilizando linha de comando
Para criação de pacote a partir de linha de comando, baixe a ferramenta no link informado anteriormente, abra o PowerShell como administrador e execute o seguinte comando:
```bash
IntuneWinAppUtil -c <pasta_do_instalador> -s <arquivo_setup> -o <pasta_de_saida>
```
<p>
  <img src="imagens/INTUNEWIN-DEPLOY-01.png">
</p>

### Utilizando frontend GUI
- Para baixar a ferramenta, acesse  [Intune Desktop Packager](./GUI/intune_gui.md);
- Ao executar o arquivo Intune-Desktop-Pack.exe pela primeira vez, os arquivos necessários serão baixados automaticamente e disponibilizados na mesma pasta do aplicativo;
- Utilizando uma interface gráfica, o processo se torna mais amigável e rápido:
<p>
  <img src="imagens/INTUNEWIN-DEPLOY-02.png">
</p>
<p>
  <img src="imagens/INTUNEWIN-DEPLOY-04.png">
</p>
<p>
  <img src="imagens/INTUNEWIN-DEPLOY-05.png">
</p>

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
