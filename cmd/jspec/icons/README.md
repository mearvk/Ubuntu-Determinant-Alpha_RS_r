# JSpec Desktop Icon Set

JSpec desktop icons are generated from one canonical vector master and reduced with a high-quality 2D reconstruction filter. The icon is part of the `.alpha` desktop-launch contract: it identifies the runnable, while JSpec owns preflight and launch behavior.

## Required sizes

The Linux desktop set is defined at:

- 48×48 — large desktop/file-manager presentation
- 32×32 — primary desktop target
- 24×24 — compact desktop/tool presentation
- 16×16 — small launcher/list presentation
- 12×12 — minimum supported clickable presentation

The source master is intentionally larger and remains the authority. Do not repeatedly resize an already reduced icon.

## Reduction rule

Each requested size is produced directly from the master using a high-quality area-aware 2D reconstruction. Alpha coverage is preserved, proportions are not distorted, and no nearest-neighbor reduction is permitted for the normal icon pipeline.

At 12×12 and 16×16, an optical correction pass may be applied to preserve the visual identity of the master on the small pixel grid. This correction must not change the executable identity or introduce animation into the icon itself.

## JSpec interaction

The desktop icon is a clickable representation of the `.alpha` runnable. Hover/proximity behavior belongs to JSpec's presentation layer. Execution remains deterministic:

`icon → JSpec preflight → .alpha → native format → OS loader → target`

The icon never becomes the execution authority and never embeds executable policy.
