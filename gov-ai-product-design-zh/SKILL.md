---
name: gov-ai-product-design-zh
description: End-to-end product discovery and PRD design for Chinese government and enterprise AI projects. Use when the user wants one integrated workflow that can assess whether AI or an agent is justified, define pilot and governance boundaries, and then draft a Product Brief, PRD, and AI or agent specification.
---

# Gov AI Product Design ZH

## Overview

Use this as the single entry skill for Chinese government and enterprise AI product planning.

This skill replaces the split workflow of separate routing, discovery, and PRD skills. It should behave as one integrated planning workflow:

1. decide whether the request is still in discovery or ready for document drafting
2. if discovery is incomplete, complete discovery first
3. when the gates are passed, draft the Product Brief
4. then draft the PRD
5. then draft the AI or Agent Spec

State that you are using `$gov-ai-product-design-zh`.

## Phase 1: Route Before Drafting

Do not jump straight into PRD writing unless the core inputs are already clear.

Start by checking whether the user already knows:

- the scenario class
- whether AI is actually needed
- whether an agent is actually needed
- the pilot scope
- the deployment boundary
- the data and compliance boundary
- the read-only versus write-action boundary
- the mandatory human approval points
- the major risks and pending questions

If these are still weak, stay in discovery first.

Use:
- [references/routing-rules-zh.md](references/routing-rules-zh.md)
- [references/skill-map-zh.md](references/skill-map-zh.md)
- [references/handoff-standard-zh.md](references/handoff-standard-zh.md)

## Phase 2: Discovery And Gating

Use this fixed gate order:

1. confirm the project is large enough to justify structured planning
2. classify the business scenario
3. determine whether AI is needed at all
4. determine whether an agent is needed at all
5. define data, deployment, and compliance boundaries
6. define pilot scope and rollout gates
7. produce a discovery pack

If a gate fails, say so clearly and recommend the simpler alternative.

Before recommending an agent, check:

- whether the task needs multi-step reasoning or orchestration
- whether the task needs tool use
- whether the task needs autonomous branching decisions
- whether the error cost is acceptable
- whether risky actions can be held behind human approval
- whether the data and network boundaries are known
- whether logs and audit trails can be retained
- whether the pilot is small enough to govern safely

Use:
- [references/decision-gates-zh.md](references/decision-gates-zh.md)
- [references/agent-necessity-matrix-zh.md](references/agent-necessity-matrix-zh.md)
- [references/red-flags-zh.md](references/red-flags-zh.md)
- [references/discovery-output-template-zh.md](references/discovery-output-template-zh.md)
- [references/pilot-gates-zh.md](references/pilot-gates-zh.md)
- [references/gov-enterprise-intake-zh.md](references/gov-enterprise-intake-zh.md)
- [references/scenario-patterns-zh.md](references/scenario-patterns-zh.md)

## Discovery Output

Default discovery output should include:

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

Do not move to PRD drafting until the discovery handoff is strong enough.

Use:
- [references/discovery-handoff-zh.md](references/discovery-handoff-zh.md)
- [references/handoff-standard-zh.md](references/handoff-standard-zh.md)

## Phase 3: Draft Product Brief, PRD, And AI Or Agent Spec

Once discovery is complete, draft in three layers:

1. `Product Brief`
2. `PRD`
3. `AI/Agent Spec`

Keep them distinct:

- Product Brief: business value, sponsor, pilot, scope, and success criteria
- PRD: user roles, workflows, functional requirements, non-functional requirements, business rules, and acceptance criteria
- AI or Agent Spec: models, knowledge boundaries, tools, permissions, human approval, audit, and fallback logic

Write in this order:

### Pass 1: Normalize Discovery Inputs

Convert discovery outputs into stable terms:

- business objective
- target users and departments
- scenario classification
- pilot scope
- deployment boundary
- risk summary

### Pass 2: Write Product Brief

Write a concise brief suitable for steering or sponsor review.

### Pass 3: Write PRD

Write:

- numbered `FR-*` requirements
- numbered `NFR-*` requirements
- workflow states
- role and permission model
- explicit in-scope and out-of-scope sections
- business acceptance criteria

### Pass 4: Write AI Or Agent Spec

Write:

- AI necessity summary
- agent necessity summary
- model and deployment constraints
- knowledge boundaries
- tool list and tool boundaries
- read-only actions
- write actions
- mandatory human approval points
- high-risk failure modes
- fallback and escalation paths
- AI evaluation metrics

Use:
- [references/agent-prd-template-zh.md](references/agent-prd-template-zh.md)
- [references/ai-evaluation-metrics-zh.md](references/ai-evaluation-metrics-zh.md)
- [references/deployment-and-compliance-zh.md](references/deployment-and-compliance-zh.md)

## Non-Negotiable Requirements

Do not omit these sections for government and enterprise AI projects:

- pilot scope and non-pilot scope
- deployment boundary
- compliance and audit requirements
- read-only versus write-action boundary
- human approval points
- business acceptance metrics
- AI acceptance metrics
- pending issues and risks

## Output Rules

When generating the final documents:

- use Chinese for the deliverables
- keep assumptions separate from confirmed facts
- keep business acceptance separate from AI acceptance
- do not hide governance or compliance items inside generic NFR prose
- if discovery is incomplete, stop and say what is missing

## Platform Adapters

If the user asks how to use this skill collection in Claude Code, Codex, Cursor, or OpenCode, load:

- [platform-adapters/overview-zh.md](platform-adapters/overview-zh.md)
- [platform-adapters/claude-code-zh.md](platform-adapters/claude-code-zh.md)
- [platform-adapters/codex-openai-zh.md](platform-adapters/codex-openai-zh.md)
- [platform-adapters/cursor-zh.md](platform-adapters/cursor-zh.md)
- [platform-adapters/opencode-zh.md](platform-adapters/opencode-zh.md)
- [platform-adapters/mcp-recommended-servers-zh.md](platform-adapters/mcp-recommended-servers-zh.md)

## Example Triggers

This skill should trigger on requests like:

- help me do end-to-end government AI product design work
- assess whether this government or enterprise workflow really needs AI or an agent
- do discovery before writing the PRD
- turn this government AI scenario into a Product Brief and PRD
- draft the Product Brief, PRD, and Agent Spec for this enterprise AI pilot
