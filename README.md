# HONE — the attention gym

A daily workout for focus. Not a blocker, not background music — HONE trains the one skill that runs everything else: holding your mind on one thing, noticing when it drifts, and pulling it back.

It's a single, self-contained HTML file. No build step, no dependencies, no account. Open it and start.

## The daily loop

1. **Weigh-in** — a ~2-minute reaction-vigilance test (adapted from the lab-standard PVT-B) scores your "sharpness" today. Sensitive to sleep and fatigue, near-zero practice effect.
2. **Prime** — set an if-then intention, clear attention residue, and breathe to the right arousal level (cyclic sighing to down-regulate, movement to wake up).
3. **Train** — a focused-attention block where you tap **"Caught it"** every time you notice your mind wandering. Noticing and returning is the rep — the isolable active ingredient behind attention training.
4. **Deep work** — a timer for the real task, with distractions parked (not chased) and a mid-block reactivation nudge.
5. **Restore** — a real break that resets the vigilance decrement, steered away from feeds.

## Features

- Objective **sharpness test** with reaction time, lapses, and a tracked score
- Guided **prime** sequence with an animated breathing pacer
- **Meta-awareness trainer** that counts your catches
- **Deep-work timer** with distraction parking and self-rating
- **Progress** charts (sharpness trend, deep-work minutes, catches-per-minute) and a day streak
- An honest **science** panel — every feature tagged by evidence strength

## The science (in brief)

HONE is built on what actually replicates: focused-attention meditation and meta-awareness, implementation intentions (Gollwitzer & Sheeran, d = 0.65), attention-residue control (Leroy 2009), goal-reactivation breaks (Ariga & Lleras 2011), and arousal-matching via breathing (Balban 2023). It deliberately avoids the overclaimed stuff — generic brain-games (see Lumosity's FTC settlement), binaural beats, and "flow-hacking" lore. Scores are within-person trends, not clinical measures. See [`docs/blueprint.md`](docs/blueprint.md).

## Run it

Open `index.html` in any modern browser. That's it. Your progress saves locally in the browser.

**Live demo:** enable GitHub Pages (Settings → Pages → deploy from `main` / root) and it will be served at `https://an1shk.github.io/hone/`.

## Repo layout

```
index.html            the app (single self-contained file)
docs/blueprint.md     product strategy: the market gap, the science, the roadmap
docs/menubar-spec.md  build spec for a native macOS menubar version
```

## Status

Early prototype. The measurement is a within-person gauge, not a validated clinical instrument — closing that gap (a real efficacy study) is the roadmap's north star and the intended moat.
