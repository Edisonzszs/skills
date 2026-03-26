---
name: using-gov-ai-product-design-zh
description: Route work across the government and enterprise AI product design skill set. Use when a user needs end-to-end analysis, discovery, PRD drafting, or help choosing which government AI planning skill to apply.
---

# Using Gov AI Product Design ZH

## Overview

Use this skill as the entry point for the government and enterprise AI product design skill set. Do not solve the task directly until you have decided which skill in this set is the right one.

State that you are using `$using-gov-ai-product-design-zh` and name the selected downstream skill.

## Skill Set

This collection includes:

- `gov-ai-product-design-zh/gov-ai-discovery-zh`: use for discovery, feasibility, scenario classification, AI necessity judgment, agent necessity judgment, pilot scope, deployment gating, and compliance gating
- `gov-ai-product-design-zh/gov-ai-agent-prd-zh`: use for Product Brief, PRD, and AI or agent specification drafting after discovery is strong enough

## Routing Rules

Choose `gov-ai-discovery-zh` when the request is early, vague, or still deciding whether AI or an agent is needed.

Choose `gov-ai-agent-prd-zh` only when the scenario class, pilot scope, deployment boundary, human approval points, and major risks are already clear.

If uncertain, choose discovery first.

Use [references/routing-rules-zh.md](references/routing-rules-zh.md), [references/handoff-standard-zh.md](references/handoff-standard-zh.md), and [references/skill-map-zh.md](references/skill-map-zh.md).

## Output Rule

Your job in this meta skill is to route and frame the work, not to duplicate the full instructions of the downstream skill. After choosing the path, follow the selected child skill.

## Example Triggers

This skill should trigger on requests like:

- help me analyze a government AI product
- choose the right planning flow for this enterprise AI scenario
- do end-to-end government AI product design work
- decide whether to do discovery or write the PRD now