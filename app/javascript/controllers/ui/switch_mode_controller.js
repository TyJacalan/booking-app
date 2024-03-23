import { Controller } from "@hotwired/stimulus";
import UIToggleController from "./switch_controller.js";

export default class UIToggleModeController extends UIToggleController {
  connect() {
    this.root = window.document.documentElement;
    this.storageKey = "ui-theme";
    this.systemTheme = null;
    if(!localStorage.getItem(this.storageKey)) {
      this.systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches? "light" : this.setDark();
    }
  }

  setDark() {
    this.systemTheme = "dark";
    console.log("set dark: ", this.systemTheme);
    this.setTheme(); 
    this.toggle();
  }

  toggleMode() {
    if (this.element.dataset.state == "checked") {
      this.systemTheme = "light";
    } else {
      this.systemTheme = "dark";
    };
    
    this.setTheme();
    this.toggle();
    console.log(this.systemTheme)
  }

  setTheme() {
    this.root.classList.remove("light", "dark");
    this.root.classList.add(this.systemTheme);
    localStorage.setItem(this.storageKey, this.systemTheme);
  }
}
