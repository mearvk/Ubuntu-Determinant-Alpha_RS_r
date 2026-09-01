// Ubuntu White Edition Panel extension.
//
// Behavior contract:
//   - The Start BUTTON is always placed at the bottom-left of the panel and
//     never moves. It is inserted at the left box, position 0, unconditionally.
//   - Only the Start MENU POPUP's horizontal anchoring changes, driven by the
//     start-menu-alignment GSettings key (left | center | right).
//   - The button glyph is chosen from three bundled logos via start-button-logo.
//
// This layer is additive and reversible: enable() creates one PanelMenu.Button
// and connects setting handlers; disable() destroys the button and clears state.

import GObject from 'gi://GObject';
import Gio from 'gi://Gio';
import St from 'gi://St';
import Clutter from 'gi://Clutter';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const StartButton = GObject.registerClass(
class StartButton extends PanelMenu.Button {
    _init(extension) {
        // menuAlignment 0.0 keeps the boxpointer arrow at the left edge of the
        // button; the White Edition alignment logic below repositions the popup
        // horizontally after that default is applied.
        super._init(0.0, 'Ubuntu White Edition Start', false);

        this._extension = extension;
        this._settings = extension.getSettings();

        this.add_style_class_name('we-start-button');

        this._icon = new St.Icon({
            style_class: 'we-start-icon',
            icon_size: 24,
        });
        this.add_child(this._icon);
        this._reloadLogo();

        // Populate the Start menu popup. Content is intentionally minimal here;
        // the White Edition Start menu items are layered on top of this popup.
        this.menu.addMenuItem(
            new PopupMenu.PopupMenuItem('Ubuntu White Edition'));
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
        this.menu.addMenuItem(
            new PopupMenu.PopupMenuItem('Activities Overview')).connect(
            'activate', () => Main.overview.toggle());

        // Reposition the popup each time it opens so the alignment always
        // reflects the current setting and the current monitor geometry.
        this._openStateId = this.menu.connect('open-state-changed',
            (_menu, isOpen) => {
                if (isOpen)
                    this._applyMenuAlignment();
            });

        // Read the alignment key so the setting is observed at build time and
        // whenever it changes. The Start button position never depends on it.
        this._alignmentChangedId = this._settings.connect(
            'changed::start-menu-alignment', () => {
                if (this.menu.isOpen)
                    this._applyMenuAlignment();
            });

        this._logoChangedId = this._settings.connect(
            'changed::start-button-logo', () => this._reloadLogo());
    }

    _reloadLogo() {
        // start-button-logo selects which bundled SVG is drawn on the button.
        const logo = this._settings.get_string('start-button-logo');
        const path = this._extension.dir
            .get_child('logos')
            .get_child(`${logo}.svg`)
            .get_path();
        this._icon.set_gicon(Gio.icon_new_for_string(path));
    }

    _applyMenuAlignment() {
        // Only the popup moves. start-menu-alignment picks the horizontal
        // anchor of the boxpointer over the primary monitor work area.
        //
        // NOTE: live popup repositioning depends on GNOME Shell BoxPointer
        // internals (_boxPointer, setArrowOrigin, work-area geometry) that
        // cannot be exercised in this sandbox because there is no running
        // Shell. The geometry math below is applied against the primary
        // monitor work area and clamped to it.
        const alignment = this._settings.get_string('start-menu-alignment');
        const boxPointer = this.menu._boxPointer;
        if (!boxPointer)
            return;

        const monitor = Main.layoutManager.primaryMonitor;
        if (!monitor)
            return;

        const workArea = Main.layoutManager.getWorkAreaForMonitor(
            Main.layoutManager.primaryIndex);
        const actor = boxPointer;
        const [, natWidth] = actor.get_preferred_width(-1);
        const menuWidth = natWidth > 0 ? natWidth : actor.width;

        let targetX;
        switch (alignment) {
        case 'center':
            targetX = workArea.x + Math.floor((workArea.width - menuWidth) / 2);
            break;
        case 'right':
            targetX = workArea.x + workArea.width - menuWidth;
            break;
        case 'left':
        default:
            // Left keeps the popup near the Start button at the left edge.
            targetX = workArea.x;
            break;
        }

        // Clamp so the popup never spills off the monitor work area.
        const maxX = workArea.x + Math.max(0, workArea.width - menuWidth);
        targetX = Math.max(workArea.x, Math.min(targetX, maxX));

        // setArrowOrigin/x adjustment nudges the boxpointer horizontally while
        // leaving the source button (the Start button) untouched.
        actor.setArrowOrigin(Clutter.Gravity.SOUTH_WEST);
        actor.set_x(targetX);
    }

    destroyButton() {
        if (this._openStateId) {
            this.menu.disconnect(this._openStateId);
            this._openStateId = 0;
        }
        if (this._alignmentChangedId) {
            this._settings.disconnect(this._alignmentChangedId);
            this._alignmentChangedId = 0;
        }
        if (this._logoChangedId) {
            this._settings.disconnect(this._logoChangedId);
            this._logoChangedId = 0;
        }
        this._settings = null;
        this.destroy();
    }
});

export default class WhiteEditionPanelExtension extends Extension {
    enable() {
        this._button = new StartButton(this);

        // Always add the Start button to the panel LEFT box at position 0 so it
        // is fixed at the bottom-left of the panel regardless of the configured
        // Start menu alignment. Alignment only affects the popup, never this.
        Main.panel.addToStatusArea(this.uuid, this._button, 0, 'left');
    }

    disable() {
        if (this._button) {
            this._button.destroyButton();
            this._button = null;
        }
    }
}
