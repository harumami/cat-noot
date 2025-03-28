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
よって、ここでは反射律と推移律の2つが「大小関係」の最も本質的な性質であると考え、それに基づいて#ref(<4084391cdab14df2a09c7c111fcead60>)を与える。

#figure(
  caption: [前順序],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  集合$X$上の二項関係$R subset.eq X^2$が前順序であるとは次の条件を満たすことである。

  + 反射律$forall x in X, x R x$が成り立つ。
  + 推移律$forall x, y, z in X, x R y and y R z => x R z$が成り立つ。
] <4084391cdab14df2a09c7c111fcead60>

$subset.eq$は完全律を満たさないが反射律と推移律は満たす。
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
  前順序集合とは集合$X$と$X$上の前順序$R$の組$(X, R)$のことである。
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
  ペアノ構造とは、集合$N$、$N$の元$z in N$、単射$s: N -> N without {z}$の組$(N, z, s)$であって、#ref(<b89addb4bee04500a3caaa5d8ab4267c>)を満たすものである。

  $ forall N' subset.eq N, (z in N' and (forall n in N', s(n) in N')) => N' = N $ <b89addb4bee04500a3caaa5d8ab4267c>
] <7c1db1faea5e4695ac24f24229ebbaa8>

#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)は所謂ペアノの公理を集合論の言葉で記述したものである。
直感的な理解としては、$(N, z, s)$をペアノ構造としたとき、$N$は自然数の集合、$z$は最少の自然数、$s$は$1$を加える写像となる。
また、#ref(<b89addb4bee04500a3caaa5d8ab4267c>)は数学的帰納法として知られるものである。
#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)はあくまで自然数の集合が満たすべき性質を定めたのみであり、具体的な構成は別に定義しなければならない。
しかし、良く知られているように自然数は無限にあり、その集合は外延的に記述することが出来ない。
よって、内包的な方法で何らかの集合の部分集合として定義する必要があり、そのためにはまず無限集合を見つける必要がある。
そして、集合論にはそのための公理が用意されている。

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
  以上より$(N, z, s)$はペアノ構造となる。
]

#ref(<7c1db1faea5e4695ac24f24229ebbaa8>)から分かるように最少の自然数が$1$である必要はない。
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
  このとき$R$は前順序となる。
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
そのようなインターフェースの1つが#ref(<ba9d86c3c1d845e18ab46f2f3617bfbc>)で議論する群である。

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
  + 任意の$g, h, i in G$に対して結合律$f(f(g, h), i) = f(g, f(h, i))$が成り立つ。
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
  群$G$と群$H$が同型であるとは$G$から$H$への同型写像が存在することであり、$G tilde.equiv H$と表す。
] <55bb79173f6d4d229209178d267fa66f>

#ref(<55bb79173f6d4d229209178d267fa66f>)の意味で加法と乗法は「同一視」出来るのである。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $(RR, +) tilde.equiv (RR_(> 0), times)$である。
]

#proof[
  #ref(<105bc0054f87490e90c631d7cf50eda7>)や#ref(<9706afaf458d4e8bbee01baae83b6e8b>)から成り立つ。
]

ここまで、二項演算を抽象化する例として群を見てきた。
だが、群のみが正しい抽象化であるという訳ではもちろんない。
例えば、群の定義に可換律を加えた可換群のようなものを考えることが出来る。
実際、$(RR, +)$と$(RR_(> 0), times)$はどちらも可換群である。
また逆に、より広い概念を表す集合を考えることも出来るだろう。
その例の1つが#ref(<427541a571b34fa7af31152ccb204408>)のモノイドである。
群ではないがモノイドである例としては$(RR, times)$がある。

#figure(
  caption: [モノイド],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  モノイドとは集合$M$と$M$上の二項演算$f: M^2 -> M$の組$(M, f)$であって次の条件を満たすものである。

  + 単位元$e in M$が存在して、任意の$m in M$に対して$f(e, m) = m = f(m, e)$が成り立つ。
  + 任意の$l, m, n in M$に対して結合律$f(f(l, m), n) = f(l, f(m, n))$が成り立つ。
] <427541a571b34fa7af31152ccb204408>

#ref(<a1e4cb7e37d24b4a995b9477a8ac072d>)と#ref(<427541a571b34fa7af31152ccb204408>)を比較すれば分かるように、モノイドとは群から逆元の存在を除いたものである。
群やモノイドだけでなく、何らかの演算を備えた集合には様々なものが考えられるが、その内のどれが優れているという訳ではない。
一般に、前提が少ない程証明できることが少なくなり、前提が多い程定理を適用できる範囲が狭まる。
よって、示したい命題などに適したものを選ぶ必要があるのだ。

== 箙と類 <e36014ced53a4b16a33373f8acea2911>

#ref(<2da7dc6cfbbd4065876df642d8c8d4c0>)で大小関係を前順序に一般化することで、より多くの集合を数直線のように図示できるようになった。
これと同じことを別の構造を持つ集合でも考える為に、箙と呼ばれる集合について考える。

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
  cetz.draw.hide(cetz.draw.circle((0, 0), radius: 0.5, name: "v0"))
  cetz.draw.content("v0", $0$)
  cetz.draw.hide(cetz.draw.circle((3, 3), radius: 0.5, name: "v1"))
  cetz.draw.content("v1", $1$)
  cetz.draw.hide(cetz.draw.circle((6, 0), radius: 0.5, name: "v2"))
  cetz.draw.content("v2", $2$)
  cetz.draw.line("v0", "v1", mark: (end: "straight"), name: "e0")
  cetz.draw.hide(cetz.draw.circle("e0", radius: 0.5, name: "e0l"))
  cetz.draw.content("e0l.north-west", $0$)
  cetz.draw.line("v1", "v2", mark: (end: "straight"), name: "e1")
  cetz.draw.hide(cetz.draw.circle("e1", radius: 0.5, name: "e1l"))
  cetz.draw.content("e1l.north-east", $1$)
  cetz.draw.line("v0", "v2", mark: (end: "straight"), name: "e2")
  cetz.draw.hide(cetz.draw.circle("e2", radius: 0.5, name: "e2l"))
  cetz.draw.content("e2l.south", $2$)
})) <b780981f41d5475eaf0410a51b5189f5>

#ref(<33ae59fbea5347b68a0665f4d1a47c7a>)によれば箙は集合もしくは写像の4つ組であれば良く、何か満たすべき条件は無い。
よって、想像以上に様々なものを箙として解釈することが出来る。
極端な例で考えれば、全ての集合を頂点とし、全ての写像を辺とすれば、これは箙を構成することが予想される。
しかし、実際にはこれは正しくない。
何故なら、全ての集合は集合ではないという集合論的な限界が存在するからだ。
これは#ref(<47ead521442d4d8a988de89eef476a29>)から導かれる。

#figure(
  caption: [正則性公理],
  kind: mathblock.kind,
  supplement: mathblock.axiom,
)[
  空集合でない任意の集合$X$にはある元$x in X$が存在して$X inter x$は空集合となる。
] <47ead521442d4d8a988de89eef476a29>

正則性公理の下で$X in X$を満たす集合$X$は矛盾を導くことが証明できる。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  $X in X$を満たす集合$X$は矛盾する。
] <632e5265d7f9495ca6ee7d0ba931d17a>

#proof[
  正則性公理より${X}$にはある元$x in {X}$が存在して${X} inter x = emptyset$となるが、${X}$の元は$X$のみなので$x = X$であり、よって${X} inter X = X = emptyset$となる。
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
このような、非形式的な「集まり」は類と呼ばれる。
これによって箙の定義を拡大したものを考えることができる。

#figure(
  caption: [大きな箙],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  大きな箙$Q$とは次の条件を満たすものである。

  + 頂点の類$Q_0$が存在する。
  + 辺の類$Q_1$が存在する。
  + 任意の辺$e in Q_1$に対して始点$op("sou")(e) in Q_0$が存在する。
  + 任意の辺$e in Q_1$に対して終点$op("tar")(e) in Q_0$が存在する。
]

大きな箙は箙における頂点の集合や辺の集合を類に変えたものである。
全ての集合の「集まり」は類であるので、これによって集合の類と写像の類による大きな箙を考えることが出来る。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  頂点の類$Q_0$を集合の類、辺の類$Q_1$を写像の類、辺$e in Q_1$の始点$op("sou")(e) in Q_0$を$e$の始域、終点$op("tar")(e) in Q_0$を$e$の終域とすれば、これは大きな箙となる。
] <93dcf43de2c348ca8cc30a65d43d40e4>

#proof[
  証明すべきことは無い。
]

#ref(<93dcf43de2c348ca8cc30a65d43d40e4>)で注意しておくべきことがまだ1つだけ存在する。
それは、任意の辺$e in Q_1$に対して終点$op("tar")(e) in Q_0$が一意に定まるかということだ。
集合$X$から集合$Y$への写像$f: X -> Y$は一般に直積集合$X times Y$の部分集合として定義されるが、この時$f$のみから終域は決定できない。
何故なら、$f$は任意の$X$の元を含んでいなければならないが、$Y$についてはそうではないからである。
例えば$NN$から$NN$への写像はそのまま$NN$から$RR$の写像として解釈できるが、明らかに写像のみから$RR$を復元できない。
これに対する解決策は、写像の定義を$X, Y, f$の組$(X, Y, f)$として定義し直せば良い。
あるいは、#ref(<93dcf43de2c348ca8cc30a65d43d40e4>)において辺の類をそのように定義するという方法もある。
これによって、任意の$e in Q_1$に対して$op("tar")(e)$は一意に定まる。
一般に、$op("sou"), op("tar")$が一意に定まらないどのような箙であっても、同様の方法によって一意に定まるように回復できる。

証明から分かるかもしれないが、#ref(<93dcf43de2c348ca8cc30a65d43d40e4>)は数学的に有用な何かを述べているわけではない。
結局のところ、集合を頂点とし写像を辺とした有向グラフを描けるという、ある種の当たり前を難しく行っただけである。
また、箙を大きな箙に拡張することでわざわざ全ての集合の分だけ頂点があるグラフを考えられるようにしたが、そもそも頂点が無数にあるグラフを描くことは出来ない。
つまり、グラフとして図示するのは常にある箙或いは大きな箙の部分箙であるということだ。
例えば#ref(<18b214ca66bb4ea88a339b4f66094b25>)を#ref(<93dcf43de2c348ca8cc30a65d43d40e4>)によって定義される大きな箙の部分箙であるとした時、これは$X, Y, Z$が集合、$f: X -> Y, g: Y -> Z$がその間の写像を意味する変数として定義していると解釈する。

#figure(cetz.canvas({
  cetz.draw.hide(cetz.draw.circle((0, 0), radius: 0.5, name: "x"))
  cetz.draw.content("x", $X$)
  cetz.draw.hide(cetz.draw.circle((3, 0), radius: 0.5, name: "y"))
  cetz.draw.content("y", $Y$)
  cetz.draw.hide(cetz.draw.circle((6, 0), radius: 0.5, name: "z"))
  cetz.draw.content("z", $Z$)
  cetz.draw.line("x", "y", mark: (end: "straight"), name: "f")
  cetz.draw.hide(cetz.draw.circle("f", radius: 0.5, name: "fl"))
  cetz.draw.content("fl.north", $f$)
  cetz.draw.line("y", "z", mark: (end: "straight"), name: "g")
  cetz.draw.hide(cetz.draw.circle("g", radius: 0.5, name: "gl"))
  cetz.draw.content("gl.north", $g$)
})) <18b214ca66bb4ea88a339b4f66094b25>

箙と大きな箙に本質的な違いは無い為、以降では2つをまとめて箙と呼ぶこととする。
区別が必要な場合には大きな箙でないものを明示的に小さな箙として対応する。
なお、通常は集合も類であると見做し、集合ではない類のことを真の類という。
よって、箙が大きいとは頂点もしくは辺の類が真の類であると言い換えることも出来る。

== 圏 <08b37d846986456dbdcbe66408a829ee>

#ref(<2da7dc6cfbbd4065876df642d8c8d4c0>)では前順序集合、#ref(<ba9d86c3c1d845e18ab46f2f3617bfbc>)では群、#ref(<e36014ced53a4b16a33373f8acea2911>)では箙という、何らかの構造を持った集合について議論してきた。
これらのように、定義によって定まる抽象的な構造のことを一般に代数的構造と言う。
代数的構造を考える意義は、議論における共通言語を与え、証明を再利用し、異なる概念の比較を可能にすることにある。
ここである単純な問いが生まれる。
それは、複数の分野に共通して用いることの出来るな汎用的な代数的構造を考えられないだろうか、という問いだ。
具体的構成によって理論の無矛盾性を保証する役割が集合論にあるように、抽象代数学の共通のインターフェースとしての役割を見出せる。
そして、それこそが圏論なのである。
様々な構造を一般化する為の代数的構造として、圏論では対象とその間の射というものを考える。
その定義を簡単に言うならばモノイドに似た演算を備えた箙である。

#figure(
  caption: [圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$とは以下の条件を満たすものである。

  + 対象の類$C$が存在する。
  + 任意の対象$a, b in C$に対して$a$から$b$への射の類$b^a$が存在する。
  + 任意の対象$a in C$に対して恒等射$1_a in a^a$が存在する。
  + 任意の対象$a, b, c in C$と射$f in a^b, g in b^c$に対して$f$と$g$の合成射$f compose g in a^c$が存在する。
  + 任意の対象$a, b in C$と射$f in a^b$に対して単位律$1_a compose f = f = f compose 1_b$が成り立つ。
  + 任意の対象$a, b, c, d in C$と射$f in a^b, g in b^c, h in c^d$に対して結合律$(f compose g) compose h = f compose (g compose h)$が成り立つ。
] <c1795453f0e04184b9fdbf6fdfd53cc8>

#ref(<c1795453f0e04184b9fdbf6fdfd53cc8>)に登場するもの以外でよく用いられる記号も定義しておく。

#figure(
  caption: [射の類],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$の射の類を$op("Mor")(C)$と記す。
]

#figure(
  caption: [終域と始域],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$の射$f in op("Mor")(C)$に対して、$f in a^b$を満たすような$a, b in C$をそれぞれ終域、始域と言い、$op("cod")(f) = a, op("dom")(f) = b$で表す。
] <fd6c44cc7606498aa3297da25435bb6e>

圏の定義には様々な流派があり、用いる記号の違いが少なくない。
よって、このノートでは基本的に独自の記法にのみ言及する。
例えば、$b^a$は一般に$op("Hom")(a, b)$と書かれる。
#ref(<fd6c44cc7606498aa3297da25435bb6e>)が成立するためには終域と始域が一意に定まらなくてはならないが、これは#ref(<e36014ced53a4b16a33373f8acea2911>)と同様の理由で問題にならない。
また、略記として、$op("dom")(f) = a, op("cod")(f) = b$であることを$f: a -> b$や$f: b <- a$、$1_a$を単に$1$、$f compose g$の$compose$を除いて$f g$とすることもある。

圏の大きさという概念についても話しておく。
#ref(<c1795453f0e04184b9fdbf6fdfd53cc8>)からも分かる通り、対象の類や射の類が集合であることは必須ではない。
しかし、それらが集合でなくてはならない場面もあるため、そのための用語が存在する。

#figure(
  caption: [圏の大きさ],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  圏$C$が小さいとは対象の類$C$と射の類$op("Mor")(C)$が共に集合であることを言う。
  一方、$C$が小さくないことを大きいと言う。
  また、$C$の小さい大きいに関わらず、任意の対象$a, b in C$に対して$a$から$b$への射の類$b^a$が集合であることを局所的に小さいと言う。
]

例えば、#ref(<6a578525efa943219d6c53d204d4e2d2>)で見るような集合の圏$"Set"$は大きく、同時に局所的に小さい。
類を誤って集合として扱うことは矛盾の原因となってしまう為、本来は慎重に議論すべきである。
しかし、このノートは個人的かつ入門用なので集合と類の区別について細かく議論はしない。
また、同様の理由から背理法や選択公理なども断りなく使用する。
さらに、$"Set"$も含めた一般的な圏は局所的に小さいので、特に説明せずに局所的に小さい圏に限定することもある。

圏とはモノイドに似た演算を備えた箙であると言ったが、実は任意の圏から箙を構成することができる。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  任意の圏$C$について、頂点の類を$C$、辺の類を$op("Mor")(C)$、始点$op("sou")$を$op("dom")$、終点$op("tar")$を$op("cod")$で定義すると、これは箙を成す。
] <7e65fda4992349ba8ec1355287100934>

#proof[
  証明すべきことは無い。
]

#ref(<7e65fda4992349ba8ec1355287100934>)の意味する所は、任意の圏は有向グラフとして図示できるということである。
この方法によって圏を有向グラフとして図示したものは図式と呼ばれる。
図式では恒等射や合成射は省略されることが一般的である。
また、特に可換図式と言った時はその図式内の終域と始域を共有する射が等しいことを意味する。
例えば#ref(<b780981f41d5475eaf0410a51b5189f5>)も図式として見ることが可能であり、これが可換ならば$1 compose 0 = 2$である。

= 圏の具体例 <94c440b9d4ba44348cc8d3d89d0d3dee>

#ref(<94c440b9d4ba44348cc8d3d89d0d3dee>)では具体例を通じて様々なものが圏となることを確認する。

== 集合の圏 <6a578525efa943219d6c53d204d4e2d2>

集合と写像が箙となったように、対象を集合、射を写像とする圏を考えることができる。
これを#ref(<1ac0d7acb204441885a656784e118d78>)で示す。

#figure(
  kind: mathblock.kind,
  supplement: mathblock.proposition,
)[
  以下のように定義される$C$は圏を成す。

  - 対象の類$C$は集合の類である。
  - 任意の対象$a, b in C$に対して$a$から$b$への射の類$b^a$は$a$から$b$への写像の集合で定義される。
  - 任意の対象$a in C$に対して$a$の恒等射$1_a in a^a$は$a$上の恒等写像であり、$1_(a)(x) = x$で定義される。
  - 任意の対象$a, b, c in C$と写像$f in a^b, g in b^c$に対して$f$と$g$の合成射$f compose g$は$f$と$g$の合成写像であり、$(f compose g)(x) = f(g(x))$定義される。
] <1ac0d7acb204441885a656784e118d78>

#proof[
  任意の射$f in a^b$に対して$(1_a compose f)(x) = 1_(a)(f(x)) = f(x), (f compose 1_a)(x) = f(1_(a)(x)) = f(x)$であり、よって単位律が成り立つ。
  また、任意の射$f in a^b, g in b^c, h in c^d$に対して$((f compose g) compose h)(x) = (f compose g)(h(x)) = f(g(h(x))), (f compose (g compose h))(x) = f((g compose h)(x)) = f(g(h(x)))$であり、よって結合律が成り立つ。
  故に$C$は圏である。
]

#ref(<1ac0d7acb204441885a656784e118d78>)が定める圏は非常に重要なので、#ref(<7c636bd681584a50a836d01876f298c2>)で名前を与えておく。

#figure(
  caption: [集合の圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  #ref(<1ac0d7acb204441885a656784e118d78>)が定める圏を$"Set"$とする。
] <7c636bd681584a50a836d01876f298c2>

== 離散圏

#figure(
  caption: [離散圏],
  kind: mathblock.kind,
  supplement: mathblock.definition,
)[
  全ての射が恒等射であるような圏を離散圏と言う。
]
