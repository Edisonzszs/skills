---
name: gov-ai-product-design-zh
description: Orchestrate Chinese government and enterprise AI product design from discovery through Product Brief, PRD, and AI or agent specification. Use when a user asks for end-to-end requirements analysis, scenario assessment, whether AI or an agent is needed, pilot scoping, or formal PRD generation for a government or enterprise AI project.
---

# Gov AI Product Design ZH

## Overview

Use this skill as the main entry point for Chinese government and enterprise AI product planning. It should automatically choose the right phase:

- discovery first when the scenario is still early, vague, or unvalidated
- PRD drafting next when discovery is already complete enough

State that you are using `$gov-ai-product-design-zh` and explicitly say which path you are taking.

## Route Automatically

Use this routing logic before doing anything else.

### Choose Discovery Path

Route to the discovery workflow when any of these is true:

- the business scenario is still vague
- the user has not yet proven AI is needed
- the user has not yet proven an agent is needed
- pilot scope is unclear
- deployment or compliance boundaries are unclear
- read-only versus write-action boundaries are unclear
- the user asks for feasibility, assessment, scoping, or solution choice

In this path, follow the process and references from `$gov-ai-discovery-zh`.

### Choose PRD Path

Route to the PRD workflow only when most of these are already clear:

- scenario class
- AI necessity
- agent necessity
- pilot scope
- deployment boundary
- compliance boundary
- human approval points
- major risks and pending issues

In this path, follow the process and references from `$gov-ai-agent-prd-zh`.

### Default Rule

If uncertain, choose the discovery path first.

## Standard End-To-End Flow

When handling a full request, work in this order:

1. run discovery
2. produce a discovery pack
3. check whether the pack is sufficient
4. if sufficient, draft Product Brief, PRD, and AI or Agent Spec
5. call out what remains unresolved

Do not skip discovery just because the user asks for a PRD. If the input is too weak, explain why and stop at the discovery pack.

## Expected Outputs

Depending on the route, produce one of these output sets:

### Discovery Route Output

- scenario summary
- current workflow summary
- AI necessity judgment
- agent necessity judgment
- deployment and compliance boundary summary
- pilot scope
- rollout gates
- pending issues and risks

### PRD Route Output

- Product Brief
- PRD
- AI or Agent Spec

Use [references/routing-rules-zh.md](references/routing-rules-zh.md) to decide the route.
Use [references/handoff-standard-zh.md](references/handoff-standard-zh.md) to judge whether discovery is complete enough for PRD drafting.

## Child Skill Contract

Treat these as child skills under this main workflow:`r`n`r`n- `gov-ai-product-design-zh/subskills/gov-ai-discovery-zh`: phase 1, discovery and gating`r`n- `gov-ai-product-design-zh/subskills/gov-ai-agent-prd-zh`: phase 2, document drafting after discovery`r`n`r`nWhen using this parent skill, prefer not to expose both child skills unless the user explicitly wants the phase split. Load the child instructions from those subdirectories when needed.

## Example Triggers

This skill should trigger on requests like:

- help me analyze and design a government AI product
- decide whether this enterprise scenario needs an agent and then write the PRD
- do end-to-end requirements analysis for a Chinese government or enterprise AI project
- produce the discovery and PRD package for this state-owned enterprise AI scenario