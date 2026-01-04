# Prose.md - In-Depth Research and Analysis

## Executive Summary

**Prose** (prose.io) is a web-based content authoring environment for managing GitHub-hosted repositories. It provides a beautifully simple interface for creating, editing, and deleting files directly on GitHub, with special support for Jekyll sites and Markdown content. The project is built with Backbone.js and interacts directly with the GitHub API.

**Repository**: https://github.com/prose/prose
**Live Application**: https://prose.io
**Version**: 1.2.0-alpha.0
**Status**: Community-maintained (looking for new maintainers)
**License**: BSD-3-Clause

---

## What is Prose?

Prose is designed for **CMS-free websites**. Instead of using a traditional Content Management System, users can:
- Edit website content directly on GitHub through a user-friendly interface
- Create, edit, and delete files without touching Git commands
- Preview Markdown content in the site's full layout
- Manage Jekyll sites with advanced features like drafts, translations, and metadata
- Host websites on GitHub Pages or custom servers

---

## Key Features

### Core Capabilities
1. **GitHub Integration**: Direct interaction with GitHub API for file management
2. **Markdown Support**: Syntax highlighting, formatting toolbar, and live previews
3. **Jekyll-Specific Features**:
   - YAML frontmatter editing
   - Draft management (_drafts folder support)
   - Publish/Unpublish workflow
   - Multilingual page translation support
   - Full site layout previewing

4. **OAuth Authentication**: Secure login via GitHub OAuth
5. **Rich Text Editing**: CodeMirror-based editor with multiple language modes
6. **Media Management**: Upload and manage images and other assets
7. **Metadata Editing**: Visual editors for YAML frontmatter fields
8. **Fork & Pull Request Workflow**: Create patches via automated fork/PR process

---

## Mental Model

### Conceptual Architecture

Prose operates on a hierarchical navigation model:

```
User → Repositories → Repository → Branch → Files → File (Edit/Preview)
```

### User Flow
1. **Authentication**: User logs in via GitHub OAuth
2. **Repository Selection**: Browse accessible repositories
3. **Branch Selection**: Choose a branch to work on
4. **File Navigation**: Browse directory structure
5. **File Editing**: Edit content with metadata and rich text support
6. **Commit Changes**: Save changes directly to GitHub with commit messages

### Key Mental Models

#### 1. **File as a Document**
Every file is treated as a document with:
- **Content**: The actual file content
- **Metadata**: YAML frontmatter (for Jekyll sites)
- **Path**: Location in the repository
- **State**: New, modified, or unchanged

#### 2. **Branch-Aware Editing**
All operations are scoped to a specific branch:
- Each branch has its own file collection
- Changes are committed to the active branch
- Supports branch switching without losing context

#### 3. **Configuration-Driven Behavior**
Repositories can configure Prose behavior via `_prose.yml` or `_config.yml`:
- Define metadata fields
- Set root directories
- Configure media upload locations
- Specify files to ignore

#### 4. **Direct GitHub API Communication**
No backend server - the browser app communicates directly with GitHub:
- All file operations are GitHub API calls
- OAuth token stored in cookies
- Real-time sync with repository state

---

## Technical Architecture

### Technology Stack

**Frontend Framework**:
- **Backbone.js**: MVC framework for application structure
- **jQuery**: DOM manipulation and AJAX
- **Underscore.js**: Utility functions

**UI Components**:
- **CodeMirror**: Syntax-highlighted code editor (supports Markdown, YAML, JavaScript, Ruby, HTML, CSS, etc.)
- **Handsontable**: Spreadsheet-like table editing
- **Chosen**: Enhanced select dropdowns
- **Marked**: Markdown parsing and rendering

**Data Handling**:
- **js-yaml**: YAML parsing and serialization
- **js-base64**: Base64 encoding/decoding for GitHub API
- **PapaParse**: CSV parsing
- **diff**: Text diffing for change visualization

**Build Tools**:
- **Browserify**: Module bundler
- **Gulp**: Task runner
- **PostCSS**: CSS processing

### Codebase Structure

```
prose/
├── app/                      # Main application code
│   ├── boot.js              # Application bootstrap & initialization
│   ├── router.js            # Backbone router - URL routing logic
│   ├── config.js            # OAuth and API configuration
│   ├── util.js              # Utility functions
│   ├── cookie.js            # Cookie management
│   ├── status.js            # GitHub API status checks
│   ├── upload.js            # File upload handling
│   │
│   ├── models/              # Backbone models (data layer)
│   │   ├── user.js          # User model
│   │   ├── repo.js          # Repository model
│   │   ├── branch.js        # Branch model
│   │   ├── file.js          # File model (core editing logic)
│   │   ├── folder.js        # Folder model
│   │   ├── commit.js        # Commit model
│   │   └── org.js           # Organization model
│   │
│   ├── collections/         # Backbone collections
│   │   ├── users.js         # User collection
│   │   ├── repos.js         # Repository collection
│   │   ├── branches.js      # Branch collection
│   │   ├── files.js         # File collection
│   │   ├── commits.js       # Commit history
│   │   └── orgs.js          # Organizations
│   │
│   ├── views/               # Backbone views (UI layer)
│   │   ├── app.js           # Main application view
│   │   ├── file.js          # File editing view (core editor)
│   │   ├── files.js         # File listing view
│   │   ├── metadata.js      # Metadata editing view
│   │   ├── toolbar.js       # Editing toolbar
│   │   ├── header.js        # Application header
│   │   ├── sidebar.js       # Navigation sidebar
│   │   ├── modal.js         # Modal dialogs
│   │   ├── notification.js  # Error/notification display
│   │   ├── repo.js          # Repository view
│   │   ├── repos.js         # Repository listing
│   │   ├── profile.js       # User profile
│   │   ├── start.js         # Landing page
│   │   │
│   │   ├── meta/            # Metadata field editors
│   │   │   ├── text.js      # Text input
│   │   │   ├── textarea.js  # Multi-line text
│   │   │   ├── select.js    # Dropdown select
│   │   │   ├── multiselect.js # Multi-select
│   │   │   ├── checkbox.js  # Checkbox
│   │   │   ├── button.js    # Button
│   │   │   └── image.js     # Image upload
│   │   │
│   │   ├── sidebar/         # Sidebar components
│   │   │   ├── save.js      # Save/commit interface
│   │   │   ├── settings.js  # File settings
│   │   │   ├── branch.js    # Branch selector
│   │   │   ├── branches.js  # Branch list
│   │   │   ├── history.js   # Commit history
│   │   │   ├── drafts.js    # Draft management
│   │   │   └── orgs.js      # Organization switcher
│   │   │
│   │   └── li/              # List item components
│   │       ├── file.js      # File list item
│   │       ├── folder.js    # Folder list item
│   │       └── repo.js      # Repository list item
│   │
│   └── toolbar/             # Toolbar components
│       └── markdown.js      # Markdown toolbar buttons
│
├── templates/               # HTML templates (Underscore templates)
├── translations/            # Internationalization files
├── style/                   # CSS/styling
├── test/                    # Test suite
│   ├── spec/                # Test specifications
│   ├── fixtures/            # Test fixtures
│   └── mocks/               # Mock data
├── vendor/                  # Third-party libraries
├── dist/                    # Compiled/built files
├── index.html              # Application entry point
├── package.json            # NPM dependencies
└── gulpfile.js             # Build configuration
```

---

## Core Constructs

### 1. Models

Models represent data entities and encapsulate business logic:

#### **File Model** (`app/models/file.js`)
The most critical model - handles all file operations:

**Key Properties**:
- `path`: File path in repository
- `content`: File content (decoded)
- `metadata`: Parsed YAML frontmatter
- `sha`: Git SHA (for versioning)
- `branch`: Associated branch
- `extension`: File extension
- `markdown`: Boolean - is it markdown?
- `binary`: Boolean - is it binary?
- `writable`: Boolean - can user write?

**Key Methods**:
- `fetch()`: Load file from GitHub API
- `getContent()`: Fetch file content
- `save()`: Commit changes to GitHub
- `destroy()`: Delete file
- `patch()`: Create fork + PR for suggested changes
- `serialize()`: Combine metadata + content for saving
- `parseContent()`: Extract YAML frontmatter from content
- `encode()/decode()`: Base64 encoding for GitHub API

**YAML Frontmatter Parsing**:
```javascript
// Extracts metadata from content like:
// ---
// title: My Post
// layout: post
// ---
// Content here...
```

#### **Repo Model** (`app/models/repo.js`)
Represents a GitHub repository:

**Key Properties**:
- `name`: Repository name
- `owner`: Owner login
- `default_branch`: Default branch name
- `permissions`: User permissions (push, pull, admin)
- `private`: Is repo private?

**Key Methods**:
- `fork()`: Create repository fork
- `ref()`: Create Git reference (for branches)

**Nested Collections**:
- `branches`: Collection of branches
- `commits`: Collection of commits

#### **Branch Model** (`app/models/branch.js`)
Represents a Git branch with associated files.

#### **User Model** (`app/models/user.js`)
Authenticated user with access to repositories.

### 2. Collections

Collections manage groups of models:

- **Files Collection**: All files in a branch
- **Branches Collection**: All branches in a repo
- **Repos Collection**: All repos accessible to user
- **Commits Collection**: Commit history for a branch

### 3. Views

Views handle UI rendering and user interactions:

#### **File View** (`app/views/file.js`)
The main editor interface - most complex view:

**Responsibilities**:
- Initialize CodeMirror editor
- Render metadata editors
- Handle file saving
- Show diff before commit
- Manage editor state (dirty checking)
- Handle translations
- Process drafts

**Key Events**:
- `edit`: Switch to edit mode
- `preview`: Switch to preview mode
- `save`: Show commit dialog
- `destroy`: Delete file
- `translate`: Create translation

#### **Metadata View** (`app/views/metadata.js`)
Dynamically generates form fields based on configuration:

**Supports**:
- Text inputs
- Textareas
- Select dropdowns
- Multi-selects
- Checkboxes
- Date pickers
- Image uploads

**Configuration-Driven**: Fields defined in `_prose.yml`

#### **Toolbar View** (`app/views/toolbar.js`)
Markdown formatting toolbar with buttons for:
- Bold, italic, link, image
- Headers, lists, code blocks
- Preview toggle

### 4. Router

**Backbone Router** (`app/router.js`) - URL-based navigation:

**Routes**:
```javascript
routes: {
  'about': 'about',                    // About page
  'chooselanguage': 'chooseLanguage',  // Language picker
  ':user': 'profile',                  // User profile /:user
  ':user/:repo': 'repo',               // Repository /:user/:repo
  ':user/:repo/*path': 'path',         // File/folder /:user/:repo/tree/branch/path
  '*default': 'start'                  // Landing page
}
```

**Path Parsing**:
```
/:user/:repo/edit/:branch/:path    → Edit file
/:user/:repo/new/:branch/:path     → New file
/:user/:repo/preview/:branch/:path → Preview file
/:user/:repo/tree/:branch/:path    → Browse folder
```

### 5. Configuration System

Prose can be configured per repository via `_prose.yml` or in Jekyll's `_config.yml`:

**Example Configuration**:
```yaml
prose:
  # Root directory for content
  rooturl: '_posts'

  # Site URL for previews
  siteurl: 'http://example.com'

  # Media upload directory
  media: 'media/uploads'

  # Files to hide from Prose
  ignore:
    - index.md
    - _config.yml
    - /.*/  # Ignore dotfiles

  # Metadata field definitions
  metadata:
    _posts:  # Apply to _posts directory
      - name: "layout"
        field:
          element: "hidden"
          value: "post"
      - name: "title"
        field:
          element: "text"
          label: "Title"
          placeholder: "Enter title"
      - name: "category"
        field:
          element: "select"
          label: "Category"
          options:
            - name: "News"
              value: "news"
            - name: "Tutorial"
              value: "tutorial"
      - name: "published"
        field:
          element: "checkbox"
          label: "Published"
          value: true
```

**Configuration Options**:

| Option | Type | Description |
|--------|------|-------------|
| `rooturl` | String | Root directory for content editing |
| `siteurl` | String | Base URL for preview rendering |
| `media` | String | Directory for uploaded media files |
| `ignore` | Array | Files/patterns to exclude from Prose |
| `metadata` | Object | Field definitions per directory |
| `relativeLinks` | String | Path to JSONP file with internal links |

**Metadata Field Types**:
- `text`: Single-line text input
- `textarea`: Multi-line text area
- `select`: Dropdown menu
- `multiselect`: Multi-select dropdown
- `checkbox`: Boolean checkbox
- `button`: Action button
- `number`: Numeric input
- `date`: Date picker
- `hidden`: Hidden field with default value

---

## Data Flow

### File Editing Flow

```
1. User clicks file → Router navigates to /:user/:repo/edit/:branch/:path
                      ↓
2. Router initializes FileView
                      ↓
3. FileView fetches:
   - Branches collection
   - Files collection for branch
   - File model (if editing existing)
                      ↓
4. File.fetch() → GitHub API: GET /repos/:owner/:repo/contents/:path?ref=:branch
                      ↓
5. Response includes:
   - File metadata (sha, size, etc.)
   - Base64-encoded content
                      ↓
6. File.getContent() → GitHub API: GET (content_url) with Accept: application/vnd.github.v3.raw
                      ↓
7. File.parseContent() extracts YAML frontmatter:
   - Metadata → MetadataView
   - Content → CodeMirror editor
                      ↓
8. User edits in CodeMirror + MetadataView
                      ↓
9. User clicks Save → Show diff modal
                      ↓
10. User enters commit message → File.save()
                      ↓
11. File.serialize() combines metadata + content:
    ---
    [YAML frontmatter]
    ---
    [Content]
                      ↓
12. File.toJSON() → GitHub API: PUT /repos/:owner/:repo/contents/:path
    {
      "path": "...",
      "message": "commit message",
      "content": "[base64 encoded]",
      "sha": "...",
      "branch": "..."
    }
                      ↓
13. Success → Update File model → Navigate to preview/file list
```

### Authentication Flow

```
1. User visits prose.io
              ↓
2. boot.js → user.authenticate()
              ↓
3. Check for OAuth token in cookies
              ↓
   Has token? → Validate with GitHub API
   |             ↓
   |          Valid? → Initialize router with user
   |             ↓
   |          Invalid? → Show login screen
   ↓
4. No token → Show Start view with "Authorize on GitHub" button
              ↓
5. User clicks authorize → Redirect to GitHub OAuth:
   https://github.com/login/oauth/authorize?client_id=...&scope=repo
              ↓
6. User authorizes → GitHub redirects back with code
              ↓
7. Exchange code for token via Gatekeeper (OAuth proxy)
              ↓
8. Store token in cookie
              ↓
9. Set AJAX headers: Authorization: token [oauth-token]
              ↓
10. All subsequent GitHub API requests use this token
```

### Fork & Pull Request Flow (Patch)

For users without write access:

```
1. User edits file → Clicks save
                     ↓
2. File.patch() checks permissions
                     ↓
3. No write access → Fork repository
                     ↓
4. Repo.fork() → GitHub API: POST /repos/:owner/:repo/forks
                     ↓
5. Create branch in fork: "prose-patch-1"
                     ↓
6. Repo.ref() → GitHub API: POST /repos/:owner/:repo/git/refs
   {
     "ref": "refs/heads/prose-patch-1",
     "sha": "[original branch SHA]"
   }
                     ↓
7. Create new File model in forked repo
                     ↓
8. File.save() → Commit to forked branch
                     ↓
9. Create pull request:
   GitHub API: POST /repos/:owner/:repo/pulls
   {
     "title": "[commit message]",
     "body": "This PR was automatically generated by prose.io",
     "base": "[original branch]",
     "head": "[fork owner]:prose-patch-1"
   }
                     ↓
10. Success → Show PR URL to user
```

---

## Utility Functions

Key helpers in `app/util.js`:

### Path Manipulation
- `extractFilename(path)`: Split path into directory + filename
- `extractURL(url)`: Parse Prose URL into mode/branch/path
- `parentPath(path)`: Get parent directory
- `chunkedPath(path)`: Create breadcrumb navigation data

### File Type Detection
- `isMarkdown(ext)`: Check if markdown file
- `isBinary(path)`: Check if binary file
- `isMedia(ext)`: Check if media file
- `extension(file)`: Extract file extension
- `mode(ext)`: Determine CodeMirror syntax mode

### Content Processing
- `hasMetadata(content)`: Check for YAML frontmatter
- `extractDate(filename)`: Extract Jekyll date (YYYY-MM-DD)
- `stringToUrl(string)`: Convert string to URL-safe slug
- `draft(path)`: Check if file is in _drafts

### Metadata Helpers
- `extractMedia(config, collection)`: Find media files
- `validPathname(path)`: Validate file path

---

## Advanced Features

### 1. Draft Management
Files in `_drafts` folder:
- Not published to live site
- Can be moved to `_posts` to publish
- Detected via `util.draft(path)`

### 2. Translation Support
Create translated versions of posts:
- Copy file with language suffix
- Maintain metadata links
- Configure via `_prose.yml`

### 3. Media Upload
- Drag-and-drop image upload
- Automatic Base64 encoding
- Configurable upload directory
- Image preview in metadata fields

### 4. Syntax Highlighting
CodeMirror modes for:
- Markdown (GFM flavor)
- YAML
- JavaScript/JSON
- HTML
- CSS
- Ruby
- C-like languages (Java, C++, C#, PHP)
- XML

### 5. Live Preview
- Renders Markdown using `marked`
- Shows content in site layout (if configured)
- Side-by-side edit/preview mode

### 6. Diff Visualization
Before committing:
- Show side-by-side or unified diff
- Uses `diff` library
- Highlight additions/deletions
- Prevent accidental overwrites

### 7. Session Persistence
- Auto-save to sessionStorage
- Restore on page reload
- Prevent data loss
- Warn before leaving with unsaved changes

---

## Security & Permissions

### Authentication
- GitHub OAuth 2.0
- Scopes: `repo` (full repository access) or `public_repo`
- Token stored in httpOnly cookie
- All API requests use OAuth token

### Authorization
- Respects GitHub repository permissions
- Read-only users → Fork + PR workflow
- Write access → Direct commits
- Private repos require authentication

### Data Handling
- No server-side processing
- Direct browser ↔ GitHub API communication
- No data stored on Prose servers
- Stateless architecture

---

## Deployment

### Hosted Version
- Available at https://prose.io
- Maintained by community
- Free to use
- Requires GitHub account

### Self-Hosted
1. Clone repository
2. Configure OAuth application in GitHub settings
3. Create `oauth.json` with credentials:
   ```json
   {
     "clientId": "YOUR_CLIENT_ID",
     "gatekeeperUrl": "YOUR_GATEKEEPER_URL",
     "api": "https://api.github.com",
     "site": "https://github.com"
   }
   ```
4. Build: `npm run build`
5. Deploy to static hosting (GitHub Pages, Netlify, etc.)

### Gatekeeper Requirement
OAuth token exchange requires a server-side proxy ("Gatekeeper"):
- Prevents exposing client secret in browser
- Exchanges OAuth code for access token
- Open-source: https://github.com/prose/gatekeeper

---

## Limitations & Considerations

### Known Limitations
1. **Large Files**: Not suitable for files >1MB (GitHub API limitation)
2. **Binary Files**: Limited support for binary file editing
3. **Merge Conflicts**: No conflict resolution UI
4. **Collaborative Editing**: No real-time collaboration
5. **GitHub Only**: Requires GitHub (no GitLab, Bitbucket support)
6. **Browser Compatibility**: Requires modern browser with CORS support

### Best Practices
1. Use for text-based content (Markdown, HTML, etc.)
2. Configure `_prose.yml` for better UX
3. Keep files reasonably sized
4. Use branches for major changes
5. Regular commits with descriptive messages

---

## Testing

Test suite uses:
- **Mocha**: Test framework
- **Chai**: Assertion library
- **Sinon**: Mocking/stubbing

Test structure:
```
test/
├── spec/
│   ├── collections/    # Collection tests
│   ├── views/          # View tests
│   ├── vendor/         # Library integration tests
│   └── router.js       # Router tests
├── fixtures/           # Test data
└── mocks/              # Mock GitHub API responses
```

Run tests: `npm test`

---

## Development Setup

```bash
# Clone repository
git clone https://github.com/prose/prose.git
cd prose

# Install dependencies
npm install

# Create OAuth config
cp oauth.example.json oauth.json
# Edit oauth.json with your credentials

# Start development server
npm start
# Opens on http://localhost:3000

# Run tests
npm test

# Build for production
npm run build
```

---

## Key Takeaways

### Mental Model Summary

**Prose is:**
1. A **GitHub-native CMS** - treats repositories as content databases
2. A **static file editor** - no server-side processing
3. **Configuration-driven** - behavior customized via YAML config
4. **Jekyll-aware** - understands Jekyll conventions and YAML frontmatter
5. **Browser-based** - entire app runs in browser

**Core Concepts:**
- **Repository**: Your content database
- **Branch**: A version of your content
- **File**: A document with optional metadata
- **Metadata**: YAML frontmatter for structured data
- **Collection**: Group of files (e.g., _posts)
- **Configuration**: Rules for how Prose behaves

**Workflow:**
```
Login → Select Repo → Choose Branch → Navigate Files → Edit Content → Commit Changes
```

### Architecture Patterns

1. **MVC with Backbone.js**
   - Models: Data and business logic
   - Views: UI and user interactions
   - Router: URL-based navigation

2. **RESTful GitHub API**
   - Files are resources
   - CRUD operations via HTTP
   - OAuth for authentication

3. **Client-Side Only**
   - No backend server
   - Stateless operation
   - Direct API communication

4. **Configuration Over Code**
   - Behavior customized via YAML
   - No code changes needed for customization
   - Per-repository settings

5. **Progressive Enhancement**
   - Core editing without configuration
   - Enhanced features with proper setup
   - Graceful degradation

---

## Resources

### Documentation
- Main repo: https://github.com/prose/prose
- Wiki: https://github.com/prose/prose/wiki
- Getting Started: https://github.com/prose/prose/wiki/Getting-Started
- Configuration Guide: https://github.com/prose/prose/wiki/Prose-Configuration

### Related Projects
- Gatekeeper (OAuth proxy): https://github.com/prose/gatekeeper
- Jekyll: https://jekyllrb.com/
- GitHub Pages: https://pages.github.com/

### Community
- GitHub Issues: https://github.com/prose/prose/issues
- IRC: #prose on Freenode

---

## Conclusion

Prose.md represents an elegant solution to the "CMS-free" website movement. By leveraging GitHub as a content backend and providing a user-friendly editing interface, it enables non-technical users to manage content on static websites without sacrificing the benefits of Git version control.

The architecture is a testament to the power of client-side applications and REST APIs. With no server-side logic, Prose achieves remarkable functionality through clever use of:
- GitHub's comprehensive API
- Browser-based text processing
- YAML-based configuration
- Modern JavaScript frameworks

For developers building content-driven static sites, Prose offers:
- Low operational overhead (no database, no CMS server)
- Git-based version control for all content
- Customizable editing experience
- Free hosting via GitHub Pages
- Strong security model (GitHub's authentication)

The codebase demonstrates solid software engineering practices with clear separation of concerns, comprehensive testing, and modular architecture. While the project is looking for new maintainers, it remains a valuable tool and reference implementation for GitHub-based content management.

---

**Research Compiled By**: Claude Code
**Date**: 2026-01-04
**Repository Analyzed**: prose/prose @ master branch
**Lines of Code Reviewed**: ~15,000+ (JavaScript, HTML, CSS, documentation)
