# Intune Desktop Packager

É uma ferramenta com interface gráfica desenvolvida em PowerShell que simplifica a criação de pacotes `.intunewin` para distribuição de aplicativos via Microsoft Intune (Endpoint Manager).

## 📦 Visão Geral

Este utilitário simplifica o processo de conversão de instaladores tradicionais (como `.exe` ou `.msi`) para o formato `.intunewin`, permitindo a distribuição automatizada de aplicativos via Microsoft Endpoint Manager (Intune).

## ⚙️ Funcionalidades

- Interface gráfica amigável e moderna
- Modo escuro nativo
- Detecção automática do utilitário `IntuneWinAppUtil.exe`
  - Caso não esteja presente na pasta do script, o aplicativo é baixado automaticamente.
- Preenchimento automático do caminho do executável após o download
- Download automático dos logotipos personalizados, se ausentes
- Exibição de mensagens informativas durante o processo
- Geração de log detalhado com cada conversão de pacote `.intunewin`
- Botão para limpar os campos e reiniciar o processo

## 📁 Estrutura

- `IntuneWinAppUtil.exe` – binário oficial da Microsoft necessário para empacotar
- `Intune-Packager.log` – log com histórico das conversões
- `Intune Desktop Packager.ps1` – script principal com interface gráfica

## 💻 Requisitos

- Windows PowerShell 5.1 ou superior
- Sistema operacional Windows 10/11
- Acesso ao executável `IntuneWinAppUtil.exe` fornecido pela Microsoft

## 🚀 Como usar

1. Execute o script `Intune Desktop Packager.ps1`
2. Preencha os campos obrigatórios com os caminhos corretos
3. Clique em “Executar” para gerar o arquivo `.intunewin`
4. Acompanhe o resultado visual e o log de conversões

---

Desenvolvido por Jardel 🚀 — para empacotamento simplificado com controle e estilo.
