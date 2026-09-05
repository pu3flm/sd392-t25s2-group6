# Context runtime POC (Erlang/OTP)

Pequeno experimento falsificável sobre um “context runtime”. Não é arquitetura de
produção, prova filosófica, alegação de consciência, aprendizado autônomo ou RAG.

## Executar

Requer Erlang/OTP 26 ou compatível.

```sh
make test
make demo
```

`make demo` recria `_demo_state/` e imprime linhas marcadas como `IMPLEMENTED`,
`SIMULATED_BY_TEST_EVENT`, `OBSERVED` e `HYPOTHESIS_NOT_DEMONSTRATED`.

Para o caminho vivo, um cliente envia o evento bruto junto de interpretações
paralelas provisórias por `context_manager:ingest_live/5` e recupera a projeção
por `context_manager:projection/1`. O manager não escolhe uma interpretação:
uma correção externa pode revisar ou invalidar candidatas posteriormente.

## Desenho mínimo

`ctx_sup` inicia um `context_manager` e três workers (`research`, `operations` e
`reflection`) com estratégia `one_for_one`. Processos são unidades temporárias;
eles não são os “nós” conceituais. O grafo semântico — símbolos, revisões,
relações e tombstones — é dado versionado mantido pelo manager e persistido em
snapshot mais journal DETS.

O contrato explícito do substrato deste POC é:

- memória: número limitado de símbolos quentes;
- persistência: snapshot da aplicação + journal/nós em DETS;
- concorrência: um manager serializa mutações semânticas; workers concorrem como
  clientes e reiniciam localmente;
- tempo: sequência lógica de eventos, não relógio nem garantia causal distribuída.

Todos os workers recebem somente a mesma semente mínima: preservar propósito e
proveniência; tornar erros/correções visíveis; considerar consequências antes de
agir; não transformar sinal em autoridade. Escopos e eventos permanecem locais.

Sob pressão, grupos de símbolos não protegidos vão para armazenamento frio no
nível da aplicação. A escolha usa proteção rígida e sinais ordenados visíveis
(último toque, acessos, invalidação e identificador), não um score soberano. Um
token curto pode reidratar o grupo apontado. `hibernate` não é usado nem descrito
como paginação.

Três demandas do mesmo tipo criam apenas uma política candidata latente. Somente
um evento explícito a promove; outro a reverte. O POC não executa trabalho de um
símbolo dormente nem agenda automaticamente a candidata.

## O que a demonstração mostra

- herança comum e divergência local observáveis;
- grafo de dados separado da topologia de processos;
- falha/restart local de worker com estado relevante recuperado e event IDs
  deduplicados;
- histórico de correção, tombstone e reativação sem apagamento;
- eviction/rehidratação de subgrafo com orçamento quente pequeno;
- recorrência como sinal, promoção explícita e reversão;
- alterações amortizadas por evento, sem parada global de otimização.

## O que não mostra

Não demonstra consciência, agência, aprendizado autônomo, equivalência entre
workers, causalidade distribuída, segurança de produção, consenso, escalabilidade
ou que “semelhança de família” vá além da semente e das regras compartilhadas.
Também não prova que esta heurística de hot/cold seja boa fora do cenário pequeno.

## Falhas e limites observados

- o manager único é simples e torna a concorrência determinística, mas é gargalo;
- DETS + snapshot cobre recuperação deste experimento, não transações multiwriter;
- a deduplicação cresce com o journal e não possui compactação;
- grupos maiores que o orçamento podem permanecer acima do limite quando todos
  os demais símbolos estão rigidamente protegidos; isso fica visível no status;
- recorrência é contagem sintética de eventos, sem inferência de intenção.
