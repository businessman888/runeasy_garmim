# Documentação de Contexto: RunEasy Garmin DataField
**Data:** 05 de Maio de 2026
**Projeto:** RunEasy (Ecossistema de Corrida para Garmin)
**Plataforma:** Connect IQ / Monkey C (SDK 7.x)
**Device Principal:** fēnix 7 Pro

## Objetivo do Projeto
Transformar um template padrão de DataField do Garmin em um produto de alta performance focado em design minimalista (High-End Dark Mode) e usabilidade para corrida, respeitando as severas restrições de memória RAM e sintaxe da linguagem Monkey C.

---

## Histórico de Implementações e Correções

### Fase 1: Identidade Visual e Lógica Matemática Básica
- **Identidade Visual:** Aplicamos um *Dark Mode* profundo com a cor de fundo `#131F54` e a cor de destaque (fonte) Azul Elétrico `#00D4FF`.
- **Tipografia e Minimalismo:** Removemos todos os rótulos textuais desnecessários do `layouts.xml`. Definimos a fonte primária do *Pace* para a maior disponível (`Graphics.FONT_NUMBER_THAI_HOT`) e a distância para `Graphics.FONT_LARGE`. O Pace ficou no centro e a Distância na parte inferior (`y=80%`).
- **Conversão de Dados:** 
  - A velocidade crua do GPS (`info.currentSpeed` em $m/s$) foi convertida para Pace de corrida ($min/km$) utilizando a fórmula $1000 / (velocidade \times 60)$.
  - A distância (`info.elapsedDistance` em $metros$) foi convertida para Quilômetros e formatada com 2 casas decimais.
- **Prevenção de Falhas (Divisão por Zero):** Adicionamos uma "trava" lógica. Se o usuário parar ou andar muito devagar (velocidade $< 0.2 m/s$), o Pace exibe `--:--` em vez de travar o relógio.
- **Otimização de Memória:** Variáveis e o instanciamento da logo (`AppLogo`) foram realocados de `onUpdate()` para o nível da classe e inicializados uma única vez em `initialize()`.

### Fase 2: Conformidade com o SDK 7.x (Tipagem e Avisos)
- **Correção do Erro 105 (Tipagem de Cores):** O compilador da Garmin barrou os valores hexadecimais puros. O tipo foi atualizado estritamente para `Graphics.ColorValue`, utilizando "cast" explícito `0x131F54 as Graphics.ColorValue`.
- **Aviso de Traduções (`manifest.xml`):** Inserimos nativamente a seção `<iq:languages>` suportando `por` (português) e `eng` (inglês) para suprimir os "warnings" de idiomas vazios do manifesto.
- **Ajuste de Atributos SVG (`drawables.xml`):** Devido a um erro 102 que proibia os atributos de escala nativa (`scaleWidth`, `scaleHeight`) neste escopo/build, eles foram abolidos do arquivo `drawables.xml`, deixando apenas a declaração pura `<bitmap id="..." filename="..." dithering="none" />`.

### Fase 3: Ordem de Camadas em `RuneasyView.mc`
O código foi reescrito para respeitar uma cadeia de renderização altamente estrita que ignora automatismos perigosos da View base, permitindo a precisão:
1. `dc.clear()` sempre sendo chamado em primeiro lugar com a cor de fundo preenchida ativamente com `#131F54`.
2. A logo (`AppLogo`) é injetada estaticamente na tela antes dos números.
3. O Posicionamento do eixo X usa matemática perfeita para alinhar no centro de qualquer relógio: `(dc.getWidth() / 2) - (logoWidth / 2)`.
4. O eixo Y da logo foi fixado dinamicamente em `35` para fugir do corte da moldura física do anel esférico de relógios como o fēnix 7 Pro.
5. Por último, o `View.onUpdate(dc)` é rodado para decalcar as métricas textuais (Pace e Distância) sobre a tela renderizada.

### Fase 4: Resolução de Conflitos de Path (Erro de Resolve do SVG)
- **Problema:** `Could not resolve novolgruneasy.svg @[...drawables.xml:L2]`
- **Causa/Correção:** O arquivo físico original foi renomeado de `novolgruneasy.svg` para `novolgruneasyy.svg` (com dois "y"). O compilador colidiu quando a linha 2 tentou declarar o `LauncherIcon` apontando para a string extinta. O problema foi corrigido unificando o `filename` das tags `LauncherIcon` e `AppLogo` para a nova nomenclatura correta.
