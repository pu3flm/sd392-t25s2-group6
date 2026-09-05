# Ontologia antes da especificação: intenção, correlação e memória de um processo de modelagem

## Nota de enquadramento

Este texto constitui uma peça de elaboração conceitual para um trabalho em desenvolvimento. Seu objeto não é ainda a especificação técnica de um programa, tampouco a defesa de uma implementação particular. O que se procura estabelecer é a camada anterior: a ontologia que permite dizer **o que existe no domínio**, **que espécies de relação podem existir**, **o que faz uma relação ser pertinente** e **como um processo de elaboração modifica o sentido daquilo que já havia sido formulado**.

A hipótese central é simples, mas tem consequências extensas: um grafo de contexto não adquire sentido apenas porque aproxima dois pontos. A correlação só se torna inteligível quando se preserva o nexo que a tornou relevante naquela elaboração. Esse nexo não é a motivação biográfica de quem iniciou o projeto, nem uma explicação psicológica inventada pelo sistema. É a **dimensão intencional da própria relação**: o para quê, em função de quê e dentro de qual direção de pensamento aquela ligação foi produzida, mantida, corrigida ou rejeitada.

É dessa ontologia — e não diretamente da conversa, do código ou de uma lista de funcionalidades — que uma especificação operacional deve ser derivada.

## 1. O problema anterior ao software

Grande parte das falhas atribuídas à implementação começa antes de qualquer linha de código. Um sistema pode estar disponível, responder corretamente a testes internos e conservar dados sem realizar o objeto que deveria ter sido construído. Isso ocorre quando a passagem entre o domínio pensado e o comportamento programado elimina justamente aquilo que dava sentido ao problema. A máquina executa uma especificação; a especificação representa um modelo; mas o modelo pode ter sido produzido a partir de compromissos ontológicos errados.

O erro aparece com nitidez quando uma relação é reduzida a uma aresta sem história. Dois símbolos podem ter ocorrido próximos, ter sido mencionados repetidamente ou ter semelhança lexical, sem que qualquer desses fatos explique por que eles passaram a integrar a mesma elaboração. A proximidade é um indício. A recorrência é outro. Nenhuma delas, isoladamente, constitui significado, verdade, prioridade ou autorização.

Por isso, antes de perguntar como armazenar nós, versionar arestas, reidratar memória ou supervisionar processos, é preciso perguntar o que um nó e uma relação **são neste domínio**. Também é necessário determinar o que distingue uma hipótese de uma afirmação, uma ironia de uma instrução, uma correção de uma simples repetição e uma intenção de uma ordem executável. Essas distinções não são detalhes de interface: são compromissos sobre a realidade que o sistema pretende representar.

Na engenharia do conhecimento, Thomas Gruber definiu ontologia como uma especificação explícita de uma conceptualização e a descreveu como um vocabulário representacional composto por classes, relações, funções e outros objetos de um domínio compartilhado. O ponto relevante aqui é que a ontologia não é uma coleção decorativa de palavras: ela explicita o modo como um domínio foi concebido para que essa concepção possa ser representada e reutilizada ([Gruber, 1993](https://tomgruber.org/writing/ontolingua-kaj-1993.pdf)). Guarino e Giaretta mostraram, posteriormente, que o termo é usado em vários níveis — sistema conceitual informal, descrição semântica formal, teoria lógica, vocabulário ou especificação de uma conceptualização — e que qualquer trabalho rigoroso precisa declarar em qual sentido o emprega ([Guarino e Giaretta, 1995](https://www.loa.istc.cnr.it/old/Papers/KBKS95.pdf)).

Neste trabalho, **ontologia** designa o conjunto explícito e revisável de compromissos sobre as entidades, relações, estados, eventos, papéis, limites e critérios de identidade do context runtime. Ela é anterior à especificação **operacional** do software, mas não é anterior a toda especificação: a própria ontologia é uma especificação conceitual. Essa precisão impede um equívoco terminológico. Não se trata de opor ontologia a especificação em sentido absoluto, e sim de distinguir a especificação do domínio da especificação do comportamento da máquina.

## 2. Ontologia, modelo, grafo, arquitetura e especificação

Esses termos não são intercambiáveis.

A ontologia declara os tipos de coisa cuja existência o trabalho assume e as condições gerais sob as quais elas podem se relacionar. O modelo conceitual seleciona e organiza esses compromissos para descrever um problema determinado. O grafo é uma possível estrutura de instanciação desse modelo: nele aparecem eventos, símbolos, interpretações e relações concretas, situadas no tempo. A arquitetura descreve os conceitos e propriedades fundamentais que organizam o sistema e sua evolução. A especificação operacional define o comportamento observável que uma máquina deve realizar. A implementação, por fim, escolhe mecanismos e substratos capazes de satisfazer essa especificação.

A distinção encontra apoio em tradições diferentes. A recomendação OWL 2 do W3C apresenta ontologias computacionais em termos de classes, propriedades, indivíduos, axiomas e significado formal, deixando claro que uma ontologia é declarativa e que os algoritmos usados para raciocinar sobre ela pertencem às implementações ([W3C, *OWL 2 Primer*](https://www.w3.org/TR/owl-primer/)). A pesquisa em modelagem conceitual, por sua vez, caracteriza o trabalho como identificação, análise e descrição dos conceitos e restrições essenciais de um universo de discurso; a adequação ontológica avalia até que ponto o modelo corresponde às situações que pretende representar ([Guizzardi, 2005](https://research.utwente.nl/en/publications/ontological-foundations-for-structural-conceptual-models/)).

Também é necessário separar a arquitetura de sua descrição. A ISO/IEC/IEEE 42010 distingue os conceitos e propriedades fundamentais de uma entidade do artefato usado para expressá-los, e afirma que o propósito de uma descrição arquitetural determina seu escopo ([ISO/IEC/IEEE 42010:2022](https://www.iso.org/standard/74393.html)). Essa distinção é particularmente importante aqui: o documento não deve ser confundido com o fenômeno vivo que descreve, assim como o estado gravado do grafo não deve ser confundido com o processo temporal que o produziu.

Podemos, portanto, organizar as camadas da seguinte maneira:

1. **Ontologia:** o que pode existir e o que as relações significam.
2. **Modelo conceitual:** como esses compromissos descrevem este problema.
3. **História de modelagem:** como o modelo foi sendo afirmado, corrigido, bifurcado e consolidado.
4. **Arquitetura:** que organização preserva esses compromissos em um sistema.
5. **Especificação operacional:** o que a máquina deve observar, transformar, devolver e impedir.
6. **Implementação:** quais processos, linguagens, armazenamentos e interfaces realizam a especificação.
7. **Evidência:** o que permite a um observador independente verificar se o efeito pretendido ocorreu.

Pular a primeira camada não acelera o desenvolvimento. Apenas faz com que escolhas ontológicas sejam tomadas silenciosamente pelo programador, pelo modelo ou pela estrutura dos dados. Uma árvore imposta onde existem bifurcações, convergências e ciclos não é uma simplificação neutra; é uma decisão sobre a natureza do domínio. Um campo único de “confiança” que mistura recorrência, verdade, importância e autoridade também não é conveniência: é a fusão de categorias ontologicamente diferentes.

## 3. A intenção como dimensão ontológica da relação

Neste trabalho, intenção não significa “a razão pessoal pela qual alguém acordou e decidiu construir um sistema”. Essa pergunta pode ser relevante em outra seção, mas não define o conceito em jogo. A intenção aqui responde a uma questão interna ao modelo: **por que esta relação existe nesta elaboração?**

Essa pergunta introduz uma semântica que não cabe na mera topologia. Uma aresta informa que dois elementos estão relacionados; seu tipo pode informar se um elemento revisa, contradiz, exemplifica, deriva de ou ativa outro. Ainda assim, duas relações do mesmo tipo podem cumprir funções distintas. Uma analogia pode ter sido introduzida para testar um limite, para explicar um conceito, para produzir humor, para provocar uma correção ou para autorizar uma transformação. Sem o nexo intencional, o sistema registra a forma aparente do vínculo, mas perde sua função na elaboração.

A engenharia de requisitos orientada a objetivos fornece uma validação externa importante para essa distinção. Eric Yu separa a fase inicial, dedicada a compreender por que um sistema é necessário, quais interesses estão em jogo e que alternativas poderiam satisfazê-los, da fase posterior, concentrada em descrever com precisão o que o sistema deve fazer. Seu modelo trata atores como portadores de propriedades intencionais — objetivos, crenças, capacidades e compromissos — e representa relações intencionais, não apenas fluxos de entrada e saída ([Yu, 1997](https://www.cs.toronto.edu/pub/eric/RE97.pdf)). Isso não significa que o context runtime deva adotar o formalismo *i\**. Significa que há precedente sólido para considerar o “porquê” uma parte modelável do domínio, e não um comentário dispensável ao lado da especificação.

O nexo intencional precisa ser distinguido de pelo menos cinco outras dimensões:

- **Correlação** informa que dois fenômenos variaram, apareceram ou foram aproximados de algum modo.
- **Causalidade** propõe que um fenômeno participa da produção de outro.
- **Proveniência** registra de onde veio uma entidade ou afirmação e por qual atividade ela foi gerada ou revisada.
- **Autoridade** determina quem pode validar, alterar ou transformar um estado em ação.
- **Intenção** situa a relação no campo de uma finalidade, de uma pergunta ou de uma direção de elaboração.

O modelo PROV-O do W3C é útil justamente para marcar a fronteira: ele permite representar entidades, atividades, agentes, derivação, revisão e atribuição de responsabilidade ([W3C, *PROV-O*](https://www.w3.org/TR/prov-o/)). Isso resolve parte da pergunta “de onde veio esta relação?”, mas não resolve automaticamente “para que esta relação foi formada neste raciocínio?”. Proveniência e intenção devem poder conversar, sem serem confundidas.

Uma relação contextual suficientemente expressiva não deveria ser tratada apenas como a tripla `origem — tipo — destino`. Ela precisa comportar, ao menos conceitualmente:

- os elementos relacionados;
- o tipo declarado ou hipotetizado do vínculo;
- o evento ou conjunto de eventos de que o vínculo deriva;
- sua posição temporal e suas revisões;
- sua modalidade epistêmica, como fato, hipótese, dúvida, exemplo, ironia ou instrução;
- seu nexo intencional, explícito ou inferido provisoriamente;
- o agente que o propôs e o agente que o validou, quando houver;
- o escopo dentro do qual é pertinente;
- a autoridade necessária para que produza efeitos fora do grafo;
- seu estado atual: provisório, consolidado, contestado, rejeitado, adormecido ou reativado.

O sistema não tem acesso direto à interioridade humana. Logo, uma intenção não declarada não pode ser gravada como fato psicológico. Ela deve permanecer hipótese contextual, ligada às evidências que a sustentam e aberta à correção do sujeito que conduz a elaboração. Este limite não reduz o valor da modelagem; ele é uma condição de honestidade epistêmica.

## 4. A narrativa como processo de modelagem

Uma conversa longa de elaboração não é simplesmente uma fonte da qual se extraem frases válidas. Ela é o próprio processo pelo qual o domínio ganha forma. Afirmações são propostas, levadas adiante, tensionadas, reformuladas e, às vezes, recusadas. O resultado final não está contido em uma única intervenção: ele emerge da história de transformações.

Isso exige uma leitura temporal. Quando uma formulação é incorporada e passa a sustentar desenvolvimentos posteriores, há evidência de consolidação. Essa consolidação, entretanto, é provisória: não equivale a uma aprovação universal de todas as palavras usadas. Uma correção posterior pode restringir o alcance de uma noção anterior sem eliminar o percurso que tornou a correção possível. Uma rejeição explícita não é ruído descartável; ela delimita o domínio ao mostrar o que a formulação não pode significar. Uma contradição ainda não resolvida não deve ser vencida por conveniência: deve permanecer como bifurcação aberta.

Portanto, o corpus narrativo contém ao menos quatro espécies de evidência de modelagem:

1. **Proposição:** introduz uma entidade, relação, distinção ou hipótese.
2. **Continuação produtiva:** emprega a proposição em novas elaborações e lhe confere estabilidade provisória.
3. **Correção:** altera significado, escopo, modalidade ou relação sem apagar a proveniência.
4. **Rejeição:** estabelece uma fronteira negativa e impede que determinada interpretação volte como se permanecesse válida.

Recorrência aumenta a estabilidade contextual de uma formulação, mas não a converte automaticamente em verdade. Ausência de objeção pode ser indício de incorporação dentro de uma sequência específica, mas não autorização irrestrita. Ironia, exemplo, brincadeira, pergunta e hipótese não podem ser promovidos a ordem apenas porque contêm verbos de ação. A modalidade epistêmica e pragmática do evento faz parte do que precisa ser preservado.

Essa leitura permite compreender por que a chamada “anti-especificação” tem valor positivo. O que foi recusado durante o processo não é apenas material que sobrou depois da limpeza. Muitas vezes, a rejeição é a forma mais nítida de uma restrição ontológica. Dizer “não é um jogo, é uma arquitetura” não acrescenta somente um rótulo preferido; impede que o sistema trate o fenômeno como performance lúdica e perca seu caráter estrutural. Dizer “não é registro, é runtime vivo” não elimina a necessidade de persistência; impede que persistência seja apresentada como substituta da operação temporal que se queria observar.

Consequentemente, a extração correta não produz um resumo médio das posições encontradas. Ela reconstrói um **estado versionado do modelo**, no qual cada compromisso conserva sua origem, suas revisões e o motivo de seu estado atual. O documento final é uma projeção legível desse estado, não a autoridade que o cria.

## 5. Da ontologia à especificação operacional

Depois que os compromissos ontológicos estão explícitos, pode-se derivar a especificação. “Derivar” é a palavra decisiva: o comportamento da máquina não deve nascer de uma preferência do implementador, mas de uma transformação rastreável entre o que o domínio requer e o que o sistema consegue observar e controlar.

Jackson e Zave distinguem requisito e especificação de modo útil. Um requisito expressa uma relação desejada no ambiente em que o efeito será percebido; uma especificação descreve comportamento da máquina suficiente para produzir esse efeito, limitado a fenômenos compartilhados com a máquina e a ações que ela pode controlar ([Jackson e Zave, 1995](https://www.pamelazave.com/turnstile.pdf)). Essa distinção impede atribuir ao runtime poderes que ele não possui. O desejo de preservar a intenção humana é um requisito do ambiente; a máquina não pode observar diretamente essa intenção. Ela pode, porém, preservar eventos, manter hipóteses concorrentes, solicitar confirmação quando necessário, registrar correções e impedir que uma hipótese não validada seja promovida a comando.

A derivação pode ser expressa assim:

**compromisso ontológico → consequência arquitetural → obrigação operacional → evidência de aceitação**.

Por exemplo:

- Se uma interpretação pode permanecer ambígua, a arquitetura precisa aceitar ramos paralelos; a operação não pode escolher silenciosamente um deles; o teste deve demonstrar que a correção posterior altera o ramo pertinente sem reescrever o evento original.
- Se recorrência não equivale a autoridade, a arquitetura precisa separar estabilidade contextual de permissão; a operação não pode executar uma ação apenas porque ela foi mencionada várias vezes; o teste deve mostrar a ação bloqueada na ausência de autorização.
- Se contexto é evolução temporal, a arquitetura precisa conservar versões e relações de revisão; a operação deve reidratar não apenas o último texto, mas o caminho relevante; o teste deve demonstrar continuidade após interrupção sem inventar uma continuidade inexistente.
- Se o modelo é um cliente substituível, a arquitetura precisa manter o estado fora dele; a operação deve fornecer uma projeção equivalente a outro cliente; o teste deve demonstrar a troca sem perda do estado ontológico.

Essa cadeia evita dois atalhos frequentes. O primeiro é escrever funcionalidades a partir de palavras soltas e, depois, declarar que o conjunto corresponde à intenção original. O segundo é deixar o teste ser definido pelo mesmo componente que escolheu a interpretação e executou a solução. Um teste desse tipo pode provar coerência interna, mas não aderência ao objeto especificado.

## 6. A anti-especificação como fronteira derivada

“Anti-especificação” é empregado aqui como um termo próprio do trabalho, não como nomenclatura universal da engenharia de software. Ele nomeia o conjunto organizado de transformações, equivalências e comportamentos que violariam os compromissos ontológicos, mesmo quando produzissem uma aplicação tecnicamente funcional.

Há analogias relevantes na literatura. A análise de obstáculos em engenharia de requisitos orientada a objetivos examina condições que impedem objetivos, expõe pressupostos idealizados e deriva requisitos defensivos para tornar o sistema mais robusto ([van Lamsweerde e Letier, 2000](https://dial.uclouvain.be/pr/boreal/object/boreal%3A43232)). A anti-especificação proposta aqui tem alcance ligeiramente diferente: além de falhas e exceções, ela inclui **desfigurações semânticas** que podem passar despercebidas em testes convencionais.

Seis classes iniciais de anti-especificação podem ser reconhecidas.

**Violação ontológica:** reduzir eventos, símbolos, interpretações e processos a uma única espécie de nó; impor hierarquia estrita a um domínio que admite convergência, ciclos e mudança de papel; tratar estado persistido como equivalente ao processo vivo.

**Violação intencional:** registrar correlação sem preservar sua função na elaboração; substituir o “para quê desta relação” por uma motivação genérica do projeto; completar uma intenção não expressa e armazená-la como fato.

**Violação epistêmica:** converter hipótese em afirmação, exemplo em requisito, ironia em comando, recorrência em verdade ou narrativa em prova. A resposta do modelo pode orientar e demonstrar comportamento; não constitui, sozinha, evidência independente de que o sistema cumpriu a especificação.

**Violação de autoridade:** confundir acesso técnico com autorização; transformar importância em permissão de execução; permitir que o componente observado altere o mecanismo que deveria testemunhar sua conduta; alegar responsabilidade sem possuir capacidade real de assumir as consequências.

**Violação temporal:** apagar correções anteriores, sobrescrever a origem de uma relação, fabricar continuidade depois de uma lacuna ou reduzir a história a um estado final sem trilha de transformação.

**Violação operacional:** substituir o ensaio vivo por eventos sintéticos; afirmar que um serviço ativo prova a existência do circuito; usar testes escolhidos pela implementação para validar um critério que pertence ao observador externo; permitir que uma inspeção modifique o objeto inspecionado.

A anti-especificação não é uma lista de erros acidentais. Ela é o negativo necessário da ontologia: torna visíveis as fronteiras sem as quais uma implementação diferente poderia satisfazer as mesmas frases superficiais e ainda assim construir outro objeto.

## 7. Consequências para a arquitetura de um context runtime

A partir dessa ontologia, algumas consequências arquiteturais deixam de ser preferências e se tornam necessárias.

O evento bruto deve existir antes da interpretação. Fala, texto, pausa, interrupção, correção e outros sinais disponíveis entram como acontecimentos temporalmente ordenados, com proveniência. A interpretação cria novas entidades ligadas a esses acontecimentos; não os substitui.

A relação precisa ser tratada como objeto de primeira classe ou receber qualificação equivalente. Ela deve poder ter origem, tempo, escopo, modalidade, estado, revisão e nexo intencional. Isso permite que o sistema responda não apenas “quais pontos estão próximos?”, mas “por que esta aproximação foi relevante, em qual etapa e sob qual hipótese?”.

A elaboração deve admitir simultaneidade. Quando mais de uma leitura é plausível, o runtime conserva alternativas e posterga a consolidação. Uma pergunta curta pode ser feita quando a diferença altera materialmente a compreensão ou a ação; fora disso, a ambiguidade pode permanecer produtiva.

A memória deve ser seletiva sem ser amnésica. Apenas uma vizinhança relevante precisa entrar no contexto de um modelo a cada turno, mas a parte adormecida continua acessível e versionada. Um ponteiro semântico pode reativar um subgrafo compartilhado; ele não precisa carregar uma explicação autossuficiente, nem deve ser confundido com uma busca documental genérica.

O plano semântico e o plano de execução precisam permanecer distintos e ligados. Nós conceituais não equivalem a processos do sistema operacional ou da máquina virtual. Processos podem supervisionar ingestão, projeção, persistência ou ação; o grafo descreve o estado simbólico. Uma entidade pode referenciar um trabalhador ou uma execução, mas a falha de um processo e a revisão de um conceito são acontecimentos de naturezas diferentes.

Toda ação externa deve atravessar uma fronteira explícita de autoridade. O grafo pode conter desejo, objetivo, importância ou proposta de ferramenta sem que isso conceda permissão para executar. A autorização precisa ter escopo, origem e validade próprios. Quando a independência da evidência for requisito, o testemunho deve estar fora da autoridade do componente observado e não ser alterável por ele.

O modelo de linguagem deve ser cliente substituível do runtime, não proprietário do estado. Antes de responder, recebe uma projeção do subgrafo pertinente; depois, sua resposta e os efeitos realmente observados retornam como eventos distintos. O sistema não deve registrar como efeito aquilo que o modelo apenas afirmou ter feito.

Por fim, a escolha de Erlang/BEAM, outro runtime, um banco de grafos ou uma representação lógica pertence à camada de realização. Erlang pode oferecer processos leves, supervisão e recuperação localizada; OWL pode oferecer um formalismo declarativo para certas classes de axiomas. Nenhuma tecnologia, sozinha, resolve a ontologia. O compromisso é inverso: a tecnologia deve ser avaliada por sua capacidade de preservar o modelo que foi estabelecido.

## 8. O “porquê” que o sistema deve preservar

Chega-se, então, à pergunta decisiva: por que preservar intenção dentro da própria relação?

Porque uma estrutura que conserva apenas conteúdos e associações preserva o produto aparente do pensamento, mas perde sua direção. Ela sabe que dois pontos foram aproximados, porém não sabe se a aproximação foi uma conclusão, uma hipótese, uma provocação, um contraste ou um caminho já rejeitado. Ao reativar esse vínculo mais tarde, pode devolvê-lo com força pragmática diferente daquela que possuía. O problema não é apenas esquecer; é lembrar de modo ontologicamente errado.

O objetivo desta arquitetura é permitir que uma elaboração sobreviva às mudanças de janela, sessão, modelo e implementação sem congelar-se em um documento estático. Isso requer preservar não só *o que* foi dito, mas as transformações que fizeram determinada relação adquirir ou perder pertinência. A continuidade desejada não é a repetição literal do passado. É a possibilidade de retomar o processo no estado em que seus compromissos realmente se encontram.

Nesse sentido, a intenção funciona como princípio de organização contextual. Ela ajuda a decidir quais relações devem ser ativadas para uma questão presente, quais permanecem laterais, quais foram superadas e quais exigem nova validação. Não é um escore soberano nem uma licença de ação. É uma dimensão semântica que mantém a ligação entre estrutura e finalidade.

O ganho esperado também não se reduz a “melhor memória para uma IA”. Trata-se de criar um instrumento de modelagem sob domínio do usuário, no qual modelos diferentes possam participar da elaboração sem se tornarem donos de sua continuidade. A inteligência do arranjo não reside apenas no modelo que gera uma resposta; reside na capacidade do sistema de preservar distinções, mostrar proveniência, sustentar alternativas, receber correções e respeitar fronteiras de autoridade.

Esse é o ponto em que ontologia e prática se encontram. A ontologia impede que a implementação redefina silenciosamente o objeto. A história de modelagem impede que o documento finja ter nascido pronto. A especificação converte os compromissos em obrigações observáveis. A anti-especificação impede equivalências fraudulentas. E o ensaio conduzido por um observador externo verifica não se o software “parece inteligente”, mas se a estrutura preservada altera de fato o comportamento no sentido que estava sendo elaborado.

## 9. Tese de trabalho

Pode-se condensar a elaboração na seguinte tese:

> Um context runtime não é um repositório de falas nem um grafo de associações. É uma infraestrutura temporal de modelagem na qual eventos, símbolos, interpretações, relações e revisões permanecem ligados à proveniência, à modalidade epistêmica, ao escopo de autoridade e ao nexo intencional que lhes confere pertinência. Sua especificação operacional deve ser derivada dessa ontologia; sua anti-especificação deve registrar as transformações que a violariam; e sua validade só pode ser demonstrada por efeitos observáveis em um circuito vivo cujo critério não seja controlado pelo próprio componente avaliado.

Essa tese mantém separadas três perguntas que não podem voltar a ser fundidas:

1. **O que existe e o que significa?** — questão ontológica.
2. **O que a máquina deve fazer e impedir?** — questão de especificação.
3. **Como saber se ela realmente o fez?** — questão de evidência e observabilidade.

A intenção pertence à primeira pergunta quando qualifica o sentido e a pertinência das relações. Pode originar requisitos na segunda, mas não se reduz a eles. E não pode ser provada pela própria resposta da máquina na terceira.

## Referências de confrontação conceitual

- Gruber, T. R. (1993). [*A Translation Approach to Portable Ontology Specifications*](https://tomgruber.org/writing/ontolingua-kaj-1993.pdf).
- Guarino, N.; Giaretta, P. (1995). [*Ontologies and Knowledge Bases: Towards a Terminological Clarification*](https://www.loa.istc.cnr.it/old/Papers/KBKS95.pdf).
- Guizzardi, G. (2005). [*Ontological Foundations for Structural Conceptual Models*](https://research.utwente.nl/en/publications/ontological-foundations-for-structural-conceptual-models/).
- W3C (2012). [*OWL 2 Web Ontology Language Primer*](https://www.w3.org/TR/owl-primer/).
- W3C (2013). [*PROV-O: The PROV Ontology*](https://www.w3.org/TR/prov-o/).
- Yu, E. S. K. (1997). [*Towards Modelling and Reasoning Support for Early-Phase Requirements Engineering*](https://www.cs.toronto.edu/pub/eric/RE97.pdf).
- van Lamsweerde, A.; Letier, E. (2000). [*Handling Obstacles in Goal-Oriented Requirements Engineering*](https://dial.uclouvain.be/pr/boreal/object/boreal%3A43232).
- Jackson, M.; Zave, P. (1995). [*Deriving Specifications from Requirements: An Example*](https://www.pamelazave.com/turnstile.pdf).
- ISO/IEC/IEEE (2022). [*42010:2022 — Architecture Description*](https://www.iso.org/standard/74393.html).

## Nota sobre a validação externa

As referências acima não são apresentadas como origem da ontologia específica deste trabalho. Elas cumprem uma função de confrontação: confirmam distinções gerais entre conceptualização, ontologia, modelagem intencional, requisitos, arquitetura, especificação, proveniência e obstáculos. As categorias próprias — especialmente **nexo intencional** e **anti-especificação** no sentido aqui definido — permanecem propostas do trabalho e deverão ser avaliadas pelo conjunto da modelagem, não legitimadas por semelhança terminológica com a literatura.
