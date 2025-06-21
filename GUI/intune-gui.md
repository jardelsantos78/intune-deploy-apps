# Intune Desktop Packager

**Intune Desktop Packager** é uma ferramenta em PowerShell com interface gráfica (GUI) desenvolvida para facilitar o empacotamento de aplicativos Win32 no formato `.intunewin`, compatível com o Microsoft Intune.

## 📦 Visão Geral

Este utilitário simplifica o processo de conversão de instaladores tradicionais (como `.exe` ou `.msi`) para o formato `.intunewin`, permitindo a distribuição automatizada de aplicativos via Microsoft Endpoint Manager (Intune).

## ⚙️ Funcionalidades

- Interface gráfica amigável e intuitiva
- Integração com `IntuneWinAppUtil.exe`
- Suporte à seleção de:
  - Caminho da ferramenta de empacotamento
  - Pasta de origem da aplicação
  - Arquivo de instalação principal
  - Pasta de destino para o arquivo `.intunewin`
- Exibição automática de logotipo personalizado
- Compatível com tema claro e escuro
- Notificações e mensagens informativas
- Registro de log detalhado com cada conversão realizada

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
