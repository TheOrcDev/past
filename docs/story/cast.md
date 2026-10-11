# Past — Cast

Status: draft, 2026-10-11, for plan 008. It follows `bible.md` and needs the
same sign-off (board #10). Every NPC is someone Ulric took something from
(the operator's brief, `decisions.md` #43).

## Rules for every NPC

- **Look:** a grey shade, never black. Only Unknown is black, and only the Dove
  carries a trace of color. Each reads by outline (hat, hood, tools, posture),
  as `art-pipeline.md` §5D asks.
- **Faces:** each one is hooded, veiled, masked or turned away, so nobody needs
  lip sync (decision #16). They act with posture and hands, and their voice
  drives a subtle head or shoulder bob, like Unknown's envelope.
- **Names:** each is known by a role until Unknown gives them back their
  memory. Then their real name (a proposal here) appears in the subtitle color
  and on the journal page.
- **Animations:** `idle`, `talk_a` and `talk_b`, plus one signature action, in
  one facing that is mirrored as needed. A walk only where the atlas says so.
- **Voice:** every NPC voice is distinct (`game-design.md` §11). Casting waits
  on plan 003 (board #4 and #7). The direction notes here go into each line's
  voice direction.

## Unknown

The shadow of **Ulric, High Magistrate**. As in `game-design.md` §2, with one
addition: as he gives memories back, his eye glow warms by a few degrees per
returned name. The shader takes a `warmth` parameter, so it stays subtle and
cheap.

## The NPCs

### The Gravedigger: prologue, `cemetery_gate` and `sexton_lodge`

- **Took:** his name, and his memory of his own wife's grave. He tends a grave
  every day without knowing why.
- **Silhouette:** a heavy hooded coat, a broad back bent over a spade, and a
  lantern on a pole. Short and wide.
- **Voice:** old, gravelly, unhurried, with gallows humor. He's the first person
  to laugh at Unknown, kindly.
- **Wants:** his lantern back. A crow made off with its glass.
- **Secret:** he hid the U under moss on the night of the burial, because the
  veiled woman who paid for the stone asked him to.
- **Name returned:** Tobias (proposal), in chapter 4's finale. His memory is the
  last one the Ledger gives back before Unknown's own.
- **Signature:** `dig`.

### The Sister: prologue, `cathedral_cloister`

- **Took:** her choir's song. She can speak but can't hold a note; none of
  them can.
- **Silhouette:** a tall, narrow veil and a wimple, with hands folded into wide
  sleeves.
- **Voice:** soft, precise and wry. A teacher who has heard every excuse.
- **Wants:** to hear one hymn again before the world ends, or whatever this is.
- **Knows:** a singer called "the dove" led the choir.
- **Name returned:** Agathe (proposal), chapter 4.
- **Signature:** `conduct`, a small beat of the hand.

### The Crier: chapter 1, `cathedral_parvis`

- **Took:** his name, and every day of news since the night time stopped.
- **Silhouette:** a tricorn hat, a long coat and a handbell held high.
- **Voice:** booming and theatrical, stuck on the same headlines. Comic relief.
- **Wants:** news. Any news. Unknown is news.
- **Name returned:** Barnaby (proposal), chapter 4.
- **Signature:** `ring_bell`.

### The Lamplighter: chapter 1, `street_of_lamps` and `lamplighter_shed`

- **Took:** his memory of his daughter's wedding. It's the first memory Unknown
  gives back.
- **Silhouette:** a tall, thin man with a ladder on his shoulder, a long
  lighting pole and a wide-brimmed hat.
- **Voice:** gentle and melancholy, and patient beyond reason.
- **Wants:** one lamp that actually gives light.
- **Name returned:** Mathis (proposal), at the end of chapter 1, when the lamp
  street keeps its warm light.
- **Signature:** `light_lamp`, reaching up with the pole.

### The Broker: chapter 1, `market_square` and `pawn_shop`

- **Took:** the meaning of everything he owns. He knows each trinket's price
  but not why anyone loved it.
- **Silhouette:** a hood, round spectacles that catch light, and a long
  counting coat with bulging pockets.
- **Voice:** quick and transactional, a haggler who's charming despite himself.
- **Wants:** to know why anyone would pay for a dove's feather. He holds Ulric's
  seal ring in a locked cabinet without knowing what it is.
- **Name returned:** Fennick (proposal), chapter 4.
- **Signature:** `weigh`, with a hand scale.

### The Clockmaker: chapter 1, `clock_tower_base` and `clockworks`

- **Took:** his hours, the years of memory between his apprenticeship and
  that night.
- **Silhouette:** a magnifying monocle on a headband, a leather apron, and arms
  full of springs.
- **Voice:** fussy, precise and impatient. He counts under his breath.
- **Wants:** the clock running, but he's afraid of what the hour will strike.
- **Name returned:** Hesper (proposal), chapter 4.
- **Signature:** `wind`, turning a great key.

### The Ferryman: chapter 2, `ferry_landing`

- **Took:** where he was going. He ferries in circles.
- **Silhouette:** a deep hood, a long punting pole, and a narrow boat. He's
  always seen standing in the boat.
- **Voice:** slow and dry, deadpan. He charges memories as his fare.
- **Wants:** a destination.
- **Name returned:** Corin (proposal), at the end of chapter 2.
- **Signature:** `pole`. The boat moves along a path; he doesn't walk.

### The Washerwoman: chapter 2, `washing_steps`

- **Took:** her husband's name. He was a sluice-keeper, one of the petitioners
  Ulric struck.
- **Silhouette:** a shawl, rolled sleeves, kneeling at a washboard, with a
  basket on her hip.
- **Voice:** sharp-tongued and working-class, funny and furious in the same
  breath.
- **Wants:** the initial on the shirt to mean something again.
- **Name returned:** Maud (proposal), at the end of chapter 2. Her husband's
  name, Aldous, comes with it.
- **Signature:** `scrub`.

### The Plague Doctor: chapter 2, `hospice_on_stilts`

- **Took:** her oath. She remembers how to heal but not why she promised to.
- **Silhouette:** a beaked mask, a wide hat, a long waxed coat and a cane.
  It's the clearest silhouette in the game.
- **Voice:** clinical and dry, with an unexpected warmth that surfaces when she's
  surprised.
- **Wants:** to wake her sleepers, who are citizens so emptied that they lie
  still.
- **Name returned:** Isolde (proposal), at the end of chapter 2.
- **Signature:** `examine`, bending over a cot with the cane.

### The Hangman: chapter 3, `gallows_square`

- **Took:** his name, and his memory of refusing to hang a nameless man.
  Ulric struck him for refusing. Years later the Registrar ordered him to
  hang Ulric, and he did.
- **Silhouette:** huge, hooded, with gentle hands and a coil of rope over his
  shoulder.
- **Voice:** deep and soft. A gentle giant who apologises a lot.
- **Wants:** to know whether the man he hanged deserved it. When he learns it
  was Unknown, he answers honestly: "Some of it."
- **Name returned:** Bram (proposal), chapter 4.
- **Signature:** `coil_rope`.

### The Puppeteer: chapter 3, `theater_stage` and `theater_backstage`

- **Took:** her audience. Everyone forgot the theatre, so she performs to empty
  seats.
- **Silhouette:** a theatrical half-mask, a puppet on each hand, and a cape
  cut like a stage curtain.
- **Voice:** grand and mischievous. She does all the puppet voices herself.
- **Wants:** an audience of one. Unknown will do.
- **Name returned:** Lisette (proposal), chapter 4.
- **Signature:** `perform`, both puppets moving.

### The Registrar: chapter 3 antagonist, `registrar_chamber`, then the belfry in chapter 4

- **Took:** his name. He was the Ledger's first entry, Ulric's test. He made
  Ulric its last.
- **Silhouette:** a very tall hat, a high stiff collar, a quill behind his ear
  and a clerk's ink-stained cuffs. He's thin as a ledger line.
- **Voice:** reasonable, polite and bloodless. He's never cruel and never in
  doubt, and he is Ulric's own logic, carried on.
- **Wants:** a city where nobody hurts, because nobody remembers.
- **Name returned:** Edmund Vey (proposal). Unknown reads it to him first in the
  belfry, and that is how he lets go of the book.
- **Signature:** `write`. He has a walk, because he flees in chapter 3.

### The Dove: chapter 4, `dovecote` and `dove_room`, and the epilogue

- **Took:** her name, when she sang the names of the taken in the cathedral.
- **Silhouette:** a long veil, a slight figure, and a dove perched on one hand.
  She's the only shade with a trace of color: the faint blue of the choir's
  banners.
- **Voice:** warm and low. She forgave him a long time ago, and she still won't
  let him off lightly.
- **Wants:** for him to stop running from what he did.
- **Name returned:** Elise (proposal), read from the belfry. In the epilogue
  she says his name.
- **Signature:** `release_dove`. She has a walk, for the epilogue.

## The memory figures (flashbacks)

People in flashbacks are glowing, warm silhouettes (`bible.md` §3). They are
made once as generic rigged bodies (man, woman, the choir) with a glow
material. Ulric's burned-out figure is the same body drawn as an absence: a
dark hole with a hot rim.

## Production order

The Gravedigger first, as the NPC route's proof (plan 008, slice 3), then in
chapter order. The Dove and the Registrar get the most animation, because the
finale stages them.
