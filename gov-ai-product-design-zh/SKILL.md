---
name: gov-ai-product-design-zh
description: End-to-end solution design, discovery, and PRD drafting for Chinese government and enterprise AI agent projects. Use when the user wants one integrated workflow that routes the request, completes discovery if needed, designs a practical solution shape, and then drafts a Product Brief, PRD, AI or agent specification, acceptance metrics, and pending items.
---

# Gov AI Product Design ZH

## Overview

Use this as the single entry skill for Chinese government and enterprise AI product and solution design.

This is not only a PRD-writing skill. It is a vertical planning workflow for:

- whether the scenario should be solved with AI at all
- whether it should be solved with an agent at all
- what the solution shape should be
- how the pilot should be bounded
- how the product documents should be written

Always work in this order:

1. route the request
2. if information is insufficient, stay in Discovery
3. if Discovery is sufficient, write the Product Brief
4. then write the PRD
5. then write the AI or Agent Spec
6. finally summarize acceptance metrics and pending items

State that you are using `$gov-ai-product-design-zh`.

## Phase 1: Route First

Do not jump directly into PRD drafting.

First decide whether the request is:

- still in discovery
- ready for structured solution framing
- ready for formal document drafting

If any of these are still unclear, stay in Discovery:

- scenario class
- business objective
- whether AI is actually needed
- whether an agent is actually needed
- pilot scope
- deployment boundary
- compliance boundary
- read-only versus write-action boundary
- human approval points
- major risks and pending questions

Use:
- [references/routing-rules-zh.md](references/routing-rules-zh.md)
- [references/scenario-patterns-zh.md](references/scenario-patterns-zh.md)

## Phase 2: Discovery

Discovery is mandatory when the request is still vague or early.

Run Discovery in a fixed order:

1. confirm the project is large enough for structured planning
2. classify the business scenario
3. determine whether AI is needed at all
4. determine whether an agent is needed at all
5. define data, deployment, and compliance boundaries
6. define pilot scope and rollout gates
7. produce a clean discovery pack

If a gate fails, say so clearly and recommend the simpler alternative.

Before recommending an agent, verify:

- whether multi-step orchestration is needed
- whether tool use is needed
- whether branching decisions are needed
- whether the error cost is acceptable
- whether risky actions can be gated by human approval
- whether the data and network boundaries are known
- whether logs and audit trails can be retained
- whether the pilot can be governed safely

Use:
- [references/discovery-workflow-zh.md](references/discovery-workflow-zh.md)
- [references/decision-gates-zh.md](references/decision-gates-zh.md)
- [references/red-flags-zh.md](references/red-flags-zh.md)
- [references/discovery-output-template-zh.md](references/discovery-output-template-zh.md)

## Solution Framing Rule

Before writing the Product Brief, convert Discovery outputs into a solution framing view.

At minimum, identify:

- which business role receives value
- which core problem is being improved first
- which capability should be delivered in the pilot
- which parts are AI, which parts are workflow, and which parts are ordinary system integration
- where the agent boundary starts and stops
- where human approval is mandatory

Do not let the documents become a feature list without a solution shape.

Use:
- [references/solution-design-workflow-zh.md](references/solution-design-workflow-zh.md)
- [references/solution-blueprint-template-zh.md](references/solution-blueprint-template-zh.md)
- [references/capability-matrix-zh.md](references/capability-matrix-zh.md)

## Phase 3: Product Brief

If Discovery is sufficient, write the Product Brief first.

The Product Brief should clarify:

- business background
- core problem
- target departments and users
- business goals
- pilot scope
- non-pilot scope
- success criteria
- risks and assumptions

Make the Product Brief reflect the chosen solution shape, not only the business request.

Use:
- [references/handoff-standard-zh.md](references/handoff-standard-zh.md)
- [references/product-brief-template-zh.md](references/product-brief-template-zh.md)

## Phase 4: PRD

After the Product Brief, write the PRD.

The PRD should include:

- user roles
- workflows
- scope
- numbered `FR-*`
- numbered `NFR-*`
- business rules
- permissions
- business acceptance criteria

The PRD should be grounded in the solution framing, not written as disconnected pages and features.

Use:
- [references/prd-workflow-zh.md](references/prd-workflow-zh.md)
- [references/prd-template-zh.md](references/prd-template-zh.md)

## Phase 5: AI Or Agent Spec

After the PRD, write the AI or Agent Spec.

The AI or Agent Spec should cover:

- why AI is needed or not needed
- why an agent is needed or not needed
- model and deployment constraints
- knowledge boundaries
- tool boundaries
- read-only actions
- write actions
- human approval points
- high-risk failure modes
- fallback and escalation
- AI evaluation metrics

Use:
- [references/agent-spec-template-zh.md](references/agent-spec-template-zh.md)
- [references/ai-evaluation-metrics-zh.md](references/ai-evaluation-metrics-zh.md)
- [references/deployment-and-compliance-zh.md](references/deployment-and-compliance-zh.md)
- [references/rollout-and-operating-model-zh.md](references/rollout-and-operating-model-zh.md)

## Final Output Rule

Every complete run should end with:

1. Product Brief
2. PRD
3. AI or Agent Spec
4. business acceptance metrics
5. AI acceptance metrics
6. pending items and risks

Keep assumptions separate from confirmed facts.
Keep business acceptance separate from AI acceptance.
Do not hide governance or compliance items inside generic NFR prose.

## Platform Adapters

If the user asks how to use this skill in Claude Code, Codex, Cursor, or OpenCode, load:

- [platform-adapters/overview-zh.md](platform-adapters/overview-zh.md)
- [platform-adapters/claude-code-zh.md](platform-adapters/claude-code-zh.md)
- [platform-adapters/codex-openai-zh.md](platform-adapters/codex-openai-zh.md)
- [platform-adapters/cursor-zh.md](platform-adapters/cursor-zh.md)
- [platform-adapters/opencode-zh.md](platform-adapters/opencode-zh.md)
- [platform-adapters/mcp-recommended-servers-zh.md](platform-adapters/mcp-recommended-servers-zh.md)

## Example Triggers

This skill should trigger on requests like:

- help me design a government or enterprise AI agent solution
- assess whether this government or enterprise workflow really needs AI or an agent
- do discovery before writing the PRD
- turn this government AI scenario into a Product Brief and PRD
- draft the Product Brief, PRD, and Agent Spec for this enterprise AI pilot
