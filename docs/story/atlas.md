# Past — Atlas: the 50 new rooms

Status: signed 2026-10-11 (decision #48), for plan 008. It follows `bible.md` and `cast.md`,
and needs the same sign-off (board #10). Each entry is what an image request
and a room build start from. A chapter's puzzle dependency chart is drawn
before its art (`game-design.md` §10), and it may move hotspots and items
between rooms, but not add rooms without a note here.

**Each entry gives:**
- **Now:** what the present-day image (monochrome) shows.
- **Then:** what the past image (color, an edit of the now image) shows. "—"
  means the room has no past.
- **Play:** people, hotspots, memories, puzzle role and exits.

The composition rules in `art-pipeline.md` §3 apply to every room. Every room's
background is empty of people: NPCs and memory figures are separate layers.

Memory types are those in `game-design.md` §6:
- **vision:** a watched flashback;
- **playable:** a playable memory;
- **vista:** a memory vista.

Already built, and not counted in the 50: `cemetery_grave` and
`cathedral_nave`.

## Totals

| Part | Rooms | Then images | Close-ups | Vista rings | NPCs |
|---|---|---|---|---|---|
| Prologue: The Grave | 5 | 5 | 3 | — (built) | 2 |
| 1. The Nameless Streets | 12 | 12 | 5 | 3 + past | 4 |
| 2. The Drowned Quarter | 11 | 10 | 4 | 3 + past | 3 |
| 3. The Hall of Records | 12 | 9 | 4 | 3 + past | 3 |
| 4. The Dovecote | 10 | 6 | 4 | 3 + past | 1 |
| **Total** | **50** | **42** | **20** | **16** | **13** |

---

## Prologue — The Grave

The area's style keys already exist: the cemetery (IMG-0006, IMG-0009) and
the nave (IMG-0001, IMG-0005).

**P1. `cemetery_gate` — The cemetery gate** · the Gravedigger
- **Now:** a tall wrought-iron gate hanging off one hinge between stone posts
  topped with urns. The Gravedigger's lodge stands to one side, its window
  dark. A row of freshly dug, empty graves is lined up neatly along the path,
  and a lantern pole is planted in a heap of earth. Fog and the city's spires
  are beyond.
- **Then:** the gate whole and black-lacquered, flower sellers' baskets,
  mourners' lanterns, gold autumn leaves, and the lodge window lit.
- **Play:**
  - The Gravedigger digs graves for nobody. His lantern has lost its glass,
    which a crow stole; he asks for it back.
  - Hotspots: the gate, the empty graves, the lantern pole, the lodge door.
  - Exits: west to `cemetery_grave`, the lodge door to `sexton_lodge`, and
    the steps down to `ossuary`.

**P2. `sexton_lodge` — The Gravedigger's lodge** · the Gravedigger (inside
after P1)
- **Now:** a cramped stone room: a cold iron stove, a narrow cot, shelves of
  dead lanterns, a wall of numbered keys, and the burial register open on a
  lectern under the window.
- **Then:** the stove glowing, a wreath on the door, and a woman's shawl on
  the peg.
- **Play:**
  - **Close-up `burial_register`:** the entry reads "U—, paid by a dove",
    then "stone defaced by order of the Registrar".
  - The key wall gives the ossuary key once the lantern is mended.

**P3. `ossuary` — The ossuary** (beneath the cemetery chapel)
- **Now:** a low vaulted crypt of stacked skulls and bones. Rows of niches
  have name plaques scraped blank. Stubs of candles, and a crow's nest of
  glinting scraps on a high ledge.
- **Then:** every plaque painted with a name in gold, fresh flowers, and
  candlelight.
- **Play:**
  - The lantern glass is in the crow's nest (a `pickup_high`).
  - **Vision "The edict":** a family watching a clerk scrape their father's
    name off his niche, and the burned-out figure watching from the stair.
  - **Close-up `ossuary_niche`.**

**P4. `cathedral_cloister` — The cloister** · the Sister
- **Now:** a square cloister walk around an overgrown garden. A dry well, a
  broken sundial, pointed arches, and dead roses climbing the columns.
- **Then:** the garden in bloom, the well full, and choir robes drying on a
  line.
- **Play:** the Sister can't sing. She remembers a singer called "the dove",
  and she holds the key to the west doors.
- **Exits:** from `cathedral_nave` (a new side door), and the stair to
  `choir_loft`.

**P5. `choir_loft` — The choir loft** (above the nave)
- **Now:** a gallery of dusty organ pipes, toppled music stands, and a hymn
  book left open on one stand, looking down into the ruined nave.
- **Then:** gilded pipes, candles, and the choir's blue-and-gold banners.
- **Play:**
  - **Close-up `hymn_book`:** a list of names written in its margins in a
    woman's hand.
  - **Vision "The singer":** the choir in gold, a woman singing the names, and
    the burned shape in the doorway below.
  - The Sister then gives the west door key, and the nave's west doors open to
    chapter 1.

---

## Chapter 1 — The Nameless Streets

**Area:** the old town below the cathedral (concept 04's streets, bridge and
archway). Style key: `cathedral_parvis`. Vista: the old town from the
cathedral steps, three rings plus a past vista seen from `clock_face`.

**1. `cathedral_parvis` — The cathedral square** · the Crier
- **Now:** a broad square before the cathedral's west front. The great doors
  stand behind and slightly above. Empty flagstones, a dry horse trough, a
  crier's platform with a handbell post, and narrow streets leaving between
  leaning gothic houses.
- **Then:** market day, with blue-and-gold banners, pigeons and a garlanded
  platform.
- **Play:**
  - The area's discovery reveal plays on arrival.
  - The Crier announces news from the night time stopped. He trades
    directions for news.

**2. `street_of_lamps` — The street of lamps** · the Lamplighter
- **Now:** a long, curving street of iron lamp posts, every lamp lit with a
  pale, lightless flame. Shuttered shops line it.
- **Then:** the lamps glowing warm gold, flower boxes, and open shutters.
- **Play:** the Lamplighter wants one lamp that gives light. It's one of
  chapter 1's three threads.

**3. `lamplighter_shed` — The lamplighter's shed**
- **Now:** a small workshop: oil jars, coils of wick, a ladder, and the
  walls covered in tally marks.
- **Then:** tidy shelves and a wedding garland hung over the door.
- **Play:** **close-up `lamp_ledger`:** a tally for every name he can't
  remember. The oil and a wick are items.

**4. `market_square` — The market square** · the Broker
- **Now:** a sloping square of empty stalls under torn awnings, around a dry
  fountain with a statue of a weeping saint. The Broker's stall is the only
  one still stocked.
- **Then:** a bustling market with garlands, and a wedding procession's
  flower petals.
- **Play:** **vision "The wedding":** the Lamplighter's daughter's wedding,
  seen by her father. It's the memory Unknown gives back at the chapter's
  end.

**5. `pawn_shop` — The Broker's shop** · the Broker (inside)
- **Now:** a narrow shop crammed with clocks, dolls, rings, scales and
  portraits with their faces turned to the wall. A locked glass cabinet
  stands behind the counter.
- **Then:** a jeweller's, polished and glittering.
- **Play:** **close-up `seal_cabinet`:** a heavy seal ring. It fits Unknown's
  hand.

**6. `canal_bridge` — The canal bridge**
- **Now:** a high arched stone bridge over a still black canal (concept 04),
  a lamp at its crown, and the clock tower rising beyond.
- **Then:** painted boats, flowers on the parapet, and clear green water.
- **Play:** a link between the market and the tower square. A moored boat's
  rope is an item.

**7. `alley_of_doors` — The alley of doors**
- **Now:** a steep narrow alley where every door's nameplate has been pried
  off, leaving pale rectangles. A notice board is covered in edicts.
- **Then:** brass nameplates shining and doors painted in color.
- **Play:** **close-up `edict_board`:** "By order of the High Magistrate:
  a name is a privilege, not a right."

**8. `tavern_lost_name` — The tavern**
- **Now:** a low-beamed tavern. Overturned stools, a mirror behind the bar,
  and a slate of debts with every name scratched out.
- **Then:** full of warm light and singing, the tables crowded.
- **Play:**
  - The mirror shows the room but not Unknown, a running gag.
  - **Close-up `tavern_tally`.**
  - **Vision "A toast":** a toast to a man whose name everyone shouts, then
    forgets mid-word.

**9. `clock_tower_base` — The clock tower square** · the Clockmaker
- **Now:** a small square at the foot of a massive clock tower. Its great
  face is stopped. A workbench of springs sits under the tower arch, with
  the door to the clockworks beside it.
- **Then:** the clock face gilded and the square crowded at noon.
- **Play:** the Clockmaker keeps the clock ready but won't start it. He fears
  the hour.

**10. `clockworks` — Inside the clock**
- **Now:** a towering interior of iron gears, a hanging pendulum, and a
  broken escapement, all in shafts of light through the clock's glass.
- **Then:** brass gears turning and warm light.
- **Play:**
  - A **playable memory**, the Clockmaker's apprenticeship, shows how the
    escapement is set. The past solves the present.
  - **Close-up `escapement`.**

**11. `clock_face` — Behind the clock face**
- **Now:** a narrow walkway behind the translucent glass clock face, with
  the giant hands in silhouette and the city through the glass.
- **Then:** the glass lit gold from outside.
- **Play:**
  - A **vista** of the old town in color.
  - Restarting the clock strikes the hour once, which opens `lower_gate`.

**12. `lower_gate` — The lower gate**
- **Now:** a stone stair plunging down to a portcullis gate. Its winding
  chain runs up towards the clock tower, and fog and water lie below.
- **Then:** the gate open and porters carrying baskets.
- **Play:**
  - The chapter's end: the Lamplighter's memory is returned, and his street
    keeps its warm light.
  - The exit leads to chapter 2.

---

## Chapter 2 — The Drowned Quarter

**Area:** the flooded lower city, drowned forest and aqueduct (concept 03).
Style key: `flooded_stair`. Vista: the drowned quarter from the stair, three
rings plus a past vista from `aqueduct_channel`.

**1. `flooded_stair` — The flooded stair**
- **Now:** wide steps descending straight into black water. Drowned
  rooftops, dead trees and the distant aqueduct's arches stand in the fog.
- **Then:** the steps leading down to a dry, busy canal-side street.
- **Play:** the area's discovery reveal. A bell on a post calls the ferry.

**2. `ferry_landing` — The ferry landing** · the Ferryman
- **Now:** a rotting jetty, mooring posts, and a lantern hung on a hook.
  The Ferryman's narrow boat is drawn as a separate layer.
- **Then:** a painted jetty with a busy ferry queue.
- **Play:** the Ferryman takes memories as his fare. Unknown pays with a
  trivial one (his first comic sacrifice). The boat is the way between rooms
  2, 3, 4 and 7.

**3. `drowned_street` — The drowned street**
- **Now:** a canal running between houses sunk to their upper floors, with
  laundry lines strung across and shutters hanging open.
- **Then:** the same street dry, with cobbles, gardens and window boxes.
- **Play:** a broken shutter and a floating crate (item).

**4. `washing_steps` — The washing steps** · the Washerwoman
- **Now:** steps down to the water, a washboard, baskets and a long line of
  grey laundry.
- **Then:** a sunny washing day and neighbors' laundry in color.
- **Play:** **close-up `washer_shirt`:** the embroidered initial "A".

**5. `sluice_house` — The sluice house**
- **Now:** a stone house over a channel. A great gate wheel is rusted solid,
  and a gauge is drowned.
- **Then:** sluice-keepers at the wheel and the gauge polished.
- **Play:**
  - **Close-up `petition`.**
  - **Vision "The petition":** the keepers' petition against the
    Magistrate, and Aldous signing first.

**6. `drowned_chapel` — The drowned chapel**
- **Now:** a small chapel half sunk, its pews standing in water and the
  altar on a little island of rubble.
- **Then:** candles, dry flagstones, and a young doctor kneeling.
- **Play:** **vision "The oath":** the Plague Doctor taking her oath.

**7. `hospice_on_stilts` — The hospice** · the Plague Doctor
- **Now:** a long timber hall on stilts above the water, with rows of cots
  where still figures sleep under sheets (a layer), and herbs hung dry.
- **Then:** a working hospice, bright and busy.
- **Play:**
  - The Plague Doctor wants her sleepers woken. The answer is upstream, at
    the valve.
  - **Close-up `hospice_chart`.**

**8. `drowned_forest` — The drowned forest**
- **Now:** dead trees standing in mirror-still water, with mist and
  aqueduct arches marching through (concept 03).
- **Then:** a green forest with birds and sunlight.
- **Play:** the path to the aqueduct along a fallen trunk. A heron's feather
  is an item.

**9. `aqueduct_foot` — The aqueduct's foot**
- **Now:** the base of a massive aqueduct pier, a maintenance stair cut into
  it, and a bronze dedication plaque.
- **Then:** a ribbon-cutting ceremony, banners, and the burned-out figure.
- **Play:** **close-up `aqueduct_plaque`:** the seal matches the ring.

**10. `aqueduct_channel` — On the aqueduct**
- **Now:** a walk along the dry stone channel on top of the aqueduct. One
  span has broken away, and there's a long view over the drowned quarter.
- **Then:** water flowing in the channel at sunset.
- **Play:**
  - A **vista** of the quarter in color.
  - Bridging the gap is a puzzle.

**11. `valve_house` — The valve house**
- **Now:** a stone cistern head with a great iron valve wheel and a
  maintenance desk. The water roars below.
- **Then:** —. The memory plays over the present, because what happened
  here is the color.
- **Play:**
  - **Vision "The signing":** Ulric strikes the keepers' names, and the
    burned figure turns and is him.
  - Turning the valve drains the quarter. It's the chapter's end: three
    memories are returned.

---

## Chapter 3 — The Hall of Records

**Area:** the upper city, Ulric's own. Style key: `upper_avenue`. Vista: the
upper city from the avenue, three rings plus a past vista.

**1. `upper_avenue` — The upper avenue**
- **Now:** a grand avenue of tall, severe buildings. The Magistrate's statue
  on a plinth has had its head knocked off, and edicts are carved into the
  plinth.
- **Then:** a parade, banners, and the statue whole.
- **Play:** the area's discovery reveal.

**2. `gallows_square` — The gallows square** · the Hangman
- **Now:** a bare square with a tall gallows and a single noose, and an
  empty flower market's iron frames.
- **Then:** the square before the gallows was built: a well and a flower
  market.
- **Play:** **vision "The refusal":** the Hangman refusing an order. He tells
  Ulric's hanging himself (`bible.md` rule 5).

**3. `theater_facade` — The theatre**
- **Now:** a baroque theatre front with torn posters, a dark marquee, and
  doors chained.
- **Then:** opening night, with the marquee lit and a crowd.
- **Play:** **close-up `playbill`:** "The Magistrate and the Book".

**4. `theater_stage` — The stage** · the Puppeteer
- **Now:** a stage seen from the stalls, with a puppet booth at its centre
  and rows of empty seats.
- **Then:** a full house in candlelight.
- **Play:** the puppet show is the chapter's exposition and its comedy.

**5. `theater_backstage` — Backstage**
- **Now:** ropes, sandbags, a rack of puppets (the Magistrate, a dove, a
  clerk) and a trapdoor.
- **Then:** —.
- **Play:** the clerk puppet's quill is the key to the records gate puzzle.

**6. `records_gate` — The gate of the Hall of Records**
- **Now:** a towering gate flanked by stone clerks holding blank stone books,
  and a seal-shaped lock.
- **Then:** petitioners queuing, and the stone books carved with names.
- **Play:** the ring opens it.

**7. `hall_of_records` — The Hall of Records**
- **Now:** a vast hall of drawers rising into darkness, rolling ladders, and
  long empty desks.
- **Then:** clerks at every desk and lamps lit.
- **Play:** the central hub of chapter 3.

**8. `archive_stacks` — The stacks**
- **Now:** a maze of ledger shelves, moths, and a reading lectern.
- **Then:** —.
- **Play:** **close-up `ledger_index`:** the index of names. Unknown looks
  for the Dove's entry.

**9. `magistrate_office` — The Magistrate's office**
- **Now:** a severe, high room: a great desk, a slashed portrait, and a
  window over the city.
- **Then:** the office in Ulric's prime, its fire lit.
- **Play:**
  - A **playable memory as Ulric**. He must strike the Dove's name to open
    the vault, and so he learns what he did.
  - **Close-up `office_desk`:** the seal and the vault's word.

**10. `registrar_chamber` — The Registrar's chamber** · the Registrar
- **Now:** a narrow chamber with a standing desk, a wall of pigeonholes, and
  the round vault door.
- **Then:** the young Registrar beside the burned figure.
- **Play:** the confrontation.

**11. `ledger_vault` — The vault**
- **Now:** a round vault with an empty lectern where the book lay.
- **Then:** the Ledger glowing on its lectern.
- **Play:**
  - **Close-up `vault_lectern`.**
  - The Registrar flees: it's the chapter's end.

**12. `covered_bridge` — The covered bridge**
- **Now:** an enclosed stone bridge from the Hall to the cathedral's
  heights, its windows open over the city.
- **Then:** —.
- **Play:** the exit to chapter 4.

---

## Chapter 4 — The Dovecote

**Area:** the cathedral's heights. Style key: `cathedral_roof`. Vista: the
whole city from the roof, three rings plus the finale's past vista, which
becomes the present.

**1. `cathedral_roof` — The cathedral roof**
- **Now:** a walk along the lead roof ridge between spires. The whole grey
  city lies below.
- **Then:** the roof gleaming and pennants flying.
- **Play:** the last discovery reveal.

**2. `buttress_walk` — The flying buttresses**
- **Now:** a perilous walk across flying buttresses, with fog below.
- **Then:** —.
- **Play:** crossing them is a puzzle.

**3. `gargoyle_gallery` — The gargoyle gallery**
- **Now:** a gallery lined with gargoyles, one of them holding something in
  its mouth.
- **Then:** —.
- **Play:** the dovecote's key.

**4. `dovecote` — The dovecote** · the Dove
- **Now:** a round stone dovecote on the roof, grey doves on every ledge,
  and one white one.
- **Then:** the dovecote freshly whitewashed in the sun.
- **Play:** the Dove knows him at once.

**5. `dove_room` — The Dove's room**
- **Now:** an attic room under the roof with a bed, a writing desk, the
  choir's faded blue banner, and keepsakes. It's the one present-day room
  with a trace of color.
- **Then:** the same room when she was the choir's singer.
- **Play:** **close-up `unsent_letter`:** Ulric's apology.

**6. `rose_window_ledge` — Behind the rose window**
- **Now:** a narrow ledge behind the great rose window, looking down into the
  ruined nave (the same nave as `cathedral_nave`).
- **Then:** the window glowing in gold and blue.
- **Play:** **vision "The song of names":** the crime, seen in full.

**7. `bell_stair` — The bell stair**
- **Now:** a spiral stair inside the tower, with bell ropes hanging through
  its centre.
- **Then:** —.
- **Play:** a transit room.

**8. `bell_chamber` — The bell chamber** · the Registrar
- **Now:** great bronze bells on a timber frame, with the Registrar and the
  Ledger.
- **Then:** bell ringers.
- **Play:**
  - The stand-off. Unknown reads the Registrar's own name.
  - **Close-up `ledger_page`:** his own entry, the last line in the book.

**9. `belfry_top` — The belfry**
- **Now:** the open top of the tower, with the whole city below.
- **Then:** the whole city in color (the finale).
- **Play:**
  - Reading the names and fading.
  - **Close-up `bell_inscription`:** the words that carry a name.

**10. `grave_at_dawn` — The grave at dawn** (epilogue)
- **Now:** —. This room is the color: the `cemetery_grave` composition at
  dawn, in full color. It's an edit of IMG-0009 v1, with the stone recut
  to read "ULRIC".
- **Then:** —.
- **Play:**
  - Elise at the stone, and the credits.
  - **Close-up `gravestone_restored`.**

---

## Inventory (draft)

Each chapter's puzzle chart sets its item list. The working estimate is
12–15 items per chapter, about 60 in all. They're generated as sheets of
eight on a plain ground, and Claude cuts them into icons.
