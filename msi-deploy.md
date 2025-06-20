# 📦 Deploy de Aplicativos MSI via Intune

Este guia apresenta o passo a passo para distribuir instaladores no formato `.MSI` utilizando o Microsoft Intune.

## ✅ Pré-requisitos

- Arquivo `.msi` válido.
- Conhecimento dos parâmetros de instalação silenciosa, se aplicável.
- Permissão para criar políticas de aplicativos no Intune.

## 🚀 Etapas

1. Acesse o [Centro de Administração do Microsoft Intune](https://intune.microsoft.com).
2. Navegue até **Aplicativos > Todos os aplicativos > Adicionar**.
3. Escolha o tipo de aplicativo: **App do Windows (Win32)**.
4. Na aba **App package file**, selecione o `.msi`.
5. Preencha as informações do aplicativo (nome, descrição, publisher).
6. Configure os **Programas de Instalação**:
   - Instalação: `msiexec /i "nome-do-app.msi" /quiet`
   - Desinstalação: `msiexec /x "{GUID}" /quiet` (ajuste o GUID conforme o aplicativo)
   -- Para saber mais sobre *GUID*, clique [aqui] 
7. Configure os requisitos, regras de detecção e dependências.
8. Atribua o aplicativo a grupos de usuários ou dispositivos.
9. Conclua e monitore o deploy pela aba **Monitoramento**.

---
