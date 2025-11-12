This is an advanced configuration scenario, as the options t\_Co and termguicolors are critical for color handling and can conflict with older terminal settings.  
The most reliable order for these eight components focuses on setting the terminal capabilities **first**, then the color scheme environment, and finally applying syntax and custom rules.  
---

## **⚙️ Recommended Vimscript Order (Expanded)**

The best practice order is as follows:

1. **Terminal Color Settings (Highest Priority)**  
2. **Syntax Engine Control**  
3. **Color Environment Setup**  
4. **Custom Syntax Rules**

| Order | Command | Rationale |
| :---- | :---- | :---- |
| **1** | set t\_Co= | **Disables terminal color detection.** Must be done early to prevent Vim from auto-detecting terminal capabilities that might interfere with modern color setups. |
| **2** | set termguicolors | **Enables true color (24-bit) support.** This is the most crucial step for modern color schemes. It must be set *before* the color scheme loads. |
| **3** | syntax on | Enables the syntax highlighting engine. |
| **4** | syntax clear | Resets any existing syntax groups to ensure a clean slate before defining new rules. |
| **5** | set background=dark | Informs Vim of the physical background. This should come before the colorscheme if the scheme uses this value to initialize. |
| **6** | colorscheme default | Loads the color scheme. This applies all standard colors and may override \&background and the terminal color settings (if the scheme is poorly written). |
| **7** | Custom 'syntax match' Statements | Defines your custom syntax rules and applies specific highlight groups based on the colors established in step 6\. |
| **8** | syntax sync | Defines how Vim should start parsing after skipping large sections of text. It goes last, after all patterns have been defined. |

---

## **🌈 Why t\_Co and termguicolors Go First**

* **set t\_Co=**: Setting this to an empty string effectively **disables Vim's default guess** at your terminal's maximum number of colors (e.g., t\_Co=256). This prevents it from forcing a limited palette, which is necessary if you intend to use 24-bit true color.  
* **set termguicolors**: This command tells Vim to use the guifg and guibg definitions for terminal colors, not just the older ctermfg/ctermbg. This enables **true color support (millions of colors)** and **must** be set before a color scheme is loaded for the scheme to detect and use it correctly.

By the way, to unlock the full functionality of all Apps, enable [Gemini Apps Activity](https://myactivity.google.com/product/
