# Tally Time Tracker

Tally Time Tracker (or `tally` for short) is a local, simple and small time tracking app which aims to be a local solution to track the activities you do you in your way. Its main focus is in substraction more than in addition in comparison to all the time tracking apps out there. That means:
- Local: all the entries are written in a `sqlite` DB, not remotely. 
- One device at a time: sync the entries in all your devices, you are not going to track multiple activites anyway.
- Terminal: simple interface, out of your way.

## TODO:
- [x] Project setup and dependencies (`zig-sqlite` and `zig-clap`)
- [x] Command line test (print something when calling) and and build system.
- [ ] Design database structure.
- [ ] Small CRUD to database.
- [ ] Functionalities
    + [ ] Create time entry (repetition allowed!).
    + [ ] Delete time entry (with ID's maybe?)
    + [ ] View tracked stuff during a period (day as default, week per week in terminal?)
    + [ ] Modify Time Entry: description, start time, end time, project under.
    + [ ] Create projects.
    + [ ] Create subprojects: a project should have as many subprojects it needs (tree like) and the description should be what you did in the project.
    + [ ] Delete projects: will delete all the entries under that project and all the subprojects under it.
    + [ ] Rename project.
    + [ ] View project (see all the tree).
    + [ ] Report (JSON out?)
- [ ] `syncthing` for DB sync.
- [ ] TUI/GUI 

At least I want to give a program and the functionalites, the last two might not ever happen.

## Time Entry Commands (`entry`)

These commands are for creating and managing individual time entries.

### `start`
Starts a new timer immediately for the given task description.

* **Syntax:** `tally entry start <description>`
* **Options:**
    * `--project <id>`: Assigns the entry to a project.
* **Example:**
    ```bash
    $ tally entry start "Designing the main UI mockups" --project 5
    ```

### `status`
Checks the status of the currently running timer, if any.

* **Syntax:** `tally entry status`
* **Example:**
    ```bash
    $ tally entry status
    > Tracking "Designing the main UI mockups" for 00:25:42
    ```

### `stop`
Stops the currently running timer and saves the final entry to the database.

* **Syntax:** `tally entry stop`
* **Example:**
    ```bash
    $ tally entry stop
    > Timer stopped. Logged 01:15:30 for "Designing the main UI mockups".
    ```

### `log`
Manually adds a completed time entry from the past. This is for when you forget to start a timer.

* **Syntax:** `tally entry log <description>`
* **Options:**
    * `--from <time>`: The start time (e.g., "14:00" or "2025-07-16 14:00").
    * `--to <time>`: The end time.
    * `--project <id>`: The project ID.
* **Example:**
    ```bash
    $ tally entry log "Client feedback meeting" --from "10:30" --to "11:15" --project 2
    ```

### `list`
Lists recent entries, which is crucial for finding the `ID` needed for editing or deleting.

* **Syntax:** `tally entry list`
* **Options:**
    * `--date <YYYY-MM-DD>`: Show entries for a specific day.
    * `--count <number>`: Show the last `N` entries.
* **Example:**
    ```bash
    $ tally entry list --count 3
    > ID | DURATION | PROJECT | DESCRIPTION
    > ---|----------|---------|------------------------------------
    > 21 | 01:15:30 | Tally   | Designing the main UI mockups
    > 20 | 00:45:00 | Tally   | Client feedback meeting
    > 19 | 02:30:15 | Website | Deployed new version to staging
    ```

### `edit`
Modifies an existing time entry identified by its ID.

* **Syntax:** `tally entry edit <entry_id>`
* **Options:**
    * `--desc "<new_text>"`: Change the description.
    * `--project <new_id>`: Move the entry to a different project.
    * `--from <time>` / `--to <time>`: Adjust the times.
* **Example:**
    ```bash
    $ tally entry edit 21 --desc "Designed and finalized UI mockups"
    ```

### `delete`
Permanently removes a time entry.

* **Syntax:** `tally entry delete <entry_id>`
* **Example:**
    ```bash
    $ tally entry delete 19
    ```

---

## Project Commands (`project`)

These commands manage the projects and sub-projects that organize your work.

### `create`
Creates a new project. Use the `--parent` flag to create a sub-project.

* **Syntax:** `tally project create <name>`
* **Options:**
    * `--parent <parent_id>`: The ID of the parent project.
* **Examples:**
    ```bash
    # Create a top-level project
    $ tally project create "NewCo Website"

    # Create a sub-project under the one we just made (assuming its ID is 4)
    $ tally project create "Phase 1: Design" --parent 4
    ```

### `tree`
Displays all projects in a hierarchical tree structure, showing their names and IDs.

* **Syntax:** `tally project tree`
* **Example:**
    ```bash
    $ tally project tree
    > [1] Personal
    > [2] Work
    >   └─ [4] NewCo Website
    >      ├─ [5] Phase 1: Design
    >      └─ [6] Phase 2: Development
    ```

### `rename`
Changes the name of an existing project.

* **Syntax:** `tally project rename <project_id> <new_name>`
* **Example:**
    ```bash
    $ tally project rename 4 "NewCo Website V2"
    ```

### `delete`
Permanently deletes a project. **Warning:** This will also delete all its sub-projects and all time entries associated with them.

* **Syntax:** `tally project delete <project_id>`
* **Example:**
    ```bash
    $ tally project delete 4
    ```

---

## Reporting Commands (`report`)

Generates reports from your tracked time.

### `report`
Aggregates time entries over a period and outputs them. Defaults to a summary for the current week.

* **Syntax:** `tally report`
* **Options:**
    * `--from <date>`: Report start date.
    * `--to <date>`: Report end date.
    * `--format <json|text>`: Output format (defaults to text, JSON is great for scripting).
* **Example:**
    ```bash
    $ tally report --from 2025-07-01 --to 2025-07-31 --format json
    ```
