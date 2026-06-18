# bakemyweb Commands Reference

`bakemyweb` is a command-line tool for managing and deploying projects on bakemyweb.com.

## Global Flags

These flags are available on all commands:

*   `--name`, `-n`: Specify the credential name to use (default: `default`).
*   `--help`, `-h`: Show help for any command.
*   `--version`: Show the application version.

---

## Commands

### `version`
Prints the version number of `bakemyweb`.

**Aliases:** `v`

**Example:**
```bash
bakemyweb version
# or
bakemyweb v
```

---

### `auth`
Displays the currently selected API credential and name for bakemyweb.

**Note:** The CLI automatically handles expired sessions. If an API request fails with a `401 Unauthorized` error, it will attempt to refresh your access token using your stored Secret Key without requiring manual intervention.

**Flags:**
*   `--name`, `-n`: The name of the profile to view (default: `default`).

**Example:**
```bash
# View current authentication profile
bakemyweb auth
```

---

### `auth list`
List all the profile has integrated with.

**Example:**
```bash
# List all integrated authentication profiles
bakemyweb auth list
```

---

### `auth validate`
Validates your stored credentials with the bakemyweb.com API and displays account details.

**Flags:**
*   `--name`, `-n`: The name to use for authentication (default: `default`).

**Example:**
```bash
# Validate credentials for the default profile
bakemyweb auth validate

# Validate credentials for a specific profile
bakemyweb auth validate --name production
```

---

### `auth add`
Prompts for and saves a new authentication profile.

**Flags:**
*   `--name`, `-n`: The name of the profile to add or update (default: `default`).

**Example:**
```bash
# Add/Update the default profile
bakemyweb auth add

# Add/Update a specific profile
bakemyweb auth add --name production
```

---

### `auth set-profile`
Sets the specified profile as the default for all subsequent commands.

**Arguments:**
*   `name`: The name of the profile to set as default.

**Example:**
```bash
# Set 'production' as the default profile
bakemyweb auth set-profile production
```

---

### `auth remove`
Deletes a specific authentication profile from your local storage.

**Flags:**
*   `--name`, `-n`: The name of the profile to remove (default: `default`).

**Example:**
```bash
# Remove the default profile
bakemyweb auth remove

# Remove a specific profile
bakemyweb auth remove --name production
```

---

### `content pull`
Download and automatically extract the project pages export, custom scripts, and CSS from bakemyweb.com for the current profile.

After the export ZIP is downloaded and its contents are extracted to the profile's `Local Directory`, the temporary ZIP file is automatically deleted. Custom scripts and CSS are saved to the `__assets__` directory and downloaded into `raw-html/__assets__` for local preview.

**Arguments:**
*   `destination` (optional): The local path where the export ZIP should be saved (default: `{LocalDirectory}/{domainID}-pages.zip`).

**Flags:**
*   `--overwrite`, `-o`: Overwrite existing local files (default: `false`). If not set, existing files will be skipped.
*   `--serve`, `-s`: Start a local server after pulling (default: `false`).

**Example:**
```bash
# Download and extract for the current profile, skipping existing files
bakemyweb content pull

# Download and extract, overwriting existing files
bakemyweb content pull --overwrite

# Download, extract, and start a local server
bakemyweb content pull --serve
```

---

### `content commit`
Sync changes from editable HTML files back to their original Markdown files.

This command takes the content from `.html` files in the `raw-html` directory and updates the body of the corresponding `.md` files in the `content` directory, while preserving the original YAML frontmatter.

**Example:**
```bash
# Sync HTML changes back to Markdown
bakemyweb content commit
```

---

### `content serve`
Start a local development server for previewing your changes.

Starts a local development server using `npx serve` for each `raw-html` root found in the project. The server stays active in the foreground and can be stopped gracefully by pressing `Ctrl+C`.

**Example:**
```bash
# Start local development server
bakemyweb content serve
```

---

### `content status`
View the local modification status of your Markdown files.

This command automatically syncs changes from editable HTML files in `raw-html` back to Markdown files in `content`. It then compares your current Markdown files with the state recorded in `.hashes.json` (from your last `pull` or `commit`) and shows which files have been modified locally.

**Status Symbols:**
*   `✓`: File is unchanged since last sync.
*   `⬆`: File has been updated locally (new, modified, or deleted).

**Example:**
```bash
# View local modification status for Markdown files
bakemyweb content status
```

---

### `content push`
Commit and upload the update ZIP bundle to bakemyweb.com.

This command automatically runs the logic of `content commit` to sync changes from `raw-html` to `content`, creates a `commit-update.zip` file, and then uploads it to the server. After a successful upload, the `commit-update.zip` file is automatically deleted.

**Flags:**
* `--overwrite, -o`: Overwrite existing pages on the server.

**Example:**
```bash
# Sync changes and push to the server
bakemyweb content push

# Sync changes and push with overwrite
bakemyweb content push --overwrite
```

---

### `content publish`
Trigger a site build and deployment on bakemyweb.com.

This command triggers a build and deployment of the site for the current profile. By default, it performs an incremental build.

**Flags:**
* `--incremental, -i`: Trigger an incremental build (default: `true`). Set to `false` for a full build.

**Example:**
```bash
# Trigger an incremental build (default)
bakemyweb content publish

# Trigger an incremental build explicitly
bakemyweb content publish --incremental

# Trigger a full build
bakemyweb content publish --incremental=false
```
