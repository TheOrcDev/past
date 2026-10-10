# Human base mesh (CC0)

`body_male_realistic.blend` holds `GEO-body_male_realistic` and its two eye
markers, extracted from **Human Base Meshes v1.4.1** by Blender Studio and
community contributors. The bundle was downloaded on 2026-10-10 from
<https://mirror.blender.org/demo/asset-bundles/human-base-meshes/human-base-meshes-bundle-v1.4.1.zip>
(listed at <https://www.blender.org/download/demo-files/>).

- **License:** CC0. No attribution is required; this note records where the
  mesh came from.
- **Used by:** `tools/blender/unknown.py`. It loads the body, moves the
  shoulders and arms out and swells it slightly into Unknown's build, rigs it,
  bakes its multires muscle detail, and melts the face into a smooth skull.
- **Kept here:** only the body object and its eye markers (the bundle's other
  heads, hands, feet and skeletons are left out). Its multires sculpt levels
  are intact.

Open it in Blender with autorun scripts disabled (`--disable-autoexec`), as for
any downloaded `.blend`.
