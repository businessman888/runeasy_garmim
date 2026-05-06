# Histórico de Atualizações: Evolução da Interface e Design (RunEasy)

Este documento registra as implementações, refatorações de arquitetura de interface e evoluções de design realizadas na DataField do RunEasy para relógios Garmin (foco no Fēnix 7 Pro e ecossistema redondo).

## 1. Correção do Bug Crítico de Renderização (A "Logo Invisível")
A logo original não estava aparecendo na interface e o fundo permanecia preto ou quebrado devido a três fatores que foram corrigidos:

- **Conflito de Camadas:** Remoção do `View.onUpdate(dc)` que apagava o fundo customizado (`0x131F54`). Implementou-se uma ordem de pintura manual rigorosa no `RuneasyView.mc`: (1) Fundo e Clear, (2) Logo e Ícones, (3) Textos.
- **Incompatibilidade de SVG:** O arquivo SVG original era na verdade um "wrapper" contendo uma imagem base64 embutida. Como o SDK da Garmin não processa rasterização base64 em vetor, a imagem ficava invisível. A solução foi migrar para um arquivo nativo em `.png` (`novoologoruneasy.png`).
- **Restrição de Geometria de Tela:** O código anterior possuía `if (obscurityFlags == 0)`, o que só autorizava o desenho da logo em telas **quadradas**. Em relógios redondos (onde as 4 bordas cortam a tela, flag `15`), nada era desenhado. Foi inserida a variável inteligente `isQuadrant` para autorizar a renderização limpa e centralizada na `MainLayout`.

## 2. Refatoração de Memória e Ciclo de Vida
Para garantir que o Connect IQ não ficasse sobrecarregado pintando bitmaps ou reavaliando referências a cada 1 segundo (dentro de `onUpdate`):

- As variáveis de memória (`AppLogo`, `HeartIcon`, `DistIcon`, e suas larguras de pixel) foram transformadas em variáveis globais / membros de classe (`hidden var`).
- Todos os recursos pesados (Bitmaps) e o cálculo físico de dimensões de imagem (`getWidth()`) foram injetados no **`onLayout`**, evento disparado apenas durante mudanças de ciclo na interface, poupando processamento no loop de renderização da corrida.

## 3. Implementação da Hierarquia Premium e Simetria ("Air Design")
A interface foi modernizada adotando técnicas visuais arrojadas, simetria de eixo e hierarquia de informação:

* **Paleta de Cores:** Fundo `0x131F54` com fontes vibrantes (Electric Blue: `0x00D4FF`) para todas as métricas em destaque, reforçando o contraste.

* **Arquitetura Matemática Simétrica:** Criou-se um modelo de agrupamento horizontal. Em vez de estimar posições para ícones e textos lado a lado, o algoritmo soma `(Largura do Ícone + Padding (5) + Largura dinâmica do Texto)`. Ao pegar a metade desse valor unificado, as métricas e seus ícones formam um **bloco absoluto perfeitamente centralizado na horizontal**.

* **Hierarquia Vertical (Eixo Y):**
   * **Logo:** Fixada no topo em `y=35`.
   * **HR (Heart Rate):** Adicionada leitura de sensor em tempo real (`info.currentHeartRate`), desenhada aglomerada com um novo ícone de coração (`HeartIcon`), alocada de forma harmônica em `y=80` com fonte `FONT_MEDIUM`. Tratamento para "--" caso o relógio esteja fora de pulso.
   * **Pace (Ritmo):** Mantido como protagonista visual (maior número no centro), centralizado perfeitamente no meio da tela e padronizado na fonte extrema `FONT_NUMBER_HOT`.
   * **Distância:** Posicionada estrategicamente na base (`y=195`), implementada fora do Layout XML genérico e desenhada também como um bloco simétrico junto a um novo ícone customizado (`DistIcon`). A métrica tem formatação fixa com duas casas decimais, tratando também casos de distância não iniciada.
   * **Linhas Divisórias ("Premium Detail"):** Inclusão de duas linhas discretas (espessura 1px, cor `0x25356e`) em `y=110` e `y=180` para isolar graciosamente os blocos de HR e Distância do destaque central de Pace.

## 4. Evolução para Centralização Premium ("True Glass")
A UI passou por refinamentos arquitetônicos para maximizar o luxo visual e a leitura rápida:

- **Efeito True Glass:** As divisórias sólidas antigas foram deletadas. O HR (topo) e a Distância (base) agora habitam "blocos de vidro": grandes retângulos desenhados com fundo translúcido `0x20326A` e uma moldura de borda sutil de 1px `0x3A508C`, criando uma profunda percepção de camadas.
- **Isolamento do Pace:** O número principal (Pace) teve seu Y deslocado levemente acima para burlar o grande espaçamento interno (padding invisível) da megaphonte da Garmin (`centerY - 25`), tornando-se o pilar central flutuante absoluto, sem elementos brigando por sua horizontal.
- **Espaçamento ("Respiro") e Alinhamento:** Os blocos de HR e Distância foram ancorados respeitando amplos respiros em proporção à altura da tela (`h * 0.24` e `h * 0.82`), impedindo qualquer colisão vertical. Os ícones e numerais dentro das caixas glass agora são alinhados perfeitamente pelo eixo vertical através do `TEXT_JUSTIFY_VCENTER`.
- **Anel Interativo (Borda Robusta):** O arco radial dinâmico, que colore os 360º de acordo com o esforço cardíaco, teve sua espessura duplicada para **4 pixels**, funcionando como um infográfico imponente que circunda as métricas.

---
*Atualizado em Maio de 2026.*
