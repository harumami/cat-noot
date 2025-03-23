#import "@preview/cetz:0.3.4"

#let numbering_with_heading = n => numbering("1.1", counter(heading).get().first(), n)

#let mathblock = (
  kind: "mathblock",
  definition: [定義],
  axiom: [公理],
  theorem: [定理],
  lemma: [補題],
  proposition: [命題],
)

#let proof = body => {
  strong[証明]
  parbreak()
  body
  align(right, $qed$)
}

#set text(font: "Noto Serif JP", fallback: false, lang: "ja", region: "JP")
#set page(numbering: "1 / 1")
#set heading(numbering: "1.", supplement: it => if it.depth == 1 [章] else [節])
#set figure(caption: [], numbering: numbering_with_heading)
#set math.equation(numbering: n => "(" + numbering_with_heading(n) + ")")

#show heading.where(level: 1): it => {
  counter(figure.where(kind: mathblock.kind)).update(0)
  counter(math.equation).update(0)
  it
}

#show figure.where(kind: mathblock.kind): it => align(
  left,
  rect(width: 100%, stroke: gray, inset: (y: 1em), {
    it.caption
    it.body
  }),
)

#show figure.caption: it => terms.item(
  {
    it.supplement
    context it.counter.display(it.numbering)
  },
  it.body
)

#align(center, text(size: 2em)[
  圏論についての個人的ノート
])

#align(center, rect(width: 100%, inset: (y: 1em), {
  strong[注意]

  align(left)[
    このノートはあくまで個人的なものであり、その正確性については保証しない。
    また、独自の記法も使用する為、よく注意すること。
  ]
}))

#outline()

= 代数学と圏 <c3ce148399c64a229fb857fc6f0fb811>

圏は様々な概念を統一的に扱う数学的な方法を与える。
#ref(<c3ce148399c64a229fb857fc6f0fb811>)では簡単な導入と共にその定義を示す。

== 自然数と前順序 <2da7dc6cfbbd4065876df642d8c8d4c0>

自然数には大小関係$lt.eq$という二項関係がある。
この関係に基づいて自然数の集合$NN$を直線上の点として図示したものは数直線と呼ばれる。
このような図示は抽象概念の理解の良い助けとなるだろう。
そこで、一般の集合に対しても「大小関係」を考えられないだろうか、という疑問が生まれる。
このようにある概念を一般化するとき、まず第一にすべきことは対象のもつ性質の観察だ。
$lt.eq$に成り立つ法則として有名なものは次の4つである。

/ 反射律: 任意の$x$に対して$x lt.eq x$が成り立つ。
/ 推移律: 任意の$x, y, z$に対して$x lt.eq y$かつ$y lt.eq z$ならば$x lt.eq z$が成り立つ。
/ 反対称律: 任意の$x, y$に対して$x lt.eq y$かつ$y lt.eq x$ならば$x = y$が成り立つ。
/ 完全律: 任意の$x, y$に対して$x lt.eq y$か$y lt.eq x$の何れかが成り立つ。

次に議論すべきは、果たして一般の「大小関係」でこれらが成り立つかである。
そして、実は反対称律と完全律にはそれぞれが成り立たない「大小関係」が存在する。
例えば、複素数に対する絶対値による「大小関係」は反対称律を満たさない。
つまり、複素数の集合$CC$上の「大小関係」$R subset.eq CC^2$を$x R y <=> abs(x) lt.eq abs(y)$で定めれば、$1 R i$かつ$i R 1$だが$1 != i$である。
また、完全律が成り立たない「大小関係」の例としては包含関係$subset.eq$がある。
よって、ここでは反射律と推移律の2つが「大小関係」の最も本質的な性質であると考え、それに基づいて#ref(<4084391cdab14df2a09c7c111fcead60>)を考える。

#figure(
  caption: [前順序],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  集合$X$上の二項関係$R subset.eq X^2$が前順序であるとは次の条件を満たすことである。

  + 反射律$forall x in X, x R x$が成り立つ。
  + 推移律$forall x, y, z in X, x R y and y R z => x R z$が成り立つ。
] <4084391cdab14df2a09c7c111fcead60>

$subset.eq$は完全律を満たさないが、反射律と推移律は満たす。
よって、$subset.eq$は任意の集合上の前順序となる。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $subset.eq$は任意の集合上の前順序である。
] <6a6c297ff015466684127f2370b4fcec>

#proof[
  任意の集合$X, Y, Z$が反射律$X subset.eq X$と推移律$X subset.eq Y and Y subset.eq Z => X subset.eq Z$を満たすことは自明である。
]

前順序が存在するならば、それによって単なる集合は構造を持つようになる。
このような構造を与えるものをまとめて組にして考えることは良くある定義である。

#figure(
  caption: [前順序集合],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  前順序集合とは、集合$X$と$X$上の前順序$R$の組$(X, R)$である。
]

#ref(<6a6c297ff015466684127f2370b4fcec>)より任意の集合$X$に対して$(X, subset.eq)$は全順序集合である。
また、前順序が自明な場合は台集合のみを指して前順序集合とすることもある。
例えば$NN$上の全順序は一般に$lt.eq$なので、通常は$lt.eq$は省略して単に前順序集合$NN$と言う。
折角なので$NN$を実際に構成してみよう。

#figure(
  caption: [ペアノ構造],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  ペアノ構造とは、集合$N$、$N$の元$z in N$、単射$s: N -> N backslash {z}$の組$(N, z, s)$であって#ref(<b89addb4bee04500a3caaa5d8ab4267c>)を満たすものである。

  $ forall N' subset.eq N, (z in N' and (forall n in N', s(n) in N')) => N' = N $ <b89addb4bee04500a3caaa5d8ab4267c>
] <7c1db1faea5e4695ac24f24229ebbaa8>

#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)は所謂ペアノの公理を集合論の言葉で記述したものである。
直感的な理解としては、$(N, z, s)$をペアノ構造としたとき、$N$は自然数の集合、$z$は最少の自然数、$s$は$1$を加える関数となる。
また、#ref(<b89addb4bee04500a3caaa5d8ab4267c>)は数学的帰納法として知られるものである。
#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)はあくまで自然数の集合が満たすべき性質を定めたのみであり、具体的な構成は別に定義しなければならない。
しかし、良く知られているように自然数は無限にあり、その集合は外延的に記述することが出来ない。
よって、内包的な方法で何らかの集合の部分集合として定義する必要があり、そのためにはまず無限集合を見つける必要がある。
実は集合論にはそのための公理が用意されている。

#figure(
  caption: [無限公理],
  kind: mathblock.kind,
  supplement: mathblock.axiom,
)[
  ある集合$X$が存在して、$emptyset in X$と$forall x in X, x union {x} in X$を満たす。
] <5e5733feaedc49c283c2b66106256808>

よって、集合論では一般に#ref(<5e5733feaedc49c283c2b66106256808>)を用いた形で自然数を定める。
具体的なペアノ構造の構成を#ref(<f3f1aa06ad0b460f9a900a1e99bf9721>)で与える。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $z = emptyset, s(n) = n union {n}$、$z$を含み$s$について閉じた最少の集合を$N$とする。
  このとき$(N, z, s)$はペアノ構造である。
] <f3f1aa06ad0b460f9a900a1e99bf9721>

#proof[
  集合上の述語$P$を$P(M) = z in M and forall n in M, s(n) in M$とし、任意の集合$M$に対して集合$N(M)$を$N(M) = inter.big { M' subset.eq M | P(M') }$によって定める。
  $P(M_1), P(M_2)$を満たすような集合$M_1, M_2$を考えれば、$M_1 inter M_2 subset.eq M_1$かつ$P(M_1 inter M_2)$より$N(M_1) subset.eq M_1 inter M_2$である。
  よって$N(M_1) subset.eq M_2$となるが、この$M_2$は任意に取ったので、さらに$N(M_1) subset.eq N(M_2)$が言える。
  同様の議論より$N(M_2) subset.eq N(M_1)$が成り立ち、故に$N(M_1) = N(M_2)$である。
  無限公理によって$P(M)$を満たす集合$M$の存在は保証されているため、これを用いて$N = N(M)$と定義する。
  #ref(<b89addb4bee04500a3caaa5d8ab4267c>)は$N' subset.eq N$と$P(N')$を満たす任意の集合$N'$に対して$N' = N$となることを要求するが、$P(N')$より$N = N(N') subset.eq N'$となるのでこれを満たす。
  また、$s$が値域に$z$を含まない単射であることは定義より自明である。
  以上より、$(N, z, s)$はペアノ構造となる。
]

#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)から分かるように、最少の自然数が$1$である必要はない。
よって、ここでは集合論で一般的な、$0$を最少の自然数とする定義を採用する。

#figure(
  caption: [自然数],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  #ref(<f3f1aa06ad0b460f9a900a1e99bf9721>)によって定義されるペアノ構造を$(NN, 0, op("suc"))$する。
  また、$NN$を自然数の集合、$NN$の元を自然数と言う。
] <8eaa0cccd787486294d68396cff2b2a4>

$op("suc")(0), op("suc")(op("suc")(0)), op("suc")(op("suc")(op("suc")(0)))$のように、$0$に$op("suc")$を繰り返し適用することで好きなだけ自然数を得られる。
このようにして得られる自然数を順に$1, 2, 3, ... in NN$とする。
これらは具体的には次のような集合である。

$ 0 = emptyset = {} $
$ 1 = op("suc") 0 = {} union {0} = {0} $
$ 2 = op("suc") 1 = {0} union {1} = {0, 1} $
$ 3 = op("suc") 2 = {0, 1} union {2} = {0, 1, 2} $

ここから推察されることは、自然数$n$とは$n$より小さい自然数の集合であるということである。
これを示すための準備としてまず#ref(<f643367ee6ee479bb559182eb9d860e5>)、#ref(<798370fb6fba42dd8fd858a6c965bea6>)を示す。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.lemma,
)[
  任意の自然数$n_1, n_2 in NN$について、$n_1 subset op("suc") n_2$ならば$n_1 subset.eq n_2$が成り立つ。
] <f643367ee6ee479bb559182eb9d860e5>

#proof[
  集合$N$を$N = { n in NN | n subset op("suc") n_2 => n subset.eq n_2 }$で定義する。
  このとき、$0 = emptyset subset.eq n_2$より$0 in N$となる。
  次に、任意の$n in N$に対して$op("suc") n = n union {n} in N$であることを示す。
  $op("suc") n subset op("suc") n_2$を仮定すれば$n subset op("suc") n_2$と$n in op("suc") n_2$の両方が成り立ち、$n in N$を思い出せば$n subset op("suc") n_2$から$n subset.eq n_2$が成り立つ。
  さらに、$n in op("suc") n_2$からは$n in n_2$と$n = n_2$のどちらかが成り立ち、$n in n_2$ならば$n subset.eq n_2$と合わせて考えて$op("suc") n subset.eq n_2$が成り立つ。
  残った$n = n_2$の場合では仮定の$op("suc") n subset op("suc") n_2$と矛盾し、よって$op("suc") n in N$が成り立つ。
  以上の議論と#ref(<b89addb4bee04500a3caaa5d8ab4267c>)より$N = NN$となるので、$n_1 in NN = N$から$n_1 subset op("suc") n_2 => n_1 subset.eq n_2$が示された。
]

#ref(<f643367ee6ee479bb559182eb9d860e5>)では#ref(<b89addb4bee04500a3caaa5d8ab4267c>)を用いた証明を行ったが、これがよく数学的帰納法と呼ばれるものである。
以降、数学的帰納法を用いた証明では暗に#ref(<b89addb4bee04500a3caaa5d8ab4267c>)を使用しているものとする。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.lemma,
)[
  任意の自然数$n_1, n_2 in NN$について、$n_1 in n_2$と$n_1 subset n_2$は同値である。
] <798370fb6fba42dd8fd858a6c965bea6>

#proof[
  $n_2$に対する数学的帰納法で証明する。
  $n_2 = 0$の場合、どちらも明らかに成り立たないので同値である。
  よって、$n_2$で成り立つという仮定の下で$op("suc") n_2$でも成り立つことを示せば良い。
  $n_1 in op("suc") n_2$ならば$n_1 in n_2$と$n_1 = n_2$の何れかが成り立ち、どちらであっても$n_1 subset op("suc") n_2$である。
  一方、$n_1 subset op("suc") n_2$ならば#ref(<f643367ee6ee479bb559182eb9d860e5>)より$n_1 subset.eq n_2$であり、$n_1 subset n_2$と$n_1 = n_2$の両方で$n_1 in op("suc") n_2$が成り立つ。
]

$in$が$subset$と同値であるということは、$in$が$NN$の前順序を定めることを意味する。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $NN$上の二項関係$R$を$n_1 R n_2 <=> n_1 = n_2 or n_1 in n_2$で定める。
  このとき、$R$は前順序となる。
] <4662a662e47e4a6e8f35cd3889b99453>

#proof[
  #ref(<6a6c297ff015466684127f2370b4fcec>)及び#ref(<798370fb6fba42dd8fd858a6c965bea6>)より示される。
]

任意の自然数$n in NN$について$n in op("suc") n$は自明なので、#ref(<4662a662e47e4a6e8f35cd3889b99453>)は自然な大小関係$lt.eq$と同値であることが分かる。
より正確に言えば、#ref(<8eaa0cccd787486294d68396cff2b2a4>)における$NN$の自然な前順序とは#ref(<4662a662e47e4a6e8f35cd3889b99453>)が定める関係のことである。

#figure(
  caption: [自然数の前順序],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  #ref(<4662a662e47e4a6e8f35cd3889b99453>)によって定義される前順序を$lt.eq$とする。
]

このように、$NN$のような適切な集合を考えることによって集合論上で自然数論を展開することができる。
ペアノ算術のような自然数論の為の論理体系を用いることも出来るが、一般的に用いられるのは集合論を用いる方法である。
何故なら、新しい公理系を作るということは、それが矛盾しないことを信じないといけないからだ。
さらに、全てを集合論の言葉で記述してしまえば、別々の分野の概念の間に写像を考えるといったことが出来るようになる。
しかし、ここで注意しておくべきことは、常に$NN$のような具体的構成を作り出し、それに対して議論する必要はないということだ。
自然数論を展開したいのであれば、何も$NN$のような具体的なペアノ構造に限定することなく、一般のペアノ構造に対して行えば良い。
何か具体的なペアノ構造が必要になった段階で初めて$NN$を構成すれば十分である。
このような、何らかの構造が満たすべき性質を定義し、それに対して議論を展開するのが抽象代数学の考え方である。
集合論が具体的構成を与えるのに対し、抽象代数学は抽象的構造という議論のインターフェースを与える。
そのようなインターフェース1つが#ref(<ba9d86c3c1d845e18ab46f2f3617bfbc>)で議論する群である。

== 群とモノイド <ba9d86c3c1d845e18ab46f2f3617bfbc>

加法における$0$と乗法における$1$が似ているというのは、皆が一度は思うであろう簡単な事実である。

$ 0 + x = x = x + 0 $ <7e638d1108ba4b858122cf1c22f36145>
$ 1 times x = x = x times 1 $ <625a5052e3ca49cd9f7a383ea4c9fa7f>

#ref(<7e638d1108ba4b858122cf1c22f36145>)と#ref(<625a5052e3ca49cd9f7a383ea4c9fa7f>)の形から分かるように、$0$を加えることと$1$を乗じることは「無意味」という点で似ているのである。
さらに考察を続ければ、ある観点ではこれらの演算は「同一視」出来ることも分かる。

$ exp(x + y) = (exp x) times (exp y) $ <d8a58e0e52914890a102b0fa388ab468>
$ log(x times y) = (log x) + (log y) $ <5bc372eaf25347479ef811cbc8b360ed>
$ log(exp x) = x = exp(log x) $ <5c19b462ef17421296386e529831eee7>

#ref(<d8a58e0e52914890a102b0fa388ab468>)により加法を乗法に「変換」することが、#ref(<5bc372eaf25347479ef811cbc8b360ed>)により乗法を加法に「変換」することができ、#ref(<5c19b462ef17421296386e529831eee7>)がそれら「変換」の正当性を保証している。
「変換」の正当性とはつまり、二つの演算を互いに「変換」しても結果は変わらないということである。
$exp$と$log$という2つの関数を使うことで加法の世界と乗法の世界を自由に行き来し、それによって加法と乗法は「同一視」出来るのである。

この主張は群というものによってより数学的に述べることが出来る。

#figure(
  caption: [群],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  群とは、集合$G$と$G$上の二項演算$f: G^2 -> G$の組$(G, f)$であって、次の条件を満たすものである。

  + 単位元$e in G$が存在して、任意の$g in G$に対して$f(e, g) = g = f(g, e)$が成り立つ。
  + 任意の$g in G$に対して逆元$h in G$が存在して$f(g, h) = e = f(h, g)$が成り立つ。
  + 任意の$g, h, i in G$に対して結合法則$f(f(g, h), i) = f(g, f(h, i))$が成り立つ。
] <a1e4cb7e37d24b4a995b9477a8ac072d>

#ref(<a1e4cb7e37d24b4a995b9477a8ac072d>)の$G$と$f$を置き換えれば、$(RR, +)$と$(RR_(> 0), times)$が群であることは自明である。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $(RR, +)$は群である。
]

#proof[
  単位元を$0$、$g$の逆元を$- g$とすれば自明である。
]

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $(RR_(> 0), times)$は群である。
]

#proof[
  単位元を$1$、$g$の逆元を$1 / g$とすれば自明である。
]

ここで重要なのは、$0$と$1$がそれぞれの群の単位元になっていることだ。
これが、演算において「無意味」という点で似ていることの正体である。
「変換」について論じるには準同型写像を用いれば良い。
ただし、以降では群$(G, f)$を単に台集合$G$で表し、演算$f(g, h)$は$g$と$h$を繋げて$g h$と略記することとする。

#figure(
  caption: [群準同型写像],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  写像$f: G -> H$が群$G$から群$H$への準同型写像であるとは、任意の元$g_1, g_2 in G$に対して$f(g_1 g_2) = f(g_1) f(g_2)$が成り立つことである。
]

「変換」とは正に準同型写像のことである。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $exp$は$(RR, +)$から$(RR_(> 0), times)$への準同型写像である。
] <53d43f4520d94dcbb3b42c7ae99fecb7>

#proof[
  #ref(<d8a58e0e52914890a102b0fa388ab468>)より成り立つ。
]

準同型写像$f: G -> H$が存在すれば、$f$を用いて自由に$G$から$H$に移ることができる。
任意の写像は演算と交換しない為に使用するタイミングが重要であるが、$f$は構造を保存するからである。
ただし、$H$から$G$に戻る方法は存在しないため、$f$は$G$と$H$を「同一視」するものではない。
適切な方法で$H$から$G$に戻るには、$G$と$H$の濃度が等しければ良い。

#figure(
  caption: [群同型写像],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  準同型写像かつ全単射であるような写像を同型写像と言う。
]

$exp$はグラフからも分かるように全単射であり、よって同型写像となる。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $exp$は同型写像である。
] <105bc0054f87490e90c631d7cf50eda7>

#proof[
  #ref(<53d43f4520d94dcbb3b42c7ae99fecb7>)より準同型写像であり、全単射でもあることより成り立つ。
]

一般に全単射には逆写像が存在するので、それを$f^(- 1)$とすれば$g_1 g_2 = f^(- 1)(f(g_1) f(g_2))$である。
よって、$f$によって$G$から$H$に移っても、必ず$f^(- 1)$によって$H$から$G$に戻ることが出来る。
さらに、同様の方法によって$H$から$G$に移ることも出来る。
これは次の定理から従う。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.theorem,
)[
  同型写像の逆写像は同型写像である。
] <00de405b71504d66926a672d810db246>

#proof[
  $f: G -> H$を同型写像とする。
  任意の元$h_1, h_2 in H$に対して、$g_1 = f^(- 1)(h_1), g_2 = f^(- 1)(h_2)$とすれば$f^(- 1)(h_1 h_2) = f^(- 1)(f(g_1) f(g_2)) = f^(- 1)(f(g_1 g_2)) = g_1 g_2 = f^(- 1)(h_1) f^(- 1)(h_2)$が成り立つので、$f^(- 1)$は$H$から$G$への準同型写像である。
  全単射であることは自明なので、$f^(- 1)$は同型写像である。
]

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $log$は$(RR_(> 0), times)$から$(RR, +)$への同型写像である。
] <9706afaf458d4e8bbee01baae83b6e8b>

#proof[
  #ref(<105bc0054f87490e90c631d7cf50eda7>)及び#ref(<00de405b71504d66926a672d810db246>)より従う。
]

#ref(<00de405b71504d66926a672d810db246>)により、もし同型写像が存在すれば、それを用いて$G$と$H$を自由に行き来することが許される。
これの意味する所は、もはや$G$での演算と$H$での演算は同じものであり、どちらを用いるかは好みの問題だということだ。

#figure(
  caption: [群同型],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  群$G$と群$H$が同型であるとは$G$から$H$への同型写像が存在することであり、$G tilde.eq H$と表す。
] <55bb79173f6d4d229209178d267fa66f>

#ref(<55bb79173f6d4d229209178d267fa66f>)の意味で加法と乗法は「同一視」出来るのである。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $(RR, +) tilde.eq (RR_(> 0), times)$である。
]

#proof[
  #ref(<105bc0054f87490e90c631d7cf50eda7>)や#ref(<9706afaf458d4e8bbee01baae83b6e8b>)から成り立つ。
]

ここまで、二項演算を抽象化する代数的構造の例として群を見てきた。
だが、群のみが正しい抽象化であるという訳ではもちろんない。
例えば、群の定義に可換律を加えた可換群のようなものを考えることが出来る。
実際、$(RR, +)$と$(RR_(> 0), times)$はどちらも可換群である。
また逆に、より広い概念を表す代数的構造を考えることも出来るだろう。
その例の1つが#ref(<427541a571b34fa7af31152ccb204408>)である。

#figure(
  caption: [モノイド],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  モノイドとは、集合$M$と$M$上の二項演算$f: M^2 -> M$の組$(M, f)$であって、次の条件を満たすものである。

  + 単位元$e in M$が存在して、任意の$m in M$に対して$f(e, m) = m = f(m, e)$が成り立つ。
  + 任意の$l, m, n in M$に対して結合法則$f(f(l, m), n) = f(l, f(m, n))$が成り立つ。
] <427541a571b34fa7af31152ccb204408>

#ref(<a1e4cb7e37d24b4a995b9477a8ac072d>)と#ref(<427541a571b34fa7af31152ccb204408>)を比較すれば分かるように、モノイドとは群から逆元の存在を除いたものである。
群ではないがモノイドである例としては$(RR, times)$がある。

== 箙と類

#ref(<2da7dc6cfbbd4065876df642d8c8d4c0>)で大小関係を前順序に一般化することで、より多くの集合を数直線のように図示できるようになった。
これと同じことを別の構造を持つ集合でも考える為に、箙と呼ばれる代数的構造について考える。

#figure(
  caption: [箙],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  箙とは集合$V, E$と写像$s, t: E -> V$の組$Q = (V, E, s, t)$である。
  このとき、$V$の元を頂点、$E$の元を辺と言い、任意の辺$e in E$に対して$s(e)$を$e$の始点、$t(e)$を$e$の終点という。
] <33ae59fbea5347b68a0665f4d1a47c7a>

箙とはつまり有向グラフのことであり、よって図示することが可能である。
例えば、箙$(3, 3, {(0, 0), (1, 1), (2, 0)}, {(0, 1), (1, 2), (2, 2)})$を有向グラフとして図示すると以下のようになる。

#figure(cetz.canvas({
  cetz.draw.hide(cetz.draw.circle((0, 0), radius: 0.3, name: "v0"))
  cetz.draw.content("v0", $0$)
  cetz.draw.hide(cetz.draw.circle((3, 3), radius: 0.3, name: "v1"))
  cetz.draw.content("v1", $1$)
  cetz.draw.hide(cetz.draw.circle((6, 0), radius: 0.3, name: "v2"))
  cetz.draw.content("v2", $2$)
  cetz.draw.line("v0", "v1", mark: (end: "straight"))
  cetz.draw.line("v1", "v2", mark: (end: "straight"))
  cetz.draw.line("v0", "v2", mark: (end: "straight"))
}))

#ref(<33ae59fbea5347b68a0665f4d1a47c7a>)によれば箙は集合もしくは写像の4つ組であれば良く、何か満たすべき条件は無い。
よって、想像以上に様々なものを箙として解釈することが出来る。
極端な例で考えれば、全ての集合を頂点とし、全ての写像を辺とすれば、これは箙を構成することが予想される。
しかし、実はこれは正しくない。
何故なら、全ての集合は集合ではないという、集合論的な限界が存在するからだ。
これは#ref(<47ead521442d4d8a988de89eef476a29>)から導かれる。

#figure(
  caption: [正則性公理],
  kind: mathblock.kind,
  supplement: mathblock.axiom,
)[
  空集合でない任意の集合$X$にはある元$x in X$が存在し$X inter x$は空集合となる。
] <47ead521442d4d8a988de89eef476a29>

正則性公理の下で、$X in X$を満たす集合$X$は矛盾を導くことが証明できる。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $X in X$を満たす集合$X$は矛盾する。
] <632e5265d7f9495ca6ee7d0ba931d17a>

#proof[
  正則性公理より${X}$にはある元$x in X$が存在して$X inter x = emptyset$となるが、${X}$の元は$X$のみなので$x = X$であり、よって$X inter X = X = emptyset$となる。
  これは$X in X$と明らかに矛盾する。
]

全ての集合の集合$X$が存在するのであれば定義より$X in X$であり、これは#ref(<632e5265d7f9495ca6ee7d0ba931d17a>)より矛盾する。
故に全ての集合を頂点とする箙は考えられないのである。
だが、そもそもの話として、全ての集合の集合のようなものを考えたいのはここに限った話ではない。
よって、これは図示が出来るか否か以上の問題となる。
これを数学者が未解決のまま放置しているはずもなく、実は単純な解決策が存在している。
それは、全ての集合から成る、集合では無い「集まり」を考えるという方法である。
そのようなことをして良いのかと思うかもしれないが、つまりこれは集合上の述語を言い換えただけであり、よって問題にはならない。
何らかの「集まり」$X$に対して$x in X$と書いたとき、これは何らかの述語$P(x)$を満たす集合$x$について考えているのと同じことである。

== 代数的構造

#ref(<ba9d86c3c1d845e18ab46f2f3617bfbc>)では群についての簡単な議論をした。
群のような、ある定義によって定まる抽象的な構造のことを一般に代数的構造と言う。
代数的構造を考える明確な意味は、具体的な構成を隠して抽象的な構造のみを証明に用いることによる、証明の再利用である。
例えば、#ref(<00de405b71504d66926a672d810db246>)は$RR, RR_(> 0), +, times, exp, log$の何れの具体的構成も用いずに証明されている。
よって、これは任意の群$G, H$に適用できる定理となっている。
定理を使用する側が必要なことは、ある集合と演算が#ref(<a1e4cb7e37d24b4a995b9477a8ac072d>)を満たしていることを証明するだけである。
また、構造に明確な定義があるということは、準同型写像のような構造間の関係も定義することができることを意味する。
これが$(RR, +)$と$(RR_(> 0), times)$がどれだけ似ているかを議論する便利なツールであったことは疑いようも無い。
代数的構造の有用性は広く知られており、群の他にも環、体、ベクトル空間のような、様々な構造が研究対象となっている。

しかし、ここで、ある単純な問が生まれる。
それは、代数的構造全体も、また何らかの構造を有しているのではないかという直感である。
#ref(<a1e4cb7e37d24b4a995b9477a8ac072d>)を満たすような群は当然$(RR, +)$や$(RR_(> 0), times)$以外にも無数にあり、それらは準同型写像によって複雑なネットワークを成しているだろう。
思い返せば、集合と写像、ベクトル空間と線形写像、ある集合上の二項関係なども同じような構造として見ることができる。
もしこれらに共通する代数的構造を定義できたなら、それは非常に有用だろう。
何故なら、集合論や群論、線形代数論に共通の言語を与えるだけでなく、その間の準同型が異なる学問の関係を露にするからだ。
具体的構成によって理論の無矛盾性を保証する役割が集合論にあるように、抽象代数学の共通のインターフェースとしての役割を見出せるだろう。
そして、それこそが圏論なのである。

== 圏 <08b37d846986456dbdcbe66408a829ee>

様々な構造を一般化する定義として、圏論では「矢印」を用いる。
圏論での用語として、「矢印」の両端を対象、対象を結ぶ「矢印」を射と言う。
その直感的な意味を考えるならばものとものの関係と言えるが、常にそうである訳ではない。
よって、初めて定義に触れるのであれば、グラフ理論における向き付きグラフのようなものだと思えば十分である。
もし図によるイメージが必要であれば、#ref(<b2bae595bc1f4b8abdb458dcee2a35e3>)も参考にすると良いかもしれない。

#figure(
  caption: [圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$とは、以下の条件を満たすものである。

  + 対象の類$C$が存在する。
  + 任意の対象$a, b in C$に対して、$a$から$b$への射の類$C(a, b)$が存在する。
  + 任意の対象$a in C$に対して、恒等射$1_a in C(a, a)$が存在する。
  + 任意の対象$a, b, c in C$と射$f in C(a, b), g in C(b, c)$に対して、$f$と$g$の合成射$f dot.op g in C(a, c)$が存在する。
  + 任意の対象$a, b in C$と射$f in C(a, b)$に対して、$1_a dot.op f = f = f dot.op 1_b$が成り立つ。
  + 任意の対象$a, b, c, d in C$と射$f in C(a, b), g in C(b, c), h in C(c, d)$に対して、$(f dot.op g) dot.op h = f dot.op (g dot.op h)$が成り立つ。
] <c1795453f0e04184b9fdbf6fdfd53cc8>

圏の定義には様々な流派があり、用いる記号の違いが少なくない。
例えば

- 対象の類は明示的に$abs(C)$や$"Ob"(C)$と書く。
- $a$から$b$への射の類は$"Hom"(a, b)$や$"Hom"_(C)(a, b)$と書く。
- $a$の恒等射は$"id"_a$と書く。

などである。
しかし、これらは些細な違いであり、特に気にする必要はない。
それよりも重要なのは、射の合成の順番についてである。
一般的には、射$f in C(a, b), g in C(b, c)$の合成は$g compose f in C(a, c)$と左から$g, f$の順番で書く。
だが、これが個人的に混乱するので、このノートでは$f, g$の順番を採用する。
この順番で書くことを図式順記法と言うのだが、広く用いられている記号は無いようである。
おそらく最も一般的なのが$f; g$という記法だが、やはり$g compose f$に比べれば少数派だと思われる。
ともかく、$g compose f$以外の記法を用いる際は注意すること。
繰り返すが、このノートでは$f dot g$の記法を用いる。

#ref(<c1795453f0e04184b9fdbf6fdfd53cc8>)に登場するもの以外でよく用いられる記号も定義しておこう。

#figure(
  caption: [射の類],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$の射の類を$"Mor"(C)$と記す。
]

#figure(
  caption: [域と予域],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$の射$f in "Mor"(C)$に対して$f in C(a, b)$を満たすような$a, b in C$をそれぞれ域、予域と言い、$"dom"(f) = a, "cod"(f) = b$で表す。
] <fd6c44cc7606498aa3297da25435bb6e>

#ref(<fd6c44cc7606498aa3297da25435bb6e>)が成立するためには域と予域が一意に定まらなくてはならないが、これは問題にはならない。
何故なら、任意の射$f in "Mor"(C)$はある1組の対象$a, b in C$に対してのみ$f in C(a, b)$となるように圏$C$を定義すべきであり、仮にそうなっていなかったとしても、射を域や予域との組として取り直すことで直ちに回復できるからである。
このような例には#ref(<6a578525efa943219d6c53d204d4e2d2>)の集合の圏$"Set"$がある。

また、略記として、ある$a, b in C$に対して$f in C(a, b)$であることを$f: a -> b$、$f dot g$を単に繋げて$f g$とすることもある。

== 圏の大きさ

#ref(<c1795453f0e04184b9fdbf6fdfd53cc8>)からも分かる通り、対象の類$C$や射の類$C(a, b)$が集合であることは必須ではない。
しかし、それらが集合でなくてはならない場面もあるため、そのための用語を定義しておく。

#figure(
  caption: [圏の大きさ],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$が小さいとは対象の類$C$と射の類$"Mor"(C)$が共に集合であることを言う。
  一方、$C$が小さくないことを大きいと言う。
  また、$C$の小さい大きいに関わらず、任意の対象$a, b in C$に対して$a$から$b$への射の類$C(a, b)$が集合であることを局所的に小さいと言う。
]

例えば、#ref(<6a578525efa943219d6c53d204d4e2d2>)で見るような集合の圏$"Set"$は大きな圏である。
これは#ref(<632e5265d7f9495ca6ee7d0ba931d17a>)から従う。



類を誤って集合として扱うことはラッセルのパラドックスの原因となってしまうため、慎重に議論すべきである。
しかし、このノートは個人的かつ入門用なので、集合と類の区別について細かく議論はしない。
また、同様の理由から背理法や選択公理なども断りなく使用する。
さらに、$"Set"$も含めた一般的な圏は局所的に小さいので、特に説明が無い場合は局所的に小さい圏のみに限定して考えることとする。

== 圏の具体例 <94c440b9d4ba44348cc8d3d89d0d3dee>

#ref(<94c440b9d4ba44348cc8d3d89d0d3dee>)では圏の具体例を通じて、様々な概念が圏を成すことを確認する。

=== 集合の圏 <6a578525efa943219d6c53d204d4e2d2>

#figure(
  caption: [集合の圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  集合の圏$"Set"$を以下のように定義する。

  - 対象の類$"Set"$は集合の類である。
  - 任意の集合$X, Y in "Set"$に対して、$X$から$Y$への射の類$"Set"(X, Y)$は$X$から$Y$への写像の集合であり、$"Set"(X, Y) = Y^X$で定義される。
  - 任意の集合$X in "Set"$に対して、$X$の恒等射$1_X in "Set"(X, X)$は$X$上の恒等写像であり、$1_(X)(x) = x$で定義される。
  - 任意の集合$X, Y, Z in "Set"$と写像$f in "Set"(X, Y), g in "Set"(Y, Z)$に対して、$f$と$g$の合成射$f dot g$は$f$と$g$の合成写像であり、$(f dot g)(x) = g(f(x))$で定義される。
] <7c636bd681584a50a836d01876f298c2>

なお、一般に、集合$X$から集合$Y$への写像の集合を$Y^X$と表す。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $"Set"$は圏の定義を満たす。
]

#proof[
  任意の写像$f: X -> Y$に対して

  $ (1_X dot f)(x) = f(1_(X)(x)) = f(x) $
  $ (f dot 1_Y)(x) = 1_(Y)(f(x)) = f(x) $

  が成り立つので、$1_X dot f = f = f dot 1_Y$である。
  また、任意の写像$f: W -> X, g: X -> Y, h: Y -> Z$に対して

  $ ((f dot g) dot h)(w) = h((f dot g)(w)) = h(g(f(w))) $
  $ (f dot (g dot h))(w) = (g dot h)(f(w)) = h(g(f(w))) $

  が成り立つので、$(f dot g) dot h = f dot (g dot h)$である。
  以上より、$"Set"$は圏の定義を満たす。
]

#ref(<7c636bd681584a50a836d01876f298c2>)で注意すべき箇所は$"cod"$が一意に定まらないことである。
何故なら、全く同じ構成の写像であってもその予域は自由に広げることが出来るからである。
例えば、自然数から自然数への写像はそのまま自然数から実数への写像でもある。
この対抗策としては、既に#ref(<08b37d846986456dbdcbe66408a829ee>)で述べたように射を域や予域との組として取り直せば良い。
今回の例では、$"cod"$が一意に定まるように予域を意味する集合と写像の組を射として定義しなおすことで直ちに回復できる。
一般に、$"dom", "cod"$が一意に定まるように圏を調整することは常に可能なので、自明なこととして特に言及しない。

=== 離散圏

#figure(
  caption: [離散圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
]

== 可換図式 <b2bae595bc1f4b8abdb458dcee2a35e3>
