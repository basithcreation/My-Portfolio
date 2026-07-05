/**
 * ═══════════════════════════════════════════════
 * db.js — Static data layer (no cloud, no API keys)
 * ═══════════════════════════════════════════════
 *
 * Projects live in js/projects-data.js (loaded before this
 * file). Nothing is fetched from any server, so the published
 * site contains zero credentials.
 *
 * save() regenerates projects-data.js and downloads it —
 * replace the file in js/ and push to publish changes.
 * The admin panel is only shown when the site runs locally.
 * ═══════════════════════════════════════════════
 */

const DB = (() => {

  // Admin password — only gates the local editing UI.
  const ADMIN_PW = 'basith@2025';

  const FILE_HEADER = `/**
 * ═══════════════════════════════════════════════
 * projects-data.js — Single source of truth for projects
 * ═══════════════════════════════════════════════
 *
 * This static file IS the database. No cloud, no API keys.
 *
 * TO ADD / EDIT PROJECTS:
 *   Option A — open the site locally, click "Manage Projects",
 *              edit in the form → an updated copy of this file
 *              downloads automatically → replace this file.
 *   Option B — edit this array by hand (keep the same fields).
 *
 * Then publish:  git add js/projects-data.js
 *                git commit -m "Update projects"
 *                git push
 * GitHub Pages redeploys automatically.
 * ═══════════════════════════════════════════════
 */

const PROJECTS_DATA = `;

  return {

    // ── Read projects (from the static file) ───
    async get() {
      const data = typeof PROJECTS_DATA !== 'undefined' ? PROJECTS_DATA : null;
      return Array.isArray(data) ? [...data] : [];
    },

    // ── Save: download a regenerated projects-data.js ──
    async save(projects) {
      try {
        const content = FILE_HEADER + JSON.stringify(projects, null, 2) + ';\n';
        const blob = new Blob([content], { type: 'text/javascript' });
        const url  = URL.createObjectURL(blob);
        const a    = document.createElement('a');
        a.href = url;
        a.download = 'projects-data.js';
        document.body.appendChild(a);
        a.click();
        a.remove();
        URL.revokeObjectURL(url);
        return { ok: true, reason: 'download' };
      } catch (e) {
        return { ok: false, reason: e.message };
      }
    },

    // ── Helpers ────────────────────────────────
    auth: pw => pw === ADMIN_PW,
    newId: () => 'p' + Date.now().toString(36) + Math.random().toString(36).slice(2,5),
    isLocal: () => location.protocol === 'file:' ||
                   ['localhost', '127.0.0.1'].includes(location.hostname),
  };
})();
