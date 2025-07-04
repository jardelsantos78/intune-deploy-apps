<p align="center">
  <img src="./imagens/BANNER-INTUNE.png" alt="Banner do Projeto" width="60%">
</p>

# Deploy de aplicativos via Microsoft Intune

Este repositório fornece um passo a passo para realizar o deploy de aplicativos em ambientes corporativos utilizando o Microsoft Intune. São abordados três métodos distintos: instalação de aplicativos no formato `.MSI`, publicação via Microsoft Store e distribuição de pacotes `.INTUNEWIN`.

## 📌 O que é o Microsoft Intune?

O **Microsoft Intune** é uma solução de gerenciamento de dispositivos móveis (MDM) e gerenciamento de aplicativos móveis (MAM) baseada em nuvem. Com ele, administradores de TI podem proteger, configurar e distribuir software em dispositivos Windows, Android, macOS e iOS com facilidade — tudo isso de forma centralizada, através de uma interface web intuitiva.

### 🚀 Benefícios do Intune

- **Gerenciamento centralizado** de dispositivos e aplicações.
- Integração com o **Azure Active Directory (Azure AD)** e o **Microsoft Endpoint Manager**.
- Suporte à **compliance e políticas de segurança**.
- Redução de custos com suporte técnico e automação de tarefas.
- Distribuição simplificada de aplicações e atualizações em larga escala.

## 🏢 Preparando o ambiente corporativo

Para utilizar o Intune no ambiente corporativo, siga estes passos iniciais:

1. **Licenciamento:** Verifique se sua organização possui licenças válidas, como o Microsoft 365 E3, E5 ou o Intune Standalone.
2. **Atribua licenças aos usuários:** Através do portal do Microsoft 365 Admin Center, atribua as licenças com Intune aos usuários que terão dispositivos gerenciados.
3. **Configuração inicial:**
   - Acesse o [Centro de Administração do Microsoft Intune](https://intune.microsoft.com).
   - Configure os domínios, tokens de MDM (Apple/Android, se aplicável) e perfis de inscrição.
   - Crie grupos de dispositivos e usuários.
4. **Políticas de conformidade:** Defina regras de segurança e conformidade de dispositivos.
5. **Inscrição de dispositivos:** Escolha e configure métodos de inscrição automática ou manual dos dispositivos gerenciados.

## 📂 Conteúdo do Repositório

Este repositório contém documentação e exemplos de como realizar deploy de aplicativos no Microsoft Intune. Cada arquivo aborda um método ou recurso específico:

- [`msi-deploy.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/msi-deploy.md): Guia para distribuição de arquivos no formato `.msi`.
- [`store-deploy.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/store-deploy.md): Instalação de aplicativos diretamente da Microsoft Store.
- [`intunewin-deploy.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/intunewin-deploy.md): Deploy utilizando pacotes `.intunewin`.
- [`descobrir-guid.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/descobrir-guid.md): Como identificar o GUID de um aplicativo via PowerShell.
- [`win32-regras-deteccao-exemplos.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/win32-regras-deteccao-exemplos.md) *(novo!)*: Exemplos práticos de regras de detecção para pacotes Win32.
- [`imagens/`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/imagens/): Pasta para armazenar imagens de apoio aos tutoriais.
- [`GUI/`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/GUI/): Interface gráfica e ferramentas complementares:
  - [`Intune-Desktop-Manager.ico`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/GUI/Intune-Desktop-Manager.ico): Ícone utilizado na aplicação gráfica.
  - [`Intune-Desktop-Packager.ps1`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/GUI/Intune-Desktop-Packager.ps1): Script PowerShell para empacotar aplicativos com interface.
  - [`Intune-Desktop-Packager.zip`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/GUI/Intune-Desktop-Packager.zip): Arquivo compactado com o `.ico` e o `.ps1` para facilitar o download.
  - [`intune-gui.md`](https://github.com/jardelsantos78/intune-deploy-apps/tree/main/GUI/intune-gui.md): Guia explicativo sobre o uso da interface gráfica para deployment.

---

Este repositório é voltado a profissionais de TI que desejam padronizar, automatizar e escalar a distribuição de aplicativos de forma segura e eficiente com o Microsoft Intune.
