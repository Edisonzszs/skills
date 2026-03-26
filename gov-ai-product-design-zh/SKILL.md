---
name: gov-ai-product-design-zh
description: Handle Chinese government and enterprise AI product design end to end in a single skill. Use when a user needs requirements analysis, scenario discovery, AI or agent fit assessment, pilot scoping, Product Brief drafting, PRD drafting, AI or agent specification drafting, deployment boundary definition, or compliance-aware planning for a government or enterprise AI project.
---

# Gov AI Product Design ZH

## Overview

Use this skill as the single official entry point for Chinese government and enterprise AI product planning. Handle the full flow inside one skill: discovery first when the scenario is still unclear, then formal document drafting when the discovery output is strong enough.

State that you are using `$gov-ai-product-design-zh` and explicitly say which phase you are running.

## Work In Two Phases

Use this fixed sequence.

### Phase 1: Discovery And Gating

Run discovery first when any of the following is still unclear:

- the real business problem
- whether AI is needed
- whether an agent is needed
- pilot scope
- deployment boundary
- compliance boundary
- read-only versus write-action boundary
- human approval points

In this phase, classify the scenario, test whether AI is justified, test whether an agent is justified, define deployment and compliance boundaries, and produce a clean discovery pack.

Use these references:

- [references/discovery-workflow-zh.md](references/discovery-workflow-zh.md)
- [references/decision-gates-zh.md](references/decision-gates-zh.md)
- [references/agent-necessity-matrix-zh.md](references/agent-necessity-matrix-zh.md)
- [references/red-flags-zh.md](references/red-flags-zh.md)
- [references/discovery-output-template-zh.md](references/discovery-output-template-zh.md)
- [references/pilot-gates-zh.md](references/pilot-gates-zh.md)

### Phase 2: Product Brief, PRD, And AI Or Agent Spec

Only move into document drafting when most of the following are already clear:

- scenario class
- AI necessity
- agent necessity
- pilot scope
- deployment boundary
- compliance boundary
- human approval points
- major risks and pending issues

In this phase, draft:

1. `Product Brief`
2. `PRD`
3. `AI/Agent Spec`

Use these references:

- [references/prd-workflow-zh.md](references/prd-workflow-zh.md)
- [references/discovery-handoff-zh.md](references/discovery-handoff-zh.md)
- [references/prd-template-zh.md](references/prd-template-zh.md)
- [references/agent-prd-template-zh.md](references/agent-prd-template-zh.md)
- [references/ai-evaluation-metrics-zh.md](references/ai-evaluation-metrics-zh.md)
- [references/deployment-and-compliance-zh.md](references/deployment-and-compliance-zh.md)
- [references/gov-enterprise-intake-zh.md](references/gov-enterprise-intake-zh.md)
- [references/scenario-patterns-zh.md](references/scenario-patterns-zh.md)

## Automatic Routing Rule

If the input is early, vague, or still debating solution form, stay in discovery.

If the input already contains a solid discovery pack or equivalent detail, move to Product Brief and PRD drafting.

If uncertain, choose discovery first.

Use [references/routing-rules-zh.md](references/routing-rules-zh.md) and [references/handoff-standard-zh.md](references/handoff-standard-zh.md).

## Standard Output Sets

### Discovery Output Set

- scenario summary
- current workflow summary
- problem statement
- AI necessity judgment
- agent necessity judgment
- deployment and compliance boundary summary
- pilot scope
- rollout gates
- pending questions and risks

### Planning Output Set

- Product Brief
- PRD
- AI or Agent Spec

If the discovery phase is incomplete, do not fake a full PRD. Stop and say what is missing.

## Output Rules

When generating the deliverables:

- use Chinese in the final documents
- separate confirmed facts from assumptions
- separate business acceptance from AI acceptance
- do not bury compliance and governance requirements inside generic NFR wording
- call out read-only versus write-action boundaries explicitly
- keep a dedicated pending-items section for unresolved issues

## Example Triggers

This skill should trigger on requests like:

- help me analyze and design a government AI product
- decide whether this enterprise scenario needs AI or an agent, then write the PRD
- do end-to-end requirements analysis for a Chinese government or enterprise AI project
- produce the discovery and PRD package for this state-owned enterprise AI scenario