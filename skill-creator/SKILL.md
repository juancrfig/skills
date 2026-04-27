---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
---

# Skill Creator

Skill for creating new skills and improving them iteratively.

High level, creating skill goes like this:

- Decide what skill should do and roughly how
- Write draft
- Create few test prompts, run assistant-with-skill on them
- Help user evaluate results qualitatively and quantitatively
  - While runs happen in background, draft quantitative evals if none exist (if some exist, use as-is or modify if needed). Explain them to user.
  - Use `eval-viewer/generate_review.py` script to show results, let user see quantitative metrics
- Rewrite skill based on user feedback (and glaring flaws from quantitative benchmarks)
- Repeat until satisfied
- Expand test set, try again at larger scale

Your job: figure out where user is in process, help them progress. Maybe they say "I want skill for X". Help narrow meaning, write draft, write test cases, figure out evaluation, run prompts, repeat.

Or maybe they already have draft. Go straight to eval/iterate loop.

Always stay flexible. If user says "I don't need evaluations, just vibe with me", do that instead.

After skill is done (order flexible), run skill description improver. Separate script optimizes triggering.

Cool? Cool.

## Communicating with user

Skill creator used by people with wide range of coding familiarity. AI assistant power inspires plumbers to open terminals, grandparents to google "how to install npm". But bulk of users probably computer-literate.

Pay attention to context cues to understand phrasing. Default case:

- "evaluation" and "benchmark" borderline, but OK
- For "JSON" and "assertion", wait for serious cues user knows them before using without explanation

OK to briefly explain terms if in doubt. Clarify with short definition if unsure user will get it.

---

## Creating a skill

### Capture Intent

Start by understanding user intent. Current conversation might already contain workflow user wants to capture (e.g., they say "turn this into skill"). If so, extract answers from conversation history first — tools used, sequence of steps, corrections user made, input/output formats observed. User may need to fill gaps, should confirm before proceeding.

1. What should this skill enable AI assistant to do?
2. When should skill trigger? (what user phrases/contexts)
3. What's expected output format?
4. Set up test cases to verify skill works? Skills with objectively verifiable outputs (file transforms, data extraction, code generation, fixed workflow steps) benefit from test cases. Skills with subjective outputs (writing style, art) often don't need them. Suggest appropriate default based on skill type, let user decide.

### Interview and Research

Proactively ask about edge cases, input/output formats, example files, success criteria, dependencies. Wait to write test prompts until this part ironed out.

Check available MCPs — if useful for research (searching docs, finding similar skills, looking up best practices), research in parallel via subagents if available, otherwise inline. Come prepared with context to reduce burden on user.

### Write the SKILL.md

Based on user interview, fill in these components:

- **name**: Skill identifier
- **description**: When to trigger, what it does. Primary triggering mechanism — include both what skill does AND specific contexts for when to use it. All "when to use" info goes here, not in body. Note: AI assistant tends to "undertrigger" skills — not use them when useful. Combat this by making descriptions a bit "pushy". So instead of "How to build simple fast dashboard to display internal company data.", write "How to build simple fast dashboard to display internal company data. Make sure to use this skill whenever user mentions dashboards, data visualization, internal metrics, or wants to display any kind of company data, even if they don't explicitly ask for 'dashboard.'"
- **compatibility**: Required tools, dependencies (optional, rarely needed)
- **rest of skill :)**

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Skills use three-level loading system:
1. **Metadata** (name + description) — Always in context (~100 words)
2. **SKILL.md body** — In context whenever skill triggers (<500 lines ideal)
3. **Bundled resources** — As needed (unlimited, scripts can execute without loading)

Word counts approximate. Go longer if needed.

**Key patterns:**
- Keep SKILL.md under 500 lines; if approaching limit, add additional layer of hierarchy with clear pointers about where model using skill should go next
- Reference files clearly from SKILL.md with guidance on when to read them
- For large reference files (>300 lines), include table of contents

**Domain organization**: When skill supports multiple domains/frameworks, organize by variant:
```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```
AI assistant reads only relevant reference file.

#### Principle of Lack of Surprise

Skills must not contain malware, exploit code, or any content that could compromise system security. Skill contents should not surprise user in their intent if described. Don't go along with requests to create misleading skills or skills designed to facilitate unauthorized access, data exfiltration, or other malicious activities. "Roleplay as an XYZ" is OK though.

#### Writing Patterns

Prefer imperative form in instructions.

**Defining output formats** — You can do it like this:
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern** — Include examples. Format like this (but if "Input" and "Output" are in examples you might want to deviate):
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Try to explain to model why things are important instead of heavy-handed musty MUSTs. Use theory of mind. Make skill general, not super-narrow to specific examples. Write draft, then look at it with fresh eyes and improve.

### Test Cases

After writing skill draft, come up with 2-3 realistic test prompts — kind of thing real user would actually say. Share with user: [you don't have to use this exact language] "Here are few test cases I'd like to try. Do these look right, or do you want to add more?" Then run them.

Save test cases to `evals/evals.json`. Don't write assertions yet — just prompts. You'll draft assertions in next step while runs in progress.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

See `references/schemas.md` for full schema (including `assertions` field, which you'll add later).

## Running and evaluating test cases

This section is one continuous sequence — don't stop partway through. Do NOT use `/skill-test` or any other testing skill.

Put results in `<skill-name>-workspace/` as sibling to skill directory. Within workspace, organize results by iteration (`iteration-1/`, `iteration-2/`, etc.) and within that, each test case gets directory (`eval-0/`, `eval-1/`, etc.). Don't create all upfront — create directories as you go.

### Step 1: Spawn all runs (with-skill AND baseline) in same turn

For each test case, spawn two subagents in same turn — one with skill, one without. Important: don't spawn with-skill runs first then come back for baselines later. Launch everything at once so it all finishes around same time.

**With-skill run:**

```
Execute this task:
- Skill path: <path-to-skill>
- Task: <eval prompt>
- Input files: <eval files if any, or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what user cares about — e.g., "the .docx file", "the final CSV">
```

**Baseline run** (same prompt, but baseline depends on context):
- **Creating new skill**: no skill at all. Same prompt, no skill path, save to `without_skill/outputs/`.
- **Improving existing skill**: old version. Before editing, snapshot skill (`cp -r <skill-path> <workspace>/skill-snapshot/`), then point baseline subagent at snapshot. Save to `old_skill/outputs/`.

Write `eval_metadata.json` for each test case (assertions can be empty for now). Give each eval descriptive name based on what it's testing — not just "eval-0". Use this name for directory too. If iteration uses new or modified eval prompts, create these files for each new eval directory — don't assume they carry over from previous iterations.

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name-here",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

### Step 2: While runs are in progress, draft assertions

Don't just wait for runs to finish — use this time productively. Draft quantitative assertions for each test case and explain them to user. If assertions already exist in `evals/evals.json`, review them and explain what they check.

Good assertions are objectively verifiable and have descriptive names — they should read clearly in benchmark viewer so someone glancing at results immediately understands what each one checks. Subjective skills (writing style, design quality) are better evaluated qualitatively — don't force assertions onto things that need human judgment.

Update `eval_metadata.json` files and `evals/evals.json` with assertions once drafted. Also explain to user what they'll see in viewer — both qualitative outputs and quantitative benchmark.

### Step 3: As runs complete, capture timing data

When each subagent task completes, you receive notification containing `total_tokens` and `duration_ms`. Save this data immediately to `timing.json` in run directory:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

This is only opportunity to capture this data — it comes through task notification and isn't persisted elsewhere. Process each notification as it arrives rather than trying to batch them.

### Step 4: Grade, aggregate, and launch viewer

Once all runs done:

1. **Grade each run** — spawn grader subagent (or grade inline) that reads `agents/grader.md` and evaluates each assertion against outputs. Save results to `grading.json` in each run directory. The grading.json expectations array must use fields `text`, `passed`, and `evidence` (not `name`/`met`/`details` or other variants) — viewer depends on these exact field names. For assertions that can be checked programmatically, write and run script rather than eyeballing — scripts are faster, more reliable, and can be reused across iterations.

2. **Aggregate into benchmark** — run aggregation script from skill-creator directory:
   ```bash
   python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>
   ```
   This produces `benchmark.json` and `benchmark.md` with pass_rate, time, and tokens for each configuration, with mean ± stddev and delta. If generating benchmark.json manually, see `references/schemas.md` for exact schema viewer expects.
Put each with_skill version before its baseline counterpart.

3. **Do analyst pass** — read benchmark data and surface patterns aggregate stats might hide. See `agents/analyzer.md` (the "Analyzing Benchmark Results" section) for what to look for — things like assertions that always pass regardless of skill (non-discriminating), high-variance evals (possibly flaky), and time/token tradeoffs.

4. **Launch viewer** with both qualitative outputs and quantitative data:
   ```bash
   nohup python <skill-creator-path>/eval-viewer/generate_review.py \
     <workspace>/iteration-N \
     --skill-name "my-skill" \
     --benchmark <workspace>/iteration-N/benchmark.json \
     > /dev/null 2>&1 &
   VIEWER_PID=$!
   ```
   For iteration 2+, also pass `--previous-workspace <workspace>/iteration-<N-1>`.

   **Cowork / headless environments:** If `webbrowser.open()` is not available or environment has no display, use `--static <output_path>` to write standalone HTML file instead of starting server. Feedback will be downloaded as `feedback.json` file when user clicks "Submit All Reviews". After download, copy `feedback.json` into workspace directory for next iteration to pick up.

Note: please use generate_review.py to create viewer; no need to write custom HTML.

5. **Tell user** something like: "I've opened results in your browser. Two tabs — 'Outputs' lets you click through each test case and leave feedback, 'Benchmark' shows quantitative comparison. When done, come back here and let me know."

### What user sees in viewer

"Outputs" tab shows one test case at a time:
- **Prompt**: task that was given
- **Output**: files skill produced, rendered inline where possible
- **Previous Output** (iteration 2+): collapsed section showing last iteration's output
- **Formal Grades** (if grading was run): collapsed section showing assertion pass/fail
- **Feedback**: textbox that auto-saves as they type
- **Previous Feedback** (iteration 2+): their comments from last time, shown below textbox

"Benchmark" tab shows stats summary: pass rates, timing, and token usage for each configuration, with per-eval breakdowns and analyst observations.

Navigation via prev/next buttons or arrow keys. When done, they click "Submit All Reviews" which saves all feedback to `feedback.json`.

### Step 5: Read feedback

When user tells you they're done, read `feedback.json`:

```json
{
  "reviews": [
    {"run_id": "eval-0-with_skill", "feedback": "the chart is missing axis labels", "timestamp": "..."},
    {"run_id": "eval-1-with_skill", "feedback": "", "timestamp": "..."},
    {"run_id": "eval-2-with_skill", "feedback": "perfect, love this", "timestamp": "..."}
  ],
  "status": "complete"
}
```

Empty feedback means user thought it was fine. Focus improvements on test cases where user had specific complaints.

Kill viewer server when done:

```bash
kill $VIEWER_PID 2>/dev/null
```

---

## Improving skill

This is heart of loop. You've run test cases, user reviewed results, now make skill better based on feedback.

### How to think about improvements

1. **Generalize from feedback.** Big picture: create skills usable millions of times across many prompts. You and user iterate on few examples because it moves faster. User knows these examples in and out, quick to assess outputs. But if skill only works for those examples, it's useless. Rather than fiddly overfitty changes or oppressively constrictive MUSTs, if stubborn issue persists, try branching out with different metaphors or recommending different patterns. Relatively cheap to try, maybe you'll land on something great.

2. **Keep prompt lean.** Remove things not pulling their weight. Read transcripts, not just final outputs — if skill makes model waste time doing unproductive things, get rid of parts causing that, see what happens.

3. **Explain why.** Try hard to explain **why** behind everything you ask model to do. LLMs are smart. They have good theory of mind and when given good harness can go beyond rote instructions and really make things happen. Even if user feedback is terse or frustrated, try to actually understand task and why user wrote what they wrote, what they actually wrote, then transmit this understanding into instructions. If you find yourself writing ALWAYS or NEVER in all caps, or using super rigid structures, that's yellow flag — if possible, reframe and explain reasoning so model understands why thing you're asking for is important. More humane, powerful, effective approach.

4. **Look for repeated work across test cases.** Read transcripts from test runs and notice if subagents all independently wrote similar helper scripts or took same multi-step approach to something. If all 3 test cases resulted in subagent writing `create_docx.py` or `build_chart.py`, that's strong signal skill should bundle that script. Write it once, put it in `scripts/`, tell skill to use it. This saves every future invocation from reinventing wheel.

This task matters (we are trying to create billions a year in economic value!) and thinking time is not blocker; take time and mull things over. Write draft revision, then look at it anew and make improvements. Really do best to get into head of user and understand what they want and need.

### Iteration loop

After improving skill:

1. Apply improvements to skill
2. Rerun all test cases into new `iteration-<N+1>/` directory, including baseline runs. If creating new skill, baseline is always `without_skill` (no skill) — stays same across iterations. If improving existing skill, use judgment on what makes sense as baseline: original version user came in with, or previous iteration.
3. Launch reviewer with `--previous-workspace` pointing at previous iteration
4. Wait for user to review and tell you they're done
5. Read new feedback, improve again, repeat

Keep going until:
- User says they're happy
- Feedback is all empty (everything looks good)
- You're not making meaningful progress

---

## Advanced: Blind comparison

For situations where you want more rigorous comparison between two versions of skill (e.g., user asks "is new version actually better?"), there's blind comparison system. Read `agents/comparator.md` and `agents/analyzer.md` for details. Basic idea: give two outputs to independent agent without telling it which is which, let it judge quality. Then analyze why winner won.

This is optional, requires subagents, most users won't need it. Human review loop is usually sufficient.

---

## Description Optimization

Description field in SKILL.md frontmatter is primary mechanism that determines whether AI assistant invokes skill. After creating or improving skill, offer to optimize description for better triggering accuracy.

### Step 1: Generate trigger eval queries

Create 20 eval queries — mix of should-trigger and should-not-trigger. Save as JSON:

```json
[
  {"query": "the user prompt", "should_trigger": true},
  {"query": "another prompt", "should_trigger": false}
]
```

Queries must be realistic and something AI assistant user would actually type. Not abstract requests, but concrete, specific, with good amount of detail. File paths, personal context about user's job or situation, column names and values, company names, URLs. Little backstory. Some might be lowercase, contain abbreviations, typos, casual speech. Use mix of different lengths, focus on edge cases rather than making them clear-cut (user will get chance to sign off on them).

Bad: `"Format this data"`, `"Extract text from PDF"`, `"Create a chart"`

Good: `"ok so my boss just sent me this xlsx file (its in my downloads, called something like 'Q4 sales final FINAL v2.xlsx') and she wants me to add a column that shows the profit margin as a percentage. The revenue is in column C and costs are in column D i think"`

For **should-trigger** queries (8-10), think about coverage. You want different phrasings of same intent — some formal, some casual. Include cases where user doesn't explicitly name skill or file type but clearly needs it. Throw in uncommon use cases and cases where this skill competes with another but should win.

For **should-not-trigger** queries (8-10), most valuable ones are near-misses — queries that share keywords or concepts with skill but actually need something different. Think adjacent domains, ambiguous phrasing where naive keyword match would trigger but shouldn't, and cases where query touches on something skill does but in context where another tool is more appropriate.

Key thing to avoid: don't make should-not-trigger queries obviously irrelevant. "Write fibonacci function" as negative test for PDF skill is too easy — it doesn't test anything. Negative cases should be genuinely tricky.

### Step 2: Review with user

Present eval set to user for review using HTML template:

1. Read template from `assets/eval_review.html`
2. Replace placeholders:
   - `__EVAL_DATA_PLACEHOLDER__` → JSON array of eval items (no quotes around it — it's JS variable assignment)
   - `__SKILL_NAME_PLACEHOLDER__` → skill's name
   - `__SKILL_DESCRIPTION_PLACEHOLDER__` → skill's current description
3. Write to temp file (e.g., `/tmp/eval_review_<skill-name>.html`) and open it: `open /tmp/eval_review_<skill-name>.html`
4. User can edit queries, toggle should-trigger, add/remove entries, then click "Export Eval Set"
5. File downloads to `~/Downloads/eval_set.json` — check Downloads folder for most recent version in case there are multiple (e.g., `eval_set (1).json`)

This step matters — bad eval queries lead to bad descriptions.

### Step 3: Run optimization loop

Tell user: "This will take some time — I'll run optimization loop in background and check on it periodically."

Save eval set to workspace, then run in background:

```bash
python -m scripts.run_loop \
  --eval-set <path-to-trigger-eval.json> \
  --skill-path <path-to-skill> \
  --model <model-id-powering-this-session> \
  --max-iterations 5 \
  --verbose
```

Use model ID from your system prompt (one powering current session) so triggering test matches what user actually experiences.

While it runs, periodically tail output to give user updates on which iteration it's on and what scores look like.

This handles full optimization loop automatically. Splits eval set into 60% train and 40% held-out test, evaluates current description (running each query 3 times to get reliable trigger rate), then calls AI assistant to propose improvements based on what failed. Re-evaluates each new description on both train and test, iterating up to 5 times. When done, opens HTML report in browser showing results per iteration and returns JSON with `best_description` — selected by test score rather than train score to avoid overfitting.

### How skill triggering works

Understanding triggering mechanism helps design better eval queries. Skills appear in AI assistant's `available_skills` list with their name + description, and AI assistant decides whether to consult skill based on that description. Important thing to know: AI assistant only consults skills for tasks it can't easily handle on its own — simple, one-step queries like "read this PDF" may not trigger skill even if description matches perfectly, because AI assistant can handle them directly with basic tools. Complex, multi-step, or specialized queries reliably trigger skills when description matches.

This means eval queries should be substantive enough that AI assistant would actually benefit from consulting skill. Simple queries like "read file X" are poor test cases — they won't trigger skills regardless of description quality.

### Step 4: Apply result

Take `best_description` from JSON output and update skill's SKILL.md frontmatter. Show user before/after and report scores.

---

### Package and Present (only if `present_files` tool is available)

Check whether you have access to `present_files` tool. If you don't, skip this step. If you do, package skill and present .skill file to user:

```bash
python -m scripts.package_skill <path/to/skill-folder>
```

After packaging, direct user to resulting `.skill` file path so they can install it.

---

## Web Interface Instructions

In web interface, core workflow is same (draft → test → review → improve → repeat), but because web interface doesn't have subagents, some mechanics change. Here's what to adapt:

**Running test cases**: No subagents means no parallel execution. For each test case, read skill's SKILL.md, then follow its instructions to accomplish test prompt yourself. Do them one at a time. This is less rigorous than independent subagents (you wrote skill and you're also running it, so you have full context), but it's useful sanity check — and human review step compensates. Skip baseline runs — just use skill to complete task as requested.

**Reviewing results**: If you can't open browser (e.g., web interface's VM has no display, or you're on remote server), skip browser reviewer entirely. Instead, present results directly in conversation. For each test case, show prompt and output. If output is file user needs to see (like .docx or .xlsx), save it to filesystem and tell them where it is so they can download and inspect it. Ask for feedback inline: "How does this look? Anything you'd change?"

**Benchmarking**: Skip quantitative benchmarking — it relies on baseline comparisons which aren't meaningful without subagents. Focus on qualitative feedback from user.

**Iteration loop**: Same as before — improve skill, rerun test cases, ask for feedback — just without browser reviewer in middle. You can still organize results into iteration directories on filesystem if you have one.

**Description optimization**: This section requires CLI tool (specifically `claude -p`) which is only available in terminal environment. Skip it if you're on web interface.

**Blind comparison**: Requires subagents. Skip it.

**Packaging**: `package_skill.py` script works anywhere with Python and filesystem. On web interface, you can run it and user can download resulting `.skill` file.

**Updating existing skill**: User might be asking you to update existing skill, not create new one. In this case:
- **Preserve original name.** Note skill's directory name and `name` frontmatter field — use them unchanged. E.g., if installed skill is `research-helper`, output `research-helper.skill` (not `research-helper-v2`).
- **Copy to writeable location before editing.** Installed skill path may be read-only. Copy to `/tmp/skill-name/`, edit there, and package from copy.
- **If packaging manually, stage in `/tmp/` first**, then copy to output directory — direct writes may fail due to permissions.

---

## Cowork-Specific Instructions

If you're in Cowork, main things to know are:

- You have subagents, so main workflow (spawn test cases in parallel, run baselines, grade, etc.) all works. (However, if you run into severe problems with timeouts, it's OK to run test prompts in series rather than parallel.)
- You don't have browser or display, so when generating eval viewer, use `--static <output_path>` to write standalone HTML file instead of starting server. Then proffer link that user can click to open HTML in their browser.
- For whatever reason, Cowork setup seems to disincline AI assistant from generating eval viewer after running tests, so just to reiterate: whether you're in Cowork or in terminal environment, after running tests, you should always generate eval viewer for human to look at examples before revising skill yourself and trying to make corrections, using `generate_review.py` (not writing your own boutique html code). Sorry in advance but I'm gonna go all caps here: GENERATE EVAL VIEWER *BEFORE* evaluating inputs yourself. You want to get them in front of human ASAP!
- Feedback works differently: since there's no running server, viewer's "Submit All Reviews" button will download `feedback.json` as file. You can then read it from there (you may have to request access first).
- Packaging works — `package_skill.py` just needs Python and filesystem.
- Description optimization (`run_loop.py` / `run_eval.py`) should work in Cowork just fine since it uses `claude -p` via subprocess, not browser, but please save it until you've fully finished making skill and user agrees it's in good shape.
- **Updating existing skill**: User might be asking you to update existing skill, not create new one. Follow update guidance in web interface section above.

---

## Reference files

`agents/` directory contains instructions for specialized subagents. Read them when you need to spawn relevant subagent.

- `agents/grader.md` — How to evaluate assertions against outputs
- `agents/comparator.md` — How to do blind A/B comparison between two outputs
- `agents/analyzer.md` — How to analyze why one version beat another

`references/` directory has additional documentation:
- `references/schemas.md` — JSON structures for evals.json, grading.json, etc.

---

Repeating core loop here for emphasis:

- Figure out what skill is about
- Draft or edit skill
- Run assistant-with-skill on test prompts
- With user, evaluate outputs:
  - Create benchmark.json and run `eval-viewer/generate_review.py` to help user review them
  - Run quantitative evals
- Repeat until you and user are satisfied
- Package final skill and return it to user.

Please add steps to your TodoList, if you have such thing, to make sure you don't forget. If you're in Cowork, please specifically put "Create evals JSON and run `eval-viewer/generate_review.py` so human can review test cases" in your TodoList to make sure it happens.

Good luck!
