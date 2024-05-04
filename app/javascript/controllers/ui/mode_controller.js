import { Controller } from "@hotwired/stimulus";

export default class UIModeController extends Controller {
  connect() {
  }

  setTheme(theme) {
    const root = window.document.documentElement;

    root.classList.remove("light", "dark", "system");

    if (theme === "system") {
      const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";

      root.classList.add(systemTheme);
      this.setCookie("ui_theme", systemTheme);
    } else {
      root.classList.add(theme);
      this.setCookie("ui_theme", theme);
    }
  }

  light() {
    this.setTheme("light");
    location.reload();
  }

  dark() {
    this.setTheme("dark");
    location.reload();
  }

  system() {
    this.setTheme("system");
    location.reload();
  }

  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }

  setCookie(name, value) {
    document.cookie = `${name}=${value}; path=/`;
  }
}

