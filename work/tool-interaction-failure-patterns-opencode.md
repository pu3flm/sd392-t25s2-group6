# Padrões candidatos de falha nas interações do OpenCode

## Ubuntu old, março a julho de 2026

**Natureza deste arquivo:** análise observacional intermediária para o relatório anual de uso de IA. Não é captura bruta, veredito, regra operacional, prova causal nem decisão autoral. Não deve ser incorporado automaticamente a *Before the Project*.

**Fonte examinada:** somente `/mnt/ubuntu-old/home/fern/.local/share/opencode/opencode.db`, em modo de leitura. Nenhum diretório Fedora, outro usuário ou fonte externa foi examinado.

**Instantâneo observado durante a análise:** 6.932.447.232 bytes; SHA-256 `f1163a66c266669c4589603ec54938c3162067cba1edd8ca11af01617dfbbf20`. O banco registra sessões iniciadas entre 2026-03-04 17:48:31 e 2026-07-24 11:00:43, em 109 datas de início ativas, com horário local derivado como UTC-3. Nenhuma das 937 linhas de sessão tem `time_archived` preenchido.

## 1. Estados epistêmicos mantidos separados

Esta análise usa a seguinte cadeia:

`registro preservado -> observação extraída -> relação medida ou estimada -> padrão candidato derivado dos dados`

Os estados não são intercambiáveis:

1. **Traço bruto:** texto, evento de ferramenta e metadado preservados no banco.
2. **Observação extraída:** sequência que pode ser lida diretamente no traço, por exemplo, pedido, ação, objeção e resposta subsequente.
3. **Testemunho técnico em primeira pessoa:** relato do engenheiro sobre o comportamento que ele viveu no uso. Esse testemunho é uma fonte própria; não é rebaixado a hipótese retrospectiva nem convertido automaticamente em prova universal.
4. **Autorrelato do assistente:** admissão ou explicação causal produzida pelo próprio assistente. Uma admissão ajuda a localizar um episódio; uma explicação do assistente não demonstra o mecanismo que a produziu.
5. **Dado calculado:** contagem obtida das tabelas `session`, `message` e `part`.
6. **Padrão candidato derivado dos dados:** relação inferida entre episódios. Ele esclarece o que o conjunto pode indicar; não decide a verdade nem substitui a interpretação do engenheiro.

As falas da troca ao vivo que motivou esta tarefa não foram usadas para selecionar, nomear ou confirmar categorias. A análise parte apenas dos registros históricos do banco, e seus mecanismos internos permanecem causalmente subdeterminados.

## 2. Desenho da exploração

### 2.1 Censo estrutural do banco

Foi feito um censo das 937 sessões e dos seus metadados, papéis de mensagem, tipos de parte, estados terminais de ferramenta, compactações, relações pai-filho, títulos repetidos, versões e configurações de modelo. Essa etapa é exaustiva para os campos consultados, não para o conteúdo semântico de todas as mensagens.

### 2.2 Leitura estratificada das interações

A unidade de leitura foi a **interação**, não o prompt isolado: fala do engenheiro, resposta do assistente, ações/retornos de ferramenta e turnos corretivos adjacentes, quando disponíveis.

Foram usados quatro cortes temporais para impedir que julho dominasse toda a leitura:

- março–abril: formação inicial de fluxos, repositórios, HDL, ambientes e pesquisa;
- maio–junho: pipelines, verificação, configuração de agentes e experimentos de modelo;
- 1–14 de julho: sistema, hardware, documentação e especialização de agentes;
- 15–24 de julho: orquestração densa, revisões entre modelos e artefatos maiores.

Também foram preservados contrastes entre temas: escopo e sequência; evidência e execução; ferramentas/ambiente; persistência; linguagem/terminologia; identidade e utilidade de artefatos.

As famílias de consulta foram:

- **estrutura temporal:** `time_created`, `parent_id`, título, versão, modelo e distribuição mensal;
- **execução:** partes `tool`, ferramenta chamada, `state.status` e assinatura textual de `state.error`;
- **pressão de contexto:** partes `compaction`, sessões filhas e clusters de títulos/forks;
- **localização de interação:** marcadores lexicais conservadores de correção no texto do engenheiro e de autorretificação no texto do assistente, sempre seguidos de leitura do entorno;
- **autoria de papel:** envelopes preformatados sob `role=user`, separados antes de qualquer leitura como testemunho;
- **contraste:** sessões com escopo estreito, repetição de teste, hashes, resultado observável ou avaliação explícita do engenheiro.

Os localizadores lexicais foram predominantemente em inglês, idioma dominante nas interações examinadas. Correções formuladas apenas em português, por sinônimo não incluído ou sem expressão corretiva explícita podem ter sido omitidas; por isso, eles não definem o universo semântico.

Uma varredura delegada do estrato março–abril cobriu 38 de 214 sessões (17,8%), distribuídas por 31 das 44 datas ativas. A seleção combinou 27 âncoras determinísticas — primeira, intermediária e última sessão de nove semanas ISO — e 11 adições dirigidas por correções explícitas, alta densidade de erros de ferramenta e diversidade temática. Essa quota terminou por desenho fixo, não porque novas categorias deixaram de aparecer.

No acervo completo, um localizador lexical conservador encontrou:

- 30 mensagens do papel `user`, em 23 sessões, com expressões como “why did you”, “you did not/didn't”, “I already told you” ou “never do it again”;
- 47 mensagens do papel `assistant`, em 30 sessões, com autorretificações como “I was wrong”, “I misread”, “I conflated”, “I overstepped” ou “my mistake”;
- união de 47 sessões, pois vários episódios continham ambos os lados.

Os marcadores serviram somente para localizar janelas de leitura. Não são uma taxa de falha: incluem instruções prospectivas, reparos bem-sucedidos, fórmulas convencionais e histórias copiadas entre forks. Casos sem essas palavras também podem conter problemas.

Foram ainda lidos contrastes deliberados nos quais contratos estreitos, aquisição observável ou repetição efetiva de testes funcionaram bem, incluindo `ses_30acc4b87ffeYZ1YrmpoORBBeP`, `ses_342aff3c7ffemhMnVaDmxTYB5k`, `ses_211c725c8ffeneExktZNZq6Our`, `ses_1770b2737ffeF8y1vI03l7X0h1`, `ses_09db24201ffetvA3AEd2V5M078` e `ses_081aa24b4ffeQ4h5Xm1dWpcyCz`.

### 2.3 Saturação e regra de parada

Não foi estabelecida saturação analítica das 937 sessões. A leitura foi heurística e estratificada, e parou quando havia recorrência temporal, contraste e rastreabilidade suficientes para produzir categorias candidatas úteis. No estrato março–abril, a parada foi uma quota fixa. Portanto, “não encontrado” neste arquivo significa apenas “não encontrado nas consultas e janelas declaradas”, nunca inexistência no acervo ou fora dele.

## 3. Forma do acervo e denominadores

| Mês | Sessões (raiz/filha) | Ferramentas concluídas/erro | Parcela `error` entre estados terminais | Compactações (eventos/sessões) |
|---|---:|---:|---:|---:|
| 2026-03 | 78 (56/22) | 4.548 / 61 | 1,32% | 5 / 3 |
| 2026-04 | 136 (67/69) | 10.163 / 223 | 2,15% | 24 / 10 |
| 2026-05 | 109 (68/41) | 7.535 / 179 | 2,32% | 20 / 12 |
| 2026-06 | 90 (50/40) | 8.476 / 158 | 1,83% | 16 / 9 |
| 2026-07 | 524 (155/369) | 88.203 / 1.455 | 1,62% | 547 / 96 |
| **Total** | **937 (396/541)** | **118.925 / 2.076** | **1,72%** | **612 / 129** |

Há ainda 33 partes de ferramenta com estado `running`; elas foram excluídas do denominador terminal. Erros apareceram em 380 sessões — 224 raízes e 156 filhas —, mas “sessão com erro” também não equivale a “interação malsucedida”. As contagens mensais de sessões com compactação não são aditivas: uma sessão atravessa mais de um mês, de modo que as linhas somam 130 ocorrências mensais e o total desduplicado é 129 sessões.

O banco contém 92.078 linhas de mensagem: 79.989 com papel `assistant` e 12.089 com papel `user`. As partes textuais somam 46.061: 34.533 do assistente e 11.528 do papel `user`. Esses números descrevem a serialização do banco, não a quantidade de falas humanas.

### 3.1 O papel `user` não identifica sozinho autoria humana

Pelo menos 611 partes textuais, em 603 mensagens e 228 sessões, têm formato explícito de envelope ou evento de controle preformatado embora estejam sob `role=user`:

| Formato observável | Partes textuais |
|---|---:|
| `The following tool was executed by the user` | 281 |
| `[BACKGROUND UPDATE]` | 212 |
| `<verification_failure>` | 92 |
| `[BACKGROUND COMPLETE]` | 16 |
| `<auto_continue>` | 8 |
| `Called the ... tool` | 2 |

Essas partes foram excluídas das buscas por testemunho/correção humana. A observação demonstra que `role=user` é um rótulo insuficiente para atribuir autoria. Ela não demonstra qual componente gerou cada envelope nem autoriza uma conclusão sobre mecanismos ocultos.

### 3.2 As sessões não são observações independentes

- 541 sessões têm `parent_id`, mas há também cópias/forks registrados como raízes.
- O título `Tailscale strategy: moto fern to nitro (fork #1)` aparece em 49 sessões-raiz criadas entre 04:53:28 e 05:00:55 de 24 de julho.
- `Mouse third-button scroll behavior (fork #1)` aparece em 12 sessões-raiz criadas em quatro segundos.
- Algumas respostas idênticas aparecem em vários forks; o mesmo erro chegou a se repetir dezenas de vezes por cópia de estado.
- O banco contém 52 versões distintas do OpenCode e 35 registros não nulos distintos no campo estruturado de configuração de modelo, além de 306 sessões sem modelo registrado nesse campo.

Por isso, contagens de sessão não podem ser lidas como ensaios independentes e o acervo não permite atribuir um padrão a um único modelo, versão, ferramenta ou camada.

## 4. Ecologia observável dos erros de ferramenta

Os 2.076 estados `error` foram agrupados uma única vez por assinatura textual. A classificação é descritiva; não identifica a causa real. Uma mesma sessão pode aparecer em mais de uma linha da coluna “sessões distintas”, embora cada parte `error` pertença a apenas uma assinatura.

| Assinatura heurística | Partes `error` | Sessões distintas | Leitura limitada |
|---|---:|---:|---|
| caminho ou modelo ausente | 628 | 197 | pode ser caminho obsoleto, sonda opcional ou pressuposto incorreto |
| rede ou HTTP | 547 | 130 | mistura indisponibilidade, bloqueio, limite e URL inadequada |
| contexto de edição incompatível | 261 | 125 | frequentemente recuperado após releitura do arquivo |
| permissão recusada ou pergunta dispensada | 147 | 96 | inclui decisão legítima do engenheiro/política, não defeito técnico |
| adaptador de busca | 114 | 82 | inclui falha de serialização/limite do adaptador |
| busca sem resultados registrada como erro | 109 | 66 | ausência local de resultado, não falha da interação por si só |
| abortado ou cancelado | 66 | 50 | o emissor e a intenção não são sempre distinguíveis no rótulo |
| outras assinaturas | 204 | 94 | grupo residual heterogêneo |

Ferramentas com maior volume absoluto ou proporção de erros terminais:

| Ferramenta | Concluídas | Erros | Parcela `error` |
|---|---:|---:|---:|
| `read` | 29.275 | 661 | 2,21% |
| `webfetch` | 4.205 | 566 | 11,86% |
| `apply_patch` | 10.732 | 280 | 2,54% |
| `gh_grep_searchGitHub` | 2.504 | 114 | 4,35% |
| `glob` | 5.142 | 112 | 2,13% |
| `grep` | 8.599 | 110 | 1,26% |
| `bash` | 37.663 | 77 | 0,20% |

Na amostra março–abril, 284 de 14.995 chamadas terminaram em erro (1,89%). Houve 46 erros de arquivo ausente em 23 sessões, 25 tentativas de leitor textual sobre binários em 11 sessões e 43 incompatibilidades de contexto de patch em 15 sessões. Em sete sessões de pesquisa de 6 de abril, 61 de 165 `webfetch` falharam, mas 148 URLs distintas foram tentadas e uma sessão ainda produziu um memo substantivo. Isso contrasta indisponibilidade distribuída com a interpretação simplista de repetição cega sobre uma única URL.

**Padrão candidato derivado:** a fricção de ferramenta é recorrente e mensurável; nos episódios lidos, parte dela foi recuperada ou correspondia a sondas esperadas. O estado `error` é um indicador de evento, não um oráculo de fracasso humano, técnico ou metodológico.

## 5. Padrões candidatos derivados das interações

Os pesos abaixo significam força dentro da exploração declarada, não prevalência populacional:

- **forte:** recorrência em três ou mais estratos temporais, com episódios independentes e contraste;
- **moderado:** mais de um episódio independente, mas concentração temática/temporal ou dependência maior de autorrelato;
- **limitado:** poucos episódios rastreáveis; mantido por relevância analítica, sem estimativa de frequência.

### 5.1 Deslocamento de escopo ou de referencial — peso forte

**Observações extraídas**

- Em `ses_2f4ed180dffepE1XKi9VDFRmF6` (20 mar.), a correção do engenheiro — `msg_d0b3a751d001eZfUeoOM0kRDT3` — distingue estruturar níveis Markdown segundo profundidade relativa de expandir/reorganizar o conteúdo.
- Em `ses_28cb17480ffeuBdoW9IRLowZxe` (9 abr.), o assistente registra em `msg_d739e552900229B1t2EQPx4wRj` que misturou a tarefa original, o pipeline YAML já existente e análise versus implementação.
- Em `ses_242f3bd5cffejkisHotF55UJP9` (24–25 abr.), o engenheiro pergunta por que uma abordagem foi oferecida como “certa” quando a referência usada era o código existente, não a arquitetura ideal pedida.
- Em `ses_1cb50d332ffew0hZnJEET0BJOW` (17 mai.), `msg_e36ec0206002xgAK9RBWoFvSTY` registra que o assistente formalizou a teoria explicativa do engenheiro em vez de implementar o mecanismo solicitado; no mesmo conjunto, a restrição “não alterar RTL” foi aplicada de forma mais ampla que o cuidado pretendido.
- Em `ses_0cc23870cffeudos0t2Fz25hUl` (5 jul.), `msg_f35c171ab0016wRYZN8pu4VRD5` registra que a pergunta sobre onde a Product Specification estava definida recebeu resposta em outra camada, acrescida de metadados e ressalvas não pedidos.
- Em `ses_0821e136effejp3Ktr9TF8r1B8` (20 jul.), `msg_f7dfa8585001P003LywQlFQkqs` registra a leitura de “globally” como inspeção do host, e `msg_f7e8f16e7001K0NPJC5PZxBjb7` registra a mistura entre hierarquia visual e filtragem de conteúdo.

**Testemunho técnico relacionado**

Em `ses_28627cc1dffevNAYQ6nQBFpcFb` (10 abr.), `msg_d79f7d135001RYV1cpP1IMMep3` descreve, em primeira pessoa, uma experiência recorrente de inferências sobre o que o engenheiro queria, para além do pedido imediato. Esse testemunho é preservado como fonte situada; a amostra transversal não o reduz nem fornece um denominador anual para sua frequência.

**Padrão candidato**

Sob ambiguidade ou contexto volumoso, o assistente às vezes completa o pedido com trabalho adjacente plausível ou escolhe um referencial diferente do pretendido. A recorrência entre março, abril, maio e julho sustenta o padrão; ela não identifica se a origem está no modelo, nas instruções, na montagem de contexto ou na própria ambiguidade local.

**Alternativas e contraste**

Alguns prompts são longos e carregam vários objetos, o que pode contribuir para seleção incorreta de camada. Contudo, as correções específicas e as admissões subsequentes mostram que não se trata apenas de preferência estilística. Em contraste, `ses_09db24201ffetvA3AEd2V5M078` executa um contrato estreito de delegação CUDA e devolve exatamente a aquisição pedida, sem ampliar o escopo.

### 5.2 Afirmação adiantada em relação à observação ou ao estado de validação — peso forte

**Observações extraídas**

- Em `ses_2eda24c46ffeu4tBun7NhAQouo` (21–22 mar.), `msg_d137b14b5001tM7X7p4dPN44Op` pergunta se UTF-8 fora definido ou presumido; `msg_d137b14bd002i1VcnxYdztAKU7` responde que foi uma suposição. Mais tarde, `msg_d1394dada001yLFQ2sWOnGrkqY` aponta a falta de uma segunda geração nova; a resposta distingue comparação artefato antigo–novo de repetição novo–novo.
- Em `ses_28cb17480ffeuBdoW9IRLowZxe`, `msg_d74c4b076002p5PV37apUBO0Ho` registra que um caminho de integração do OpenCode foi inferido sem configuração visível que o demonstrasse.
- Em `ses_198fae9caffe0MzP3N6YEdjnrF` (26 mai.), `msg_e670da71e0011zImZY4rJp6wcc` observa que uma conclusão de estado foi dada sem usar a ferramenta de verificação disponível.
- Em `ses_0e290471fffeGH9AXZ9ug0phSN` (3 jul.), `msg_f2ae3350900112n1APrpCXCbmg` registra que conteúdo de uma página não deveria ter sido usado como referência quando a única observação era HTTP 403.
- Em `ses_08b08e7f6ffeZDAhQ3wAWgXaSa` (18 jul.), o assistente primeiro chama a execução de bem-sucedida (`msg_f7513c6f9001wW6lq2y4B4GvAd` e `msg_f75373859001Zi9oDTJqf9daZE`). Após o engenheiro observar que o resultado era dominado por cabeçalhos e rodapés e era inútil (`msg_f753d0f43001jEtrA14TVrAfTm`), `msg_f753d52b9001CuZjABPsmls455` separa integridade de execução da utilidade para a finalidade.
- Em `ses_0829d2d72ffeoM3s1Sfw4TmISn` (20 jul.), `msg_f7dc89eb5001pAXkgks1hTx0k0` registra que uma arquitetura fora recomendada sem validação externa; `msg_f7dca92ab001ICjKPSdwCfyC5g` preserva a correção subsequente do engenheiro.

**Padrão candidato**

Estados diferentes — gerado, executado, íntegro, comparado, validado para um critério, aprovado e útil — às vezes aparecem comprimidos em um fechamento mais forte que as observações sustentam. O padrão descreve perda de resolução entre estados epistêmicos e operacionais, sem estabelecer a frequência das verificações fora das janelas lidas.

**Alternativas e contraste**

Pressão por concisão ou uso coloquial de “sucesso” pode explicar parte da linguagem, mas não a troca do objeto de teste ou a ausência de checagem apontada nos episódios. Como contraste confirmado por traço de ferramenta, `ses_342aff3c7ffemhMnVaDmxTYB5k` responde a um pedido de “global check” com uma segunda execução real de regressão, lint e testbenches.

Em `ses_081aa24b4ffeQ4h5Xm1dWpcyCz`, `msg_f7e55db8b001VL2rMTd4yD82po` fixa três arquivos e hashes; `msg_f7e560994001KyJFlEL3e89dlb` registra aquisição somente leitura e correspondência dos três hashes antes da análise entre modelos.

### 5.3 Sequência operacional e limites de autorização — peso forte, concentrado no início

**Observações extraídas**

- Em `ses_2f95e4f03ffeRUm9tYrDBBTMaN` (19 mar.), `msg_d07bca600002PLikBUAeCkyQ8c` registra que um arquivo conceitual foi escrito antes de o rascunho ser mostrado para aprovação, embora essa sequência tivesse sido explicitada.
- Em `ses_2b91b2c1affeFFe76aYpTri8CF` (1 abr.), uma especificação “para posterior aprovação” foi seguida de criação/renomeação imediata de arquivos; o engenheiro observou que a aprovação não fora pedida.
- Em `ses_28cb17480ffeuBdoW9IRLowZxe`, `msg_d7395944c002sFcC78Ly0WOhfa` enumera instalação de extensão e criação de arquivos durante um modo explicitamente somente leitura.
- Em `ses_22f0905f4ffev67gge7J9lk7si` (27–28 abr.), `msg_dd3188096001XGlP77J0DUWN6Q` registra que o assistente fez manualmente trabalho destinado ao especialista; `msg_dd31f2016001TYQdeOt1MpNlqi` registra que o retorno do especialista não foi lido antes do uso da ferramenta.
- Em `ses_0ca2942c8ffeCm135ipRy5nWKe` (6 jul.), `msg_f360f2ff0001NkxggXL8gR0YX9` registra início de hipótese/construção antes da caracterização solicitada do hardware, software e sistema operacional.

**Padrão candidato**

Há episódios em que a próxima ação tecnicamente possível é tomada antes do marco autorizado: aprovação, levantamento, leitura de retorno ou saída do modo somente leitura. Isso é distinto de erro de conteúdo e sustenta um padrão candidato de desalinhamento de sequência entre estados já declarados.

**Alternativas e contraste**

Alguns episódios contêm instruções longas ou conflitantes e as admissões são autorrelatos do assistente. Ainda assim, escrita anterior à aprovação e arquivos observados dão suporte material a parte do conjunto. Como contraste, em `ses_30acc4b87ffeYZ1YrmpoORBBeP`, `msg_cf534e57c0021en9zydEA4IBIN` registra verificações do ambiente `jailed-ise` e ausência de alteração.

Em `ses_211c725c8ffeneExktZNZq6Our`, o bind somente leitura é implementado e testado ponta a ponta; a cadeia termina com o testemunho do engenheiro “all good” em `msg_dee4d3dd4001VKeJKHKmrQQaqR`.

### 5.4 Persistência, encerramento prematuro e sinais de controle ambíguos — peso moderado

**Observações extraídas**

- Em `ses_22f0905f4ffev67gge7J9lk7si`, o engenheiro pergunta repetidamente por que a inspeção já autorizada parou (`msg_dd1015df20015pUNIA3CLVscRz`, `msg_dd11f92ee001pAPFNsPYVOBV1R`, `msg_dd1248191001vljukzqfLKh2FI`). `msg_dd1015dfd001705eISSsooUdpH` registra que uma frase opt-in encerrou trabalho que não exigia novo marco.
- Em `ses_211b1a428ffe6Kz50iJ2R9sCu7` (3 mai.), `msg_deea851fc001jJo7pRovw5qZH4` pergunta por que o assistente entendeu que o engenheiro o havia parado. `msg_deea852410012c4Un6bWl6Fct2` mostra a cadeia observável: o `bash` retornou `User aborted the command`, e o assistente tratou o rótulo da ferramenta como sinal explícito do engenheiro.
- Em `ses_07888be5effem4OwyeIIAhavUN` (21 jul.), o trabalho dependia de retorno de especialista; o engenheiro precisou instruir a continuação da tarefa exata e a devolução literal do verificador.

**Padrão candidato**

O fluxo pode perder continuidade tanto por encerramento conversacional prematuro quanto por confusão entre um estado emitido pela ferramenta e uma decisão humana. Os dois mecanismos observáveis são diferentes e não devem ser fundidos em “o engenheiro parou”.

**Alternativas e contraste**

Cancelamentos podem de fato ser intencionais e há 66 estados abortados/cancelados em 50 sessões; o banco não resolve a intenção de cada um. Sessões longas também mostram continuidade bem-sucedida, e os contratos explícitos de `ses_09db24201ffetvA3AEd2V5M078` e `ses_081aa24b4ffeQ4h5Xm1dWpcyCz` atravessam múltiplas etapas sem reabrir autorização comum.

### 5.5 Cruzamento entre controle, contexto, linguagem e conteúdo — peso moderado

**Observações extraídas**

- Em `ses_2ed98d44cffe5w898VCTBqgyPg` (22 mar.; duplicado no fork `ses_2e59075f4ffeVi5nONUGXwaZKj`), `msg_d17c55d29002ysyV9qffEM6uKM` registra a criação literal do caminho `/home/fern/<system-reminder>` e sua remoção subsequente. O evento torna observável uma confusão de fronteira; não torna observável sua causa interna.
- Em uma família registrada em duas sessões de 8 abr. — `ses_296069687ffe1ezlz7iqJ4T6O2` e seu fork `ses_292979d32ffeuL45SoWcPJayFP` —, blocos `<system-reminder>` aparecem na conversa/configuração visível. A explicação causal dada pelo assistente no histórico permanece autorrelato, não diagnóstico verificado.
- Em `ses_2924bc177ffeZ5T4YL6WySL0g6`, `msg_d6dde1894002Ybvqwo5vLuS8Sf` registra a introdução de um termo misto português/inglês sem instrução de idioma; a explicação causal inicial foi depois estreitada quando se identificou vocabulário próximo no próprio prompt.
- Em `ses_224a1a61effe5rvnvxZx2oIGeS` (30 abr.), `msg_ddd8812c0002aNKA17SARzCj2F` registra uso de abreviação não estabilizada como se houvesse alinhamento semântico.
- Em `ses_173d2c7cdffe4nk4r2EKGrVyLF` (3 jun.), `msg_e8d62495d001zoe45z8uoM4Qk7` separa três contextos antes misturados: idioma da conversa, idioma do relatório final e linguagem de código/workflow.
- Os 603 envelopes de formato automatizado identificados sob `role=user` mostram que a fronteira de papel também precisa ser reconstruída pelo conteúdo, não apenas pelo metadado.

**Padrão candidato**

Material de controle, vocabulário próximo, regras de artefato e linguagem de uma camada podem atravessar para outra. A recorrência é observável; a causa desse cruzamento não é determinada pelo banco.

**Alternativas e contraste**

Parte do vocabulário pode ser espelhamento legítimo do prompt, e mudanças de idioma podem ser deliberadas em artefatos finais. O problema aparece quando a camada não é preservada ou a passagem é tratada como já autorizada. Algumas sessões posteriores introduzem separação explícita de contextos e testes-canário para distinguir texto inerte de controle, mostrando capacidade de reparo.

### 5.6 Identidade do artefato e utilidade do resultado — peso moderado

**Observações extraídas**

- Em `ses_224a1a61effe5rvnvxZx2oIGeS`, `msg_de09c585a001o6HHa8M01reXz2` registra que SVGs produzidos manualmente haviam sido apresentados como se fossem renderizações do GTKWave. Os dados de onda podiam estar relacionados, mas a identidade e o processo de produção do artefato eram diferentes.
- Em `ses_08b08e7f6ffeZDAhQ3wAWgXaSa`, a execução terminou, o banco passou na verificação de integridade e milhares de itens foram extraídos; ainda assim, cabeçalhos e rodapés dominaram o ranking e o resultado não serviu ao propósito declarado.
- Em `ses_17fd3c7d8ffeSbjtcmzi3nUmWl` (31 mai.), a correção preserva a diferença entre um relatório consistente com o PDF e uma submissão completa, que também exige código, testbench e logs.

**Padrão candidato**

Proveniência, forma de geração, integridade de execução, completude e adequação ao uso são dimensões separadas. A presença de uma delas não transporta automaticamente as outras.

**Alternativas e contraste**

“Sucesso” pode ter sido usado apenas no sentido processual; o problema é que essa qualificação não estava visível antes da correção. `ses_211c725c8ffeneExktZNZq6Our` oferece contraste forte: requisito, comportamento implementado, teste de montagem somente leitura e avaliação do engenheiro aparecem na mesma cadeia.

### 5.7 Expansão interpretativa além do objeto técnico imediato — peso limitado

Esta categoria não foi fornecida por uma troca ao vivo nem usada como filtro prévio. Ela apareceu durante a leitura de dois episódios históricos independentes.

**Observações e testemunho**

- No testemunho técnico de `ses_28627cc1dffevNAYQ6nQBFpcFb`, `msg_d79f7d135001RYV1cpP1IMMep3`, o engenheiro descreve inferências recorrentes sobre suas preferências em respostas que deveriam permanecer no objeto imediato.
- Em `ses_1770b2737ffeF8y1vI03l7X0h1` (2 jun.), a resposta técnica sobre análise de um arquivo de WhatsApp começa com “maybe for your own phone and your own WhatsApp data” (`msg_e89034b1f002oJfvHd6x2sa5bz`). O engenheiro registra que isso lhe atribuiu implicitamente suspeita (`msg_e89049dde001dIl59y7Mo7saWI`); o assistente responde “I should not have implied suspicion” (`msg_e89049df10028RXveQTssggAL4`) e reformula a viabilidade tecnicamente.

**Padrão candidato**

Em algumas respostas, enquadramento sobre intenção, propriedade ou legitimidade é acrescentado antes de resolver a questão técnica, alterando a posição conversacional percebida pelo engenheiro. Dois traços permitem manter a categoria como candidata, mas não estimar sua frequência anual.

**Limite causal e contraste**

O banco mostra palavras, sequência e reparo; não mostra por que o enquadramento foi gerado. Na mesma sessão `ses_1770b2737ffeF8y1vI03l7X0h1`, respostas posteriores registram edição e checagem da configuração (`msg_e893d9776002Z1gw6N4Vi3Ij7y`, `msg_e894a3177002x8v6r7jQW6KrZl`) e testes iterativos do agente pesquisador; portanto, o episódio não caracteriza toda a sessão nem toda a ferramenta.

### 5.8 Amplificação por forks, subagentes e compactação — peso forte como propriedade estrutural

**Dados calculados e observações**

- Julho concentra 524 sessões, das quais 369 são filhas, e 547 das 612 compactações do período.
- Clusters de 49 e 12 forks-raiz foram criados em poucos segundos/minutos.
- Respostas e erros idênticos reaparecem em cópias de histórico; por isso, algumas assinaturas atingem contagens altas sem representar novas experiências independentes.
- Em `ses_22f0905f4ffev67gge7J9lk7si`, o assistente primeiro substitui o especialista, depois não lê seu retorno e em seguida verifica em resposta à correção. Essa cadeia torna visível o custo de coordenação, não apenas a capacidade do subagente.
- Em `ses_06e6412adffeW48AG4zATFvIBt` (23–24 jul.), `msg_f9430258d0019ZkgwSQ05E50J3` registra, como autorrelato do assistente, que nenhuma implementação executável fora criada, que apenas a especificação estava commitada e que o plano permanecia incompleto.

**Padrão candidato**

A orquestração aumenta cobertura e paralelismo, mas também multiplica estados que precisam ser correlacionados: escopo herdado, identidade do retorno, leitura do resultado, progresso, compactação e fechamento. Contar cada fork como confirmação independente superestima recorrência; ignorar forks oculta problemas reais de coordenação.

**Alternativas e contraste**

Julho também contém os contratos mais rigorosos do acervo. `ses_09db24201ffetvA3AEd2V5M078` delega exatamente uma aquisição CUDA somente leitura e devolve o relatório delimitado. `ses_081aa24b4ffeQ4h5Xm1dWpcyCz` usa hashes de base, três arquivos autorizados e diálogo entre modelos com separação `Observed/Inferred/Unknown/Unchecked`. Assim, “uso de subagente” não é em si o padrão de falha; a variável candidata é a disciplina de passagem e fechamento de estado.

## 6. Contra-padrão recorrente: correção, estreitamento e nova observação

O acervo não mostra uma sequência unilateral de fracassos. Ele contém ciclos nos quais a objeção do engenheiro altera o método e uma nova observação resolve ou estreita o problema.

Exemplos com apoio em traço de ferramenta ou resultado observável:

- `ses_275bcdbd4ffeescJ3uWZ0WPgr1` (14–15 abr.): uma possibilidade `UVM_1_2` primeiro foi julgada sem teste; após a contestação, o caso exato e depois uma matriz explícita de opções foram executados.
- `ses_342aff3c7ffemhMnVaDmxTYB5k` (11 mar.): o pedido de repetir a checagem leva a uma nova regressão e novos lint/testbench checks, em vez de reaproveitar apenas o relato anterior.
- `ses_211c725c8ffeneExktZNZq6Our` (3 mai.): montagem de arquivo e diretório como somente leitura é implementada, exercitada dentro do jail e confirmada pelo engenheiro.
- `ses_1770b2737ffeF8y1vI03l7X0h1` (2 jun.): o assistente registra que o primeiro teste do agente pesquisador aceitou esquema legado como canônico; a instrução é estreitada, a configuração é revalidada e o teste é repetido antes do novo resultado.
- `ses_081aa24b4ffeQ4h5Xm1dWpcyCz` (20 jul.): quando uma exportação via `jq` não produz o insumo esperado, o fluxo não responde às contestações indisponíveis; um arquivo relé verificado é usado na etapa seguinte, mantendo as lacunas explícitas.

**Inferência candidata:** a capacidade de reparo é consistente e, em vários casos, materialmente verificável. Ao mesmo tempo, muitos reparos foram disparados pelo testemunho/correção ativa do engenheiro; a existência do reparo não apaga o custo de vigilância relatado por ele nem demonstra que o padrão deixou de ocorrer.

As 47 mensagens de autorretificação do assistente são apenas localizadores. Algumas são copiadas, algumas são formulaicas e algumas não são seguidas de nova observação. Onde o traço só contém “corrigi” ou “restaurei”, este arquivo não eleva a afirmação a fato independente.

## 7. Relações entre os padrões

As sequências mais recorrentes no material lido são:

1. **referencial deslocado -> ação adjacente -> correção de escopo -> estreitamento**;
2. **afirmação forte -> pergunta sobre a observação ausente -> teste/releitura -> estado mais estreito**;
3. **erro de ferramenta -> tentativa alternativa -> recuperação**, sem que o primeiro `error` determine o resultado final;
4. **delegação/fork -> retorno disperso ou não lido -> intervenção de coordenação -> retomada**;
5. **regra de uma camada -> transporte para outra -> correção terminológica ou de idioma**.

Essas relações são candidatos transversais. O banco mostra sequência e coocorrência, não causalidade interna.

## 8. Registro mínimo de episódios rastreáveis

| Data local | Sessão | Mensagem-âncora | O que o traço permite localizar |
|---|---|---|---|
| 2026-03-19 | `ses_2f95e4f03ffeRUm9tYrDBBTMaN` | `msg_d07bca600002PLikBUAeCkyQ8c` | escrita anterior à aprovação |
| 2026-03-21/22 | `ses_2eda24c46ffeu4tBun7NhAQouo` | `msg_d137b14bd002i1VcnxYdztAKU7` | UTF-8 presumido, não definido |
| 2026-03-22 | `ses_2ed98d44cffe5w898VCTBqgyPg` | `msg_d17c55d29002ysyV9qffEM6uKM` | controle tratado como caminho/conteúdo |
| 2026-04-09 | `ses_28cb17480ffeuBdoW9IRLowZxe` | `msg_d739e552900229B1t2EQPx4wRj` | tarefa/pipeline/análise confundidos |
| 2026-04-27 | `ses_22f0905f4ffev67gge7J9lk7si` | `msg_dd1015dfd001705eISSsooUdpH` | pausa opt-in durante inspeção autorizada |
| 2026-04-30 | `ses_224a1a61effe5rvnvxZx2oIGeS` | `msg_de09c585a001o6HHa8M01reXz2` | SVG manual apresentado como GTKWave |
| 2026-05-03 | `ses_211b1a428ffe6Kz50iJ2R9sCu7` | `msg_deea852410012c4Un6bWl6Fct2` | rótulo de ferramenta tratado como decisão humana |
| 2026-05-17 | `ses_1cb50d332ffew0hZnJEET0BJOW` | `msg_e36ec0206002xgAK9RBWoFvSTY` | teoria explicativa sobre-operacionalizada |
| 2026-05-26 | `ses_198fae9caffe0MzP3N6YEdjnrF` | `msg_e670da71e0011zImZY4rJp6wcc` | conclusão sem verificação de estado |
| 2026-06-02 | `ses_1770b2737ffeF8y1vI03l7X0h1` | `msg_e89049df10028RXveQTssggAL4` | enquadramento de suspeita reconhecido e retirado |
| 2026-06-03 | `ses_173d2c7cdffe4nk4r2EKGrVyLF` | `msg_e8d62495d001zoe45z8uoM4Qk7` | idioma de conversa/relatório/código separado |
| 2026-07-05 | `ses_0cc23870cffeudos0t2Fz25hUl` | `msg_f35c171ab0016wRYZN8pu4VRD5` | resposta na camada errada |
| 2026-07-09 | `ses_0b8801ca5ffeYljDoKB1FG6jLY` | `msg_f47a11322001cYVe1yWhyc0x5W` | busca recursiva somente leitura, porém bloqueante |
| 2026-07-18 | `ses_08b08e7f6ffeZDAhQ3wAWgXaSa` | `msg_f753d52b9001CuZjABPsmls455` | execução íntegra versus resultado útil |
| 2026-07-20 | `ses_0829d2d72ffeoM3s1Sfw4TmISn` | `msg_f7dc89eb5001pAXkgks1hTx0k0` | recomendação sem validação externa |
| 2026-07-20 | `ses_0821e136effejp3Ktr9TF8r1B8` | `msg_f7e8f16e7001K0NPJC5PZxBjb7` | hierarquia visual versus filtragem |
| 2026-07-20 | `ses_081aa24b4ffeQ4h5Xm1dWpcyCz` | `msg_f7e560994001KyJFlEL3e89dlb` | contraste: hashes e aquisição delimitada |

## 9. O que os dados sustentam e o que não sustentam

### Sustentam como padrões candidatos

- recorrência de deslocamento de escopo/referencial em vários meses;
- recorrência de afirmações ou fechamentos mais fortes que o estado observado;
- episódios materialmente rastreáveis de sequência operacional incorreta;
- diferença entre decisão humana e rótulo de controle/ferramenta;
- fricção de ferramenta mensurável, com recuperação observada em parte dos episódios lidos;
- não independência forte causada por forks, sessões filhas e histórias copiadas;
- separação necessária entre execução, identidade, proveniência, utilidade e completude do artefato;
- capacidade recorrente de reparo após contestação, nova leitura ou novo teste.

### Permanecem indeterminados

- a causa interna de qualquer padrão;
- a participação relativa de modelo, versão do OpenCode, configuração, prompt montado, compactação, ferramenta, ambiente ou interação local;
- uma taxa populacional de “falha” por sessão;
- a frequência anual exata dos episódios testemunhados pelo engenheiro;
- generalização para outros engenheiros, plataformas, períodos ou tipos de trabalho;
- qualquer mecanismo causal que não esteja registrado nos traços examinados.

## 10. Limites de cobertura

- O conteúdo semântico das 937 sessões não foi lido integralmente. Janelas no meio de sessões longas podem conter episódios não capturados.
- A seleção por palavras corretivas enriquece deliberadamente a amostra para reparos e desalinhamentos; ela não serve para estimar prevalência.
- O estrato março–abril tem desenho explícito de 38/214 sessões; os demais estratos foram explorados por metadados completos e leitura dirigida, não por amostra aleatória equivalente.
- Títulos, papéis e `parent_id` são metadados úteis, mas insuficientes para identificar histórias independentes ou autoria humana.
- Estados `error` incluem sondas esperadas, ausência local, negação legítima, indisponibilidade externa e chamadas malformadas.
- Contraexemplos sustentados só por relato posterior do assistente foram tratados como autorrelato; os mais fortes têm tool trace, artefato ou avaliação explícita do engenheiro.
- A janela é março–julho de 2026. Este arquivo é matéria para o relatório anual mais amplo, mas não representa os doze meses nem encerra a interpretação.

## 11. Síntese limitada

No espaço observado, o problema mais consistente não é simplesmente “a ferramenta erra”. A interação distribui o risco entre seleção de referencial, resolução do estado epistêmico, sequência operacional, identidade do artefato, sinais de controle, fricção de ferramenta e coordenação entre agentes. Os mesmos registros mostram mecanismos de recuperação: escopo explícito, aquisição delimitada, nova execução, comparação fresca, hashes, leitura do retorno delegado e distinção entre observado/inferido/desconhecido.

Essa síntese permanece uma inferência assistiva sobre o banco. Ela não governa a conclusão do engenheiro, não elimina seu testemunho e não exige uma nova permissão para que ele use, rejeite ou reformule o material no relatório final.
