---
name: gov-ai-discovery-zh
description: Assess and scope Chinese government and enterprise AI projects before PRD writing. Use when a user needs scenario discovery, agent necessity judgment, solution pattern selection, pilot scope definition, deployment or compliance gating, risk discovery, or a structured handoff for later Product Brief and PRD generation.
---

# Gov AI Discovery ZH

## Overview

Use this skill before writing a PRD for a Chinese government or enterprise AI project. Treat it as a gatekeeping and discovery skill: classify the scenario, decide whether AI is needed, decide whether an agent is justified, define the deployment and compliance boundary, and produce a clean handoff package for later PRD writing.

State that you are using `$gov-ai-discovery-zh`. Do not jump into document drafting until the discovery gates are passed.

## Work In Gates

Use this fixed order:

1. confirm this is a project large enough to justify structured planning
2. classify the business scenario
3. determine whether AI is needed at all
4. determine whether an agent is needed at all
5. define data, deployment, and compliance boundaries
6. define pilot scope and rollout gates
7. produce a discovery output pack

If a gate fails, say so clearly and recommend the simpler alternative.

## Apply Rigid Checks Before Recommending An Agent

Before recommending an agent, answer these questions:

- does the task need multi-step reasoning or orchestration
- does the task need tool use
- does the task need autonomous branching decisions
- is the error cost acceptable
- can risky actions be held behind human approval
- are the data and network boundaries known
- can logs and audit trails be retained
- is a pilot small enough to govern safely

If the answer is weak or unknown for most of these, do not recommend an agent by default.

Use [references/agent-necessity-matrix-zh.md](references/agent-necessity-matrix-zh.md).

## Use Red Flags

Check for common failure modes before writing recommendations:

- user asked for an agent before defining the business task
- product scope is still vague
- deployment assumptions are not validated
- external model use is assumed without approval
- write actions are planned without human review
- pilot scope is too large for a first release
- success metrics are only qualitative

Use [references/red-flags-zh.md](references/red-flags-zh.md).

## Produce A Discovery Pack

Default outputs:

1. scenario summary
2. current workflow summary
3. problem statement
4. solution pattern recommendation
5. AI necessity judgment
6. agent necessity judgment
7. deployment and compliance boundary summary
8. pilot scope
9. rollout gates
10. pending questions and risks

Use [references/discovery-output-template-zh.md](references/discovery-output-template-zh.md).

## Handoff Rule

If discovery is complete, recommend using `$gov-ai-agent-prd-zh` next.

Your handoff should make the next skill's job easy. It should include:

- chosen scenario class
- chosen solution class
- why AI is needed or not needed
- why an agent is needed or not needed
- read-only and write action boundaries
- human approval points
- deployment boundary
- pilot scope and pilot success criteria
- unresolved questions

## Reference Files

Load only what is needed:

- [references/decision-gates-zh.md](references/decision-gates-zh.md): ordered gates for discovery
- [references/agent-necessity-matrix-zh.md](references/agent-necessity-matrix-zh.md): how to judge whether an agent is justified
- [references/red-flags-zh.md](references/red-flags-zh.md): common bad assumptions and failure patterns
- [references/discovery-output-template-zh.md](references/discovery-output-template-zh.md): output structure for the discovery pack
- [references/pilot-gates-zh.md](references/pilot-gates-zh.md): pilot and rollout checkpoints

## Example Triggers

This skill should trigger on requests like:

- assess whether this government scenario needs AI
- assess whether this enterprise workflow needs an agent
- do discovery before writing the PRD
- help me scope a pilot for a state-owned enterprise AI project
- classify this scenario and define the handoff for PRD writing