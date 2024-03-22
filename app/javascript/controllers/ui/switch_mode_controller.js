import { Controller } from "@hotwired/stimulus";
import UIToggleController from "./switch_controller.js";

export default class UIToggleModeController extends UIToggleController {
  toggleMode() {
    if (this.element.dataset.state == "checked") {
      this.systemTheme = "dark";
    } else {
      this.systemTheme = "light";
    };
    
    this.setTheme();
    this.toggle();
  }

  setTheme() {
    const root = window.document.documentElement;
    const storageKey = "ui-theme";

    root.classList.remove("light", "dark");
    root.classList.add(this.systemTheme);
    localStorage.setItem(storageKey, this.systemTheme);
  }
}
